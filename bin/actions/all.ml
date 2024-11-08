open Yocaml

let process (module R : S.RESOLVER) () =
  let open Eff in
  Action.restore_cache R.Target.cache
  >>= Blog.process (module R)
  >>= Css.process (module R)
  >>= Js.process (module R)
  >>= Fonts.process (module R)
  >>= Images.process (module R)
  >>= Index.process (module R)
  >>= Page.process (module R)
  >>= Wiki.process (module R)
  >>= Projects.process (module R)
  >>= Action.store_cache R.Target.cache
;;
