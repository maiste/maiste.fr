open Yocaml

type 'a tree =
  | File of
      { path : Path.t
      ; content : 'a * string
      }
  | Dir of
      { title : string
      ; path : Path.t
      ; children : 'a tree list
      }

let create ~title path = Dir { title; path; children = [] }
let file path content = File { path; content }

let rec to_sexp tree =
  match tree with
  | File { path; _ } ->
    let s = Format.sprintf "File %s" (Path.to_string path) in
    Sexp.atom s
  | Dir { title; path; children } ->
    let s = Format.sprintf "Dir(%s) %s" title (Path.to_string path) in
    Sexp.node [ Sexp.atom s; Sexp.node (List.map to_sexp children) ]
;;

let add_children tree child =
  match tree with
  | Dir { title; path; children } -> Dir { title; path; children = child :: children }
  | File _ -> raise (Invalid_argument "Can't add a children to a File")
;;

let rec relocate f tree =
  match tree with
  | Dir { title; path; children } ->
    Dir { title; path = f `Dir path; children = List.map (relocate f) children }
  | File { path; content } -> File { path = f `File path; content }
;;

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
        file path content
    in
    let title =
      Path.basename path |> Option.get |> Model.Wiki_section.normalize_dir_title
    in
    let+ children = List.traverse f files in
    Dir { title; path; children }
  in
  aux path
;;

let fetch (type a) (module D : Required.DATA_READABLE with type t = a) root =
  Task.from_effect (fun () -> compute (module D) root)
;;

module Debug = struct
  (* FIXME: include this into a debug function and add the dump as a unique representation *)
  let rec dump tree =
    let open Eff in
    match tree with
    | File { path; _ } as f ->
      let+ () = logf ~level:`App "File %s" (Path.to_string path) in
      f
    | Dir { title; path; children } as dir ->
      let* () = logf ~level:`Debug "Dir (%s) %s" title (Path.to_string path) in
      List.traverse dump children >>= fun _ -> return dir
  ;;

  let dump_task () =
    let open Task in
    from_effect dump
  ;;

  let relocate_task (module R : S.RESOLVER) () =
    let f kind path =
      let path = R.truncate path 1 in
      let path = Path.(R.Target.root ++ path) in
      match kind with
      | `File -> R.Target.as_html_index_untouched path
      | `Dir -> Path.(path / "index.html")
    in
    Task.lift (fun tree -> relocate f tree)
  ;;

  let process (module R : S.RESOLVER) root =
    let target = Path.(R.Target.root / "dump") in
    let open Task in
    Action.write_static_file
      target
      (Pipeline.track_file R.Source.binary
       >>> fetch (module Model.Wiki) root
       >>> dump_task ()
       >>> relocate_task (module R) ()
       >>> dump_task ()
       >>> lift (fun tree -> to_sexp tree |> Sexp.to_string))
  ;;
end

module Executor = struct
  type t =
    | Execute of Action.t
    | Queue of t list

  let rec to_list : t -> Action.t list = function
    | Execute action -> [ action ]
    | Queue actions -> List.map to_list actions |> List.flatten
  ;;

  let from_tree ~of_dir ~of_file tree =
    let rec aux = function
      | File { path; content } -> Execute (of_file path content)
      | Dir { title; path; children } ->
        let action = Execute (of_dir ~title path children) in
        let actions = List.map aux children in
        Queue (action :: actions)
    in
    aux tree
  ;;
end

module Default (R : S.RESOLVER) = struct
  (* FIXME: generalize me! *)
  let of_dir ~title path children =
    let get_index = function
      | Dir { title; path; _ } ->
        let path = R.truncate path 1 |> Path.abs in
        Model.Wiki.v title, path
      | File { path; content } ->
        let path = R.truncate path 1 |> Path.abs in
        let metadata, _ = content in
        let title = Model.Wiki.title metadata in
        let description = Model.Wiki.description metadata in
        let lang = Model.Wiki.lang metadata in
        Model.Wiki.v ?description ?lang title, path
    in
    let children = List.map get_index children in
    let wiki_section = Model.Wiki_section.(v ~title children |> sort) in
    let template = wiki_section, "" in
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

  let of_file path content =
    let open Task in
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

(* FIXME: Move to Wiki and generalize me! *)
let process (module R : S.RESOLVER) root : Action.t =
  let open Eff in
  let module W = Default (R) in
  fun cache ->
    let to_target_path kind path =
      let path = R.truncate path 1 in
      let path = Path.(R.Target.root ++ path) in
      match kind with
      | `File -> R.Target.as_html_index_untouched path
      | `Dir -> Path.(path / "index.html")
    in
    let* tree = compute (module Model.Wiki) root in
    let tree = relocate to_target_path tree in
    let executor = Executor.from_tree ~of_dir:W.of_dir ~of_file:W.of_file tree in
    let actions = Executor.to_list executor in
    Utils.process_actions actions cache
;;
