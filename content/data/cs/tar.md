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

## Create a gzip archive

```sh
  tar czf <name>.tgz [objs]
```

## Extract an archive

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
