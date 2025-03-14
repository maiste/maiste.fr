open Yocaml

let process (module R : S.RESOLVER) =
  Action.batch
    ~only:`Files
    ~where:Rule.is_js
    R.Source.js
    (Action.copy_file ~into:R.Target.js)
;;
