+++
title = "Sway"
description = "How to deal with Sway WM"

[extra]
lang = "ENG"
+++

## GTK App & Desktop slow to start

This is issue can be created by `xdg-desktop-portal-gnome`. One way to fix the problem is to `mask` the service _(symlink point to /dev/null)_ for `systemd` as follow:
```
systemctl --user mask xdg-desktop-portal-gnome
```

### Resources

* [Bug for xdg-desktop-portal-gnome](https://bbs.archlinux.org/viewtopic.php?id=285590)
