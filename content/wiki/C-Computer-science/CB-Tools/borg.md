---
id: borg
aliases: []
tags: []
description: Backup Commandline tool
lang: en-GB
title: Borg
---

## Recurrent flags

- `--dry-run` can be used to see the effect of the command.
- `--list` allows to list concerned files.
- `--stats` gives some statistics about the archives.

## Init a borg repository

```sh
# Generate a strong passphrase
openssl rand -base64 50 > "/path/to/passphrase"

# Export command to retrieve PASSPHRASE
export BORG_PASSCOMMAND="cat /path/to/passphrase"

# Init a borg repository in a specific location
borg init --encryption=repokey /path/to/borg/repo
```

- `--encryption=repokey` means with store the key with the `borg` repository. Without it, you can't restore your data.
## Create an archive

```sh
# Export command to retrieve PASSPHRASE
export BORG_PASSCOMMAND="cat /path/to/passphrase"

borg create "/path/to/borg/repo"::backup_name [FILES TO BACKUP]
```

- `--stats` can be used to display information while backing up data.
- `backup_name` can use `{hostname}` to include the name of the host in the name.

## Prune archives

```sh
# Export command to retrieve PASSPHRASE
export BORG_PASSCOMMAND="cat /path/to/passphrase"

borg prune --keep-daily=7 --keep-monthly=4 "/path/to/borg/repo"
```

- `--keep-X`: they can be combined to keep daily and monthly backup. In the example above it keeps archives from the last 7 days __plus__ 1 archive for each month is the last 4 months.
	- `--keep-daily=N`: keeps N daily archives
	- `--keep-monthly=N`: keeps N monthly archive
	- `--keep-yearly=N`: remove archive older than N years
- `--stats`: displays stats

## Compact data

```sh
# Export command to retrieve PASSPHRASE
export BORG_PASSCOMMAND="cat /path/to/passphrase"

borg compact "/path/to/borg/repo"
```

## List archives

```sh
# Export command to retrieve PASSPHRASE
export BORG_PASSCOMMAND="cat /path/to/passphrase"

borg list "/path/to/borg/repo"
```

## Extract archive

```sh
borg extract -v --list "/path/to/borg/repo"::backup_name [archive_repo_paths]
```

- `-v` is for verbose mode.
- `--list` allows to display files taken into account.
- `[archive_repo_paths]` is a list of path separated by space to only restore specific paths. If it's **absent**, it restores **all of them**. 
## Delete archive

```sh
# Export command to retrieve PASSPHRASE
export BORG_PASSCOMMAND="cat /path/to/passphrase"

borg delete --list "/path/to/borg/repo"::backup_name
```

- `--list` allows to display files taken into account.
