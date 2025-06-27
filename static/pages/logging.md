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
- [✔️] Find a decent design for the website:
  - Follow [xvw](https://xvw.lol) suggestion and rely on
    [Penpot](https://penpot.app/) to create a design first
  - Blog post page
  - Colors
  - Change the principal font as Overpass feels to tight...
- [✔️] Support for D2
  - [✔️] Transform code block with `d2` to image link
  - [✔️] Add a `d2: <bool>` YAML entry to know if it needs to transform using
    `d2`. It is verbose, but it would save some computation time and requires
    being vigilant about it.
  - [✔️] Produce the `d2` image at the right place
- [ ] Refactor the code because it is not clean:
  - [ ] `Tree.ml` with a less leaky interface and remove the `is_index_file` function
  - [ ] Clean the `S.ml` and the `Resolver.ml`
  - [ ] Add some documentation everywhere, please!
  - [✔️] Improve the separation between actions and model and move the code in `lib/`
  - [ ] Use the _"forest"_ language to describe all of this!
  - [✔️] The D2 system available for the `blog.ml` too.
  - [✔️] Unified the `blog.ml`, `project.ml` and, `wiki.ml` interface to use the same section type. (Same page?)
- [ ] Start the blog back and write regularly about what I learn,
- [ ] Create a script to transfert between private to the public wiki
- Fixes:
  - [✔️] Fix the problem with `eio` and running the server. Worst case, move
    to the Unix runtime (prefer not to).
  - [✔️] Import locally the version of the `h1` fonts and register it in the license page.

## 2025

### 2025-06-27

I imported the _Rubik Doodle Shadow_ font in the local repository and cleaned
_Amatic SC_ traces. I converted both `Blog` and `Wiki` to use the `Section`
module. It allowed me to remove the `wiki.section.html` and the
`blog.section.html`.

### 2025-06-13

Change the theme to add more space and refine the new fonts. I have also
restructured the website to have the `index` containing everything.

### 2025-06-07

It seems pinning to the latest version of `yocaml` makes the error disapear as
[xvw](https://xvw.lol) suggested. I added the support to the "Do Not Track"
recognition from Umami.

### 2025-04-18

Many changes! I moved the website to use Nebula Sans instead of Roboto. It
makes the website more unified and give I really like the font. I changed the
colors to be blue dark mode and, red/purple in light mode. This is better for
readability and also cleaner. I fixed some CSS problems I add with alignments.
I rewrote the [/projects/index.html] page to make it lighter and, though, more
readable. Finally, I move the legals to the about page. It's been a while since I have
done improvements here and, it's nice to be back!

### 2025-02-17

Synchronize my notes with the public website.

### 2025-01-29

Move fonts to use Roboto as the primary font.

### 2025-01-27

Switch to the new design, finally!

### 2025-01-24

I finished implementing the new design for the desktop version. To finish the
implementation, I need to make the adjustments for the mobile version. I know
it is more usual to do the other way but, I wanted to have the full screen
version first because this is my primary source usage of this website.

### 2025-01-19

I have implemented the theme switcher with the help of [this blog
post](https://lukelowrey.com/css-variable-theme-switcher) and I started to
implement the design according to Penpot.

### 2025-01-17

The code makes the blog capable of using `d2` diagrams too, the same way
`wiki.ml` does. Finish the mock design on Pen Pot. All I need is to implement
the CSS. For future me, it needs to be done in an atomic way: I write the new
CSS and HTML files and just switch the path ultimately.

### 2025-01-10

The wiki is now able to directly extract `d2` diagrams from the markdown file
and extract the diagrams to an SVG and swap the graph code block with a newly
create SVG image. It now requires `d2` to be able to build the full wiki.

## 2024

### 2024-12-27

Support the `d2` front matter in wiki page and generate image links from
content digest (weak caching system to not generate some files multiple times).
The next step is to walk through the tree and generate the `d2` schemas in the
tree using the
[Folder](https://erratique.ch/software/cmarkit/doc/Cmarkit/Folder/index.html)
API from Cmarkit and [the YOCaml D2
example](https://github.com/xhtmlboi/yocaml/blob/main/examples/d2/d2.ml)

### 2024-12-26

Add Wikipedia to the donation blog post because it was missing.

### 2024-12-19

Support the `draft: <bool>` metadata with `Wiki.t` elements. It allows the same as
for the `Blog.t` elements. Night time!

### 2024-12-13

Support the `draft: <bool>` metadata with `Blog.t` elements. It allows testing
online without referencing them. Write a new blog post about the donations!
Yeah, being a bit productive on personal time :)

### 2024-12-08

Add the RSS2 flux as a syndication page. This allows users to have both _Atom_
and _RSS_ versions.

### 2024-12-06

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
