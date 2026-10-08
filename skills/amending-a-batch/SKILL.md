---
name: amending-a-batch
description: Use when an open batch must change its scope, its spec delta, its technical design, its constraints or its flag - amends the batch document and opens the amendment pull request, reviewed like the others
---

# Amending a Batch

## Overview

The batch document carries no mutable state, but it stays amendable by an
**amendment pull request**, reviewed like the others. An amendment changes the
scope, the spec delta, the technical design, the constraints or the flag of an
open batch.

**Announce at start:** "I'm using the amending-a-batch skill to amend batch NN."

**Start by invoking `supercharlouze:following-the-rules`, unless this session already has.**

Every text this skill writes follows `Concision` in `supercharlouze:following-the-rules`.

## What an Amendment Is For

An amendment is the exit from these real dead ends:

- **An exempted batch that discovers it needed a flag** — a batch whose stories
  were all technical and one of them turned out not to be, a single-story batch
  that splits in two.
- **A batch whose scope is reduced or abandoned**, including reducing it after a
  requalification, or giving a flag an extended scope so a later batch can decide.
- **A batch whose spec delta must change**: a corrective batch rewritten as an
  ordinary one, or a technical story whose observable change needs a block.
- **A batch whose technical design or constraints must change**: a design the
  remaining stories should no longer start from, or a constraint your human
  partner ruled untenable.

Without this path none of them has an issue: the batch document is written
at opening, and nothing else changes it before closing.

A change that touches nothing but ADRs is not an amendment: it goes through a
bounded change, under `supercharlouze:using-batches`.

**When a story has stopped and nothing is ruled yet, go to
`supercharlouze:handling-a-stopped-story` first**: an amendment follows your
human partner's ruling, and never stands in for it.

## The Branch

Do it on a branch whose name **follows none of this plugin's branch patterns** —
`adopt/<module>`, `batch/NN-<slug>`, `batch/NN-<slug>-close`,
`story/NN-us-N-<slug>`, `bounded/<slug>`, `chore/supercharlouze-init`. Some of those
names are read as claims: `batch/*` and `story/*` claim a number, `story/*` and
`bounded/*` claim sections. An amendment claims neither a number nor any section, so a
branch named after one of the claiming patterns would claim what it does not hold,
and a name that follows none has nothing to carry. Invoke
`supercharlouze:starting-a-branch` and give it the name you chose.

## The Document

To amend the document, invoke `supercharlouze:writing-a-batch-document` and give
it the batch document and what the amendment changes in it. An amendment is not
mutable state flowing along: it is an explicit human decision that goes through
a review.

An amendment that takes a gaps register entry out of `Scope` releases its
reservation in the same pull request: invoke
`supercharlouze:writing-in-a-gaps-register` before releasing it.

An amendment that adds the block of an observable change a technical story
revealed declares the flag that block requires, if it requires one. Ask the
exemption criterion again of the batch with its new block: would one story,
merged alone, leave a user facing something incomplete? The exemption drawn
from all stories being technical no longer holds, so the answer alone
decides.

## The ADRs

An amendment's pull request may also write, rewrite or delete the ADRs your
human partner decided with the amendment. Do it once the document is amended.

Before writing or rewriting one, invoke `supercharlouze:applying-a-spec-delta`
and give it the amended document and every block of it that no merged story has
declared yet: it returns the copies of the specs, blocks applied. An ADR is
confronted with the specs as the batch leaves them, and those blocks are in no
spec yet.

Invoke `supercharlouze:recording-a-decision` for each ADR to write or to
rewrite, and hand it those copies.

Delete yourself each ADR your human partner abandoned, in a commit that says
why.

The pull request body states each ADR it writes, rewrites or deletes.

## The Rereads

An amendment that changes the spec delta, the technical design or the
constraints, or that writes or rewrites an ADR, owes the technical reread. One
that changes the spec delta owes the coherence reread and the batch-document
reread as well.

Before the pull request of an amendment that owes a reread opens, invoke
`supercharlouze:rereading-a-batch` and give it the amended document, its new or
changed blocks together with every block no merged story has declared yet, the
rereads it owes, and the path of each ADR it writes or rewrites.

A behaviour or a block that skill returns as taken back to the spec delta makes
the amendment one that changes the spec delta.

The body of an amendment says what each of its rereads found, or that it found
nothing. When the technical reread returned that it had nothing to reread, the
body says that instead.

## The Pull Request

Say in the pull request body what changed and why.

By exception, an amendment that changes the spec delta is reviewed as an
opening. Its body states the exact text of every new or changed block, and what
the coherence reread found.

**To end the review of an amendment, invoke `supercharlouze:finishing-a-pr` and
give it no condition, and this next step: whatever the batch was doing when it
stopped, with the skill that conducts it, starting from the amended batch
document.**

## Red Flags

| Thought | Reality |
|---------|---------|
| "The scope changed, I'll slip the edit into the next story's pull request" | Then the change is never reviewed as a scope change. The batch document has no mutable state: before closing, it moves only through an amendment pull request of its own. |
| "I'll call the amendment branch `batch/NN-<slug>-amend`, it says what it is" | A name under one of this plugin's branch patterns claims what that pattern claims — a number, sections — and an amendment holds neither. Its branch follows none of them. |
| "My human partner decided this ADR, I'll write the file myself" | Invoke `supercharlouze:recording-a-decision`. It confronts the decision with the specs, blocks applied, and with the other ADRs. |
| "My human partner wants this ADR rewritten, I'll amend the batch for it" | An amendment changes the batch document. A change that touches nothing but ADRs goes through a bounded change. |
| "This amendment only changes the scope, the ADR it writes needs no reread" | An amendment that writes or rewrites an ADR goes through the technical reread, whatever else it changes. |
