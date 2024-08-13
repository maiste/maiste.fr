open Yocaml
module Index = Index.Blog
module Model = Model.Blog

module Tree = struct
  let years = [ "2021"; "2022" ]
  let source (module R : S.RESOLVER) year = Path.(R.Source.blog / year)

  let target (module R : S.RESOLVER) year file =
    let into = Path.(R.Target.blog / year) in
    R.Target.as_html_index ~into file
  ;;
end

let process_index (module R : S.RESOLVER) ~title path =
  let file_target =
    Path.(R.(truncate_and_move ~into:Target.root path 1) / "index.html")
  in
  let open Task in
  Action.write_static_file
    file_target
    (Pipeline.track_file R.Source.binary
     >>> Index.compute_index ~title path
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Index)
           (R.Source.template "blog.section.html")
     >>> Yocaml_jingoo.Pipeline.as_template (module Index) (R.Source.template "base.html")
     >>> drop_first ())
;;

let process_post (module R : S.RESOLVER) year file =
  let file_target = Tree.target (module R) year file in
  let open Task in
  Action.write_static_file
    file_target
    (Pipeline.track_file R.Source.binary
     >>> Yocaml_yaml.Pipeline.read_file_with_metadata (module Model) file
     >>> Yocaml_cmarkit.content_to_html ()
     >>> Yocaml_jingoo.Pipeline.as_template (module Model) (R.Source.template "blog.html")
     >>> Yocaml_jingoo.Pipeline.as_template (module Model) (R.Source.template "base.html")
     >>> drop_first ())
;;

let process_posts (module R : S.RESOLVER) : Action.t =
  let f year =
    let path = Tree.source (module R) year in
    let process_post = process_post (module R) year in
    Utils.process_markdown ~only:`Files path process_post
  in
  List.map f Tree.years |> Utils.process_actions
;;

(* Extract index from loop *)
let process (module R : S.RESOLVER) : Action.t =
  let open Eff in
  fun cache ->
    process_posts (module R) cache
    >>= process_index (module R) ~title:"Blog" R.Source.blog
    >>= process_index (module R) ~title:"2021" (R.Source.posts "2021")
    >>= process_index (module R) ~title:"2022" (R.Source.posts "2022")
;;
