---
id: tcpdump
aliases: []
tags: []
description: Network Analyzer - Commandline tool
lang: ENG
title: TCPDump
---

## List available interfaces

```sh
tcpdump -D
```

## Run TCPDump on a specific interface

```sh
tcpdump -i <if>
```

### Run TCPDump and display brut ASCII

```sh
tcpdump -A
```

### Limit the number of captured packets

```sh
tcpdump -c <number>
```

### Print the result in line

```sh
tcpdump -l
```

### Read from a file

```sh
tcpdump -r <file>
```

### Export to a file

```sh
tcpdump -w <file>
```
