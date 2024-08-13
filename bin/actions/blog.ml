open Yocaml
module Index = Index.Blog
module Model = Model.Blog

module P = Resolver.Make (struct
    let source = Path.rel []
    let target = Path.rel [ "target" ]
  end)

module Tree = struct
  let years = [ "2021"; "2022" ]
  let source year = Path.(P.Source.blog / year)

  let target year file =
    let into = Path.(P.Target.blog / year) in
    P.Target.as_html_index ~into file
  ;;

  let index = Path.(P.Target.blog / "index.html")
end

let process_index ~title path =
  let file_target =
    Path.(P.(truncate_and_move ~into:Target.root path 1) / "index.html")
  in
  let open Task in
  Action.write_static_file
    file_target
    (Pipeline.track_file P.Source.binary
     >>> Index.compute_index ~title path
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Index)
           (P.Source.template "blog.section.html")
     >>> Yocaml_jingoo.Pipeline.as_template (module Index) (P.Source.template "base.html")
     >>> drop_first ())
;;

let process_post year file =
  let file_target = Tree.target year file in
  let open Task in
  Action.write_static_file
    file_target
    (Pipeline.track_file P.Source.binary
     >>> Yocaml_yaml.Pipeline.read_file_with_metadata (module Model) file
     >>> Yocaml_cmarkit.content_to_html ()
     >>> Yocaml_jingoo.Pipeline.as_template (module Model) (P.Source.template "blog.html")
     >>> Yocaml_jingoo.Pipeline.as_template (module Model) (P.Source.template "base.html")
     >>> drop_first ())
;;

let process_posts : Action.t =
  let f year =
    let path = Tree.source year in
    let process_post = process_post year in
    Utils.process_markdown ~only:`Files path process_post
  in
  List.map f Tree.years |> Utils.process_actions
;;

(* Extract index from loop *)
let process : Action.t =
  let open Eff in
  fun cache ->
    process_posts cache
    >>= process_index ~title:"Blog" P.Source.blog
    >>= process_index ~title:"2021" (P.Source.posts "2021")
    >>= process_index ~title:"2022" (P.Source.posts "2022")
;;
