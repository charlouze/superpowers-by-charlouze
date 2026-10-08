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

## What a Spec Says

A spec carries **business rules and intentions; the mechanism stays in the code**. This is a second content property, orthogonal to normative-not-descriptive: a perfectly normative spec can still impose a data store, a trigger or an adapter layer. The clauses below are inseparable — the first says what does not get in, the second says what you may not write in its place, the third is what keeps the first two from manufacturing vagueness.

**The other-implementation test.** The criterion is not a forbidden vocabulary but a question, asked of every sentence you are about to write:

> Would another developer, having implemented the same intention differently, read this sentence as true of their code?

Yes: it is a rule, it goes in. No: it is this implementation of it, and it stays in the code. The test restates equivalently as replaceability — *could this mechanism be replaced without making the spec false for anyone outside the module?* — and the first form is the one you apply: imagining a colleague is within anyone's reach, imagining an external observer is not.

The test bears on the module's boundary, never on words, and that is what makes it applicable everywhere. A module whose domain *is* infrastructure — a deployment pipeline, or this plugin — states branch names and pull requests as rules, because at its boundary they are observable and another implementer would read them as true of theirs. A forbidden vocabulary would make this plugin's own spec illegal; the test lets it be written.

Two corollaries. **A rule does not move when a mechanism moves:** if a purely technical change of mind forced you to rewrite the sentence, the sentence was describing the technique. **And a spec does not legislate on code quality:** a clumsy implementation that produces the promised behaviour is conformant. The spec says what must be true, never by which road nor with what elegance.

**You do not reword a mechanism into a rule.** The test says what goes out, not what replaces it, and that is where an agent invents. The intention behind a mechanism is not **deduced**: it comes from a validated document or from your human partner. An intention paraphrased from the code is reconstruction from the code by another road, and the rule that comes out has three defects no review catches easily — it is unverifiable from outside, it has the shape of the code rather than of the business, and it **canonises the drift**, since what it describes is the observed behaviour.

Four signs recognise it without knowing anything about the domain:

- the section has **the shape of the code** — one sentence per branch, one paragraph per technical module;
- it is **vague where the code is precise** — "a few minutes" is an erased number, not a prudent promise;
- it **names an internal actor** — what watches, what computes, what this module does not count;
- **nobody outside the module could tell whether it is held.**

The question that settles all four: *what does a user or a neighbouring module lose if this sentence is false?* If the answer is "nothing observable", it is not a rule — it is a gap, and it goes to the register. Exception: a sentence that states a technical decision has an ADR for outlet, under the conditions `supercharlouze:following-the-rules` states.

**A business choice carries its number.** A duration, a step, a window, a ceiling, a guarantee delay are business decisions, and a business decision is written with its value: "a session lasts four hours", "extending pushes the closing back by one hour and is offered only in the last thirty minutes". If the value changes one day, the spec changes, and that is exactly what a living spec is for. **Vagueness is not prudence** — it is a rule no code can contradict, therefore a rule that serves nothing.

The other-implementation test is enough for the plain case: another implementer reads "a session lasts four hours" as true of their code, and does not recognise "the sweep runs every five minutes". It is not enough for the case that matters — a number inherited from a mechanism and then written as a guarantee has the shape of a promise and passes the test, since any implementation can hold it. It is false as a rule nonetheless, because nobody ever decided it. Hence the question that accompanies every number written into a spec:

> That one — where does it come from: a decision, or a reading of the code?

A number you cannot answer for is a gap, not a guarantee. Written as a guarantee, it turns a legitimate engineering decision into conformance debt, and the corrective batch that follows is regular — which is what makes it undetectable.

**The spec's structure follows the business.** A rule lives where the behaviour it constrains lives. What is banned is a section that reproduces the code's internal decomposition — "the ports", "the adapters", "what writes where" — or that files rules by their nature rather than by what they constrain — "the invariants", "the constraints". That shape alone betrays the origin of the text even when every sentence, taken on its own, would pass the test; it is the shape-of-the-code sign, stated constructively. A section carrying a concept observable at the module's boundary — a naming convention, an authority rule — follows the business, even when that concept holds for several behaviours. Without that last sentence the clause would outlaw this plugin's own spec, whose `Authority and conflict rules` and `Language` gather rules several workflows share.

