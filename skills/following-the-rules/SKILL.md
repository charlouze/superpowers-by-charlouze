---
name: following-the-rules
description: Use when a skill or a plan tells you to invoke following-the-rules - carries what holds at every moment of the flow, from the model and the git model to the rules whoever executes or reviews a task of a plan follows
user-invocable: false
---

# Following the Rules

These rules hold at every moment of the flow. Read them once per session, before the skill or the plan that sent you here.

## The Model

**Module** — a coarse functional domain, seen from the outside. A human draws the boundaries; never infer them. Prefer few large modules to many small ones; how many a project needs depends on the size of the product, not on a fixed count.

**Spec** — one living document per module, at `docs/specs/<module>.md`. It is **normative** (what the code must do), not descriptive (what the code happens to do), and it carries **business rules and intentions; the mechanism stays in the code**. It carries no date, no status, no work-in-progress marker, except a flag's gating sentence. It is the binding authority of every review.

**Section** — the smallest titled unit of a spec, and the unit everything is counted in: a concurrency conflict is judged on a section, a gaps register entry names a section. "Requirement" is not used as a unit — its granularity cannot be defined, so it cannot be checked.

**Batch** — the delivery unit, at `docs/batches/NN-<slug>/`. It groups several user stories, and targets one or more modules, hence one or more specs. A batch may cut across modules.

**User story** — an implementation plan at `docs/batches/NN-<slug>/NN-us-N-<slug>.md`. It belongs to exactly one batch and targets exactly **one** module, hence one spec. It is also the technical delivery unit: **one story, one branch, one pull request**.

**Technical story** — a story that changes nothing observable at its module's boundary. A dependency bump, an internal rename, a preparatory refactor are technical: no rule moves, so no block is transcribed. It is a declared qualification, caught by its stop condition if it turns out to be false.

**Technical design** — the mechanism a batch plans for its stories, each of which may depart from it. It lives in the batch document's `Technical design` field, and a story's plan starts from it: the spec binds a story, the technical design only guides it.

**Technical design ruling** — a ruling by which a story departs from its batch's technical design.

**ADR** — the document that records a technical decision of the project and its reason: a `.md` file placed directly in `docs/adr/`, at `docs/adr/<slug>.md`. An ADR this flow writes or rewrites carries no date and no status.

A technical decision is recorded as an ADR only if it meets these conditions:

- undoing it is expensive;
- it surprises whoever does not know its context;
- it settles between real alternatives.

**Your human partner decides every ADR.** An agent neither writes, rewrites nor deletes one unless they have decided it.

What is observable at a module's boundary is a rule of that module's spec, never an ADR.

An ADR contradicts no spec and no other ADR.

An ADR whose decision is replaced is rewritten in place, and one whose decision is abandoned is deleted.

The code of a story or of a bounded change holds the ADRs `main` carries when its branch starts.

No ADR binds the code already on `main`.

**Corrective batch** — a batch that brings existing code back into conformance with a spec that is already true. Its spec delta carries no block. Its scope is drawn from a module's gaps register, `docs/specs/<module>.gaps.md`.

**Delta block** — the unit of a batch's spec delta: one targeted section and the exact text it must receive, transcribed word for word by a story.

**Pull request** — a change proposed for `main`, which the human reviews before it reaches `main`.

**Gate** — the human's review of a pull request, whose merge moves a module, a batch or a story forward.

**Reread** — an agent's check of a piece of work. A reread is not a gate.

**Feature flag** — what makes a story deliverable on its own without exposing a half-built batch. Everything that reaches `main` may ship to production, so every merged story may reach users; a batch whose stories would expose incomplete behaviour declares a flag.

**The flag is a specified object, not an implementation detail.** The spec section concerned states its name and its default, as a gating sentence in one of these forms, which adds its lifting condition when the declared scope reaches beyond the batch:

```markdown
🔒 `billing.recurring`, off by default
🔒 `billing.recurring`, off by default — lifted when the `facturation` module is fully delivered
```

The flag's name, its default and its lifting condition vary; the rest of each form is fixed.

