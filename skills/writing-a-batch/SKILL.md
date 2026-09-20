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

`NN` is the **smallest integer not used in `docs/batches/` on `main`, not
claimed by an open pull request, and not claimed by a pushed `batch/*` or
`story/*` branch that carries no pull request yet**. All three, always:

```bash
ls docs/batches/
gh pr list --state open --json number,headRefName
git ls-remote --heads origin 'batch/*' 'story/*'
```

An artifact only reaches `main` when its pull request merges, so
the directory listing knows nothing about work in flight. Trusting the directory
alone hands the same number to two batches opened in parallel — and the second
one discovers it at merge time, after review.

**The third source closes the same window, by the same argument, as the
concurrency scan of `supercharlouze:writing-a-user-story`** — read it as one
idea applied twice, not as two coincidences. A branch is on the remote as soon
as it has a commit, while its pull request may not open for a long while, so for
that whole stretch it claims its number and `gh pr list` shows nothing at all.
The branch name already carries the number — `batch/NN-<slug>` and
`story/NN-us-N-<slug>` — so the remote listing answers on its own, with nothing
to fetch and no file to read. That is also why the pull request query asks for
`headRefName`: the number is in the head branch name, and nothing else in a
pull request states it.

Both patterns are scanned because both spell `NN`, but they do not carry the
same weight. On the nominal path the `story/*` half finds nothing new:
`supercharlouze:writing-a-user-story` requires the batch's opening pull request
to be **merged** before any story is written, so wherever a `story/NN-us-N-`
branch exists, `docs/batches/NN-<slug>/` is already on `main` and the directory
listing above sees it. Scan it anyway — it is one line and it is the only thing
that answers in the degraded case where that precondition was skipped and a
story branch is the sole trace of its batch.

The branch is `batch/NN-<slug>`. Path and branch patterns are English and fixed;
the slug follows the project's language, because it names a business object.

Create the branch and workspace by invoking `superpowers:using-git-worktrees`.
That skill prefers the harness's native tooling, which picks its own branch name
and may leave you on a detached HEAD. This plugin enforces its own naming: if you
end up elsewhere, restore the conventional name before going on:
`batch/NN-<slug>`. **A named branch is not enough.** Allocating `NN` above reads
`batch/*` and `story/*` on the remote to refuse a number already claimed, so a
branch left under a harness-chosen name claims nothing, and hands its number to
the next batch opened in parallel.

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

<The exact text this batch writes into the specs, in blocks. Per block: its
`D<n>` identifier, the spec and the section it targets, then the current passage
and the text that replaces it, the passage it removes, or the text it inserts and
where. Including the removal of the gating sentence of any flag an earlier batch
declared and this batch takes on.>

## Constraints

<Migration and compatibility constraints, the required ordering of the user
stories, and the order of any two blocks that change the same section. `none`
if there are none.>

## Feature flag

<See the next section. Never omitted.>
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

This pull request does **no writing into the specs**. The delta is
written here as **exact text, in blocks**, and no block is transcribed at
opening: each one is transcribed, word for word, by a story, in that story's own
pull request (`supercharlouze:writing-a-user-story`). Transcribing the whole delta
now would put behaviour into the spec that no code delivers — drift by
definition, and the reviewers of a story would then report as missing what is
merely not built yet.

**A block is the unit of the delta.** Each one carries an identifier `D<n>`,
unique within the batch, and names the spec and the section it targets. To modify
a passage, it quotes the current passage, then the text that replaces it; to
remove one, it quotes it; to add text, it gives that text and where it goes.
Quote the passage as `main` carries it now: the story transcribes against it.

**No block is attached to a story.** The story chooses, as it is written, the
blocks it transcribes; the batch document names no story and carries no list of
them. A section that changes twice in the course of the batch carries two blocks,
and `Constraints` states their order.

**The gaps register is not a spec.** `docs/specs/<module>.gaps.md` records what
no spec describes, and where the code contradicts one — it
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

**The two categories of the register do not feed the same kind of batch.**
*Violations* — the code contradicts a spec — feed a **corrective** batch.
*Gaps* — something real that no spec describes — feed an **ordinary** batch
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

## Flags Declared by Earlier Batches

**The specs are the registry of flags.** A flag exists as long as its gating
sentence stands in a spec section, with its default and, when it outlives its
batch, its lifting condition. There is no other list to keep, and the batch
document copies none: anyone reading or changing that section sees the flag.

So read the gating sentences of the specs this batch touches. When this batch's
work satisfies one's lifting condition, and your human partner agrees, **state
its lifting in the `Spec delta`**, as a block that removes its gating sentence.
Lifting a flag is a change of spec like any other, delivered by a lifting story
(`supercharlouze:writing-a-user-story`), and `supercharlouze:closing-a-batch`
catches it undelivered the way it catches any block the delta announced and no
story declared.

A flag whose condition is met and that no batch takes on stays where it is: in
the spec, with its condition, in front of whoever touches that section next.

## Opening the Pull Request

