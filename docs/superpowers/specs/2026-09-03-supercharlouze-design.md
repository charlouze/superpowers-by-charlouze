# supercharlouze — Design

**Goal:** A Claude Code plugin that overrides how superpowers organizes specs
and plans. It replaces dated, one-shot design documents with one living spec
per functional module, and replaces standalone plans with *batches* of user
stories that make those specs grow.

**Status:** Design approved 2026-09-03. Not yet implemented.

**Plugin name:** `supercharlouze` (namespace for all skills). Repository:
`superpowers-by-charlouze`.

**Target harness:** Claude Code only.

**Language:** The plugin is English throughout — skill names, skill content,
templates, generated section headings, and the `CLAUDE.md` block. superpowers
has no localization mechanism, and conformance with superpowers is a stated
requirement. Templates are not localizable. Prose written by a human inside a
project's documents may be in any language; the skeleton is always English.

---

## 1. Problem

superpowers writes one dated design document per feature
(`docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`) and one plan per
feature (`docs/superpowers/plans/YYYY-MM-DD-<feature>.md`). Both are
snapshots of an intent at a moment in time, and neither is ever revisited.

Nothing accumulates. After ten features, a module's behavior is scattered
across ten dated documents, each describing a delta, none describing the
current state. No artifact answers the question "what does the billing module
do today?" — and therefore no artifact can be used to detect that the code has
drifted away from what was agreed.

## 2. Model

**Module** — a coarse functional area, seen from the outside. Modules are
delimited by the human, never inferred by an agent. Prefer few, large modules
over many small ones: a project with three modules is normal, a project with
fifteen is a decomposition mistake. This entire plugin is one module.

**Spec** — one living document per module, at `docs/specs/<module>.md`. It is
**normative** (what the code must do), not descriptive (what the code
happens to do). It carries no date. It is the binding authority for every
review.

**Batch** — the unit of delivery, at `docs/batches/NN-<slug>/`. A batch groups
several user stories. Its purpose is to add functionality to one or more
specs. A batch may span modules.

**User story** — one implementation plan, at
`docs/batches/NN-<slug>/us-N-<slug>.md`. A user story belongs to exactly one
batch and targets exactly **one** module, therefore exactly one spec.

**Corrective batch** — a batch whose spec delta is empty. Its purpose is to
bring existing code into conformance with a spec that is already true. Its
scope is drawn from a module's gaps register.

## 3. Authority and conflict rules

The spec is the binding authority. The batch carries only what a spec cannot
carry: delivery scope, ordering of user stories, migration and compatibility
constraints, and the reason this work is happening now. By construction the
batch cannot contradict the spec.

**When a batch and a spec conflict, the spec wins.** A conflict is not an
arbitration to be made, it is a symptom: the spec delta was written wrong.
Fix the spec, then continue.

**Every conflict is logged for the human.** This reuses the existing
superpowers mechanism rather than inventing one: superpowers'
`subagent-driven-development` maintains a ledger whose rulings take the form
`Ruling: <decision> — <why> — <what it costs if wrong>`, and collects every
`Ruling:` line to present to the human before deleting its workspace. Because
that workspace is transient, this plugin copies those lines into the batch's
**Rulings log** when each user story is validated, so the trace survives.

**Two open batches may mark the same spec** — markers name their batch, so
they cannot be confused. Two open batches modifying **the same requirement**
is a stop-and-escalate condition; it does not resolve itself. Detection
happens in `writing-a-batch`: before placing a marker on a section, it checks
for a marker already there naming a different batch.

## 4. Artifact layout

```
docs/
  specs/
    billing.md                    living spec, one per module, undated
    billing.gaps.md               gaps register for that module
  batches/
    07-recurring-billing/
      README.md                   the batch
      us-1-subscription.md        one user story = one superpowers plan
      us-2-dunning.md
  archive/                        pre-migration dated documents
```

### 4.1 Spec document

Describes behavior. No dates, no per-requirement status at rest.

- Sections currently being delivered carry a temporary marker `🚧 batch-07`,
  placed when the batch opens and removed when it closes.
- A **Changelog** table at the foot of the document carries history:
  `batch | date | change`. Changes made outside any batch (see §8.2) are
  recorded there with `batch` set to `out-of-batch`.

The marker rule is what makes drift detection mechanical: **any divergence
between spec and code that is not covered by a marker is drift**, and
therefore corrective work.

### 4.2 Gaps register

`docs/specs/<module>.gaps.md` is a living document, not a throwaway report. It
is created by module adoption and drained by subsequent batches. Two distinct
sections, because they are not treated the same way:

- **Violations** — the code contradicts the spec. Feeds a *corrective* batch.
- **Gaps** — the code does things no spec describes. Feeds a *regular* batch
  that finally specifies them.

Each entry is struck through with its batch number when consumed.

The register also states **its own coverage**: which parts of the module were
audited and which were not, and why. An empty register that means "nothing was
examined" must not look like an empty register that means "everything
conforms".

