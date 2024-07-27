(lang dune 3.14)

(name maiste-web)
(version dev)
(generate_opam_files)
(executables_implicit_empty_intf)

(source (github maiste/maiste.github.io ))
(license GPL-3.0-or-later)
(authors "Etienne \"Maiste\" Marais <dev@maiste.fr>")
(maintainers "Etienne \"Maiste\" Marais <dev@maiste.fr>")

(package
  (name maiste-web)
  (synopsis "A YOcaml program to generate my website")
  (description "A YOcaml generator to build maiste.fr, my static website")
  (depends

   ;; Build dependencies
   (ocaml (>= 5.1.1))
   (dune (>= 3.14.0))

   ;; YOCaml dependencies
   yocaml
   yocaml_jingoo
   yocaml_yaml
   yocaml_cmarkit
   yocaml_runtime
   yocaml_eio

   ;; dev setup
   (ocamlformat :with-dev-setup)
   (utop :with-dev-setup)
   (ocaml-lsp-server :with-dev-setup)))
