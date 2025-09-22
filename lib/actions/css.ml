open Yocaml

let process r =
  Action.batch
    ~only:`Files
    ~where:Rule.is_css
    (Resolver.Source.css r)
    (Action.copy_file ~into:(Resolver.Target.css r))
;;
