open Yocaml
module Section = Model.Section
module Peak = Section.Peak
module Blog = Model.Blog
module Blog_section = Model.Blog.Section

let index_name = "_index.md"

let is_section_index path =
  match Path.basename path with
  | None -> false
  | Some name -> name = index_name
;;

let file_to_action r path content =
  let file_target =
    Resolver.Path.truncate_and_move ~into:(Resolver.Target.target r) path 1
    |> Resolver.Path.as_html_index_untouched
  in
  let metadata, markdown = content in
  let is_using_d2 = Model.Blog.is_using_d2 metadata in
  let d2_action = Markdown.d2_action r ~is_using_d2 markdown in
  let open Task in
  Action.Static.write_file_with_metadata
    file_target
    (Pipeline.track_file Resolver.binary
     >>> lift (fun () -> content)
     >>> Markdown.content_to_html ~is_using_d2
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Blog)
           (Resolver.Source.template r "blog.html")
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Blog)
           (Resolver.Source.template r "base.html"))
  :: d2_action
;;

let extract_metadata_from_dir path = function
  | None ->
    let err = Format.sprintf "No %s file found at %s" index_name (Path.to_string path) in
    raise (Invalid_argument err)
  | Some (metadata, content) -> Blog_section.title metadata, content
;;

let generate_index = function
  | Tree.Dir { path; content; _ } ->
    let title, _ = extract_metadata_from_dir path content in
    let path =
      Resolver.Path.truncate path 1 |> Path.abs |> Resolver.Path.as_html_index_untouched
    in
    Peak.v ~title path []
  | Tree.File { path; content; _ } ->
    let path =
      Resolver.Path.truncate path 1 |> Path.abs |> Resolver.Path.as_html_index_untouched
    in
    let metadata, _ = content in
    let title = Blog.title metadata in
    let metadata = Blog.metadata_to_assoc metadata in
    Peak.v ~title path metadata
;;

let is_draft = function
  | Tree.Dir _ -> false
  | Tree.File { content; _ } ->
    let metadata, _ = content in
    Blog.is_draft metadata
;;

let compare_blog_data p1 p2 =
  let m1 = Peak.metadata p1 in
  let m2 = Peak.metadata p2 in
  let order =
    match List.assoc_opt "date" m1, List.assoc_opt "date" m2 with
    | None, None -> String.compare (Peak.title p1) (Peak.title p2)
    | Some d1, Some d2 -> String.compare d1 d2
    | None, Some _ -> -1
    | Some _, None -> 1
  in
  order * -1 (* We want the reverse order *)
;;

let dir_to_action r path children content =
  let index =
    children |> List.filter (fun child -> not (is_draft child)) |> List.map generate_index
  in
  let title, content = extract_metadata_from_dir path content in
  let metadata = Section.(v ~title Category.Posts index |> sort ~f:compare_blog_data) in
  let section = metadata, content in
  let path =
    Resolver.Path.truncate_and_move ~into:(Resolver.Target.target r) path 1
    |> fun path -> Path.(path / "index.html")
  in
  let open Task in
  [ Action.Static.write_file_with_metadata
      path
      (Pipeline.track_file Resolver.binary
       >>> lift (fun () -> section)
       >>> Yocaml_cmarkit.content_to_html ()
       >>> Yocaml_jingoo.Pipeline.as_template
             (module Section)
             (Resolver.Source.template r "section.html")
       >>> Yocaml_jingoo.Pipeline.as_template
             (module Section)
             (Resolver.Source.template r "base.html"))
  ]
;;

let process r : Action.t =
  let open Eff in
  fun cache ->
    let* tree =
      Tree.compute
        (module Yocaml_yaml)
        (module Blog)
        (module Blog_section)
        ~is_section_index
        (Resolver.Source.blog r)
    in
    let dir_to_action = dir_to_action r in
    let file_to_action = file_to_action r in
    Tree.to_action ~dir_to_action ~file_to_action tree cache
;;
