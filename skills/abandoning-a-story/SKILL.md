---
name: abandoning-a-story
description: Use only when a skill tells you to invoke abandoning-a-story, never on a request to drop a story - closes the story's pull request without merging it, deletes its branch locally and on the remote, and removes its worktree
user-invocable: false
---

# Abandoning a Story

## Overview

This skill makes the gesture that abandons a story.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the abandoning-a-story skill to abandon this story."

The skill that invokes it gives the story's branch.

Once the story is abandoned, go on with the step that invoked this skill.

## The Gesture

1. **Close the story's pull request without merging it, if one is open.** A
   story stopped before its pull request opened has none: there is nothing to
   close, only a branch and a worktree to discard.
2. **Remove its worktree.** A worktree left behind is where a later session
   resumes a story that no longer exists, and git refuses to delete a branch a
   worktree still has checked out.
3. **Delete the branch, locally and on the remote.** A pushed `story/*` branch
   with no pull request reads as a live claim on its sections, so a branch left
   on the remote holds them against every story that follows, and nothing ever
   releases them.

## What It Leaves on `main`

Nothing has to be revoked: the spec change, or the deleted gaps-register entry,
travels with the code and dies with the branch.

Change nothing on `main`. The gaps register reservations and the blocks the
batch announced were put there by the batch's opening pull request, and
abandoning a story leaves them as they are.

## Red Flags

| Thought | Reality |
|---------|---------|
| "The story is abandoned, the branch can stay" | A pushed `story/*` branch with no pull request reads as a live claim on its sections. Delete it, locally and on the remote. |
