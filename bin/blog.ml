open Core

module Model = struct
  let entity_name = "Blog"

  type t = { title : string; date : Archetype.Datetime.t; lang : string option }

  let title t = t.title
  let date t = t.date
  let lang t = t.lang

  let neutral =
    Data.Validation.fail_with ~given:"null" "Cannot be null"
    |> Result.map_error (fun error ->
           Required.Validation_error { entity = entity_name; error })

  let validate =
    let open Data.Validation in
    record (fun fields ->
        let+ title = required fields "title" string
        and+ date = required fields "date" Archetype.Datetime.validate
        and+ lang = optional fields "lang" string in
        { title; date; lang })

  let normalize t =
    Data.
      [
        ("title", string t.title);
        ("date", Archetype.Datetime.normalize t.date);
        ("lang", option string t.lang);
        ("has_lang", bool @@ Option.is_some t.lang);
      ]
end

module Tree = struct
  let blog = "blog"
  let years = [ "2021"; "2022" ]
  let source year = Path.(Source.Content.root / blog / year)

  let target year file =
    let into = Path.(Target.root / blog / year) in
    Target.with_index_html ~into file

  let index = Path.(Target.root / blog / "index.html")
end

module Index = struct
  type elt = Dir of Path.t | File of (Path.t * Model.t)
  type t = { title : string; index : elt list }

  let v ~title index = { title; index }
  let is_dir = function Dir _ -> true | File _ -> false

  let get_model_props_opt props = function
    | Dir _ -> None
    | File (_, model) -> props model

  let get_title = function
    | Dir p -> Path.basename p |> Option.get
    | File (_, model) -> Model.title model

  let get_url = function
    | Dir p | File (p, _) -> Path.to_string (Target.remove_rel_build_path p)

  let normalize_elt elt =
    let open Data in
    let title = get_title elt in
    let url = get_url elt in
    let lang = get_model_props_opt Model.lang elt in
    let has_lang = Option.is_some lang in
    let date =
      get_model_props_opt (fun model -> Model.date model |> Option.some) elt
    in
    let has_date = not (is_dir elt) in
    record
      [
        ("title", string title);
        ("url", string url);
        ("lang", option string lang);
        ("has_lang", bool has_lang);
        ("date", option Archetype.Datetime.normalize date);
        ("has_date", bool has_date);
      ]

  let normalize t =
    Data.[ ("title", string t.title); ("index", list_of normalize_elt t.index) ]

  let fetch path =
    let on = `Source in
    Task.from_effect (fun () ->
        let open Eff in
        let* files =
          read_directory ~on ~only:`Both ~where:(fun _ -> true) path
        in
        let f file =
          let* is_dir = is_directory ~on file in
          if is_dir then Dir (Target.from_content file) |> return
          else
            (* We assume it's a file here! *)
            let+ model, _content =
              read_file_with_metadata
                (module Yocaml_yaml)
                (module Model)
                ~on file
            in
            let into = Target.from_content path in
            File (Target.with_index_html ~into file, model)
        in

        List.traverse f files)

  let compute_index ~title src =
    let open Task in
    (fun () -> ((), ""))
    |>> first (fetch src >>> lift (fun index -> v ~title index))
end

let process_index ~title path =
  let file_target = Path.(path / "index.html") |> Target.from_content in
  let open Task in
  Action.write_static_file file_target
    (Pipeline.track_file Source.binary
    >>> Index.compute_index ~title path
    >>> Yocaml_jingoo.Pipeline.as_template
          (module Index)
          (Source.template "blog.section.html")
    >>> Yocaml_jingoo.Pipeline.as_template
          (module Index)
          (Source.template "base.html")
    >>> drop_first ())

let process_post year file =
  let file_target = Tree.target year file in
  let open Task in
  Action.write_static_file file_target
    (Pipeline.track_file Source.binary
    >>> Yocaml_yaml.Pipeline.read_file_with_metadata (module Model) file
    >>> Yocaml_cmarkit.content_to_html ()
    >>> Yocaml_jingoo.Pipeline.as_template
          (module Model)
          (Source.template "blog.html")
    >>> Yocaml_jingoo.Pipeline.as_template
          (module Model)
          (Source.template "base.html")
    >>> drop_first ())

let process_posts : Action.t =
  let f year =
    let path = Tree.source year in
    let process_post = process_post year in
    Process.process_markdown ~only:`Files path process_post
  in
  List.map f Tree.years |> Process.process_actions

(* Extract index from loop *)
let process : Action.t =
  let open Eff in
  fun cache ->
    process_posts cache
    >>= process_index ~title:"Blog" Path.(Source.Content.root / Tree.blog)
    >>= process_index ~title:"2021"
          Path.(Source.Content.root / Tree.blog / "2021")
    >>= process_index ~title:"2022"
          Path.(Source.Content.root / Tree.blog / "2022")
