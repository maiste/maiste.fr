---
id: bash
aliases: []
tags: []
description: About Bash scripts.
lang: ENG
title: Bash
---
## Here document

In Unix Shell, it is possible to create a multi-line input using the _here document_ syntax:

```shell
cat <<TOKEN
[...]
TOKEN
```

It is useful, when you want to create a block of text using multi-lines.
Notabely to create files. By default, this is going to expand variables.
However, if you quote the `TOKEN`, it will prevent expanding the variables.

```sh
cat <<'TOKEN'
[...]
TOKEN
```
