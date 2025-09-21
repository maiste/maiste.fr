---
id: paste
aliases: 
tags: 
description: Commandline tool paste
language: en
title: Paste
---

Paste is a tool that allows to merge files together.

## Merge files

To merge files in parallel, you can run the following command:

```sh
paste <file1> <file2>
```

## Merge files with a specific delimiter

The default delimiter is <kbd>Tab</kbd> but it is possible to modify it:

```sh
paste -d "|" [files...]
```

Note that if you specified multiple delimiters, `paste` will use it in a circular buffer and increment after each delimitation.

## Merge files in serial

The default option is to merge files in a parallel way. If you want to merge file using a serial way (row instead of column), it can be achieve with the `-s` flag:

```sh
paste -s [files]
```