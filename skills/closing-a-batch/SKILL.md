---
name: closing-a-batch
description: Use when every user story of a batch is merged or abandoned - consolidates what the story documents left, releases reservations, withdraws undelivered blocks, checks flags and closes the batch
---

# Closing a Batch

## Overview

A batch closes when every one of its user stories is merged or abandoned and the human judges the work finished. Closing is not bookkeeping. It is the only moment in the lifecycle where the residue left on `main` gets collected.

It is also the only moment in a batch's normal course that touches the batch document itself. The batch document carries no mutable state: it is written once, by the opening pull request, and nothing in the normal course of the batch modifies it **until closing** — *Withdraw the blocks no story delivered* removes them from it, and *Set status: closed* flips its front matter. This closure is that exception and the only one: anything else that would edit the document goes through an amendment pull request of its own, which `supercharlouze:writing-a-batch` owns.

Abandoning a story is almost free: closing its pull request without merging throws away its code, and its spec change if it had one — nothing to revoke, no spec left out of step. But what it never touched is still on `main`, put there by the batch's own opening pull request: the gaps register entry the batch reserved, and the blocks the batch announced in its spec delta. Either may be absent — a batch with no blocks announced none, a batch that reserved nothing left nothing to release — so what closing owes here is a look at both, not a tally. **No other skill picks them up.** If closing skips a duty, that duty is simply never done.

Every duty lands in one pull request, on a branch named `batch/NN-<slug>-close`. The flag check is allowed to refuse, and because it is allowed to refuse it comes before the duties that write.

**Announce at start:** "I'm using the closing-a-batch skill to close batch NN."

## Preconditions

- **Every story is merged or its pull request is closed.** `gh pr list` is the authority. A story's state *is* its pull request's state — there is no checklist anywhere to reconcile against.
- **Your human partner judges the batch finished.** Every story being merged or closed is necessary and not sufficient. Closing records a human decision — that the batch delivered what it owed — and a batch is never closed because an agent judged the work to look finished.
- **The close branch starts from `main` as the remote carries it.** Fetch, then branch from `origin/main`, never from another branch. Otherwise two things go wrong at once: `superpowers:finishing-a-development-branch` *preserves* the worktree on the pull request path, so from inside one `superpowers:using-git-worktrees` Step 0 sees `GIT_DIR != GIT_COMMON`, concludes "already in a linked worktree" and reuses it, and this closure lands on the previous branch instead of its own; and a starting point behind the remote hides the very stories you are about to account for, so you would consolidate from an incomplete set.
- **Create the branch and its workspace by invoking `superpowers:using-git-worktrees`.** The conventional name is `batch/NN-<slug>-close`, enforced by this plugin, not by that skill. If it lands on a differently named branch, a detached HEAD, or a starting point other than `origin/main`, restore the conventional name and the starting point before going on. **A named branch is not enough** — though here, unlike on a story branch, nothing is lost if you get it wrong: this batch's `NN` is already held by `docs/batches/NN-<slug>/` on `main`, since closing only runs on a batch whose opening pull request merged, so number allocation refuses it on that ground alone whatever this branch is called. The convention is uniform because one honoured only where a scan would catch you is not a convention at all.
- **Read the batch document `docs/batches/NN-<slug>/README.md` and every story document in that directory.** The story documents carry what you are about to consolidate — the drift they observed, and the open rulings their `Rulings log` leaves; the batch document carries the blocks you are about to check against the `Blocks:` declarations of the story documents. "Every document in that directory" is every document that reached `main`: an abandoned story's document died with its branch, never merged, so it is not there — and neither is whatever it recorded under `Observed drift`. Nothing recovers it; that is part of what abandoning costs. Read what is on `main` and do not go hunting closed pull requests for documents that never landed.

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
| Extend the scope | Defers the decision to a later batch by declaring the flag's extended scope and its lifting condition | An amendment pull request on the batch document, written with `supercharlouze:writing-a-batch` — its *Amending a Batch* section owns this path — and reviewed like any other |
| Tear down | Removes the guarded code and the corresponding spec change | A teardown story, written with `supercharlouze:writing-a-user-story` |