### 4.3 Batch document

`README.md` with front matter `status: open | closed`, plus:

- **Scope** — what this batch delivers, and why now.
- **Spec delta** — the behavior added to each spec, or, for a corrective
  batch, the gaps-register entries being consumed. Empty delta + non-empty
  entries is exactly what makes a batch corrective.
- **User stories** — a checklist. Boxes are ticked as stories are validated.
- **Rulings log** — rulings rapatriated from superpowers' SDD ledger.

### 4.4 User story document

A standard superpowers plan, produced by `superpowers:writing-plans`, saved
under the batch directory, with an extended header:

```markdown
**Spec:** docs/specs/billing.md
**Batch:** docs/batches/07-recurring-billing/README.md
```

`Spec:` is the field `subagent-driven-development` already reads as binding
authority — pointing it at the living module spec is what makes the whole
integration work without modifying superpowers.

`Batch:` is a pointer for human readers and for the orchestrator. It is **not**
the vehicle for constraints. Constraints the batch imposes on execution are
copied verbatim into the plan's `Global Constraints` section, which
`superpowers:writing-plans` already defines as implicitly part of every task's
requirements.

## 5. Batch lifecycle

**Opening.** Confirm every module the batch touches has an adopted spec; if
not, adoption is a blocking prerequisite (§6). Write the spec delta into each
spec and place `🚧 batch-NN` markers on the affected sections. Write the batch
document with scope and the initial list of user stories.

**Running.** User stories are written **one at a time**, not all up front: the
story N+1 is written knowing what story N produced. Each story goes through
`superpowers:writing-plans` for task mechanics, then through
`superpowers:subagent-driven-development` for execution. On validation, tick
its box in the batch and copy its rulings into the Rulings log.

**Closing.** Remove every `🚧 batch-NN` marker from the specs. Append a
changelog line to each touched spec. Strike consumed entries in the gaps
registers with the batch number. Set `status: closed`.

## 6. Module adoption

`supercharlouze:adopting-a-module` establishes the truth everything else
depends on. It is the most delicate operation in the system.

**Source of authority, in order:**

1. **Validated documents** are normative. They make the truth.
2. **The code** never overrides a document. It fills documents' *silences* —
   behavior no document ever described.
3. **The human** settles contradictions.

Reconstructing a spec from code is explicitly rejected: it would canonize
drift and destroy the very property that makes corrective batches possible.

**Steps:**

1. **Delimit the module** — the human names it and draws its boundaries. The
   skill never infers them. Prefer one large module over several small ones.
2. **Inventory the validated documents** covering it — old superpowers design
   docs, READMEs, domain docs, ADRs. Present the list to the human *before*
   writing anything, so they can add a missing source or reject one that was
   never validated. The spec's quality is capped by this inventory.
3. **Write the spec from those documents only.** Merge, deduplicate,
   reconcile. When two validated documents contradict each other, the more
   recent wins by default — recorded as a ruling, never resolved silently.
4. **Audit the code against the spec** and produce the gaps register, with
   its two sections and its declared coverage (§4.2).
5. **Mandatory human review.** Until the human approves the spec and the
   register, the module is not adopted and no batch may start on it.

**Degraded case — a module with no validated documents.** Adoption from
documents is impossible and reconstruction from code is rejected. The skill
falls back to a dialogue: it enumerates behaviors found in the code and asks
the human, section by section, "is this intended?". What the human validates
becomes the spec; everything else becomes a gap. This is slow, and choosing to
run it now or defer it is the human's call.

## 7. Skills

| Skill | Trigger | Produces |
|---|---|---|
| `using-batches` | entry point, cited by the `CLAUDE.md` block | routing, vocabulary, authority and conflict rules |
| `adopting-a-module` | first batch touching a module with no spec | the spec + the gaps register |
| `writing-a-batch` | opening a batch | the batch document, the spec delta, the markers |
| `writing-a-user-story` | a story to write | a superpowers plan in the right place and format |
| `closing-a-batch` | last story validated | markers removed, changelog, register drained, rulings logged |

`writing-a-user-story` is separate from `writing-a-batch` because stories are
written lazily (§5).

## 8. Routing and precedence

### 8.1 The lever

Precedence over superpowers is won through the project's `CLAUDE.md`, because
that is the only lever superpowers explicitly concedes:
`superpowers:using-superpowers` ends with *"User instructions (CLAUDE.md,
AGENTS.md, direct requests) take precedence over skills"*.

A `SessionStart` hook was rejected: hook ordering between two plugins is
unspecified, which would leave two competing `EXTREMELY_IMPORTANT` blocks and
produce intermittent, undiagnosable failures.

The block inserted by `/supercharlouze:init` is deliberately tiny and stable,
so it never needs resynchronizing when the plugin evolves. All substance lives
in the versioned skills:

