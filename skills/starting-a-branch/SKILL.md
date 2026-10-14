---
name: starting-a-branch
description: Use only when a skill tells you to invoke starting-a-branch, never on a request to create a branch - fetches, creates the branch and its workspace, and restores the name it was given and the starting point origin/main
user-invocable: false
---

# Starting a Branch

## Overview

This skill starts a branch from `main` as the remote carries it.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the starting-a-branch skill to start this branch."

The skill that invokes it gives the name of the branch.

Once the branch is started, go on with the step that invoked this skill, in the workspace of the branch.

## The Gesture

1. **Fetch.**

   ```bash
   git fetch origin
   ```

   Merges arrive from the remote, so a branch started without the fetch starts
   from a `main` that is already behind.

2. **Create the branch and its workspace by invoking
   `superpowers:using-git-worktrees`**, then move into that workspace.

3. **Check the name and the starting point**, whatever that skill reported:

   ```bash
   git branch --show-current
   git merge-base --is-ancestor origin/main HEAD
   ```

   That skill prefers the harness's native tooling, which picks its own branch
   name, may leave a detached HEAD, and may branch from wherever you happened to
   be. And from inside a linked worktree it sees `GIT_DIR != GIT_COMMON`,
   concludes "already in a linked worktree" and reuses it without creating a
   branch: the work would land on the branch of the piece of work before.

4. **If the branch bears another name, HEAD is detached, the starting point is
   not `origin/main`, or isolation was declined, restore the name you were given
   and the starting point before going on**, inside the workspace:

   ```bash
   git switch -c <branch> origin/main
   ```

**A named branch is not enough.** Until its pull request opens, a piece of work
is recognised by the name of its branch on the remote. A branch under another
name claims nothing of what the name you were given claims, and a branch started
elsewhere carries commits that are not its own.

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'm already in a worktree, that will do" | As a place to work, it will. A branch that starts there will not: the work lands on the branch of the piece of work before. Start the branch from `origin/main`, wherever you stand. |
| "The harness already named the branch, that will do" | Under that name the branch claims nothing of what the name you were given claims. Restore the name you were given. |
