+++
title = "LaTex"
template = "data/page.html"
+++

## Installation latex et minted

* Installation de latex :
```sh
sudo apt install texlive texlive-latex-extra texlive-lang-french texmaker
```

* Installation des dépendances de minted:
```sh
sudo apt install  python3-pygments
```

* Dans texmaker, aller dans `Options > Configurer Texmaker` et ajouter la ligne
suivante à la place de `PdfLaTex`:
```
pdflatex -shell-escape -synctex=1 -interaction=nonstopmode %.tex
```

* Exemple code minted:
```latex
\begin{minted}{python}
import numpy as np
    
def incmatrix(genl1,genl2):
    m = len(genl1)
    n = len(genl2)
    M = None #to become the incidence matrix
    VT = np.zeros((n*m,1), int)  #dummy variable
    return M
\end{minted}
```
Pour plus d'exemples : [ici](https://www.overleaf.com/learn/latex/Code_Highlighting_with_minted)

## Installation du thème Métropolis

* Installation des dépendances:
```sh
sudo apt install latexmk texlive-xetex
```

* Installation de métropolis avec Git:

Lien du git: [ici](https://github.com/matze/mtheme)

```sh
cd /tmp
git clone git@github.com:matze/mtheme.git
cd mtheme/
make sty && make install
```

Et après, il suffit de changer `\usetheme{metropolis}` qui est par défaut dans le pdf de rendu.
Pour utiliser __minted__ avec Beamer, il faut penser à spécifier le mot clef `[fragile]` avant:
```latex
\begin{frame}[fragile]{Frame}
\begin{minted}{c}
int main() {
  printf("hello, world");
  return 0;
}
\end{minted}
\end{frame}
```

## Ressources

 * [LearnLaTex](https://www.learnlatex.org/en/): Site pour apprendre le LaTex
 * [Detexify](http://detexify.kirelabs.org/classify.html): Permet de détecter le symbole en LaTex
 * [Tex Stackoverflow](https://tex.stackexchange.com/questions/34175/how-do-i-create-a-latex-package) : Créer un package en LaTex
