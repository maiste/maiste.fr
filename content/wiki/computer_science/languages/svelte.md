---
id: svelte
aliases: []
tags: []
description: Frontend Javascript & Typescript
lang: FR
title: Svelte
---

## Syntaxe

- Utilise les extensions `.svelte`.

### Variables

- On ajoute la partie scripting via les balises `script`.
- On peut appeler les variables en utilisant `{var_name}`.

```html
<script>
    let name = "Mon nom"
</script>

<h1>Tu es {name}</h1>
```

- Dans le cas où l'attribut a le même nom que la variable on peut faire un raccourci synthaxique :
```html
<script>
    let src = "./file.gif";
</script>

<img src={src} />
<!-- est équivalent à -->
<img {src} />
```

- On peut aussi permettre l'utilisation de code Html __non vérifié__:
```html
<script>
    let balise = "<strong>Code en gras</strong>
</script>

<p>{@html balise}</p>
```

### Style

- On peut rajouter du style grâce à la balise `<style>`.
- Ce style ne s'applique qu'au composant associé.

```html
<p>Coucou</p>

<style>
    p {
        background-color: green;
    }
</style>
```

### Reactivité

- Quand l'état du composant change, _Svelte_ met automatiquement l'état à jour.
- On peut synchroniser l'état de l'application avec l'état du DOM en réponse à des événements :
```html
<button on:click={increment}>
	Clicked {count}
	{count === 1 ? 'time' : 'times'}
</button>
```
- L'attribut `on:<event>={<function>}` permet de spécifier l'événement et la fonction à utiliser.
- On peut ajouter des _modifiers_ avec `on:<event>|<modifier>|<modifier>={<function>}`. Ils peuvent être :
    - `preventDefault` évite le comportement par défaut.
    - `stopPropagation` ne propage pas aux autres éléments.
    - `passive` améliore le _scroll_.
    - `nonpassive`: _set_ `passive` à `false`.
    - `capture` lance le handler pendant la phase de _capture_ plutôt que la phase _bubbling_. Dans les faits inverses le rapport de gestion des événements du haut vers le bas.
    - `once` ne lance l'événement qu'une fois.
    - `self` ne s'active que si la _target_ de l'_event_ est nous-même.
    - `trusted` ne s'active que si les éléments est _trusted_ parce qu'il a été déclenché par un action utilisateur plutôt que du code _JavaScript_.
- On peut avoir des _events_ de composants :
    - _Inner.svelte_:
    ```html
    <script>
        import { createEventDispatcher } from 'svelte';

        const dispatch = createEventDispatcher();

        function sayHello() {
            dispatch('message', {
                text: 'Hello!'
            });
        }
    </script>

    <button on:click={sayHello}>
	    Click to say hello
    </button>
    ```
    - _App.svelte_:
    ```html
    <script>
        import Inner from './Inner.svelte';

        function handleMessage(event) {
            alert(event.detail.text);
        }
    </script>

    <Inner on:message={handleMessage} />
    ```
    - Dans le cas où l'on a des composants avec des événements (du DOM ou générer par l'utilisateur) que l'on veut forward, on peut le passer avec :
    ```html
    <Component on:message />
    ```
- Pour dire à un composant enfant de mettre à jour la valeur parent, on peut utiliser `bind` :
```html
<script>
    let name = "truc";
</script>

<input bind:value={name} />
```
- `bind:group={variable}` permet de _binder_ plusieurs _inputs_ sur la même variable.
- Un `<select>` avec `multiple` permet de faire un `bind:value={variable}` qui va mettre à jour la valeur comme un tableau.
- Les _Reactive declarations_ permettent à _Svelte_ de recalculer des variables à partir d'autres :
```html
<script>
    let count = 0;
    $: doubled = count * 2
</script>
```
- Ces _Reactive Declarations_ peuvent être utilisés avec des blocs, des `if`, etc :
```html
<script>
$: {
    // Put something here
}

$: if (condition) {
    // Do something!
} /* else {

} */
</script>
```
- La réactivité de _Svelte_ n'est _trigger_ que grâce à des __assignations__. Ce qui veut dire que les méthodes de modifications __en place__ ne marchent pas. Il faut faire un réassignation pour que cela soit effectif !
- Pour les objets, il faut que cela soit fait directement sur l'objet qui contient la __propriété__. Cela ne fonctionne pas avec les alias tel que :
```html
<script>
let foo = obj.foo;
foo.bar = "bar"; // Don't redraw obj
</script>
```

