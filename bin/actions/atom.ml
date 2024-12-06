open Yocaml
module Blog = Model.Blog
module Blog_section = Model.Blog.Section

let from_posts ~title ~site_url ~feed_url ~authors () =
  let open Yocaml_syndication.Atom in
  let title = text title in
  let updated = updated_from_entries () in
  from ~id:feed_url ~title ~updated ~authors (fun (path, post) ->
    let title = Blog.title post in
    let updated = Yocaml_syndication.Datetime.make (Blog.date post) in
    let content_url = site_url ^ Yocaml.Path.to_string path in
    let links = [ alternate content_url ~title ] in
    let title = text title in
    entry ~id:content_url ~title ~updated ~links ())
;;

let fetch_posts (module R : S.RESOLVER) =
  let open Task in
  let is_section_index path =
    let index_name = "_index.md" in
    match Path.basename path with
    | None -> false
    | Some name -> name = index_name
  in
  let ff acc path content =
    let metadata, _ = content in
    let path = R.truncate path 1 |> Path.abs |> R.Target.as_html_index_untouched in
    (path, metadata) :: acc
  in
  let fd acc _path _content _children = acc in
  Tree.fetch
    (module Yocaml_yaml)
    (module Blog)
    (module Blog_section)
    ~is_section_index
    R.Source.blog
  >>> lift (Tree.leaked_fold ff fd [])
;;

let process (module R : S.RESOLVER) =
  let title = "Maiste Digital Garden" in
  let site_url = "https://maiste.fr" in
  let feed_url = "https://maiste.fr/atom.xml" in
  let authors =
    Nel.singleton
    @@ Yocaml_syndication.Person.make ~email:"dev@maiste.fr" "Etienne <Maiste> Marais"
  in
  let open Task in
  Action.write_static_file
    R.Target.atom
    (Pipeline.track_file R.Source.binary
     >>> fetch_posts (module R)
     >>> from_posts ~title ~site_url ~feed_url ~authors ())
;;
