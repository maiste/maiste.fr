open Yocaml
module Blog = Model.Blog
module Blog_section = Model.Blog.Section

let atom_from_posts ~title ~site_url ~feed_url ~authors () =
  let open Yocaml_syndication.Atom in
  let title = text title in
  let updated = updated_from_entries () in
  from ~id:feed_url ~title ~updated ~authors (fun (path, post) ->
    let title = Blog.title post in
    let updated = Yocaml_syndication.Datetime.make (Blog.date post) in
    let content_url = site_url ^ Path.to_string path in
    let links = [ alternate content_url ~title ] in
    let title = text title in
    let summary = text @@ Blog.description post in
    entry ~id:content_url ~title ~updated ~links ~summary ())
;;

let rss_from_posts ~title ~site_url ~feed_url ~description ~author () =
  let open Yocaml_syndication.Rss2 in
  from ~title ~site_url ~feed_url ~description (fun (path, post) ->
    let title = Blog.title post in
    let description = Blog.description post in
    let link = site_url ^ Path.to_string path in
    let pub_date = Yocaml_syndication.Datetime.make (Blog.date post) in
    item ~title ~author ~description ~link ~pub_date ())
;;

let fetch_posts r =
  let open Task in
  let is_section_index path =
    let index_name = "_index.md" in
    match Path.basename path with
    | None -> false
    | Some name -> name = index_name
  in
  let ff acc path content =
    let metadata, _ = content in
    let path =
      Resolver.Path.truncate path 1 |> Path.abs |> Resolver.Path.as_html_index_untouched
    in
    if not @@ Blog.is_draft metadata then (path, metadata) :: acc else acc
  in
  let fd acc _path _content _children = acc in
  Tree.fetch
    (module Yocaml_yaml)
    (module Blog)
    (module Blog_section)
    ~is_section_index
    (Resolver.Source.blog r)
  >>> lift (Tree.leaked_fold ff fd [])
;;

let process r =
  let title = "Maiste Forest" in
  let description = "A flux about the posts I have published" in
  let site_url = "https://maiste.fr" in
  let feed_url = "https://maiste.fr/atom.xml" in
  let author =
    Yocaml_syndication.Person.make ~email:"dev@maiste.fr" "Etienne (maiste) Marais"
  in
  let open Task in
  let posts = fetch_posts r in
  let atom =
    Action.write_static_file
      (Resolver.Target.atom r)
      (Pipeline.track_file Resolver.binary
       >>> posts
       >>> atom_from_posts
             ~title
             ~site_url
             ~feed_url
             ~authors:(Nel.singleton @@ author)
             ())
  in
  let rss =
    Action.write_static_file
      (Resolver.Target.rss r)
      (Pipeline.track_file Resolver.binary
       >>> posts
       >>> rss_from_posts ~title ~site_url ~feed_url ~description ~author ())
  in
  Utils.process_actions [ rss; atom ]
;;
