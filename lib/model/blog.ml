open Yocaml

let entity_name = "Blog"

type t =
  { title : string
  ; description : string
  ; date : Archetype.Datetime.t
  ; lang : string option
  ; draft : bool
  ; d2 : bool
  }

let title t = t.title
let description t = t.description
let date t = t.date
let lang t = t.lang
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
    and+ description = required fields "description" string
    and+ date = required fields "date" Archetype.Datetime.validate
    and+ lang = optional fields "lang" string
    and+ draft = optional_or fields "draft" ~default:false bool
    and+ d2 = optional_or fields "d2" ~default:false bool in
    { title; description; date; lang; draft; d2 })
;;

let normalize t =
  Data.
    [ "title", string t.title
    ; "description", string t.description
    ; "date", Archetype.Datetime.normalize t.date
    ; "lang", option string t.lang
    ; "has_lang", bool @@ Option.is_some t.lang
    ; "draft", bool t.draft
    ]
;;

let date_to_string date =
  Datetime.pp Format.str_formatter date;
  Format.flush_str_formatter () |> String.split_on_char ' ' |> List.hd
;;

let metadata_to_assoc t =
  let date = date_to_string t.date in
  match t.lang with
  | None -> [ "date", date ]
  | Some lang -> [ "date", date; "lang", lang ]
;;

module Section = struct
  let entity_name = "Blog.Section"

  type t = { title : string }

  let title t = t.title

  let neutral =
    Data.Validation.fail_with ~given:"null" "Cannot be null"
    |> Result.map_error (fun error ->
      Required.Validation_error { entity = entity_name; error })
  ;;

  let validate =
    let open Data.Validation in
    record (fun fields ->
      let+ title = required fields "title" string in
      { title })
  ;;
end
