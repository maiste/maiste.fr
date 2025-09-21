---
id: ssh
aliases: []
tags: []
description: Manipulate SSH utilities
language: en
title: SSH
---

## Generate keys

SSH requires you to generate a public and a private key. The recommandations
are to use the `ed25519` algorithm with `100` derivations. The `-a` specifies
the number of iterations to derive the key and make it harder to brut force.

```sh
ssh-keygen -t ed25519 [-a <number>] [-f <output_file>] [-C <email>]
```
