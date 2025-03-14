module Resolver = Lib.Resolver

let build ~source ~target log_level =
  let module R =
    Resolver.Make (struct
      let source = source
      let target = target
    end)
  in
  let process_all = Lib.Actions.All.process (module R) in
  Yocaml_eio.run ~level:log_level process_all
;;

let serve ~source ~target log_level port =
  let module R =
    Lib.Resolver.Make (struct
      let source = source
      let target = target
    end)
  in
  let process_all = Lib.Actions.All.process (module R) in
  Yocaml_eio.serve ~level:log_level ~target:R.Target.root ~port process_all
;;

let () =
  let source = Lib.Path.rel [] in
  let target = Lib.Path.rel [ "target" ] in
  match Array.to_list Sys.argv with
  | [ _; "serve" ] -> serve ~source ~target `Debug 8085
  | _ -> build ~source ~target `Debug
;;
