---
id: typescript
aliases: []
tags: []
description: Typed JavaScript
lang: ENG
title: TypeScript
---

## Rest Parameters & Spread syntax

You can copy an object by doing:

```ts
const object = { /* Whatever */ };
const copye = { ...object };
```

To get a part of your object you can do:

```ts
const object : MyObject = 
	  {
		  stuff: string,
		  otherStuff: string,
		  other: /* Whatever */
	  };

function doStuff({
	stuff,
	...rest
}: MyObject) {
	console.log(stuff);
	return { ...rest }; /* Contains otherStuff and other */
}
```


### Resources

- [Digital Ocean](https://www.digitalocean.com/community/tutorials/understanding-destructuring-rest-parameters-and-spread-syntax-in-javascript)


## TS Config

### Resources

-[TS Config Cheat Sheet](https://www.totaltypescript.com/tsconfig-cheat-sheet) 
