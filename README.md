# Maiste.fr - A garden for my digital life

> :warning: This website is still active but is under a complete redesign
> :safety_vest: New stuffs incoming! :camel:

## Context

As a true privacy believer, I think it's important to keep control over your
data and be able to host your website on your own. This project is an attempt
(with more and less success) to bring my stone to the edifice!

This blog is built with the wonderful OCaml framework `YOCaml`. Feel free to
inspire yourself from it!

## Install deps

As the project is built using _OCaml_, it currently uses _opam_ to manage
dependencies. To install the project, simply run:

```sh
$ opam switch create . --deps-only $ eval $(opam env)
```

If you want to also install the dependencies for a development purpose, you
need to add the `--with-dev-setup`:

```sh
$ opam switch create . --deps-only --with-dev-setup $ eval $(opam env)
```

## Run the builder

To execute our code, we rely on `dune`. To produce the content in the _target/_
directory, run:

```sh
$ dune exec ./bin/maiste.exe
```

If you want to lunch the development server, you can run the same command with
the `serve` option:

```sh
$ dune exec ./bin/maiste.exe serve
```

## License

All the code under this project is under the [GPL3](./LICENSE) license. The
content of the blog is under [CC BY-NC
4.0](https://creativecommons.org/licenses/by-nc/4.0/?ref=chooser-v1).
