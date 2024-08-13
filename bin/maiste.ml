open Yocaml

let process_index (module R : S.RESOLVER) =
  let file = R.Source.index in
  let file_target = R.Target.(as_html ~into:root file) in
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

let process_all (module R : S.RESOLVER) () =
  let open Eff in
  Action.restore_cache R.Target.cache
  >>= process_index (module R)
  >>= Actions.All.process (module R)
  >>= Action.store_cache R.Target.cache
;;

(* FIXME: use argument to select source and target. *)
module R = Resolver.Make (struct
    let source = Path.rel []
    let target = Path.rel [ "target" ]
  end)

let () =
  let process_all = process_all (module R) in
  match Array.to_list Sys.argv with
  | [ _; "serve" ] ->
    Yocaml_eio.serve ~level:`Info ~target:R.Target.root ~port:8085 process_all
  | _ -> Yocaml_eio.run process_all
;;
