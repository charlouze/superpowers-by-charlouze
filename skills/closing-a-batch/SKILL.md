---
name: closing-a-batch
description: Use when every user story of a batch is merged or abandoned - writes the changelog, consolidates observed drift, releases reservations, checks flags and closes the batch
---

# Closing a Batch

## Overview

A batch closes when every one of its user stories is merged or abandoned and the human judges the work finished. Closing is not bookkeeping. It is the only moment in the lifecycle where the residue left on `main` gets collected.

Abandoning a story is almost free: closing its pull request without merging throws away the spec slice and the code together — nothing to revoke, no spec left out of step. But two things it never touched are still on `main`, put there by the batch's own opening pull request: the gaps register entry the batch reserved, and the intention the batch announced in its spec delta. **No other skill picks them up.** If closing skips a duty, that duty is simply never done.

Six duties, one pull request, on a branch named `batch/NN-<slug>-close`. Duty 5 is allowed to refuse.

**Announce at start:** "I'm using the closing-a-batch skill to close batch NN."

## Preconditions

- **Every story is merged or its pull request is closed.** `gh pr list` is the authority. A story's state *is* its pull request's state — there is no checklist anywhere to reconcile against.
- **You are in the main checkout, on `main`, refreshed from the remote.** Merges arrive from the remote; a stale `main` hides the very stories you are about to account for, and you would consolidate from an incomplete set.
- **Create the branch and its workspace by invoking `superpowers:using-git-worktrees`.** The conventional name is `batch/NN-<slug>-close`, enforced by this plugin, not by that skill. If it lands on a differently named branch or a detached HEAD, make sure a named branch exists before continuing — nothing depends on the name, but a pull request needs a branch.
- **Read the batch document `docs/batches/NN-<slug>/README.md` and every story document in that directory.** The story documents carry the drift you are about to consolidate; the batch document carries the intention you are about to check against what actually shipped.

## The Six Duties

Do all six on the same branch. Then open one pull request.

### 1. Write the changelog line

Append to the **Changelog** table (`batch | date | change`) at the foot of every spec this batch touched: **one line per batch**, per touched spec — not one line per story.

Stories do not write the changelog, and the reason is contention, not taste. The table grows at a single point at the foot of the file. If every story appended its own line, all the stories of a module in flight at the same time would conflict at exactly that point — and several stories in flight is the nominal regime, not an edge case. One writer per batch removes the conflict outright.

The changelog is a reading convenience, not a mechanism: no rule of this system depends on it. The authoritative history is `git log docs/specs/<module>.md`, exact by construction because every spec change travels in the same pull request as its code. Write the line well — a human skims it — but never let a difficulty here become a reason to stop.

### 2. Consolidate observed drift

Collect the **Observed drift** section of every story document in the batch and write its findings into the gaps register of the module concerned, `docs/specs/<module>.gaps.md`: code that contradicts the spec goes under **Violations**, behaviour no spec describes goes under **Gaps**.

Stories deliberately do not write into the register. Adding an entry appends at the end of a section and competes with every other addition to the same module — the same contention duty 1 avoids, solved the same way: a single writer per batch. Their observations wait in their own document until now, which is why they are recorded there and why you are the one who moves them.

"Out of scope for this batch" is never a reason to drop an observation. It is precisely why the observation belongs in the register: the register is what a later corrective batch draws its scope from. Dropped here, the finding dies with the session that made it.

### 3. Release unconsumed reservations

For every gaps register entry this batch reserved at opening (`reserved by batch-NN`) that was never struck through, remove the reservation annotation. Those are the **unconsumed reservations** — a story abandoned, a scope revised mid-flight. Entries a story did strike stay struck: that gesture was atomic with the code that resolved them.

Closing a story's pull request does not do this for you. The reservation lives on `main` — it got there when the batch's opening pull request merged — and abandoning a story touches nothing on `main`. Left in place, the annotation is a perpetual claim: the gap looks taken forever, and no future batch can pick it up.

### 4. Record intentions announced but never delivered

