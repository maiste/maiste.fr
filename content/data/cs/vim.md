+++
title = "Vim"
description = "Stuffs about (Neo)Vim."

[extra]
lang = "ENG"
+++

## Shortcuts

 * <kbd>space</kbd> => Leader key
 * jk / kj => Exit mode

### Par défaut

 * \<c-<direction>> => Change windows
 * \<M-<direction>> => Change dimensions
 * \<TAB>           => Change buffer
 * \<S-TAB>         => Change buffer from back
 * \<leader>bd      => Delete buffer
 * \<leader>ss      => Stop research
 * \<c-a>           => Decrement a number
 * \<c-x>           => Increment a number
 * \<c-o>           => Go to the previous point before jump
 * \<c-i>           => Go to the next point before jump
 * \<c-e>           => Scroll up
 * \<c-y>           => Scroll down
 * Macros:
   * q\<name>\<macro>q => record
   * \<nombre>@\<name> => call

### Vim-surrounding

 * cs\<symbole>\<new symbole> => Change surrounding
 * ds<symbole>              => Delete surrounding
 * ys => you surround
    * ysiw\<symbole>  => Surround word
    * yss\<symbole>   => Surround line
 * __VISUAL__:
    * S\<symbole> => Surround selection

### Nerdcommenter

 * \<leader>cc => Comment
 * \<leader>ci => Inverse comment / uncomment

### Tabular

 * __VISUAL__:
   * \<leader>t=          => Tabular on =
   * \<leader>tp\<pattern> => Tabular on pattern

### Quick-scope

 * f\<char> => Move forward to character
 * F\<char> => Move backward to character

### FZF

 * \<leader>ff => Walk through git files
 * \<leader>fg => Walk through code
 * \<leader>b => Walk through buffers

### NCM2

 * \<c-e> => Expand snippets
 * \<c-j> => Up in snippets
 * \<c-k> => Down in snippets
 * \<c-c> => Cancel
 * \<CR>  => Apply
 * \<TAB> => Up
 * \<S-TAB> => Down

### LSP

  * \<leader>ld => Go to definitions
  * \<leader>lr => Rename
  * \<leader>lf => Format
  * \<leader>lt => Go to type definition
  * \<leader>lx => Go to the reference
  * \<leader>la => Change workspace
  * \<leader>lc => Completion
  * \<leader>lh => Object informations
  * \<leader>ls => Document symbols
  * \<leader>lm => Display menu

### Mardown

 * \<leader>md => Show markdown
 * \<leader>wp => Use glow to display the markdown


## Resources

* [10 VIim shortcuts](https://catonmat.net/top-10-vim-shortcuts) (TO TRANSLATE)
* [Vim-advanced](https://thevaluable.dev/vim-advanced/) (TO TRANSLATE)
