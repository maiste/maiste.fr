open Yocaml

module Source = struct
  let pages = Path.rel [ "pages" ]
  let template file = Path.rel [ "templates"; file ]
  let css = template "main.css"
  let css_code = template "code.css"
  let binary = Path.rel [ Sys.argv.(0) ]
  let is_md path = Path.has_extension "md" path

  module Content = struct
    let root = Path.rel [ "contents" ]
    let src_root = Path.rel [ "contents" ]
    let index = Path.(src_root / "index.md")
  end

  module Wiki = struct
    let wiki = Path.(Content.src_root / "wiki")
    let books = Path.(wiki / "books")
  end
end

module Target = struct
  let build = Path.rel [ "_build" ]
  let root = Path.(build / "public")
  let target_root = Path.rel [ "_build"; "public" ]
  let cache = Path.(build / "cache")
  let pages = target_root
  let wiki = Path.(target_root / "wiki")
  let book = Path.(wiki / "books")

  let from_source src =
    Path.to_list src |> function
    | [] ->
        raise
          (Invalid_argument
             "Source from empty list is not possible from source!")
    | _path :: paths -> Path.(target_root ++ paths)

  let from_content src =
    Path.to_list src |> function
    | [] | [ _ ] ->
        raise
          (Invalid_argument
             "Source from empty list or card 1 is not possible from content!")
    | _src :: _content :: paths -> Path.(target_root ++ paths)

  (* FIXME: this needs to be clean! *)
  let remove_rel_build_path src =
    Path.to_list src |> function
    | [] | [ _ ] | [ _; _ ] ->
        raise
          (Invalid_argument
             "Source from empty list or card 1 is not possible from build_path!")
    | _dot :: _build :: _public :: paths -> Path.abs paths

  let as_html ~into file =
    file |> Path.move ~into |> Path.change_extension "html"

  let with_index_html ~into file =
    let subpath = Path.remove_extension file |> Path.basename |> Option.get in
    Path.(into / subpath / "index.html")
end

module Process = struct
  (** Generic *)
  let process_markdown ?(only = `Both) source processor =
    Action.batch ~only ~where:Source.is_md source processor

  (* FIXME: Ugly function? Need refactoring *)
  let process_actions (actions : Action.t list) (cache : Cache.t) :
      Cache.t Eff.t =
    let open Eff in
    let rec aux actions (cache : Cache.t Eff.t) =
      match actions with
      | [] -> cache
      | action :: actions ->
          let cache = cache >>= action in
          aux actions cache
    in
    aux actions (Eff.return cache)
end
