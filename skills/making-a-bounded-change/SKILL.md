---
name: making-a-bounded-change
description: Use when a piece of work is bounded, in a project whose CLAUDE.md says specs and plans are overridden - a well-scoped change that needs no batch, a spec your human partner judges wrong where the code is right, or an ADR your human partner wants written, rewritten or deleted outside a batch - holds the change to a single pull request on a bounded/<slug> branch, with its spec update, its declaration and its ADRs
---

# Making a Bounded Change

## Overview

A bounded change has no batch and no user story: it is already a single pull request, and whether it carries a spec update is what rule (a) decides.

Its ceremony is the one `superpowers:brainstorming` gives bounded work, to which `supercharlouze:using-batches` adds the reading of `docs/adr/` by the design. `The Rules` are what its pull request holds besides.

**Announce at start:** "I'm using the making-a-bounded-change skill to make this bounded change."

**Start by invoking `supercharlouze:following-the-rules`, unless this session already has.**

## The Rules

- **(a) Its pull request leaves the spec silent if and only if nothing observable at the module's boundary changes.** Whether it *alters* a behaviour some spec already describes or *adds* one no spec describes, it updates the spec in the same pull request as the code. Handling only the "alters" case would reopen the same hole one notch over. Where nothing observable at that boundary changes — a dependency bump, an internal rename, a preparatory refactor — the spec stays silent. That silence is not a tolerance: a rule does not move when a mechanism moves, so there is nothing to write, and writing something anyway means inventing a sentence from the code, which canonises the drift it describes.

  **Exception: when your human partner judges that a spec is wrong and the code is right, it carries the spec correction they decide, and touches no code.** Both the judgment and the correction are your human partner's: a correction you derive from the code alone canonises the drift it describes. When the correction settles a gaps register entry, remove that entry under rule (d).

  When it updates a spec, invoke `supercharlouze:writing-in-a-spec` before writing in it.

- **(b) It undergoes the same concurrency detection as a story**, and therefore declares in the body of its pull request **the spec it targets and the sections it touches**, `none` when it touches none — otherwise it would hit a story in flight through a back door. The spec is named because nothing else in the declaration says which document those section titles belong to, and a bounded change that updates no spec file leaves a reader nothing to infer it from; two identically titled sections in two different specs are not a conflict. And `none` is a declaration, not a blank: it is what a bounded change that writes in no spec has to say, where a blank body is indistinguishable from one nobody filled in — which is an unknown, and an unknown stops the reader. Invoke `supercharlouze:detecting-concurrency` before creating `bounded/<slug>`, and give it that spec and those sections. Stop if it returns a conflict or a declaration it could not read: report what it returned, and let your human partner sequence the two pieces of work or decide on the unread declaration.

  **Before its pull request opens, a bounded change about to touch a section the detection was not run for redoes the detection:** invoke it again, and give it that section and `bounded/<slug>` as well. Stop again if it returns a conflict or a declaration it could not read. The detection answered for the sections it was given, so a section added afterwards was never intersected against anything — not found free, simply never looked at.

- **(c) It carries no feature flag.** A bounded change is complete in its own pull request, so it satisfies the exemption criterion by construction.
- **(d) It writes to a gaps register directly.** Belonging to no batch, it may both add an entry and delete one in `docs/specs/<module>.gaps.md`, from its own pull request, contending only with another bounded change. Invoke `supercharlouze:writing-in-a-gaps-register` before writing in it.
- **(e) It may write, rewrite and delete ADRs, and may carry nothing but ADRs.** Invoke `supercharlouze:recording-a-decision` to write or rewrite one. Delete yourself the one your human partner abandons, and correct yourself, on their decision, a text whose decision does not change.
- **(f) It holds the ADRs `main` carries when its branch starts.** Once `bounded/<slug>` is created, reread `docs/adr/` and hold what you find there: the design read it where you stood, and the branch starts from `main` as the remote carries it. When you cannot hold an ADR, put it to your human partner: if they rule it untenable, rewrite or delete it under rule (e); otherwise hold it.
- **(g) It puts to your human partner the technical decision it takes that meets the conditions of an ADR `supercharlouze:following-the-rules` states.** That holds for a decision taken along the way as for one taken at design. If they want it as an ADR, write it under rule (e).

Its branch is `bounded/<slug>`: invoke `supercharlouze:starting-a-branch` and give it the name `bounded/<slug>`.

## Red Flags

| Thought | Reality |
|---------|---------|
| "This is a small fix, the spec can stay silent about it" | Only if nothing observable at the module's boundary changes. The moment behaviour moves, the spec is updated in the same pull request, and either way the change declares the spec it targets and the sections it touches. |
| "It's one more section of the same spec, the detection already ran" | It ran for the sections it was given, and never looked at this one. Detect again before touching it, and stop if it is held or a declaration cannot be read. |
| "The code is right and the spec is plainly wrong, I'll correct the spec" | Only your human partner judges a spec wrong, and they decide the correction. Put it to them, and write nothing in the spec until they have decided. |
| "While I correct the spec, I'll tidy the code it describes" | A spec correction touches no code: the code is what your human partner judged right. A code change is another bounded change. |
