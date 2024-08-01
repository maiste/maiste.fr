open Core

module Make (R : sig
    val source : Path.t
    val target : Path.t
  end) =
struct
  module Source = struct
    let root = R.source
    let binary = Path.rel [ Sys.argv.(0) ]
    let static = Path.(R.source / "static")
    let css = Path.(static / "css")
    let pages = Path.(static / "pages")
    let templates = Path.(R.source / "templates")
    let template file = Path.(templates / file)
    let content = Path.(R.source / "content")
    let blog = Path.(content / "blog")
    let wiki = Path.(content / "wiki")
    let index = Path.(content / "index.md")
  end

  module Target = struct
    let root = R.target
    let website = Path.(R.target / "public")
    let cache = Path.(R.target / "yocaml-cache")
    let pages = website
    let blog = Path.(website / "blog")
    let wiki = Path.(website / "wiki")

    let from_source src =
      Path.to_pair src |> snd |> List.to_seq |> Seq.drop 1 |> List.of_seq
    ;;

    let as_html ~into file = file |> Path.move ~into |> Path.change_extension "html"

    let as_html_index ~into file =
      let subpath = Path.remove_extension file |> Path.basename |> Option.get in
      Path.(into / subpath / "index.html")
    ;;
  end
end
