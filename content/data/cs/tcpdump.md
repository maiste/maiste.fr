+++
title = "TCPDump"
description = "Commands and resources."
template = "data/page.html"

[extra]
lang = "ENG"
+++

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
