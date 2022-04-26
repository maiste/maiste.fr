+++
title = "Good Practises"
description = "Lessons about CS I've learnt"
template = "data/page.html"

[extra]
lang = "ENG"
+++

## Debugging

1. Even if it's seemed bad, often a `Printf` is quicked than a debugging tool
2. Logging data is *important*: a debug mode should always be available for medium to big programs.
3. `git-diff` is a good friend, that the first step to debugging

## Coding style

1. The style is often *subjective*. However, it matters to stay consistent.

## Coding methods

1. Pencils and papers are your friends, feel free to fill a lot of them with notes, graphs or anything relevant: it frees your mind.
2. A good way to design a good API is actually to try to explain it with documentation ie. always start by a .mli, give a few hints on the general idea behind the API and give a few explanations on how users are supposed to use it. Writing a few examples is always a good way to find the right function and types names and the proper API to compose them ([quote @samoht](https://github.com/mirage/irmin/pull/1817)).
