+++
title = "OCaml"
description = "About OCaml."
template = "data/page.html"

[extra]
lang = "ENG"
+++

### Opam

Opam is the package manager for OCaml.

#### Pin all the *.opam in a repo to a specific version without installing them

```sh
# -n = don't install .opam packages themselves
opam pin <path> --with-version <version> -n
```

#### Resources

* [Opam documentation](https://opam.ocaml.org/doc/Manual.html)
* [Opam packages](https://opam.ocaml.org/packages/)
* [Opam packages on v3.ocaml.org](https://v3.ocaml.org/packages)

<hr />

### Dune

Dune is a build system for OCaml.

#### Build a specific package

```sh
dune build -p <package>
```

#### Build some doc

```sh
dune build @doc
```

#### Run some tests

```sh
dune runtest
```

#### Build in watch mode and clear the screen on rebuilt

```sh
dune build -w --terminal-persistence=clear-on-rebuild
```

#### Resources

* [Dune documentation](https://dune.readthedocs.io/en/stable/)

<hr />

### PPX

#### Summary

PPXs are a tool included in OCaml that allows you to rewrite the AST at compile
time. It's very powerful but also very complicated.

#### Resources

* [Tarides blog post](https://tarides.com/blog/2019-05-09-an-introduction-to-ocaml-ppx-ecosystem)
* [Ppxlib documentation](https://ppxlib.readthedocs.io/en/latest/ppx-for-plugin-authors.html#getting-started)
* [Github Ppxlib example](https://github.com/ocaml-ppx/ppxlib/blob/master/examples/simple-extension-rewriter/dune)
