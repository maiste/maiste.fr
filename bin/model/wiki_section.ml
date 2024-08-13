open Yocaml

type t =
  { title : string
  ; index : (Wiki.t * Path.t) list
  }

let normalize_dir_title name =
  let chain = String.split_on_char '_' name in
  let first_letter_uppercase s =
    String.mapi (fun idx c -> if idx = 0 then Char.uppercase_ascii c else c) s
  in
  List.map first_letter_uppercase chain |> String.concat " "
;;

let v ~title index = { title; index }

let normalize_elt (elt, path) =
  let open Data in
  let title = Wiki.title elt in
  let url = Path.to_string path in
  let description = Wiki.description elt in
  let has_description = Option.is_some description in
  let lang = Wiki.lang elt in
  let has_lang = Option.is_some lang in
  record
    [ "title", string title
    ; "url", string url
    ; "lang", option string lang
    ; "has_lang", bool has_lang
    ; "description", option string description
    ; "has_description", bool has_description
    ]
;;

let normalize t = Data.[ "title", string t.title; "index", list_of normalize_elt t.index ]

let sort t =
  { t with index = List.sort (fun (w1, _) (w2, _) -> Wiki.compare w1 w2) t.index }
;;