```markdown
## Specs and plans

This project overrides the documentary organization of superpowers.
Before any design work, invoke `supercharlouze:using-batches`. It replaces the
"Write design doc" step of superpowers:brainstorming and the plan location of
superpowers:writing-plans. Every other superpowers skill (TDD,
subagent-driven-development, debugging, reviews) applies unchanged.
```

### 8.2 What is kept and what is rerouted

superpowers' spike / bounded / architectural classification is **kept
unchanged** — it is orthogonal to this model and it is good.

- **Spike** — unchanged. No artifact.
- **Bounded** — unchanged in ceremony, with one addition. superpowers allows a
  bounded change to ship with no document at all, which in this model means
  behavior changing while the spec stands still: drift manufactured by the
  process itself. Therefore: a bounded change that alters behavior described in
  a spec **must update that spec as part of its definition of done**, with an
  `out-of-batch` changelog line. No batch, no user story, no added ceremony.
- **Architectural** — the terminal state is rerouted. Instead of writing a
  dated design doc and calling `writing-plans`, it calls
  `supercharlouze:writing-a-batch`.

### 8.3 Declared override of a closed rule

`superpowers:subagent-driven-development` states *"Four things stop you, and
only these"*. This plugin adds a fifth, for corrective batches only:

> If, while making code conform to a spec, you find that the **spec** is wrong
> and the code is right, stop. The batch is no longer corrective and must be
> requalified.

Because SDD frames its list as closed, this override must be **named as an
override** in `using-batches`, with its justification. An implicit exception to
a rule marked "and only these" will not survive a session under pressure.

## 9. The `init` command

`/supercharlouze:init` is idempotent and never adopts anything.

1. Create `docs/specs/`, `docs/batches/`, `docs/archive/`.
2. Move existing `docs/superpowers/specs/` and `docs/superpowers/plans/` into
   `docs/archive/`.
3. Insert the `CLAUDE.md` block, or update it in place if already present.
   Never duplicate it. Works both on a project with an existing `CLAUDE.md`
   and on one without.
4. Report the state of play: which modules are adopted (a spec exists under
   `docs/specs/`), and which documents were archived without a spec covering
   them. It does **not** propose module boundaries — §6 reserves that to the
   human, and a suggested decomposition would be read as an authoritative one.

Adoption stays a deliberate, per-module decision (§6). A project may remain
half-adopted indefinitely without anything breaking.

## 10. Verification

**Structural checks only**, automated and cheap:

- `plugin.json` is valid.
- Every `SKILL.md` has front matter with `name` and `description`.
- Paths cited across skills resolve.
- The `CLAUDE.md` block inserts cleanly into a file that already exists, into
  a project with no `CLAUDE.md`, and does not duplicate on a second run.

Behavioral evaluation of the routing is **explicitly out of scope**. The
accepted consequence is that the strength of the `CLAUDE.md` lever — the most
likely failure point of the design — is not proven by the test suite. Phase 2
of the bootstrap plan below is what exercises it in practice.

## 11. Bootstrap plan

**Phase 1 — build v1 with plain superpowers.** The plugin cannot build itself:
`writing-a-batch` does not exist yet. So v1 follows the standard superpowers
path — this design document, then `superpowers:writing-plans`, then
`subagent-driven-development`. Artifacts land in `docs/superpowers/specs/` and
`docs/superpowers/plans/` under superpowers' own conventions.

**Phase 2 — dogfood on this repository.** Once v1 ships, run
`/supercharlouze:init` on `superpowers-by-charlouze` itself. At that point it
is a genuine superpowers project with dated design documents to migrate, whose
every line is known — the right first subject for init, migration and
adoption, before they are pointed at real projects. superpowers itself is built
this way, and a skills plugin is a good fit: its "code" is prose, so
spec-versus-implementation drift is real and worth tracking.

**Module count for this repository: one — `superpowers-override`.** Not four.
This is the granularity heuristic of §2 applied to its own author.

## 12. Rejected alternatives

| Alternative | Why rejected |
|---|---|
| Fork superpowers | The project explicitly refuses fork-specific PRs; the divergence would be maintained alone, for no gain over a companion plugin. |
| `CLAUDE.md` per project, no plugin | Sufficient for paths and vocabulary, insufficient against `brainstorming`'s hard-coded checklist and tuned red-flag tables. |
| `SessionStart` hook for precedence | Unspecified ordering between plugin hooks; intermittent failure. |
| Batch wins over spec during the batch | The spec is what reviewers read; leaving it false for a whole batch defeats its purpose. |
| Spec updated at batch closure | Same reason: SDD reviews conformance after *every* task, against a spec that would not yet describe the work. |
| Permanent per-requirement status in the spec | Full traceability at the cost of a document that reads like a registry rather than a specification. The changelog recovers most of it. |
| Spec reconstructed from code at adoption | Canonizes drift; destroys the premise of corrective batches. |
| Undocumented behavior absorbed into the spec at adoption | The spec must contain only validated content; unvalidated behavior belongs in the gaps register. |
| Multi-harness support | Only Claude Code is used; each additional harness is porting work with no return. |