### Export

- On peut exporter les propriétés d'un fichier via `export` et passer en paramêtre :
    - _App.svelte_:
    ```html
        <script>
            import Nested from './Nested.svelte';
        </script>

        <Nested answer={42} />
    ```
    - _Nested.svelte_:
    ```html
        <script>
            export let answer;
        </script>

        <p>La réponse est {answer}</p>
    ```
- On peut définir une valeur par défaut avec :
```html
    <script>
        export let anwser = "Default value";
    </script>
```
- Dans le cas où les propriétés d'un __objet__ sont les mêmes que celles du composant, on peut passer le composant. Pour le cas du `Nested` au dessus, on pourrait faire :
```html
    const obj = {
        answer: 42
    };

    <Nested {...obj} />
```

### Structures de contrôles

- On peut faire des blocs de `if` :
```html
{#if condition}
    <!-- Code html -->
{/if}
```
- Il y a également un bloc `else` :
```html
{#if condition}
    <!-- Code html -->
{:else}
    <!-- Autre code html -->
{/if}
```
- Il y a un bloc `else-if` :
```html
{#if condition}
    <!-- Code html -->
{:else if condition}
    <!-- Code html 2 -->
{:else}
    <!-- Code html 3 -->
{/if}

```
- On peut faire des boucles `for` :
```html
{#each iterables as iterable}
    <!-- Code html -->
{/each}
```
- On peut récupérer l'index avec de la boucle `for` :
```html
{#each iterables as iterable, index}
    <!-- Code html -->
{/each}
```
- Dans le cas où l'on manipule des objets complexes, il faut spécifier dans la boucle comment identifier les objets à afficher pour que _Svelte_ sache comment garder le _DOM_ cohérent. Ici, l'attribut est identifié avec son `id` :
```html
{#each things as thing (thing.id)}
	<Thing name={thing.name}/>
{/each}
```

### Asynchrone

- On peut faire un bloc `async / await` :
```html
{#await promise}
    <!-- Code html d'attente -->
{:then res}
    <!-- Code html de résolution -->
{:catch error}
    <!-- Code html de gestion d'erreur -->
{/await}
```
- On peut simplifier ce bloc en cas de besoin:
```html
{#await promise then number}
    <!-- Code html -->
{/await}
```

## Cycle de vie

-  `onMount` correspond au moment où le composant est rendu pour la première fois au niveau du DOM.
- `beforeUpdate` correspond au moment juste avant la mise à jour du DOM.
- `afterUpdate` correspond au moment juste après la synchronisation du DOM.
- `tick` renvoie une `Promise` qui est appelée quand n'importe quel changement a été appliqué au DOM.
- `onDestroy` correspond au moment où un composant est détruit.

## Stores

- On peut créer des stores avec :
```js
import { writable } from 'svelte/store';

export const count = writable(0);
```
- On peut ensuite souscrire aux modifications d'un store :
```js
const unsubscribe = count.subscribe((value) => {
    // Action
})
```
- On peut utiliser le méchanisme d'auto souscription avec :
```html
<script>
let v = $count
</script>
<!-- Ou dans le HTML -->
<h1>La valeur est {$count}</h1>
```
- Un store peut être seulement en lecture seule : 
```js
export const time = readable(new Date(), function start(set) {
	const interval = setInterval(() => {
		set(new Date());
	}, 1000);

	return function stop() {
		clearInterval(interval);
	};
});
```
- On peut utiliser des stores qui fonctionnent à partir d'autres stores :
```js
const start = new Date();

export const elapsed = derived(
	time,
	($time) => Math.round(($time - start) / 1000)
);
```
- On peut également fabriquer des _stores_ _customs_ : 
```js
function createCount() {
	const { subscribe, set, update } = writable(0);

	return {
		subscribe,
		increment: () => update((n) => n + 1),
		decrement: () => update((n) => n - 1),
		reset: () => set(0)
	};
}
```
- Un store peut être associé à une valeur changeante avec `bind`.
