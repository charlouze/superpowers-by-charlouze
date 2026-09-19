---
name: using-batches
description: Use when working in a project whose CLAUDE.md says specs and plans are overridden - routes design and execution through living module specs, batches and user stories instead of dated design docs
---

# Using Batches

This project replaces dated design docs and one-off plans with a **living spec per module** and **batches of user stories** that grow those specs. Invoke this skill before any design work, and again before executing any plan — its rules bite at both moments, and a plan executed without them lands code that no spec describes.

**Announce at start:** "I'm using the using-batches skill to route this work."

**Route by situation:**

| Situation | Go to |
|---|---|
| A module this work touches has no spec in `docs/specs/` | `supercharlouze:adopting-a-module` — blocking; nothing starts until its pull request merges |
| Architectural work on adopted modules | `supercharlouze:writing-a-batch` |
| Drift found, or a module's gaps register holds unreserved **Violations** — the code contradicts the spec | `supercharlouze:writing-a-batch`, as a corrective batch — never straight to the code |
| A module's gaps register holds unreserved **Gaps** — something real that no spec describes | `supercharlouze:writing-a-batch`, as an ordinary batch that finally specifies them |
| A batch is open and its next story must be written | `supercharlouze:writing-a-user-story` |
| A batch must change scope or flag, or a corrective batch must be requalified | `supercharlouze:writing-a-batch` |
| Every story of a batch is merged or abandoned | `supercharlouze:closing-a-batch` |
| Spike or bounded work | Nothing is rerouted except what `What Is Kept, What Is Rerouted` states below |

## The Model

**Module** — a coarse functional domain, seen from the outside. A human draws the boundaries; never infer them. Prefer few large modules to many small ones: three modules is a normal project, fifteen is a slicing error.

**Spec** — one living document per module, at `docs/specs/<module>.md`. It is **normative** (what the code must do), not descriptive (what the code happens to do), and it carries **business rules and intentions; the mechanism stays in the code** — see `What a Spec Says` below. It carries no date, no status, no work-in-progress marker. It is the binding authority of every review.

**Section** — the smallest titled unit of a spec, and the unit everything is counted in: a concurrency conflict is judged on a section, a gaps register entry names a section. "Requirement" is not used as a unit — its granularity cannot be defined, so it cannot be checked.

**Batch** — the delivery unit, at `docs/batches/NN-<slug>/`. It groups several user stories, and exists to add behaviour to one or more specs. A batch may cut across modules.

**User story** — an implementation plan at `docs/batches/NN-<slug>/NN-us-N-<slug>.md`. It belongs to exactly one batch and targets exactly **one** module, hence one spec. It is also the technical delivery unit: **one story, one branch, one pull request**.

**Corrective batch** — a batch whose spec delta is empty. It brings existing code back into conformance with a spec that is already true. Its scope is drawn from a module's gaps register, `docs/specs/<module>.gaps.md`.

**Feature flag** — what makes a story deliverable on its own without exposing a half-built batch. `main` is deployed continuously, so every merged story ships; a batch whose stories would expose incomplete behaviour declares a flag.

**The flag is a specified object, not an implementation detail.** The spec section concerned states its name and its default — *"behind the `billing.recurring` flag, off by default"*. Without that declaration, a story merged behind a flag would make the spec false as far as users are concerned, and would reopen through the window exactly the gap the drift rule exists to close.

**The flag is per (batch, module).** Not per story — the batch is the boundary past which nothing is incomplete. But not per batch either: a batch spanning two modules declares **two** flags, one per module. Otherwise its lifting story would have to remove the gating sentence from two specs, while a story targets exactly one module — it would be impossible to write.

**Its lifetime is short, and by default the batch bounds it.** A flag that lingers is dead code nobody dares remove — the classic failure mode, and it is silent. A flag may legitimately outlive its batch (a module built over several batches, opened only once complete), but then it declares **its scope and the condition that lifts it** — "lifted when the `facturation` module is fully delivered". That declaration is what tells a still-useful flag apart from a forgotten one; without it the two are identical.

**The exemption criterion is one question:** *would a single story of this batch, merged on its own, leave a user in front of something incomplete?* If no, no flag. Three families answer no by construction:

