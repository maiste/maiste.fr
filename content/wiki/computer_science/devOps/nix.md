---
id: nix
aliases: []
tags: []
description: Reproducible builds.
lang: ENG
title: Nix
---
## Nix-shell

### Specify the wanted packages

```sh
nix-shell -p <package list>
```

## Execute in a pure environment

This unset the environment variables

```sh
nix-shell --pure
```