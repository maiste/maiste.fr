---
id: ack
aliases: []
tags: []
description: Commandline tool ack
language: en
title: Ack
---

## List files

```sh
  $ ack -f
```

## List files according to pattern

```sh
  $ ack -g <pattern>
```

## Find a pattern in files

```sh
  $ ack <pattern>
```

## Find a word in files

```sh
  $ ack -w <word>
```

## Find a pattern in files but restrict the file format

```sh
  $ ack [--python | --c | --yaml | --json | ..] <pattern>
```

## Find the number of occurences of a pattern by file

```sh
  $ ack -c <pattern>

```

## Print the files that matches the expression

```sh
$ ack <pattern> -l
```


## Print the files that doesn't match the expression

```sh
$ ack <pattern> -L
```