**Naming is not mechanising.** A glossary binding a business term to the name the code and the interface carry is a rule, not a leak: it states that this concept is called the same everywhere, which is exactly what lets a domain expert read the code and recognise their intentions in it. It passes the test — renaming the identifier without touching the glossary makes the spec false, since the spec promised the opposite. What a glossary need not carry are the names that are nobody's: a persistence type, an adapter class, a store document.

**Everything a spec contains is normative, at the same level.** A spec does not rank its rules: marking some as important implies the others bind less, and a rule that binds less does not bind. There are therefore no main rules, no recommendations and no best practices in a spec — what is not opposable does not go in. A project that wants a **non-normative aside** — an example, a precision tempering a neighbouring rule — declares the convention that makes it recognisable and holds to it; no markup is imposed, it is only required that an aside be distinguishable from a rule and that it never carry one.

**A module redefines what it borrows.** A spec reads on its own. A term a neighbouring module owns is redefined here, **reduced to what this module uses**, naming the spec that owns it. Referring to the definition next door looks cleaner and is not: the term's meaning then changes without this module knowing, and it finds out through a breakage. The reduced borrowing is not duplication but a **contract** — and the day it diverges from the original definition is exactly what you wanted to see.

**A rule belongs to exactly one spec.** A rule that would constrain behaviour
observable at the boundary of more than one module is not a rule looking for a
home — it is a module breakdown asking to be revisited, and a breakdown is a
human decision. Stop and put the case to your human partner, rather than copying
the rule from one spec into another or giving it a home above them both. The
reduced borrowing of a term — a term a neighbouring module owns, redefined here
and reduced to what this module uses — is not concerned: it redefines a term, it
does not share a rule.

There is no spec above the specs, and that is the point. A rule housed outside
the module specs — in a CLAUDE.md, in an architecture note — sits beyond
everything that makes a spec binding: the review held against it, the drift rule,
the gaps register. It would read as a norm and be none. A technical decision
that no module boundary makes observable is not a rule: its outlet is an ADR.

**Scope.** These clauses bear on the spec file, **all of its lines**: this is a property of the document, so it holds for whoever writes in it. They do not bear on `docs/specs/<module>.gaps.md`, which is not a spec — a register entry names a mechanism, that is its job, and that is where what the test ejects goes, except a technical decision, which has an ADR for outlet. Saying both is necessary: a rule with no declared outlet leaves an agent who has understood it with nowhere to write down what they found.

## What Is Kept, What Is Rerouted

The spike / bounded / architectural classification of `superpowers:brainstorming` is **kept as it is** — it is orthogonal to this model, and it is good. Only the tail of the architectural path is diverted.

**Spike** — unchanged. An answer, no artifact.

**Bounded** — ceremony unchanged, except for the reading of `docs/adr/` stated below, with these rules:

