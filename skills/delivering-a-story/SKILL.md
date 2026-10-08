---
name: delivering-a-story
description: Use when writing the next user story of an open batch - transcribes the spec change, then hands off to superpowers:writing-plans and subagent-driven-development
---

# Delivering a Story

## Overview

A story is the unit of technical delivery: **one story, one branch, one pull
request** — and that pull request never carries its spec change without the code
that implements it. The reverse is legitimate: a story that transcribes no block
may carry code alone, as a corrective batch's story does. That is what gives
`main` its central property: **its spec always describes exactly what its
code does.** No intermediate state to signal, no marker, no exception to the
drift rule.

**Announce at start:** "I'm using the delivering-a-story skill to deliver this
story."

**Start by invoking `supercharlouze:following-the-rules`, unless this session already has.**

This skill runs the whole cycle in one place — preconditions, concurrency
detection, branch, spec change, plan, execution, records, review — because the
pull request carries the story's state. There is nothing to repatriate
afterwards and nothing to reconcile.

Stories are written **one at a time**, each knowing the stories of its batch
already written. Several may be *in flight* simultaneously — that is the
normal regime of a pull-request flow, not an edge case.

**Each story chooses, as it is written, the blocks of the spec delta it
transcribes**, and transcribes them entirely: a block is never shared between two
stories. Nothing attached them in advance — the batch document carries blocks and
no list of stories — so the choice is made here, and the `Blocks:` field of
Step 4 is what records it.

A story targets exactly **one** module, therefore exactly one spec. If the work
spans two modules, it is two stories.

## Preconditions

Check all of these before creating anything. They apply to every pull request
of this system, not only to stories.

- **`gh` is available and authenticated.** Number allocation and concurrency
  detection both query it. Without it, both degrade to a partial net —
  collision visible when the pull request opens, merge conflict — and they no
  longer *prevent* anything. Say so rather than proceeding silently.
- **The batch exists and is open.** Its opening pull request is merged and its
  document says `status: open`. Until that gate is passed, no story is written.

## Step 1 — Detect Concurrency

Decide which sections this story will touch, then invoke
`supercharlouze:detecting-concurrency` and give it the story's spec and those
sections.

**Stop if it returns a conflict or a declaration it could not read.** Report
what it returned, and let your human partner sequence the two pieces of work or
decide on the unread declaration.

## Step 2 — Allocate us-N and Create the Branch

Allocate `us-N` as `skills/delivering-a-story/references/allocating-us-n.md`
says: it fetches, then reads `main`, the open pull requests and the pushed
`story/*` branches.

Branch name, enforced by this plugin and not by superpowers:

| Object | Branch |
|---|---|
| Story | `story/NN-us-N-<slug>` |

`NN` is the batch number, `us-N` the story number, and the slug follows the
project's language — it names a business object.

Invoke `supercharlouze:starting-a-branch` and give it the name
`story/NN-us-N-<slug>`.

The story document lives at `docs/batches/NN-<slug>/NN-us-N-<slug>.md`. The
`NN-` prefix keeps basenames unique across batches. On the nominal path it is
comfort: each story runs in its own worktree. On degraded paths — worktree
declined, isolation unavailable — two stories share a checkout, SDD derives its
workspace from the plan's **basename**, and two `us-1-setup.md` would share one
ledger.

## Step 3 — Commit the Spec Change First

Transcribe into `docs/specs/<module>.md` the blocks of the batch's spec delta
that **this** story takes, and commit them as the **first commit on the
branch** — before the plan is written, before any task runs. **A lifting story
transcribes a removal:** its block deletes the gating sentence from the spec
instead of adding behaviour, and that deletion is this same first commit (see
Lifting and Teardown Stories below).

Three properties are load-bearing.

**Word for word.** The text of the blocks `Blocks:` declares, exactly as the
opening review read it, and never the batch's whole delta. Rewording it would put into
the spec a sentence no gate ever ruled on, and would make the opening review a
review of something else. Transcribing the whole delta is the other failure: the
spec would describe, while story 1 is still executing, the behaviour of the
stories that follow — and the SDD reviewers would flag as missing what is not yet
meant to be delivered.

