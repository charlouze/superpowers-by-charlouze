# Extraction de `applying-a-spec-delta` Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La skill interne `applying-a-spec-delta` porte la construction, hors du dépôt, de la copie de chaque spec avec les blocs appliqués, et `writing-a-batch` l'invoque à la place de son texte.

**Architecture:** La skill reçoit le document de lot et les blocs à appliquer, construit les copies, ce qui vérifie chaque bloc, et rend leur chemin. `writing-a-batch` l'invoque là où elle construisait ces copies, et lui passe les blocs, qui varient d'un passage à l'autre. Les gardes qui tenaient le texte dans `writing-a-batch` passent sur la skill, une garde tient l'invocation chez l'appelante, et une garde négative interdit le texte ailleurs.

**Tech Stack:** Markdown pour les skills, Bash pour `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes

## Global Constraints

### Constraints of the batch

Les skills portent les noms que `Technical design` leur donne.

`using-batches` garde son nom, que le bloc d'instructions des projets installés
cite.

La story qui renomme une skill redonne, avec le nouveau nom, le prompt en attente
qui nomme l'ancien.

Une skill interne porte `user-invocable: false` et une description de la forme
« Use only when a skill tells you to invoke <nom>, never on … ».

Une skill interne nomme les skills qu'elle invoque, jamais celles qui
l'invoquent.

Un texte de plus d'une ou deux phrases que plusieurs skills partagent vit dans une
skill interne, jamais dans une ref.

Une story fusionnée laisse chaque référence `supercharlouze:<nom>` résolue et la
suite de tests verte.

Jusqu'à la story qui transcrit D6, D7 et D8, `Global Constraints` recopie ses
textes, et les contrats `shared` qui les tiennent identiques suivent ces textes
dans les skills qui les portent.

Chaque skill extraite l'est par une story à elle.

Les stories se livrent une à la fois, dans cet ordre, libre entre les skills d'un
même rang que « puis » ne sépare pas :

1. l'outillage des tests ;
2. `following-the-rules` ;
3. `writing-in-a-spec`, `writing-in-a-gaps-register`, `detecting-concurrency`,
   `abandoning-a-story`, `applying-a-spec-delta` et `running-reread-rounds` ;
4. `starting-a-branch`, puis `finishing-a-pr` ;
5. `writing-a-batch-document`, puis `rereading-a-batch` ;
6. `amending-a-batch`, dont la story renomme `writing-a-batch` en
   `opening-a-batch` ;
7. `handling-a-stopped-story`, `making-a-bounded-change`, puis le renommage de
   `writing-a-user-story` en `delivering-a-story`.

La story qui résorbe la violation sur `The gaps register` suit l'extraction de
`amending-a-batch`.

La story qui extrait `following-the-rules` résorbe le gap sur `Code under a
feature flag` et `The user story document`.

D1 et D4 sont transcrits par une même story, qui suit l'extraction de
`handling-a-stopped-story`.

D2 et D3 sont transcrits par une même story, qui suit l'extraction de
`making-a-bounded-change`.

D6, D7 et D8 sont transcrits par une même story, qui suit le renommage en
`delivering-a-story`.

La story qui transcrit D5 suit ce renommage.

### The freeze of the spec file

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

### The authority rule

When the batch and the spec contradict each other, the spec wins, without
exception and without deliberation. Implement what the spec says, record a
`Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
agent's.

### The concision rules

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

### The stop condition of a technical story

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

### The stop condition on a constraint or an ADR

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

### The ADRs

> The code this story writes holds these ADRs.

- `docs/adr/une-skill-par-moment-d-invocation.md`

### The conditions of an ADR

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

### This repository

- Every `git` command that writes a commit or talks to the remote goes through
  `bash ~/.config/github-app/as-agent.sh git …`. A commit message ends with
  `Co-Authored-By: Charlouze <me@charlouze.com>` and carries no other
  attribution line.
- A skill is English, cites no section of `docs/specs/supercharlouze.md`, and
  follows the rules of `Writing a skill` in the repository's `CLAUDE.md`.
- A `SKILL.md` has LF line endings.
- Write and edit files with the file tools, never with a heredoc, `sed` or
  `perl` in the shell: the shell of this machine eats backslashes.
- The machine has neither `python` nor `node`.
- A guard is written before the text it holds, and each task shows its red step.
- `bash tests/run-all.sh` runs the whole suite, in about two minutes.

