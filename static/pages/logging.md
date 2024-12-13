---
page_title: "Logs"
---

This page summarizes everything that I want to log about my personal projects,
conferences or anything where I want a timeline. Expect it to be absolutely
hard to read because I expect no other person than me (maybe my girlfriend) to
care about it.

## TODOs

- [✔️] Port the Blog using the _tree.ml_ module,
- [✔️] Move the `index.ml` to pages
- [✔️] Add a [logging](/logging) page
- [✔️] Improve the content of the [about](/about) page,
- [✔️] Set up the Atom feed back,
- [ ] Find a decent design for the website:
  - Follow [xvw](https://xvw.lol) suggestion and rely on
    [Penpot](https://penpot.app/) to create a design first
  - Blog post page
  - Colors
  - Change the principal font as Overpass feels to tight...
- [ ] Refactor the code because it is not clean:
  - [ ] `Tree.ml` with a less leaky interface and remove the `is_index_file` function
  - [ ] Clean the `S.ml` and the `Resolver.ml`
  - [ ] Add some documentation everywhere, please!
  - [ ] Improve the separation between actions and model and move the code in `lib/`
  - [ ] Use the _"forest"_ language to describe all of this!
- [ ] Start the blog back and write regularly about what I learn,

## 2024

## 2024-12-13

Support the `draft: <bool>` metadata with `Blog.t` elements. It allows testing
online without referencing them. Write a new blog post about the donations!
Yeah, being a bit productive on personal time :)

## 2024-12-08

Add the RSS2 flux as a syndication page. This allows users to have both _Atom_
and _RSS_ versions.

## 2024-12-06

Bring back the profile picture in the [about](/about) page. Improve the content
of the page by adding more information about employers. Add a disclaimer on all
the pages about opinions. I wrote the first version of the `Atom` feed. It is
not a clean interface but at least, it works. The next stage is to improve the
code readability. I'll take care of this after the design because I want to
have a decent "visible" version before going into hard refactoring mode.

### 2024-11-24

Add this logging section. It is still hidden for the public as I do not know
how to expose it on the website. However, it will be built. I also cleaned the
`index.ml` file to make it easier to maintain in the long rune. I added some
small improvement tot the `about.md` page, but it needs to be done when I have
more time. Will look at this later.

### 2024-11-22

Move the `blog.ml` file to use the `tree.ml` structure. It is not clean at all
right now: it needs a little cleaning.
