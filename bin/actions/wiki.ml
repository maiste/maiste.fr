open Yocaml

let process_page (module R : S.RESOLVER) ~into file =
  let file_target = R.Target.(as_html_index ~into file) in
  let open Task in
  Action.write_static_file
    file_target
    (Pipeline.track_file R.Source.binary
     >>> Yocaml_yaml.Pipeline.read_file_with_metadata (module Archetype.Page) file
     >>> Yocaml_cmarkit.content_to_html ()
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Archetype.Page)
           (R.Source.template "page.html")
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Archetype.Page)
           (R.Source.template "base.html")
     >>> drop_first ())
;;

let process_books (module R : S.RESOLVER) : Action.t =
  Utils.process_markdown
    ~only:`Files
    (R.Source.wiki_section "books")
    (process_page (module R) ~into:(R.Target.wiki_section "books"))
;;

let process (module R : S.RESOLVER) = process_books (module R)