## Review Focus

- A sentence of `writing-a-batch` that still tells how the copies are built: the negative guard of Task 2 refuses it.
- An invocation that does not say which blocks it passes: an amendment applies the blocks no merged story has declared yet, an opening applies them all.
- A name of an entry skill, or a numbered step, in `applying-a-spec-delta`: the guard of Task 1 refuses it.
- A needle that no longer matches because the prose it targets was re-wrapped with two spaces or a stray character: run the whole suite, not the edited file alone.
- A `reader-prompt.md` or an internal skill that receives the copies and starts naming the skill that builds them: none of them changes in this story.

---

### Task 1: The skill `applying-a-spec-delta`

**Files:**
- Create: `skills/applying-a-spec-delta/SKILL.md`
- Modify: `tests/skills.txt`
- Modify: `tests/test-skill-content.sh` (after the `abandoning-a-story` block, before `# --- following-the-rules: the delta block`)
- Modify: `tests/test-cross-references.sh` (after the block on the README row of `abandoning-a-story`)
- Modify: `README.md` (the `Skills` table)

**Interfaces:**
- Consumes: `require`, `absent`, `declared_skills` from `tests/lib.sh`; `entry_names`, already set in `tests/test-skill-content.sh`.
- Produces: the skill `supercharlouze:applying-a-spec-delta`, which Task 2 makes `writing-a-batch` invoke. It is given the batch document and the blocks to apply, and returns the path of each copy and the blocks that did not apply.

- [ ] **Step 1: Write the failing guards**

In `tests/test-skill-content.sh`, insert after the line `absent "abandoning-a-story names no skill that invokes it" "${entry_names%|}|Step [0-9]" abandoning-a-story` and its following blank line:

```bash
# --- applying-a-spec-delta: the specs with a batch's blocks applied ---
require applying-a-spec-delta "says what the invoking skill passes" \
    "The skill that invokes it gives the batch document and the blocks to apply."
require applying-a-spec-delta "the copies are built outside the repository" \
    "**outside the repository**"
require applying-a-spec-delta "no block reaches a spec before a story" \
    "no block is written into a spec before a story transcribes it"
require applying-a-spec-delta "only the given blocks are applied" \
    "Apply the given blocks and no other"
# Building a copy checks every block it applies, so the check lives with the
# copies.
require applying-a-spec-delta "building a copy checks every block" \
    "Building a copy checks every block it applies: it carries its \`D<n>\`, it names the spec and section it targets"
require applying-a-spec-delta "a block matches main or the block before it" \
    "its unchanged and removed lines match \`main\`, or the text the block ordered before it leaves"
require applying-a-spec-delta "a stale block will not apply" \
    "A block that fails this check does not apply"
require applying-a-spec-delta "returns the path of each copy" \
    "Return the path of each copy, with the path of the spec it copies."
require applying-a-spec-delta "returns the blocks that did not apply" \
    "Return each block that did not apply, with the check it failed."
require applying-a-spec-delta "red flag: applying the blocks in the worktree" \
    "| \"Editing the spec in the worktree is quicker, I'll revert it after\" |"
require applying-a-spec-delta "red flag: fitting a block that does not apply" \
    "| \"This block almost applies, I'll fit it as I go\" |"
require applying-a-spec-delta "says when to go back to the step that invoked it" \
    "Once you have them, go on with the step that invoked this skill."
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them.
absent "applying-a-spec-delta names no skill that invokes it" "${entry_names%|}|Step [0-9]" applying-a-spec-delta

```

In `tests/test-cross-references.sh`, insert after the `esac` that closes the second `case "$AROW"` block, and before the comment that starts `# The rereads use three skills`:

