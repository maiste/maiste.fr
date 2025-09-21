---
id: react
aliases: []
tags: []
description: Bibliotèque React JS
language: fr
title: React
---

## Philosophie

### Introduction

- Dev par Facebook en 2013
- JSX (aujourd'hui TSX)
- Approche composant avec une gestion du cycle de vie et des états locaux (states)

### Version notables

- `16.0` (2017) -> `Fragments`, changement dans le cycle de vie, Server Side Rendering
- `16.3` (2018) -> `Context API`
- `16.8` (2019) -> `Hooks`
- `18` (2022) -> `Concurrent` management

### Architecture

```ascii
                        ┌───────────────────┐
                        │                   │
                        │  React Component  │
     Props  ──────────► │                   │ ──────────►   render
                        │  - State          │
                        │                   │
                        └───────────────────┘
```

#### Props

- C'est récupéré depuis le composant qui instancie. C'est une ressource immutable :
```tsx
class Cat extends React.Component {
  render() {
    return <h1>{this.props.name} section</h1>;
  }
}

class App extends React.Component {
  render() {
  return (
    <div>
     <Cat name=”Jim” />
    </div>
  );
  }
}
```

#### States

- C'est limité au composant, modifiable et asynchrone:
```tsx
class Cat extends React.Component {

 constructor(props) {
   super(props);
   this.state = {
	name: “Jim”
   };
 }

  render() {
    return <div>{ this.state.name }</div>;
  }
}
```

#### Nouvelle version

- On est passé d'une approche `Class component` à une approche `Functional component`:
```tsx
class Cat extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}</h1>;
  }
}
```
devient
```tsx
function Cat(props) {
    return <h1>Hello, {props.name}</h1>;
}
```

### Cycle de Vie

```ascii

             ┌─────────────────────────┐    ┌──────────────────────┐   ┌────────────────────────┐
             │                         │    │                      │   │                        │
             │   Mounting              │    │   Updating           │   │ Unmounting             │
             │                         │    │                      │   │                        │
             │                         │    │                      │   │     │                  │
             │   Constructor           │    │                      │   │     │                  │
             │                         │    │                      │   │     │                  │
             │         │               │    │                      │   │     │                  │
             │         │               │    │                      │   │     │                  │
             │         │               │    │                      │   │     │                  │
             │         │               │    │                      │   │     │                  │
             │    ┌────▼───────────────┼────┼─────────────┐        │   │     │                  │
             │    │                    │    │             │        │   │     │                  │
             │    │           render   │    │             │        │   │     │                  │
             │    │                    │    │             │        │   │     │                  │
             │    └────────┬───────────┼────┼────────┬────┘        │   │     │                  │
             │             │           │    │        │             │   │     │                  │
             │             │           │    │        │             │   │     ▼                  │
             │             ▼           │    │        ▼             │   │                        │
             │                         │    │                      │   │                        │
             │   ComponentDidMount     │    │ ComponentDidUpdate   │   │  ComponentDidUnmount   │
             │                         │    │                      │   │                        │
             │                         │    │                      │   │                        │
             └─────────────────────────┘    └──────────────────────┘   └────────────────────────┘

```

<hr />

## Code

### Fragments

- Permet de rendre des composants HTML au même niveau sans avoir besoin de "nested":
```tsx
<>
    /* Mon code */
</>
```
est équivalent à
```tsx
<Fragment>
/* Mon code */
</Fragment>
```

### Keys

- Penser à utiliser les _keys_ dans les composant pour permettre à `React` de faire le rendu dans le bon sens.

### Get Started

Pour créer une app `React` avec `npx`, on utilise _Create React App_ (CRA) :
```sh
  npx create-react-app front --template typescript
  cd front
  npm start
```

<hr />

## Router

- Avec react on peut avoir un router qui manipule l'API `history` du DOM Html. Le package à installer est le suivant: `react-router-dom@6`

<hr />

## Context

Les _Context_ permettent de partager des données en profondeur dans l'arbre sans avoir besoin de passer les éléments à travers les `props`.
Il possède deux éléments clefs:
- `Provider` qui déclare et fournit les données du contexte.
- `Consumer` qui conomme et récupère les données du contexte

<hr />

## Redux

- Permet de faire ce que fait les _Context_ avant leur introduction.
- Il possède un état global appelé le __Store__.
- C'est une __conteneur à état prédictible_: en fonction des inputs, on peut prévoir l'état suivant.
- Les _actions_ sont déclenchées par les composants _React_ et modifie l'état du Store
- La réponse est produite et récupérée par un _reducer_ qui fabrique un nouvel état du store à partir de l'état __précédent__ et de la réponse de l'__action__.
- Pour l'action, utilisation de __fonctions pures__ : (pas de variations de sorties pour les mêmes arguments + pas d'effets de bord).
- Les _selectors_ permettent d'obtenir le resultat depuis le store.

<hr />

## Test

### React Testing Library (RTL)

- Permet d'interagir avec les composants _React_.

### Smoke test

- Permet de vérifier qu'un composant s'affiche sans crash.

### Snapshot test

- Vérifier si le rendu d'un html est bon.

### Mock test

- permet de vérifier que les composants s'affichent comme il le faut.

<hr />

## Formulaire

### Uncontrolled vs controlled component

- Les _Uncontrolled components_ sont des composants qui sont gérés par le `DOM` html.
- Les _Controlled components_ sont des composants dont l'état interne est géré par React.

### Uncontrolled

Pour faire un _uncontrolled_, on définit une référence que l'on donne en attribut :
```tsx
// Valeur de input est accessible via nameInputRef.current.value
// Nous devons utiliser defaultValue pour initialiser l'input
function NameFormUncontrolled({defaultValue}: {defaultValue: string}) {
  const nameInputRef = useRef<HTMLInputElement>(null);
  return (
    <div>
      <input defaultValue={defaultValue} ref={nameInputRef} placeholder="name" />
    </div>
  );

```

### Controlled

- On récupère l'état interne via un _State_ :
```tsx
function NameFormControlled() {
  const [name, setName] = useState("");
  return (
    <div>
      <input
        onChange={(inputEvent) => setName(inputEvent.target.value)}
        defaultValue={name}
      />
    </div>
  );
}
```

### React Hook Form

Il s'agit d"une bibliotèque permettant de construire un formulaire sans avoir trop de code redondant.

```sh
npm install react-hook-form
```
