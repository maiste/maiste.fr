open Yocaml

let process (module R : S.RESOLVER) cache =
  let open Eff in
  Blog.process (module R) cache
  >>= Css.process (module R)
  >>= Js.process (module R)
  >>= Fonts.process (module R)
  >>= Images.process (module R)
  >>= Page.process (module R)
  >>= Wiki.process (module R)
;;
