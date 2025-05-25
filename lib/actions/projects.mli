(** Module to generates the page containing the projects based on a YAML file.
    *)

(** [process] generates the [Action.t] based on the [Path.t] provided by the
    [S.RESOLVER] module. *)
val process : (module S.RESOLVER) -> Yocaml.Action.t
