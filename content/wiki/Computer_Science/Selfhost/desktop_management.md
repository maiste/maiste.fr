---
id: system
aliases: []
tags: []
description: Desktop Management - Messy, needs to be split
lang: ENG
title: Desktop Management
---

## Update Fireware

### Commands

- Check detected devices:
```sh
fwupdmgr get-devices
```

- Refresh latest metadata:
```sh
 fwupdmgr refresh
```
- List available update:
```sh
fwupdmgr get-updates
```
- Install update:
```sh
fwupdmgr update
```
### Resources

* [Archwiki fwupd](https://wiki.archlinux.org/title/Fwupd)
* [Shortcut for kernel crash](https://wiki.archlinux.org/title/Keyboard_shortcuts)
* [Losetup](https://www.computerhope.com/unix/losetup.htm): handle loop devices
* [Weechat bridge](https://megalithic.io/thoughts/weechat-setup-with-irc-bitlbee-slack): bridge for weechat
* [Encrypt external hardrive](https://www.cyberciti.biz/security/howto-linux-hard-disk-encryption-with-luks-cryptsetup-command/): how to encrypt a hard drive


## Clean Flatpak cache

When uninstalling flatpak apps, it might leave some data installed behind. Running this command will clean the unused apps:

```sh
flatpak uninstall --unused
```
