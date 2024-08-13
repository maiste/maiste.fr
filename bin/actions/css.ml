open Yocaml

let process (module R : S.RESOLVER) =
  Action.batch
    ~only:`Files
    ~where:Rule.is_css
    R.Source.css
    (Action.copy_file ~into:R.Target.css)
;;