```bash

# The README row of applying-a-spec-delta, like the other internal skills', says
# it is not for direct use and names none of the skills that invoke it.
SROW="$(grep -F '`supercharlouze:applying-a-spec-delta`' "$REPO_ROOT/README.md" || true)"
case "$SROW" in
    *"writing-a-batch"*|*"invoked by"*)
        fail "the README row of applying-a-spec-delta names no caller" ;;
    *)  pass "the README row of applying-a-spec-delta names no caller" ;;
esac
case "$SROW" in
    *"Never directly"*) pass "the README row of applying-a-spec-delta rules out direct use" ;;
    *)                  fail "the README row of applying-a-spec-delta rules out direct use" ;;
esac
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-content.sh 2>&1 | grep -c 'FAIL.*applying-a-spec-delta'` and `bash tests/test-cross-references.sh 2>&1 | grep 'applying-a-spec-delta'`
Expected: thirteen failures in the first, among them `applying-a-spec-delta names no skill that invokes it (no such skill: applying-a-spec-delta)`; in the second, a failure on `the README row of applying-a-spec-delta rules out direct use`. If the output of a failure carries another marker than `FAIL`, read `pass` and `fail` in `tests/lib.sh` and adapt the `grep`.

- [ ] **Step 3: Declare the skill**

In `tests/skills.txt`, add this line after `abandoning-a-story internal`:

```
applying-a-spec-delta internal
```

- [ ] **Step 4: Write the skill**

Create `skills/applying-a-spec-delta/SKILL.md` with exactly this content, LF line endings:

```markdown
---
name: applying-a-spec-delta
description: Use only when a skill tells you to invoke applying-a-spec-delta, never on a request to preview a spec change - builds outside the repository a copy of each spec the given blocks target, with those blocks applied, which checks each block, and returns the paths of the copies
user-invocable: false
---

# Applying a Spec Delta

## Overview

This skill builds the state a batch's blocks produce: a copy of each spec they
target, with the blocks applied.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the applying-a-spec-delta skill to apply these blocks."

The skill that invokes it gives the batch document and the blocks to apply.

It returns the path of each copy (`What It Returns`). Once you have them, go on
with the step that invoked this skill.

## The Copies

Build a copy of each spec the blocks target, with those blocks applied,
**outside the repository**, in a scratch directory: no block is written into a
spec before a story transcribes it, whoever needs to read the state the blocks
produce.

Apply the given blocks and no other. A spec none of them targets gets no copy.

## The Check

Building a copy checks every block it applies: it carries its `D<n>`, it names
the spec and section it targets, and its unchanged and removed lines match
`main`, or the text the block ordered before it leaves.

A block that fails this check does not apply, which is how a delta gone stale
since the batch was drafted is caught.

## What It Returns

Return the path of each copy, with the path of the spec it copies.

Return each block that did not apply, with the check it failed.

## Red Flags

| Thought | Reality |
|---------|---------|
| "Editing the spec in the worktree is quicker, I'll revert it after" | No block is written into a spec before a story transcribes it. Build the copy outside the repository. |
| "This block almost applies, I'll fit it as I go" | A block that fails the check is a stale delta, and fitting it hides that. Return it with the check it failed. |
```

- [ ] **Step 5: Add the README row**

In `README.md`, add this row to the `Skills` table, after the row of `supercharlouze:abandoning-a-story`:

```markdown
| `supercharlouze:applying-a-spec-delta` | Never directly — a building block the other skills invoke to build, outside the repository, a copy of each spec with a batch's blocks applied |
```

- [ ] **Step 6: Run the whole suite**

Run: `bash tests/run-all.sh 2>&1 | tail -15`
Expected: every check file passes, no failure. A negative guard that walks every declared skill may refuse a phrase of the new skill: reword the phrase of the skill, never the guard, and say so in your report.

- [ ] **Step 7: Commit**

```bash
git add skills/applying-a-spec-delta tests/skills.txt tests/test-skill-content.sh tests/test-cross-references.sh README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la skill interne applying-a-spec-delta porte les copies des specs, blocs appliqués" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: `writing-a-batch` invokes `applying-a-spec-delta`

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`The ADRs`, `The Coherence Reread`, `The Technical Reread`, `Amending a Batch`)
- Modify: `tests/test-skill-content.sh` (the `require writing-a-batch` guards named below)
- Modify: `tests/test-skill-contracts.sh` (after the `absent "no other skill restates the abandonment gesture"` guard)

**Interfaces:**
- Consumes: the skill `supercharlouze:applying-a-spec-delta` of Task 1, given the batch document and the blocks to apply, returning the path of each copy.
- Produces: nothing a later task relies on.

- [ ] **Step 1: Write the failing guards**

In `tests/test-skill-contracts.sh`, insert after the three lines of the guard `absent "no other skill restates the abandonment gesture"` (it ends on the line `$(declared_skills | grep -vx abandoning-a-story)`) and a blank line:

```bash
# The copies of the specs, blocks applied, are built in one place,
# `applying-a-spec-delta`. A skill that needs them invokes it and passes the
# batch document and the blocks to apply.
require writing-a-batch "invokes applying-a-spec-delta with the batch document and the blocks" \
    "nvoke \`supercharlouze:applying-a-spec-delta\` and give it the"