- **(a) Its pull request leaves the spec silent if and only if nothing observable at the module's boundary changes.** Whether it *alters* a behaviour some spec already describes or *adds* one no spec describes, it updates the spec in the same pull request as the code. Handling only the "alters" case would reopen the same hole one notch over. Where nothing observable at that boundary changes — a dependency bump, an internal rename, a preparatory refactor — the spec stays silent. That silence is not a tolerance: a rule does not move when a mechanism moves, so there is nothing to write, and writing something anyway means inventing a sentence from the code, which canonises the drift it describes.
- **(b) It undergoes the same concurrency detection as a story**, and therefore declares in the body of its pull request **the spec it targets and the sections it touches**, `none` when it touches none — otherwise it would hit a story in flight through a back door. The spec is named because nothing else in the declaration says which document those section titles belong to, and a bounded change that updates no spec file leaves a reader nothing to infer it from; two identically titled sections in two different specs are not a conflict. And `none` is a declaration, not a blank: it is what a bounded change that changes nothing observable has to say, where a blank body is indistinguishable from one nobody filled in — which is an unknown, and an unknown stops the reader. Run **Step 1 of `supercharlouze:writing-a-user-story`** before creating `bounded/<slug>` — the same open pull requests and the same pushed `story/*` and `bounded/*` branches to scan, the same `gh` calls, the same declaration read wherever each pull request keeps it — and stop on the same conditions, including the one where a declaration cannot be read. Symmetrically, a bounded change's declaration is read in its pull request body, because that is where a bounded keeps it: it has no story document, and a reader that looked only for one would stop on every open bounded change and jam the nominal path for as long as one stays open.

  **A declaration that changes before the pull request opens redoes the detection.** Step 1 answered about the sections declared when it ran, so a section added afterwards was never intersected against anything — not found free, simply never looked at. Redoing it costs one scan, and the opening is the last point where the widening is still cheap to undo.

  Before its pull request opens, a bounded change's branch carries no declaration, since the declaration lives in the pull request body. Once pushed, it is read like any branch that has not declared yet, by the sections it has already changed. Unpushed, it is invisible, like any branch the remote does not carry.

- **(c) It carries no feature flag.** A bounded change is complete in its own pull request, so it satisfies the exemption criterion by construction.
- **(d) It writes to a gaps register directly.** Belonging to no batch, it may both add an entry and delete one in `docs/specs/<module>.gaps.md`, from its own pull request, contending only with another bounded change.

  An entry is one list item, added at the end of its category.

  When it deletes one, the commit that removes it says why.

  A finding already deleted from the register is re-entered only if the entry says what has changed since. Read the file's history before adding an entry (`git log -p docs/specs/<module>.gaps.md`): what was set aside was set aside for a reason, written in the commit that removed it.

  What qualifies an entry lives in the entry: no prose qualifies a *group* of them, and what an entry's neighbours have in common is repeated in each of them.

  An entry designates no other entry: a settled entry leaves the file whole, and takes with it anything that pointed at it.

  Within a batch, only the closing pull request adds entries to the gaps register: stories record their findings in their own document, and `supercharlouze:closing-a-batch` consolidates them.

- **(e) It may write, rewrite and delete ADRs, and may carry nothing but ADRs.** Invoke `supercharlouze:recording-a-decision` to write or rewrite one. Delete yourself the one your human partner abandons, and correct yourself, on their decision, a text whose decision does not change.
- **(f) It holds the ADRs `main` carries when its branch starts.** Once `bounded/<slug>` is created, reread `docs/adr/` and hold what you find there: the design read it where you stood, and the branch starts from `main` as the remote carries it. When you cannot hold an ADR, put it to your human partner: if they rule it untenable, rewrite or delete it under rule (e); otherwise hold it.
- **(g) It puts to your human partner the technical decision it takes that meets the conditions of an ADR `supercharlouze:following-the-rules` states.** That holds for a decision taken along the way as for one taken at design. If they want it as an ADR, write it under rule (e).

No batch, no user story: a bounded change is already a single pull request, and whether it carries a spec update is what rule (a) decides. Its branch is `bounded/<slug>`.

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
| "The delta names a mechanism — I'll reword it into a business rule" | That is the laundering this rule exists to stop: what you would write describes the observed behaviour, so it canonises the drift. The spec wins, record a `Ruling:` for the clause you left out, and carry on. |
| "I can't say where this number came from, I'll write 'a few minutes'" | Vagueness is not prudence — it is a rule no code can contradict. A number you cannot answer for is a gap, not a guarantee. |
| "This rule holds for every module, so it lives above them all" | There is no spec above the specs. A rule belongs to exactly one spec; a rule that seems to belong to several signals a module breakdown to revisit, and that is your human partner's decision. A technical decision with nothing observable at a module's boundary is no rule at all: its outlet is an ADR. |
