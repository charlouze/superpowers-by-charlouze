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

Three entry points, all landing in a pull request:

| Entry point | Section |
|---|---|
| Opening a new batch | Preconditions through Opening the Pull Request |
| Changing the scope or the flag of an existing batch | Amending a Batch |
| A corrective batch that turned out not to be corrective | Requalifying a Corrective Batch |

## Preconditions

Check all four **before creating any branch**. Each one, skipped, produces a
pull request that has to be thrown away.

1. **Every module this batch touches has an adopted spec** in
   `docs/specs/<module>.md`. If one does not, then adoption is a
   **blocking precondition**: stop, run `supercharlouze:adopting-a-module`,
   and get its pull request merged before coming back. Do not write the batch
   "in the meantime". A batch argues from a spec — without one, the delta has
   nothing to attach to, and you would end up inventing the module's norm from
   its code, which is exactly what adoption exists to prevent.
2. **You are in the main checkout**, not in a worktree left over from an earlier
   story. `superpowers:finishing-a-development-branch` preserves the worktree on
   the pull request path, so a session that chains two pieces of work without
   leaving it would silently stack this batch on the previous branch.
3. **You are on `main`, up to date with the remote.** Merges
   arrive from the remote; without a fetch, number allocation reasons on a stale
   directory.
4. **`gh` is available and authenticated.** Number allocation queries it. Without
   it you still have a partial safety net — the collision becomes visible when
   the pull request opens — but nothing prevents it.

## Allocating NN

`NN` is the **smallest integer not used in `docs/batches/` on `main` and not
claimed by an open pull request**. Both conditions, always:

```bash
ls docs/batches/
gh pr list --state open
```

An artifact only reaches `main` when its pull request merges, so
the directory listing knows nothing about work in flight. Trusting the directory
alone hands the same number to two batches opened in parallel — and the second
one discovers it at merge time, after review.

The branch is `batch/NN-<slug>`. Path and branch patterns are English and fixed;
the slug follows the project's language, because it names a business object.

Create the branch and workspace by invoking `superpowers:using-git-worktrees`.
That skill prefers the harness's native tooling, which picks its own branch name
and may leave you on a detached HEAD. This plugin enforces its own naming: if you
end up elsewhere, make sure a branch named `batch/NN-<slug>` exists before going
on. No mechanism depends on the name — but a pull request needs a branch.

## The Batch Document

Write `docs/batches/NN-<slug>/README.md`:

```markdown
---
status: open
---

# NN — <title>

## Scope

<What this batch delivers, and why now.>

## Spec delta

<The behaviour added to each spec, stated as intention, per module.>

## Constraints

<Migration and compatibility constraints, and the required ordering of the user
stories. `none` if there are none.>

## Feature flag

<See the next section. Never omitted.>

## Live flags

<See Surfacing Live Flags. `none` if there are none. Each entry carries the
human's ruling once the review has given it.>
```

`status: open | closed` is a front matter value, so it is English even in a
French project.

**`Constraints` is where the batch says what a spec cannot.** The spec is the
binding authority on behaviour; what belongs to the batch and only to it is the
delivery perimeter, the ordering of the user stories, and the migration and
compatibility constraints — so that is what goes here, and nothing normative.
`supercharlouze:writing-a-user-story` copies this section **verbatim** into
every story's `Global Constraints`, where `superpowers:writing-plans` makes it
implicitly part of every task's requirements. Write it as constraints an
implementer can obey, not as background. Left out, each story would silently
invent its own migration rule and its own order.

This pull request does **no writing into the specs**. The delta is stated
here as intention only; it is transcribed slice by slice, by the pull request of
each story (`supercharlouze:writing-a-user-story`). Transcribing the whole delta
now would put behaviour into the spec that no code delivers — drift by
definition, and the reviewers of a story would then report as missing what is
merely not built yet.

**The gaps register is not a spec.** `docs/specs/<module>.gaps.md` records what
the code does that no spec describes, and where the code contradicts one — it
carries no norm, so nothing you write there is normative and the rule above is
untouched. That is why a batch reserves its entries in this same pull request
while still writing nothing into a spec.

