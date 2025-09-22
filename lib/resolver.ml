open Yocaml

type t =
  { source : Path.t
  ; target : Path.t
  }

let make ~source ~target = { source; target }
let binary = Path.rel [ Sys.argv.(0) ]

module Source = struct
  let source { source; _ } = source
  let static r = Path.(source r / "static")
  let content r = Path.(source r / "content")
  let data r = Path.(content r / "data")
  let css r = Path.(static r / "css")
  let js r = Path.(static r / "script")
  let fonts r = Path.(static r / "fonts")
  let images r = Path.(static r / "images")
  let pages r = Path.(static r / "pages")
  let templates r = Path.(static r / "templates")
  let template r file = Path.(templates r / file)
  let blog r = Path.(content r / "blog")
  let posts r year = Path.(blog r / year)
  let wiki r = Path.(content r / "wiki")
  let wiki_section r section = Path.(wiki r / section)
  let projects r = Path.(data r / "projects.md")
end

module Target = struct
  let target { target; _ } = target
  let cache r = Path.(target r / "yocaml-cache")
  let static r = Path.(target r / "static")
  let css r = Path.(static r / "css")
  let js r = Path.(static r / "script")
  let fonts r = Path.(static r / "fonts")
  let images r = Path.(static r / "images")
  let pages r = target r
  let projects r = target r
  let blog r = Path.(target r / "blog")
  let posts r year = Path.(blog r / year)
  let wiki r = Path.(target r / "wiki")
  let wiki_section r section = Path.(wiki r / section)
  let diagrams r = Path.(static r / "diagrams")
  let atom r = Path.(target r / "atom.xml")
  let rss r = Path.(target r / "rss.xml")
end

module URL = struct
  let static = Path.abs [ "static" ]
  let diagrams name = Path.(static / "diagrams" / name |> add_extension "svg")
end

module Path = struct
  let as_html ~into file = file |> Path.move ~into |> Path.change_extension "html"

  let as_html_index ~into file =
    let subpath = Path.remove_extension file |> Path.basename |> Option.get in
    Path.(into / subpath / "index.html")
  ;;

  let as_html_index_untouched file =
    let into = Path.dirname file in
    as_html_index ~into file
  ;;

  let truncate src n = Path.to_pair src |> snd |> List.to_seq |> Seq.drop n |> List.of_seq
  let truncate_and_move ~into src n = truncate src n |> Path.( ++ ) into
end
