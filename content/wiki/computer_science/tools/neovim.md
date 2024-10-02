---
id: neovim
aliases: []
tags: []
description: Stuffs about (Neo)Vim.
lang: ENG
title: NeoVIM
---
## Environment

To run NeoVIM with a specific config located in `~/.config/<dir>`, you can pass it to the environment variable: 
```sh
$ NVIM_APPNAME=<dir> nvim
```
## Shortcuts

 * <kbd>space</kbd>: Leader key
 * <kbd>jk</kbd> / <kbd>kj</kbd> : Exit mode

### Par défaut

 * <kbd>Ctrl</kbd> + <kbd>direction</kbd> : Change windows
 * <kbd>Shift</kbd> + <kbd>direction</kbd> : Change dimensions
 * <kbd>TAB</kbd> : Change buffer
 * <kbd>Shift</kbd> + <kbd>TAB</kbd> : Change buffer from back
 * <kbd>leader</kbd> + <kbd>bd</kbd> : Delete buffer
 * <kbd>leader</kbd> + <kbd>ss</kbd> : Stop research
 * <kbd>Ctrl</kbd> + <kbd>a</kbd> : Decrement a number
 * <kbd>Ctrl</kbd> + <kbd>x</kbd> : Increment a number
 * <kbd>Ctrl</kbd> + <kbd>o</kbd> : Go to the previous point before jump
 * <kbd>Ctrl</kbd> + <kbd>i</kbd> : Go to the next point before jump
 * <kbd>Ctrl</kbd> + <kbd>e</kbd> : Scroll up
 * <kbd>Ctrl</kbd> + <kbd>y</kbd> : Scroll down
 * Macros:
   * <kbd>q</kbd>\<name>\<macro><kbd>q</kbd> => record
   * \<nombre><kbd>@</kbd>\<name> => call

### Vim-surrounding

 * <kbd>cs</kbd>\<symbole>\<new symbole> => Change surrounding
 * <kbd>ds</kbd>\<symbole>              => Delete surrounding
 * <kbd>ys</kbd> => you surround
    * <kbd>ysiw</kbd>\<symbole>  => Surround word
    * <kbd>yss</kbd>\<symbole>   => Surround line
 * __VISUAL__:
    * <kbd>S</kbd>\<symbole> => Surround selection

### Nerdcommenter

 * <kbd>leader</kbd> + <kbd>cc</kbd> : Comment
 * <kbd>leader</kbd> + <kbd>ci</kbd> : Inverse comment / uncomment

### Telescope

 * <kbd>leader</kbd> + <kbd>ff</kbd> : Walk through git files
 * <kbd>leader</kbd> + <kbd>fg</kbd> : Walk through code
 * <kbd>leader</kbd> + <kbd>b</kbd> : Walk through buffers

## Completion

__TODO__

### LSP

  * <kbd>leader</kbd> + <kbd>ld</kbd> => Go to definitions
  * <kbd>leader</kbd> + <kbd>lr</kbd> => Rename
  * <kbd>leader</kbd> + <kbd>lf</kbd> => Format
  * <kbd>leader</kbd> + <kbd>lt</kbd> => Go to type definition
  * <kbd>leader</kbd> + <kbd>lx</kbd> => Go to the reference
  * <kbd>leader</kbd> + <kbd>la</kbd> => Change workspace
  * <kbd>leader</kbd> + <kbd>lc</kbd> => Completion
  * <kbd>leader</kbd> + <kbd>lh</kbd> => Object informations
  * <kbd>leader</kbd> + <kbd>ls</kbd> => Document symbols
  * <kbd>leader</kbd> + <kbd>lm</kbd> => Display menu

### Mardown

-  <kbd>leader</kbd> + <kbd>wp</kbd> => Show markdown
- Format paragraphs:
	- <kbd>v</kbd> (and selection) + <kbd>gw</kbd>: unify size for line (old version)
	* <kbd>v</kbd> (and selection) + <kbd>gq</kbd>: unify size for line (old version of Neovim)
## Resources

* [10 VIim shortcuts](https://catonmat.net/top-10-vim-shortcuts) (TO TRANSLATE)
* [Vim-advanced](https://thevaluable.dev/vim-advanced/) (TO TRANSLATE)