**Reserving gaps-register entries — any batch, not only a corrective one.**
Reservation is a property of the opening pull request of **whatever batch takes
an entry on**, and it exists so that two batches cannot draw the same entry. So:
if any part of this batch's scope comes from `docs/specs/<module>.gaps.md`,
reserve every entry it takes on **in this same pull request**, annotating the
entry `reserved by batch-NN`. The reservation lives on `main`; that is what
stops another batch from taking the same gap, and closing a story's pull request
does not carry it away. `supercharlouze:closing-a-batch` releases whatever is
left unconsumed — which it can only do for entries that were reserved in the
first place.

**The two sections of the register do not feed the same kind of batch.**
*Violations* — the code contradicts a spec — feed a **corrective** batch.
*Gaps* — the code does things no spec describes — feed an **ordinary** batch
that finally specifies them, and such a batch has a real spec delta *and*
reservations. Reservation is not a corrective-batch ceremony: an ordinary batch
drawing from *Gaps* reserves exactly like a corrective one. Skip it, and two
batches set out to specify the same undocumented behaviour in parallel, which is
the collision the annotation exists to prevent.

**Corrective batch** — its spec delta is empty by definition: it restores
behaviour a spec already promises. Replace that section with the *Violations*
entries the batch takes on, reserved in `docs/specs/<module>.gaps.md` as above.

**The batch document carries no mutable state.** It is written once, by this
opening pull request, and nothing in the normal course of the batch modifies it
**until closing** — where `supercharlouze:closing-a-batch` amends it and flips
its front matter to `status: closed`, in a reviewed pull request of its own, and
the batch is over. Two consequences follow, and both are deliberate:

- **The list of stories does not appear in it.** The list of stories is the
  content of the batch directory, completed by the open pull requests. A
  hand-maintained one would be edited by every story, conflicting on the same
  file every time, for information the system already holds.
- **Story state does not appear either.** A story's state *is* the state of its
  pull request. A checkbox copies, worse, a truth `gh pr list` gives exactly, and
  goes stale at the first merge that happens outside your session.

## The Feature Flag Field

The `Feature flag` field is **mandatory and never left empty**. "No flag" must be
a stated and reviewed decision, not an omission. It is examined at this gate
because this is the moment when the batch's scope is still ahead of everyone.

The batch is delivered onto a continuously deployed `main`: every
merged story ships. The flag is what makes a story deliverable alone without
exposing a half-built batch.

**The exemption criterion is one question:** *would one story of this batch,
merged alone, leave a user facing something incomplete?* If no, no flag. Three
families answer no by construction:

- **Refactor and infrastructure** — they change no behaviour, so every pull
  request is deployable as is. That is the definition of a refactor, not a
  tolerance granted to it.
- **Corrective batch** — it restores behaviour the spec already promises. Gating
  it would delay a conformance fix, the opposite of its purpose.
- **Single-story batch** — nothing is ever half delivered.

**One flag per (batch, module).** Not per story: the batch is the boundary beyond
which nothing is incomplete. Not per batch either: a cross-module batch that
leaves guarded behaviour in two modules declares **two** flags, one per module.
Otherwise its lifting story would have to delete the gating sentence from two
specs at once, and a story targets exactly one module — it would be impossible to
write.

**A flag's life is short, and the batch bounds it by default.** A flag that
lingers is dead code nobody dares remove, and that failure mode is silent.

**Extended scope, by exception.** A flag may legitimately outlive its batch — a
whole module built over several batches, opened only once complete, is the
typical case. It must then name its scope **and its lifting condition**. That
declaration is not paperwork: it is the only thing that tells a still-useful flag
from a forgotten one, and `supercharlouze:closing-a-batch` refuses to close a
batch whose surviving flag has no declared scope.

Three shapes of the field, and there are no others:

```markdown
Feature flag: `billing.recurring`, off by default — scope: this batch
Feature flag: `billing.recurring`, off by default — scope: beyond this batch,
              lifted when the `facturation` module is fully delivered
Feature flag: none — corrective batch, restores behaviour the spec already promises
```

A cross-module batch is not a fourth shape: it writes **one line per guarded
module**, each of one of those three shapes, and each naming its module so the
lifting story knows which spec it belongs to:

```markdown
Feature flag: `facturation.recurrent`, off by default — scope: this batch — module `facturation`
Feature flag: `relance.recurrent`, off by default — scope: this batch — module `relance`
```

The flag is a specified object, not an implementation detail. Its name, its
default and — when the scope extends — its lifting condition are written into the
**spec section** concerned, by the story that transcribes that section. State
that here so the story author knows it is owed; do not write it into the spec
yourself.

## Surfacing Live Flags

