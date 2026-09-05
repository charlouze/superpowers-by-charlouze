---
name: closing-a-batch
description: Use when every user story of a batch is merged or abandoned - writes the changelog, consolidates observed drift, releases reservations, checks flags and closes the batch
---

# Closing a Batch

## Overview

A batch closes when every one of its user stories is merged or abandoned and the human judges the work finished. Closing is not bookkeeping. It is the only moment in the lifecycle where the residue left on `main` gets collected.

Abandoning a story is almost free: closing its pull request without merging throws away the spec slice and the code together — nothing to revoke, no spec left out of step. But two things it never touched are still on `main`, put there by the batch's own opening pull request: the gaps register entry the batch reserved, and the intention the batch announced in its spec delta. **No other skill picks them up.** If closing skips a duty, that duty is simply never done.

Six duties, one pull request, on a branch named `batch/NN-<slug>-close`. Duty 5 is allowed to refuse, and because it is allowed to refuse it runs its check before the four that write.

**Announce at start:** "I'm using the closing-a-batch skill to close batch NN."

## Preconditions

- **Every story is merged or its pull request is closed.** `gh pr list` is the authority. A story's state *is* its pull request's state — there is no checklist anywhere to reconcile against.
- **Your human partner judges the batch finished.** Every story being merged or closed is necessary and not sufficient. Closing records a human decision — that the batch delivered what it owed — and a batch is never closed because an agent judged the work to look finished.
- **You are in the main checkout, on `main`, refreshed from the remote.** In the main checkout because `superpowers:finishing-a-development-branch` *preserves* the worktree on the pull request path: from inside one, `superpowers:using-git-worktrees` Step 0 sees `GIT_DIR != GIT_COMMON`, concludes "already in a linked worktree" and reuses it, and this closure lands on the previous branch instead of its own. Refreshed because merges arrive from the remote; a stale `main` hides the very stories you are about to account for, and you would consolidate from an incomplete set.
- **Create the branch and its workspace by invoking `superpowers:using-git-worktrees`.** The conventional name is `batch/NN-<slug>-close`, enforced by this plugin, not by that skill. If it lands on a differently named branch or a detached HEAD, make sure a named branch exists before continuing — nothing depends on the name, but a pull request needs a branch.
- **Read the batch document `docs/batches/NN-<slug>/README.md` and every story document in that directory.** The story documents carry the drift you are about to consolidate; the batch document carries the intention you are about to check against what actually shipped. "Every document in that directory" is every document that reached `main`: an abandoned story's document died with its branch, never merged, so it is not there — and neither is whatever it recorded under `Observed drift`. Nothing recovers it; that is part of what abandoning costs. Read what is on `main` and do not go hunting closed pull requests for documents that never landed.

## The Six Duties

Do all six on the same branch. Then open one pull request.

**Duty 5 is a check, not a write, and its check runs first — before duties 1 to 4 write anything.** The numbering below is the model's and does not change; only the moment of that one check is fixed. Read the code, the specs and the batch document's `Live flags` rulings for surviving flags, decide whether this batch may be closed at all, and only then do duties 1, 2, 3, 4 in order, with duty 6 last as always.

The reason is what a refusal costs. Duties 1 to 4 all write: changelog lines into every touched spec, consolidated drift and recorded shortfalls into the gaps registers, released reservations. Duty 5 writes nothing — it reports and hands the decision to your human partner. Check first and a refusal costs nothing: the close branch is still empty, there is no commit to abandon, and the batch closes later in one clean run once the lifting story has merged. Check last and a refusal strands four duties' worth of writing on a branch nobody may merge, and none of it is safe to re-run: a second attempt would append the changelog line a second time, re-append every consolidated drift entry, and find reservations duty 3 had already released for a batch that was never closed.

So: if duty 5 refuses, **stop before writing anything.** Report the surviving flag, present the three exits below, and leave the batch open. The only thing to clean up is an empty branch and its workspace.

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

**A corrective batch has nothing to compare here**, and that is not a gap in the duty. Its spec delta is empty by definition — it restores behaviour a spec already promises — so it announced no intention a spec could fall short of. What it announced instead were the gaps register entries it reserved, and an entry it never resolved is an unconsumed reservation: duty 3 is the whole of this duty for a corrective batch. Do not invent a comparison, and do not re-file the released entries as fresh gaps — they are still in the register where they always were.