Before opening, reread the batch document against the specs with fresh eyes:
scope stated with its "why now", spec delta in blocks — each with its `D<n>`,
the spec and section it targets, and its exact text, every quoted passage
matching `main` —, `Constraints` stated or `none` — including the order of any
section that carries two blocks —, `Feature flag` filled, reservations made for
every gaps register entry this batch takes on — corrective or ordinary — and the
lifting of any earlier flag this batch takes on stated as a block.

Then open the pull request from `batch/NN-<slug>`. Its body states what the
reviewer has to rule on: the exact text of every block, the flag decision, the
scope, and any flag lifting the delta announces.

**The review of the batch pull request is the human gate.** Until it merges, no
story is written and no spec is touched. It bears on the exact text of every
block: this is where the human reads what the specs will say, before any code is
written on it — block by block, in the batch document, and not later as a diff of
the spec. It replaces the tail of the
architectural path of `superpowers:brainstorming` — the dated design doc becomes
this batch document, the self-review becomes the reread above, and the human
review of the written spec becomes this pull request review. The human review is
not removed; it changes tool, into the one where you already review everything
else.

**Ending the review.** The agent never approves and never merges a pull request.
Each correction the review asks for is pushed as a `fixup!` commit of the commit
it corrects, or as a commit of its own when it carries a fresh decision — the
block texts are what the human is reading, and a force-push mid-review replaces
the very lines their comments hang on. Your human partner gives their agreement
in the conversation; then you squash the fixups, push, and announce the pull
request ready.

**Merging this pull request is a moment to clear the context.** The batch
document now carries the exact text of every block, which is what the design
conversation was for — and that conversation also carries every option you
discarded on the way, which the first story must not inherit.

The announcement therefore names `supercharlouze:writing-a-user-story` as the
next step and gives its prompt in a block to copy and paste. **That prompt stands
on its own:** it names the skill to invoke, the batch document by path, and says
to choose the blocks from those the document still carries, and it never refers
back to this conversation.

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
`batch/NN-<slug>`, which the opening pull request may still hold on the remote.
An amendment claims neither a fresh number nor any sections, so no scan looks for
its branch and its name has nothing to carry: that is what makes it the one
exception to restoring a conventional name, and the exception holds for that
reason alone. Edit the batch document **in place** — no
changelog inside it, no history of its own scope — and say in the pull request
body what changed and why. An amendment is not mutable state
flowing along: it is an explicit human decision that goes through a review.

**An amendment merges into the same clear moment as an opening**, and ends its
review the same way: fixups during the review, agreement in the conversation,
squash, and an announcement that names the next step. What differs is which step
that is — an amendment hands back to whatever the batch was doing when it stopped,
so the announcement names that, and its prompt names the amended batch document
by path.

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
   `main`: the spec change, or the struck gaps-register entry, travels with the
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
     an **amendment pull request** that goes back through the gate above.

   The rewrite keeps `NN` and its directory: the number identifies a delivery
   unit, and any story already merged lives under it — a new number would strand
   them. Hence an amendment pull request on the existing document, replacing
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
| "I'll take the next free number from the directory" | Work in an open pull request has not reached main yet, and a pushed branch may hold a number with no pull request at all. Ask gh and `git ls-remote --heads` too. |
| "I'll add the story list to the batch document, it's clearer" | Every story would then conflict on that file, for information the directory already holds. |
| "This batch satisfies that flag's lifting condition, I'll lift it in passing" | Lifting is a spec change. State it in the `Spec delta`, where the gate sees it, and a lifting story delivers it. |
| "I'll transcribe the spec delta now, while it's fresh" | The spec would then describe behaviour no code delivers. Each story transcribes its own spec change. |
| "The delta only needs to say what changes — the story will find the words" | The delta is the exact text. The opening review is where the human reads what the specs will say; wording left to a story reaches them only once code is built on it. |
| "The module has no spec yet, I'll write the batch and adopt later" | The design stops. Otherwise the batch invents the norm it is supposed to obey. |
| "The module has no spec, I'll adopt it right now and come back" | Adoption is never conducted in the same context. It would carry the mechanisms it read in the code into the design that follows. Stop, and resume in a fresh context after the merge. |
| "The spec is wrong here, I'll fix it and keep the batch corrective" | Only the human corrects a spec. Stop the story, present the requalification choice. |
| "This batch is ordinary, reservations are a corrective-batch thing" | Any batch taking on gaps register entries reserves them at opening — a Gaps entry as much as a Violations one. Otherwise two batches specify the same behaviour. |
| "Requalification starts by closing the story's pull request" | Override 2 fires mid-SDD, usually before any pull request exists. Close it only if it is already open; otherwise discard the branch, locally and on the remote, and its worktree — a branch left on the remote reads as a live claim on its sections. |
| "The scope changed, I'll slip the edit into the next story's pull request" | Then the change is never reviewed as a scope change. The batch document has no mutable state: it moves only through an amendment pull request of its own. |
| "The flag will obviously be removed at the end, no need to say when" | A flag outliving its batch without a stated lifting condition is indistinguishable from a forgotten one, and blocks closing. |
