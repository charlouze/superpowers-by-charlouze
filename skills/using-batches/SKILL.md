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
| Architectural work on adopted modules | `supercharlouze:opening-a-batch` |
| Drift found, or a module's gaps register holds unreserved **Violations** — the code contradicts the spec | `supercharlouze:opening-a-batch`, as a corrective batch — never straight to the code |
| A module's gaps register holds unreserved **Gaps** — something real that no spec describes | `supercharlouze:opening-a-batch`, as an ordinary batch that finally specifies them |
| A batch is open and its next story must be written | `supercharlouze:delivering-a-story` |
| A story has stopped on a stop condition this flow adds | `supercharlouze:handling-a-stopped-story` |
| A batch must change its scope, its spec delta, its technical design, its constraints or its flag | `supercharlouze:amending-a-batch` |
| Every story of a batch is merged or abandoned | `supercharlouze:closing-a-batch` |
| Your human partner wants an ADR written, rewritten or deleted outside the adoption of a module, the opening of a batch, its amendment, the delivery review of a story and the installation | `supercharlouze:making-a-bounded-change` |
| Your human partner judges that a spec is wrong and the code is right | `supercharlouze:making-a-bounded-change` |
| Bounded work | `supercharlouze:making-a-bounded-change` |
| Spike | Nothing is rerouted |

## What Is Kept, What Is Rerouted

The spike / bounded / architectural classification of `superpowers:brainstorming` is **kept as it is** — it is orthogonal to this model, and it is good. Only the tail of the architectural path is diverted.

**Spike** — unchanged. An answer, no artifact.

**Bounded** — ceremony unchanged, except for the reading of `docs/adr/` stated below. `supercharlouze:making-a-bounded-change` carries the rules its pull request holds.

**Architectural** — **steps 6 to 9** of the architectural checklist (dated design doc, self-review, human review, transition to writing-plans) are replaced by `supercharlouze:opening-a-batch`, which stops the design outright when a module it touches has no spec. That is Override 1 below. Steps 1 to 5 — context, questions, approaches, design presented section by section, approval — are **kept intact**, except for the reading of `docs/adr/` stated below: that is the design work itself.

**The design reads `docs/adr/`.** On the bounded path and on the architectural path, read every ADR in `docs/adr/` before proposing an approach, and put to your human partner each technical decision the design takes that meets the conditions of an ADR `supercharlouze:following-the-rules` states. An approach that breaks an ADR is one the code may not take, and only your human partner decides an ADR. On the architectural path, `supercharlouze:opening-a-batch` writes, rewrites or deletes at the opening the ADRs they decide.

## Declared Overrides

superpowers states several of its rules as closed. An implicit exception to a rule marked "and only these" will not survive a session under pressure, so each one is **named as an override**, here and in the CLAUDE.md block, and written in full, with its justification, here or in the skill this section names. There are four of them, and there must never be an undeclared **fifth**. If you find yourself wanting one, stop and take it to the human: an undeclared override is indistinguishable from an agent quietly ignoring superpowers.

The CLAUDE.md block opens on a fifth clause — *"it relocates specs and plans"* — and that one is **not** an override, which is why the count still reads four. `superpowers:writing-plans` grants the plan location as an explicit concession, *"(User preferences for plan location override this default)"*, so relocating them overrides no closed rule; and the spec location needs no concession at all, because Override 1 replaces the step that would have written a dated design doc, leaving nothing to relocate.

The CLAUDE.md block is not reproduced in this skill. It lives in exactly one place, `skills/using-batches/references/claude-md-block.md`, and the init command inserts it into a project; a second copy would drift from the first.

### Override 1 — steps 6 to 9 of the architectural checklist

The architectural checklist of `superpowers:brainstorming` ends with four steps: **6.** write the dated design doc, **7.** self-review, **8.** human review of the written spec, **9.** transition to writing-plans. The skill locks the ninth — *"Architectural: the ONLY skill you invoke after brainstorming is writing-plans"*, doubled by *"Do NOT invoke any other skill. writing-plans is the next step"*.

**This override replaces all four, not only the last.** Rerouting step 9 alone would let steps 6 to 8 run, and a dated design doc would still be written into `docs/superpowers/specs/` — exactly what this plugin exists to remove. It is one override, correctly bounded, not two: the substitution covers a coherent terminal block.

**The substitute stops rather than chaining.** When a module the work touches has no spec, `supercharlouze:opening-a-batch` does not run `supercharlouze:adopting-a-module` and come back: **the design stops**, your human partner abandons it or sets it aside, and it resumes in a fresh context once the adoption pull request is merged. That skill's `Preconditions` carry the full rule and the reason it rests on — **adoption is never conducted in the same context as a design**. Said here because a post-brainstorming path that ends anywhere other than `supercharlouze:opening-a-batch` is exactly what an unnamed exception looks like, and this one ends nowhere at all — it stops. It widens nothing: the override still covers steps 6 to 9 and nothing else, and the resumed design re-enters the checklist at the same step.

Justification: `supercharlouze:opening-a-batch` is not an implementation skill — the category step 9's rule protects — but a substitute for the documentary step that precedes writing-plans, which is still called, from `supercharlouze:delivering-a-story`. And the substitution preserves every replaced step: step 6 becomes the batch document, step 7 its reread before opening, and **step 8 becomes the review of the batch pull request**. The human review is not removed; it changes tool.

### Override 2 — the stop conditions the flow adds

`superpowers:subagent-driven-development` states *"Four things stop you, and only these"*. This plugin adds the stop conditions `supercharlouze:following-the-rules` writes in full: one for corrective batches only, one for a technical story only, and one for a story only if its batch declares constraints or `main` carries an ADR when its branch starts. `supercharlouze:delivering-a-story` writes this override in full.

When one of them fires, you stop, and `supercharlouze:handling-a-stopped-story` conducts what follows.

### Override 3 — imposed execution mode

`superpowers:writing-plans` ends by offering the human a choice between subagent-driven-development and executing-plans. This plugin imposes SDD as the execution mode, and does not present the choice. `supercharlouze:delivering-a-story` writes this override in full.

### Override 4 — finishing-a-development-branch is constrained to the pull request

`superpowers:finishing-a-development-branch` presents three options — merge locally, open a pull request, keep the branch — and waits for a human choice. On the story path this plugin constrains the choice to **"Push and create a Pull Request"**. `supercharlouze:delivering-a-story` writes this override in full.

**Deliberately not an override:** the reuse of an existing worktree by `superpowers:using-git-worktrees`, which is the documented behaviour of its Step 0.

## Red Flags

| Thought | Reality |
|---------|---------|
| "Only writing-plans may follow brainstorming, so I must write the design doc" | Override 1 is declared: steps 6 to 9 are replaced by `supercharlouze:opening-a-batch`. A dated design doc is precisely what this plugin removes. |
| "This batch is refactor-only, the Feature flag field can stay empty" | The field is never empty. "none" plus its reason is a decision the opening gate reviews; a blank is an omission nobody can review. |
| "The flag is still there but the batch is done, I'll clean it up later" | A flag surviving without a declared scope and lifting condition is the classic silent failure. Write the lifting story, declare extended scope by amendment, or write a teardown story. |
| "This case needs one more exception to a superpowers rule" | There is no undeclared fifth override. Stop and take it to the human. |
| "The module has no spec but the change is small, I'll just code it" | Without an adopted spec there is no authority to review against, and the change becomes drift the moment it merges. The design stops until the module is adopted. |
| "The module has no spec, I'll adopt it now and carry on designing" | Adoption is never conducted in the same context as a design. Stop, and resume in a fresh context once the adoption merges. |
