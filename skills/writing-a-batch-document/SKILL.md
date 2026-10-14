---
name: writing-a-batch-document
description: Use only when a skill tells you to invoke writing-a-batch-document, never on a request to write or change a batch document - gives the form of a batch document and of its fields, for a document to write and for one to amend
user-invocable: false
---

# Writing a Batch Document

## Overview

This skill carries the form of a batch document and of its fields.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the writing-a-batch-document skill to write
this batch document."

The skill that invokes it gives the batch's `NN` and its slug for a document to
write, or the batch document and what changes in it for a document to amend.

Write a new document whole, from the template below.

Amend a document in place, in the fields the change touches, and keep in it no
history of what it said before.

Once the document is written, go on with the step that invoked this skill.

## The Document

Write `docs/batches/NN-<slug>/README.md`:

```markdown
---
status: open
---

# NN — <title>

## Scope

<What this batch delivers, including every gaps register entry it takes on.>

## Spec delta

<The exact text this batch writes into the specs, in blocks. Per block: its
`D<n>` identifier, the spec and the section it targets, then its change shown in
the paragraph that contains it. Including the removal of the gating sentence of
any flag an earlier batch declared and this batch takes on. Never left blank:
with no block, `none` and the reason.>

## Technical design

<The design your human partner approved during the brainstorming: the mechanism
the stories are planned from. Never left blank: with no design, `none` and the
reason.>

## Constraints

<Only the migration and compatibility constraints, the technical decisions the
rest of the technical design relies on, and the required order of the stories
and of the blocks. `none` if there are none.>

## Feature flag

<See `The Feature Flag Field`. Never omitted.>
```

The document follows `Language` in `supercharlouze:following-the-rules`: English
skeleton, prose in the project's language.

Every text of the document follows `Concision` in `supercharlouze:following-the-rules`.

**The batch document carries no mutable state.** It is written once, when the
batch opens, and nothing in the normal course of the batch modifies it **until
closing**, which withdraws from it the blocks no story delivered and flips its
front matter to `status: closed`. Before closing, it changes only through an
amendment. Two consequences follow, and both are deliberate:

- **The list of stories does not appear in it.** The list of stories is the
  content of the batch directory, completed by the open pull requests and by
  the pushed `story/*` branches that carry no pull request yet. A
  hand-maintained one would be edited by every story, conflicting on the same
  file every time, for information the system already holds.
- **Story state does not appear either.** A story's state *is* the state of its
  pull request. A checkbox copies, worse, a truth `gh pr list` gives exactly, and
  goes stale at the first merge that happens outside your session.

## The Spec Delta

The delta is written here as **exact text, in blocks**: each block is
transcribed word for word by a story, in that story's own pull request.

**Invoke `supercharlouze:writing-in-a-spec` before writing a block.** A block is
the exact text a spec will receive, so what a spec contains holds for every
sentence of it.

**A block is the unit of the delta.** Each one carries an identifier `D<n>`,
unique within the batch, and names the spec and the section it targets.

A block shows what it changes in the paragraph that contains it. A fragment and
its replacement, quoted apart, leave the reviewer to rebuild the paragraph, and
the sentence the change contradicts two lines further on goes unseen. Give the
paragraph in a `diff` fence: its lines as `main` carries them, each removed line
prefixed `-`, each added line `+`, each unchanged line a space. The story
transcribes against those lines, so take the paragraph from `main` as it stands.

A block that changes a whole section is the exception: one that rewrites it
gives the section as it will read, one that inserts it gives it and names the
section it follows, one that removes it names it.

````markdown
### D4 — `docs/specs/facturation.md`, `Subscription > Renewal`

```diff
 A subscription renews on its anniversary date, for the same length.
-The customer is notified seven days before.
+The customer is notified fourteen days before, and may decline the renewal
+until the day before.
```
````

**No block is attached to a story.** The story chooses, as it is written, the
blocks it transcribes; the batch document names no story and carries no list of
them. A section that changes twice in the course of the batch carries two blocks,
and `Constraints` states their order.

