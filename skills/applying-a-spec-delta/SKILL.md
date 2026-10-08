---
name: applying-a-spec-delta
description: Use only when a skill tells you to invoke applying-a-spec-delta, never on a request to preview a spec change - builds outside the repository a copy of each spec the given blocks target, with those blocks applied, which checks each block, and returns the paths of the copies
user-invocable: false
---

# Applying a Spec Delta

## Overview

This skill builds the state a batch's blocks produce: a copy of each spec they
target, with the blocks applied.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the applying-a-spec-delta skill to apply these blocks."

The skill that invokes it gives the batch document and the blocks to apply.

It returns the path of each copy (`What It Returns`). Once you have the paths, go
on with the step that invoked this skill.

## The Copies

Build a copy of each spec the blocks target, with those blocks applied,
**outside the repository**, in a scratch directory: no block is written into a
spec before a story transcribes it, whoever needs to read the state the blocks
produce.

Apply the given blocks and no other. A spec none of them targets gets no copy.

## The Check

Check every block as you apply it: it carries its `D<n>`, it names the spec and
section it targets, and its unchanged and removed lines match `main`, or the
text the block ordered before it leaves.

A block that fails this check does not apply, which is how a delta gone stale
since the batch was drafted is caught.

## What It Returns

Return the path of each copy, with the path of the spec it copies.

Return each block that did not apply, with the check it failed.

## Red Flags

| Thought | Reality |
|---------|---------|
| "Editing the spec in the worktree is quicker, I'll revert it after" | No block is written into a spec before a story transcribes it. Build the copy outside the repository. |
| "This block almost applies, I'll fit it as I go" | A block that fails the check is a stale delta, and fitting it hides that. Return it with the check it failed. |
