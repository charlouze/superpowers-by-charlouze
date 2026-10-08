---
name: adopting-a-module
description: Use when a batch touches a functional module that has no living spec yet - builds the spec from human-validated documents and produces the gaps register
---

# Adopting a Module

## Overview

Adoption establishes the living spec of a functional module — the binding authority
that every review, every batch and every drift ruling in this system depends on.
It is the most delicate operation here, because everything downstream inherits
whatever it gets wrong, and nothing downstream can detect the mistake.

It produces one pull request carrying the spec at `docs/specs/<module>.md`, the
gaps register at `docs/specs/<module>.gaps.md`, the ADRs it writes, and no code.
Until that pull request is merged the module is not adopted, and no batch may
start on it.

Run this when a batch is about to touch a module that has no spec yet — always
**in a context of its own**. A design that discovers an unadopted module stops
instead of chaining here; you arrive from a conversation that begins with this
adoption, or directly when your human partner asks for a module to be adopted.
`supercharlouze:writing-a-batch` carries the rule and the reason in its
`Preconditions`.

**Announce at start:** "I'm using the adopting-a-module skill to adopt the
<module> module."

**Start by invoking `supercharlouze:following-the-rules`, unless this session already has.**

## Source Authority

Three ranks, and they never trade places:

1. **The validated documents.** Here, validated documents are normative on the
   **intentions they state**, never on the **mechanisms they describe** — and a
   design document is full of the latter. A mechanism read in a validated
   document does not enter the spec: it becomes a gap naming its document, and
   only your human partner can promote it from there. Within that bound, only
   they create normative text.
2. **The code.** It never corrects a document. It fills the *silences* — behaviour
   no document ever described. And what it reveals in a silence does not enter the
   spec on its own authority: it is recorded as a gap. Only your human partner can
   promote it to specification.
3. **Your human partner.** They arbitrate every contradiction that rank 1 leaves
   open.

**The spec is never reconstructed from the code.** This is the load-bearing rule of
the whole plugin, so know why it holds: a spec written from the code is a spec no
code can contradict. Drift becomes canon at the moment it is written down,
violations become undetectable by construction, and corrective batches lose the
baseline that makes them possible. A spec that describes what the code happens to
do answers no question worth asking.

The pressure to break this rule is highest exactly where the documents are thinnest
— that is the moment to slow down, not to improvise.

**And you do not read *through* a mechanism to deduce the intention it served.**
Adoption is where that is most tempting: a validated document describes a
mechanism, the intention behind it looks one paraphrase away, and it is not.
What a document states as an intention is normative and goes in; what it
states as a mechanism becomes a gap. Deducing an intention from a mechanism is
reconstruction from the code by another road, whether you read that mechanism in
the code or in a validated document. An intention comes from a validated document
or from your human partner.

## Steps

**Check the preconditions first, before creating any branch and long before
writing a line of either document.** They are the ones every pull request of this
system checks:

- **The branch you are about to create starts from `main` as the remote carries
  it.** Fetch, then branch from `origin/main`, never from another branch. The
  reason matters, because this is exactly the rule an agent talks itself out of:
  `superpowers:finishing-a-development-branch` *preserves* the worktree on the
  pull request path, so `superpowers:using-git-worktrees` Step 0 sees
  `GIT_DIR != GIT_COMMON`, concludes "already in a linked worktree", reuses it,
  and the adoption lands on the previous piece of work's branch. And merges
  arrive from the remote: an adoption written from a stale starting point audits
  code that is no longer there.
- **`gh` is available and authenticated.** The adoption ends in a pull request.

The order below is not a suggestion. **The branch exists before either document
is written** — step 3 — because `superpowers:using-git-worktrees` creates a
*separate directory*: writing the spec first would leave it uncommitted where you
started, and the new workspace would open empty.

### 1. Delimit the module

Your human partner names the module and draws its contours. You never delimit one
yourself — not from the directory layout, not from package names, not from how the
code happens to be split today.

Ask first. Their breakdown comes before any of yours: never open with a proposal
of your own, because an opening suggestion is read as a decision. If they want it,
think it through with them — show what exists (entry points, directories, obvious
clusters) as material, ask questions, lay options side by side. The decision stays
theirs, and nothing is written until they have made it.

