open Yocaml

let process (module R : S.RESOLVER) =
  let into = R.Target.projects in
  let file = R.Target.as_html_index ~into R.Source.projects in
  let open Task in
  Action.Static.write_file_with_metadata
    file
    (Pipeline.track_file R.Source.binary
     >>> Yocaml_yaml.Pipeline.read_file_with_metadata
           (module Model.Projects)
           R.Source.projects
     >>> Yocaml_cmarkit.content_to_html ()
     >>> first (lift @@ Model.Projects.map ~f:Model.Projects.Project.generate_summary_html)
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Projects)
           (R.Source.template "projects.html")
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Projects)
           (R.Source.template "base.html"))
;;
