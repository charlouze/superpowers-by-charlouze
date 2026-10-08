---
name: opening-a-batch
description: Use when opening a batch of user stories - writes the batch document and opens the pull request whose review is the human gate
---

# Opening a Batch

## Overview

A batch is the delivery unit: a directory `docs/batches/NN-<slug>/` holding a
batch document and, later, the user stories that deliver it. Its purpose is to
add behaviour to one or more module specs. It may span several modules.

This skill produces **one pull request carrying the batch document**, and that
pull request's review is the human gate: until it merges, no story is written.

**Announce at start:** "I'm using the opening-a-batch skill to open batch NN."

**Start by invoking `supercharlouze:following-the-rules`, unless this session already has.**

## Opening, in Order

Opening a new batch runs these steps, in this order. Each names the section
that carries it.

1. **Check that every module this batch touches has an adopted spec** — the
   design stops here if one does not (`Preconditions`).
2. **Allocate `NN`** and create the branch (`Allocating NN`).
3. **Write the batch document**: `Scope`, `Spec delta`, `Technical design`,
   `Constraints`, `Feature flag` (`The Batch Document`), then write, rewrite or
   delete the ADRs your human partner decided (`The ADRs`).
4. **Reserve every gaps register entry this batch takes on.** No writing into
   the specs at this stage (`The Batch Document`).
5. **Have the batch reread**: the coherence reread, the technical reread and the
   batch-document reread (`The Rereads`).
6. **Open the pull request** from `batch/NN-<slug>` (`Opening the Pull Request`).

## Preconditions

Check them all **before creating any branch**. Each one, skipped, produces a
pull request that has to be thrown away.

1. **Every module this batch touches has an adopted spec** in
   `docs/specs/<module>.md`. If one does not, **the design stops here** — and
   **adoption is never conducted in the same context as a design**. Say what is missing, and
   let your human partner abandon the design or set it aside. Adoption then runs
   on its own, through `supercharlouze:adopting-a-module`, and the design
   **resumes in a fresh context** once that pull request is merged, starting from
   the adopted spec.

   Two reasons, and the second is the one that is easy to miss. A batch argues
   from a spec — without one, the delta has nothing to attach to, and you would
   end up inventing the module's norm from its code, which is exactly what
   adoption exists to prevent. And an adoption run in this conversation would
   carry into the batch every mechanism it read while auditing the code: the
   design that follows would then argue from what the code does, having been told
   in the same breath that it must not. Chaining the two is what makes that leak
   invisible, so the stop is the rule and not a preference.
2. **`gh` is available and authenticated.** Number allocation queries it. Without
   it you still have a partial safety net — the collision becomes visible when
   the pull request opens — but nothing prevents it.

## Allocating NN

Allocate `NN` as `skills/opening-a-batch/references/allocating-nn.md` says: it
fetches, then reads `main`, the open pull requests and the pushed branches.

The branch is `batch/NN-<slug>`. Path and branch patterns are English and fixed;
the slug follows the project's language, because it names a business object.

Invoke `supercharlouze:starting-a-branch` and give it the name `batch/NN-<slug>`.

## The Batch Document

To write the batch document, invoke `supercharlouze:writing-a-batch-document`
and give it this batch's `NN` and its slug.

This pull request does **no writing into the specs**. No block is transcribed at
opening: each one is transcribed by a story, in that story's own pull request
(`supercharlouze:writing-a-user-story`). Transcribing the whole delta now would
put behaviour into the spec that no code delivers — drift by definition, and the
reviewers of a story would then report as missing what is merely not built yet.

**The gaps register is not a spec.** `docs/specs/<module>.gaps.md` records what
no spec describes, and where the code contradicts one — it carries no norm, so
nothing you write there is normative and the rule that this pull request writes
nothing into the specs is untouched. That is why a batch reserves its entries
in this same pull request while still writing nothing into a spec.

**Reserving gaps-register entries — any batch, not only a corrective one.**
Reservation is a property of the opening pull request of **whatever batch takes
an entry on**, and it exists so that two batches cannot draw the same entry. So:
if any part of this batch's scope comes from `docs/specs/<module>.gaps.md`,
reserve every entry it takes on **in this same pull request**: invoke
`supercharlouze:writing-in-a-gaps-register` before reserving one, and give it
this batch's `NN`. The reservation lives on `main`; that is what stops another
batch from taking the same gap, and closing a story's pull request does not
carry it away. `supercharlouze:closing-a-batch` releases whatever is
left unconsumed — which it can only do for entries that were reserved in the
first place.

