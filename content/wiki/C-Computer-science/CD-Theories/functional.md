---
id: functional
aliases: []
tags: []
description: Programming using functional idioms
lang: en-GB
title: Functional Programming
---

## Programming with Functor, Applicative and Monad

### Functor

Functors are here to send value into another space while "keeping" the same form.

```ocaml
 val map : ('a -> 'b) -> ('a t -> 'b t)
 let ( <$> ) = map
 ```

 We can't code it like this, we need a property to not have:
```ocaml
 let map fn lst = []
```
 FORALL fn lst,
  - assert (List.length lst = List.length (map fn lst)) map (fun x -> x) t = t map f (map g t) = map (fun x -> f (g x)) t
 
### Applicative

Applicatives exist because with Functors, you can't combine things. With Applicatives you are able to combine the information to apply functions.

```ocaml
val pure/return/singleton : 'a -> 'a t
val pair : 'a t -> 'b t -> ('a * 'b) t

val apply : ('a -> 'b) t -> 'a t -> 'b t
let apply fn_t a_t = pair fn_t a_t |> map (fun (fn, a) -> fn a)
let ( <*> ) = apply

val liftA2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t let liftA2 fn a_t b_t = pair a_t b_t |> map (fun (a,b) -> fn a b)
```

```ocaml
((fn : 'a -> ...) <$> truc : 'a t) <*> bidule (fun t b m -> ...) <$> truc <*> bidule <*> machin
```
is equivalent to
```ocaml
let+ t = truc and+ b = bidule and+ m = machin in ...
```
is equivalent to
```ocaml
let+ t = truc
and+ (b, m) =
	let+ b = bidule
	and+ m = machin
	in (b, m)
in ...
```

We want this property to be true on Applicative:
```ocaml
map (fun (a, (b, c)) -> (a, b, c)) (pair at (pair bt ct)) == map (fun ((a, b), c) -> (a, b, c)) (pair (pair at bt) ct)
```


## Stage functions

Partial applications are really useful. However, sometimes, you want to compute elements in the partial application and keep them in a closure. If you directly provide the function and let people partially applying it, nothing prevent them to recompute the closure every time.

This is where the stage trick comes in action. You simply define a module:
```ocaml
module Stage : sig
  type 'a t
  val staged : 'a -> 'a t
  val unstaged 'a t -> 'a

end = struct
  type 'a t = 'a
  let stage (fn : 'a) : 'a t = fn
  let unstage (fn : 'a t) : 'a' = fn
end
```

As the function type will be constraint in an abstract `a t`, there is no risk to execute the partial application without using the `Stage.unstaged` function.
## Resources

- [Jean-Christophe' blog](https://backtracking.github.io/): a collection of many ideas and project from a University teacher
- [JaneStreet's blog](https://blog.janestreet.com/): an interesting blog about `OCaml`
- [Programming and computation](https://okmij.org/ftp/Computation/): a kind of wiki about multiple stuff in functional languages
- [Learn Haskell](http://learnyouahaskell.com/chapters): book to learn Haskell
- [Type class in  OCaml](https://blog.shaynefletcher.org/2017/05/more-type-classes-in-ocaml.html)
