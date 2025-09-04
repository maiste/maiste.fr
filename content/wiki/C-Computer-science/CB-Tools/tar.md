---
id: tar
aliases: []
tags: []
description: An archive system
lang: ENG
title: Tar
---

## Basics

### Create an archive

```sh
 tar cf <name>.tar [objs]
```

### Extract an archive

```sh
  tar xf <name>.tar
```

### Activate verbose mode

```sh
 tar v [cmd]
```

---

## Use compression

### Create a gzip archive

```sh
  tar czf <name>.tgz [objs]
```

### Extract a gzip archive

```sh
  tar xzf <name>.tgz
```

### Create an zstd archive

See [zsdt](zstd.md)

```sh
tar --zstd cf <name>.tar.zst <files>
```

### Extract a zstd archive

```sh
tar --zstd xf <name>.tar.zst
```


---

## Pipe with other programs

### Extract on flight an archive with http

```sh
  wget -c http[s]://host/path/to/file.tgz -O - | tar -xz
```

---

## GPG

### Encrypt tar with GPG

```sh
  tar czpvf - <name> | gpg -c [--batch --yes --passphrase <password>] --cipher-algo aes256 -o <name>.gz.gpg
```

### Decrypt tar with GPG

```sh
  gpg -d [--batch --yes --passphrase azerty12] <tar file> | tar xzvf -
```
