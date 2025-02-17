---
id: golang
aliases: []
tags: []
description: About Golang.
draft: true
lang: ENG
title: Golang
---

## Install

<!-- TODO -->

## Syntax

### Declare a package

```go
package <name>
```

### Import packages

```go
import (
    "fmt"
    "math/rand"
)
```
or (bad one)
```go
import "fmt"
import "math/rand"
```

Convention is that the package name is the last element of the import path. For `x/y/z`, it would be `package z`.

### Functions

Arguments in a function comes after the name declaration:
```go
func my_function_name(arg type, arg2 type2) returnType {
    return
}
```

If two arguments have the same type, it can be shortened:
```go
func f(x, y int) int {
    return x + Y
}
```

You can return any number of results:
```go
func f(x,y int) (int, int) {
    return y, x
}
```

You can returned name values that you specify in the return type. It is called "naked return"
```go
func f(i int) (x,y int) {
    x = 0
    y = 0
    return
}
```

### Exported names

If names start with a **capital letter** it is **public**, otherwise it is **private**.

### Var

You can declare variables at package or function level with:
```go
var x, y int
var z string
```

They can be initialise using an inializers. In this case, **type** can be **ignored**:
```go
var x, y, z = 1, "c", false
```
or
```go
var (
    x = false
    y = "c"
)
```

If you need to do an assignement, there is the short assignement statement:
```go
i := 1
x,y := 1, "hehe"
```

### Types

Basic types are:
- `bool` (default: `false`)
- `int`, `int8`, `int16`, `int32`, `int64` (default: `0`)
- `uint`, `uint8`, `uint16`, `uint32`, `uint64`, `uintptr` (default: `0`)
- `float32`, `float64` (default: `0`)
- `complex64`, `complex128` (default: `0`)
- `byte` which is an alias for `uint8`
- `rune` which is an alias for `int32`. This a representation for Unicode code point
- `string` (default: `""`)

## Entrypoint

Programs start running in package `main`.


