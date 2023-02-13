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

<hr />

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

<hr />

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


## Rebase conflicts

First, it is better to use `diff3` to get the parent content and see what the issue is. In a rebase,
you are trying to apply the commits from a branch as `patches` into a `target branch`. The conflict
happens when the branch has been modified on both branches. All the following examples are coming
from [codeinthehole](https://codeinthehole.com/guides/resolving-conflicts-during-a-git-rebase/).

1. Show conflicting commit

```sh
git rebase --show-current-patch
# On git < 2.17 do
# git am --show-current-patch

```
2. Use the `REBASE_HEAD` pseudo ref to show various stuff:
```sh
git show REBASE_HEAD # View the current commit
git rev-parse REBASE_HEAD # Show the sha of the commit
```
3. Check the diff with the target branch:
```sh
git diff REBASE_HEAD...<target_branch> -- <FILEPATH>
```
4. Check the log history:
```sh
git log REBASE_HEAD..<target_branch> -- <FILEPATH>
```
5. Resolve conflict directly between _master_ and _example_
```diff
<<<<<<<< HEAD
I like apples and pears
|||||||| merged common ancestors
I like apples
========
I love apples
>>>>>>> working-branch
```
If you want to keep the change from the target branch (HEAD), you can use:
```sh
git checkout --ours -- <FILEPATH>
```
If you want to keep the one of the branch you are rebasing (working-branch), you can use 
```sh
git checkout --theirs -- <FILEPATH>
```



# Cherry pick

## Cherry pick one commit

```sh
git cherry-pick <commit>
```

<hr />

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

<hr />

## Resources

* [How to add submodules](https://devconnected.com/how-to-add-and-update-git-submodules/) (TO TRANSLATE)
