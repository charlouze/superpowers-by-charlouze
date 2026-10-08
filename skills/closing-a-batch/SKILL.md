---
name: closing-a-batch
description: Use when every user story of a batch is merged or abandoned - consolidates what the story documents left, releases reservations, withdraws undelivered blocks, checks flags and closes the batch
---

# Closing a Batch

## Overview

A batch closes when every one of its user stories is merged or abandoned and the human judges the work finished. Closing is not bookkeeping. It is the only moment in the lifecycle where the residue left on `main` gets collected.

It is also the only moment in a batch's normal course that touches the batch document itself: *Withdraw the blocks no story delivered* removes them from it, and *Set status: closed* flips its front matter. Anything else that would edit the document goes through an amendment pull request of its own, which `supercharlouze:amending-a-batch` owns.

Abandoning a story is almost free: closing its pull request without merging throws away its code, and its spec change if it had one — nothing to revoke, no spec left out of step. But what it never touched is still on `main`, put there by the batch's own opening pull request: the gaps register entry the batch reserved, and the blocks the batch announced in its spec delta. Either may be absent — a batch with no blocks announced none, a batch that reserved nothing left nothing to release — so what closing owes here is a look at both, not a tally. **Nothing else picks them up**, except an amendment that takes a reserved entry out of `Scope` and releases it. If closing skips a duty, that duty is simply never done.

Every duty lands in one pull request, on a branch named `batch/NN-<slug>-close`. The flag check is allowed to refuse, and because it is allowed to refuse it comes before the duties that write.

**Announce at start:** "I'm using the closing-a-batch skill to close batch NN."

**Start by invoking `supercharlouze:following-the-rules`, unless this session already has.**

## Preconditions

- **Every story is merged or its pull request is closed.** `gh pr list` is the authority. A story's state *is* its pull request's state — there is no checklist anywhere to reconcile against.
- **Your human partner judges the batch finished.** Every story being merged or closed is necessary and not sufficient. Closing records a human decision — that the batch delivered what it owed — and a batch is never closed because an agent judged the work to look finished.
- **Invoke `supercharlouze:starting-a-branch` and give it the name `batch/NN-<slug>-close`.** The documents below are read on that branch: read from a `main` behind the remote, they leave out the stories merged since.
- **Read the batch document `docs/batches/NN-<slug>/README.md` and every story document in that directory.** The story documents carry what you are about to consolidate: the drift they observed and the open rulings their `Rulings log` leaves. The batch document carries the blocks you are about to check against the `Blocks:` declarations of the story documents. "Every document in that directory" is every document that reached `main`: an abandoned story's document died with its branch, never merged, so it is not there — and neither is whatever it recorded under `Observed drift`. Nothing recovers it; that is part of what abandoning costs. Read what is on `main` and do not go hunting closed pull requests for documents that never landed.

## The Duties

Do them all on the same branch, in the order below. Then open one pull request.

**The flag check, *Refuse to close on a flag*, writes nothing, and it comes before any other duty writes anything.** Read the code and the specs for surviving flags this batch declared and decide whether this batch may be closed at all; only then write.

The reason is what a refusal costs. The other duties all write: consolidated findings into the gaps registers, released reservations, the amended batch document, the closed status. The flag check writes nothing — it reports and hands the decision to your human partner. Check first and a refusal costs nothing: the close branch is still empty, there is no commit to abandon, and the batch closes later in one clean run once the lifting story has merged. Check any later and a refusal strands the writing already done on a branch nobody may merge, and none of it is safe to re-run: a second attempt would re-append every consolidated finding, and find reservations already released for a batch that was never closed.

So: if the flag check refuses, **stop before writing anything.** Report the surviving flag, present the three exits below, and leave the batch open. The only thing to clean up is an empty branch and its workspace.

### Refuse to close on a flag that survives without a declared scope

It writes nothing, so performing it on an empty branch makes a refusal free.

Check every feature flag **this batch declared**, in its `Feature flag` field, in two places: the code, and the gating sentences of the specs it touched. A surviving flag is acceptable **only** if its extended scope and its lifting condition are declared — in the batch document's `Feature flag` field and in the spec's gating sentence. A flag that survives with **no declared scope** means the lifting story was never written, and the batch **cannot be closed**.