A block shown as a `diff` fence is transcribed as the paragraph it produces: its
unchanged lines and its added lines, without their prefix.

**First.** Not for visibility — the file would be readable in the worktree even
uncommitted — but because this is what makes the norm **prior and binding** on
the code. It is already in the branch's history when implementation starts, it
travels in the pull request, and the freeze of Step 4 gets an identifiable
starting point.

**Named in the pull request.** Every divergence from a block is named in the body
of the pull request Step 5 opens, and ruled on at the delivery review.

When `main` moved under a block, fit the block to what `main` now carries, without
changing its meaning, and say in the pull request what you fitted and why. `main`
moved when the paragraph a block changes no longer reads in `main` as the block
shows it, because another story or a bounded change landed on that section since
the batch opened.

When the block's text is a problem, stop and put it to your human partner before
transcribing it. Do not transcribe a text you believe is wrong, and do not repair
it on your own: the opening gate is where that text was ruled on, and reopening it
is your human partner's act.

**Neither case amends the batch document.** It records what the opening review
read, and editing it would erase the very text a reviewer compares your
transcription against. The divergence lives in the pull request, where it is
visible and gets ruled on.

If the batch declares a feature flag for this story's module, the transcribed spec
change states the flag and its default in a gating sentence, in the form
`supercharlouze:following-the-rules` fixes.

The code you write next is guarded by that flag. Without this sentence a story
merged behind a flag would make the spec false as users read it, and would
reopen through the window exactly the gap the living spec exists to close. The
sentence disappears in the lifting story, and that is a spec change like any
other.

**What the spec change may contain.** Invoke `supercharlouze:writing-in-a-spec`
before transcribing a block, and apply what it carries to every sentence you
write. The delta was written by a human at
the opening gate, but transcribing it is still writing, and a delta that names a
mechanism is transcribed as the rule that mechanism served **only if a validated
document or your human partner states that rule**. You do not deduce it: an
intention paraphrased from the code is reconstruction from the code, and it
canonises the very drift it describes. A delta clause you cannot transcribe is
a conflict between the batch and the spec, and the authority rule above settles
it: the spec wins, you record a `Ruling:` naming the clause you left out and
why, and you carry on. That ruling reaches your human partner through the story
document (Step 6) and is read at the delivery gate. Only where the ejected
clause describes behaviour the code already has does it *also* belong under
**Observed drift**, from where `supercharlouze:closing-a-batch` files it into
the gaps register — a mechanism prescribed but not yet built is neither a
violation nor a gap, and the register has nowhere to put it.

**A rule belongs to exactly one spec.** One case looks like that conflict and is
not: a block whose rule would constrain behaviour observable at the boundary of
more than one module. The authority rule cannot settle it, because no ruling puts
a rule in two places, and transcribing it into this spec alone would leave the
neighbouring module bound by something its own spec never says. Nor is the
ordinary way out open, because a clause ejected and ruled on leaves the block's
intent unreviewed while the breakdown it revealed stays hidden. Stop and put it
to your human partner: what is in question is the breakdown, and a breakdown is
their decision.

**A story that transcribes no block** still has this first commit, and it still
fixes the scope in the branch's history before any code exists. It carries the
header of the story document and its empty `Rulings log` and `Observed drift`
sections — Step 4 then writes the plan into that document rather than creating it
— together with what this particular story removes, if it removes anything.

A technical story removes nothing, and its first commit carries that header
alone. A corrective batch's story removes an entry: it deletes the gaps register
entry it resolves from `docs/specs/<module>.gaps.md`. Invoke
`supercharlouze:writing-in-a-gaps-register` before deleting it. Removing an
entry takes out lines nobody else is writing, so two stories removing different
entries do not collide. A teardown story removes from the spec what no block
announced, and that removal is this same commit.

**Push the branch as soon as this commit exists** — `git push -u origin
story/NN-us-N-<slug>`. Nothing depends on it for this story; it is what makes
this story *visible*, since a sibling's concurrency scan reads pushed `story/*`
branches and the pull request does not exist for a long while yet. Pushing here
rather than at the end shrinks the blind spot of that scan from the length of
an implementation to the length of a single commit.

