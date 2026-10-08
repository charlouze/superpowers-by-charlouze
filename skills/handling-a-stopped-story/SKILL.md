---
name: handling-a-stopped-story
description: Use when a story has stopped on a stop condition this flow adds - a corrective batch whose spec is wrong, a technical story that changes something observable, a constraint or an ADR that cannot be held - keeps the story as it stands, puts the choice to your human partner, then abandons the story or resumes it
---

# Handling a Stopped Story

## Overview

A story that stops on one of the stop conditions this flow adds settles nothing
by itself. The story stays as it stands, your human partner rules between the
options of that condition, then the story is abandoned or resumes.

**Announce at start:** "I'm using the handling-a-stopped-story skill to handle this stopped story."

**Start by invoking `supercharlouze:following-the-rules`, unless this session already has.**

`Stop Conditions` in `supercharlouze:following-the-rules` states each of them.

| Entry point | Section |
|---|---|
| A corrective batch that turned out not to be corrective | Requalifying a Corrective Batch |
| A technical story that turned out to change something observable | Requalifying a Technical Story |
| A story stopped on a constraint of its batch or an ADR it cannot hold | A Constraint or an ADR a Story Cannot Hold |

Once the story is abandoned, `What the Ruling Asks For` says what comes next.

## Requalifying a Corrective Batch

**Trigger — Override 2, the stop condition proper to a corrective batch.** This
plugin adds stop conditions to `superpowers:subagent-driven-development`, and
this is the corrective one: while
bringing code into conformance with a spec, if a story discovers that the
**spec** is wrong and the code is right, it stops. The batch is no longer
corrective and must be requalified. The four native stop conditions assume a
valid authority exists; here the authority itself is in question, and no agent
may correct a spec.

**Procedure.**

1. **Leave the story as it stands until the choice below is ruled, then abandon
   it.** A pull request already open stays open until then. Once the choice is
   ruled, invoke `supercharlouze:abandoning-a-story` and give it the story's
   branch.
2. **Put the choice to the human**, who alone may rule:
   - **Correct the spec**: the batch stays corrective, on a reduced scope,
     and the corrected spec ships through its own pull request;
   - **Rewrite the batch as an ordinary batch**, with a real spec delta, through
     an **amendment pull request** reviewed as an opening;
   - **Rule the remaining work a different batch**: it gets a fresh `NN`, and
     this batch is closed with `supercharlouze:closing-a-batch` rather than left
     open.

   The rewrite keeps `NN` and its directory: the number identifies a delivery
   unit, and any story already merged lives under it, so a new number would
   strand them.
3. **Release the reservations of the entries the batch no longer takes on.** A
   reduced or rewritten scope releases them in the amendment pull request that
   changes `Scope`. A batch closed in favour of a fresh one releases them at its
   closing, before the fresh batch reserves them at its own opening: two batches
   never reserve the same entry.

Never carry out a requalification by deciding the substance yourself. Correcting
a spec is a human act, never an agent act. Your job is to present the choice with
its consequences, then execute what is ruled.

## Requalifying a Technical Story

**Trigger — the stop condition of a technical story.** `supercharlouze:following-the-rules`
states it and `supercharlouze:writing-a-user-story` copies it into the
`Global Constraints` of every technical story: a story that discovers it changes
something observable at its module's boundary is no longer technical. It reaches
you already stopped, from inside `superpowers:subagent-driven-development`.

**Procedure.**

1. **Abandon the story.** Close its pull request without merging it if one is
   already open; the branch and its worktree stay until the choice below is
   ruled. Once it is ruled, invoke `supercharlouze:abandoning-a-story` and give
   it the story's branch.
2. **Put the choice to the human**, who alone may rule. If they judge the
   observable change wanted, it needs a block, and a block is acquired by an
   amendment that goes back through the opening review — the exact text of a block
   is what that review reads, and a story that transcribes none never passes it.

If the human judges the observable change unwanted instead, there is nothing to
amend: the story is abandoned and the batch carries on as it was.

## A Constraint or an ADR a Story Cannot Hold

**When a story stops on a constraint or an ADR it cannot hold, your human
partner rules on the constraint or the ADR.** Until then the branch and the
worktree stay as they are.

If they rule it untenable, the story is abandoned: invoke
`supercharlouze:abandoning-a-story` and give it the story's branch.

Otherwise the story resumes and holds the constraint or the ADR, and nothing is
amended.

## What the Ruling Asks For

A ruling that abandons the story may ask for next steps. Take them in the order
their row gives, each with the skill that conducts it:

| Ruling | Next steps |
|---|---|
| The spec is corrected, and the batch stays corrective on a reduced scope | The corrected spec ships through its own pull request, and `supercharlouze:amending-a-batch` reduces the `Scope`. |
| The corrective batch is rewritten as an ordinary batch | `supercharlouze:amending-a-batch` rewrites it. |
| The remaining work is a different batch | `supercharlouze:closing-a-batch` closes this batch, then `supercharlouze:opening-a-batch` opens the fresh one. |
| The observable change of a technical story is wanted | `supercharlouze:amending-a-batch` adds its block. Once that pull request merges, `supercharlouze:writing-a-user-story` rewrites the work as an ordinary story of the amended batch. |
| A constraint is untenable | `supercharlouze:amending-a-batch` changes or removes it. |
| An ADR is untenable | A bounded change, under `supercharlouze:making-a-bounded-change`, rewrites or deletes it. |

## Red Flags

| Thought | Reality |
|---------|---------|
| "The spec is wrong here, I'll fix it and keep the batch corrective" | Only the human corrects a spec. Stop the story, present the requalification choice. |
| "Requalification starts by closing the story's pull request" | Override 2 fires mid-SDD, usually before any pull request exists. Close it only if it is already open. |
| "The story is right, this constraint cannot be held, I'll amend it" | Whether a constraint can be held is your human partner's ruling. Put it to them: the amendment follows a ruling of untenable, and the story resumes on any other. |
