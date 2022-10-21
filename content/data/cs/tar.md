+++
title = "Tar"
description = "About the tar archive system."
template = "data/page.html"

[extra]
lang = "ENG"
+++


## Create an archive

```sh
 tar cf <name>.tar [objs]
```

## Extract an archive

```sh
  tar xf <name>.tar
```

<hr />

## Create a gzip archive

```sh
  tar czf <name>.tgz [objs]
```

## Extract a gzip archive

```sh
  tar xzf <name>.tgz
```

## Activate verbose mode

```sh
 tar v [cmd]
```

## Extract on flight an archive with http

```sh
  wget -c http[s]://host/path/to/file.tgz -O - | tar -xz
```

<hr />

## Encrypt tar with GPG

```sh
  tar czpvf - <name> | gpg -c [--batch --yes --passphrase <password>] --cipher-algo aes256 -o <name>.gz.gpg
```

## Decrypt tar with GPG

```sh
  gpg -d [--batch --yes --passphrase azerty12] <tar file> | tar xzvf -
```
