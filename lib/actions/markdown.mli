(** This module provides function to manipulate markdown and extends the format. *)

(** TODO: the d2_action needs to be refactor to provides an [Action.t] and the
    [content_to_html] should be better simplified. *)

(** This function generates a list of [Action.t] to build the [d2] diagrams. *)
val d2_action : Resolver.t -> is_using_d2:bool -> string -> Yocaml.Action.t list

(* This function provides a replacement to the [Yocaml_cmarkit.content_to_html]
   function by extending it using a custom [d2] extractor. *)
val content_to_html : is_using_d2:bool -> ('a * string, 'a * string) Yocaml.Task.t
