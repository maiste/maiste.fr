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
      List.map (fun (name, data) -> Format.sprintf "%s:\"%s\"" name data) t.metadata
    in
    record
      [ "title", string t.title
      ; "url", string (Path.to_string t.path)
      ; "metadata", list_of string metadata
      ]
  ;;
end

let entity_name = "Section"

module Category = struct
  type t =
    | Index
    | Posts

  let to_string = function
    | Index -> "Index"
    | Posts -> "Posts"
  ;;
end

type t =
  { title : string
  ; category : Category.t
  ; index : Peak.t list
  }

let v ~title category index = { title; category; index }

let normalize t =
  let open Data in
  [ "title", string t.title
  ; "category", string (Category.to_string t.category)
  ; "index", list_of Peak.normalize t.index
  ]
;;

let sort ~f t = { t with index = List.sort f t.index }