## Step 4 — Write the Plan

Call `superpowers:writing-plans`. The plan **is** the story document: save it
into the batch directory, and extend the standard header with the fields below.

```markdown
**Spec:** docs/specs/facturation.md
**Batch:** docs/batches/07-facturation-recurrente/README.md
**Sections:** Subscription > Renewal, Subscription > Proration
**Blocks:** D3, D7
```

`Spec:` is the field `subagent-driven-development` already reads as the binding
authority — pointing it at the living module spec is what makes this
integration work without modifying superpowers. `Sections:` is what the *next*
story's concurrency scan reads.

`Blocks:` declares the blocks of the spec delta this story transcribes — the
`D<n>` identifiers the batch document defines — and it is what
`supercharlouze:closing-a-batch` reads to find the blocks nobody delivered. It is
`none` for a story that transcribes none, such as a corrective batch's story, a
technical story or a teardown story. Write it even though the blocks are already committed by
now, because Step 3's commit says what the spec received, and this field says
which blocks this story answered for — which is the question closing asks.

**A technical story carries `Technical: yes` in its header**, and touches no
section: its `Sections:` is `none`. No other story carries that field — an
absent field is the ordinary case, so nothing has to be written to say "not
technical", and the qualification is visible wherever it is claimed.

```markdown
**Spec:** docs/specs/facturation.md
**Batch:** docs/batches/07-facturation-recurrente/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes
```

The qualification is yours to declare and nobody else's to check at this point:
what catches a false one is the stop condition, in `Global Constraints` below,
and it fires during the implementation rather than here.

Then create, at the end of the document, the two sections Step 6 fills — empty
now, and left empty if nothing turns up:

```markdown
## Rulings log

## Observed drift
```

Write them at the same time as the header, never at Step 6. An empty section says
*checked, nothing found*; a missing section says *never examined*, and a reviewer
cannot tell the second from an omission. A story that transcribed no block wrote
both at Step 3, with the header: they are already there, and this step writes the
plan into the document between them.

**An open ruling is written `Open ruling:`** where the others are written
`Ruling:`, and its line ends with what is left to settle, then with the gaps
register category that takes it when it joins one. An open ruling is a ruling
whose decision leaves something to settle; written in the common form, nothing
says that something is still open, nor what — and whoever reads the log would
have to recognise a category in prose.

**The plan starts from the batch's `Technical design`**, and its `Architecture:`
line derives from it. Exceptions: where an ADR contradicts the design, the plan
follows the ADR; elsewhere, where the code on `main` has departed from the
design, as an earlier story of the batch may have, the plan starts from the code.

Read every ADR in `docs/adr/`, in this story's worktree, before writing the plan:
the worktree carries the ADRs `main` carried when the branch started, which are
the ones this story's code holds.

A batch whose `Technical design` is `none` gives the plan nothing to start from.

`Global Constraints` — which `superpowers:writing-plans` defines as implicitly
part of every task's requirements — carries:

- the constraints the batch imposes;
- the freeze of the spec file;
- the authority rule;
- the concision rules;
- **in a corrective batch only**, the stop condition proper to a corrective
  batch;
- **in a story that writes code guarded by a flag only**, the rules for code
  under a flag;
- **in a technical story only**, the stop condition proper to a technical
  story;
- **only if the batch declares constraints or `docs/adr/` carries an ADR**, the
  stop condition on a constraint or an ADR that cannot be held;
- **only if `docs/adr/` carries an ADR**, the paths of the ADRs this story's code
  holds;
- the conditions of an ADR, with the obligation to record as an `Open ruling:`
  the decision that meets them.

The batch's constraints are its `Constraints` section copied verbatim. The
freeze of the spec file reads:

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

The freeze exists because the spec file now travels in the same branch as the
code, so SDD's tasks can physically edit it — which was not true when it lived
elsewhere. Putting it in `Global Constraints` puts it in front of every
implementer and every reviewer.

