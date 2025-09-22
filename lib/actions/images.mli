(** The module [Images] is in charge of processing the images to the target directory. *)

(** [process] generates an [Action.t] based on the [Path.t] provided by the
    [S.RESOLVER] module. *)
val process : Resolver.t -> Yocaml.Action.t