Without that declaration, a story merged behind a flag would make the spec false as far as users are concerned, and would reopen through the window exactly the gap the drift rule exists to close.

**The flag is per (batch, module).** Not per story — the batch is the boundary past which nothing is incomplete. But not per batch either: a batch spanning two modules declares **two** flags, one per module. Otherwise its lifting story would have to remove the gating sentence from two specs, while a story targets exactly one module — it would be impossible to write.

Each flag is switched on, switched off and lifted independently of the others: one flag's lifting story waits for no other flag's.

**Its lifetime is short, and by default the batch bounds it.** A flag that lingers is dead code nobody dares remove — the classic failure mode, and it is silent. A flag may legitimately outlive its batch (a module built over several batches, opened only once complete), but then it declares **its scope and the condition that lifts it** — "lifted when the `facturation` module is fully delivered". That declaration is what tells a still-useful flag apart from a forgotten one; without it the two are identical.

**The exemption criterion is one question:** *would a single story of this batch, merged on its own, leave a user in front of something incomplete?* If no, no flag. Three families answer no by construction:

- **A batch all of whose stories are technical** — none of them changes what is observable at its module's boundary, so every pull request is deployable as it stands. That is what the qualification means, not a tolerance granted to it.
- **Corrective batch** — it restores behaviour the spec already promises. Gating it would delay a conformance fix, which is the opposite of its purpose.
- **Single-story batch** — nothing is ever half delivered.

## The Git Model

Two project constraints, not choices of this plugin, and everything else follows from them:

- **`main` is protected** — everything goes through a pull request.
- **Everything that reaches `main` may ship to production**, whenever the project deploys.

The second is why feature flags exist, and it rules out the two natural alternatives. A batch branch, or a gitflow `develop` branch, would protect production by holding work back — at the price of a blind spot. Concurrency detection reads only the open pull requests and the pushed `story/*` and `bounded/*` branches, and a story merged into a batch branch leaves **both at once**: its pull request closes, and its branch is gone with it. The sections it took are then held by nothing any sibling can see, for the whole life of the batch — and that is precisely the stretch during which the batch branch is supposed to be protecting things. A `develop` branch is worse: it creates **two baselines** for the drift rule — the reference spec on `develop`, the running code on `main` — and a corrective batch no longer knows what it is correcting against. A flag protects production without holding code back, so it creates neither blind spot nor second baseline.

**One branch, one name.** `main` is that protected branch, whose every merge may ship, and this plugin calls it `main` everywhere — deliberately not an abstract "integration branch". The abstraction is what invites the `develop`-style branch the paragraph above rejects by name.

**A story's pull request never carries its spec change without the code that implements it.** It may carry code alone: a corrective batch's story does, and so may any story that transcribes no block. It may carry a spec change no block announced: a teardown story removes from the spec what no block announced. What never reaches `main` is a norm ahead of the code that honours it. That is what gives `main` its central property: **its spec always describes exactly what its code does.** There is no intermediate state to signal, therefore no marker, no semantics to explain to agents that know nothing about this plugin, and no exception to the drift rule.

**The spec change is the first commit of every story branch**, before the plan is written and before any task runs. Not for visibility — the file would be readable in the worktree uncommitted — but because that is what makes the norm *prior and opposable* to the code: it is already in the branch's history when implementation starts. A story that transcribes no block is the exception in form and not in purpose: no block dictates its first commit, so that commit carries the header of the story document and its empty `Rulings log` and `Observed drift` sections, plus what that story removes, if it removes anything — a corrective batch's story deletes the gaps register entry it resolves, a teardown story removes from the spec what no block announced, a technical story removes nothing — which fixes its scope in the branch's history exactly the same way. Batch-opening and batch-closing branches carry no spec change at all — they carry no code either.

**The drift rule therefore has no exception:** any code on `main` that contradicts the spec on `main`, and any behaviour on `main` that no spec describes, is drift, hence corrective work. There is no "not delivered yet" case to exempt, because that case does not exist. Behaviour still gated states its flag, its default and — when the scope outlives the batch — its lifting condition in the spec itself, so the spec stays exactly true: it describes not only what the code does but what it exposes and under what condition.