List **every gating sentence in the specs of the modules** this batch touches —
at module granularity, whatever sections the batch actually targets — and copy
each one into the `Live flags` section of the batch document with its lifting
condition. If there are none, write `none`, so that "checked, nothing found" does
not look like "never checked".

The human then rules at the gate: *does this batch satisfy the condition, and
does it therefore carry the lifting story?*

**Record that ruling next to its entry before the pull request merges.** One
line per surfaced flag — `carried by this batch — lifting story owed` or
`not this batch — <reason>` — written into `Live flags` on the batch branch, in
answer to the review. Recording it is review feedback applied to an open pull
request, which is exactly how every other correction reaches this document; it
is not mutable state, because after the merge nothing edits it again. Without
that line the ruling exists only in a review thread:
`supercharlouze:closing-a-batch` checks the flags this batch declared **and the
ones it inherited by a ruling at the opening gate**, and it learns of the second
kind from `Live flags` alone. So a flag declared by batch 05, surfaced by batch
08 and assigned by the human to 08 would be checked by nobody if the lifting
story were never written — the forgotten-flag failure this section exists to
close, reintroduced at the very gate meant to close it.

**Those two annotations are fixed strings, not paraphrases.** Write
`carried by this batch — lifting story owed` verbatim, on one line, immediately
under the surfaced flag it rules on; or `not this batch — <reason>` with the
reason in the project's language after the dash. `supercharlouze:closing-a-batch`
reads the `Live flags` section of this document and matches the literal
`carried by this batch — lifting story owed`; a flag it cannot match that way is
an unruled flag, not a flag ruled away. Reword the annotation and the reader
finds nothing, which is the failure this whole section exists to close.

**`Live flags` is a snapshot, taken for this gate.** It records what was live
when this batch opened and what was ruled about it; it is not a registry to
keep in step with reality. The gating sentence in each module spec remains the
authoritative statement of a flag, its default and its lifting condition —
which is why a closed batch document is never consulted to find out whether a
flag is still live.

The granularity is what makes the control useful. Surfacing only the sections the
batch modifies would let an extended-scope flag survive forever: the last batch
of a module typically adds new sections without touching the old ones, so nothing
would surface, the module would be "fully delivered", and the flag would stay off
for good. Modules are coarse by construction, so reading them whole costs little
and closes that hole. This is the place — and nowhere else — where every batch is
asked again whether a flag has come due.

## Opening the Pull Request

Before opening, reread the batch document against the specs with fresh eyes:
scope stated with its "why now", spec delta per module, `Constraints` stated or
`none`, `Feature flag` filled, reservations made for every gaps register entry
this batch takes on — corrective or ordinary — and live flags surfaced.

Then open the pull request from `batch/NN-<slug>`. Its body states what the
reviewer has to rule on: the flag decision, the scope, and each surfaced live
flag. As the review answers, write each live-flag ruling into the document, on
this branch, before it merges.

**The review of the batch pull request is the human gate.** Until it merges, no
story is written and no spec is touched. It replaces the tail of the
architectural path of `superpowers:brainstorming` — the dated design doc becomes
this batch document, the self-review becomes the reread above, and the human
review of the written spec becomes this pull request review. The human review is
not removed; it changes tool, into the one where you already review everything
else.

## Amending a Batch

The batch document carries no mutable state, but it stays amendable by an
**amendment pull request**, reviewed like the others. That is the exit from two
real dead ends:

- **An exempted batch that discovers it needed a flag** — a "refactor" that
  turned out to change behaviour, a single-story batch that splits in two.
- **A batch whose scope is reduced or abandoned**, including reducing it after a
  requalification, or giving a flag an extended scope so a later batch can decide.

Without this path neither situation has an issue: the `Feature flag` field was
decided at opening, and closing checks it against reality.

Do it on a **distinct branch whose name carries no meaning** — do not reuse
`batch/NN-<slug>`, which the opening pull request may still hold on the remote;
nothing here depends on the name. Edit the batch document **in place** — no
changelog inside it, no history of its own scope — and say in the pull request
body what changed and why. An amendment is not mutable state
flowing along: it is an explicit human decision that goes through a review.

## Requalifying a Corrective Batch

**Trigger — Override 2, the fifth stop condition (corrective batches).** This
plugin adds a fifth stop condition to
`superpowers:subagent-driven-development`: while bringing code into conformance
with a spec, if a story discovers that the **spec** is wrong and the code is
right, it stops. The batch is no longer corrective and must be requalified. The
other four stop conditions assume a valid authority exists; here the authority
itself is in question, and no agent may correct a spec.

