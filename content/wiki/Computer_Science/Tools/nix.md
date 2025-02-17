---
id: nix
aliases: []
tags: []
description: Reproductible package manager
lang: ENG
title: Nix
---

## NixEnv

- `nix-env -q`: do a research
- `nix-env -i`: install a package
- `nix-env -e`: remove a package

## Nix garbage

- `nix-collect-garbage`: launch the garbage collector

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