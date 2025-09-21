---
id: kotlin
aliases: 
tags: 
description: Kotlin Programming Language
language: fr
title: Kotlin
---

## Overview

- Équivalent de bibliotèques Java:
    -    `MockK`: Mocking
    - `KtLint`: Linter
    - `Koin`: injection de dépendances.

## Variables

- Possède l'inférence de types.
- Déclaration :
    - `val` déclare une valeur immutable.
    - `var` une valeur mutable.
- Pas de getter et de setter
- pas de mot clef `static`.
- On peut _override_ les _getters_ et les _setters_ (en utilisant le mot clef `field`):
    ```kotlin
    val truc : Int = 0
        get() = field + 1

    var mutableInt =°
        set(value) {
            field = value
        }
    ```
- On peut définir des constantes avec `const`.
- `lateinit var x : Truc` permet de choisir la valeur via une méthode.
- _Null safety_:
    - Pas de `null` par défaut.
    - On ajoute `?` pour autoriser le `null` avec:
    ```kotlin
    var null : String? = null
    ```
    - `if (b != null) {}` pour checker sur les valeurs immutables.
    - `x?.length` renvoie `null` ou la valeur.
    - `val x = l ?: -1` renvoie l s'il n'est pas null, -1 sinon.
    - `value!!.length` transfort la valeur de gauche en un non-`null`.

## Méthodes

- On définit une méthode comme suit:
```kotlin
fun <name>(param : Type, param: Type = <défaut>) : Type {

}
```
- Le type de retour par défaut est `Unit`
- On peut utiliser les paramètres nommées.
- On peut définir des paramètres par défaut.
- On peut faire des méthodes expression et des méthodes infix:
```kotlin
// Expression
fun plusOne(param : Int) : Int = param + 1

// Infix
infix fun plusOne(param : Int) : Int = param + 1
```
- On peut étendre des classes avec des nouvelles méthodes :
```kptlin
fun <Class>.method() : String {
    return "$This?"
}
```
- `inline` copie le corps de la méthode où il est appelé. Bien pour les _getters_, les _setters_ et les petites _lambdas_.
- On peut overloader les opérateurs `+`, `-`, `*` et `/` avec:
```kotlin
operator fun plus(param : Type) : Type {
    val newValue = param.value + 1
    return new Type(newValue)
}
```
- Utilisation des lambdas :
```kotlin
val x : (t : Type) -> AutreType = { variables -> corps}
```
- On peut faire une lambda sans variable avec `{ corps }`

## Classe

- Constructeur par défaut vide ou complet en fonction des paramètres.
- Possible d'ajouter des constructeurs avec :
```kotlin
class Truc(truc : Type) {
    constructor(param : Int, param2 : Int) : this(Type(param + parm2))
}
class Truc(var truc : Type) {
    // truc est un class field ici.
}
```
- Par défaut, classes et membres `final`. Il faut ajouter `open` pour permettre l'héritage et `open` sur les méthodes pour permettre l'héritage :
```kotlin
open class C {
open val myValue = 1
}

class D : C() {
    override val myValue = 0
}
```
- On peut utiliser `init { }` comme bloc constructeur.
- On peut faire un bloc `static` en ajoutant soit la valeur au _top level_, soit un `object / companion object { }`.
- Le _nesting_ est autorisé.
- `data class` est un équivalent des records.
- Les enumérations sont déclarées avec le mot clef `enum class {}`
- `object` permet de faire des _singletons_.

## Flot de contrôle

### For

- `for (i in start..end)`
- `for(i in start until end)`
- `for (i in start until end step inc)`
- `for (content in data)`
- `data.forEach()`

### If

- Fonctionne pour checker `null`, mais sur les `val` uniquement.
- `if'(truc) corps else corpsElse` est une expression.

### When

- Remplace le mot clef `switch`.
- Permet de faire du pattern matching :
```kotlin
when(i) {
    is Int -> truc
    is String -> truc
    else -> default case ou {}
}
```
- Plusieurs mot clefs :
```kotlin
when(i) {
    0 -> truc
    1 -> autre truc
    in start..end -> truc
    else -> default case
}
``
- Il s'agit d'expression également donc on peut l'assigner.
```

## Scope functions

- `data.let { }` permet d'accès à l'objet via le mot clef `it`. Renvoie le resultat de la lambda.
- `with(data) { }` fait la même chose que `let` mais référence l'objet avec `this` et n'est pas une méthode sur un objet. Renvoie le resultat de la lambda.
- `data.run { }` fonctionne pareil que `let` mais en important l'object comme `this` et non comme une variable. Renvoie le resultat de la lambda.
- `data.apply {}` prend l'objet et fait la même chose que `run` avec `this`. Il renvoie l'objet lui même cependant.

## Interfaces

- Permet de définir des valeurs par défaut et _getters_ et _setters_.
```kotlin
interface Truc {
    var test  : Int get() = 1
}

class Bidule : Truc, Truc2 {
 // corps
}
```

## Abstract class

- À faire.

## Génériques

- On peut déclarer des génériques de la même manière que Java
```kotlin
class Truc<T> {
    // Corps
}
```
- Kotlin fournit `in` et `out` pour spécifier les types d'entrée et de sortie :
- `out T` ne peut qu'être utilisé en sortie.
```kotlin
interface Produce<out T> {
    fun produce() : T
}
```
- `in T` ne peut être utilisé qu'en entrée :
```kotlin
interface Consume<in T> {
    fun consume(t :T)
}
```
- On peut passer des contraintes comme Java avec `<T : Type>`
- Si on ne connait pas le type que l'on doit créer, on peut passer `*`.
- On peut utilise `reified` avec les méthodes `inline` pour vérifier le type de retour :
```kotlin
inline fun <reified T> method(p : Any) {
    return p as T
}
```

## Type alias

- Ajoute du sucre syntaxique pour les types avec `typealias Truc = Int`

## Modifiers

- Par défaut ce qui est à top level est `public`. 
- On peut ajouter le mot clefs `private` pour rendre privé à la classe. Attention ce n'est pas accessible depuis les classes mères.
- `internal` est privé au module.
- `protected` authorise aux sous classes aussi.

## Coroutines

- Threads légères. Une coroutine est coopérative à la différence d'une thread.
- On peut récupérer le resultat avec `Class.async`.
- On peut utiliser `await()` pour avoir le resultat et `cancel()` pour stopper.
