---
name: running-reread-rounds
description: Use only when a skill tells you to invoke running-reread-rounds, never on a request to reread a text - waits for every reader of a reread, works their findings through on the text, and runs the later rounds until the reread closes
user-invocable: false
---

# Running Reread Rounds

## Overview

This skill conducts a reread from the moment its first round of readers is
dispatched: it gathers their findings, works them through, and opens the second
round.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the running-reread-rounds skill to run the rounds of this reread."

The skill that invokes it gives:

- the text the rounds revise;
- what becomes of each finding;
- the readings that go out in the first round only, when it has any.

## The Findings

Every reader returns before you settle anything. Wait for all of them and
gather their findings, never a running report: a partial report gets findings
settled that the next reader displaces.

You instruct the findings; you do not forward them. Work each one through: the
invoking skill says what becomes of it.

Drop a finding that names nothing it would make someone do wrong: a wording a
reader merely prefers is not a finding.

**Ask your human partner nothing while the reread runs, except what the
invoking skill says only they decide.** Settle every other finding yourself:
they review what you decided on the pull request that carries the text, and a
question asked now makes them rule twice.

Put each finding only your human partner decides to them once every reader has
returned, before you revise anything: describe the problem so they can rule on
it without the text in front of them, give the option you recommend, and apply
their ruling. Ask it with your harness's question tool when it has one, such as
`AskUserQuestion`.

Write for the pull request body, in this order:

- each decision that goes back on something your human partner decided;
- each ruling they gave, with the finding it settled;
- what else you changed, the changes that weigh most first.

A decision the invoking skill says ends the reread ends the rounds.

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
- **A problem that comes back is not reworded again.** Recognise a finding by
  its problem, not by its words: a reworded clause still carries the problem a
  reader found in it. When the second round returns a problem the first
  returned, change what the passage rules or leave it as it is, and write which
  for the pull request body.
- **The second round is the last.** Settle what it finds as you settled the
  first round's, and open no third: the review of the pull request reads what
  that last revision changed. Name in the pull request body the passages it
  changed, which no reader has read.
- **The reread prepares the review of the pull request that carries the text, it
  does not replace it.**

## What It Returns

Return the text as the rounds leave it.

Once the rounds are over, go on with the skill that invoked this one: it says
what the reread returns.

## Red Flags

| Thought | Reality |
|---|---|
| "This reader is done, I'll settle its findings now" | The next reader may displace them. Wait for every reader. |
| "I'll ask my human partner how to settle this finding" | Unless the invoking skill says only they decide it, settle it, and write the decision for the pull request body: they rule on it in the review. |
| "This reader has a point, the wording could be smoother" | A wording a reader merely prefers is not a finding. Drop it. |
| "One more round, the text can still improve" | The second round is the last. The review of the pull request reads what follows it. |
| "This section reads better rewritten whole" | A rewritten section is unread, and sends every reading out again. Retouch the sentences a finding names. |
| "I reworded the clause, so this finding is a new one" | A finding is its problem, not its words. Returned by the second round, it is not reworded again. |
