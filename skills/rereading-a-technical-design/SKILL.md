---
name: rereading-a-technical-design
description: Use only when a skill tells you to invoke rereading-a-technical-design, never on a request to reread a text - dispatches one reader per reading, outside the context that wrote what it reads, and returns the technical design and constraints revised, with the findings on the ADRs
user-invocable: false
---

# Rereading a Technical Design

## Overview

A batch's technical design and constraints are reread outside the context that
wrote them, by readers dispatched as subagents. The context that wrote a design
rereads its own intentions, and the file it assumed exists is what it cannot
see.

The reread also reads the batch's blocks and its design against the ADRs, and
rereads each ADR that the pull request opening or amending the batch writes or
rewrites.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the rereading-a-technical-design skill to run this batch's technical reread."

## Input and Output

The input is:

- the batch document;
- each spec the batch touches, with the batch's blocks applied;
- `docs/specs/`, for the specs the batch does not touch;
- `docs/adr/`, as the pull request that opens or amends the batch leaves it;
- the path of each ADR that pull request writes or rewrites.

The readers read the code as `main` carries it. Hand them the root of a working
tree whose code is `origin/main`'s: a branch started from `origin/main` that
changes only documents has one.

When no reading is dispatched (`The Readings`), return "nothing to reread".

When the rounds are over, return:

- the technical design and the constraints, revised: every finding worked
  through, and every ruling of your human partner applied;
- the behaviours and the blocks your human partner took back to the spec delta,
  which ended the reread;
- the findings on an ADR, each with what your human partner ruled on it;
- what the reread found, or that it found nothing, written for a pull request
  body.

## The Readers

A reader takes one reading. Each reading asks for its own motion, a comparison
with what the batch promises, a search through the code, a judgement of
structure, a reasoning about failures or a confrontation with the ADRs, and one
reader holding several does the cheapest of them and returns. So every reading
gets its own reader, and they are dispatched together.

Compose each dispatch from
`skills/rereading-a-technical-design/references/reader-prompt.md`, which carries
what a reader gets and what it must return.

Dispatch every reader on the model you run on, and name that model in the
dispatch: a harness may give subagents a lighter default, and a lighter reader
misses findings the review then has to find.

## The Readings

Each reading below is the text a reader's prompt carries, pasted word for word
into the slot the template leaves for it. It is written for a reader that has
nothing else: never abbreviate it, and never hand a reader two.

Dispatch a reading when its object exists. This is the first round's dispatch: a
later round sends out fewer (`Findings and Rounds`).

The object of these readings is the design: the batch document's
`Technical design` and `Constraints`. It exists unless both read `none`.

> **Does the design deliver what the batch promises?** The batch promises the
> rules its blocks write into the specifications or, when it has no block, what
> its `Scope` says it delivers. Find, for each promise, the part of the design
> that makes the code hold it. Report a promise no part of the design delivers,
> and a behaviour the design would make observable to a user or a neighbouring
> module that no specification describes.

> **Does the design stand on the code as it is?** Check against the code every
> file, unit, name and test that the design assumes exists, and every one it says
> it changes. Report what does not exist, what exists elsewhere or under another
> name, a structure already in place that the design ignores or duplicates, what
> the design would have to change without saying so, and a constraint the code
> already breaks.

> **Does the design hold as an architecture?** Use the `clean-architecture` skill
> if it is available to you, and read without it if it is not, and say so at the
> top of your report. Report a unit the design draws that mixes responsibilities,
> a boundary it crosses, and a dependency that points from a business rule
> towards a mechanism.

> **Are the modules this design draws deep?** Use the
> `software-design-philosophy` skill if it is available to you, and read without
> it if it is not, and say so at the top of your report. Report a module whose
> interface is nearly as complex as what it hides, knowledge that leaks from one
> module into another, a method that only passes its arguments on, and complexity
> the design adds without stating why.

> **How does this design fail?** Report an error the design does not handle, a
> behaviour its testing strategy leaves untested, a risk it takes without naming
> it, such as a migration, a concurrent access, a compatibility break or a cost
> in performance, and a constraint that a story could not hold.

The object of this reading is the batch's blocks and its design. It exists when
a `.md` file is placed directly in `docs/adr/`, and the batch has a block or a
design.

> **Do the blocks and the design hold the ADRs?** An ADR records a technical
> decision that the code to come must hold: it is a `.md` file placed directly
> in the ADR directory. Read every one. Report a block that writes into a
> specification a rule an ADR contradicts, and a part of the design that an ADR
> rules out or that would make the code break one.

The object of this reading is each ADR the pull request writes or rewrites. It
exists when the input names one.

