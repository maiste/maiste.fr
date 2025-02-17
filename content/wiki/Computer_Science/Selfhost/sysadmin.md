---
id: sysadmin
aliases: []
tags: []
description: Resources about Sys Admin - Messy, needs to be split
lang: ENG
title: Sys Admin
---

## Apps

### Resources

* [Syncthing](https://syncthing.net/): tool to keep sync up to date
* [Nextcloud](https://nextcloud.com/): cloud interface

<hr />

## Backup

* rsync: backup tool
```sh
  # a is for archive, v for verbose, h for human and p for partial
  rsync -avhp src/ dest/
```

<hr />

### Resources

* [Rclone](https://rclone.org/docs/): a tool to manage backup with cloud providers
* [Object Storage - Scaleway](https://www.scaleway.com/en/docs/tutorials/migrate-data-rclone/): how to use Object Storage and Rclone with Scaleway
* [Encrypted Object Storage - Scaleway](https://www.scaleway.com/en/docs/tutorials/encrypt-s3-data-rclone/): how to use object storage with encrypted buckets

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

## Nginx

### Resources

* [Proxy_pass](https://dev.to/danielkun/nginx-everything-about-proxypass-2ona): tutorial about nginx `proxy_pass` directive

<hr />

## SSH

### Chroot jail

#### Definition

Use *chroot jail* wit SSH. It allows to isolate a user through ssh in a
specific directory with limited commands.

### Resources

* [chroot jail](https://allanfeid.com/content/creating-chroot-jail-ssh-access): how to build a Chroot jail
* [Bastion SSH (FR)](https://blog.octo.com/le-bastion-ssh/): how to create a SSH bastion
* [Visual Guide to SSH Tunnels](https://iximiuz.com/en/posts/ssh-tunnels/)

<hr />

## VPN

### Resources

* [Buil a VPN with Wireguard](https://fedoramagazine.org/build-a-virtual-private-network-with-wireguard/): Fedora magazine post about how to build aVPN with Wireguard

<hr />

## Sudo & su

## Su

* Execute a command with the default shell for a specific user
  ```sh
  su <user> -c <command>
  ```
* Execute a specific shell for a specific user
  ```sh
  su <user> -s <shell>
  ```

## DNS - Protect from squatting

The DNS should have this if you don't want to host an email on your domain.

```dns
MX 0 "."
TXT v=spf1 -all
TXT v=DMARC1; p=reject;
```

The `MX` is to specify that there is no mail server in the domain. The first
`TXT` specifies that no mail server can send mail in your domain name. The last
one says that every mail saying they are sent on your behalf should be consider
as trash.