Prefer one coarse module to several small ones; how many a project needs depends
on the size of the product, not on a fixed count. A wrong boundary contaminates
the spec, the gaps register, and every batch that follows. One late signal
exists, and only one: **a rule belongs to exactly one spec**, so a rule that
later turns out to constrain behaviour observable at the boundary of more than
one module sends the breakdown back to your human partner. Do not lean on it —
it fires batches later, and only for the boundaries a rule happens to straddle.

Record the agreed boundary at the top of the spec: what the module covers, and what
it explicitly does not.

### 2. Inventory the validated documents

Find every document that could describe the module: archived superpowers design
docs under `docs/archive/specs/`, README files, business documentation, ADRs,
product notes.

**Present the list to your human partner before you write a single line of spec.**
They can add a source you missed and drop one that was never validated. The
quality of the spec is capped by this inventory — a source missed here is a hole in
the spec, and no later step fills it.

For each candidate, say where it is and why you believe it covers the module. Never
assume a document is validated because it exists, looks official, or is the only
one you found. "Close enough to validated" is not validated: ask.

Record the retained inventory in the **body of the adoption pull request**, by
archive path, next to its rulings, at the step `Open the adoption pull request`:
it is what the reviewer checks the spec against. The spec itself lists no
sources — it is a living document, and archived documents stop evolving the day
they are archived.

### 3. Create the branch

Now, and not later. Create the branch `adopt/<module>` and its workspace by
invoking `superpowers:using-git-worktrees`, then move into that workspace: every
file the next two steps write belongs there.

That skill prefers the harness's native tooling, which picks its own branch
name and may leave you on a detached HEAD, and may branch from wherever you
happened to be. If it leaves you on a differently named branch, a detached
HEAD, or a starting point other than `origin/main`, restore the conventional
name and the starting point before going on: `adopt/<module>`, from
`origin/main`. **A named branch is not enough** — and here that is a matter
of convention rather than mechanism, which is worth saying plainly: nothing
scans `adopt/*`. Number allocation reads `batch/*` and `story/*`, the
concurrency scan reads `story/*` and `bounded/*`, and an adoption branch claims no number and
holds no sections, so it is equally unseen under either name. The convention
is uniform anyway: a rule honoured only where a scan would catch you is not a
rule. And it is on `batch/*` and `story/*` that it bites — there, a branch
under the wrong name silently hands away its number and its sections for the
length of an implementation.

The two steps before this one are dialogue: they produce a boundary and an
inventory, not files. Everything after it writes.

### 4. Write the spec from those documents only

Merge, deduplicate, reconcile. The spec is normative — what the code must do — not
descriptive.

**Invoke `supercharlouze:writing-in-a-spec` before writing the first sentence.**

- **Every sentence you write passes the other-implementation test**, and what it
  ejects **goes straight into the gaps register**, naming the document it came
  from. Create `docs/specs/<module>.gaps.md` the first time you need it, and
  invoke `supercharlouze:writing-in-a-gaps-register` before writing in it. The
  authority rule of `Source Authority` above holds while you write: a mechanism
  the document prescribes is no more admissible here than one you read in the
  code.
- Exception: put to your human partner a technical decision the test ejects
  that meets the conditions of an ADR, which
  `supercharlouze:following-the-rules` states. If they want it as an ADR, invoke
  `supercharlouze:recording-a-decision`, and the ADR travels in the adoption
  pull request. Otherwise it becomes a gap.

**A rule belongs to exactly one spec.** If a rule you are about to write would
constrain behaviour observable at the boundary of more than one module, stop
before writing it: the breakdown is what is in question, not the wording, and a
breakdown is your human partner's decision. Do not write it into both specs, and
do not give it a home above them. You are adopting one module, so the second
module may not even have a spec yet — that changes nothing: the signal is the
rule's reach, not what already exists next door.

- **Nothing enters the spec that no validated document supports.** Behaviour you
  found in the code but no document describes belongs to the gaps register, not
  here.
- **When two validated documents contradict each other, the most recent wins by
  default** — and the arbitration is written down as
  `Ruling: <decision> — <why> — <what it costs if it is wrong>`. Never resolve a
  contradiction in silence; the ruling is what lets a reviewer disagree with you.
  Adoption has no story document and therefore no Rulings log, so these lines go
  in the **body of the adoption pull request**, at the step
  `Open the adoption pull request`, where the reviewer who might disagree will
  read them.
- No date, no status, no work-in-progress marker, except a flag's gating sentence.
  On `main`, spec and code always travel in the same pull request, so no other
  state exists that would need one.
