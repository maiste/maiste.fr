let process_markdown ?(only = `Both) source processor =
  Yocaml.Action.batch ~only ~where:Rule.is_md source processor
;;

let process_actions actions = Yocaml.Action.batch_list actions Fun.id
