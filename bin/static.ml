open Core
(* FIXME: copy a static directory! *)

(** Building the css is just copying the file to the right position. *)
let process_css = Action.copy_file ~into:Target.target_root Source.css

let process_css_code = Action.copy_file ~into:Target.target_root Source.css_code
