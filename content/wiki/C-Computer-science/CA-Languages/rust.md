---
id: rust
aliases: 
tags: 
description: Rust Programming Language - Low level language
lang: en-GB
title: Rust
---

## Basics

- `std` is the standard `rust` library.
- Libraries brought into the scope by `rust` from the `std` library are called _the prelude_.
- _Statements_ are instructions that perform some action and do not return a value.
- _Expressions_ evaluate to a resultant value. They don't end with a _semicolon_.

## Syntax

### Comments

- They are always the same:
 ```rust
// Rust use only the one line comment
// so you don't have to worry about various
// styles!
```

### Main

- This is how you start a rust program:

```rust
fn main() {
    // Program
}
```

### Imports

- Bring some library into the scope:
```rust
use std::io;
```

### Constants and variables

- Immutable variable:
```rust
let x = 5;
let x = 6;
// Forbidden: x = 6
```
- Mutable variable:
```rust
let mut x = 5;
x = 6;
```
- Constants:
```rust
const I_AM_A_CONSTANT: u32 = 42;
```

### Tuples

```rust
let tuple: (i32, f32, bool, char) = (500, 6.4, true, 'a');
let (i,f,b,c) = tuple; // Deconstruction
let f = tuple.1; // Field access
```

### Arrays

```rust
let x = [1,2,3,4,4];
let x: [i32; 5] = [1,2,3,4,4];
let x = [4; 5]; // = [4, 4, 4, 4, 4];
let first = x[0];
```

### Functions

```rust
fn function_name(arg: i32) -> i32 {
    return arg + 2;
}
```

### Printing

- We can print value using `println!` placeholders:
```rust
let x = 1;
let y = 2;

println!("x = {x}, y = {}", y);
```

### Pattern matching

```rust
let x = match res {
    Ok(num) => num,
    Err(_) => continue,
}
```

### If-then-else

- `if-then-else` acts like a variable and can be consume by a variable or as a return expression from a function.
```rust
if boolean_expression {
    // Case one!
} else if another_expression {
    // Another case!
} else {
    // Final case!
}
```

### Loop

- _Infinity loop_:
```rust
loop {
    // Need a break; to leave this loop.
}
```
- _Infinite loop_ with return result:
```rust
let mut counter = 0;
let result = loop {
    counter += 1;
    if counter == 10 {
        break counter * 2;
    }
};
```
- Loop _label_:
```rust
'label: loop {
    break 'label;
}
```
- _While_ loop:
```rust
let mut number = 10;
while number != 0 {
    number -= 1;
}
```
- _For_ loop:
```rust
for element in collection {
    // Do something.
}
```
```rust
for number in (0..4) {
    // Do something too.
}
```

## Cmdline

### Rustc

- To compile a code, just run:
```sh
rustc file.rs
./file
```

### Cargo

#### Create a new project

```sh
cargo new <project_name>
```

#### Build a project

```sh
cargo build
```

#### Build and run a project

```sh
cargo run
```

#### Check the code is correct

```sh
cargo check
```

## Resources

### Library docs

- [Rust Prelude](https://doc.rust-lang.org/stable/std/prelude/index.html)

### Learning

- [Rust Book](https://doc.rust-lang.org/stable/book)
