open Yocaml

(* FIXME: turn me into a First class module *)
module P = Resolver.Make (struct
    let source = Path.rel []
    let target = Path.rel [ "target" ]
  end)

module Blog = struct
  module Model = Model.Blog

  type elt =
    | Dir of Path.t
    | File of (Path.t * Model.t)

  type t =
    { title : string
    ; index : elt list
    }

  let v ~title index = { title; index }

  let is_dir = function
    | Dir _ -> true
    | File _ -> false
  ;;

  let get_model_props_opt props = function
    | Dir _ -> None
    | File (_, model) -> props model
  ;;

  let get_title = function
    | Dir p -> Path.basename p |> Option.get
    | File (_, model) -> Model.title model
  ;;

  let get_url = function
    | Dir p | File (p, _) -> P.truncate p 1 |> Path.abs |> Path.to_string
  ;;

  let normalize_elt elt =
    let open Data in
    let title = get_title elt in
    let url = get_url elt in
    let lang = get_model_props_opt Model.lang elt in
    let has_lang = Option.is_some lang in
    let date = get_model_props_opt (fun model -> Model.date model |> Option.some) elt in
    let has_date = not (is_dir elt) in
    record
      [ "title", string title
      ; "url", string url
      ; "lang", option string lang
      ; "has_lang", bool has_lang
      ; "date", option Archetype.Datetime.normalize date
      ; "has_date", bool has_date
      ]
  ;;

  let normalize t =
    Data.[ "title", string t.title; "index", list_of normalize_elt t.index ]
  ;;

  let fetch path =
    let on = `Source in
    Task.from_effect (fun () ->
      let open Eff in
      let* files = read_directory ~on ~only:`Both ~where:(fun _ -> true) path in
      let f file =
        let* is_dir = is_directory ~on file in
        if is_dir
        then Dir P.(truncate_and_move ~into:Target.root file 1) |> return
        else
          (* We assume it's a file here! *)
          let+ model, _content =
            read_file_with_metadata (module Yocaml_yaml) (module Model) ~on file
          in
          let into = P.(truncate_and_move ~into:Target.root path 2) in
          File (P.Target.as_html_index ~into file, model)
      in
      List.traverse f files)
  ;;

  let compute_index ~title src =
    let open Task in
    (fun () -> (), "") |>> first (fetch src >>> lift (fun index -> v ~title index))
  ;;
end
