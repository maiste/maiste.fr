open Yocaml

let process cache =
  let open Eff in
  Blog.process cache >>= Css.process >>= Wiki.process >>= Page.process
;;
