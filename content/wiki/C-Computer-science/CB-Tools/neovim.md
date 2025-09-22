---
id: neovim
aliases: []
tags: []
description: Stuffs about (Neo)Vim.
lang: en-GB
title: NeoVIM
---

## Environment

To run NeoVIM with a specific config located in `~/.config/<dir>`, you can pass
it to the environment variable:

```sh
$ NVIM_APPNAME=<dir> nvim
```

## Shortcuts

- <kbd>space</kbd>: Leader key
- <kbd>jk</kbd> / <kbd>kj</kbd> : Exit mode

### By default

- <kbd>TAB</kbd> : Change buffer
- <kbd>Shift</kbd> + <kbd>TAB</kbd> : Change buffer from back
- <kbd>leader</kbd> + <kbd>bd</kbd> : Delete buffer
- <kbd>leader</kbd> + <kbd>os</kbd> : Stop research
- <kbd>Ctrl</kbd> + <kbd>a</kbd> : Decrement a number
- <kbd>Ctrl</kbd> + <kbd>x</kbd> : Increment a number
- <kbd>Ctrl</kbd> + <kbd>o</kbd> : Go to the previous point before jump
- <kbd>Ctrl</kbd> + <kbd>i</kbd> : Go to the next point before jump
- <kbd>Ctrl</kbd> + <kbd>e</kbd> : Scroll up
- <kbd>Ctrl</kbd> + <kbd>y</kbd> : Scroll down

Related to macros :

- <kbd>q</kbd>\<name>\<macro><kbd>q</kbd> => record
- \<nombre><kbd>@</kbd>\<name> => call

Related to window spaces:

- <kbd>Ctrl</kbd> + <kbd>direction</kbd> : Change windows
- <kbd>Shift</kbd> + <kbd>direction</kbd> : Change dimensions
- <kbd>Ctrl</kdb> + <kbd>w</kbd> ; <kbd>\_</kbd> : Maximum height
- <kdb>Ctrl</kdb> + <kbd>w</kbd> ; <kbd>r</kbd> : Maximum width
- <kbd>Ctrl</kbd> + <kbd>w</kbd> ; <kbd>=</kbd> : Equal size windows

Related to auto-completion:

- <kbd>Ctrl</kbd> + <kbd>x</kbd> ; <kbd>Ctrl</kbd> + <kbd>l</kbd> : Complete
  the line
- <kbd>Ctrl</kbd> + <kbd>x</kbd> ; <kbd>Ctrl</kbd> + <kbd>f</kbd> : Complete
  from workspace file

### Mini.surround

In _Normal_ mode:

- <kbd>sr</kbd>\<symbole>\<new symbole> : Change surrounding
- <kbd>sd</kbd>\<symbole> : Delete surrounding

In _Visual_ mode

- <kbd>sa</kbd>\<symbole> : Surround selection

You can choose the symbol for the _input_ and the _output_ by using:

- any unique character,
- `t` for a tag (HTML kind)
- `?` for the interactive mode

In the case of the unique character, the left version will add a space (_e.g._ `(`)
whereas the right version will not (_e.g._ `)`). 

### Comment.nvim

- <kbd>leader</kbd> + <kbd>cc</kbd> : Comment
- <kbd>leader</kbd> + <kbd>ci</kbd> : Inverse comment / uncomment

### Telescope

- <kbd>leader</kbd> + <kbd>ff</kbd> : Walk through git files
- <kbd>leader</kbd> + <kbd>fg</kbd> : Walk through code
- <kbd>leader</kbd> + <kbd>b</kbd> : Walk through buffers

### Completion

When completion menu is opened:

- <kbd>Ctrl</kbd> + <kbd>e</kbd>: Complete or triger snippets
- <kbd>Ctrl</kbd> + <kbd>c</kbd>: Cancel completion
- <kbd>Ctrl</kbd> + <kbd>space</kbd>: Show or hide documentation

### LSP

- <kbd>leader</kbd> + <kbd>ld</kbd> => Go to definitions
- <kbd>leader</kbd> + <kbd>lr</kbd> => Rename
- <kbd>leader</kbd> + <kbd>lf</kbd> => Format
- <kbd>leader</kbd> + <kbd>lgt</kbd> => Go to type definition
- <kbd>leader</kbd> + <kbd>lgr</kbd> => Go to the reference
- <kbd>leader</kbd> + <kbd>lw</kbd> => Change workspace
- <kbd>leader</kbd> + <kbd>lca</kbd> => Code action
- <kbd>leader</kbd> + <kbd>lh</kbd> => Object informations
- <kbd>leader</kbd> + <kbd>ls</kbd> => Signatures

### Markdown

Using the markdown mode:

- <kbd>leader</kbd> + <kbd>wg</kbd>: Glowish markdown
- <kbd>leader</kbd> + <kbd>wu</kbd>: Go back to raw markdown

By default in _NeoVIM_:

- Format paragraphs:
  - <kbd>v</kbd> (and selection) + <kbd>gw</kbd>: unify size for line (old
    version)
  - <kbd>v</kbd> (and selection) + <kbd>gq</kbd>: unify size for line (old
    version of Neovim)

## Mode

### Visual

In visual mode it is possible to select the with:

- <kbd>iw</kbd> to select a specific word

## Commands

### Range

Many commands in NeoVIM can use a range to describe where the effect should
take place. The range can be:

- `%` to target the entire file

### Replace

In NeoVIM, replacing some text is done using RegExpr. It is triggered using
`:[range]s`.

```
:[range]s/{pattern}/{replacement}/flags
```

### Dot

`.` can be used to replay an action store in registers. For example you can
delete multiple lines with: `dd....`.

### Macros

You can register a macro by using `q<letter>`, then register the macro and
finish with `q`. The macro will be stored inside of `<letter>`. Once it is
done, you can _apply_ the macro with `@<letter>`. It is possible to mix it with
range. For example, you can apply it five times with `5@<letter>`. If you want
to apply the previous macro, you can run `@@`. It also works with ranges.

## Debugging Neovim

To print the variables, it is possible to use the
`print(vim.inspect(<variable>))` directive. The value can be found in
`:messages` at startup.

To inspect the `treesitter` tree, you can use `:InspectTree`.

## Resources

- [10 VIim shortcuts](https://catonmat.net/top-10-vim-shortcuts) (TO TRANSLATE)
- [Vim-advanced](https://thevaluable.dev/vim-advanced/) (TO TRANSLATE)
