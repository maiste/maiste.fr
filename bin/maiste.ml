open Core

let process_index =
  let file = Source.Content.index in
  let file_target = Target.(as_html ~into:Target.root file) in
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


let process_all () =
  let open Eff in
  Action.restore_cache Target.cache
  >>= Static.process_css >>= Static.process_css_code >>= process_index >>= Pages.process
  >>= Blog.process >>= Wiki.process_books
  >>= Action.store_cache Target.cache

let () =
  match Array.to_list Sys.argv with
  | [ _; "serve" ] ->
      Yocaml_eio.serve ~level:`Info ~target:Target.target_root ~port:8085
        process_all
  | _ -> Yocaml_eio.run process_all