Then stop and wait. Do not close the batch under an undeclared surviving flag "to be tidied up later" — that is the outcome this duty exists to prevent. And do not leave the batch open indefinitely either: without these three exits, the refusal would manufacture exactly the dead flagged code it is meant to prevent.

### Consolidate what the story documents left

Collect from every story document in the batch what it left for you, and write it into the gaps register of the module concerned, `docs/specs/<module>.gaps.md`. **Two sections carry it.** The **Observed drift** section holds what the story saw outside its own scope. The **Rulings log** holds its `Open ruling:` lines, each of which names the gaps register category that takes it — the ones classified as a violation or a gap are yours, and the rest were settled at the delivery review, where an open ruling can still be acted on. From either section, whatever a story reported as code contradicting the spec goes under **Violations**, whatever it reported as behaviour no spec describes goes under **Gaps**. A story finds its gaps in the code it went through; those are this duty's sources, and they are not the only sources the register has.

**An open ruling that names no category should not reach you.** A story does not merge leaving one without a destination — the delivery review settles those, and it is the last moment that can: here the story is merged and its branch is gone, so you can note that a ruling was never taken up and no longer take it up. If you find one, report it with the rest of your findings and let your human partner rule; do not classify it yourself.

Stories deliberately do not write into the register. Adding an entry appends at the end of its category and competes with every other addition to the same module, and a single writer per batch removes that contention. Their findings wait in their own document until now, which is why they are recorded there and why you are the one who moves them.

"Out of scope for this batch" is never a reason to drop an observation. It is precisely why the observation belongs in the register: the register is what a later corrective batch draws its scope from. Dropped here, the finding dies with the session that made it.

**Read the file's history before adding an entry** (`git log -p docs/specs/<module>.gaps.md`). An entry that once left this file left for a reason, and that reason is in the commit that removed it — resolved, promoted, moot, false, or set aside by your human partner. Re-filing an observation that was already set aside, without saying what has changed since, reopens a decision nobody has reviewed.

**What qualifies an entry lives in the entry.** Besides its coverage, the register carries nothing but entries: no prose qualifies a *group* of them — where they came from, how they were classified, how many there are. Entries are added and removed one at a time, and nothing keeps such a paragraph honest: it goes false without anyone touching it. What it would say of several entries is repeated in each, and where an entry came from is read in the history of the file. You arrive with a batch's worth of findings at once, so the temptation is yours more than anyone's: write "consolidated by batch NN" into each entry that needs it, never above them.

**An entry designates no other entry.** A settled entry leaves the file whole, and it takes with it anything that pointed at it — by name or by position. What an entry needs from its neighbour it states itself.

### Release unconsumed reservations

For every gaps register entry this batch reserved at opening (`reserved by batch-NN`) that is still in the file, release it. Releasing removes the reservation annotation and leaves the entry: the gap is still open, it is simply no longer claimed. Those are the **unconsumed reservations** — a story abandoned, a scope revised mid-flight. An entry a story did resolve is not there to release: the story deleted it from the file, atomically with the code that resolved it, and the commit that removes it says why.

Closing a story's pull request does not do this for you. The reservation lives on `main` — it got there when the batch's opening pull request merged — and abandoning a story touches nothing on `main`. Left in place, the annotation is a perpetual claim: the gap looks taken forever, and no future batch can pick it up.

### Withdraw the blocks no story delivered

Read the `Blocks:` field of every story document in the batch directory, and collect the `D<n>` identifiers they declare; a `none` declares nothing. A block the batch document's `Spec delta` defines and that no collected declaration names is a block announced but never delivered: a story abandoned, a scope cut along the way. For each one:

1. Remove it from the batch document, its `Spec delta` entry and any constraint that names it, so the document no longer promises what the batch did not deliver.
2. Ask your human partner whether it joins the gaps register. If they say yes, write it under **Gaps** in the register of the module concerned.

Without this duty the abandonment is invisible. It is not drift, since the spec and the code agree: both are silent about the feature. And nothing else records it.

Whether an undelivered block is still wanted is your human partner's call. A block may have been dropped because its scope was given up, and a gap filed for it would ask a later batch to deliver what nobody wants.

