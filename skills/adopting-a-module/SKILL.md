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

It produces one pull request carrying two documents and no code: the spec at
`docs/specs/<module>.md`, and the gaps register at `docs/specs/<module>.gaps.md`.
Until that pull request is merged the module is not adopted, and no batch may
start on it.

Run this when a batch is about to touch a module that has no spec yet.
`supercharlouze:writing-a-batch` treats adoption as a blocking precondition, so
you arrive here from there, or directly when your human partner asks for a module
to be adopted.

**Announce at start:** "I'm using the adopting-a-module skill to adopt the
<module> module."

## Source Authority

Three ranks, and they never trade places:

1. **The validated documents.** Here, validated documents are normative,
   and only they create normative text.
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

## Steps

**Check the preconditions first, before creating any branch and long before
writing a line of either document.** They are the ones every pull request of this
system checks:

- **You are in the main checkout.** `git rev-parse --git-dir` and
  `git rev-parse --git-common-dir` resolve to the same directory. The reason
  matters, because from inside a worktree this rule is exactly the one an agent
  talks itself out of: `superpowers:finishing-a-development-branch` *preserves*
  the worktree on the pull request path, so `superpowers:using-git-worktrees`
  Step 0 sees `GIT_DIR != GIT_COMMON`, concludes "already in a linked worktree",
  reuses it, and the adoption lands on the previous piece of work's branch. Go
  back to the main checkout first.
- **You are on `main`, refreshed from the remote.** Merges arrive from the
  remote, and an adoption written against a stale `main` audits code that is no
  longer there.
- **`gh` is available and authenticated.** The adoption ends in a pull request.

The order below is not a suggestion. **The branch exists before either document
is written** — step 3 — because `superpowers:using-git-worktrees` creates a
*separate directory*: writing the spec first would leave it uncommitted in the
main checkout on `main`, and the new workspace would open empty.

### 1. Delimit the module

Your human partner names the module and draws its contours. You never delimit one
yourself — not from the directory layout, not from package names, not from how the
code happens to be split today.

Ask. You may show what exists — entry points, directories, obvious clusters — as
material for their decision, but do not propose a split: a suggestion is read as a
decision, and this decision is not yours.

Prefer one coarse module to several small ones. Three modules for a project is
normal; fifteen is a bad split. A wrong boundary contaminates the spec, the gaps
register, and every batch that follows, and nothing later in the flow will catch
it.

Record the agreed boundary at the top of the spec: what the module covers, and what
it explicitly does not.

### 2. Inventory the validated documents

Find every document that could describe the module: archived superpowers design
docs under `docs/archive/specs/`, README files, business documentation, ADRs,
product notes.

**Present the list to your human partner before you write a single line of spec.**
They can add a source you missed and strike one that was never validated. The
quality of the spec is capped by this inventory — a source missed here is a hole in
the spec, and no later step fills it.

For each candidate, say where it is and why you believe it covers the module. Never
assume a document is validated because it exists, looks official, or is the only
one you found. "Close enough to validated" is not validated: ask.

The retained inventory is recorded in the `Sources` section of the spec, by archive
path. That section is the only persistent link between a spec and the documents
that fed it, and the init command depends on it: its status report computes which
archived documents appear in no spec's `Sources` at all.

### 3. Create the branch

Now, and not later. Create the branch `adopt/<module>` and its workspace by
invoking `superpowers:using-git-worktrees`, then move into that workspace: every
file the next two steps write belongs there.

That skill prefers the harness's native tooling, which picks its own branch name
and may leave you on a detached HEAD. If it leaves you on a differently named
branch or on a detached HEAD, make sure a named branch exists before you
continue — nothing in this system depends on the branch name, but a pull request
needs a branch.

The two steps before this one are dialogue: they produce a boundary and an
inventory, not files. Everything after it writes.

### 4. Write the spec from those documents only

Merge, deduplicate, reconcile. The spec is normative — what the code must do — not
descriptive.

- **Nothing enters the spec that no validated document supports.** Behaviour you
  found in the code but no document describes belongs to the gaps register, not
  here.
- **When two validated documents contradict each other, the most recent wins by
  default** — and the arbitration is written down as
  `Ruling: <decision> — <why> — <what it costs if it is wrong>`. Never resolve a
  contradiction in silence; the ruling is what lets a reviewer disagree with you.
  Adoption has no story document and therefore no Rulings log, so these lines go
  in the **body of the adoption pull request** (step 6), where the reviewer who
  might disagree will read them.
- **No date, no status, no in-progress marker.** A spec carries none, ever. On
  `main`, spec and code always travel in the same pull request, so no state exists
  that would need one.
- **Titled sections are the unit of the whole system** — concurrency detection and
  gaps entries both designate a section. Title them so they can be pointed at.
- Add the empty `Changelog` table (`batch | date | change`) in the footer.
  `supercharlouze:closing-a-batch` writes into it, one line per batch. It is not
  the only writer: a bounded change belongs to no batch and writes its own
  `out-of-batch` line, from its own pull request.

**The shape of the spec.** Minimal, and every part of it load-bearing:

```markdown
# <module>

## Boundary

<What this module covers, and — explicitly — what it does not.>

## <A titled section>

<Normative prose: what the code must do. Titled so a gaps entry, a story's
`Sections:` field and a concurrency check can all point at it.>

## Sources

- `docs/archive/specs/<archived document>.md` — <why it covers this module.>

## Changelog

| batch | date | change |
|---|---|---|
```

No front matter, no date, no status. The section titles are English skeleton;
the prose under them follows the project's language.

### 5. Audit the code against the spec

Read the code against each section you just wrote, and produce the gaps register.
Two sections, kept apart because they are not treated the same way:

