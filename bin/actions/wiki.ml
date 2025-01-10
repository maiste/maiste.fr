open Yocaml

let index_name = "_index.md"

let is_section_index path =
  match Path.basename path with
  | None -> false
  | Some name -> name = index_name
;;

let extract_metadata_from_dir path content =
  match content with
  | None ->
    Path.basename path
    |> (function
     | None -> raise (Invalid_argument "Path is wrong")
     | Some path ->
       let title = String.split_on_char '_' path |> String.concat " " in
       Model.Wiki.v title ~description:None ~draft:false ~d2:false, "")
  | Some (metadata, content) -> metadata, content
;;

let get_index (module R : S.RESOLVER) = function
  | Tree.Dir { path; content; _ } ->
    let metadata, _ = extract_metadata_from_dir path content in
    let path = R.truncate path 1 |> Path.abs |> fun p -> Path.(p / "index.html") in
    metadata, path
  | Tree.File { path; content } ->
    let path = R.truncate path 1 |> Path.abs |> R.Target.as_html_index_untouched in
    let metadata, _ = content in
    metadata, path
;;

module Transformer = struct
  (* HACK: this part is so dirty! Transfer me to my own file and clean me! *)
  let strict = false
  let safe = false

  let read_code_block cb =
    let open Cmarkit in
    Block.Code_block.code cb
    |> List.map (fun line -> Block_line.to_string line)
    |> String.concat "\n"
  ;;

  let compute_image_name cb =
    read_code_block cb |> Digestif.SHA256.digest_string |> Digestif.SHA256.to_hex
  ;;

  let generate_image_link_from_block (module R : S.RESOLVER) cb meta =
    let open Cmarkit in
    let path = compute_image_name cb |> R.URL.diagrams |> Path.to_string in
    let reference : Inline.Link.reference =
      `Inline (Link_definition.make ~dest:(path, meta) (), meta)
    in
    let text =
      Inline.Text ("An auto generated diagram, description should be bellow.", meta)
    in
    let image = Inline.Image (Inline.Link.make text reference, meta) in
    Block.Paragraph (Block.Paragraph.make image, meta)
  ;;

  let map_d2_to_img (module R : S.RESOLVER) markdown =
    let open Cmarkit in
    let block _m = function
      | Block.Code_block (cb, _) ->
        (match Block.Code_block.info_string cb with
         | Some (lang, meta) when lang = "d2" ->
           Mapper.ret @@ generate_image_link_from_block (module R) cb meta
         | _ -> Mapper.default)
      | _ -> Mapper.default
    in
    let mapper = Mapper.make ~block () in
    Mapper.map_doc mapper markdown
  ;;

  let get_diagrams (module R : S.RESOLVER) content =
    let markdown = Cmarkit.Doc.of_string ~heading_auto_ids:true ~strict content in
    let open Cmarkit in
    let block _ acc = function
      | Block.Code_block (cb, _) ->
        let acc =
          match Block.Code_block.info_string cb with
          | Some (lang, _) when lang = "d2" ->
            let content = read_code_block cb in
            let path =
              compute_image_name cb
              |> fun path -> Path.(R.Target.diagrams / path) |> Path.add_extension "d2"
            in
            (path, content) :: acc
          | _ -> acc
        in
        Folder.ret acc
      | _ -> Folder.default
    in
    let folder = Folder.make ~block () in
    Folder.fold_doc folder [] markdown
  ;;

  let to_markdown (module R : S.RESOLVER) metadata content =
    let markdown = Cmarkit.Doc.of_string ~heading_auto_ids:true ~strict content in
    (if Model.Wiki.is_using_d2 metadata
     then map_d2_to_img (module R) markdown
     else markdown)
    |> Cmarkit_html.of_doc ~safe
  ;;

  let content_to_html (module R : S.RESOLVER) =
    Yocaml.Task.lift (fun (metadata, content) ->
      metadata, to_markdown (module R) metadata content)
  ;;

  let invoke_d2 source target =
    let open Cmd in
    make
      "d2"
      [ flag ~prefix:"--" "sketch"
      ; param ~prefix:"-" "t" (int 301)
      ; param ~suffix:"=" "layout" (string "elk")
      ; arg (w source)
      ; arg target
      ]
  ;;

  let batch_diagrams (module R : S.RESOLVER) =
    Action.batch
      ~only:`Files
      ~where:(Path.has_extension "d2")
      R.Target.diagrams
      (fun source ->
         let target = Path.change_extension "svg" source in
         Action.exec_cmd (invoke_d2 source) target)
  ;;
end

let dir_to_action (module R : S.RESOLVER) path children content =
  let children =
    List.map (get_index (module R)) children
    |> List.filter (fun (wiki, _) -> not @@ Model.Wiki.is_draft wiki)
  in
  let metadata, content = extract_metadata_from_dir path content in
  let wiki_section =
    let title = Model.Wiki.title metadata in
    let description = Model.Wiki.description metadata in
    Model.Wiki_section.(v ~title ?description children |> sort)
  in
  let template = wiki_section, content in
  let path = R.truncate path 1 in
  let path = Path.(R.Target.root ++ path) in
  let path = Path.(path / "index.html") in
  let open Task in
  [ Action.write_static_file
      path
      (Pipeline.track_file R.Source.binary
       >>> lift (fun () -> template)
       >>> Yocaml_cmarkit.content_to_html ()
       >>> Yocaml_jingoo.Pipeline.as_template
             (module Model.Wiki_section)
             (R.Source.template "wiki.section.html")
       >>> Yocaml_jingoo.Pipeline.as_template
             (module Model.Wiki_section)
             (R.Source.template "base.html")
       >>> drop_first ())
  ]
;;

let file_to_action (module R : S.RESOLVER) path content =
  let open Task in
  let path = R.truncate path 1 in
  let path = Path.(R.Target.root ++ path) in
  let path = R.Target.as_html_index_untouched path in
  let metadata, markdown = content in
  let d2_schemas =
    if Model.Wiki.is_using_d2 metadata
    then (
      let diagrams = Transformer.get_diagrams (module R) markdown in
      List.iter
        (fun (path, content) ->
           Format.printf
             "For path (%s) I'm using content\n%s@."
             (Path.to_string path)
             content)
        diagrams;
      let to_action (path, content) =
        Action.Static.write_file
          path
          (Pipeline.track_file R.Source.binary >>> lift (fun () -> content))
      in
      List.map to_action diagrams @ [ Transformer.batch_diagrams (module R) ])
    else []
  in
  Action.write_static_file
    path
    (Pipeline.track_file R.Source.binary
     >>> lift (fun () -> content)
     >>> Transformer.content_to_html (module R)
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Wiki)
           (R.Source.template "wiki.html")
     >>> Yocaml_jingoo.Pipeline.as_template
           (module Model.Wiki)
           (R.Source.template "base.html")
     >>> drop_first ())
  :: d2_schemas
;;

let process (module R : S.RESOLVER) root : Action.t =
  let open Eff in
  fun cache ->
    let* tree =
      Tree.compute
        (module Yocaml_yaml)
        (module Model.Wiki)
        (module Model.Wiki)
        ~is_section_index
        root
    in
    let dir_to_action = dir_to_action (module R) in
    let file_to_action = file_to_action (module R) in
    Tree.to_action ~dir_to_action ~file_to_action tree cache
;;

let process (module R : S.RESOLVER) = process (module R) R.Source.wiki
