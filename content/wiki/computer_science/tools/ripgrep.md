---
id: ripgrep
aliases: []
tags: []
description: Commandline tool rg
lang: ENG
title: Ripgrep
---

## Find a pattern in files

```sh
  $ rg <pattern>
```

## List files according to pattern

```sh
  $ rg -l <pattern>
```

## Find a word in files

```sh
  $ rg -w <word>
```

## Find a pattern in files but restrict the file format

```sh
  $ rg -t [ python | c | yaml | json | .. ] <pattern>
```

## Find the number of occurences of a pattern by file

```sh
  $ rg -c <pattern>
```

## Print the files that doesn't match the expression

```sh
$ rg --files-without-match <pattern>
```
