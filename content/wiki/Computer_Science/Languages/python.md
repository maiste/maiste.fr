---
id: python
aliases: []
tags: []
description: The Python Programming Language
lang: ENG
title: Python
---

## Execute shell command

```python
from subprocess import run, CalledProcessError
  try:
    run(["echo", ["..."]], capture_output=True, text=True, check=True, shell=True)
  except CalledProcessError as error:
	pass
```

- The first argument is a `list[str]` with argument separated. `shlex.split("my cmd")` can be used to get the array. If it's used with the `shell=True`, the argument __must__ be `["all you command in one place"]`.
- `capture_output=True` asks to get the output
- `text=True` requires the stdout & stderr to be `str`
- `shell=True` execute the command as a shell command. Use with __cautious__ and not when using external inputs!

<hr />

## Good libraries

* Rich: library to create a format text into the terminal
* Mkdocs: create a documentation
* Xml2rfc: transform an xml document into an rfc format, see [docs](https://xml2rfc.tools.ietf.org/xml2rfc-doc.html) and [writting](https://xml2rfc.tools.ietf.org/authoring/draft-mrose-writing-rfcs.html)
