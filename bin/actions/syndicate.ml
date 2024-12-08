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
    entry ~id:content_url ~title ~updated ~links ())
;;

let rss_from_posts ~title ~site_url ~feed_url ~description ~author () =
  let open Yocaml_syndication.Rss2 in
  from ~title ~site_url ~feed_url ~description (fun (path, post) ->
    let title = Blog.title post in
    let description = "" in
    (* TODO: add a summary into the blog post *)
    let link = site_url ^ Path.to_string path in
    let pub_date = Yocaml_syndication.Datetime.make (Blog.date post) in
    item ~title ~author ~description ~link ~pub_date ())
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
  let title = "Maiste Forest" in
  let description = "A flux about the posts I have published" in
  let site_url = "https://maiste.fr" in
  let feed_url = "https://maiste.fr/atom.xml" in
  let author =
    Yocaml_syndication.Person.make ~email:"dev@maiste.fr" "Etienne <Maiste> Marais"
  in
  let open Task in
  let posts = fetch_posts (module R) in
  let atom =
    Action.write_static_file
      R.Target.atom
      (Pipeline.track_file R.Source.binary
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
      R.Target.rss
      (Pipeline.track_file R.Source.binary
       >>> posts
       >>> rss_from_posts ~title ~site_url ~feed_url ~description ~author ())
  in
  Utils.process_actions [ rss; atom ]
;;
