(** This module defines the rules to build JS files inside the final website.
    *)

(** [process] generates an [Action.t] using the [Path.t] provided in the
    [resolver]. *)
val process : Resolver.t -> Yocaml.Action.t
