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
   - **Correct the spec**: a bounded change carries the correction they decide,
     and an amendment reduces the scope of the batch, which stays corrective;
   - **Rewrite the batch as an ordinary batch**, with a real spec delta, through
     an **amendment pull request** reviewed as an opening;
   - **Rule the remaining work a different batch**: it gets a fresh `NN`, and
     this batch is closed with `supercharlouze:closing-a-batch` rather than left
     open.

   The rewrite keeps `NN` and its directory: the number identifies a delivery
   unit, and any story already merged lives under it, so a new number would
   strand them.

The steps the ruling asks for release the reservations of the entries the batch
no longer takes on; this session releases none. A reduced or rewritten scope
releases them in the amendment pull request that changes `Scope`. A batch closed
in favour of a fresh one releases them at its closing, before the fresh batch
reserves them at its own opening: two batches never reserve the same entry.

Never carry out a requalification by deciding the substance yourself. Correcting
a spec is a human act, never an agent act. Your job is to present the choice with
its consequences, then execute what is ruled.

## Requalifying a Technical Story

**Trigger — the stop condition of a technical story.** `supercharlouze:following-the-rules`
states it and `supercharlouze:delivering-a-story` copies it into the
`Global Constraints` of every technical story: a story that discovers it changes
something observable at its module's boundary is no longer technical. It reaches
you already stopped, from inside `superpowers:subagent-driven-development`.

**Procedure.**

1. **Leave the story as it stands until your human partner has ruled whether
   the observable change is wanted, then abandon it.** A pull request already
   open stays open until then. Once it is ruled, invoke
   `supercharlouze:abandoning-a-story` and give it the story's branch.
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

A ruling that abandons the story may ask for next steps. They start in a fresh
context: this conversation carries a stopped execution, and each step is
conducted from a document.

When it does, once the story is abandoned:

1. **Ask your human partner to clear the context.**
2. **Give the prompt that starts the next steps**, in the form `The Git Model`
   in `supercharlouze:following-the-rules` fixes. It states the ruling, then
   the steps of its row below, in their order, each with the skill to invoke
   and the document it starts from, by its path.

State the ruling as your human partner gave it, and name the story and what it
revealed. Not: "Carry on with the requalification." Good: "Technical story
`07-us-4-renommer-les-echeances` was abandoned: it changes how a prorated amount
is rounded, and that change is wanted."

| Ruling | Next steps, in their order |
|---|---|
| The spec is corrected, and the batch stays corrective on a reduced scope | `supercharlouze:amending-a-batch` reduces the `Scope`, from the batch document. Then `supercharlouze:making-a-bounded-change` carries the correction your human partner decides, from the spec. |
| The corrective batch is rewritten as an ordinary batch | `supercharlouze:amending-a-batch` rewrites it, from the batch document. |
| The remaining work is a different batch | `supercharlouze:closing-a-batch` closes this batch, from the batch document. Then `supercharlouze:opening-a-batch` opens the fresh one, from the gaps register whose entries this batch released. |
| The observable change of a technical story is wanted | `supercharlouze:amending-a-batch` adds its block, from the batch document. Once that pull request merges, `supercharlouze:delivering-a-story` rewrites the work as an ordinary story of the amended batch, from the amended batch document. |
| A constraint is untenable | `supercharlouze:amending-a-batch` changes or removes it, from the batch document. |
| An ADR is untenable | A bounded change, under `supercharlouze:making-a-bounded-change`, rewrites or deletes it, from the ADR. |

## Red Flags

| Thought | Reality |
|---------|---------|
| "The spec is wrong here, I'll fix it and keep the batch corrective" | Only the human corrects a spec. Stop the story, present the requalification choice. |
| "Requalification starts by closing the story's pull request" | The story stays as it stands until your human partner has ruled. A pull request already open is closed with the story, once it is abandoned. |
| "The story is right, this constraint cannot be held, I'll amend it" | Whether a constraint can be held is your human partner's ruling. Put it to them: the amendment follows a ruling of untenable, and the story resumes on any other. |
| "The ruling is fresh in this conversation, I'll run the amendment here" | This conversation carries a stopped execution, which can contradict the document the next step starts from. Ask your human partner to clear the context, and give the prompt. |
