---
name: using-batches
description: Use when working in a project whose CLAUDE.md says specs and plans are overridden - routes design and execution through living module specs, batches and user stories instead of dated design docs
---

# Using Batches

This project replaces dated design docs and one-off plans with a **living spec per module** and **batches of user stories** that grow those specs. Invoke this skill before any design work, and again before executing any plan — its rules bite at both moments, and a plan executed without them lands code that no spec describes.

**Announce at start:** "I'm using the using-batches skill to route this work."

**Start by invoking `supercharlouze:following-the-rules`, unless this session already has.** It carries the model, the git model and the authority rules everything below relies on.

**Route by situation:**

| Situation | Go to |
|---|---|
| A module this work touches has no spec in `docs/specs/` | `supercharlouze:adopting-a-module`, in a context of its own — the design stops, and resumes in a fresh context once that pull request merges |
| Architectural work on adopted modules | `supercharlouze:writing-a-batch` |
| Drift found, or a module's gaps register holds unreserved **Violations** — the code contradicts the spec | `supercharlouze:writing-a-batch`, as a corrective batch — never straight to the code |
| A module's gaps register holds unreserved **Gaps** — something real that no spec describes | `supercharlouze:writing-a-batch`, as an ordinary batch that finally specifies them |
| A batch is open and its next story must be written | `supercharlouze:writing-a-user-story` |
| A batch must change its scope, its spec delta, its technical design, its constraints or its flag, or a corrective batch must be requalified | `supercharlouze:writing-a-batch` |
| Every story of a batch is merged or abandoned | `supercharlouze:closing-a-batch` |
| Your human partner wants an ADR written, rewritten or deleted outside the adoption of a module, the opening of a batch, its amendment, the delivery review of a story and the installation | A bounded change, under `What Is Kept, What Is Rerouted` below |
| Spike or bounded work | Nothing is rerouted except what `What Is Kept, What Is Rerouted` states below |

## What Is Kept, What Is Rerouted

The spike / bounded / architectural classification of `superpowers:brainstorming` is **kept as it is** — it is orthogonal to this model, and it is good. Only the tail of the architectural path is diverted.

**Spike** — unchanged. An answer, no artifact.

**Bounded** — ceremony unchanged, except for the reading of `docs/adr/` stated below, with these rules:

- **(a) Its pull request leaves the spec silent if and only if nothing observable at the module's boundary changes.** Whether it *alters* a behaviour some spec already describes or *adds* one no spec describes, it updates the spec in the same pull request as the code. Handling only the "alters" case would reopen the same hole one notch over. Where nothing observable at that boundary changes — a dependency bump, an internal rename, a preparatory refactor — the spec stays silent. That silence is not a tolerance: a rule does not move when a mechanism moves, so there is nothing to write, and writing something anyway means inventing a sentence from the code, which canonises the drift it describes. When it updates a spec, invoke `supercharlouze:writing-in-a-spec` before writing in it.
- **(b) It undergoes the same concurrency detection as a story**, and therefore declares in the body of its pull request **the spec it targets and the sections it touches**, `none` when it touches none — otherwise it would hit a story in flight through a back door. The spec is named because nothing else in the declaration says which document those section titles belong to, and a bounded change that updates no spec file leaves a reader nothing to infer it from; two identically titled sections in two different specs are not a conflict. And `none` is a declaration, not a blank: it is what a bounded change that changes nothing observable has to say, where a blank body is indistinguishable from one nobody filled in — which is an unknown, and an unknown stops the reader. Invoke `supercharlouze:detecting-concurrency` before creating `bounded/<slug>`, and give it that spec and those sections. Stop if it returns a conflict or a declaration it could not read: report what it returned, and let your human partner sequence the two pieces of work or decide on the unread declaration.

  **A declaration that changes before the pull request opens redoes the detection:** invoke it again, and give it `bounded/<slug>` as well. The detection answered about the sections declared when it ran, so a section added afterwards was never intersected against anything — not found free, simply never looked at. Redoing it costs one scan, and the opening is the last point where the widening is still cheap to undo.

