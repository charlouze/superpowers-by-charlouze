---
name: rereading-a-batch
description: Use only when a skill tells you to invoke rereading-a-batch, never on a request to reread a batch - conducts the rereads a batch owes before its pull request opens, coherence, technical then batch document, and returns the document revised with what each reread found
user-invocable: false
---

# Rereading a Batch

## Overview

This skill conducts the rereads a batch goes through before the pull request
that opens or amends it: the coherence reread, the technical reread and the
batch-document reread.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the rereading-a-batch skill to have this batch reread."

The skill that invokes it gives:

- the batch document;
- the blocks to apply;
- the rereads due;
- the path of each ADR the pull request writes or rewrites.

Run the rereads due, in this order: the coherence reread, the technical reread,
the batch-document reread.

**Each reread has its own object.** The coherence reread bears on the blocks and
on the state they produce, read whole. The technical reread bears on the
technical design and the constraints, on the blocks read against the ADRs, and
on the ADRs the pull request writes or rewrites. The batch-document reread bears
on the whole document: `Scope`, `Spec delta`, `Technical design`, `Constraints`,
`Feature flag`. Merge the batch-document reread into another and it disappears
wherever that one does not run, leaving a batch that has no blocks without a
reread of its document.

Once the last reread has returned, return what `What It Returns` lists, and go
on with the step that invoked this skill.

## The Applied Copies

The coherence reread and the technical reread read each spec with the blocks
applied.

Before the first reread, invoke `supercharlouze:applying-a-spec-delta` and give
it the batch document and the blocks you were given. Given no block, skip the
invocation: each spec is read as it stands.

**Invoke it again each time a reread has changed or added a block**, and give it
the blocks as they now read. The next reread reads the state those blocks
produce, and a block nothing applied was never checked.

**A block it returns as not applied is a delta gone stale.** Start no reread
while one is left: put the block to your human partner.

## The Coherence Reread

The coherence reread reads each touched spec whole, on the state its blocks
produce.

**Given no block, skip it.** That is not a dispensation granted to a smaller
batch: this reread reads blocks against the spec they will change, so with no
block it has nothing to read. Such a batch still owes the rereads that follow.

Otherwise invoke `supercharlouze:rereading-a-spec` on each applied copy, with
the path of the spec it applies to.

Carry every revision it returns back into the blocks: into the block whose text
it changes, or into a new block when it changes a passage no block targets.
Then have the blocks applied again (`The Applied Copies`).

A rule it returns as reaching past its module's boundary stops the rereads: put
the breakdown to your human partner.

## The Technical Reread

**Start it only once the coherence reread has closed its rounds.** Run side by
side, each reread revises what the other is reading, and neither reads a state
that holds.

Invoke `supercharlouze:rereading-a-technical-design` with the batch document and
each spec the batch touches: its applied copy, or the spec itself when no block
targets it. Hand it also `docs/specs/`, `docs/adr/` and the path of each ADR the
pull request writes or rewrites. An ADR whose text you corrected on a finding
counts among those it rewrites.

Carry every revision it returns back into `Technical design` and `Constraints`.

The technical reread itself never changes `Spec delta`: only your human partner
takes a behaviour or a block back to it.

**A behaviour or a block it returns as taken back to the spec delta sends the
batch back to the coherence reread.** Write the block your human partner rules,
or correct the block as they correct it, and have the blocks applied again
(`The Applied Copies`). The coherence reread and the batch-document reread are
due from then on, whatever you were given: run the coherence reread, then the
technical reread again.

The technical reread changes no ADR either. When your human partner has an ADR
corrected on a finding it returns, invoke `supercharlouze:recording-a-decision`
and hand it the applied copies if the correction changes the ADR's decision, and
correct the text yourself if it does not. When they abandon the ADR, delete it.
After a correction or a deletion, invoke the technical reread again.

## The Batch-Document Reread

The batch-document reread comes after the technical reread and bears on the
whole document.

Conduct it outside the context that wrote the document, by dispatching a
subagent: the context that wrote a document rereads its intentions, not its
text.

Compose the dispatch from
`skills/rereading-a-batch/references/document-reader-prompt.md`, which carries
what the reader checks in each field and what it must return.

Revise the document on what it reports.

## What It Returns

Return:

- the batch document, revised;
- what each reread you ran found, or that it found nothing, written for a pull
  request body, and for a technical reread that returned that it had nothing
  to reread, that instead;
- each behaviour and each block your human partner took back to the spec delta.

## Red Flags

| Thought | Reality |
|---------|---------|
| "I wrote these blocks, I can reread them myself" | The context that argued them into existence rereads its intentions, not its text. Invoke `supercharlouze:rereading-a-spec`. |
| "The rereads read different things, I'll run them together" | Each revises what the other is reading. Start the technical reread once the coherence reread has closed its rounds. |
| "I wrote this design, I can reread it myself" | The context that argued it into existence rereads its intentions, not its text. Invoke `supercharlouze:rereading-a-technical-design`. |
| "I only corrected the ADR's wording, no need to reread again" | The corrected text is one no reader has read. Invoke the technical reread again. |
| "The reread only reworded a block, the copies I have are close enough" | The next reread would read a state no block produces, and nothing has checked the reworded block. Have the blocks applied again. |
| "One block does not apply, the rereads can start on the others" | A reread reads the state all the blocks produce. Start none while a block is left unapplied. |
| "Only the technical reread was due, the block taken back can skip the coherence reread" | No reader has read that block against its spec. The coherence reread is due from then on, and the batch-document reread with it. |
| "I know what each field must hold, I'll check the document myself" | The context that wrote the document rereads its intentions. Dispatch the reader. |
