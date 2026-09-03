---
name: writing-a-user-story
description: Use when writing the next user story of an open batch - transcribes the spec slice, then hands off to superpowers:writing-plans and subagent-driven-development
---

# Writing a User Story

## Overview

A story is the unit of technical delivery: **one story, one branch, one pull
request** — and that pull request carries *both* the spec slice and the code
that implements it. They ship together or not at all. That is what gives
`main` its central property: **its spec always describes exactly
what its code does.** No intermediate state to signal, no marker, no exception
to the drift rule.

**Announce at start:** "I'm using the writing-a-user-story skill to write this
story."

This skill runs the whole cycle in one place — preconditions, concurrency
detection, branch, spec slice, plan, execution, records, review — because the
pull request carries the story's state. There is nothing to repatriate
afterwards and nothing to reconcile.

Stories are written **one at a time**: story N+1 is written knowing what story
N produced. Several may be *in flight* simultaneously — that is the normal
regime of a pull-request flow, not an edge case.

A story targets exactly **one** module, therefore exactly one spec. If the work
spans two modules, it is two stories.

## Preconditions

Check all of these before creating anything. They apply to every pull request
of this system, not only to stories.

- **You are in the main checkout.** `git rev-parse --git-dir` and
  `git rev-parse --git-common-dir` resolve to the same directory. Reason:
  `superpowers:finishing-a-development-branch` *preserves* the worktree on the
  pull request path. A session that chains two stories without leaving it would
  let `superpowers:using-git-worktrees` skip creation — its Step 0 sees
  `GIT_DIR != GIT_COMMON`, concludes "already in a linked worktree" and reuses
  the existing one — and this story's code would land on the previous story's
  branch. Go back to the main checkout first.
- **`main` is checked out and up to date with the remote.**
  Fetch, then fast-forward. Merges arrive from the remote; without that
  refresh, number allocation and concurrency detection both reason on a stale
  state.
- **`gh` is available and authenticated.** Number allocation and concurrency
  detection both query it. Without it, both degrade to a partial net —
  collision visible when the pull request opens, merge conflict — and they no
  longer *prevent* anything. Say so rather than proceeding silently.
- **The batch exists and is open.** Its opening pull request is merged and its
  document says `status: open`. Until that gate is passed, no story is written.

That first check assumes a plain repository. In a submodule, `GIT_DIR` and
`GIT_COMMON` differ without a worktree being involved; a submodule project is
outside the path this plugin covers.

## Step 1 — Detect Concurrency

Two stories touching the same section of the same spec are a conflict. Decide
which sections this story will touch, then check that nobody else holds them.

1. **List the open pull requests together with the files they touch**, and keep
   those whose files include this story's spec file. Bare `gh pr list` prints
   neither the files of a pull request nor its head branch, so it can never
   answer this question — ask for both explicitly:

   ```bash
   gh pr list --state open --limit 100 --json number,headRefName,files
   gh pr view <n> --json number,headRefName,files   # one pull request at a time
   ```

2. **For each of those, read the `Sections:` field of its story document.** That
   document lives on the *other* pull request's head branch, not on yours:
   looking for it in your worktree finds nothing. Read it at the head ref:

   ```bash
   gh api "repos/{owner}/{repo}/contents/<path>?ref=<headRefName>" --jq .content | base64 -d
   git fetch origin <headRefName> && git show FETCH_HEAD:<path>   # local alternative
   ```

3. **Read the same field on every remote `story/*` branch that carries no pull
   request yet.** A story's pull request opens only at the end of Step 5, so a
   sibling holds its sections for the whole length of an implementation without
   appearing in point 1 above. Its branch, however, is on the remote from its
   very first commit (Step 3), so the remote sees it:

   ```bash
   git ls-remote --heads origin 'story/*'
   git fetch origin
   git diff --name-only origin/main...origin/<branch>   # does it touch this spec file?
   git show origin/<branch>:docs/batches/NN-<slug>/NN-us-N-<slug>.md
   ```

   Keep the branches whose diff against `main` touches this story's spec file —
   the same filter point 1 applies to pull requests. Skip the branches already
   covered by a pull request there, and skip your own. A kept branch whose
   story document does not exist yet is a story between its spec commit and its
   plan commit: it holds the spec file and has not yet declared its sections,
   which is an unknown and stops you exactly as point 6 does. That window is one
   plan-writing step long.
