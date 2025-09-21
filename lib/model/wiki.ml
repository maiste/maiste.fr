open Yocaml

let entity_name = "Wiki"

type t =
  { title : string
  ; description : string option
  ; language : string option
  ; draft : bool
  ; d2 : bool
  }

let v ?language ~draft ~d2 ~description title = { title; description; language; draft; d2 }
let title t = t.title
let description t = t.description
let language t = t.language
let is_draft t = t.draft
let is_using_d2 t = t.d2

let neutral =
  Data.Validation.fail_with ~given:"null" "Cannot be null"
  |> Result.map_error (fun error ->
    Required.Validation_error { entity = entity_name; error })
;;

let validate =
  let open Data.Validation in
  record (fun fields ->
    let+ title = required fields "title" string
    and+ description = optional fields "description" string
    and+ language = optional fields "language" string
    and+ draft = optional_or fields "draft" bool ~default:false
    and+ d2 = optional_or fields "d2" bool ~default:false in
    { title; description; language; draft; d2 })
;;

let normalize t =
  Data.
    [ "title", string t.title
    ; "description", option string t.description
    ; "language", option string t.language
    ; "has_description", bool @@ Option.is_some t.description
    ; "has_language", bool @@ Option.is_some t.language
    ; "draft", bool t.draft
    ]
;;

let compare w1 w2 = String.compare w1.title w2.title

let metadata_to_assoc t =
  let language =
    match t.language with
    | None -> []
    | Some language -> [ "language", language ]
  in
  let description =
    match t.description with
    | None -> []
    | Some desc -> [ "description", desc ]
  in
  language @ description
;;