# How they are built is spelled there and nowhere else. Walks the declared
# skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates how the applied copies are built" \
    "outside the repository|scratch directory|checks every block|fails this check does not apply|the text the block ordered before it leaves|[Bb]uild (a|that|the) cop(y|ies)|cop(y|ies) built|coherence reread built|Coherence Reread\` builds it" \
    $(declared_skills | grep -vx applying-a-spec-delta)
```

In `tests/test-skill-content.sh`:

1. Delete these five guards of `writing-a-batch`, which Task 1 already wrote on `applying-a-spec-delta`, together with the two comment lines that start `# Building the applied copy checks every block`:

   - `require writing-a-batch "the applied state is built outside the repository" …`
   - `require writing-a-batch "no block reaches a spec before a story" …`
   - `require writing-a-batch "building the copy checks every block" …`
   - `require writing-a-batch "a block matches main or the block before it" …`
   - `require writing-a-batch "a stale block will not apply" …`

2. In the comment above `require writing-a-batch "the delta goes through the coherence reread"`, replace the four lines

   ```bash
   # The step exists, the applied state is built outside the repository, the rule it
   # must not suspend to get there, what building it catches for free, the
   # independence of the context, and the declaration that makes the whole thing
   # observable. Drop any one and the section still reads whole while doing less.
   ```

   with

   ```bash
   # The step exists, the applied state comes from `applying-a-spec-delta`, and the
   # declaration makes the whole thing observable. Drop any one and the section
   # still reads whole while doing less.
   ```

   and add, right after `require writing-a-batch "step 5 states the skip where it is ordered" …`:

   ```bash
   require writing-a-batch "the coherence reread has every block applied" "Invoke \`supercharlouze:applying-a-spec-delta\` and give it the batch document and every block of its spec delta. Then invoke \`supercharlouze:rereading-a-spec\` on each applied copy"
   ```

3. Replace the needle of `"a spec no block targets goes as it is"` with:

   ```
   "the applied copy the coherence reread read, or the spec itself when no block targets it"
   ```

4. Replace the guard `"the applied copies are built before an ADR is written"` with:

   ```bash
   require writing-a-batch "the blocks are applied before an ADR is written" "Before writing or rewriting one, invoke \`supercharlouze:applying-a-spec-delta\` and give it the batch document and every block of its spec delta: it returns the copies of the specs, blocks applied."
   ```

5. Replace the needle of `"its blocks are applied with every pending block"` with:

   ```
   "invoke \`supercharlouze:applying-a-spec-delta\` and give it the amended document and its new or changed blocks together with every block no merged story has declared yet"
   ```

6. Replace the needle of `"its applied copies go to the shared reread"` with:

   ```
   "then invoke \`supercharlouze:rereading-a-spec\` on each applied copy, with the path of the spec it applies to, as \`The Coherence Reread\` does"
   ```

7. Replace the guard `"its technical reread builds the copies itself"` with:

   ```bash
   require writing-a-batch "its technical reread has the pending blocks applied" "invoke \`supercharlouze:applying-a-spec-delta\` and give it the amended document and those blocks"
   ```