4. Intersect all of those with the sections this story will touch.
5. **Stop if the intersection is not empty.** Report which pull request or
   branch holds the section, and let your human partner sequence the two.
6. **Stop if you could not read a pull request's `Sections:` field** — fetch
   failed, document absent, field missing. An unread field is an unknown, not a
   pass. Name the pull request and say why, and let your human partner decide.
   Silently treating it as empty turns the one real net into "found nothing".
   The same applies to a story branch kept at point 3.

**Name the blind spot rather than trusting the net.** What this check sees is
what is on the remote: open pull requests, and pushed story branches. A story
that has created its branch but not yet pushed it is invisible to every sibling,
and no amount of care at this step finds it. That window runs from Step 2 to the
push at the end of Step 3, which is precisely why the push happens there and not
at the end of the run — it turns a window as long as an implementation into one
as long as writing a single commit. Read this step as complete for work already
on the remote, and as blind to everything else.

Sections are **declared, not derived**: reading a diff to guess which sections
a story touches is fragile, whereas the story's author knows them. That is the
entire reason the story document carries the field.

Do not fall back on git. A merge conflict is only a **partial safety net** —
git conflicts on lines, not on sections, so two stories editing the same
section in distant places merge cleanly. Relying on it lets through exactly the
case this check exists to catch.

## Step 2 — Allocate us-N and Create the Branch

`us-N` is the smallest integer **not used in the batch directory on `main`**
*and* **not claimed by an open pull request** (`gh pr
list`). Both conditions are necessary: an artifact only reaches `main`
when its pull request merges, so the directory listing knows nothing
about what is in flight. Going by the directory alone gives the same number to
two stories written while a third is in review.

Branch name, enforced by this plugin and not by superpowers:

| Object | Branch |
|---|---|
| Story | `story/NN-us-N-<slug>` |

`NN` is the batch number, `us-N` the story number, and the slug follows the
project's language — it names a business object.

Create the branch and the workspace by invoking
`superpowers:using-git-worktrees`. That skill prefers the harness's native
tooling, which picks its own branch name, and may leave a detached HEAD. If it
produces another name, a detached HEAD, or if isolation is declined, make sure
a **named branch exists** before going further. No mechanism here depends on
the name — identification goes through the pull request and the story document
— but a pull request cannot be opened without a branch.

The story document lives at `docs/batches/NN-<slug>/NN-us-N-<slug>.md`. The
`NN-` prefix keeps basenames unique across batches. On the nominal path it is
comfort: each story runs in its own worktree. On degraded paths — worktree
declined, isolation unavailable — two stories share a checkout, SDD derives its
workspace from the plan's **basename**, and two `us-1-setup.md` would share one
ledger.

## Step 3 — Commit the Spec Slice First

Transcribe into `docs/specs/<module>.md` the part of the batch's spec delta
that **this** story delivers, and commit it as the **first commit on the
branch** — before the plan is written, before any task runs. **A lifting story
transcribes a removal:** its slice deletes the gating sentence from the spec
instead of adding behaviour, and that deletion is this same first commit (see
Lifting and Teardown Stories below).

Both properties are load-bearing.

**Incremental.** One slice per story, never the batch's whole delta. Otherwise
the spec would describe, while story 1 is still executing, the behaviour of the
stories that follow — and the SDD reviewers would flag as missing what is not
yet meant to be delivered.

**First.** Not for visibility — the file would be readable in the worktree even
uncommitted — but because this is what makes the norm **prior and binding** on
the code. It is already in the branch's history when implementation starts, it
travels in the pull request, and the freeze of Step 4 gets an identifiable
starting point.

If the batch declares a feature flag, the transcribed slice **states the flag
and its default**, and — when the declared scope reaches beyond the batch — its
lifting condition:

```markdown
🔒 `billing.recurring`, off by default — lifted when the `facturation` module is fully delivered
```

The code you write next is guarded by that flag. Without this sentence a story
merged behind a flag would make the spec false as users read it, and would
reopen through the window exactly the gap the living spec exists to close. The
sentence disappears in the lifting story, and that is a spec change like any
other.

