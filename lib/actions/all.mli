(** Module executing all the actions. *)

(** This function provide the processing function, executing all the actions listed. *)
val process : Resolver.t -> unit Yocaml.Eff.t