**The batch directory on `main` holds exactly the batch's merged stories.** An artifact only reaches `main` when its pull request merges, and closing runs once every story is merged or abandoned — so an abandoned story left no document there, and there is nothing to subtract from what you collect.

**Read the declarations, not the specs.** A block fitted to a `main` that had moved is a block that was delivered, and its text in the spec no longer matches the batch document word for word. Diffing the specs against the delta would report it missing; the declaration reports it delivered, which is what it is. Judging a transcription is the delivery review's job, and it is already done.

**A corrective batch has nothing to compare here**, and that is not a gap in the duty. Its spec delta is empty by definition — it restores behaviour a spec already promises — so it announced no block a spec could fall short of. What it announced instead were the gaps register entries it reserved, and an entry it never resolved is an unconsumed reservation: *Release unconsumed reservations* is the whole of this duty for a corrective batch. Do not invent a comparison, and do not re-file the released entries as fresh gaps — they are still in the register where they always were.

### Set status: closed

Set `status: closed` in the batch document's front matter. That is the whole duty, and it comes last: it is the record that the other duties were done, so it must not precede them.

Then push and open the pull request. The **review of the closing pull request** is the human gate, like every other gate in this system — this plugin adds no ceremony, it puts its checkpoints where your flow already has them. Closing records a human decision, that the batch delivered what it owed, and that decision deserves its review. A batch is never closed because an agent judged the work to look finished.

**Ending the review.** The agent never approves and never merges a pull request. Each correction is pushed as a `fixup!` commit of the commit it corrects, or as a commit of its own when it carries a fresh decision; your human partner gives their agreement in the conversation, and only then do you squash the fixups, push, and announce the pull request ready.

**Merging a closing review is a moment to clear the context.** It is the one gate with **no next step to name**, so it **hands over no prompt** — what comes after a closed batch is chosen outside this model.

## Language

**English skeleton, project-language prose.** Section titles, field names, table headers, front matter values (`status: closed`), path patterns and branch patterns are English, everywhere and always. The prose you write — the body of a gaps register entry, an amended scope paragraph — follows the project's language, as do the slugs, which name business objects. This skill and every message it produces are English; the documents it writes carry both.

Every text this skill writes follows `Concision` in `supercharlouze:using-batches`.

## Red Flags

| Thought | Reality |
|---------|---------|
| "A story was abandoned, nothing to do — closing its PR undid it all" | Not on main: its reservation and the blocks the batch announced are still there. |
| "Observed drift is out of scope for this batch" | That is exactly why it goes to the register instead of being forgotten. |
| "A flag is still live, so I cannot close — dead end" | Three exits: lift it, declare an extended scope by amendment, or tear the guarded code down. |
| "I'll do the writing duties first and check the flags at the end" | The flag check writes nothing, so it comes first. Checked later, a refusal strands the writing already done on a branch nobody can merge, and re-running duplicates all of it. |
| "I'm already in a worktree from this batch's last story, I'll close from here" | Close from there if you like, but branch from `origin/main`: otherwise using-git-worktrees reuses the workspace and the closure lands on that story's branch. |
| "The flag is gone from the code, that is enough" | The gating sentence in the spec is part of the flag. Left behind, it makes the spec false. |
| "The delta announced lifting an earlier batch's flag, but the flag check only covers our own flags" | Right, and *Withdraw the blocks no story delivered* checks the rest: an announced lifting that did not happen is a block not delivered. |
| "I'll flip the status now and file the gaps in a follow-up" | The status is the record that the duties were done. Flipping it first turns the record into a lie. |
| "The batch document says it delivered X, so it delivered X" | Check the `Blocks:` declarations of the merged stories, not the promise made at opening. The whole point of *Withdraw the blocks no story delivered* is the difference. |
| "No story reported drift, so there is nothing to consolidate" | Confirm by reading each story document. An empty Observed drift section and an unread one look identical from here. |
| "The Rulings log is the delivery review's business, not mine" | Its open rulings classified as a violation or a gap are yours to consolidate. The review settled the rest. |