- **Refactor and infrastructure** — they change no behaviour, so every pull request is deployable as it stands. That is the definition of a refactor, not a tolerance granted to it.
- **Corrective batch** — it restores behaviour the spec already promises. Gating it would delay a conformance fix, which is the opposite of its purpose.
- **Single-story batch** — nothing is ever half delivered.

## What a Spec Says

A spec carries **business rules and intentions; the mechanism stays in the code**. This is a second content property, orthogonal to normative-not-descriptive: a perfectly normative spec can still impose a data store, a trigger or an adapter layer. The clauses below are inseparable — the first says what does not get in, the second says what you may not write in its place, the third is what keeps the first two from manufacturing vagueness.

**The other-implementation test.** The criterion is not a forbidden vocabulary but a question, asked of every sentence you are about to write:

> Would another developer, having implemented the same intention differently, read this sentence as true of their code?

Yes: it is a rule, it goes in. No: it is this implementation of it, and it stays in the code. The test restates equivalently as replaceability — *could this mechanism be replaced without making the spec false for anyone outside the module?* — and the first form is the one you apply: imagining a colleague is within anyone's reach, imagining an external observer is not.

The test bears on the module's boundary, never on words, and that is what makes it applicable everywhere. A module whose domain *is* infrastructure — a deployment pipeline, or this plugin — states branch names and `gh` calls as rules, because at its boundary they are observable and another implementer would read them as true of theirs. A forbidden vocabulary would make this plugin's own spec illegal; the test lets it be written.

Two corollaries. **A rule does not move when a mechanism moves:** if a purely technical change of mind forced you to rewrite the sentence, the sentence was describing the technique. **And a spec does not legislate on code quality:** a clumsy implementation that produces the promised behaviour is conformant. The spec says what must be true, never by which road nor with what elegance.

**You do not reword a mechanism into a rule.** The test says what goes out, not what replaces it, and that is where an agent invents. The intention behind a mechanism is not **deduced**: it comes from a validated document or from your human partner. An intention paraphrased from the code is reconstruction from the code by another road, and the rule that comes out has three defects no review catches easily — it is unverifiable from outside, it has the shape of the code rather than of the business, and it **canonises the drift**, since what it describes is the observed behaviour.

Four signs recognise it without knowing anything about the domain:

- the section has **the shape of the code** — one sentence per branch, one paragraph per technical module;
- it is **vague where the code is precise** — "a few minutes" is an erased number, not a prudent promise;
- it **names an internal actor** — what watches, what computes, what this module does not count;
- **nobody outside the module could tell whether it is held.**

The question that settles all four: *what does a user or a neighbouring module lose if this sentence is false?* If the answer is "nothing observable", it is not a rule — it is a gap, and it goes to the register.

**A business choice carries its number.** A duration, a step, a window, a ceiling, a guarantee delay are business decisions, and a business decision is written with its value: "a session lasts four hours", "extending pushes the closing back by one hour and is offered only in the last thirty minutes". If the value changes one day, the spec changes, and that is exactly what a living spec is for. **Vagueness is not prudence** — it is a rule no code can contradict, therefore a rule that serves nothing.

The other-implementation test is enough for the plain case: another implementer reads "a session lasts four hours" as true of their code, and does not recognise "the sweep runs every five minutes". It is not enough for the case that matters — a number inherited from a mechanism and then written as a guarantee has the shape of a promise and passes the test, since any implementation can hold it. It is false as a rule nonetheless, because nobody ever decided it. Hence the question that accompanies every number written into a spec:

> That one — where does it come from: a decision, or a reading of the code?

A number you cannot answer for is a gap, not a guarantee. Written as a guarantee, it turns a legitimate engineering decision into conformance debt, and the corrective batch that follows is regular — which is what makes it undetectable.

**The spec's structure follows the business.** A rule lives where the behaviour it constrains lives, not gathered into a section that groups rules by nature. A section called "the invariants", "the ports" or "what writes where" has the shape of the code's layers, and that shape alone betrays the origin of the text even when every sentence, taken on its own, would pass the test. It is the shape-of-the-code sign, stated constructively.

