(lang dune 3.14)

(name maiste)

(version dev)

(generate_opam_files)

(executables_implicit_empty_intf)

(source
 (codeberg maiste/maiste.fr))

(license GPL-3.0-or-later)

(authors "Etienne \"Maiste\" Marais <self@maiste.fr>")

(maintainers "Etienne \"Maiste\" Marais <self@maiste.fr>")

(package
 (name maiste)
 (synopsis "A YOcaml program to generate my website")
 (description "A YOcaml generator to build maiste.fr, my static website")
 (depends
  ;; Build dependencies
  (ocaml
   (>= 5.1.1))
  ;; YOCaml dependencies
  (yocaml
   (>= 2.0.0))
  yocaml_jingoo
  yocaml_yaml
  yocaml_cmarkit
  yocaml_runtime
  yocaml_eio
  yocaml_syndication
  ;; External dependencies
  (digestif
   (>= 1.2.0))
  ;; dev setup
  (ocamlformat :with-dev-setup)
  (utop :with-dev-setup)
  (ocaml-lsp-server :with-dev-setup)))
