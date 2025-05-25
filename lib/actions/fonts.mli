(** This module defines the way to process fonts to build the website. *)

(** [process] defines an [Action.t] to generate the font based on the
    [S.RESOLVER] module. *)
val process : (module S.RESOLVER) -> Yocaml.Action.t
