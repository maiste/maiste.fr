---
id: dune
aliases: 
tags: 
description: Quick summary about what I learned while on-boarding the Dune Project
lang: ENG
title: Dune
draft: true
---

## Dune Terminology

- **root**: `dune` build things from this directory. It knows how to build targets that are descendants of this directory.
	- Depending on the type of structure, it can be the top of a GitHub repository, a dune workspace (`%{workspace_root}`) or a project (`%{project_root}`).
- **workspace**: it refers to the **subtree** of a **root**. 
	- It can contain any number of **projects**. 
	- It contains a `dune-workspace` file.
- **project**: A collection of source files. It must include a `dune-project` file. 
	- It can contain multiple packages. 
	- The project is a hierarchy of directories which can all hold `dune` file (including the root). 
	- Projects can be shared.
- **package**: A set of libraries and executables installed as one.
- **installed world**: Anything outside a workspace. _Dune_ doesn't know how to build this.
- **installation**: Action of copying files from `<root>/_build` to the **installed world**.
- **scope**: (This part of the project is still unclear for me) It is defined by any directory with a `<package>.opam`. 
	- Most of the time, every project scope is a **subtree** starting from this directory. 
	- It sets the visibility of what is meant to be seen outside the scope. 
	- To make project deps available, it needs to by added in a `vendor` directory.
- **build context**: Specific configuration in a `dune-workspace` with a corresponding `<root>/_build` directory.  
	- It contains all the workspace build artifacts. 
	- There is always a `default` **build context**.
- **build context root**: The root of a build context. For example, if the context is `bar` is root is `<root>/_build/<bar>`
- **build target**: Specified on the command line. 
	- All targets that _Dune_ knows how to build are in the `<root>/_build` directory 
- **build profile**: a global setting that influences default configuration. 
	- It can be set with `--profile <profile>` or in the `dune-workspace` file.
	- There are two standard profiles: `dev` (stricter warnings) and `release`
- **alias**: **build target** that do not correspond to specific files.
	- Referred in the command line by `@<alias_name>`.
	- `@@<alias_name>` is  the same but, it is not recursive in subdirectories.
	- **aliases** are **per-directory**.
- **env**: default values of various parameters.
	- Each directory has an **env** attached to it.
	- In a scope, **env** is inherited from its parent.
	- At the **root* of a **scope**, there is a **default env**.
	- It can be altered with the **env** stanza (high level rule). 
- **dialect**: An alternative frontend to OCaml
	- Described by a pair of file extensions, one for interfaces and one for implementations.
	- Can use OCaml syntax or use a converter to OCaml AST.
	- Can have a custom formatter.
- **placeholder substitution**: build step where placeholders (e.g `%%VERSION%%`) are replaced by concrete values.


## Mental model

> TL;DR: a **rule** reads **dependencies** and produces **targets** using an **action**. It can be attached to **aliases**. 

- The model can be drawn as follows:
![Rule mental model](/static/images/Computer_Science/Tools/dune.rule_mental_model.svg)
- An **alias** can be seen as a rule with no **target**:
![Rule mental model](/static/images/Computer_Science/Tools/dune.alias_mental_model.svg)
- Interprets rules:
	- **Build a file**: check if the file is in the source tree or, if not, it checks if it is the target of a rule.
	- **Build an alias**: it executes all the rules attached to this alias.
	- **Execute a rule**: it builds the dependencies and when they are all satisfied, it runs the action (using the various caches).
- A **stanza** is a high level construction to generate **rules**

**N.B**: The set of rules and the dependency graph create a _Direct Acyclic Graph_ (DAG).

`(depends ...)` in package defines `opam` packages whereas `(libraries ...` defines archive in term of linking.

## Compile Dune

- Install and compile:
	- `opam switch create . --empty` to be sure to not build a switch with the wrong OCaml version. It **must** be compiled with `ocaml.4.14`.
	- `make dev-deps` to install dependencies.
	- `make dev` to build the full project.

- `bootstap.ml`:
	- `bootstrap.ml` is a small build system used to create `dune.exe`
	- `dune.exe` is the true `dune` that is copy to its Opam location.