**The two categories of the register do not feed the same kind of batch.**
*Violations* — the code contradicts a spec — feed a **corrective** batch.
*Gaps* — something real that no spec describes — feed an **ordinary** batch
that finally specifies them, and such a batch has a real spec delta *and*
reservations. Reservation is not a corrective-batch ceremony: an ordinary batch
drawing from *Gaps* reserves exactly like a corrective one. Skip it, and two
batches set out to specify the same undocumented behaviour in parallel, which is
the collision the annotation exists to prevent.

## The ADRs

Write, rewrite or delete in this pull request, with the batch document, the ADRs
your human partner decided during the brainstorming.

Before writing or rewriting one, invoke `supercharlouze:applying-a-spec-delta`
and give it the batch document and every block of its spec delta: it returns
the copies of the specs, blocks applied. An ADR is confronted with the specs as
the batch leaves them, and no block is in a spec yet.

Invoke `supercharlouze:recording-a-decision` for each ADR to write or to
rewrite, and hand it those copies.

Delete yourself each ADR your human partner abandoned, in a commit that says
why.

## The Rereads

Before the pull request opens, the batch goes through the coherence reread, the
technical reread and the batch-document reread.

Invoke `supercharlouze:rereading-a-batch` and give it the batch document, every
block of its spec delta, those rereads as the rereads due, and the path of each
ADR this pull request writes or rewrites.

**An opening owes every reread, whatever the batch carries.** A reread that has
nothing to read says so itself.

The body of the pull request says what each reread found,
or that it found nothing. When the technical reread returned that it had nothing
to reread, the body says that instead. A reread nobody can see from the pull
request is a practice again, not a rule.

## Opening the Pull Request

Open the pull request from `batch/NN-<slug>`. Its body states what the
reviewer has to rule on: the exact text of every block, or the reason for the
`none`; the technical design, or the reason for its `none`; the constraints;
the flag decision; the scope, with the entries it takes on; any flag lifting
the delta announces; and each ADR this pull request writes, rewrites or deletes.

**The review of the batch pull request is the human gate.** Until it merges, no
story is written and no spec is touched. It bears on the exact text of every
block: this is where the human reads what the specs will say, before any code is
written on it — block by block, in the batch document, and not later as a diff of
the spec.

**Where the delta carries no block, the review bears on what stands in their
place**: the reason for the `none`, and the entries `Scope` takes on. The gate
does not move and nothing is waived: a batch with no block is read at the same
review.

This review replaces the tail of the architectural path of
`superpowers:brainstorming` — the dated design doc becomes this batch document,
the self-review becomes the batch-document reread, and the human review of
the written spec becomes this pull request review. The human review is not
removed; it changes tool, into the one where you already review everything else.

**To end the review, invoke `supercharlouze:finishing-a-pr` and give it no
condition, and this next step: `supercharlouze:writing-a-user-story`, which
starts from the batch document, with a prompt that says to choose the blocks
from those the document still carries.**

The clear that follows the merge matters here: the batch document carries the
exact text of every block and the technical design, which is what the design
conversation was for — and that conversation also carries every option you
discarded on the way, which the first story must not inherit.

## Language

**English skeleton, project-language prose**, inside every document you write
here. Section headings, field names, front matter values (`status: open`), table
headers, path patterns and branch patterns are English, always, whatever the
project speaks. The prose is in the project's language: the scope, the
spec delta, the justification of the flag decision. Slugs name business
objects, so they follow the project's language too.

Every text this skill writes follows `Concision` in `supercharlouze:following-the-rules`.

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll take the next free number from the directory" | Work in an open pull request has not reached main yet, and a pushed branch may hold a number with no pull request at all. Ask gh and `git ls-remote --heads` too. |
| "I'll transcribe the spec delta now, while it's fresh" | The spec would then describe behaviour no code delivers. Each story transcribes its own spec change. |
| "The module has no spec yet, I'll write the batch and adopt later" | The design stops. Otherwise the batch invents the norm it is supposed to obey. |
| "The module has no spec, I'll adopt it right now and come back" | Adoption is never conducted in the same context. It would carry the mechanisms it read in the code into the design that follows. Stop, and resume in a fresh context after the merge. |
| "This batch is ordinary, reservations are a corrective-batch thing" | Any batch taking on gaps register entries reserves them at opening — a Gaps entry as much as a Violations one. Otherwise two batches specify the same behaviour. |
| "The batch has no design and no constraints, I'll skip the technical reread" | An opening owes every reread. The technical reread says itself when it has nothing to reread, and it rereads the ADRs this pull request writes. |
| "My human partner decided this ADR, I'll write the file myself" | Invoke `supercharlouze:recording-a-decision`. It confronts the decision with the specs, blocks applied, and with the other ADRs. |
| "This design decision deserves an ADR, I'll write it with the batch" | Only your human partner decides an ADR. Put the decision to them, and write it once they want it. |