**Corrective story.** The delta being empty, this first commit does not touch
the spec. It strikes the gaps register entry the story resolves, in
`docs/specs/<module>.gaps.md`. That plays the same role: fixing the scope in
the branch's history before any code exists. Striking an entry is local to a
line already written, so two stories striking different entries do not collide.

**Push the branch as soon as this commit exists** — `git push -u origin
story/NN-us-N-<slug>`. Nothing depends on it for this story; it is what makes
this story *visible*, since a sibling running Step 1 reads pushed `story/*`
branches and the pull request does not exist for a long while yet. Pushing here
rather than at the end shrinks the blind spot named in Step 1 from the length of
an implementation to the length of a single commit.

## Step 4 — Write the Plan

Call `superpowers:writing-plans`. The plan **is** the story document: save it
into the batch directory, and extend the standard header with three fields.

```markdown
**Spec:** docs/specs/facturation.md
**Batch:** docs/batches/07-facturation-recurrente/README.md
**Sections:** Abonnement > Renouvellement, Abonnement > Proration
```

`Spec:` is the field `subagent-driven-development` already reads as the binding
authority — pointing it at the living module spec is what makes this
integration work without modifying superpowers. `Sections:` is what the *next*
story's Step 1 reads.

Then create, at the end of the document, the two sections Step 6 fills — empty
now, and left empty if nothing turns up:

```markdown
## Rulings log

## Observed drift
```

Write them at the same time as the header, not at Step 6. An empty section says
*checked, nothing found*; a missing section says *never examined*, and a
reviewer cannot tell the second from an omission.

`Global Constraints` — which `superpowers:writing-plans` defines as implicitly
part of every task's requirements — carries two things: the constraints the
batch imposes, that is its `Constraints` section copied verbatim, and **the
freeze of the spec file**:

> Between the transcription commit and the opening of the pull request, no task
> modifies the spec file. A story that discovers the spec must change stops.

The freeze exists because the spec file now travels in the same branch as the
code, so SDD's tasks can physically edit it — which was not true when it lived
elsewhere. Putting it in `Global Constraints` puts it in front of every
implementer and every reviewer.

The freeze has a bound: the **freeze is lifted when the pull request opens**.
Review requests are human decisions, including on the wording of the spec
slice, and they apply on the story's branch (Step 7). An unbounded freeze would
make it literally impossible to answer a review — or to resolve a merge
conflict on the spec file.

**When the batch and the spec contradict each other, the spec wins — without
exception and without deliberation.** Implement what the spec says, record a
`Ruling:`, and carry on. **Correcting a spec mid-batch is a human act, never an
agent's.** Put that rule in `Global Constraints` too.

**In a corrective batch, `Global Constraints` carries a third thing: the fifth
stop condition of Step 5, written out in full.** Copy it verbatim:

> If, while bringing code into conformity with the spec, you discover that the
> **spec** is wrong and the code is right, stop. The batch is no longer
> corrective and must be requalified. Do not correct the spec and do not work
> around it.

The freeze above already stops a task that finds the spec must change, but it
stops it and says nothing more. The consequence — that the batch has lost the
qualification it was opened under — is what makes this a requalification rather
than a question to ask and move on from. And the discovery happens inside SDD's
implementer subagents, whose only channel to this skill's rules is this list: a
stop condition stated to you and not written here never reaches the agent who
has to obey it.

**Commit the story document — header, the two empty sections and
`Global Constraints` together — and push it immediately**, `git push`, before
anything else in Step 5 starts. Until that push the branch is on the remote but
declares no sections, and a sibling that finds it has to stop on an unknown.
Pushing here closes that window and is what lets Step 1 answer for a story whose
pull request will not exist for hours.

## Step 5 — Execute

Three of this plugin's four declared overrides bite here. All three are named,
each carries its reason, and none is a matter of judgment in the moment.

**Override 3 — the execution mode is imposed.** `superpowers:writing-plans`
ends by offering a choice between subagent-driven development and
`superpowers:executing-plans`. Do not present that choice: this plugin requires
`superpowers:subagent-driven-development`. Reason: repatriating the rulings
depends on SDD's ledger; `superpowers:executing-plans` keeps none, and the
trace of every arbitration made on your human partner's behalf would be lost.

