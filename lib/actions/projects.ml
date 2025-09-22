open Yocaml

let process r =
  let into = Resolver.Target.projects r in
  let file = Resolver.Path.as_html_index ~into (Resolver.Source.projects r) in
  let open Task in
  Action.Static.write_file_with_metadata
    file
    (Pipeline.track_file Resolver.binary
     >>> Yocaml_yaml.Pipeline.read_file_with_metadata
           (module Model.Projects)
           (Resolver.Source.projects r)
     >>> Yocaml_cmarkit.content_to_html ()
     >>> first (lift @@ Model.Projects.map ~f:Model.Projects.Project.generate_summary_html)
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Projects)
           (Resolver.Source.template r "projects.html")
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Projects)
           (Resolver.Source.template r "base.html"))
;;