- Schema of the build flow
```ascii
+---------------+                  +--------------------+
|               |                  |                    |
|  boostrap.ml  +---------+--------+  ocamlc / ocamlopt |
|               |         |        |                    |
+---------------+         |        +--------------------+
                          |                              
                          | Compile                      
                          |                              
                          |                              
                   +------v-----+                        
                   |            |                        
                   |  dune.exe  |                        
    +--------------+            |                        
    |              +------+-----+                        
    |                     |                              
    |                     |                              
    |                     |  Generate                    
    |                     |                              
    | Copy                |                              
    |             +-------v--------+                     
    |             |                |                     
    |             |  dune.install  |                     
    |             |                |                     
    |             +--------+-------+                     
    |                      |                             
    |                      |                             
    +----------------------+  Opam                       
                           |                             
                           |                             
                     +-----v------+                      
                     |            |                      
                     |    dune    |                      
                     |            |                      
                     +------------+                      
````

## Release process

- [Ref](https://github.com/ocaml/dune/wiki/Release-process)
- One minor version maintained at the time.
- Process:
	1. Ask the team about any know blockers.
	2. Mirage CI to ensure nothing breaks.
	3. Update the changelog with `doc/changes`
- Talk with Opam maintainer
- Only take care about regression issues

## Questions
- Is everything in the `_build`?
	- Almost everything and we almost never read outside.
	- Use fast copy mechanisms (hard links) to be fast.
	- Allow to keep the `dune clean <=> rm -rf _build` invariant.
- Do we have to manually update dependencies? 
	- Yes, but not always synchronize.
	- Add some patches.
	- Rebase can be complex...
- What is the `Fiber` module?
	- It is a concurrency monad.
	- Scheduler for processes.
- What is the `Memo.t` type for?
	- Two tasks for `dune`:
		- Read configs
		- Call actions
	- Keep in cache to reduce the number of external calls.
	- Like a spreadsheet with `Lazy` and `cell`.
	- Reduce performance cost and handle cache invalidation.
- Is everything in a `dune-workspace` or is a particular structure?
- Does `dune.exe` rebuild the entire version of dune?

## Pain Section

 > This section summarizes the pain point I encountered while working with Dune.
 
 - When rebuilding dune, if the `make boostrap` fails with `thread.posix` errors, you just need to restore `boot/libs.ml`, and rebuild.
 - If `ocaml-lsp-server` is broken, build the switch with `make dev-switch` and `make dev`. Then, pin the dune packages with `opam pin add . -n` and finally install the LSP with `opam install ocaml-lsp-server` and `ocamlformat`.
## Remember section

- We could rework the _# Working on the Dune Codebase_ section:
	- It can be moved at top level
	- It can be split in multiple section like in the [Tour of the Dune Codebase](https://dune.readthedocs.io/en/latest/explanation/tour/index.html)
## Resources

- [Dune Terminology](https://dune.readthedocs.io/en/latest/overview.html#terminology)
- [Dune Mental Model](https://dune.readthedocs.io/en/latest/explanation/mental-model.html)
- [Build Systems à la Carte](https://www.microsoft.com/en-us/research/uploads/prod/2020/04/build-systems-jfp.pdf)
- [Working on the Dune Codebase](https://dune.readthedocs.io/en/latest/hacking.html)


---

### Draft - FR

- Memo :
  - Ce qui se passe en mémoire: qu'est que je dois recalculer.
  - Etat existe que dans la RAM.
  - Invalidation passe par Memo comme pour le watch mode
  - C'est 1. une optimisation 2. recalculer ce qui doit être recalculer
- Action builder :
  - Ce qui se passe dans le répertoire _build
  - Ensemble de régle pour construire une target
- `-> unit Memo.t` est equivalent à effet de bord
- Les règles sont enregistrées dans `Memo`
- Les règles ajoutées par répertoire: un fichier Dune d'un coup
- `Action_builder.With_targets` est une monade qui lit et produit des fichiers
  dans `_build`. Distinction entre les règles qui peuvent faire des targets et
  celles qui ne peuvent pas en faire. Permet de savoir statiquement de savoir
  quelles targets vont être produites.
- `Action.t` est un type sum qui permet de décrire l'action. `Action.Full.t`
  offre des tags en plus.
- `Alias` décrit un ensemble de règles. Équivalent de stampfile pour Makefile.
- `Expander.t` :
  - Variable (`%{x}`).
  - Transforme une variable en valeur.
  - Faire le check sur les numéros de versions dans les variables.
-  `Locks`: sémantique de nom de fichiers
    - `Expander` traduit le nom
- `dune-site` permet de au programme de faire référence à des choses qui sont différentes à runtime.
