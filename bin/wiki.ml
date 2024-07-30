open Core


 let process_page ~into file =
  let file_target = Target.(with_index_html ~into file) in
  let open Task in
  Action.write_static_file file_target
    (Pipeline.track_file Source.binary
    >>> Yocaml_yaml.Pipeline.read_file_with_metadata
          (module Archetype.Page)
          file
    >>> Yocaml_cmarkit.content_to_html ()
    >>> Yocaml_jingoo.Pipeline.as_template
          (module Archetype.Page)
          (Source.template "page.html")
    >>> Yocaml_jingoo.Pipeline.as_template
          (module Archetype.Page)
          (Source.template "base.html")
    >>> drop_first ())


  let process_books : Action.t =
    Process.process_markdown ~only:`Files Source.Wiki.books
      (process_page ~into:Target.book)

    let process = process_books
