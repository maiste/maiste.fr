---
id: java
aliases: 
tags: 
description: Java Programming Language
lang: FR
title: Java
---

## Extra

### Reified type for function
- En Java, pour permettre au typeur d'avoir le type on doit normalement faire : 
```java
public <T> T function(Class<T> valueType) {
	// Content
}

// Call
Truc t = function(Truc.class) 

```
- Une méthode pour pourvoir rendre le typeur heureux sans avoir à passer la classe est d'utiliser les types réifiés qui fonctionnent en Java sur les tableaux (pas les génériques).
	```java
	public <T> T function(T... reified) {
	 // Content
	}
	// Call
	Truc t = function()
	```

> Source : [ici](https://maciejwalkowiak.com/blog/java-reified-generics/)


## Spring

### Json

- Pour supporter le nommage en snake case : 

```java
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
```