**Naming is not mechanising.** A glossary binding a business term to the name the code and the interface carry is a rule, not a leak: it states that this concept is called the same everywhere, which is exactly what lets a domain expert read the code and recognise their intentions in it. It passes the test — renaming the identifier without touching the glossary makes the spec false, since the spec promised the opposite. What a glossary need not carry are the names that are nobody's: a persistence type, an adapter class, a store document.

**Everything a spec contains is normative, at the same level.** A spec does not rank its rules: marking some as important implies the others bind less, and a rule that binds less does not bind. There are therefore no main rules, no recommendations and no best practices in a spec — what is not opposable does not go in. A project that wants a **non-normative aside** — an example, a precision tempering a neighbouring rule — declares the convention that makes it recognisable and holds to it; no markup is imposed, it is only required that an aside be distinguishable from a rule and that it never carry one.

**A module redefines what it borrows.** A spec reads on its own. A term a neighbouring module owns is redefined here, **reduced to what this module uses**, naming the spec that owns it. Referring to the definition next door looks cleaner and is not: the term's meaning then changes without this module knowing, and it finds out through a breakage. The reduced borrowing is not duplication but a **contract** — and the day it diverges from the original definition is exactly what you wanted to see.

**Scope.** These clauses bear on the spec file, **all of its lines**, including the changelog's `change` cell: this is a property of the document, so it holds for whoever writes in it. They do not bear on `docs/specs/<module>.gaps.md`, which is not a spec — a register entry names a mechanism, that is its job, and that is where everything the test ejects goes. Saying both is necessary: a rule with no declared outlet leaves an agent who has understood it with nowhere to write down what they found.

## The Git Model

Two project constraints, not choices of this plugin, and everything else follows from them:

- **`main` is protected** — everything goes through a pull request.
- **`main` is deployed continuously** — every merge ships to production.

The second is why feature flags exist, and it rules out the two natural alternatives. A batch branch, or a gitflow `develop` branch, would protect production by holding work back — at the price of a blind spot. Concurrency detection has exactly two sources, the open pull requests and the pushed `story/*` branches, and a story merged into a batch branch leaves **both at once**: its pull request closes, and its branch is gone with it. The sections it took are then held by nothing any sibling can see, for the whole life of the batch — and that is precisely the stretch during which the batch branch is supposed to be protecting things. A `develop` branch is worse: it creates **two baselines** for the drift rule — the reference spec on `develop`, the running code on `main` — and a corrective batch no longer knows what it is correcting against. A flag protects production without holding code back, so it creates neither blind spot nor second baseline.

**One branch, one name.** `main` is that protected, continuously deployed branch, and this plugin calls it `main` everywhere — deliberately not an abstract "integration branch". The abstraction is what invites the `develop`-style branch the paragraph above rejects by name.

**A story's pull request carries the spec slice and the code that implements it.** They ship together or not at all, in the same pull request. That is what gives `main` its central property: **its spec always describes exactly what its code does.** There is no intermediate state to signal, therefore no marker, no semantics to explain to agents that know nothing about this plugin, and no exception to the drift rule.

**The spec slice is the first commit of every story branch**, before the plan is written and before any task runs. Not for visibility — the file would be readable in the worktree uncommitted — but because that is what makes the norm *prior and opposable* to the code: it is already in the branch's history when implementation starts. A corrective story is the one exception in form and not in purpose: its spec delta is empty, so its first commit strikes the gaps register entry it resolves instead, which fixes its scope in the branch's history exactly the same way. Batch-opening and batch-closing branches carry no spec slice at all — they carry no code either.

**The drift rule therefore has no exception:** any divergence between the spec on `main` and the code on `main` is drift, hence corrective work. There is no "not delivered yet" case to exempt, because that case does not exist. Behaviour still gated states its flag, its default and — when the scope outlives the batch — its lifting condition in the spec itself, so the spec stays exactly true: it describes not only what the code does but what it exposes and under what condition.

**Human gates are pull request reviews.** The plugin adds no ceremony; it puts its checkpoints where your flow already has them.

| Gate | Artifact reviewed |
|---|---|
| Module adoption | the pull request carrying the spec and the gaps register |
| Batch opening | the pull request carrying the batch document |
| Story delivery | the pull request carrying the spec slice and the code |
| Batch closing | the pull request carrying the changelog, the consolidation and `status: closed` |
| Batch amendment | the pull request carrying the decision to change its scope or its flag |

