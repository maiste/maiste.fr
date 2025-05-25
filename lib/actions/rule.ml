(* TODO: we need to upstream this rules directly in the actions. This is better
   because it is up to the action to now this and it doesn't need to be
   exposed. *)
let is_md = Yocaml.Path.has_extension "md"
let is_css = Yocaml.Path.has_extension "css"
let is_js = Yocaml.Path.has_extension "js"

let is_image path =
  Yocaml.Path.has_extension "png" path
  || Yocaml.Path.has_extension "jpeg" path
  || Yocaml.Path.has_extension "jpg" path
  || Yocaml.Path.has_extension "png" path
;;

let wildcard _ = true