- **(c) It carries no feature flag.** A bounded change is complete in its own pull request, so it satisfies the exemption criterion by construction.
- **(d) It writes to a gaps register directly.** Belonging to no batch, it may both add an entry and delete one in `docs/specs/<module>.gaps.md`, from its own pull request, contending only with another bounded change. Invoke `supercharlouze:writing-in-a-gaps-register` before writing in it.
- **(e) It may write, rewrite and delete ADRs, and may carry nothing but ADRs.** Invoke `supercharlouze:recording-a-decision` to write or rewrite one. Delete yourself the one your human partner abandons, and correct yourself, on their decision, a text whose decision does not change.
- **(f) It holds the ADRs `main` carries when its branch starts.** Once `bounded/<slug>` is created, reread `docs/adr/` and hold what you find there: the design read it where you stood, and the branch starts from `main` as the remote carries it. When you cannot hold an ADR, put it to your human partner: if they rule it untenable, rewrite or delete it under rule (e); otherwise hold it.
- **(g) It puts to your human partner the technical decision it takes that meets the conditions of an ADR `supercharlouze:following-the-rules` states.** That holds for a decision taken along the way as for one taken at design. If they want it as an ADR, write it under rule (e).

No batch, no user story: a bounded change is already a single pull request, and whether it carries a spec update is what rule (a) decides. Its branch is `bounded/<slug>`: invoke `supercharlouze:starting-a-branch` and give it the name `bounded/<slug>`.

**Architectural** — **steps 6 to 9** of the architectural checklist (dated design doc, self-review, human review, transition to writing-plans) are replaced by `supercharlouze:writing-a-batch`, which stops the design outright when a module it touches has no spec. That is Override 1 below. Steps 1 to 5 — context, questions, approaches, design presented section by section, approval — are **kept intact**, except for the reading of `docs/adr/` stated below: that is the design work itself.

**The design reads `docs/adr/`.** On the bounded path and on the architectural path, read every ADR in `docs/adr/` before proposing an approach, and put to your human partner each technical decision the design takes that meets the conditions of an ADR `supercharlouze:following-the-rules` states. An approach that breaks an ADR is one the code may not take, and only your human partner decides an ADR. On the architectural path, `supercharlouze:writing-a-batch` writes, rewrites or deletes at the opening the ADRs they decide.

## Declared Overrides

superpowers states several of its rules as closed. An implicit exception to a rule marked "and only these" will not survive a session under pressure, so each one is **named as an override**, here and in the CLAUDE.md block, with its justification. There are four of them, and there must never be an undeclared **fifth**. If you find yourself wanting one, stop and take it to the human: an undeclared override is indistinguishable from an agent quietly ignoring superpowers.

The CLAUDE.md block opens on a fifth clause — *"it relocates specs and plans"* — and that one is **not** an override, which is why the count still reads four. `superpowers:writing-plans` grants the plan location as an explicit concession, *"(User preferences for plan location override this default)"*, so relocating them overrides no closed rule; and the spec location needs no concession at all, because Override 1 replaces the step that would have written a dated design doc, leaving nothing to relocate.

The CLAUDE.md block is not reproduced in this skill. It lives in exactly one place, `skills/using-batches/references/claude-md-block.md`, and the init command inserts it into a project; a second copy would drift from the first.

### Override 1 — steps 6 to 9 of the architectural checklist

The architectural checklist of `superpowers:brainstorming` ends with four steps: **6.** write the dated design doc, **7.** self-review, **8.** human review of the written spec, **9.** transition to writing-plans. The skill locks the ninth — *"Architectural: the ONLY skill you invoke after brainstorming is writing-plans"*, doubled by *"Do NOT invoke any other skill. writing-plans is the next step"*.

**This override replaces all four, not only the last.** Rerouting step 9 alone would let steps 6 to 8 run, and a dated design doc would still be written into `docs/superpowers/specs/` — exactly what this plugin exists to remove. It is one override, correctly bounded, not two: the substitution covers a coherent terminal block.

**The substitute stops rather than chaining.** When a module the work touches has no spec, `supercharlouze:writing-a-batch` does not run `supercharlouze:adopting-a-module` and come back: **the design stops**, your human partner abandons it or sets it aside, and it resumes in a fresh context once the adoption pull request is merged. That skill's `Preconditions` carry the full rule and the reason it rests on — **adoption is never conducted in the same context as a design**. Said here because a post-brainstorming path that ends anywhere other than `supercharlouze:writing-a-batch` is exactly what an unnamed exception looks like, and this one ends nowhere at all — it stops. It widens nothing: the override still covers steps 6 to 9 and nothing else, and the resumed design re-enters the checklist at the same step.

Justification: `supercharlouze:writing-a-batch` is not an implementation skill — the category step 9's rule protects — but a substitute for the documentary step that precedes writing-plans, which is still called, from `supercharlouze:writing-a-user-story`. And the substitution preserves every replaced step: step 6 becomes the batch document, step 7 its reread before opening, and **step 8 becomes the review of the batch pull request**. The human review is not removed; it changes tool.

### Override 2 — the stop conditions the flow adds

