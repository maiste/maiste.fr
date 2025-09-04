---
id: age
aliases: []
tags: []
description: Encryption tool for modern encryption
lang: ENG
title: Age
---

## Introduction

`age` is a modern tool for modern encryption. It contains a lot of features and
aims to fix some of [gpg](./gpg.md) flows. The Golang development is done with
[GitHub](https://github.com/FiloSottile/age).

## Encrypt with a passphrase

You can provide a passphrase to encode your file. This is a convenient method
to protect your files before sharing.

```sh
age -p file.to.encrypt > file.encrypted.age
```

## Decrypt with a passphrase

You need to do the inverted action to extract the data from the files.

```sh
age -d file.encrypted.age > file.decrypted
```
