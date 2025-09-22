open Yocaml
module Section = Model.Section
module Peak = Model.Section.Peak

let index_name = "_index.md"

let is_section_index path =
  match Path.basename path with
  | None -> false
  | Some name -> name = index_name
;;

let extract_metadata_from_dir path content =
  match content with
  | None ->
    let err = Format.sprintf "No %s file found at %s" index_name (Path.to_string path) in
    raise (Invalid_argument err)
  | Some (metadata, content) -> metadata, content
;;

let get_index = function
  | Tree.Dir { path; content; _ } ->
    let metadata, _ = extract_metadata_from_dir path content in
    let path =
      Resolver.Path.truncate path 1 |> Path.abs |> fun p -> Path.(p / "index.html")
    in
    metadata, path
  | Tree.File { path; content } ->
    let path =
      Resolver.Path.truncate path 1 |> Path.abs |> Resolver.Path.as_html_index_untouched
    in
    let metadata, _ = content in
    metadata, path
;;

let dir_to_action r path children content =
  let children =
    List.map get_index children
    |> List.filter (fun (wiki, _) -> not @@ Model.Wiki.is_draft wiki)
    |> List.sort (fun (w1, _) (w2, _) -> Model.Wiki.compare w1 w2)
    |> List.map (fun (t, path) ->
      let title = Model.Wiki.title t in
      let data = Model.Wiki.metadata_to_assoc t in
      Peak.v ~title path data)
  in
  let metadata, content = extract_metadata_from_dir path content in
  let section =
    let title = Model.Wiki.title metadata in
    Section.v ~title Section.Category.Index children
  in
  let template = section, content in
  let path = Resolver.Path.truncate path 1 in
  let path = Path.(Resolver.Target.target r ++ path) in
  let path = Path.(path / "index.html") in
  let open Task in
  [ Action.write_static_file
      path
      (Pipeline.track_file Resolver.binary
       >>> lift (fun () -> template)
       >>> Yocaml_cmarkit.content_to_html ()
       >>> Yocaml_jingoo.Pipeline.as_template
             (module Section)
             (Resolver.Source.template r "section.html")
       >>> Yocaml_jingoo.Pipeline.as_template
             (module Section)
             (Resolver.Source.template r "base.html")
       >>> drop_first ())
  ]
;;

let file_to_action r path content =
  let open Task in
  let path = Resolver.Path.truncate path 1 in
  let path = Path.(Resolver.Target.target r ++ path) in
  let path = Resolver.Path.as_html_index_untouched path in
  let metadata, markdown = content in
  let is_using_d2 = Model.Wiki.is_using_d2 metadata in
  let d2_action = Markdown.d2_action r ~is_using_d2 markdown in
  Action.write_static_file
    path
    (Pipeline.track_file Resolver.binary
     >>> lift (fun () -> content)
     >>> Markdown.content_to_html ~is_using_d2
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Wiki)
           (Resolver.Source.template r "wiki.html")
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Wiki)
           (Resolver.Source.template r "base.html")
     >>> drop_first ())
  :: d2_action
;;

let process r : Action.t =
  let root = Resolver.Source.wiki r in
  let open Eff in
  fun cache ->
    let* tree =
      Tree.compute
        (module Yocaml_yaml)
        (module Model.Wiki)
        (module Model.Wiki)
        ~is_section_index
        root
    in
    let dir_to_action = dir_to_action r in
    let file_to_action = file_to_action r in
    Tree.to_action ~dir_to_action ~file_to_action tree cache
;;
