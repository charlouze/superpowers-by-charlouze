---
name: writing-a-batch
description: Use when opening a batch of user stories, amending one, or requalifying a corrective batch - writes the batch document and opens the pull request whose review is the human gate
---

# Writing a Batch

## Overview

A batch is the delivery unit: a directory `docs/batches/NN-<slug>/` holding a
batch document and, later, the user stories that deliver it. Its purpose is to
add behaviour to one or more module specs. It may span several modules.

This skill produces **one pull request carrying the batch document**, and that
pull request's review is the human gate: until it merges, no story is written.

**Announce at start:** "I'm using the writing-a-batch skill to open batch NN."

**Start by invoking `supercharlouze:following-the-rules`, unless this session already has.**

Three entry points, all landing in a pull request:

| Entry point | Section |
|---|---|
| Opening a new batch | Preconditions through Opening the Pull Request |
| Changing the scope, the spec delta, the technical design, the constraints or the flag of an existing batch | Amending a Batch |
| A corrective batch that turned out not to be corrective | Requalifying a Corrective Batch |

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

`NN` is the **smallest integer not used in `docs/batches/` on `main`, not
claimed by an open pull request, and not claimed by a pushed `batch/*` or
`story/*` branch that carries no pull request yet**. Fetch, then read all three,
always:

```bash
git fetch origin
git ls-tree --name-only origin/main docs/batches/
gh pr list --state open --json number,headRefName
git ls-remote --heads origin 'batch/*' 'story/*'
```

An artifact only reaches `main` when its pull request merges, so
that listing knows nothing about work in flight. Trusting that listing
alone hands the same number to two batches opened in parallel — and the second
one discovers it at merge time, after review.

**The third source closes the same window, by the same argument, as the
scan of `supercharlouze:detecting-concurrency`** — read it as one idea applied
twice, not as two coincidences. A branch is on the remote as soon as it has a
commit, while its pull request may not open for a long while, so for that whole
stretch it claims its number and `gh pr list` shows nothing at all.
The branch name already carries the number — `batch/NN-<slug>` and
`story/NN-us-N-<slug>` — so the remote listing answers on its own, with nothing
to fetch and no file to read. That is also why the pull request query asks for
`headRefName`: the number is in the head branch name, and nothing else in a
pull request states it.

Both patterns are scanned because both spell `NN`, but they do not carry the
same weight. On the nominal path the `story/*` half finds nothing new:
`supercharlouze:writing-a-user-story` requires the batch's opening pull request
to be **merged** before any story is written, so wherever a `story/NN-us-N-`
branch exists, `docs/batches/NN-<slug>/` is already on `main` and that
listing above sees it. Scan it anyway — it is one line and it is the only thing
that answers in the degraded case where that precondition was skipped and a
story branch is the sole trace of its batch.

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

The body of the pull request, opening or amendment, says what each reread found,
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

## Amending a Batch

The batch document carries no mutable state, but it stays amendable by an
**amendment pull request**, reviewed like the others. An amendment changes the
scope, the spec delta, the technical design, the constraints or the flag of an
open batch. That is the exit from these real dead ends:

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

Do it on a branch whose name **follows none of this plugin's branch patterns** —
`adopt/<module>`, `batch/NN-<slug>`, `batch/NN-<slug>-close`,
`story/NN-us-N-<slug>`, `bounded/<slug>`, `chore/supercharlouze-init`. Some of those
names are read as claims: `batch/*` and `story/*` claim a number, `story/*` and
`bounded/*` claim sections. An amendment claims neither a number nor any section, so a
branch named after one of the claiming patterns would claim what it does not hold,
and a name that follows none has nothing to carry. Invoke
`supercharlouze:starting-a-branch` and give it the name you chose.
To amend the document, invoke `supercharlouze:writing-a-batch-document` and give
it the batch document and what the amendment changes in it. Say in the pull
request body what changed and why. An amendment is not mutable state flowing
along: it is an explicit human decision that goes through a review.