**A rule belongs to exactly one spec.** A batch may cut across modules, so its
delta may well carry blocks aimed at several specs — that is ordinary. What is
not: two blocks writing the same rule into two specs. That is not a delta with a
duplicate in it, it is a module breakdown asking to be revisited, and this is the
one place in the flow where it becomes visible, because this is the one document
that faces several specs at once. Stop and put it to your human partner before
going on. No wording of the delta settles it, and a review is not where a
breakdown gets decided in passing.

**The `Spec delta` field is never left blank.** It carries the blocks, or `none`
and the reason. "No block" is a decision, and a decision is stated.

A corrective batch has no block by definition: it restores behaviour a spec
already promises. Its `Spec delta` reads `none` with that reason, and its
`Scope` lists the *Violations* entries it takes on.

## Technical Design and Constraints

`Technical design` carries the design your human partner approved during
`superpowers:brainstorming`, which this document replaces as the design doc.
Each story's plan starts from it, and a story may depart from it by recording
a `Technical design ruling:`.

What a user or a neighbouring module would observe goes in a block, never in
`Technical design`.

Nothing normative goes in `Constraints`: the spec is the binding authority on
behaviour. Every story's `Global Constraints` copies this section **verbatim**,
which makes it part of every task's requirements. Write it as constraints an
implementer can obey, not as background. Left out, each story would silently
invent its own migration rule, its own order, and its own version of a decision
the rest of the design relies on.

A technical decision goes in `Constraints` only if the rest of the technical
design relies on it, such as a name or a format several parts of the design use.
Every other technical decision goes in `Technical design`, where a story may
depart from it.

A batch's constraints bind only its stories.

## The Feature Flag Field

The `Feature flag` field is **mandatory and never left empty**. "No flag" must be
a stated and reviewed decision, not an omission.

Decide it by `The Model` in `supercharlouze:following-the-rules`: the exemption
criterion and the families that answer it by construction, one flag per (batch,
module), and the scope and the lifting condition a flag declares when it
outlives its batch.

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

The flag's name, its default and, when the scope extends, its lifting condition
are written into the spec section concerned by the story that transcribes that
section. State them here so the story author knows the gating sentence is owed;
do not write it into the spec yourself.

## Flags Declared by Earlier Batches

**The specs are the registry of flags.** A flag exists as long as its gating
sentence stands in a spec section, with its default and, when it outlives its
batch, its lifting condition. There is no other list to keep, and the batch
document copies none: anyone reading or changing that section sees the flag.

So read the gating sentences of the specs this batch touches. When this batch's
work satisfies one's lifting condition, and your human partner agrees, **state
its lifting in the `Spec delta`**, as a block that removes its gating sentence.
Lifting a flag is a change of spec like any other, delivered by a lifting story,
and a lifting left undelivered is withdrawn at closing like any block the delta
announced and no story declared.

A flag whose condition is met and that no batch takes on stays where it is: in
the spec, with its condition, in front of whoever touches that section next.

## Red Flags

| Thought | Reality |
|---------|---------|
| "No flag needed, this batch is small" | Small is not the criterion. Would one story, merged alone, leave a user facing something incomplete? |
| "I'll add the story list to the batch document, it's clearer" | Every story would then conflict on that file, for information the directory already holds. |
| "This batch satisfies that flag's lifting condition, I'll lift it in passing" | Lifting is a spec change. State it in the `Spec delta`, where the gate sees it, and a lifting story delivers it. |
| "The delta only needs to say what changes — the story will find the words" | The delta is the exact text. The opening review is where the human reads what the specs will say; wording left to a story reaches them only once code is built on it. |
| "The flag will obviously be removed at the end, no need to say when" | A flag outliving its batch without a stated lifting condition is indistinguishable from a forgotten one, and blocks closing. |
| "The rule holds for both modules, so the delta carries it twice" | A rule belongs to exactly one spec, so two blocks writing the same rule into two specs signal the breakdown, not a delta. Stop and put it to your human partner. |
| "The design is obvious from the delta, `Technical design` can say `none`" | An obvious design is still a design: write it. `none` is for a batch with no design to plan from, and it carries its reason; written `none`, it leaves each story to invent its own mechanism. |
| "This technical decision matters, so it goes in `Constraints`" | Only if the rest of the technical design relies on it. Otherwise it goes in `Technical design`, where a story may depart from it by a ruling. |
