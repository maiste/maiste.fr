open Yocaml

let entity_name = "Projects"

module Project = struct
  let entity_name = "Project"

  (* TODO: Use date instead of integer. *)
  type t =
    { name : string
    ; starting_year : int option
    ; ending_year : int option
    ; links : string list
    ; summary : string
    }

  let neutral = Metadata.required entity_name

  let validate =
    let open Data.Validation in
    record (fun fields ->
      let+ name = required fields "name" string
      and+ starting_year = optional fields "starting_year" int
      and+ ending_year = optional fields "ending_year" int
      and+ links = optional_or fields ~default:[] "links" (list_of string)
      and+ summary = required fields "summary" string in
      { name; starting_year; ending_year; links; summary })
  ;;

  let normalize t =
    let open Data in
    record
      [ "name", string t.name
      ; "starting_year", option int t.starting_year
      ; "has_starting_year", bool (Option.is_some t.starting_year)
      ; "ending_year", option int t.ending_year
      ; "has_ending_year", bool (Option.is_some t.ending_year)
      ; "active", bool (Option.is_some t.starting_year && Option.is_none t.ending_year)
      ; "links", list_of string t.links
      ; "summary", string t.summary
      ]
  ;;

  let generate_summary_html t =
    let summary =
      Cmarkit.Doc.of_string ~strict:false t.summary |> Cmarkit_html.of_doc ~safe:true
    in
    { t with summary }
  ;;
end

type t = Project.t list

let neutral = Ok []

let validate =
  let open Data.Validation in
  list_of Project.validate
;;

let normalize t =
  let open Data in
  [ "projects", list_of Project.normalize t ]
;;

let map ~f t = List.map f t
