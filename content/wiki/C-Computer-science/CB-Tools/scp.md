---
id: scp
aliases: []
tags: []
description: SSH remote copy commandline tool
lang: ENG
title: Scp
---

## Description

```sh
scp [OPTIONS] user@hostname:src user@otherhostname:dst
```

## Copy a local file to a remote server

```sh
scp /path/to/file user@ip:/path/to/copy/file
```

## Copy a repository

```sh
scp -r [src] [dest]
```

## Specify the file to use as a key

```sh
scp -i /path/to/file [src] [dest]
```
