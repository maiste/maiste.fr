(** Module executing all the actions. *)

(** This function provide the processing function, executing all the actions listed. *)
val process : (module S.RESOLVER) -> unit -> unit Yocaml.Eff.t
