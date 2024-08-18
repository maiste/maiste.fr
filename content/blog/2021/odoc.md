---
title: "Doc on GitHub pages with Odoc and Actions"
date: 2021-08-20
---

## Context

I will not surprise anyone if I say that documenting your code is important.
If you host your code on GitHub, you might have heard about [GitHub Pages](https://pages.github.com/).
This project allows GitHub users to deploy some static websites using GitHub.
For example, [this website](maiste.fr) is stored on my GitHub account.

An interesting point is that you can use this feature to store piece of
documentations at a specific URL. If your OCaml code is on GitHub, you can
deploy the configuration the way I will show you.

First, your code must follow the [ocamldoc](https://ocaml.org/manual/ocamldoc.html) convention. Also,
the [odoc](https://opam.ocaml.org/packages/odoc/) generator must be in your package dependencies (maybe with the
`{with-doc}` specification.

Below, you can see a partial example of a `.opam`, I have created:
```
depends: [
  "ocaml" {>= "4.12.0"}
  "dune" {>= "2.5"}
  "odoc" {with-doc}
]
build: [
  ["dune" "subst"] {pinned}
  [
    "dune"
    "build"
    "-p"
    name
    "-j"
    jobs
    "@install"
    "@runtest" {with-test}
    "@doc" {with-doc}
  ]
]
```

Now we have our documentation, it's time to automatize the process with
GitHub Actions.

## Setup GitHub Actions

At the root of your repository, you must create (if it's not already the case)
a __.github/workflows/__ directory. In it, you must create a <name>.yml file.
The content of the file is:

```yaml
name: <Display title>

on:
  push:
    branches:
    - <Regex describing the branch on which this action must be trigger>

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: ocaml/setup-ocaml@v2
        with:
          ocaml-compiler: '<version number>'
      - name: Dependencies
        run: opam install -d . --deps-only
      - name: Building docs
        run: opam exec -- dune build @doc
      - name: Deploying to github pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: <./_build/default/_doc/_html/ or directory where your doc is stored>
          [destination_dir: no_mammut] <optional: push the doc in a different directory>
          [enable_jekyll: true] <optional: allow jekyll like website>
```

Thanks to this file, each time the action is triggered, it will push a new commit in the
`gh-pages` branch of your repository.

## Take the mouse back and update GitHub

- You need to go to your repository settings:

  ![Github settings](/static/images/blog/2021/github_1.png)
- Then, you must go to the __Pages__ settings:

  ![Github Pages](/static/images/blog/2021/github_2.png)
- Finally, you must select the branch on which your pages are built. Here it is
  `gh-pages`:

  ![Github branch](/static/images/blog/2021/github_3.png)

And, you are done! If everything has worked well you can check your documentation at:

__\<user\>.github.io/\<repo name\>/__.

## Conclusion

I hope this tutorial can be useful to you! Feel free to send me correction if
I have made a mistake.

