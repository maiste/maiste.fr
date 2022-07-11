+++
title = "OCaml"
description = "About OCaml."
template = "data/page.html"

[extra]
lang = "ENG"
+++

## Opam

Opam is the package manager for OCaml.

### Pin all the *.opam in a repo to a specific version without installing them

```sh
# -n = don't install .opam packages themselves
opam pin <path> --with-version <version> -n
```

### Resources

* [Opam documentation](https://opam.ocaml.org/doc/Manual.html)
* [Opam packages](https://opam.ocaml.org/packages/)
* [Opam packages on v3.ocaml.org](https://v3.ocaml.org/packages)

<hr />

## Dune

Dune is a build system for OCaml.

### Build a specific package

```sh
dune build -p <package>
```

### Build some doc

```sh
dune build @doc
```

### Run some tests

```sh
dune runtest
```

### Build in watch mode and clear the screen on rebuilt

```sh
dune build -w --terminal-persistence=clear-on-rebuild
```

### Resources

* [Dune documentation](https://dune.readthedocs.io/en/stable/)

<hr />

## PPX

### Summary

PPXs are a tool included in OCaml that allows you to rewrite the AST at compile
time. It's very powerful but also very complicated.

### Resources

* [Tarides blog post](https://tarides.com/blog/2019-05-09-an-introduction-to-ocaml-ppx-ecosystem)
* [Ppxlib documentation](https://ppxlib.readthedocs.io/en/latest/ppx-for-plugin-authors.html#getting-started)
* [Github Ppxlib example](https://github.com/ocaml-ppx/ppxlib/blob/master/examples/simple-extension-rewriter/dune)

## OCaml

### Note about exceptions

Exceptions can be a bit tricky to understand. It's hard to know when it is going to generate a _StackOverflow_ error. With this two examples, we can understand how it behaves.
* This example is not going to generate an error as the handler is added arround the `g` function once.
```ocaml
let rec g x =
    match x with
    | Leaf x -> raise (Found x)
    | Node (r, v) -> g r ; g v

let f x = try g x with Found x -> (* Do something *)
```
* However, this example is able to generate a _StackOverflow_ error if the tree is too big. An handler is installed on `g` each time you call the function.
```ocaml
let rec g x =
    match x with
    | Leaf x -> raise (Found x)
    | Node (r, v) ->  try g r ; g v with Found x -> x
```

### Resources

* [Write a website with Dream](https://ceramichacker.com/blog/26-1x-full-stack-webdev-in-ocaml-intro)
* [Realworld OCaml](https://dev.realworldocaml.org/index.html)