- **Titled sections are the unit of the whole system** — concurrency detection and
  gaps entries both designate a section. Title them so they can be pointed at.

**The shape of the spec.** Minimal, and every part of it load-bearing:

```markdown
# <module>

## Boundary

<What this module covers, and — explicitly — what it does not.>

## <A titled section>

<Normative prose: what the code must do. Titled so a gaps entry, a story's
`Sections:` field and a concurrency check can all point at it.>
```

No front matter, no date, no status. The section titles are English skeleton;
the prose under them follows the project's language.

### 5. Audit the code against the spec

Read the code against each section you just wrote, and add to the gaps register
what the audit reveals, each finding as an entry under its category.

Write the register's `Coverage` from this audit.

Fix nothing in the code while you are here. Adoption produces the register;
resorbing a violation is a batch of its own, with its own review.

### 6. Offer to promote the gaps

The code often carries intentions no document ever made visible. **Offer your
human partner to promote the gaps into the spec**, one gap at a time, before the
pull request opens. For each gap that describes a behaviour observable at the
module's boundary, ask whether that behaviour carries an intended rule — a
question about the intention, never about the mechanism. What they validate goes
into the spec, under the section that behaviour constrains, and **its entry is
deleted from the register** — this is an adoption that promotes a gap into the
spec, and that is the reason the commit that removes it gives. Everything else
stays there.

The intention comes from them, not from you: you show the behaviour, they state or
confirm what it is for. Paraphrasing an intention from the code yourself and
asking for a yes is reconstruction from the code with extra steps. A gap that
names a mechanism is not put to them at all — validating a mechanism would not
make it a rule, only an approved drift.

### 7. Have the spec reread

Before the pull request opens, invoke `supercharlouze:rereading-a-spec` on the
spec.

File each sentence it returns as a mechanism in the gaps register, as a gap
naming the document the sentence came from when it came from one.

Exception: a technical decision among them that meets the conditions of an ADR
is handled as the step `Write the spec from those documents only` says.

A rule it returns as reaching past this module's boundary stops the adoption: the
breakdown goes back to your human partner.

### 8. Open the adoption pull request

The branch already exists — you created it at step 3. Commit the spec, the gaps
register and the ADRs you wrote on it, push, and open the pull request.

The pull request carries the spec, the gaps register and the ADRs you wrote, and
no code. Its body
carries what a reviewer needs to disagree with you: the boundary as your partner
drew it, the retained inventory, the rulings from step 4, and the declared
coverage. **The pull request body is where an adoption's inventory and rulings
live.** List every retained document by archive path, with why it covers the
module — or state that no validated document existed. The spec lists no sources,
so this body is the one place that says what the spec was written from; it stays
readable long after the merge. Adoption produces no story document either, so
there is no Rulings log to write the rulings into, and a ruling nobody can read is
a contradiction resolved in silence.

**The review of the adoption pull request is the mandatory human review.** It is the
adoption gate, and there is no other one — this plugin adds no ceremony, it puts
its gates where your flow already has reviews. Until that pull request is merged
the module is not adopted and no batch may start on it. An open adoption pull
request is not adoption; do not start `supercharlouze:writing-a-batch` on the
strength of one.

**Ending the review.** The agent never approves and never merges a pull request,
here as at every gate. Each correction the review asks for is pushed as a
`fixup!` commit of the commit it corrects, or as a commit of its own when it
carries a fresh decision; your human partner gives their agreement in the
conversation, and only then do you squash the fixups, push, and announce the
pull request ready.

**Merging this pull request is a moment to clear the context**, and your human
partner's announcement of the merge is where you say so. The adoption
conversation carried an inventory, rulings and a boundary argument that the
merged documents now carry better than it does — and worse, it carried every
mechanism you read while auditing the code, which is exactly what must not leak
into the batch that follows.

So when your human partner announces the merge, name
`supercharlouze:writing-a-batch` as the next step, and give the prompt for it in
a block to copy and paste. **That prompt stands on its own:** it names the skill
to invoke, and the prompt names the adopted spec by path, and the gaps register
beside it, and never refers back to this conversation.

That next step is a **start, not a return**. A design that stopped on this
module does not carry over: it begins again from the adopted spec, not from a
conversation, and whatever it had established before the stop is restated there
or lost. Saying so is what keeps the clear honest — a design resumed from memory
would bring back the very mechanisms the clear was meant to drop.

