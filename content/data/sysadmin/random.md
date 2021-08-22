+++
title = "Random"
description = "Random resources about Sys Admin."
template = "data/page.html"

[extra]
lang = "ENG"
+++

## Backup

* rsync: backup tool
```sh
  # a is for archive, v for verbose, h for human and p for partial
  rsync -avhp src/ dest/
```

## Restricting privileges with SSH

Use *chroot jail* wit SSH. It allows to isolate a user through ssh in a
specific directory with limited commands.

Tutorial link: [chroot jail](https://allanfeid.com/content/creating-chroot-jail-ssh-access)

## Block connections on 22 port:

Use the tool *endlessh*
