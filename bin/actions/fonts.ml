open Yocaml

let process (module R : S.RESOLVER) =
  Action.batch
    ~only:`Files
    ~where:Rule.wildcard
    R.Source.fonts
    (Action.copy_file ~into:R.Target.fonts)
;;
