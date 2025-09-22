(** This module defines the static pages of the website and the ways they need
    to be proceeded. *)

(** [process] generates an [Action.t] based on the [Path.t] provided in the
    [S.RESOLVER] module. *)
val process : Resolver.t -> Yocaml.Action.t
