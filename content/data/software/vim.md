+++
title = "Vim"
template = "data/page.html"
+++

## Raccourcis

 * Leader key   => space
 * Quitter mode =>  jk / kj

### Par défaut

 * <c-<direction>> => Changer de fenetre
 * <M-<direction>> => Redimensionnement
 * <TAB>           => Changer de buffer
 * <S-TAB>         => Changer de buffer arrière
 * <leader>bd      => Delete buffer
 * <leader>ss      => Stop recherche
 * <c-a>           => Décrémente
 * <c-x>           => Incrémente
 * macro
   * q<name><macro>q => enregistrement
   * <nombre>@<name> => appel

### Vim-surrounding

 * cs<symbole><new symbole> => Change surrounding
 * ds<symbole>              => Delete surrounding
 * ys => you surround
    * ysiw<symbole>  => Surround word
    * yss<symbole>   => Surround line
 * __VISUAL__
    * S<symbole> => Surround selection

### Nerdcommenter

 * <leader>cc => Commenter
 * <leader>ci => Inversion commentaires / pas commentaire

### Tabular

 * __VISUAL__
   * <leader>t=          => Tabulation sur =
   * <leader>tp<pattern> => Tabulation sur pattern

### Quick-scope

 * f<char> => Avancer à ce charactère
 * F<char> => Reculer à ce charactère

### FZF

 * <leader>ff => Parcours de fichiers git
 * <leader>fg => Parcours des fichiers avec regrep
 * <leader>b => Parcours des buffers

### NCM2

 * <c-e> => Expand snippets
 * <c-j> => Descendre
 * <c-k> => Monter
 * <c-c> => Annuler
 * <CR>  => Valider
 * <TAB> => Descendre
 * <S-TAB> => Monter

### LSP

<leader>ld => Go to definitions
<leader>lr => Renommage
<leader>lf => Formattage
<leader>lt => Aller la définition de type
<leader>lx => Aller à la référence
<leader>la => Modification du workspace
<leader>lc => Completion
<leader>lh => Information sur l'objet
<leader>ls => Affichage des symboles du documents
<leader>lm => Afficher le menu

### Mardown

 * <leader>md => Vue markdown