Compare the spec delta the batch announced at opening against what actually reached the specs. For everything **announced but never delivered** — story abandoned, scope cut along the way — do both of these:

1. Write the shortfall into the gaps register of the module concerned, under **Gaps**.
2. Amend the batch document so it no longer promises what it did not deliver.

Both, not either. Without this step the abandonment is perfectly invisible: it is not drift, because the spec and the code agree — both are silent about the feature; and it is not a gap, because nothing recorded it. It is a promise forgotten inside a document that just went `closed`. This duty is the only reader of that edge in the whole system.

### 5. Refuse to close on a flag that survives without a declared scope

Check every feature flag this batch declared, in two places: the code, and the gating sentences of the specs it touched. A surviving flag is acceptable **only** if its extended scope and its lifting condition are declared — in the batch document's `Feature flag` field and in the spec's gating sentence. A flag that survives with **no declared scope** means the lifting story was never written, and the batch **cannot be closed**.

This is the duty an agent in a hurry will want to skip, so take the reason seriously. A wanted flag and a forgotten flag are indistinguishable in the code — the declaration is the only thing that separates them. Treating an undeclared survivor as "probably fine" reinstates the classic failure mode of feature flags: guarded code nobody dares to remove, and the failure is silent. Deliberate survival stays possible; survival by oversight does not.

Refusing is not a dead end. Report the surviving flag and present the **three exits**; the human chooses, you do not:

| Exit | What it does | Form |
|---|---|---|
| Lift | Ships what exists: removes the branching in the code and the gating sentence in the spec | A lifting story, written with `supercharlouze:writing-a-user-story` — one per guarded module |
| Extend the scope | Defers the decision to a later batch by declaring the flag's extended scope and its lifting condition | An amendment pull request on the batch document, reviewed like any other |
| Tear down | Removes the guarded code and the corresponding spec slice | A teardown story, written with `supercharlouze:writing-a-user-story` |

Then stop and wait. Do not close the batch under an undeclared surviving flag "to be tidied up later" — that is the outcome this duty exists to prevent. And do not leave the batch open indefinitely either: without these three exits, the refusal would manufacture exactly the dead flagged code it is meant to prevent.

### 6. Set status: closed

Set `status: closed` in the batch document's front matter. That is the whole duty, and it comes last: it is the record that the other five were done, so it must not precede them.

Then push and open the pull request. The **review of the closing pull request** is the human gate, like every other gate in this system — this plugin adds no ceremony, it puts its checkpoints where your flow already has them. Closing records a human decision, that the batch delivered what it owed, and that decision deserves its review. A batch is never closed because an agent judged the work to look finished.

## Language

**English skeleton, project-language prose.** Section titles, field names, table headers, front matter values (`status: closed`), path patterns and branch patterns are English, everywhere and always. The prose you write — the `change` cell of a changelog line, the body of a gaps register entry, an amended scope paragraph — follows the project's language, as do the slugs, which name business objects. This skill and every message it produces are English; the documents it writes carry both.

## Red Flags

| Thought | Reality |
|---------|---------|
| "A story was abandoned, nothing to do — closing its PR undid it all" | Not on main: its reservation and the batch's announced intention are still there. |
| "The changelog is already up to date, each story added its line" | Stories do not write the changelog. One line per batch, here. |
| "Observed drift is out of scope for this batch" | That is exactly why it goes to the register instead of being forgotten. |
| "A flag is still live, so I cannot close — dead end" | Three exits: lift it, declare an extended scope by amendment, or tear the guarded code down. |
| "The flag is gone from the code, that is enough" | The gating sentence in the spec is part of the flag. Left behind, it makes the spec false. |
| "I'll flip the status now and file the gaps in a follow-up" | The status is the record that the duties were done. Flipping it first turns the record into a lie. |
| "The batch document says it delivered X, so it delivered X" | Check the specs on main, not the promise made at opening. The whole point of duty 4 is the difference. |
| "No story reported drift, so there is nothing to consolidate" | Confirm by reading each story document. An empty Observed drift section and an unread one look identical from here. |
