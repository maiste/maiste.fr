+++
title = "Git"
description = "How to use Git"
template = "data/page.html"

[extra]
lang = "ENG"
+++

# Commits

## Create a commit

```sh
git commit
```

## Create a commit wit a message

```sh
git commit -m "<message>"
```

## Create a commit as a fixup

```sh
git commit --fixup=<commit>
```

## Create a commit with a sign-off

```sh
git commit -s
```

## Signing a commit with a GPG key

```sh
git commit -S [KEYID]
```

## Amend a previous commit

```sh
git commit --amend
```

# Branch

## List branches

```sh
git branch [--all]

```

## Create a branch

```sh
git branch <name> [origin branch]
```

## Delete a branch without forcing

```sh
git branch -d <name>
```

## Delete a branch with forcing

```sh
git branch -D <name>
```

## Switch to a branch

```
git switch <name>
```

## Switch to a new branch

```sh
git switch -c <name> [origin]
```

## Switch to a branch with a detached head

```sh
git switch -d <commit or branch>
```

# Rebase

## Rebase a branch

```sh
git rebase <rebase onto> [from]
```

## Rebase in interactive mode (optionnaly with fixup squashing)

```sh
git rebase --interactive  [--autosquash] [range]
```

## Rewrite commit while rebasing

```sh
git rebase --interactive [range]
# For each stage
git reset HEAD^
git commit ...
```

## Continue a rebase

```sh
git rebase --continue
```

## Abort a rebase

```sh
git rebase --abort
```

# Cherry pick

## Cherry pick one commit

```sh
git cherry-pick <commit>
```

# Patch

## Produce a patch

```sh
git format-patch <branch or commit range> --stdout > <name>.patch
```

## Use a patch

```sh
git am <name>.patch
```

## Co Authored patch

```
Co-authored-by: author-name <name@xxx.com>
```
