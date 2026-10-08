---
name: running-reread-rounds
description: Use only when a skill tells you to invoke running-reread-rounds, never on a request to reread a text - waits for every reader of a reread, works their findings through on the text, and runs the later rounds until the reread closes
user-invocable: false
---

# Running Reread Rounds

## Overview

This skill conducts a reread from the moment its first round of readers is
dispatched: it gathers their findings, works them through, and opens the later
rounds.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the running-reread-rounds skill to run the rounds of this reread."

The skill that invokes it gives:

- the text the rounds revise;
- what becomes of each finding;
- the readings that go out in the first round only, when it has any.

## The Findings

Every reader returns before anything goes up. Wait for all of them and gather
their findings, never a running report: a partial report gets findings ruled on
that the next reader displaces, and asks for the same ruling twice.

You instruct the findings; you do not forward them. Work each one through: the
invoking skill says what becomes of it.

Then put to your human partner what you changed and what you could not settle,
and apply their rulings on the text the rounds revise. Forwarding raw findings
makes your human partner arbitrate a draft, which is the work the review exists
to spare them.

A ruling the invoking skill says ends the reread ends the rounds.

## The Rounds

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
  round before read, next to the revised one. A reading given as going out in
  the first round only is not dispatched again. Compose each dispatch as the
  invoking skill composed the first round's.
- **A problem that comes back goes to your human partner.** Keep a ledger from
  round to round: each finding's problem, the round that returned it, and what
  you did with it. Recognise a finding by its problem, not by its words: a
  reworded clause still carries the problem a reader found in it. When a second
  round returns the same problem, put it to your human partner with the option
  you recommend, and do not reword it a third time.
- **The third round is the last you open.** After it, stop and put to your human
  partner what is still open, with your recommendation. A further round runs
  only on their decision.
- **The reread prepares the review of the pull request that carries the text, it
  does not replace it.**

## What It Returns

Return the text as the rounds leave it.

Once the rounds are over, go on with the skill that invoked this one: it says
what the reread returns.

## Red Flags

| Thought | Reality |
|---|---|
| "This reader is done, I'll put its findings up now" | The next reader may displace them. Wait for every reader. |
| "I'll hand my human partner the findings to rule on" | Instruct them first. Your human partner rules on what you changed and what you could not settle. |
| "One more round, the text can still improve" | The third round is the last you open. After it, your human partner decides whether another runs. |
| "This section reads better rewritten whole" | A rewritten section is unread, and sends every reading out again. Retouch the sentences a finding names. |
| "I reworded the clause, so this finding is a new one" | A finding is its problem, not its words. Returned by a second round, it goes to your human partner. |
