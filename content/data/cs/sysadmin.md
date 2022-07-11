+++
title = "Sysadmin"
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

<hr />

## Block connections on 22 port

Use the tool *endlessh*

<hr />

## FileSystem

### Resources

<hr />

## Firewall

### Resources

* [UFW beginner guide](https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands)

<hr />

## Restricting privileges with SSH

### Definition

Use *chroot jail* wit SSH. It allows to isolate a user through ssh in a
specific directory with limited commands.

### Resources

* Tutorial link: [chroot jail](https://allanfeid.com/content/creating-chroot-jail-ssh-access)