## Degraded Case: A Module With No Validated Documents

Sometimes the inventory comes back empty: no validated document covers the module.
Adoption from documents is impossible, and reconstruction from the code stays
excluded — it would canonize drift here exactly as it would anywhere else.

Switch to dialogue:

1. Enumerate the behaviours **observable at the module's boundary**, grouped as
   candidate sections.
2. Ask your human partner, section by section: *is this intended?* — a question
   about the intention, never about the mechanism.
3. What they validate becomes the spec. Everything else goes to **Gaps**.

The boundary is what bounds the enumeration, and it is load-bearing: an agent
reading code sees infrastructure first, so an unbounded enumeration puts data
stores, triggers and adapter layers to your partner one at a time. **A mechanism
is not submitted to human validation** — validating it would not make it a rule,
only an approved drift, and approved drift is worse than drift because nothing
downstream can tell it apart from a decision. Enumerate what a user or a
neighbouring module could observe, and nothing else.

Each answer is a human validation, and human validation is the only thing that can
create normative text where no document exists. So ask section by section: a wall
of questions gets one blanket "yes" back, and a blanket yes is reconstruction from
the code with extra steps.

The adoption pull request body then records that there was no validated document,
rather than staying silent. The declared coverage says which behaviours were never
put to your partner.

The same treatment applies to a partial inventory: the covered part of the module
follows steps 2 to 6, the uncovered part follows this dialogue. Either way the
branch of step 3 is created before anything is written.

## Language

English skeleton, project-language prose: section titles, field names, table
headers, front matter values and path patterns are English, while requirement
bodies, descriptions, rationale and the slugs naming business objects follow the
project's language. The spec and the gaps register you write obey this rule.

Every text this skill writes follows `Concision` in `supercharlouze:following-the-rules`.

## Red Flags

| Thought | Reality |
|---------|---------|
| "The code is the real truth, I'll spec what it does" | That canonizes drift and destroys the premise of corrective batches. |
| "The document prescribes this mechanism, so it is normative" | A validated document is authority over the intentions it states, not the mechanisms it describes. The mechanism goes to the register, naming its source. |
| "The intention behind this mechanism is obvious, I'll write it down" | Deducing an intention from a mechanism is reconstruction from the code by another road. It comes from a document or from your partner, or it goes to the register. |
| "I can infer the module boundaries from the directory layout" | Boundaries belong to your human partner. A wrong one contaminates everything downstream. |
| "This old design doc is close enough to validated" | Ask. The spec's quality is capped by the inventory. |
| "I'll write the spec first and show the source list with it" | The inventory is presented before anything is written, or your partner reviews sources they can no longer change your mind about. |
| "These two documents disagree, I'll keep the clearer one" | Most recent wins by default, and the choice is a ruling, written down. |
| "This behaviour is obviously intended, so into the spec it goes" | Obvious to you is not validated by them. Undocumented behaviour is a gap until a human says otherwise. |
| "No documents exist, so I'll draft from the code and have them confirm" | A draft to confirm is a blanket yes waiting to happen. Section by section, one question at a time. |
| "They said yes to it, so this mechanism is now a rule" | A mechanism is not submitted to validation. Enumerate what is observable at the boundary; a validated mechanism is approved drift. |
| "I'll write the two documents first and create the branch to carry them" | using-git-worktrees opens a separate, empty directory. The branch comes first, at step 3, or both files stay stranded where you started. |
| "I'm already in a worktree, that will do" | The worktree is not the problem; the branch is. Step 0 reuses the workspace, and the adoption lands on the previous branch unless you create the branch from `origin/main` yourself. |
| "The adoption PR is open, the batch can start" | Merged is adopted. The review is the gate, not the push. |
| "I found a violation, I'll fix it while I'm in there" | Adoption produces the register. The fix is a corrective batch, with its own review. |
| "I ejected those mechanisms at step 4, the code audit will pick them up" | It cannot. A mechanism the code never implemented has no code to audit, and step 4's set-aside list is its only route into the register. |
| "This rule concerns the neighbouring module too, I'll write it in both specs" | A rule belongs to exactly one spec, and a rule that reaches past one boundary signals the breakdown — your human partner's decision. Stop. |
| "I wrote the spec, I can reread it myself" | This context rereads its own intentions. Invoke `supercharlouze:rereading-a-spec` at the step `Have the spec reread`. |