`superpowers:subagent-driven-development` states *"Four things stop you, and only these"*. This plugin adds the stop conditions `supercharlouze:following-the-rules` writes in full: one for corrective batches only, one for a technical story only, and one for a story only if its batch declares constraints or `main` carries an ADR when its branch starts.

Justification: the four native conditions assume a valid authority exists, assume the story is the story it says it is, and know nothing of the stories beside it. A corrective batch puts the authority in question; a technical story puts its own qualification in question — "purely technical" is otherwise the door through which behaviour enters with no gate behind it, since a story that transcribes no block passes no opening review; a constraint is what the other stories of its batch rely on, so a story that cannot hold one cannot settle it alone; and an ADR is a decision your human partner took, so only they judge it untenable.

When the corrective or the technical condition fires, you stop, and `supercharlouze:writing-a-batch` conducts the requalification: under `Requalifying a Corrective Batch` for the corrective one, under `Requalifying a Technical Story` for the technical one.

When the condition on a constraint or an ADR fires, your human partner rules on the constraint or the ADR.

If they rule a constraint untenable, the story is abandoned and `supercharlouze:writing-a-batch` amends the constraint, under `Amending a Batch`.

If they rule an ADR untenable, the story is abandoned and a bounded change rewrites or deletes the ADR.

Otherwise the story resumes and holds the constraint or the ADR.

### Override 3 — imposed execution mode

`superpowers:writing-plans` ends by offering the human a choice between subagent-driven-development and executing-plans. This plugin imposes SDD as the execution mode, and does not present the choice.

Justification: repatriating the rulings depends on SDD's ledger. `superpowers:executing-plans` keeps none, so the trace of every arbitration made during the story would be lost — and those arbitrations are the only record of where the spec was ambiguous.

### Override 4 — finishing-a-development-branch is constrained to the pull request

`superpowers:finishing-a-development-branch` presents three options — merge locally, open a pull request, keep the branch — and waits for a human choice. On the story path this plugin constrains the choice to **"Push and create a Pull Request"**.

Justification, stated exactly, because the other two options are not equivalent.

**"Merge back locally" is actively destructive.** It merges into the **local** `main`, runs the tests, then **deletes the worktree and the branch**. It never pushes, so nothing fails at the time: the work ends up in a local commit that can never reach the remote, and the branch that would have carried a pull request no longer exists. Repatriating the rulings never happens either, since that is done on the branch before the merge.

**"Keep the branch as-is" is not destructive** and stays compatible with a protected `main` — it is simply outside the flow: without a pull request the story has no observable state and will never be delivered. It is ruled out for that reason, not because it breaks anything.

This override removes one choice that cannot succeed, and one that leads nowhere.

**Deliberately not an override:** SDD's terminal state. Nothing is interposed between SDD and `superpowers:finishing-a-development-branch` — what is constrained is what the latter offers, which is Override 4 and nothing else. The reuse of an existing worktree by `superpowers:using-git-worktrees` is not one either: it is the documented behaviour of its Step 0.

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll transcribe the whole spec delta now, it's more efficient" | One spec change per story. A full delta makes the spec describe behaviour nobody delivered yet, and SDD's reviewers will report it as missing. |
| "Only writing-plans may follow brainstorming, so I must write the design doc" | Override 1 is declared: steps 6 to 9 are replaced by `supercharlouze:writing-a-batch`. A dated design doc is precisely what this plugin removes. |
| "This batch is refactor-only, the Feature flag field can stay empty" | The field is never empty. "none" plus its reason is a decision the opening gate reviews; a blank is an omission nobody can review. |
| "The flag is still there but the batch is done, I'll clean it up later" | A flag surviving without a declared scope and lifting condition is the classic silent failure. Write the lifting story, declare extended scope by amendment, or write a teardown story. |
| "A local merge is quicker than opening a pull request" | It deletes the worktree and the branch after merging into a `main` that can never be pushed. The work and the un-repatriated rulings go with them. |
| "This case needs one more exception to a superpowers rule" | There is no undeclared fifth override. Stop and take it to the human. |
| "The module has no spec but the change is small, I'll just code it" | Without an adopted spec there is no authority to review against, and the change becomes drift the moment it merges. The design stops until the module is adopted. |
| "The module has no spec, I'll adopt it now and carry on designing" | Adoption is never conducted in the same context as a design. Stop, and resume in a fresh context once the adoption merges. |
| "This is a small fix, the spec can stay silent about it" | Only if nothing observable at the module's boundary changes. The moment behaviour moves, the spec is updated in the same pull request, and either way the change declares the spec it targets and the sections it touches. |