**The commit that rewrites or deletes an ADR says why.** The file keeps nothing of the decision it replaced, so the commit is where its reason stays readable.

**Human gates are pull request reviews.** The plugin adds no ceremony; it puts its checkpoints where your flow already has them.

| Gate | Artifact reviewed |
|---|---|
| Module adoption | the pull request carrying the spec and the gaps register, and the ADRs written with them |
| Batch opening | the pull request carrying the batch document, and the ADRs written, rewritten or deleted with it |
| Story delivery | the pull request carrying a story's code, its spec change if it has one, and the ADRs the review asks for |
| Batch closing | the pull request carrying the consolidation and `status: closed` |
| Batch amendment | the pull request carrying the decision to change its scope, its spec delta, its technical design, its constraints or its flag, and the ADRs written, rewritten or deleted with it |

**Preconditions for every pull request of this system**, checked before creating a branch: fetch, then start the branch from **`main` as the remote carries it**, never from another branch. That is what keeps a session chaining two pieces of work from stacking the second on the first one's branch, and what makes numbering and concurrency detection reason on the remote state. **Where you are standing does not matter**, and it must not: a session the harness launched inside a worktree cannot run git against the shared checkout at all, so a precondition on the directory would be unreachable exactly there. The starting point is reachable from anywhere — inside a reused workspace, `git fetch origin && git switch -c <branch> origin/main` satisfies it without leaving. `gh` is assumed available and authenticated; without it both degrade to a partial safety net and stop preventing anything.

**The agent never approves and never merges a pull request.** Approving and
merging are human acts, at every gate in the table above without exception.

**During a review the branch is not rewritten.** Each requested correction is
pushed as a `fixup!` commit of the commit it corrects, or as a commit of its own
when it carries a fresh decision, so that the human sees on the pull request what
changed since they last read it. **The human gives their agreement in the
conversation**, not through a GitHub approval. The agent then squashes the
`fixup!` commits into the commits they correct, pushes the rewritten branch, and
announces that the pull request is ready to be approved and merged.

Rewriting earlier would destroy what the review is reading. A force-push that
lands mid-review replaces the commits the human has comments on, and their
comments come back attached to nothing.

**Merging any review is a moment to clear the context.** The merged document then
carries everything that follows needs, and the conversation is only a draft that
can contradict it.

The agent cannot clear its own context. So when your human partner announces the
merge, the agent asks them to clear the context. Where a next step exists, it names
that step and gives, in a block to copy and paste, the prompt that starts it in a
fresh context.

**Abandoning a story after a stop condition is a moment to clear the context
too, when the ruling asks for a next step.** The agent asks its human partner to
clear the context, names that step and gives its prompt the same way, and that
prompt states the ruling: the story's branch is gone, and no document carries
what was ruled yet.

**Each of these prompts stands on its own:** it names the skill to invoke and
the document to start from, and never refers back to the conversation.

After a review, the prompt waits for the merge announcement, not for the
announcement that the pull request is ready. Between the two the review may go
on, and a prompt given earlier ends up buried under it, or names a document the
review has since changed.

"Never refers back to the conversation" is the whole point. A prompt saying
"continue what we discussed" is worthless after a clear, and it is worthless in a
way nobody notices until the context is already gone.

## Authority and Conflict Rules

**The spec is the binding authority.** Besides its spec delta, a batch carries only what a spec cannot carry: its scope, its flags, its constraints and its technical design.

**When a batch and a spec contradict each other, the spec wins — no exception, no deliberation.** Implement what the spec says, record a `Ruling:`, and carry on. **Correcting a spec mid-batch is a human act, never an agent's.** An agent that "fixes" the spec silently inverts the authority: the batch's intent wins, and the document reviewers rely on becomes a record of what an agent preferred.

