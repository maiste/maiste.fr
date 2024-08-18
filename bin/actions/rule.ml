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