- **Violations** — the code contradicts the spec. Feeds a *corrective batch*.
- **Gaps** — the code does things no spec describes. Feeds an ordinary batch that
  finally specifies them.

Each entry designates a section of the spec.

**Each entry is a single addressable item — one list item, never a paragraph of
running prose.** You are the only skill that ever *creates* this file, and three
later skills act on entries in place, each needing a thing it can point at:

| Gesture | Who | What it does to the entry |
|---|---|---|
| Reserve | `supercharlouze:writing-a-batch`, in the batch's opening pull request | appends `reserved by batch-NN` to it |
| Strike | `supercharlouze:writing-a-user-story`, as the first commit of the story that resolves it | strikes it through, atomically with the code |
| Release | `supercharlouze:closing-a-batch`, at closing | removes a `reserved by batch-NN` the batch never consumed |

A register written as flowing paragraphs satisfies every other word of this step
and breaks all three: there is no item to annotate, none to strike, and nothing a
corrective batch can draw a scope from. Write entries so those gestures are
mechanical.

**The shape of the register:**

```markdown
# <module> — Gaps register

## Coverage

<Which parts of the module were audited, which were not, and why. Written even
— especially — when nothing was found.>

## Violations

- **<spec section>** — <how the code contradicts it.>
- **<spec section>** — <another one.> `reserved by batch-08`
- ~~**<spec section>** — <one a story has already resolved.>~~

## Gaps

- **<spec section, or the section that should exist>** — <behaviour no spec
  describes.>
```

**The register also declares its own coverage:** which parts of the module were
audited, which were not, and why. An empty register that means "nothing was
examined" must never look like an empty register that means "everything conforms" —
they are opposite facts and they look identical unless you write the difference
down. Declare the coverage especially when you found nothing.

Fix nothing while you are here. Adoption produces the register; resorbing an entry
is a batch of its own, with its own review.

### 6. Open the adoption pull request

The branch already exists — you created it at step 3. Commit both documents on
it, push, and open the pull request.

The pull request carries the spec and the gaps register, and no code. Its body
carries what a reviewer needs to disagree with you: the boundary as your partner
drew it, the retained inventory, the rulings from step 4, and the declared
coverage. **The pull request body is where an adoption's rulings live.** Adoption
produces no story document, so there is no Rulings log to write them into, and a
ruling nobody can read is a contradiction resolved in silence.

**The review of the adoption pull request is the mandatory human review.** It is the
adoption gate, and there is no other one — this plugin adds no ceremony, it puts
its gates where your flow already has reviews. Until that pull request is merged
the module is not adopted and no batch may start on it. An open adoption pull
request is not adoption; do not start `supercharlouze:writing-a-batch` on the
strength of one.

## Degraded Case: A Module With No Validated Documents

Sometimes the inventory comes back empty: no validated document covers the module.
Adoption from documents is impossible, and reconstruction from the code stays
excluded — it would canonize drift here exactly as it would anywhere else.

Switch to dialogue:

1. Enumerate the behaviours you find in the code, grouped as candidate sections.
2. Ask your human partner, section by section: *is this intended?*
3. What they validate becomes the spec. Everything else goes to **Gaps**.

Each answer is a human validation, and human validation is the only thing that can
create normative text where no document exists. So ask section by section: a wall
of questions gets one blanket "yes" back, and a blanket yes is reconstruction from
the code with extra steps.

The `Sources` section then records that there was no validated document, rather
than staying silent — a missing section and an empty one read the same, and the
init command reads it. The declared coverage says which behaviours were never put
to your partner.

The same treatment applies to a partial inventory: the covered part of the module
follows steps 2 to 5, the uncovered part follows this dialogue. Either way the
branch of step 3 is created before anything is written.

## Language

English skeleton, project-language prose: section titles, field names, table
headers, front matter values and path patterns are English, while requirement
bodies, descriptions, rationale and the slugs naming business objects follow the
project's language. The spec and the gaps register you write obey this rule; this
plugin itself is entirely English, because it carries no business prose.

## Red Flags

| Thought | Reality |
|---------|---------|
| "The code is the real truth, I'll spec what it does" | That canonizes drift and destroys the premise of corrective batches. |
| "I can infer the module boundaries from the directory layout" | Boundaries belong to your human partner. A wrong one contaminates everything downstream. |
| "This old design doc is close enough to validated" | Ask. The spec's quality is capped by the inventory. |
| "The audit found nothing, so the register is empty" | An empty register must say whether nothing was found or nothing was examined. |
| "I'll write the spec first and show the source list with it" | The inventory is presented before anything is written, or your partner reviews sources they can no longer change your mind about. |
| "These two documents disagree, I'll keep the clearer one" | Most recent wins by default, and the choice is a ruling, written down. |
| "This behaviour is obviously intended, so into the spec it goes" | Obvious to you is not validated by them. Undocumented behaviour is a gap until a human says otherwise. |
| "No documents exist, so I'll draft from the code and have them confirm" | A draft to confirm is a blanket yes waiting to happen. Section by section, one question at a time. |
| "I'll write the two documents first and create the branch to carry them" | using-git-worktrees opens a separate, empty directory. The branch comes first, at step 3, or both files stay stranded on `main`. |
| "I'm already in a worktree, that will do" | Its Step 0 sees `GIT_DIR != GIT_COMMON`, reuses it, and the adoption lands on the previous branch. Main checkout first. |
| "Prose reads better than a list in the gaps register" | Then nothing can reserve, strike or release an entry, and the three downstream gestures break. |
| "The adoption PR is open, the batch can start" | Merged is adopted. The review is the gate, not the push. |
| "I found a violation, I'll fix it while I'm in there" | Adoption produces the register. The fix is a corrective batch, with its own review. |
