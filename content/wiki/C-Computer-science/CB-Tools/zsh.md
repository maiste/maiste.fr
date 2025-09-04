---
id: zsh
aliases: []
tags: []
description: Zsh utilities.
lang: ENG
title: Zsh
---

### Shortcuts

  - <kdb>Ctrl</kdb> + <kdb>q</kdb> => Stage a command

### Plugins

  - `zmv`
    - Massing renaming
    - `autoload zmv` => load in zsh
    - zmv 'regex src' 'export'
  - `take dir` => `mkdir dir` + `cd dir`

### Run an anonymous shell

```sh
zsh # Run a new shell
fc -p # In memory history

# Do Whatever you don't want to store [...]

exit # Discard In Memory result 
```
