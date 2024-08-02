open Yocaml

(* FIXME: turn me into a First class module *)
module P = Resolver.Make (struct
    let source = Path.rel []
    let target = Path.rel [ "target" ]
  end)

let process_page ?(into = P.Target.pages) file =
  let file_target = P.Target.(as_html_index ~into file) in
  let open Task in
  Action.write_static_file
    file_target
    (Pipeline.track_file P.Source.binary
     >>> Yocaml_yaml.Pipeline.read_file_with_metadata (module Archetype.Page) file
     >>> Yocaml_cmarkit.content_to_html ()
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Archetype.Page)
           (P.Source.template "page.html")
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Archetype.Page)
           (P.Source.template "base.html")
     >>> drop_first ())
;;

let process = Generator.process_markdown ~only:`Files P.Source.pages process_page
