open Yocaml

let process r =
  let open Eff in
  let cache = Resolver.Target.cache r in
  Action.restore_cache cache
  >>= Css.process r
  >>= Js.process r
  >>= Fonts.process r
  >>= Images.process r
  >>= Page.process r
  >>= Blog.process r
  >>= Syndicate.process r
  >>= Wiki.process r
  >>= Projects.process r
  >>= Action.store_cache cache
;;