An amendment's pull request may also write, rewrite or delete the ADRs your
human partner decided with the amendment. Do it as `The ADRs` does, once the
document is amended. Where that section gives
`supercharlouze:applying-a-spec-delta` every block of the spec delta, give it
every block of the amended document that no merged story has declared yet. The
pull request body states each ADR it writes, rewrites or deletes.

A change that touches nothing but ADRs is not an amendment: it goes through a
bounded change, under `supercharlouze:using-batches`.

By exception, an amendment that changes the spec delta is reviewed as an
opening. Its body states the exact text of every new or changed block, and what
the coherence reread found.

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

The body of an amendment says what each of its rereads found, as `The Rereads`
states.

**When a story stops on a constraint it cannot hold, your human partner rules on
the constraint.** If they rule it untenable, an amendment changes or removes the
constraint and the story is abandoned: invoke
`supercharlouze:abandoning-a-story` and give it the story's branch. Otherwise
the story resumes and holds the constraint, and nothing is amended.

An amendment that takes a gaps register entry out of `Scope` releases its
reservation in the same pull request: invoke
`supercharlouze:writing-in-a-gaps-register` before releasing it.

**To end the review of an amendment, invoke `supercharlouze:finishing-a-pr` and
give it no condition, and this next step: whatever the batch was doing when it
stopped, with the skill that conducts it, starting from the amended batch
document.**

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
3. **The same amendment declares the flag the block requires, if it requires
   one.** Ask the exemption criterion again of the batch with its new block:
   would one story, merged alone, leave a user facing something incomplete?
   The exemption drawn from all stories being technical no longer holds, so
   the answer alone decides.

**Concluded by** the merge of the amendment pull request: the work is rewritten as
an ordinary story of the amended batch, with `supercharlouze:writing-a-user-story`.

If the human judges the observable change unwanted instead, there is nothing to
amend: the story is abandoned and the batch carries on as it was.

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
| "The spec is wrong here, I'll fix it and keep the batch corrective" | Only the human corrects a spec. Stop the story, present the requalification choice. |
| "This batch is ordinary, reservations are a corrective-batch thing" | Any batch taking on gaps register entries reserves them at opening — a Gaps entry as much as a Violations one. Otherwise two batches specify the same behaviour. |
| "Requalification starts by closing the story's pull request" | Override 2 fires mid-SDD, usually before any pull request exists. Close it only if it is already open. |
| "The scope changed, I'll slip the edit into the next story's pull request" | Then the change is never reviewed as a scope change. The batch document has no mutable state: before closing, it moves only through an amendment pull request of its own. |
| "I'll call the amendment branch `batch/NN-<slug>-amend`, it says what it is" | A name under one of this plugin's branch patterns claims what that pattern claims — a number, sections — and an amendment holds neither. Its branch follows none of them. |
| "The story is right, this constraint cannot be held, I'll amend it" | Whether a constraint can be held is your human partner's ruling. Put it to them: the amendment follows a ruling of untenable, and the story resumes on any other. |
| "The batch has no design and no constraints, I'll skip the technical reread" | An opening owes every reread. The technical reread says itself when it has nothing to reread, and it rereads the ADRs this pull request writes. |
| "My human partner decided this ADR, I'll write the file myself" | Invoke `supercharlouze:recording-a-decision`. It confronts the decision with the specs, blocks applied, and with the other ADRs. |
| "This design decision deserves an ADR, I'll write it with the batch" | Only your human partner decides an ADR. Put the decision to them, and write it once they want it. |
| "My human partner wants this ADR rewritten, I'll amend the batch for it" | An amendment changes the batch document. A change that touches nothing but ADRs goes through a bounded change. |
| "This amendment only changes the scope, the ADR it writes needs no reread" | An amendment that writes or rewrites an ADR goes through the technical reread, whatever else it changes. |
