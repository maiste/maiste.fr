---
id: web
aliases: []
tags: []
description: Javascript, Typescript and Co. Messy notes to be split
language: fr
title: WebDev - Front
---

### Terminologie

- _DOM_: Document Object Model. Représentation du Document.
- _Bundler_: create a unique file with all the code needed. Avoid dealing with `import`.
- _SPA_: Single Page Application: the application lives in a single html page.
- _IIFE_:  Immediately Invoked Function Expression i.e ancêtre de _ESModule_

### NPM

- `npm install` or `: installe le packages spécifié dans le `package.json``
- `npm install -D`: installe le package spécifié dans le `package.json` comme une dépendances dev
- `npm <script>`: run the script specified in the `package.json`


## Javascript

### Pièges

- Attention au scope de `this` qui est dans une `function() {}` car il prend le scope de l'appelant:
```js
class Truc {
    constructor(this) {
        this.msg;
    }
    print() {
        setTimeout(function(){
            console.log(msg);
        }.bind(thi))
    }
 

    /* Sont équivalents */
    print() {
        setTimeout(() => ){
            console.log(msg);
        })
    }
}
```

### Import / export

- `export` ne peut être utiliser qu'à la racine du fichier.
- On a le `default` import mais pour permettre le _Tree Shaking_, on doit utiliser `import { X, Y } from "./path";`

### Typescript


#### Infos

- Activer les `compilerOptions` à `"strict" : true` pour s'assurer qu'il fasse le
maximum.


#### Types

On peut avoir une énumération de string à partir des clefs d'un objet:
```typescript
type Point = {
    x: number,
    y: number
}

// "x" | "y"
type KeyPoint = keyof Point

// z = "x" ou z = "y"
function call(z : KeyPoint) {
    return z;
}
```

### Webrowser

- Utiliser la console pour débugguer, c'est fait pour.

### Storage

#### LocalStorage

Stockage natif des browser mais n'utilise pas `indexedDB` donc moins de fonctionnalités.

#### LocalForage

Stockage qui repose sur localStorage mais support l'asynchrone.

## Bundler

- Il résout les imports en faisant un fichier avec tout !
- Il fonctionne avec `require/module.exports` et les `export/import`.

### Webpack

- La configuration se fait dans un `webpack.config.js`. Le fichier produit est dans `dist/main.js`
- Il prend un unique point d'entrée.
- En cas de changement dans le `webpack.config.js`, il faut restart le serveur.


### Transpiler

- `Babel` transpile vers du "vieux" (ES5) Js pour assurer la compatibilité des fonctions JS. _Polyfills_ étends les capacités de "transpilage" de Babel.
- `Core-js` est un _Polyfills_.
- `Babel` a besoin d'avoir `babel-loader` pour fonctionner avec `webpack`.

## SASS

- Un `css` est un `sass` valide.
- On définit les données partielles dans les fichiers commençant par `_name.scss`. Il peut ensuite être chargé à un autre endroit via `@use "./name";`.
- `min-heigth: 100vh` signifie que le composant prend au moins la taille de la vue. En utilisant un container  `flex, column` et en assignant "`margin-top: auto", le composant
se place en bas.

## CSS

- Pour merger facilement les propriétés de tailwind :
	```js
	import { type ClassValue, clsx } from "clsx";
	export function cn(...inputs: ClassValue[]) {
	  return twMerge(clsx(inputs));
	}
	```

## Tools

### ESLint

- Avec `create-react-app`, tout est déjà installer. Il faut juste lancer `npm init @eslint/config` et ne pas installer les dépendances.
- Il faut ajouter `plugin:react/jsx-runtime` dans la list `extends` du _.eslintrc.json_.

### Prettier

- On peut l'installer avec: `npm install prettier@^version -D --save-exact`
- `npx prettier --check .`: permet de vérifier les règles dans le code.
- `npx prettier --write .`: modifier les fichiers avec le bon formatage.

- `npm install --save-dev eslint-config-prettier@^8.5.0` permet de partager la config du linter et du formateur
- `npm install --save-dev eslint-plugin-prettier@^4.2.1` permet d'avoir un plugin de linter pour eslint qui regarde le formatage.

- Dans ce cas, il faut penser à étendre la configuration _.eslintrc.json_ avec:
```json
{
  "extends": [
    "some-other-config-you-use",
    "plugin:prettier/recommended"
  ]
  ...
  "plugins": [..., "prettier"]
}
```

### Mrm

- Permet d'automatiser la configuration des fichiers en se basant sur la configuration présente.

### Husky

- Git hooks pour en JS.

## CJS vs ESM

- Lire la doc de https://antfu.me/posts/publish-esm-and-cjs
## Module Bundlers: Webpack

Webpack is a module bundler that allows to resolve dependencies to make file exportable via the web.

## Optimise the code

* [You might not need jQuery](https://www.joshwcomeau.com/performance/embracing-modern-image-formats/): when you can do it in CSS and vanilla JavaScript
* [Embracing modern image format](https://www.joshwcomeau.com/performance/embracing-modern-image-formats/): use webP if you can
