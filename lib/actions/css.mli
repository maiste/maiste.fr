(** This module contains this action in charge of processing the css content. *)

(** [process] is the function that explains how to produce a CSS. *)
val process : (module S.RESOLVER) -> Yocaml.Action.t
