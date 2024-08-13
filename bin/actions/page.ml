open Yocaml

let process_page (module R : S.RESOLVER) file =
  let into = R.Target.pages in
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

let process (module R : S.RESOLVER) =
  let process_page = process_page (module R) in
  Utils.process_markdown ~only:`Files R.Source.pages process_page
;;
