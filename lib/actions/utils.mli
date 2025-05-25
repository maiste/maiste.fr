(** Module containing helper function *)

(** This function generate an [Action.t] that executes only on markdown, based
    on the [processor] function. *)
val process_markdown
  :  ?only:[ `Both | `Directories | `Files ]
  -> Yocaml.Path.t
  -> (Yocaml.Path.t -> Yocaml.Action.t)
  -> Yocaml.Action.t

(** [process_actions actions] flatten a list of [Action.t] into a unique
    [Action.t]. You can see an analogy of [List.flatten] *)
val process_actions : Yocaml.Action.t list -> Yocaml.Action.t