### 5. Refuse to close on a flag that survives without a declared scope

**This check runs first, before duties 1 to 4 — see The Six Duties above.** It writes nothing, so performing it on an empty branch makes a refusal free.

Check every feature flag this batch owed — the ones **it declared** and the ones **it inherited by a ruling at the opening gate** — in two places: the code, and the gating sentences of the specs it touched. A surviving flag is acceptable **only** if its extended scope and its lifting condition are declared — in the batch document's `Feature flag` field and in the spec's gating sentence. A flag that survives with **no declared scope** means the lifting story was never written, and the batch **cannot be closed**.

**Both sources are named in the batch document, and you read both.** The `Feature flag` field names what this batch declared at opening. The `Live flags` section names the gating sentences that were already live when it opened, each carrying the ruling the human gave at the gate: an entry annotated `carried by this batch — lifting story owed` is a flag this batch was ruled the lifter of, so it owed a lifting story exactly as a flag of its own, and its survival blocks closing on exactly the same terms — with the same three exits. Entries ruled `not this batch — <reason>` are somebody else's; leave them alone. If `Live flags` says `none`, nothing was inherited, and you say so rather than passing over the section in silence.

**For an inherited flag the ruling replaces the declaration as the test.** That flag was declared by an earlier batch, so it does have a scope and a lifting condition on record — reading it against the paragraph above would clear it every time, and the batch ruled to lift it would close over a lifting story nobody wrote. The ruling is what changed: the human found the lifting condition satisfied by *this* batch, which is precisely what makes the old extended scope spent. So the entry is settled only if the flag is gone from the code and its gating sentence gone from the spec; otherwise, refuse and present the exits — the flag's scope may be extended again, but by an amendment on *this* batch, decided now and not inherited from the batch that first declared it.

Read `Live flags` even when the `Feature flag` field says `none`: an exempted batch declares no flag of its own and can still have been ruled the lifter of somebody else's. The reason to check at all is that a flag inherited by ruling and a flag declared at opening are indistinguishable once the lifting story is missing, and only the batch that was ruled the lifter is in a position to notice — the ruling exists in this document and nowhere else, and after this closure nobody reads it again.

This is the duty an agent in a hurry will want to skip, so take the reason seriously. A wanted flag and a forgotten flag are indistinguishable in the code — the declaration is the only thing that separates them. Treating an undeclared survivor as "probably fine" reinstates the classic failure mode of feature flags: guarded code nobody dares to remove, and the failure is silent. Deliberate survival stays possible; survival by oversight does not.

Refusing is not a dead end. Report the surviving flag and present the **three exits**; the human chooses, you do not:

| Exit | What it does | Form |
|---|---|---|
| Lift | Ships what exists: removes the branching in the code and the gating sentence in the spec | A lifting story, written with `supercharlouze:writing-a-user-story` — one per guarded module |
| Extend the scope | Defers the decision to a later batch by declaring the flag's extended scope and its lifting condition | An amendment pull request on the batch document, written with `supercharlouze:writing-a-batch` — its *Amending a Batch* section owns this path — and reviewed like any other |
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
| "I'll work through the duties in order and check the flags at the end" | Duty 5 writes nothing, so it checks first. Checked last, a refusal strands four duties of writing on a branch nobody can merge, and re-running duplicates all of it. |
| "I'm already in a worktree from this batch's last story, I'll close from here" | using-git-worktrees would reuse it and the closure would land on that story's branch. Back to the main checkout first. |
| "The flag is gone from the code, that is enough" | The gating sentence in the spec is part of the flag. Left behind, it makes the spec false. |
| "This batch declared no flag, so duty 5 has nothing to check" | Read `Live flags` too. An exempted batch can still have been ruled the lifter of a flag somebody else declared. |
| "That surviving flag has a declared scope, so it passes" | Not if `Live flags` rules it carried by this batch. The ruling says its lifting condition is met; the old scope is spent. |
| "I'll flip the status now and file the gaps in a follow-up" | The status is the record that the duties were done. Flipping it first turns the record into a lie. |
| "The batch document says it delivered X, so it delivered X" | Check the specs on main, not the promise made at opening. The whole point of duty 4 is the difference. |
| "No story reported drift, so there is nothing to consolidate" | Confirm by reading each story document. An empty Observed drift section and an unread one look identical from here. |
