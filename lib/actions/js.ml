open Yocaml

let process r =
  Action.batch
    ~only:`Files
    ~where:Rule.is_js
    (Resolver.Source.js r)
    (Action.copy_file ~into:(Resolver.Target.js r))
;;
