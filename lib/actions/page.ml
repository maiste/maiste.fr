open Yocaml

let from_file_to_template r file =
  let open Task in
  let files =
    let+ () = Pipeline.track_file Resolver.binary
    and+ content =
      Yocaml_yaml.Pipeline.read_file_with_metadata (module Archetype.Page) file
    in
    content
  in
  files
  >>> Yocaml_markdown.Pipeline.With_metadata.make ~strict:false ()
  >>> Yocaml.Pipeline.chain_templates
        (module Yocaml_jingoo)
        (module Archetype.Page)
        [ Resolver.Source.template r "page.html"; Resolver.Source.template r "base.html" ]
  >>> drop_first ()
;;

let process_page r file =
  let into = Resolver.Target.pages r in
  let file_target =
    if Path.basename file = Some "index.md"
    then Resolver.Path.as_html ~into file
    else Resolver.Path.as_html_index ~into file
  in
  Action.write_static_file file_target (from_file_to_template r file)
;;

let process r =
  let process_page = process_page r in
  Utils.process_markdown ~only:`Files (Resolver.Source.pages r) process_page
;;