The freeze has a bound: the **freeze is lifted when the pull request opens**.
Review requests are human decisions, including on the wording of the spec
change, and they apply on the story's branch (Step 7). An unbounded freeze would
make it literally impossible to answer a review — or to resolve a merge
conflict on the spec file.

**When the batch and the spec contradict each other, the spec wins — without
exception and without deliberation.** Implement what the spec says, record a
`Ruling:`, and carry on. **Correcting a spec mid-batch is a human act, never an
agent's.** That rule is the authority rule `Global Constraints` carries.

In every story, `Global Constraints` carries the concision rules, written out in
full. Copy the block below verbatim:

> These rules hold for every document, pull request body and commit message
> this story writes.
>
> Every sentence says one exact thing, once, and stands on its own.
>
> Every paragraph carries one rule.
>
> A rule says how far it holds, and an exception presents itself as one.
>
> A text says what it delivers or decides, without telling how it got there or
> why. Exception: a reason that is explicitly asked for, such as the why of a
> ruling.
>
> No sentence is set in relief: no bold that ranks one sentence above its
> neighbours.

**In a corrective batch, `Global Constraints` carries the stop condition proper
to a corrective batch, written out in full.** Copy it verbatim,
exactly as `supercharlouze:following-the-rules` states it:

> If, while bringing code into conformance with a spec, you discover that it is the **spec** that is wrong and the code that is right, stop. The batch is no longer corrective and must be requalified.

The freeze above already stops a task that finds the spec must change, but it
stops it and says nothing more. The consequence — that the batch has lost the
qualification it was opened under — is what makes this a requalification rather
than a question to ask and move on from. And the discovery happens inside SDD's
implementer subagents, whose only channel to this skill's rules is this list: a
stop condition stated to you and not written here never reaches the agent who
has to obey it.

**In a story that writes code guarded by a feature flag, `Global Constraints`
carries the rules for code under a flag, written out in full.**
This holds whether the flag was declared by this story's batch or by another one:
what decides is that this story writes guarded code, not which batch owns the
flag. Copy the block below verbatim, exactly as `supercharlouze:following-the-rules` states it:

> Code guarded by a feature flag holds up when the flag is on for some users
> only, on for everyone, and off:
>
> - The two states work on the same data: what one produces, the other reads
>   and uses, with no error and no data loss.
> - With the flag off, the user finds the behaviour from before the batch.
> - The story's pull request tests the flag-on behaviour, the flag-off
>   behaviour, and their coexistence.
> - Lifting the flag comes down to deleting the branching and the behaviour
>   from before the batch, without writing anything new.

Copying this block is what puts those rules in front of the implementer — a norm
nobody reads while writing the code bites on nothing. They travel the way the
freeze does, through the only channel SDD's subagents read.

**In a technical story, `Global Constraints` carries the stop condition proper to
a technical story, written out in full.** Copy it verbatim,
exactly as `supercharlouze:following-the-rules` states it:

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

The freeze above stops a task that finds the spec must change, and it is not this.
A technical story was written on the claim that nothing needed changing at all, so
nobody is looking at the spec when the claim fails: what fails is the
qualification the story carries, and losing it sends the work back to the opening
gate rather than forward. And the discovery happens inside SDD's implementer
subagents, whose only channel to this skill's rules is this list — a stop
condition stated to you and not written here never reaches the agent who has to
obey it.

**In a story whose batch declares constraints, or whose `docs/adr/` carries an
ADR, `Global Constraints` carries the stop condition on a constraint or an ADR
that cannot be held, written out in full.** A batch declares constraints when its
`Constraints` section is not `none`. `docs/adr/` carries an ADR when a `.md` file
is placed directly in it, in this story's worktree. Copy the block below
verbatim, exactly as `supercharlouze:following-the-rules` states it:

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

A constraint is a decision another story of the batch relies on, and an ADR is a
decision your human partner took for all the code to come, so an implementer who
works around either breaks something they cannot see.

**When `docs/adr/` carries an ADR, `Global Constraints` lists the path of each
one, under the sentence below.** Copy it verbatim:

> The code this story writes holds these ADRs.

An implementer reads only this list, so an ADR whose path is missing from it
binds nobody.

**In every story, `Global Constraints` carries the conditions of an ADR, written
out in full, with the obligation to record the decision that meets them.** Copy
the block below verbatim. Its conditions are those `supercharlouze:following-the-rules`
states:

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

Only your human partner decides an ADR, so an implementer who takes such a
decision reports it and leaves the file to the review.

**Commit the story document — header, the two empty sections and
`Global Constraints` together — and push it immediately**, `git push`, before
anything else in Step 5 starts. Before this push, a sibling's concurrency scan
reads this branch only by the sections it has already changed; after it, by
every section this story will touch.

## Step 5 — Execute

Three of this plugin's four declared overrides bite here. All three are named,
each carries its reason, and none is a matter of judgment in the moment.

**Override 3 — the execution mode is imposed.** `superpowers:writing-plans`
ends by offering a choice between subagent-driven development and
`superpowers:executing-plans`. Do not present that choice: this plugin requires
`superpowers:subagent-driven-development`. Reason: repatriating the rulings
depends on SDD's ledger; `superpowers:executing-plans` keeps none, and the
trace of every arbitration made on your human partner's behalf would be lost —
and those arbitrations are the only record of where the spec was ambiguous.

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

**Deliberately not an override:** SDD's terminal state. Nothing is interposed
between SDD and `superpowers:finishing-a-development-branch` — what is
constrained is what the latter offers, which is Override 4 and nothing else.

**Override 2 — the stop conditions the flow adds.** SDD states that four things
stop you and only these. This plugin adds its own. **When one of them fires,
stop: `supercharlouze:handling-a-stopped-story` conducts what follows.**

In a corrective batch: if, while bringing code into conformity with the spec, you
discover that the **spec** is wrong and the code is right, stop. The batch is no
longer corrective and must be requalified. An agent may not correct a spec.

In a technical story, whatever its batch: if, while conducting it, you discover
that it changes something observable at the module's boundary, stop. The story is
no longer technical. Only your human partner may rule what follows: a block for
the observable change, and the flag that block requires, if it requires one.

In a story whose batch declares constraints or whose `docs/adr/` carries an ADR:
if, while conducting it, you discover that a constraint of its batch or an ADR
cannot be held, stop and put it to your human partner. A constraint the spec
contradicts is not this case, since the spec wins.

Justification: the four native conditions assume a valid authority exists,
assume the story is the story it says it is, and know nothing of the stories
beside it. A corrective batch puts the authority in question; a technical story
puts its own qualification in question — "purely technical" is otherwise the
door through which behaviour enters with no gate behind it, since a story that
transcribes no block passes no opening review; a constraint is what the other
stories of its batch rely on, so a story that cannot hold one cannot settle it
alone; and an ADR is a decision your human partner took, so only they judge it
untenable.

It is named as an override for the same reason as the other three: an unnamed
exception to a rule superpowers states as closed does not survive a session
under pressure. It reaches the implementers through `Global Constraints`
(Step 4), which is the only channel they read.

No task writes in `docs/adr/`. The ADR a decision of this story deserves is
written at the review (Step 7), once your human partner wants it.

## Step 6 — Record Before the Merge

Before the pull request is merged, and in the session where these facts still
exist:

- Copy every `Ruling:` line from SDD's closing "Rulings I made" message into
  the **Rulings log** of the story document. The list is exhaustive.
- Write as a `Technical design ruling:`, with the three parts of a `Ruling:`,
  every departure from the batch's `Technical design` that the plan or the
  execution took, except where the plan follows an ADR or the code on `main`.
  The design was approved at the opening gate, and a departure nobody recorded
  reaches the delivery review as a surprise.
- Write as an `Open ruling:` every technical decision the plan or the execution
  took that meets the conditions of an ADR, its line ending with whether your
  human partner wants it as an ADR.
- Record under **Observed drift** the drift you noticed *outside* this story's
  scope: code that contradicts the spec, and behaviour no spec describes.

