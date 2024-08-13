open Yocaml

let entity_name = "Wiki"

type t =
  { title : string
  ; description : string option
  ; lang : string option
  }

let v ?description ?lang title = { title; description; lang }
let title t = t.title
let description t = t.description
let lang t = t.lang

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
    and+ lang = optional fields "lang" string in
    { title; description; lang })
;;

let normalize t =
  Data.
    [ "title", string t.title
    ; "description", option string t.description
    ; "lang", option string t.lang
    ; "has_description", bool @@ Option.is_some t.description
    ; "has_lang", bool @@ Option.is_some t.lang
    ]
;;

let compare w1 w2 = String.compare w1.title w2.title
