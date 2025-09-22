(** Module containing the actions in charge of building the blog part. *)

(** [process] generates an [Action.t] based on the [Path.t] provided inside of
   the [S.RESOLVER] module. *)
val process : Resolver.t -> Yocaml.Action.t
