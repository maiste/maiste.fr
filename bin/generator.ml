open Yocaml

(** Generic *)
let process_markdown ?(only = `Both) source processor =
  Action.batch ~only ~where:Rule.is_md source processor
;;

(* FIXME: Ugly function? Need refactoring *)
let process_actions (actions : Action.t list) (cache : Cache.t) : Cache.t Eff.t =
  let open Eff in
  let rec aux actions (cache : Cache.t Eff.t) =
    match actions with
    | [] -> cache
    | action :: actions ->
      let cache = cache >>= action in
      aux actions cache
  in
  aux actions (Eff.return cache)
;;