**The spec file is frozen, with a start and an end.** Between the first commit of the branch and the opening of the pull request, no task modifies the spec file; a story that discovers the spec must change stops. Once the pull request is open the freeze lifts — review requests are human decisions, including on the wording of the spec change. A freeze without an end would make it literally impossible to answer a review, or to resolve a merge conflict on that file. The rule is copied into the `Global Constraints` of every plan, so it sits under the eyes of every implementer and every reviewer.

**Every conflict is recorded for the human.** Reuse the existing mechanism rather than inventing one: the execution of a plan by subagents keeps a ledger whose decisions take the form `Ruling: <decision> — <why> — <what it costs if it is wrong>`, presented under "Rulings I made" before it deletes its workspace. Copy those lines into the story document, on the story's branch, before the merge — they are perishable, and the workspace is already gone.

**Concurrency.** Two stories, or a story and a bounded change, touching the same section of the same spec are a conflict. Only `story/*` and `bounded/*` branches claim sections.

Each claimant declares its spec and its sections: a story in its story document, where `Spec:` names the spec and `Sections:` the sections; a bounded change in its pull request body.

## Language

The boundary does not run between documents; it runs **inside** each document: English skeleton, prose in the project's language.

- **The skeleton is English, everywhere** — section titles, field names, template labels, front matter values (`status: open | closed`), table headers, path and branch patterns, skill and command names.
- **Prose is in the project's language** — requirement bodies, descriptions, justifications, and the file and directory slugs, which name business objects.

That is the superpowers feeling kept: a document of this system reads like a superpowers document, with content in the project's language. The English skeleton a plan imposes on a story is then no longer an exception you put up with — it is the general rule, already applied.

## Concision

These rules hold for every text this flow writes: its documents, its pull request bodies and its commit messages. A text nobody manages to reread is no longer an authority, and the rules are what keeps it readable.

Every sentence says one exact thing, once, and stands on its own.

Every paragraph carries one rule.

A rule says how far it holds, and an exception presents itself as one.

A text says what it delivers or decides, without telling how it got there or why. Exception: the reason this flow explicitly asks for, such as the why of a ruling or of the commit that deletes a gaps register entry.

No sentence is set in relief. Bold that ranks one sentence above its neighbours tells the reader the others bind less.

### How to apply them

The cut test, asked of every sentence before you commit it: would a reader who never saw the previous version lose anything if this sentence went? If not, cut it. Two kinds of sentence fail it every time. The refutation of a version that no longer exists ("X is no exception") answers a text the reader will never see. And the particular case the general rule already covers ("every review merge" already includes the closing one) makes the reader doubt the cases that are not spelled out.

Too little is as wrong as too much. A bound ("only", "and nothing else") is a rule; cut it and the rule widens. A vague word ("nature", "handled appropriately") is replaced by the concrete rule it hides. When you strip a mechanism from a sentence, check that the intention it served is still written somewhere.

Examples:

- One rule per paragraph. Not: "Every branch starts from `main` and merges into `main`. Except an amendment's, it bears the name its step assigns." The exception reads as if it held for both rules. Good: each rule in its own paragraph, the exception attached to the one rule it touches.
- Write what you mean. Not: "no prose qualifies a group of entries". Good: "everything that qualifies an entry is written in the entry".
- Write the positive case. Not: "reaches `main` as a separate commit only if it carries a fresh decision". Good: "is squashed into the commit it corrects, unless it carries a fresh decision".
- Say what to do rather than listing cases. Not: "a divergence has only two legitimate causes: …". Good: "when `main` moved under a block, the story fits it; when a block's text is a problem, the agent puts it to the human".
- Two rules that paraphrase each other become one. Two phrasings reassure an agent and confuse a human, who looks for the difference between them.
- A list does not announce how many items it holds. Not: "The five readings." Good: "The readings." The count tells the reader nothing the list does not, and goes false the day an item is added or removed.
- A field carries what its name says. Reserved gaps register entries go under `Scope`, not under `Spec delta`.
- No dash in place of a comma or of "that is".
- An option the human decides is taken out of the text when it reads as an obligation.
- "Word for word" applies only to what really is copied word for word.
- A means is not the intention. Not: "each task runs in a subagent". Good: "each task is reviewed".

