---
id: printer
aliases: []
tags: []
description: How to configure a printer
lang: ENG
title: Printer Management
---

## HP

1. Install the packages `cups` and `hplip`
2. Execute the following command:
```sh
ping <printer_ip>
hp-makeuri <printer_ip>
```
3. Copy the given URI
4. Open the [CUPS interface](http://localhost:631).
5. Add a new printer and paste the previous URL.
