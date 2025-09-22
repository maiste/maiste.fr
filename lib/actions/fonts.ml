open Yocaml

let process r =
  Action.batch
    ~only:`Files
    ~where:Rule.wildcard
    (Resolver.Source.fonts r)
    (Action.copy_file ~into:(Resolver.Target.fonts r))
;;
