---
name: rereading-a-spec
description: Use only when a skill tells you to invoke rereading-a-spec, never on a request to reread a text - dispatches one reader per reading, outside the context that wrote the spec, and returns the spec revised
user-invocable: false
---

# Rereading a Spec

## Overview

A spec is reread outside the context that wrote it, by readers dispatched as
subagents. The context that wrote a text rereads its own intentions, not its
text, and the passage it never meant to touch is what it cannot see.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the rereading-a-spec skill to have this spec reread."

## Input and Output

The input is the spec to read, and the path it has or will have under
`docs/specs/`.

The spec is new when `main` carries no file at that path, and changed otherwise.
Fetch, then read the spec as `main` carries it with
`git show origin/main:<path>`.

When the rounds are over, return:

- the spec, revised: every finding worked through, and every ruling of your
  human partner applied;
- the sentences taken out because they describe a mechanism, each with the
  section it came from;
- the rules left as they are because they would constrain behaviour observable
  at the boundary of more than one module;
- what the reread found, or that it found nothing, written for a pull request
  body.

## The Readers

A reader takes one reading, on one spec. Each reading asks for its own motion,
a sweep of the whole document, a reasoning about cases, a test applied sentence
by sentence, a check of the wording or a look at the model, and one reader
holding several does the cheapest of them and returns. So the readers follow
from the state: one per reading that applies to its state, per spec, dispatched
together.

Compose each dispatch from `skills/rereading-a-spec/references/reader-prompt.md`,
which carries what a reader gets and what it must return. Hand every reader the
project's aside convention, or say that it declares none, and
`docs/specs/`, the directory where the project's other specifications live.

Dispatch every reader on the model you run on, and name that model in the
dispatch: a harness may give subagents a lighter default, and a lighter reader
misses findings the review then has to find.

A reader of a changed spec gets both states, and reads the later one. Handing it
the spec as `main` carries it turns "what changed" into a diff it can run rather
than a change it has to rebuild. The reading itself stays on the applied state,
read whole: a reader that works through the change piece by piece leaves unseen
the passage no change aims at.

## The Readings

Each reading below is the text a reader's prompt carries, pasted word for word
into the slot the template leaves for it. It is written for a reader that has
nothing else: never abbreviate it, and never hand a reader two.

A changed spec gets every reading. A new spec gets *Does this specification hold
what a specification must hold?*, *Is this specification precise and concise?*
and *Where does this sit in the model?* This is the first round's dispatch: a
later round sends out fewer (`Findings and Rounds`).

> **What does this change make false elsewhere?** Find a passage of this
> specification that the change does not aim at and that it now contradicts.

> **What does this change leave out?** Find a case it walks past, or a
> consequence it does not draw.

> **Does this specification hold what a specification must hold?** Every
> sentence states a business rule or an intention, and passes the
> other-implementation test: a developer who implemented the same intention
> differently would read that sentence as true of their code. A sentence that
> describes a mechanism does not pass it. A business decision that carries a
> number states its value. The specification carries no date, no status and no
> work-in-progress marker, except a feature flag's gating sentence. A rule lives
> in the section of the behaviour it constrains, never in a section named after
> the code's internal parts. A rule that constrains several behaviours lives in a
> section named after what it rules. A rule that would constrain behaviour
> observable at the boundary of more than one module is a finding. A glossary
> that binds a domain concept, and only a domain concept, to the name the code
> and the interface carry states a rule. A term borrowed from another module's
> specification is redefined here, reduced to what this one uses, and names that
> specification. Everything is normative at the same level: no recommendation,
> no best practice. A passage marked by the project's declared aside convention
> is not normative, and carries no rule. Report the sentences that fail, and
> what each breaks.

> **Is this specification precise and concise?** Read every sentence under
> review: every sentence of a new specification, every sentence the change
> brings to a changed one. Each says one exact thing, once, and stands on its
> own. Every paragraph carries one rule. A rule says how far it holds, and an
> exception presents itself as one. A text says what it delivers or decides,
> without telling how it got there or why. No sentence is set in relief. A
> sentence whose removal would cost a reader nothing fails; so does a vague word
> where a concrete rule belongs. Report the sentences that fail, and what each
> breaks.

> **Where does this sit in the model?** Use the `domain-driven-design` skill if
> it is available to you, and read without it if it is not, and say so at the
> top of your report. Report what this specification names inconsistently,
> places where it does not belong, or splits across a boundary it should not
> cross.

The model reading comes last: it answers none of the others and feeds them all,
and its skill is invoked only if present. This plugin recommends
`domain-driven-design` and depends on it nowhere, so its absence changes how that
reader reads, never whether the reading happens.

When the model reader reports that it read without its skill, tell your human
partner that `domain-driven-design` is not available, so they can install it.

## Findings and Rounds

Every reader returns before anything goes up. Wait for all of them and gather
their findings, never a running report: a partial report gets findings ruled on
that the next reader displaces, and asks for the same ruling twice.

You instruct the findings; you do not forward them. Work each one through on the
spec:

- A sentence that describes a mechanism leaves the spec, and goes to the output.
- A rule that would constrain behaviour observable at the boundary of more than
  one module stays as it is, and goes to the output: the module breakdown is
  your human partner's decision, not a wording.
- A defect the spec already carries on `main` is not fixed: the change did not
  write that passage, and fixing it widens what your human partner reviews. It
  goes once into what the reread found, and opens no round.
- Any other finding is fixed without changing what its sentence rules, or put to
  your human partner when fixing it would.

Then put to your human partner what you changed and what you could not settle,
and apply their rulings. Forwarding raw findings makes your human partner
arbitrate a draft, which is the work the review exists to spare them.

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
  round before read, next to the revised one.
- **A problem that comes back goes to your human partner.** Keep a ledger from
  round to round: each finding's problem, the round that returned it, and what
  you did with it. Recognise a finding by its problem, not by its words: a
  reworded clause still carries the problem a reader found in it. When a second
  round returns the same problem, put it to your human partner with the option
  you recommend, and do not reword it a third time.
- **The third round is the last you open.** After it, stop and put to your human
  partner what is still open, with your recommendation. A further round runs
  only on their decision.
- **The reread prepares the review of the pull request that carries the spec, it
  does not replace it.**

## Red Flags

| Thought | Reality |
|---|---|
| "I wrote this spec, I can reread it myself" | The context that wrote it rereads its intentions, not its text. Dispatch readers outside it. |
| "One reader can take every reading, it is cheaper" | A reader holding several readings does the cheapest and returns. One reader per reading. |
| "The reading is long, I'll summarise it in the prompt" | The reader has nothing else. Paste it word for word. |
| "This reader is done, I'll put its findings up now" | The next reader may displace them. Wait for every reader. |
| "I'll hand my human partner the findings to rule on" | Instruct them first. Your human partner rules on what you changed and what you could not settle. |
| "This rule spills into the next module, I'll reword it to fit" | The breakdown is your human partner's decision. Leave the rule as it is, and return it. |
| "The reader is right about this old passage, I'll fix it too" | The change did not write it. Return it once, and fix nothing. |
| "One more round, the wording can still improve" | The third round is the last you open. After it, your human partner decides whether another runs. |
| "This section reads better rewritten whole" | A rewritten section is unread, and sends every reading out again. Retouch the sentences a finding names. |
| "I reworded the clause, so this finding is a new one" | A finding is its problem, not its words. Returned by a second round, it goes to your human partner. |
