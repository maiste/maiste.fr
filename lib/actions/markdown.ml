open Yocaml

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

let generate_image_link_from_block cb meta =
  let open Cmarkit in
  let path = compute_image_name cb |> Resolver.URL.diagrams |> Path.to_string in
  let reference : Inline.Link.reference =
    `Inline (Link_definition.make ~dest:(path, meta) (), meta)
  in
  let text =
    Inline.Text ("An auto generated diagram, description should be bellow.", meta)
  in
  let image = Inline.Image (Inline.Link.make text reference, meta) in
  Block.Paragraph (Block.Paragraph.make image, meta)
;;

let map_d2_to_img markdown =
  let open Cmarkit in
  let block _m = function
    | Block.Code_block (cb, _) ->
      (match Block.Code_block.info_string cb with
       | Some (lang, meta) when lang = "d2" ->
         Mapper.ret @@ generate_image_link_from_block cb meta
       | _ -> Mapper.default)
    | _ -> Mapper.default
  in
  let mapper = Mapper.make ~block () in
  Mapper.map_doc mapper markdown
;;

let get_diagrams r content =
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
            |> fun path ->
            Path.(Resolver.Target.diagrams r / path) |> Path.add_extension "d2"
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

let to_markdown ~is_using_d2 content =
  let markdown = Cmarkit.Doc.of_string ~heading_auto_ids:true ~strict content in
  (if is_using_d2 then map_d2_to_img markdown else markdown) |> Cmarkit_html.of_doc ~safe
;;

let content_to_html ~is_using_d2 =
  Yocaml.Task.lift (fun (metadata, content) -> metadata, to_markdown ~is_using_d2 content)
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

let batch_diagrams r =
  Action.batch
    ~only:`Files
    ~where:(Path.has_extension "d2")
    (Resolver.Target.diagrams r)
    (fun source ->
       let target = Path.change_extension "svg" source in
       Action.exec_cmd (invoke_d2 source) target)
;;

let d2_action r ~is_using_d2 markdown =
  let open Task in
  if is_using_d2
  then (
    let diagrams = get_diagrams r markdown in
    let to_action (path, content) =
      Action.Static.write_file
        path
        (Pipeline.track_file Resolver.binary >>> lift (fun () -> content))
    in
    List.map to_action diagrams @ [ batch_diagrams r ])
  else []
;;
