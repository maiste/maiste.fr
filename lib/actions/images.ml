open Yocaml

let process r =
  Action.batch
    ~only:`Both
    ~where:Rule.wildcard
    (Resolver.Source.images r)
    (Action.copy_directory ~into:(Resolver.Target.images r))
;;
