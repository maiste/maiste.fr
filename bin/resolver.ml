open Yocaml

module Make (R : S.RESOLVABLE) : S.RESOLVER = struct
  module Source = struct
    let root = R.source
    let binary = Path.rel [ Sys.argv.(0) ]
    let static = Path.(R.source / "static")
    let css = Path.(static / "css")
    let js = Path.(static / "script")
    let fonts = Path.(static / "fonts")
    let images = Path.(static / "images")
    let pages = Path.(static / "pages")
    let templates = Path.(static / "templates")
    let template file = Path.(templates / file)
    let content = Path.(R.source / "content")
    let blog = Path.(content / "blog")
    let posts year = Path.(blog / year)
    let wiki = Path.(content / "wiki")
    let wiki_section section = Path.(wiki / section)
    let index = Path.(content / "index.md")
  end

  module Target = struct
    let root = R.target
    let cache = Path.(R.target / "yocaml-cache")
    let static = Path.(R.target / "static")
    let css = Path.(static / "css")
    let js = Path.(static / "script")
    let fonts = Path.(static / "fonts")
    let images = Path.(static / "images")
    let pages = R.target
    let blog = Path.(R.target / "blog")
    let posts year = Path.(blog / year)
    let wiki = Path.(R.target / "wiki")
    let wiki_section section = Path.(wiki / section)
    let as_html ~into file = file |> Path.move ~into |> Path.change_extension "html"

    let as_html_index ~into file =
      let subpath = Path.remove_extension file |> Path.basename |> Option.get in
      Path.(into / subpath / "index.html")
    ;;

    let as_html_index_untouched file =
      let into = Path.dirname file in
      as_html_index ~into file
    ;;
  end

  let truncate src n = Path.to_pair src |> snd |> List.to_seq |> Seq.drop n |> List.of_seq
  let truncate_and_move ~into src n = truncate src n |> Path.( ++ ) into
end