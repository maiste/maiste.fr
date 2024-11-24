open Yocaml

module Peak = struct
  let entity_name = "Section.Peak"

  type t =
    { title : string
    ; metadata : (string * string) list
    ; path : Path.t
    }

  let v ~title path metadata = { title; path; metadata }
  let metadata t = t.metadata
  let title t = t.title

  let normalize t =
    let open Data in
    let metadata =
      List.map (fun (name, data) -> Format.sprintf "%s:%s" name data) t.metadata
    in
    record
      [ "title", string t.title
      ; "url", string (Path.to_string t.path)
      ; "metadata", list_of string metadata
      ]
  ;;
end

let entity_name = "Section"

type t =
  { title : string
  ; index : Peak.t list
  }

let v ~title index = { title; index }

let normalize_index_element ((peak, path) : Peak.t * Path.t) =
  let open Data in
  record [ "title", string peak.title; "url", string (Path.to_string path) ]
;;

let normalize t =
  let open Data in
  [ "title", string t.title; "index", list_of Peak.normalize t.index ]
;;

let sort ~f t = { t with index = List.sort f t.index }