**Override 4 — the exit of `superpowers:finishing-a-development-branch` is
constrained.** SDD concludes on that skill, which presents three options and
waits for a human choice. On the story path the choice is constrained to
**"Push and create a Pull Request"**. The other two are not equivalent, and the
reason is exact:

- **"Merge back locally" is actively destructive.** It merges into the *local*
  `main` — a `main` that can never be pushed — runs the tests, then **deletes
  the worktree and the branch**. It never pushes, so nothing fails at the time:
  the work ends up in a local commit that can never reach the remote, and the
  branch that would have carried a pull request no longer exists. Step 6 never
  happens either, since it happens on the branch before the merge.
- **"Keep the branch as-is" is not destructive** and remains compatible with a
  protected `main`. It is simply out of the flow: with no pull
  request the story has no observable state and will never be delivered.

So this override removes one choice that cannot succeed, and one that leads
nowhere.

**Override 2 — fifth stop condition (corrective batches).** SDD states that
four things stop you and only these. In a corrective batch, this plugin adds
one: if, while bringing code into conformity with the spec, you discover that
the **spec** is wrong and the code is right, stop. The batch is no longer
corrective and must be requalified — **abandon the story**, then hand the
decision to `supercharlouze:writing-a-batch`. The four native
conditions assume a valid authority exists; here the authority itself is in
question, and an agent may not correct a spec.

**Abandoning here does not start by closing a pull request, because there is
normally no pull request yet.** This condition fires *inside*
`superpowers:subagent-driven-development`, mid-implementation, and the story's
pull request only opens at the very end of this step, through
`superpowers:finishing-a-development-branch`. What exists when it triggers is a
branch and a worktree. So: **close the story's pull request without merging it
if one is already open; the branch and its worktree stay until the
requalification is ruled.**
Nothing on `main` changes either way — the spec slice, or the struck
gaps-register entry, travels with the code and dies with the branch. The
reservation posted on `main` by the batch's opening pull request is untouched,
and `supercharlouze:closing-a-batch` releases it. Delete the abandoned branch,
locally and on the remote, once the requalification is ruled.

It is named as an override for the same reason as the other three: an unnamed
exception to a rule superpowers states as closed does not survive a session
under pressure. It reaches the implementers through `Global Constraints`
(Step 4), which is the only channel they read.

## Step 6 — Record Before the Merge

Before the pull request is merged, and in the session where these facts still
exist:

- Copy every `Ruling:` line from SDD's closing "Rulings I made" message into
  the **Rulings log** of the story document. The list is exhaustive.
- Record under **Observed drift** every divergence between spec and code you
  noticed *outside* this story's scope.

Do **not** add those observations to the gaps register yourself. An addition
happens at the end of a section and contends with every other addition on the
same module — the exact contention this system avoids everywhere else, resolved
the same way: one writer per batch. `supercharlouze:closing-a-batch`
consolidates them in a single pull request.

Commit both on the branch and push, so they merge with it.

**This information is perishable.** SDD's workspace is already deleted, and the
merge may happen days later in another session. A ruling that dies with the
workspace was a decision made in secret.

## Step 7 — Answer the Review

The review of the story's pull request is the delivery gate — a human gate, in
the tool where you already review everything else.

Apply the **review feedback** on the story's branch, including on the wording
of the spec slice: the freeze ended when the pull request opened, precisely so
that this is possible. `superpowers:finishing-a-development-branch` preserved
the worktree on this path, so iterate there. Read the feedback with
`superpowers:receiving-code-review` rigour — verify before you agree.

The story is delivered when its pull request is merged. There is nothing to
tick and nothing to reconcile: its state *is* the state of its pull request.

**Abandoning is almost free.** Closing the pull request without merging throws
the transcription away with the code — nothing to revoke, no spec to put back
straight. If the abandonment happens before the pull request exists — a
requalification under Override 2, a story dropped mid-run — there is nothing to
close, only a branch and a worktree to discard. Two residues remain on `main`:
the gaps register
reservation posted by the batch's opening pull request, and the intention the
batch announced and never delivered. Both belong to
`supercharlouze:closing-a-batch`.

