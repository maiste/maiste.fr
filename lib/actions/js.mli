(** This module defines the rules to build JS files inside the final website.
    *)

(** [process] generates an [Action.t] using the [Path.t] provided in the
    [S.RESOLVER] module. *)
val process : (module S.RESOLVER) -> Yocaml.Action.t
