open Yocaml

module type RESOLVABLE = sig
  val source : Path.t
  val target : Path.t
end

module type RESOLVER = sig
  (** Provide some resolvers for the website. *)

  module Source : sig
    (** Describe the source resolver. It contains most of the past inside of
        the source directory. *)

    val root : Path.t
    val binary : Path.t
    val static : Path.t
    val content : Path.t
    val data : Path.t
    val css : Path.t
    val js : Path.t
    val fonts : Path.t
    val images : Path.t
    val pages : Path.t
    val templates : Path.t
    val template : string -> Path.t
    val blog : Path.t
    val posts : string -> Path.t
    val wiki : Path.t
    val wiki_section : string -> Path.t
    val projects : Path.t
  end

  module Target : sig
    (** Describe the target resolver. It contains most of the [Path.t] inside
        of target dir. *)

    val root : Path.t
    val cache : Path.t
    val static : Path.t
    val css : Path.t
    val js : Path.t
    val fonts : Path.t
    val images : Path.t
    val pages : Path.t
    val blog : Path.t
    val posts : string -> Path.t
    val wiki : Path.t
    val wiki_section : string -> Path.t
    val diagrams : Path.t
    val projects : Path.t
    val atom : Path.t
    val rss : Path.t

    (** Take a file and move it to another location and replace its extension
       with .html. For example: [as_html ~into:Path.rel["target" ; "truc"]
       Path.rel["source" ; "index.md"]] becomes ["target/truc/index.html"]. *)
    val as_html : into:Path.t -> Path.t -> Path.t

    (** Take a file and move it to another location as an [index.html] file.
       For example: [as_html_index ~into:Path.rel["target" ; "truc"] Path.rel
       ["source"; "file.md"]] becomes ["target/truc/file/index.html"]. *)
    val as_html_index : into:Path.t -> Path.t -> Path.t

    (** Is the same as [as_html_index] but it doesn't move the path, it just
       extends the path to a version with  [index.html]. For example
       "target/truc/index.md" becomes "target/truc/index/index.html". *)
    val as_html_index_untouched : Path.t -> Path.t
  end

  module URL : sig
    (** Describe the resolver in the HTTP space *)

    (** Url to static content on the website *)
    val static : Path.t

    (** URL to get the generated images associated to D2 diagrams. *)
    val diagrams : string -> Path.t
  end

  (** Remove the first n elements of the [Path.t]. It returns a [string list]
     that can be converted back to a [Path.t] *)
  val truncate : Path.t -> int -> string list

  (** [truncate_and_move ~into path n] truncates the first [n] of [path] and prefix the path with [into]. *)
  val truncate_and_move : into:Path.t -> Path.t -> int -> Path.t
end
