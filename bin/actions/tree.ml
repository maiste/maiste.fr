open Yocaml

module Tree = struct
  type 'a file =
    { path : Path.t
    ; content : 'a * string
    }

  and ('a, 'b) dir =
    { title : string
    ; path : Path.t
    ; children : ('a, 'b) t list
    ; content : ('b * string) option
    }

  and ('a, 'b) t =
    | File of 'a file
    | Dir of ('a, 'b) dir

  let dir ~title ?content ?(children = []) path = Dir { title; path; children; content }
  let file path content = File { path; content }

  let path = function
    | File { path; _ } -> path
    | Dir { path; _ } -> path
  ;;

  let rec to_sexp tree =
    match tree with
    | File { path; _ } ->
      let s = Format.sprintf "File %s" (Path.to_string path) in
      Sexp.atom s
    | Dir { title; path; children; content = _ } ->
      let s = Format.sprintf "Dir(%s) %s" title (Path.to_string path) in
      Sexp.node [ Sexp.atom s; Sexp.node (List.map to_sexp children) ]
  ;;
end

let compute (type a) (module D : Required.DATA_READABLE with type t = a) path =
  let rec aux path =
    let open Eff in
    let on = `Source in
    let* files = read_directory ~on ~only:`Both ~where:Rule.wildcard path in
    let f path =
      let* is_dir = is_directory ~on path in
      if is_dir
      then aux path
      else
        let+ content = read_file_with_metadata (module Yocaml_yaml) (module D) ~on path in
        Tree.file path content
    in
    let title =
      Path.basename path |> Option.get |> Model.Wiki_section.normalize_dir_title
    in
    let+ children = List.traverse f files in
    Tree.dir ~title ~children path
  in
  aux path
;;

let fetch (type a) (module D : Required.DATA_READABLE with type t = a) root =
  Task.from_effect (fun () -> compute (module D) root)
;;

let to_action ~dir_to_action ~file_to_action tree cache =
  let rec aux = function
    | Tree.File { path; content } -> [ file_to_action path content ]
    | Tree.Dir { title; path; children; content = _ } ->
      let action = dir_to_action ~title path children in
      let actions = List.map aux children |> List.flatten in
      action :: actions
  in
  aux tree |> fun actions -> Utils.process_actions actions cache
;;

module Default (R : S.RESOLVER) = struct
  (* FIXME: generalize me! *)
  let dir_to_action ~title path children =
    let get_index = function
      | Tree.Dir { title; path; _ } ->
        let path = R.truncate path 1 |> Path.abs |> fun p -> Path.(p / "index.html") in
        (* let path = R.truncate path 1 |> Path.abs in *)
        Model.Wiki.v title, path
      | Tree.File { path; content } ->
        let path = R.truncate path 1 |> Path.abs |> R.Target.as_html_index_untouched in
        let metadata, _ = content in
        let title = Model.Wiki.title metadata in
        let description = Model.Wiki.description metadata in
        let lang = Model.Wiki.lang metadata in
        Model.Wiki.v ?description ?lang title, path
    in
    let children = List.map get_index children in
    let wiki_section = Model.Wiki_section.(v ~title children |> sort) in
    let template = wiki_section, "" in
    let path = R.truncate path 1 in
    let path = Path.(R.Target.root ++ path) in
    let path = Path.(path / "index.html") in
    let open Task in
    Action.write_static_file
      path
      (Pipeline.track_file R.Source.binary
       >>> lift (fun () -> template)
       >>> Yocaml_jingoo.Pipeline.as_template
             (module Model.Wiki_section)
             (R.Source.template "wiki.section.html")
       >>> Yocaml_jingoo.Pipeline.as_template
             (module Model.Wiki_section)
             (R.Source.template "base.html")
       >>> drop_first ())
  ;;

  let file_to_action path content =
    let open Task in
    let path = R.truncate path 1 in
    let path = Path.(R.Target.root ++ path) in
    let path = R.Target.as_html_index_untouched path in
    Action.write_static_file
      path
      (Pipeline.track_file R.Source.binary
       >>> lift (fun () -> content)
       >>> Yocaml_cmarkit.content_to_html ()
       >>> Yocaml_jingoo.Pipeline.as_template
             (module Model.Wiki)
             (R.Source.template "wiki.html")
       >>> Yocaml_jingoo.Pipeline.as_template
             (module Model.Wiki)
             (R.Source.template "base.html")
       >>> drop_first ())
  ;;
end

let process (module R : S.RESOLVER) root : Action.t =
  let open Eff in
  let module W = Default (R) in
  fun cache ->
    let* tree = compute (module Model.Wiki) root in
    to_action ~dir_to_action:W.dir_to_action ~file_to_action:W.file_to_action tree cache
;;
