---
title: "Exiftool"
description: "Metadata manipulation"
---

## Move file in a datatime architecture

```sh
exiftool "-Directory<DateTimeOriginal" -d "%Y/%m" <path>/*.<extension>
```