## Conversation

What the agent says to the human follows `Concision` above.

Facing the human, a delta block, a story or a gaps register entry is named by the section it targets and what it changes there, never by its identifier alone. Identifiers serve the documents and the agents; a human who hears "D12 conflicts with D6" does not know what either says, and naming the section alone still leaves them guessing what moves. Not: "D12 is ready". Good: "the block on `The batch document`, which moves the reserved entries into `Scope`, is ready".

The identifier may follow in parentheses when the human has to find it in the document.

## Execution Rules

A story's `Global Constraints` carries the execution rules that hold for that story. Each has a name:

| Name | Holds for | Written under |
|---|---|---|
| `spec freeze` | every story | `Authority and Conflict Rules` |
| `spec authority` | every story | `Authority and Conflict Rules` |
| `concision` | every story | `Concision` |
| `corrective stop condition` | a story of a corrective batch | `Stop Conditions` |
| `code under a feature flag` | a story that writes code guarded by a flag, whichever batch declares the flag | `Code Under a Feature Flag` |
| `technical stop condition` | a technical story | `Stop Conditions` |
| `untenable constraint or ADR` | a story whose batch declares constraints, or whose branch starts from a `main` that carries an ADR | `Stop Conditions` |
| `held ADRs` | a story whose branch starts from a `main` that carries an ADR | `The Model` |
| `decision worth an ADR` | every story | `Decisions Worth an ADR` |

### Stop Conditions

These conditions stop the execution of a plan, on top of those the execution by subagents states.

For corrective batches only:

> If, while bringing code into conformance with a spec, you discover that it is the **spec** that is wrong and the code that is right, stop. The batch is no longer corrective and must be requalified.

For a technical story only:

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

For a story only if its batch declares constraints or `main` carries an ADR when its branch starts:

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.

A constraint the spec contradicts does not fall under this condition: the spec wins.

A ruling replaces none of them. A ruling is a decision an agent takes on its human partner's behalf, and none of these is an agent's to take: the corrective condition would correct a spec, the technical condition would keep a qualification the story has just lost, and the condition on a constraint or an ADR would break a decision another story of the batch relies on, or one your human partner took for all the code to come. Recording one and carrying on is exactly the failure these conditions exist to prevent.

### Code Under a Feature Flag

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

### Decisions Worth an ADR

When you take a technical decision that meets the conditions of an ADR (`The Model`), say so in your report: it is recorded as an `Open ruling:`, which asks your human partner whether they want it as an ADR. Write nothing in `docs/adr/`.

## Red Flags

| Thought | Reality |
|---------|---------|
| "The spec is wrong here, I'll fix it and move on" | Correcting a spec is a human act. Implement what the spec says, record the `Ruling:`, and carry on. |
| "The batch is newer than the spec, so the batch wins" | The spec is the binding authority, without exception and without deliberation. The batch carries scope and order, never behaviour that contradicts a spec. |
| "The flag is just an `if`, the guarded code can do as it likes" | Guarded code holds up when the flag is on for some users, on for everyone, and off, under the rules of `Code Under a Feature Flag`. |
| "The flag is on for everyone, so it is lifted" | The declared default and the effective state are two different things. A flag exists as long as its gating sentence stands in the spec, and only a story removes it. |
| "I'm already in the previous story's worktree, I'll start the next one here" | Working there is fine; branching from there is not. Fetch, and start `story/NN-us-N-<slug>` from `main` as the remote carries it, or the new story's code lands on the previous story's branch. |
| "This sentence is safer in, even if it repeats the rule above" | A text that says what goes without saying makes the reader doubt what does not, and ends up unread. Apply the cut test. |
| "The human has the batch document, `D12` is enough" | They do not keep the identifiers in mind. Name the section the block targets and what it changes there. |
| "This decision is technical, no need to bring it to my human partner" | If it meets the conditions of an ADR, put it to them: only they decide an ADR. |
