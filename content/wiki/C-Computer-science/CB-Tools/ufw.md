---
id: ufw
aliases: []
tags: []
description: Firewall
lang: en-GB
title: UFW
---

## Description

`ufw` is a firewall on top of `iptableQ`

## Commands
### Status

```sh
ufw status [verbose]
```

### Enabled

```sh
ufw enable
```

### Allow port from anywhere (IPv4-6)

```sh
ufw allow <PORT>
```

### Deny incoming by default

```sh
ufw default deny incoming
```