Do not add those observations to the gaps register yourself: `supercharlouze:closing-a-batch` consolidates them there.

Commit both on the branch and push, so they merge with it.

**This information is perishable.** SDD's workspace is already deleted, and the
merge may happen days later in another session. A ruling that dies with the
workspace was a decision made in secret.

## Step 7 — Answer the Review

The review of the story's pull request is the delivery gate — a human gate, in
the tool where you already review everything else.

Apply the **review feedback** on the story's branch, including on the wording
of the spec change: the freeze ended when the pull request opened, precisely so
that this is possible. `superpowers:finishing-a-development-branch` preserved
the worktree on this path, so iterate there. Read the feedback with
`superpowers:receiving-code-review` rigour — verify before you agree.

The story is delivered when its pull request is merged. There is nothing to
tick and nothing to reconcile: its state *is* the state of its pull request.

**A story does not merge leaving an open ruling without a destination.** Read the
`Rulings log` at the review and take every `Open ruling:` line it carries. One
that is a violation or a gap already has its destination: the gaps register, where
`supercharlouze:closing-a-batch` files it alongside the `Observed drift` sections.
Every other one is settled here, before the merge, and the `Rulings log` records
what was settled.

The review is the last place where an open ruling can still be acted on. By
closing, the story is merged and its branch is gone: closing can note that a
ruling was never taken up, it can no longer take it up. Your human partner has
the rulings in front of them here, and nowhere later.

**Your human partner settles an open ruling on a decision that meets the
conditions of an ADR.** If they want the ADR, invoke
`supercharlouze:recording-a-decision` and commit the file it writes in a commit
of its own.

If nothing is written, record in the `Rulings log` what they ruled.

A correction of the ADR's text asked for afterwards, which does not change its
decision, is a `fixup!` of that commit.

**To end the review, invoke `supercharlouze:finishing-a-pr` and give it this
condition: no `Open ruling:` without a destination stands in the `Rulings log`.**

Give it this next step: the next story, conducted by
`supercharlouze:delivering-a-story` from the batch document, with a prompt
that says to choose from the blocks no merged story has declared.

If this story took the batch's last undelivered blocks, give it
`supercharlouze:closing-a-batch` instead, from the same document.

The clear that follows the merge matters here: the conversation carries a plan,
an SDD ledger and every file the implementers touched, while `main` now carries
this story's code, and its spec change if it had one, which is all the next
story needs. Everything perishable is already in the story document — that is
what `Step 6 — Record Before the Merge` was for.

**To abandon a story, invoke `supercharlouze:abandoning-a-story` and give it the
story's branch.** What remains on `main` belongs to
`supercharlouze:closing-a-batch`: the blocks the batch announced and no story
delivered, and the gaps register reservation posted by the batch's opening pull
request, unless an amendment took its entry out of `Scope` and released it. Do
not count them — a story that transcribed no block announced nothing in the spec
delta and leaves the reservation alone.

## Lifting and Teardown Stories

Both are ordinary stories — code plus a spec change, in one pull request —
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
under construction. It is not for the current batch to guess: a batch that
lifts a flag declared by another one says so in its `Spec delta`, and your human
partner validates it at the opening gate like the rest of that delta.

It is a story and not a closing chore because it carries code, and code
deserves a review and a test cycle. An observation period is two stories: the
first moves the declared default of the gating sentence from `off` to `on`, the
second deletes the branching and the gating sentence. The model supports that
without changing anything.

**The declared default and the effective state are two different things.** The
spec declares a default; switching the flag on for some users, or off again, is
a move the project makes, and it changes nothing about what the spec declares.
Only a story changes the declared default — so a flag switched on everywhere is
not a flag that has been lifted, and its gating sentence still stands in the
spec for `supercharlouze:closing-a-batch` to find.

**The teardown story** is the other way out. When a batch's scope is abandoned
while guarded stories are already merged, a teardown story removes the guarded
code and the corresponding spec change. It is one of the three exits
`supercharlouze:closing-a-batch` offers when a flag would otherwise survive its
batch; without it, refusing to close would manufacture precisely the dead
flagged code that check exists to prevent.

