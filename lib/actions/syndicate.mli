(** Module in charge of generating the news flux. *)

(** [process] generates the rss and atom flux for the website, based on the
    [Path.t] provided by the [S.RESOLVER] module. *)
val process : Resolver.t -> Yocaml.Action.t
