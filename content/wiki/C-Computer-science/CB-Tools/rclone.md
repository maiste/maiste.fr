---
id: rclone
aliases: []
tags: []
description: Rsync with remote provider for backups - Commandline tool
language: en
title: Rclone
---

## Configuration file for Scaleway

This a sample for Scaleway that you need to store in `$HOME/.config/rclone/rclone.conf`

```toml
[scaleway] # Remote name
type = s3
provider = Scaleway
access_key_id = XXXXX
secret_access_key = XXXX
region = fr-par
endpoint = s3.fr-par.scw.cloud
acl = private
storage_class = STANDARD # or GLACIER
```

## Synchronize files with remote

It will synchronize files which means it can delete file on remote.

```sh
rclone sync -v "/path/to/backup" remote:bucket_name
```

## Copy files with remote

Same as `sync` but it will keep the deleted files.

```sh
rclone copy  "/path/to/backup" remote:bucket_name
```

## Restore glacier file

If the data are store with the GLACIER storage class, you first need to restore them. It can take up to **48 hours**!

```shell
rclone backend restore remote:bucket_name -o priority=Standard
```

## Restore files

```sh
rclone copy remote:bucket_name "/path/to/restore"
```
