open Yocaml

let process (module R : S.RESOLVER) =
  Action.batch
    ~only:`Both
    ~where:Rule.wildcard
    R.Source.images
    (Action.copy_directory ~into:R.Target.images)
;;
