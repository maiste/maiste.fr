+++
title = "Sysadmin"
description = "Random resources about Sys Admin."
template = "data/page.html"

[extra]
lang = "ENG"
+++

## Backup

* rsync: backup tool
```sh
  # a is for archive, v for verbose, h for human and p for partial
  rsync -avhp src/ dest/
```

<hr />

## Block connections on 22 port

Use the tool *endlessh*

<hr />

## FileSystem

### Create swap memory

* First, you need to create the file:
```bash
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1000000
```
* Then, format the swap file:
```bash
sudo mkswap /swapfile
```
* After that, restrict the permission:
```
sudo chmod 600 /swapfile
```
* Activate the swap:
```
sudo swapon /swapfile
```
* (Optional) Depending if you need to have it online when you restart the computer, you need to edit `/etc/fstab` as follow:
```bash
# FS          mountpoint  type  option(s) dump pass
/path/to/swap    none     swap      sw      0    0
```

### Resources

* [ZFS partition](https://unix.stackexchange.com/questions/672151/create-zfs-partition-on-existing-drive): how to create a ZFS partition

<hr />

## Firewall

### Resources

* [UFW beginner guide](https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands)

<hr />

## Restricting privileges with SSH

### Definition

Use *chroot jail* wit SSH. It allows to isolate a user through ssh in a
specific directory with limited commands.

### Resources

* Tutorial link: [chroot jail](https://allanfeid.com/content/creating-chroot-jail-ssh-access)


## App

### Resources

* [Syncthing](https://syncthing.net/): tool to keep sync up to date
* [Nextcloud](https://nextcloud.com/): cloud interface
