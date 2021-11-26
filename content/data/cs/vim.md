+++
title = "Vim"
description = "Stuffs about (Neo)Vim."
template = "data/page.html"

[extra]
lang = "ENG"
+++

## Shortcuts

 * space => Leader key
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