> **Does each ADR to reread stand with the specifications and the other ADRs?**
> An ADR records a technical decision that the code to come must hold. Read each
> ADR to reread against every specification, the batch's changes applied, and
> against every other `.md` file placed directly in the ADR directory. Report an
> ADR that contradicts a specification, an ADR that contradicts another ADR, and
> an ADR that states what a user or a neighbouring module would observe: that is
> a rule of a specification, never a decision an ADR records.

The architecture and module readings invoke their skill only if present. This
plugin recommends `clean-architecture` and `software-design-philosophy` and
depends on them nowhere, so the absence of one changes how its reader reads,
never whether the reading happens.

When a reader reports that it read without its skill, tell your human partner
that the skill is not available, so they can install it.

## Findings and Rounds

Every reader returns before anything goes up. Wait for all of them and gather
their findings, never a running report: a partial report gets findings ruled on
that the next reader displaces, and asks for the same ruling twice.

You instruct the findings; you do not forward them. Fix each one on the
technical design or the constraints without changing what they decide, or put it
to your human partner when fixing it would: they approved what the design
decides.

A behaviour the design would make observable that no specification describes is
always put to your human partner. It leaves the design, or your human partner
takes the batch back to its spec delta and the reread ends: this reread writes
no block.

A finding on a block is not fixed: put it to your human partner, who leaves the
block as it is, takes the batch back to its spec delta, which ends the reread,
or has the ADR changed. This reread revises no block.

A finding on an ADR is not fixed either: put it to your human partner, and
return it with what they ruled. Return the same way a finding on a block or on
the design that they settle by having an ADR changed. This reread revises no
ADR.

Then put to your human partner what you changed and what you could not settle,
and apply their rulings on the design. Forwarding raw findings makes your human
partner arbitrate a draft, which is the work the review exists to spare them.

A round runs on the revised text. Keep a copy of the state each round read: the
next round's readers are handed it. These stop the rounds, and without them they
chain indefinitely:

- **A revision retouches.** Change only the sentences a finding names. A section
  rewritten whole is a section no reader has read, and it sends every reading
  out again.
- **A later round reads the revision, and nothing else.** What a revision adds,
  moves or rewords is unread; what it takes out reopens only what leaned on it,
  coherence being a property of the state and not of the text that remains. A
  revision that leaves nothing unread opens no round. Dispatch only the readings
  the revision bears on: a reworded sentence goes back to the reading that found
  it wanting, an added one to every reading. Hand each reader the state the
  round before read, next to the revised one. The reading of the ADRs to reread
  goes out in the first round only: no revision touches what it reads.
- **A problem that comes back goes to your human partner.** Keep a ledger from
  round to round: each finding's problem, the round that returned it, and what
  you did with it. Recognise a finding by its problem, not by its words: a
  reworded clause still carries the problem a reader found in it. When a second
  round returns the same problem, put it to your human partner with the option
  you recommend, and do not reword it a third time.
- **The third round is the last you open.** After it, stop and put to your human
  partner what is still open, with your recommendation. A further round runs
  only on their decision.
- **The reread prepares the review of the pull request that carries the design,
  it does not replace it.**

## Red Flags

| Thought | Reality |
|---|---|
| "I wrote this design, I can reread it myself" | The context that wrote it rereads its intentions, not its text. Dispatch readers outside it. |
| "One reader can take every reading, it is cheaper" | A reader holding several readings does the cheapest and returns. One reader per reading. |
| "The reading is long, I'll summarise it in the prompt" | The reader has nothing else. Paste it word for word. |
| "This reader is done, I'll put its findings up now" | The next reader may displace them. Wait for every reader. |
| "This finding is right, I'll rework the design around it" | Your human partner approved what the design decides. Fix the wording, or put the change to them. |
| "This behaviour is small, the design can carry it without a block" | What a user or a neighbouring module would observe needs a block. Put it to your human partner. |
| "The design needs this rule, I'll write the block" | This reread writes no block. Put the behaviour to your human partner. |
| "One more round, the design can still improve" | The third round is the last you open. After it, your human partner decides whether another runs. |
| "This section reads better rewritten whole" | A rewritten section is unread, and sends every reading out again. Retouch the sentences a finding names. |
| "I reworded the clause, so this finding is a new one" | A finding is its problem, not its words. Returned by a second round, it goes to your human partner. |
| "The reader is right about this ADR, I'll fix its wording" | This reread revises no ADR. Put the finding to your human partner, and return it with what they ruled. |
| "This block contradicts an ADR, I'll adjust the block" | This reread revises no block. Put the finding to your human partner. |
| "The batch has no design, so there is nothing to reread" | A reading is dispatched when its object exists. An ADR the pull request writes is reread whatever the batch carries. |
