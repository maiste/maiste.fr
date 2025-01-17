open Yocaml

let process (module R : S.RESOLVER) () =
  let open Eff in
  Action.restore_cache R.Target.cache
  >>= Css.process (module R)
  >>= Js.process (module R)
  >>= Fonts.process (module R)
  >>= Images.process (module R)
  >>= Page.process (module R)
  >>= Blog.process (module R)
  >>= Syndicate.process (module R)
  >>= Wiki.process (module R)
  >>= Projects.process (module R)
  >>= Action.store_cache R.Target.cache
;;
