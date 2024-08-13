open Yocaml

(* FIXME: turn me into a First class module *)
module P = Resolver.Make (struct
    let source = Path.rel []
    let target = Path.rel [ "target" ]
  end)

let process =
  Action.batch
    ~only:`Files
    ~where:Rule.is_css
    P.Source.css
    (Action.copy_file ~into:P.Target.css)
;;