**Preconditions for every pull request of this system**, checked before creating a branch: be in the **main checkout** (a session chaining two stories without leaving the worktree would stack the second story on the first story's branch), and be on `main`, freshly fetched (numbering and concurrency detection reason on the remote state). `gh` is assumed available and authenticated; without it both degrade to a partial safety net and stop preventing anything.

## Authority and Conflict Rules

**The spec is the binding authority.** The batch carries only what a spec cannot carry: delivery scope, story order, migration and compatibility constraints, and why this work happens now.

**When a batch and a spec contradict each other, the spec wins — no exception, no deliberation.** Implement what the spec says, record a `Ruling:`, and carry on. **Correcting a spec mid-batch is a human act, never an agent's.** An agent that "fixes" the spec silently inverts the authority: the batch's intent wins, and the document reviewers rely on becomes a record of what an agent preferred.

**The spec file is frozen, with a start and an end.** Between the transcription commit and the opening of the pull request, no task modifies the spec file; a story that discovers the spec must change stops. Once the pull request is open the freeze lifts — review requests are human decisions, including on the wording of the spec slice. A freeze without an end would make it literally impossible to answer a review, or to resolve a merge conflict on that file. The rule is copied into the `Global Constraints` of every plan, so it sits under the eyes of every implementer and every reviewer.

**Every conflict is recorded for the human.** Reuse the existing mechanism rather than inventing one: `superpowers:subagent-driven-development` keeps a ledger whose decisions take the form `Ruling: <decision> — <why> — <what it costs if it is wrong>`, presented under "Rulings I made" before it deletes its workspace. Copy those lines into the story document, on the story's branch, before the merge — they are perishable, and the workspace is already gone.

**Concurrency.** Two stories touching the same section of the same spec are a conflict. Detection is by declaration: each story document lists the sections it touches, and a starting story compares them against the open pull requests **and against every remote `story/*` branch that carries no pull request yet whose diff against `main` touches this story's spec file**. That filter is part of the rule, not an optimisation: without it the scan orders a read of every story branch in the repository, and stops on the first one whose declaration cannot be read — an arrest no conflict justifies. Both sources are needed: a story's pull request opens only at the very end of its implementation, so for that whole stretch its pushed branch is the only thing that shows it holds its sections. The git merge conflict is only a **partial** safety net — git conflicts on lines, not on sections, so two stories editing the same section far apart merge cleanly. Relying on it would let through exactly the case worth catching.

## What Is Kept, What Is Rerouted

The spike / bounded / architectural classification of `superpowers:brainstorming` is **kept as it is** — it is orthogonal to this model, and it is good. Only the tail of the architectural path is diverted.

**Spike** — unchanged. An answer, no artifact.

**Bounded** — ceremony unchanged, with four rules:

- **(a) Its pull request never leaves the spec silent.** Whether it *alters* a behaviour some spec already describes or *adds* one no spec describes, it updates the spec in the same pull request as the code, with an `out-of-batch` changelog line. Handling only the "alters" case would reopen the same hole one notch over.
- **(b) It undergoes the same concurrency detection as a story**, and therefore declares its sections in the body of its pull request — otherwise it would hit a story in flight through a back door. Run **Step 1 of `supercharlouze:writing-a-user-story`** before creating `fix/<slug>` — the same open pull requests and the same pushed `story/*` branches to scan, the same `gh` calls, the same `Sections:` declaration read wherever each pull request keeps it — and stop on the same conditions, including the one where a declaration cannot be read. Symmetrically, a bounded change's declaration is read in its pull request body, because that is where a bounded keeps it: it has no story document, and a reader that looked only for one would stop on every open bounded change and jam the nominal path for as long as one stays open.

  **A bounded change is in turn invisible until its own pull request opens, and that is accepted.** Its `fix/<slug>` branch declares nothing, since the sections live in the pull request body — so between its first commit and its pull request, nothing shows what it holds. The story path refused the same window and closed it by pushing the branch early; here it is not worth the same machinery, because a bounded change is one pull request with no long implementation phase behind it, where a story's window was as long as an implementation. Same blind spot, and the difference in size is the whole argument — so it is named as tolerated here, exactly as Step 1 names the story's, rather than left for someone to rediscover as a bug.

- **(c) It carries no feature flag.** A bounded change is complete in its own pull request, so it satisfies the exemption criterion by construction.
- **(d) It writes to a gaps register directly.** Belonging to no batch, it may both add an entry and strike one in `docs/specs/<module>.gaps.md`, from its own pull request, contending only with another bounded change. The batch path is stricter — stories only record what they observe, and only `supercharlouze:closing-a-batch` consolidates it — because that contention is per batch, not per pull request.

No batch, no user story: a bounded change is already a pull request, it simply carries its spec update. Its branch is `fix/<slug>`.

**Architectural** — **steps 6 to 9** of the architectural checklist (dated design doc, self-review, human review, transition to writing-plans) are replaced by `supercharlouze:writing-a-batch`, which may first require `supercharlouze:adopting-a-module` as a blocking precondition. That is Override 1 below. Steps 1 to 5 — context, questions, approaches, design presented section by section, approval — are **kept intact**: that is the design work itself, and it has no reason to change.

## Declared Overrides

superpowers states several of its rules as closed. An implicit exception to a rule marked "and only these" will not survive a session under pressure, so each one is **named as an override**, here and in the CLAUDE.md block, with its justification. There are four of them, and there must never be an undeclared **fifth**. If you find yourself wanting one, stop and take it to the human: an undeclared override is indistinguishable from an agent quietly ignoring superpowers.

The CLAUDE.md block opens on a fifth clause — *"it relocates specs and plans"* — and that one is **not** an override, which is why the count still reads four. `superpowers:writing-plans` grants the plan location as an explicit concession, *"(User preferences for plan location override this default)"*, so relocating them overrides no closed rule; and the spec location needs no concession at all, because Override 1 replaces the step that would have written a dated design doc, leaving nothing to relocate.

The CLAUDE.md block is not reproduced in this skill. It lives in exactly one place, `skills/using-batches/references/claude-md-block.md`, and the init command inserts it into a project; a second copy would drift from the first.

### Override 1 — steps 6 to 9 of the architectural checklist

The architectural checklist of `superpowers:brainstorming` ends with four steps: **6.** write the dated design doc, **7.** self-review, **8.** human review of the written spec, **9.** transition to writing-plans. The skill locks the ninth — *"Architectural: the ONLY skill you invoke after brainstorming is writing-plans"*, doubled by *"Do NOT invoke any other skill. writing-plans is the next step"*.

**This override replaces all four, not only the last.** Rerouting step 9 alone would let steps 6 to 8 run, and a dated design doc would still be written into `docs/superpowers/specs/` — exactly what this plugin exists to remove. It is one override, correctly bounded, not two: the substitution covers a coherent terminal block.

**The substitute may itself be blocked.** When a module the work touches has no spec, `supercharlouze:writing-a-batch` treats `supercharlouze:adopting-a-module` as a blocking precondition, so that skill runs first — named here rather than left implicit, because a second post-brainstorming skill under a rule stated as closed is exactly what an unnamed exception looks like. It widens nothing: the override still covers steps 6 to 9 and nothing else.

Justification: `supercharlouze:writing-a-batch` is not an implementation skill — the category step 9's rule protects — but a substitute for the documentary step that precedes writing-plans, which is still called, from `supercharlouze:writing-a-user-story`. And the substitution preserves every replaced step: step 6 becomes the batch document, step 7 its re-read before opening, and **step 8 becomes the review of the batch pull request**. The human review is not removed; it changes tool.

### Override 2 — fifth stop condition (corrective batches)

`superpowers:subagent-driven-development` states *"Four things stop you, and only these"*. This plugin adds one, for corrective batches only:

> If, while bringing code into conformance with a spec, you discover that it is the **spec** that is wrong and the code that is right, stop. The batch is no longer corrective and must be requalified.

Justification: the four conditions assume a valid authority exists. Here the authority itself is what is in question, and an agent may not correct a spec.

Requalification is carried by `supercharlouze:writing-a-batch`, and it **does not start by closing a pull request**: this condition fires *inside* `superpowers:subagent-driven-development`, mid-implementation, while a story's pull request opens only at the very end of Step 5 through `superpowers:finishing-a-development-branch` — so normally there is no pull request at all, only a branch and a worktree. Abandon the story, closing its pull request without merging only if one is already open, and once the choice below is ruled discard the branch **locally and on the remote**, with its worktree — a branch left on the remote is re-read as a live claim on its sections by every sibling's concurrency scan. Nothing has to be revoked either way, because nothing reached `main`. Then the human decides — either they correct the spec, which only they can do, and the batch stays corrective on a reduced scope; or the batch is rewritten as an ordinary batch, with a spec delta, through an **amendment pull request** on the existing document, which keeps `NN` and its directory and still passes the opening review — any story already merged lives under that number, and a new one would strand it. A fresh `NN` only if the human rules the remaining work a *different* batch, and this one is then closed rather than left open. Either way the gaps register reservations are revised.

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

## Language

The boundary does not run between documents; it runs **inside** each document: English skeleton, prose in the project's language.

- **The skeleton is English, everywhere** — section titles, field names, template labels, front matter values (`status: open | closed`), table headers, path and branch patterns, skill and command names. This holds for the plugin and for the documents it produces.
- **Prose is in the project's language** — requirement bodies, descriptions, justifications, and the file and directory slugs, which name business objects.
- **The plugin itself is entirely English** — skills, commands, README, CLAUDE.md block, messages. It has no business prose; it has only skeleton.

That is the superpowers feeling kept: a document of this system reads like a superpowers document, with content in the project's language. The English skeleton that `superpowers:writing-plans` imposes on a story is then no longer an exception you put up with — it is the general rule, already applied.

## Red Flags

| Thought | Reality |
|---------|---------|
| "The spec is wrong here, I'll fix it and move on" | Correcting a spec is a human act. Implement what the spec says, record the `Ruling:`, and carry on. |
| "The batch is newer than the spec, so the batch wins" | The spec is the binding authority, without exception and without deliberation. The batch carries scope and order, never behaviour that contradicts a spec. |
| "I'll transcribe the whole spec delta now, it's more efficient" | One slice per story. A full delta makes the spec describe behaviour nobody delivered yet, and SDD's reviewers will report it as missing. |
| "Only writing-plans may follow brainstorming, so I must write the design doc" | Override 1 is declared: steps 6 to 9 are replaced by `supercharlouze:writing-a-batch`. A dated design doc is precisely what this plugin removes. |
| "Git will conflict if two stories touch the same section" | Git conflicts on lines, not sections; two edits far apart in one section merge cleanly. Compare the declared `Sections:` fields against the open pull requests and against every remote `story/*` branch that carries no pull request yet and whose diff against `main` touches this spec file — the filter keeps the scan from reading, and stopping on, branches that hold nothing you want. |
| "This batch is refactor-only, the Feature flag field can stay empty" | The field is never empty. "none" plus its reason is a decision the opening gate reviews; a blank is an omission nobody can review. |
| "The flag is still there but the batch is done, I'll clean it up later" | A flag surviving without a declared scope and lifting condition is the classic silent failure. Write the lifting story, declare extended scope by amendment, or write a teardown story. |
| "A local merge is quicker than opening a pull request" | It deletes the worktree and the branch after merging into a `main` that can never be pushed. The work and the un-repatriated rulings go with them. |
| "This case needs one more exception to a superpowers rule" | There is no undeclared fifth override. Stop and take it to the human. |
| "The module has no spec but the change is small, I'll just code it" | Adoption is a blocking precondition: without an adopted spec there is no authority to review against, and the change becomes drift the moment it merges. |
| "I'm already in the previous story's worktree, I'll start the next one here" | Preconditions first: main checkout, `main` refreshed. Otherwise the new story's code lands on the previous story's branch. |
| "This is a small fix, the spec can stay silent about it" | A bounded change updates the spec in the same pull request, with an `out-of-batch` changelog line, and declares its sections. |
| "The delta names a mechanism — I'll reword it into a business rule" | That is the laundering this rule exists to stop: what you would write describes the observed behaviour, so it canonises the drift. The spec wins, record a `Ruling:` for the clause you left out, and carry on. |
| "I can't say where this number came from, I'll write 'a few minutes'" | Vagueness is not prudence — it is a rule no code can contradict. A number you cannot answer for is a gap, not a guarantee. |
