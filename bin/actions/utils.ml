
(** Generic *)
let process_markdown ?(only = `Both) source processor =
  Yocaml.Action.batch ~only ~where:Rule.is_md source processor
;;

(* FIXME: Ugly function? Need refactoring *)
let process_actions (actions : Yocaml.Action.t list) (cache : Yocaml.Cache.t) : Yocaml.Cache.t Yocaml.Eff.t =
  let open Yocaml.Eff in
  let rec aux actions (cache : Yocaml.Cache.t Yocaml.Eff.t) =
    match actions with
    | [] -> cache
    | action :: actions ->
      let cache = cache >>= action in
      aux actions cache
  in
  aux actions (return cache)
;;