## Language

Every document this skill produces carries an **English skeleton** and prose in
the project's language. The boundary runs *inside* each document, not between
documents.

- **Skeleton, always English:** section titles, field names (`Spec:`,
  `Batch:`, `Sections:`, `Blocks:`, `Technical:`, `Rulings log`, `Observed drift`),
  template labels, front matter values, table headers, path and branch patterns.
- **Prose, in the project's language:** the body of the requirements, the
  descriptions, the justifications, and the slugs of files and directories —
  they name business objects.
- The English headings `superpowers:writing-plans` imposes on a plan —
  `Global Constraints`, `Files`, `Interfaces` — are that same rule already at
  work, not an exception you tolerate.

Every text this skill writes follows `Concision` in `supercharlouze:following-the-rules`.

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll write the whole batch delta now, it's more efficient" | Reviewers would flag the next stories' behaviour as missing. One spec change per story. |
| "This block's wording is off, I'll improve it as I transcribe" | The opening gate ruled on that exact text. Transcribe it word for word, or stop and put the problem to your human partner. |
| "`main` moved, so I'll amend the batch document to match" | Fit the block to `main` without changing its meaning, and name the divergence in the pull request. The batch document records what the review read. |
| "The spec is wrong, I'll fix it while I'm here" | Only your human partner corrects a spec. Stop and say so. |
| "No open pull request uses us-3, so us-3 is free" | A branch claims its number from its first commit until its pull request opens at the end of Step 5. Read the pushed `story/*` branches too — same argument as the concurrency scan. |
| "I'll push the branch when the work is done" | Then this story is invisible to every sibling for the whole implementation. Push right after the spec-change commit. |
| "Merging locally is quicker" | It never pushes. It merges into the local `main`, deletes the worktree and the branch, and takes the unrecorded rulings with it. |
| "I'll transcribe the spec at the end, with the code" | Then the norm is not prior to the code and the freeze has no starting point. The spec change ships as commit one. |
| "Keeping the branch is harmless" | Without a pull request the story has no observable state and is never delivered. |
| "Inline execution is simpler for a small story" | It keeps no ledger, so the rulings never reach your human partner. SDD is required. |
| "I'll copy the rulings after the merge" | The workspace is already gone and the merge may be days later, in another session. |
| "This drift is small, I'll just add it to the gaps register" | Within a batch, only the closing pull request adds entries. Record it under Observed drift. |
| "Every ruling is recorded, the log is done" | An open ruling also needs a destination. A violation or a gap goes to the register through closing; anything else is settled at the review, before the merge. |
| "The flag is an implementation detail, the spec need not mention it" | Then the spec is false for users. The spec change states the flag, its default, and its lifting condition if the scope is extended. |
| "This story writes guarded code, but the flag is another batch's" | The rules for code under a flag go into `Global Constraints` all the same. What decides is that this story writes guarded code, not which batch owns the flag. |
| "The batch says otherwise, and the batch is more recent" | The spec wins, without deliberation. Implement the spec, record a Ruling, continue. |
| "The block's rule spills onto the next module — the spec wins, I record a Ruling" | No ruling puts a rule in two places. A rule belongs to exactly one spec, and a rule that reaches further signals the breakdown. Stop and put it to your human partner. |
| "My plan departs only slightly from the design, no ruling needed" | Every departure is a `Technical design ruling:`. One left out reaches the delivery review as a surprise. |
| "`main`'s code contradicts the design, so the design wins" | The design only guides. Where an ADR contradicts it, the plan follows the ADR; elsewhere, where `main`'s code departed from it, the plan starts from the code. |
| "This constraint, or this ADR, cannot be held, I'll work around it and record a ruling" | A ruling replaces no stop condition. Another story of the batch relies on that constraint, and your human partner decided that ADR: stop and put it to them. |
| "This decision deserves an ADR, I'll write it with the code" | No task writes in `docs/adr/`. Record an `Open ruling:`, and write the ADR at the review if your human partner wants it. |