**A flag declared by an earlier batch is not this duty's business.** If this batch took on lifting one, its `Spec delta` said so, and removing that flag's gating sentence is a block like any other: *Withdraw the blocks no story delivered* catches it undelivered, not this one. The specs are the registry of flags, and a flag this batch did not declare and did not announce lifting stays in its spec, with its condition, where the next reader of that section sees it.

This is the duty an agent in a hurry will want to skip, so take the reason seriously. A wanted flag and a forgotten flag are indistinguishable in the code — the declaration is the only thing that separates them. Treating an undeclared survivor as "probably fine" reinstates the classic failure mode of feature flags: guarded code nobody dares to remove, and the failure is silent. Deliberate survival stays possible; survival by oversight does not.

Refusing is not a dead end. Report the surviving flag and present the **three exits**; the human chooses, you do not:

| Exit | What it does | Form |
|---|---|---|
| Lift | Ships what exists: removes the branching in the code and the gating sentence in the spec | A lifting story, written with `supercharlouze:writing-a-user-story` — one per guarded module |
| Extend the scope | Defers the decision to a later batch by declaring the flag's extended scope and its lifting condition | An amendment pull request on the batch document, written with `supercharlouze:amending-a-batch` and reviewed like any other |
| Tear down | Removes the guarded code and the corresponding spec change | A teardown story, written with `supercharlouze:writing-a-user-story` |

Then stop and wait. Do not close the batch under an undeclared surviving flag "to be tidied up later" — that is the outcome this duty exists to prevent. And do not leave the batch open indefinitely either: without these three exits, the refusal would manufacture exactly the dead flagged code it is meant to prevent.

### Consolidate what the story documents left

Collect from every story document in the batch what it left for you, and write it into the gaps register of the module concerned, `docs/specs/<module>.gaps.md`. **Two sections carry it.** The **Observed drift** section holds what the story saw outside its own scope. The **Rulings log** holds its `Open ruling:` lines, each of which names the gaps register category that takes it — the ones classified as a violation or a gap are yours, and the rest were settled at the delivery review, where an open ruling can still be acted on. From either section, whatever a story reported as code contradicting the spec goes under **Violations**, whatever it reported as behaviour no spec describes goes under **Gaps**. A story finds its gaps in the code it went through; those are this duty's sources, and they are not the only sources the register has.

**An open ruling that names no category should not reach you.** A story does not merge leaving one without a destination — the delivery review settles those, and it is the last moment that can: here the story is merged and its branch is gone, so you can note that a ruling was never taken up and no longer take it up. If you find one, report it with the rest of your findings and let your human partner rule; do not classify it yourself.

**Invoke `supercharlouze:writing-in-a-gaps-register` before adding an entry.**

"Out of scope for this batch" is never a reason to drop an observation. It is precisely why the observation belongs in the register: the register is what a later corrective batch draws its scope from. Dropped here, the finding dies with the session that made it.

You arrive with a batch's worth of findings at once: write "consolidated by batch NN" into each entry that needs it, never above them.

### Release unconsumed reservations

For every gaps register entry this batch reserved at opening (`reserved by batch-NN`) that is still in the file, release it. Invoke `supercharlouze:writing-in-a-gaps-register` before releasing one. Those are the **unconsumed reservations**: a story abandoned, an entry no story resolved. An entry an amendment took out of `Scope` is not among them: that amendment released it. An entry a story did resolve is not there to release: the story deleted it from the file, atomically with the code that resolved it.

Closing a story's pull request does not do this for you. The reservation lives on `main` — it got there when the batch's opening pull request merged — and abandoning a story touches nothing on `main`. Left in place, the annotation is a perpetual claim: the gap looks taken forever, and no future batch can pick it up.

### Withdraw the blocks no story delivered

Read the `Blocks:` field of every story document in the batch directory, and collect the `D<n>` identifiers they declare; a `none` declares nothing. A block the batch document's `Spec delta` defines and that no collected declaration names is a block announced but never delivered: a story abandoned, a scope cut along the way. For each one:

1. Remove it from the batch document, its `Spec delta` entry and any constraint that names it, so the document no longer promises what the batch did not deliver.
2. Ask your human partner whether it joins the gaps register. If they say yes, invoke `supercharlouze:writing-in-a-gaps-register` and add it under **Gaps** in the register of the module concerned.

Without this duty the abandonment is invisible. It is not drift, since the spec and the code agree: both are silent about the feature. And nothing else records it.

Whether an undelivered block is still wanted is your human partner's call. A block may have been dropped because its scope was given up, and a gap filed for it would ask a later batch to deliver what nobody wants.

**The batch directory on `main` holds exactly the batch's merged stories.** An artifact only reaches `main` when its pull request merges, and closing runs once every story is merged or abandoned — so an abandoned story left no document there, and there is nothing to subtract from what you collect.

**Read the declarations, not the specs.** A block fitted to a `main` that had moved is a block that was delivered, and its text in the spec no longer matches the batch document word for word. Diffing the specs against the delta would report it missing; the declaration reports it delivered, which is what it is. Judging a transcription is the delivery review's job, and it is already done.

**A corrective batch has nothing to compare here**, and that is not a gap in the duty. Its spec delta carries no block, so it announced none a spec could fall short of. What it announced instead were the gaps register entries it reserved, and an entry it never resolved is an unconsumed reservation: *Release unconsumed reservations* is the whole of this duty for a corrective batch. Do not invent a comparison, and do not re-file the released entries as fresh gaps — they are still in the register where they always were.

### Set status: closed

Set `status: closed` in the batch document's front matter. That is the whole duty, and it comes last: it is the record that the other duties were done, so it must not precede them.

Then push and open the pull request. The **review of the closing pull request** is the human gate, like every other gate in this system — this plugin adds no ceremony, it puts its checkpoints where your flow already has them. Closing records a human decision, that the batch delivered what it owed, and that decision deserves its review. A batch is never closed because an agent judged the work to look finished.

**To end the review, invoke `supercharlouze:finishing-a-pr` and give it no condition and no next step.** What comes after a closed batch is chosen outside this model.

## Language

**English skeleton, project-language prose.** Section titles, field names, table headers, front matter values (`status: closed`), path patterns and branch patterns are English, everywhere and always. The prose you write — the body of a gaps register entry, an amended scope paragraph — follows the project's language, as do the slugs, which name business objects. This skill and every message it produces are English; the documents it writes carry both.

Every text this skill writes follows `Concision` in `supercharlouze:following-the-rules`.

## Red Flags

| Thought | Reality |
|---------|---------|
| "A story was abandoned, nothing to do — closing its PR undid it all" | Not on main: its reservation and the blocks the batch announced are still there. |
| "Observed drift is out of scope for this batch" | That is exactly why it goes to the register instead of being forgotten. |
| "A flag is still live, so I cannot close — dead end" | Three exits: lift it, declare an extended scope by amendment, or tear the guarded code down. |
| "I'll do the writing duties first and check the flags at the end" | The flag check writes nothing, so it comes first. Checked later, a refusal strands the writing already done on a branch nobody can merge, and re-running duplicates all of it. |
| "The flag is gone from the code, that is enough" | The gating sentence in the spec is part of the flag. Left behind, it makes the spec false. |
| "The delta announced lifting an earlier batch's flag, but the flag check only covers our own flags" | Right, and *Withdraw the blocks no story delivered* checks the rest: an announced lifting that did not happen is a block not delivered. |
| "I'll flip the status now and file the gaps in a follow-up" | The status is the record that the duties were done. Flipping it first turns the record into a lie. |
| "The batch document says it delivered X, so it delivered X" | Check the `Blocks:` declarations of the merged stories, not the promise made at opening. The whole point of *Withdraw the blocks no story delivered* is the difference. |
| "No story reported drift, so there is nothing to consolidate" | Confirm by reading each story document. An empty Observed drift section and an unread one look identical from here. |
| "The Rulings log is the delivery review's business, not mine" | Its open rulings classified as a violation or a gap are yours to consolidate. The review settled the rest. |