8. Replace the needle of `"its ADRs meet the pending blocks of the amended document"` with:

   ```
   "Where that section gives \`supercharlouze:applying-a-spec-delta\` every block of the spec delta, give it every block of the amended document that no merged story has declared yet."
   ```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-contracts.sh 2>&1 | grep -E 'applying-a-spec-delta|applied copies'` and `bash tests/test-skill-content.sh 2>&1 | grep -i fail`
Expected: the two new guards of `tests/test-skill-contracts.sh` fail, the second one naming `writing-a-batch` as the skill that still carries the text; in `tests/test-skill-content.sh` the seven guards whose needle changed or was added fail (`the coherence reread has every block applied`, `a spec no block targets goes as it is`, `the blocks are applied before an ADR is written`, `its blocks are applied with every pending block`, `its applied copies go to the shared reread`, `its technical reread has the pending blocks applied`, `its ADRs meet the pending blocks of the amended document`).

- [ ] **Step 3: Rewrite `The ADRs`**

In `skills/writing-a-batch/SKILL.md`, replace

```markdown
Before writing or rewriting one, build a copy of each spec the batch touches
with its blocks applied, as `The Coherence Reread` builds it. An ADR is
confronted with the specs as the batch leaves them, and no block is in a spec
yet.
```

with

```markdown
Before writing or rewriting one, invoke `supercharlouze:applying-a-spec-delta`
and give it the batch document and every block of its spec delta: it returns
the copies of the specs, blocks applied. An ADR is confronted with the specs as
the batch leaves them, and no block is in a spec yet.
```

The paragraph that follows, `Invoke supercharlouze:recording-a-decision … and hand it those copies.`, stays as it is.

- [ ] **Step 4: Rewrite `The Coherence Reread`**

Replace the three paragraphs

```markdown
Build that state — a copy of each touched spec with its blocks applied —
**outside the repository**, in a scratch directory: no block is written into a
spec before a story transcribes it, and that rule is not suspended to make a
reread convenient.

Building that copy checks every block: it carries its `D<n>`, it names the spec
and section it targets, and its unchanged and removed lines match `main`, or the
text the block ordered before it leaves. A block that fails this check does not
apply, which is how a delta gone stale since the batch was drafted is caught.

Then invoke `supercharlouze:rereading-a-spec` on each applied copy, with the path
of the spec it applies to.
```

with

```markdown
Invoke `supercharlouze:applying-a-spec-delta` and give it the batch document and
every block of its spec delta.

Then invoke `supercharlouze:rereading-a-spec` on each applied copy, with the path
of the spec it applies to.
```

- [ ] **Step 5: Rewrite the sentence of `The Technical Reread`**

Replace

```markdown
each spec the batch touches: the applied copy the coherence reread built, or the
spec itself when no block targets it.
```

with

```markdown
each spec the batch touches: the applied copy the coherence reread read, or the
spec itself when no block targets it.
```

Keep the rest of the line that follows (`Hand it also …`) as it is.

- [ ] **Step 6: Rewrite the three passages of `Amending a Batch`**

Replace

```markdown
document is amended. Where that section applies the batch's blocks, apply every
block of the amended document that no merged story has declared yet. The pull
request body states each ADR it writes, rewrites or deletes.
```

with

```markdown
document is amended. Where that section gives
`supercharlouze:applying-a-spec-delta` every block of the spec delta, give it
every block of the amended document that no merged story has declared yet. The
pull request body states each ADR it writes, rewrites or deletes.
```

Replace

```markdown
opening. Before its pull request opens, apply its new or changed blocks together
with every block no merged story has declared yet, and invoke
`supercharlouze:rereading-a-spec` on each applied copy, with the path of the
spec it applies to, as `The Coherence Reread` does. Its body states the exact
text of every new or changed block, and what the coherence reread found.
```

with

```markdown
opening. Before its pull request opens, invoke
`supercharlouze:applying-a-spec-delta` and give it the amended document and its
new or changed blocks together with every block no merged story has declared
yet, then invoke `supercharlouze:rereading-a-spec` on each applied copy, with
the path of the spec it applies to, as `The Coherence Reread` does. Its body
states the exact text of every new or changed block, and what the coherence
reread found.
```

Replace

```markdown
one. Conduct it as `The Technical Reread` does, on the amended document and on
each spec with every block no merged story has declared yet applied, in a copy
built as `The Coherence Reread` builds it. A behaviour or a block it returns as
```

with

```markdown
one. Conduct it as `The Technical Reread` does, on the amended document and on
each spec with every block no merged story has declared yet applied: invoke
`supercharlouze:applying-a-spec-delta` and give it the amended document and
those blocks. A behaviour or a block it returns as
```

- [ ] **Step 7: Run the whole suite**

Run: `bash tests/run-all.sh 2>&1 | tail -15`
Expected: every check file passes, no failure. Then run `grep -rn 'supercharlouze:applying-a-spec-delta' skills README.md` and check that the name appears only in `skills/writing-a-batch/SKILL.md` and `README.md`.

- [ ] **Step 8: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: writing-a-batch invoque applying-a-spec-delta pour appliquer les blocs" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

## Observed drift