**Clean up after an abandoned or requalified story: remove its worktree and
delete its branch, locally and on the remote.** This is not tidiness. A pushed
`story/*` branch with no pull request is exactly what every sibling's Step 1
reads as a live claim on its sections, so an abandoned branch left on the remote
holds those sections against every story that follows, and nothing ever releases
them.

## Lifting and Teardown Stories

Both are ordinary stories — code plus a spec slice, in one pull request —
written with this skill. No new mechanism.

**The lifting story** removes the branching from the code and the gating
sentence from the spec. It is what actually puts the feature in production.

There is **one lifting story per guarded module**, because the flag is per
(batch, module). A cross-cutting batch guarding two modules writes two lifting
stories, each removing the gating sentence from its own spec and the branching
from its own module — and each keeps the "one story, one module" invariant. A
single story could not do it: it would have to edit two specs.

Which batch owns it depends on the declared scope. With batch scope, it is the
**last story of the batch**. With extended scope, it belongs to the batch that
satisfies the declared lifting condition — often the last batch of a module
under construction. It is not for the current batch to guess:
`supercharlouze:writing-a-batch` surfaces every live flag at the opening gate,
and your human partner rules on whether this batch is the one that lifts.

It is a story and not a closing chore because it carries code, and code
deserves a review and a test cycle. If you want an observation period between
switching on and cleaning up, split it into two stories — enable, then remove.
The model supports that without changing anything.

**The teardown story** is the other way out. When a batch's scope is abandoned
while guarded stories are already merged, a teardown story removes the guarded
code and the corresponding spec slice. It is one of the three exits
`supercharlouze:closing-a-batch` offers when a flag would otherwise survive its
batch; without it, refusing to close would manufacture precisely the dead
flagged code that check exists to prevent.

## Language

Every document this skill produces carries an **English skeleton** and prose in
the project's language. The boundary runs *inside* each document, not between
documents.

- **Skeleton, always English:** section titles, field names (`Spec:`,
  `Batch:`, `Sections:`, `Rulings log`, `Observed drift`), template labels,
  front matter values, table headers, path and branch patterns.
- **Prose, in the project's language:** the body of the requirements, the
  descriptions, the justifications, and the slugs of files and directories —
  they name business objects.
- The English headings `superpowers:writing-plans` imposes on a plan —
  `Global Constraints`, `Files`, `Interfaces` — are that same rule already at
  work, not an exception you tolerate.

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll write the whole batch delta now, it's more efficient" | Reviewers would flag the next stories' behaviour as missing. One slice per story. |
| "The spec is wrong, I'll fix it while I'm here" | Only your human partner corrects a spec. Stop and say so. |
| "No merge conflict, so no one else is on this section" | Git conflicts on lines, not sections. Check the open pull requests. |
| "No open pull request touches this spec, so the section is free" | A story holds its sections from Step 1 until its pull request opens at the end of Step 5. Read the pushed `story/*` branches too. |
| "I'll push the branch when the work is done" | Then this story is invisible to every sibling for the whole implementation. Push right after the spec-slice commit. |
| "The story is abandoned, the branch can stay" | A pushed `story/*` branch with no pull request reads as a live claim on its sections. Delete it, locally and on the remote. |
| "I'm already in a worktree, that's fine" | Then this story's code lands on the previous story's branch. Return to the main checkout. |
| "Merging locally is quicker" | It never pushes. It merges into the local `main`, deletes the worktree and the branch, and takes the unrecorded rulings with it. |
| "I'll transcribe the spec at the end, with the code" | Then the norm is not prior to the code and the freeze has no starting point. The slice ships as commit one. |
| "Keeping the branch is harmless" | Without a pull request the story has no observable state and is never delivered. |
| "Inline execution is simpler for a small story" | It keeps no ledger, so the rulings never reach your human partner. SDD is required. |
| "I'll copy the rulings after the merge" | The workspace is already gone and the merge may be days later, in another session. |
| "This drift is small, I'll just add it to the gaps register" | Every story adding to the same section collides there. Record it under Observed drift; closing consolidates. |
| "The flag is an implementation detail, the spec need not mention it" | Then the spec is false for users. The slice states the flag, its default, and its lifting condition if the scope is extended. |
| "The batch says otherwise, and the batch is more recent" | The spec wins, without deliberation. Implement the spec, record a Ruling, continue. |
