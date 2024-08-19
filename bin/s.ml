open Yocaml

module type RESOLVABLE = sig
  val source : Path.t
  val target : Path.t
end

module type RESOLVER = sig
  (** Provide some resolvers for the website. *)

  module Source : sig
    (** Describe the source resolver. *)

    val root : Path.t
    val binary : Path.t
    val static : Path.t
    val css : Path.t
    val js : Path.t
    val images : Path.t
    val pages : Path.t
    val templates : Path.t
    val template : string -> Path.t
    val content : Path.t
    val blog : Path.t
    val posts : string -> Path.t
    val wiki : Path.t
    val wiki_section : string -> Path.t
    val index : Path.t
  end

  module Target : sig
    (** Describe the target resolver. *)

    val root : Path.t
    val cache : Path.t
    val static : Path.t
    val css : Path.t
    val js : Path.t
    val images : Path.t
    val pages : Path.t
    val blog : Path.t
    val posts : string -> Path.t
    val wiki : Path.t
    val wiki_section : string -> Path.t
    val as_html : into:Path.t -> Path.t -> Path.t
    val as_html_index : into:Path.t -> Path.t -> Path.t
    val as_html_index_untouched : Path.t -> Path.t
  end

  val truncate : Path.t -> int -> string list
  val truncate_and_move : into:Path.t -> Path.t -> int -> Path.t
end

module type DATA_REINJECTABLE = sig
  (** Union of the [DATA_PROVIDER] and the [DATA_INJECTABLE] module. *)

  (** Describe the type of a the content. *)
  type t

  include Required.DATA_READABLE with type t := t
  include Required.DATA_INJECTABLE with type t := t
end

module type DATA_TREE = sig
  (** A representation of tree structure. *)

  (** Extremity nodes *)
  module Leaf : DATA_REINJECTABLE

  (** Nodes *)
  module Node : DATA_REINJECTABLE

  val node_to_action : Node.t -> Action.t
  val leaf_to_action : Leaf.t -> Action.t
end