**Procedure.**

1. **Abandon the story — and do not assume it has a pull request.** Override 2
   fires *inside* `superpowers:subagent-driven-development`, mid-implementation,
   and a story's pull request is opened only at the very end of its Step 5, by
   `superpowers:finishing-a-development-branch`. So the usual situation when
   this triggers is a branch and a worktree and **no pull request at all**.
   Therefore: **close the story's pull request without merging it if one is
   already open.** Nothing has to be revoked either way, because nothing reached
   `main`: the spec slice, or the struck gaps-register entry, travels with the
   code and dies with the branch. The branch and its worktree go once the choice
   below is ruled: delete the story branch locally and on the remote and remove
   its worktree — whether a pull request existed or not — so no later session
   resumes work under a qualification the batch no longer has. The gaps-register
   reservation is untouched by all of this — it lives on `main`, posted by the
   opening pull request, and `supercharlouze:closing-a-batch` releases it.
2. **Put the choice to the human**, who alone may rule:
   - **Correct the spec** — then the batch stays corrective, on a reduced scope,
     and the corrected spec ships through its own pull request; or
   - **Rewrite the batch as an ordinary batch**, with a real spec delta, through
     a **new batch pull request** that goes back through the gate above.

   The rewrite keeps `NN` and its directory: the number identifies a delivery
   unit, and any story already merged lives under it — a new number would strand
   them. So it is an amendment pull request on the existing document, replacing
   the reserved gaps entries with a `Spec delta`, reviewed at the gate like an
   opening. Allocate a fresh `NN` only when the human rules that the remaining
   work is a *different* batch, and then close this one with
   `supercharlouze:closing-a-batch` rather than leaving it open.
3. **Revise the gaps register reservations** in either case: entries annotated
   `reserved by batch-NN` that are no longer in scope must be released, and
   `supercharlouze:closing-a-batch` releases whatever is left unconsumed.

Never carry out a requalification by deciding the substance yourself. Correcting
a spec is a human act, never an agent act. Your job is to present the choice with
its consequences, then execute what is ruled.

## Language

**English skeleton, project-language prose**, inside every document you write
here. Section headings, field names, front matter values (`status: open`), table
headers, path patterns and branch patterns are English, always, whatever the
project speaks. The prose is in the project's language: the scope, the "why now",
the spec delta, the justification of the flag decision. Slugs name business
objects, so they follow the project's language too.

This plugin's own files are entirely English — it has no business prose, only
skeleton.

## Red Flags

| Thought | Reality |
|---------|---------|
| "No flag needed, this batch is small" | Small is not the criterion. Would one story, merged alone, leave a user facing something incomplete? |
| "I'll take the next free number from the directory" | A batch in an open pull request has not reached main yet. Ask gh too. |
| "I'll add the story list to the batch document, it's clearer" | Every story would then conflict on that file, for information the directory already holds. |
| "There's a flag on this module but my batch doesn't touch that section" | Surface it anyway. That is how an extended-scope flag gets lifted instead of forgotten. |
| "I'll transcribe the spec delta now, while it's fresh" | The spec would then describe behaviour no code delivers. Each story transcribes its own slice. |
| "The module has no spec yet, I'll write the batch and adopt later" | Adoption is blocking. Otherwise the batch invents the norm it is supposed to obey. |
| "The spec is wrong here, I'll fix it and keep the batch corrective" | Only the human corrects a spec. Stop the story, present the requalification choice. |
| "This batch is ordinary, reservations are a corrective-batch thing" | Any batch taking on gaps register entries reserves them at opening — a Gaps entry as much as a Violations one. Otherwise two batches specify the same behaviour. |
| "Requalification starts by closing the story's pull request" | Override 2 fires mid-SDD, usually before any pull request exists. Close it only if it is already open; otherwise discard the branch and its worktree. |
| "The scope changed, I'll slip the edit into the next story's pull request" | Then the change is never reviewed as a scope change. The batch document has no mutable state: it moves only through an amendment pull request of its own. |
| "The human ruled on the live flags in the review, that's recorded" | A review thread is not the document. Write the ruling into `Live flags` before the merge, or closing has nothing to check. |
| "The flag will obviously be removed at the end, no need to say when" | A flag outliving its batch without a stated lifting condition is indistinguishable from a forgotten one, and blocks closing. |
