+++
title = "LaTex"
description = "About LaTex"

[extra]
lang = "ENG"
+++

## Installation of latex and minted on Ubuntu

* LaTex Installation:
```sh
 sudo apt install texlive texlive-latex-extra texlive-lang-french texmaker
```

* Minted dependencies:
```sh
 sudo apt install  python3-pygments
```

* In TexMaker, go in `Options > Configurer Texmaker` and add the following line
in `PdfLaTex`:
```
 pdflatex -shell-escape -synctex=1 -interaction=nonstopmode %.tex
```

* Minted example:
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
More examples in: [here](https://www.overleaf.com/learn/latex/Code_Highlighting_with_minted)

## Installation of latex and minted with Arch based

__TODO__

## Installation of the Metropolis theme 

* Install dependencies:
  * Ubuntu:
  ```sh
    sudo apt install latexmk texlive-xetex
  ```
* Install Metropolis with Git:
Link for the git repo: [here](https://github.com/matze/mtheme)
```sh
  cd /tmp
  git clone git@github.com:matze/mtheme.git
  cd mtheme/
  make sty && make install
```

Then you just need to change your latex with `\usetheme{metropolis}`.
To use __minted__ with Beamer, remember to add the `[fragile]` keyword:

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

## Makefile example with XeLaTeX

```Makefile
MAIN = main
MAIN_LATEX = $(MAIN).tex
PDF_TARGET = $(MAIN_LATEX:.tex=.pdf)
TARGET ?= $(PDF_TARGET)
LATEX = xelatex
FLAGS = --shell-escape -output-directory `pwd`/build
# BIBTEX = biber

all:
	mkdir -p build
	TEXINPUTS=$$TEXINPUTS $(LATEX) $(FLAGS) $(MAIN_LATEX)
	cp build/$(PDF_TARGET) $(TARGET)

release:
	mkdir -p build
	TEXINPUTS=$$TEXINPUTS $(LATEX) $(FLAGS) $(MAIN_LATEX)
  # $(BIBTEX) build/$(MAIN)
	TEXINPUTS=$$TEXINPUTS $(LATEX) $(FLAGS) $(MAIN_LATEX)
	cp build/$(PDF_TARGET) $(TARGET)

clean:
	rm -rf build $(PDF_TARGET)

```

## Resources

 * [LearnLaTex](https://www.learnlatex.org/en/): Learn LaTex
 * [Detexify](http://detexify.kirelabs.org/classify.html): Detect LaTex symbols
 * [Tex Stackoverflow](https://tex.stackexchange.com/questions/34175/how-do-i-create-a-latex-package): Write a LaTex package
