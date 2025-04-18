open Yocaml

type 'a file =
  { path : Path.t
  ; content : 'a * string
  }

and ('a, 'b) dir =
  { path : Path.t
  ; children : ('a, 'b) t list
  ; content : ('b * string) option
  }

and ('a, 'b) t =
  | File of 'a file
  | Dir of ('a, 'b) dir

let dir : type a b. ?content:b * string -> ?children:(a, b) t list -> Path.t -> (a, b) t =
  fun ?content ?(children = []) path -> Dir { path; children; content }
;;

let file path content = File { path; content }

let rec leaked_fold
  : type a b c.
    (c -> Path.t -> a * string -> c)
    -> (c -> Path.t -> (b * string) option -> (a, b) t list -> c)
    -> c
    -> (a, b) t
    -> c
  =
  fun ff fd acc tree ->
  match tree with
  | File { path; content } -> ff acc path content
  | Dir { path; children; content } ->
    List.fold_left
      (fun acc tree -> leaked_fold ff fd acc tree)
      (fd acc path content children)
      children
;;

let path = function
  | File { path; _ } -> path
  | Dir { path; _ } -> path
;;

let rec to_sexp tree =
  match tree with
  | File { path; _ } ->
    let s = Format.sprintf "File %s" (Path.to_string path) in
    Sexp.atom s
  | Dir { path; children; content = _ } ->
    let s = Format.sprintf "Dir %s" (Path.to_string path) in
    Sexp.node [ Sexp.atom s; Sexp.node (List.map to_sexp children) ]
;;

let compute
      (type a b)
      (module P : Required.DATA_PROVIDER)
      (module File : Required.DATA_READABLE with type t = a)
      (module Dir : Required.DATA_READABLE with type t = b)
      ~is_section_index
      path
  =
  let rec aux path =
    let open Eff in
    let on = `Source in
    let f path =
      let* is_dir = is_directory ~on path in
      if is_dir
      then aux path
      else
        let+ content = read_file_with_metadata (module P) (module File) ~on path in
        file path content
    in
    let* files = read_directory ~on ~only:`Both ~where:Rule.wildcard path in
    let index = Stdlib.List.find_opt is_section_index files in
    let files = Stdlib.List.filter (fun path -> is_section_index path |> not) files in
    let* children = List.traverse f files in
    let+ content =
      match index with
      | None -> Eff.return Option.none
      | Some path ->
        read_file_with_metadata (module P) (module Dir) ~on path >|= Option.some
    in
    dir ?content ~children path
  in
  aux path
;;

let fetch
      (type a b)
      (module P : Required.DATA_PROVIDER)
      (module D : Required.DATA_READABLE with type t = a)
      (module Dir : Required.DATA_READABLE with type t = b)
      ~is_section_index
      root
  =
  Task.from_effect (fun () ->
    compute (module P) (module D) (module Dir) ~is_section_index root)
;;

let to_action ~dir_to_action ~file_to_action tree cache =
  let ff acc path content = file_to_action path content @ acc in
  let fd acc path content children = dir_to_action path children content @ acc in
  leaked_fold ff fd [] tree |> fun actions -> Utils.process_actions actions cache
;;
