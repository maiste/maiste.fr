module Resolver = Lib.Resolver

let build ~source ~target log_level =
  let r = Resolver.make ~source ~target in
  let process_all = fun () -> Lib.Actions.All.process r in
  Yocaml_eio.run ~level:log_level process_all
;;

let serve ~source ~target log_level port =
  let r = Resolver.make ~source ~target in
  let process_all = fun () -> Lib.Actions.All.process r in
  Yocaml_eio.serve ~level:log_level ~target ~port process_all
;;

let () =
  let source = Lib.Path.rel [] in
  let target = Lib.Path.rel [ "target" ] in
  match Array.to_list Sys.argv with
  | [ _; "serve" ] -> serve ~source ~target `Debug 8085
  | _ -> build ~source ~target `Debug
;;
