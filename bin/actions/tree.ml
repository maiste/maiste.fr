open Yocaml

type 'a tree =
  | File of { path : Path.t }
  | Dir of
      { path : Path.t
      ; children : 'a tree list
      }

let create path = Dir { path; children = [] }
let file path = File { path }

let add_children tree child =
  match tree with
  | Dir { path; children } -> Dir { path; children = child :: children }
  | File _ -> raise (Invalid_argument "Can't add a children to a File")
;;

let rec relocate f tree =
  match tree with
  | Dir { path; children } ->
    Dir { path = f `Dir path; children = List.map (relocate f) children }
  | File { path } -> File { path = f `File path }
;;

let rec compute path =
  let open Eff in
  let on = `Source in
  let* files = read_directory ~on ~only:`Both ~where:Rule.wildcard path in
  let f path =
    let* is_dir = is_directory ~on path in
    if is_dir then compute path else return (file path)
  in
  let+ children = List.traverse f files in
  Dir { path; children }
;;

let fetch root = Task.from_effect (fun () -> compute root)

(* FIXME: include this into a debug function and add the dump as a unique representation *)

module Debug = struct
  let rec dump tree =
    let open Eff in
    match tree with
    | File { path } as f ->
      let+ () = logf ~level:`App "File %s" (Path.to_string path) in
      f
    | Dir { path; children } as dir ->
      let* () = logf ~level:`Debug "Dir %s" (Path.to_string path) in
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
end

module Executor = struct
  type t =
    | Execute of Action.t
    | Queue of t list

  let rec to_list : t -> Action.t list = function
    | Execute action -> [ action ]
    | Queue actions -> List.map to_list actions |> List.flatten
  ;;
end

let process (module R : S.RESOLVER) root =
  let target = Path.(R.Target.root / "dump") in
  let open Task in
  Action.write_static_file
    target
    (Pipeline.track_file R.Source.binary
     >>> fetch root
     >>> Debug.dump_task ()
     >>> Debug.relocate_task (module R) ()
     >>> Debug.dump_task ()
     >>> lift (fun _ -> "coucou"))
;;
