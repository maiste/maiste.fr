open Yocaml

let entity_name = "Wiki"

type t =
  { title : string
  ; description : string option
  ; lang : string option
  ; draft : bool
  }

let v ?lang ~draft ~description title = { title; description; lang; draft }
let title t = t.title
let description t = t.description
let lang t = t.lang
let is_draft t = t.draft

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
    and+ lang = optional fields "lang" string
    and+ draft = optional_or fields "draft" bool ~default:false in
    { title; description; lang; draft })
;;

let normalize t =
  Data.
    [ "title", string t.title
    ; "description", option string t.description
    ; "lang", option string t.lang
    ; "has_description", bool @@ Option.is_some t.description
    ; "has_lang", bool @@ Option.is_some t.lang
    ; "draft", bool t.draft
    ]
;;

let compare w1 w2 = String.compare w1.title w2.title
