# Extraction de `running-reread-rounds` Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La skill interne `running-reread-rounds` porte le déroulé des tours d'une relecture, et `rereading-a-spec` et `rereading-a-technical-design` l'invoquent à la place de leur copie.

**Architecture:** La skill reçoit le texte que les tours retouchent, ce que devient chaque constat et les lectures qui ne partent qu'au premier tour. Elle attend les lecteurs, instruit les constats, conduit les tours suivants en tenant le registre des problèmes, et rend le texte. Chaque relecture garde ses lecteurs, ses lectures et son `reader-prompt.md`, envoie le premier tour, puis invoque la skill en lui passant ce qui lui est propre. Les gardes qui tenaient le déroulé dans les deux relectures passent sur la skill, une garde tient l'invocation dans chaque relecture, et une garde négative interdit le texte ailleurs.

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

- A difference between the two rereads flattened into the shared skill: what becomes of a finding, the text the rounds revise and the reading that goes out in the first round only stay in each reread, which passes them.
- A sentence of the rounds left behind in a reread, body or `Red Flags` table: the negative guard of Task 2 refuses it.
- A name of a skill, or a numbered step, in `running-reread-rounds`: the guard of Task 1 refuses it.
- A `reader-prompt.md` that changes, or that starts naming a skill of the plugin: neither changes in this story, and Task 2 guards the name.
- A needle that no longer matches because the prose it targets was re-wrapped with two spaces or a stray character: run the whole suite, not the edited file alone.

---

### Task 1: The skill `running-reread-rounds`

**Files:**
- Create: `skills/running-reread-rounds/SKILL.md`
- Modify: `tests/skills.txt`
- Modify: `tests/test-skill-content.sh` (after the `applying-a-spec-delta` block, before `# --- following-the-rules: the delta block`)
- Modify: `tests/test-cross-references.sh` (after the block on the README row of `applying-a-spec-delta`)
- Modify: `README.md` (the `Skills` table)

**Interfaces:**
- Consumes: `require`, `absent`, `declared_skills` from `tests/lib.sh`.
- Produces: the skill `supercharlouze:running-reread-rounds`, which Task 2 makes both rereads invoke. It is given the text the rounds revise, what becomes of each finding, and the readings that go out in the first round only. It returns the text as the rounds leave it, and the ledger.

- [ ] **Step 1: Write the failing guards**

In `tests/test-skill-content.sh`, insert after the line `absent "applying-a-spec-delta names no skill that invokes it" "${entry_names%|}|Step [0-9]" applying-a-spec-delta` and its following blank line:

```bash
# --- running-reread-rounds: the rounds of a reread ---
require running-reread-rounds "says what the invoking skill passes" \
    "The skill that invokes it gives: - the text the rounds revise; - what becomes of each finding; - the readings that go out in the first round only, when it has any."
require running-reread-rounds "waits for every reader" \
    "Every reader returns before anything goes up. Wait for all of them and gather their findings, never a running report"
require running-reread-rounds "findings are instructed, not forwarded" \
    "You instruct the findings; you do not forward them."
require running-reread-rounds "the invoking skill says what becomes of a finding" \
    "Work each one through: the invoking skill says what becomes of it."
require running-reread-rounds "the rulings are applied on the text the rounds revise" \
    "Then put to your human partner what you changed and what you could not settle, and apply their rulings on the text the rounds revise."
require running-reread-rounds "the human is spared a draft" \
    "Forwarding raw findings makes your human partner arbitrate a draft, which is the work the review exists to spare them."
require running-reread-rounds "a ruling can end the rounds" \
    "A ruling the invoking skill says ends the reread ends the rounds."
require running-reread-rounds "a round runs on the revised text" \
    "A round runs on the revised text."
require running-reread-rounds "keeps the state a round read" \
    "Keep a copy of the state each round read: the next round's readers are handed it."
require running-reread-rounds "the rounds have stop conditions" \
    "These stop the rounds, and without them they chain indefinitely"
require running-reread-rounds "a revision retouches" \
    "**A revision retouches.** Change only the sentences a finding names. A section rewritten whole is a section no reader has read, and it sends every reading out again."
require running-reread-rounds "a later round reads only the revision" \
    "**A later round reads the revision, and nothing else.** What a revision adds, moves or rewords is unread; what it takes out reopens only what leaned on it"
require running-reread-rounds "nothing unread opens no round" \
    "A revision that leaves nothing unread opens no round."
require running-reread-rounds "a later round's readings" \
    "Dispatch only the readings the revision bears on: a reworded sentence goes back to the reading that found it wanting, an added one to every reading. Hand each reader the state the round before read, next to the revised one."
require running-reread-rounds "a first-round reading is not dispatched again" \
    "A reading given as going out in the first round only is not dispatched again."
require running-reread-rounds "a later dispatch is composed as the first" \
    "Compose each dispatch as the invoking skill composed the first round's."
require running-reread-rounds "keeps a ledger of problems" \
    "Keep a ledger from round to round: each finding's problem, the round that returned it, and what you did with it. Recognise a finding by its problem, not by its words"
require running-reread-rounds "a returning problem goes to the human" \
    "When a second round returns the same problem, put it to your human partner with the option you recommend, and do not reword it a third time."
require running-reread-rounds "three rounds at most" \
    "**The third round is the last you open.** After it, stop and put to your human partner what is still open, with your recommendation. A further round runs only on their decision."
require running-reread-rounds "the reread does not replace the review" \
    "**The reread prepares the review of the pull request that carries the text, it does not replace it.**"
require running-reread-rounds "returns the text and the ledger" \
    "Return the text as the rounds leave it, and the ledger."
require running-reread-rounds "says when to go back to the step that invoked it" \
    "Once the rounds are over, go on with the step that invoked this skill."
require running-reread-rounds "red flag: a reader is done" \
    "| \"This reader is done, I'll put its findings up now\" | The next reader may displace them. Wait for every reader. |"
require running-reread-rounds "red flag: handing over the findings" \
    "| \"I'll hand my human partner the findings to rule on\" | Instruct them first. Your human partner rules on what you changed and what you could not settle. |"
require running-reread-rounds "red flag: one more round" \
    "| \"One more round, the text can still improve\" | The third round is the last you open. After it, your human partner decides whether another runs. |"
require running-reread-rounds "red flag: a section rewritten whole" \
    "| \"This section reads better rewritten whole\" | A rewritten section is unread, and sends every reading out again. Retouch the sentences a finding names. |"
require running-reread-rounds "red flag: a reworded clause" \
    "| \"I reworded the clause, so this finding is a new one\" | A finding is its problem, not its words. Returned by a second round, it goes to your human partner. |"
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them. This one invokes none, and the skills that
# invoke it are internal too: the guard walks every declared skill.
rounds_other_names="supercharlouze:|superpowers:|calling skill|Step [0-9]"
for declared in $(declared_skills); do
    [ "$declared" = "running-reread-rounds" ] && continue
    rounds_other_names="$rounds_other_names|$declared"
done
absent "running-reread-rounds names no skill" "$rounds_other_names" running-reread-rounds

```

In `tests/test-cross-references.sh`, insert after the `esac` that closes the second `case "$SROW"` block, and before the comment that starts `# The rereads use three skills`:

```bash

# The README row of running-reread-rounds, like the other internal skills', says
# it is not for direct use and names none of the skills that invoke it.
OROW="$(grep -F '`supercharlouze:running-reread-rounds`' "$REPO_ROOT/README.md" || true)"
case "$OROW" in
    *"rereading-a-"*|*"invoked by"*)
        fail "the README row of running-reread-rounds names no caller" ;;
    *)  pass "the README row of running-reread-rounds names no caller" ;;
esac
case "$OROW" in
    *"Never directly"*) pass "the README row of running-reread-rounds rules out direct use" ;;
    *)                  fail "the README row of running-reread-rounds rules out direct use" ;;
esac
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-content.sh 2>&1 | grep 'FAIL.*running-reread-rounds'` and `bash tests/test-cross-references.sh 2>&1 | grep 'running-reread-rounds'`
Expected: every guard added to the first file fails, the last as `running-reread-rounds names no skill (no such skill: running-reread-rounds)`; in the second, a failure on `the README row of running-reread-rounds rules out direct use`. Keep this output for your report.

- [ ] **Step 3: Declare the skill**

In `tests/skills.txt`, add this line after `applying-a-spec-delta internal`:

```
running-reread-rounds internal
```

- [ ] **Step 4: Write the skill**

Create `skills/running-reread-rounds/SKILL.md` with exactly this content, LF line endings:

````markdown
---
name: running-reread-rounds
description: Use only when a skill tells you to invoke running-reread-rounds, never on a request to reread a text - waits for every reader of a reread, works their findings through on the text, and runs the later rounds until the reread closes
user-invocable: false
---

# Running Reread Rounds

## Overview

This skill conducts a reread from the moment its first round of readers is
dispatched: it gathers their findings, works them through, and opens the later
rounds.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the running-reread-rounds skill to run the rounds of this reread."

The skill that invokes it gives:

- the text the rounds revise;
- what becomes of each finding;
- the readings that go out in the first round only, when it has any.

It returns the text as the rounds leave it, and the ledger (`What It Returns`).

## The Findings

Every reader returns before anything goes up. Wait for all of them and gather
their findings, never a running report: a partial report gets findings ruled on
that the next reader displaces, and asks for the same ruling twice.

You instruct the findings; you do not forward them. Work each one through: the
invoking skill says what becomes of it.

Then put to your human partner what you changed and what you could not settle,
and apply their rulings on the text the rounds revise. Forwarding raw findings
makes your human partner arbitrate a draft, which is the work the review exists
to spare them.

A ruling the invoking skill says ends the reread ends the rounds.

## The Rounds

A round runs on the revised text. Keep a copy of the state each round read: the
next round's readers are handed it. These stop the rounds, and without them they
chain indefinitely:

- **A revision retouches.** Change only the sentences a finding names. A section
  rewritten whole is a section no reader has read, and it sends every reading
  out again.
- **A later round reads the revision, and nothing else.** What a revision adds,
  moves or rewords is unread; what it takes out reopens only what leaned on it,
  coherence being a property of the state and not of the text that remains. A
  revision that leaves nothing unread opens no round. Dispatch only the readings
  the revision bears on: a reworded sentence goes back to the reading that found
  it wanting, an added one to every reading. Hand each reader the state the
  round before read, next to the revised one. A reading given as going out in
  the first round only is not dispatched again. Compose each dispatch as the
  invoking skill composed the first round's.
- **A problem that comes back goes to your human partner.** Keep a ledger from
  round to round: each finding's problem, the round that returned it, and what
  you did with it. Recognise a finding by its problem, not by its words: a
  reworded clause still carries the problem a reader found in it. When a second
  round returns the same problem, put it to your human partner with the option
  you recommend, and do not reword it a third time.
- **The third round is the last you open.** After it, stop and put to your human
  partner what is still open, with your recommendation. A further round runs
  only on their decision.
- **The reread prepares the review of the pull request that carries the text, it
  does not replace it.**

## What It Returns

Return the text as the rounds leave it, and the ledger.

Once the rounds are over, go on with the step that invoked this skill.

## Red Flags

| Thought | Reality |
|---|---|
| "This reader is done, I'll put its findings up now" | The next reader may displace them. Wait for every reader. |
| "I'll hand my human partner the findings to rule on" | Instruct them first. Your human partner rules on what you changed and what you could not settle. |
| "One more round, the text can still improve" | The third round is the last you open. After it, your human partner decides whether another runs. |
| "This section reads better rewritten whole" | A rewritten section is unread, and sends every reading out again. Retouch the sentences a finding names. |
| "I reworded the clause, so this finding is a new one" | A finding is its problem, not its words. Returned by a second round, it goes to your human partner. |
````

- [ ] **Step 5: Add the README row**

In `README.md`, add this row to the `Skills` table, after the row of `supercharlouze:applying-a-spec-delta`:

```markdown
| `supercharlouze:running-reread-rounds` | Never directly — a building block the other skills invoke to run the rounds of a reread: gather the readers' findings, work them through and open the later rounds |
```

- [ ] **Step 6: Run the whole suite**

Run: `bash tests/run-all.sh 2>&1 | grep -c '\[FAIL\]'`
Expected: `0`. On a failure, read it with `bash tests/run-all.sh 2>&1 | grep '\[FAIL\]'` and fix the text, not the guard, unless the guard has a typing slip.

- [ ] **Step 7: Commit**

```bash
git add skills/running-reread-rounds/SKILL.md tests/skills.txt tests/test-skill-content.sh tests/test-cross-references.sh README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la skill interne running-reread-rounds porte le déroulé des tours d'une relecture" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 2: Both rereads invoke `running-reread-rounds`

**Files:**
- Modify: `skills/rereading-a-spec/SKILL.md` (`Findings and Rounds`, `Red Flags`)
- Modify: `skills/rereading-a-technical-design/SKILL.md` (`Findings and Rounds`, `Red Flags`)
- Modify: `tests/test-skill-contracts.sh`
- Modify: `tests/test-skill-content.sh`
- Modify: `tests/test-reader-prompt.sh`
- Modify: `tests/test-technical-reader-prompt.sh`

**Interfaces:**
- Consumes: the skill `supercharlouze:running-reread-rounds` of Task 1, which is given the text the rounds revise, what becomes of each finding, and the readings that go out in the first round only.
- Produces: nothing a later task relies on.

Neither `reader-prompt.md` changes. No other section of the two skills changes: `The Readers`, `The Readings` and `Input and Output` stay as they are, the sentence `This is the first round's dispatch: a later round sends out fewer (`Findings and Rounds`).` included.

- [ ] **Step 1: Rewrite the guards in `tests/test-skill-contracts.sh`**

(a) Replace the guard `absent "the reread names no skill that invokes it"` and its two following lines by:

```bash
absent "the reread names no skill that invokes it" \
    "supercharlouze:([^r]|r[^u])|adopting-a-module|writing-a-batch|calling skill" \
    rereading-a-spec
```

(b) Replace everything from the comment line `# Both rereads dispatch their readers, gather them and close their rounds the` down to the line `    rereading-a-spec rereading-a-technical-design` that ends the guard `shared "both rereads spare the human a draft"`, both included, by:

```bash
# Both rereads dispatch their readers the same way. One assertion per rule over
# both skills, so neither drifts alone.
shared "both rereads dispatch on the conductor's model" \
    "Dispatch every reader on the model you run on, and name that model in the dispatch" \
    rereading-a-spec rereading-a-technical-design
shared "both rereads send out fewer readings after the first round" \
    "This is the first round's dispatch: a later round sends out fewer (\`Findings and Rounds\`)." \
    rereading-a-spec rereading-a-technical-design

# The rounds of a reread are run in one place, `running-reread-rounds`. A reread
# invokes it once its first round is dispatched, and passes what varies from one
# reread to the other.
for s in rereading-a-spec rereading-a-technical-design; do
    require "$s" "invokes running-reread-rounds once the first round is dispatched" \
        "Once the first round is dispatched, invoke \`supercharlouze:running-reread-rounds\` and give it"
done
# How the rounds run is spelled there and nowhere else. Walks the declared
# skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the rounds of a reread" \
    "Every reader returns before anything goes up|never a running report|You instruct the findings|arbitrate a draft|A revision retouches|Keep a copy of the state each round read|reads the revision, and nothing else|leaves nothing unread opens no round|Dispatch only the readings the revision bears on|Keep a ledger from round to round|do not reword it a third time|third round is the last you open|These stop the rounds|it does not replace it|A round runs on the revised text|rewritten whole|I reworded the clause|One more round|put its findings up now|the findings to rule on" \
    $(declared_skills | grep -vx running-reread-rounds)
# The conditions these replaced never stopped a reread: one read as an order to
# reopen, the other waited for a round with no fresh finding, which a reader of
# freshly revised text always has.
absent "no reread reopens on every unread state" \
    "A fresh round only on a state|already examined and declined|Two rounds stuck on the same clause" \
    rereading-a-spec rereading-a-technical-design running-reread-rounds
```

(c) Replace the guard `absent "the technical reread names no skill that invokes it"` and its two following lines by:

```bash
absent "the technical reread names no skill that invokes it" \
    "supercharlouze:([^r]|r[^u])|using-batches|adopting-a-module|writing-a-batch|writing-a-user-story|closing-a-batch|rereading-a-spec|recording-a-decision|calling skill" \
    rereading-a-technical-design
```

- [ ] **Step 2: Rewrite the guards in `tests/test-skill-content.sh`**

(a) In the `rereading-a-spec` block, replace everything from the comment line `# Waiting for every reader, then who revises between two rounds. Without the last` down to the line `require rereading-a-spec "the reread does not replace the review" …`, both included, by:

```bash
# The rounds live in `running-reread-rounds`, guarded in its block below. Here:
# what this reread passes to it.
require rereading-a-spec "the rounds revise the spec" "give it the spec as the text the rounds revise, and what becomes of each finding:"
require rereading-a-spec "a mechanism leaves the spec, as a finding" "- A sentence that describes a mechanism leaves the spec, and goes to the output."
# A defect the change did not write is returned and left alone. Fixed in the
# reread, it widens what the human reviews; left to every round, it comes back
# with each of them.
require rereading-a-spec "a defect already on main is not fixed"  "A defect the spec already carries on \`main\` is not fixed: the change did not write that passage, and fixing it widens what your human partner reviews"
require rereading-a-spec "a defect already on main opens no round" "It goes once into what the reread found, and opens no round"
require rereading-a-spec "red flag: an old passage"               "| \"The reader is right about this old passage, I'll fix it too\" | The change did not write it."
```

(b) In the `rereading-a-technical-design` block, replace everything from the comment line `# Findings are instructed, and what changes a decision goes to the human, who` down to the line `require rereading-a-technical-design "the reread does not replace the review" …`, both included, by:

```bash
# The rounds live in `running-reread-rounds`, guarded in its block below. Here:
# what this reread passes to it. What changes a decision goes to the human, who
# approved the design.
require rereading-a-technical-design "the rounds revise the design and the constraints" "- the technical design and the constraints, as the text the rounds revise;"
require rereading-a-technical-design "the reading of the ADRs goes out once" "- the reading of the ADRs to reread, as a reading that goes out in the first round only: no revision touches what it reads;"
require rereading-a-technical-design "it says what becomes of each finding" "- what becomes of each finding, stated below."
require rereading-a-technical-design "an undescribed behaviour always goes up" "A behaviour the design would make observable that no specification describes is always put to your human partner"
require rereading-a-technical-design "a finding on a block goes to the human" "A finding on a block is not fixed: put it to your human partner, who leaves the block as it is, takes the batch back to its spec delta, which ends the reread, or has the ADR changed. This reread revises no block."
require rereading-a-technical-design "a finding on an ADR goes to the human" "A finding on an ADR is not fixed either: put it to your human partner, and return it with what they ruled. Return the same way a finding on a block or on the design that they settle by having an ADR changed. This reread revises no ADR."
require rereading-a-technical-design "a fix keeps what the design decides" "Any other finding is fixed on the technical design or the constraints without changing what they decide, or put to your human partner when fixing it would: they approved what the design decides."
require rereading-a-technical-design "red flag: fixing an ADR" "| \"The reader is right about this ADR, I'll fix its wording\" | This reread revises no ADR. Put the finding to your human partner, and return it with what they ruled. |"
require rereading-a-technical-design "red flag: adjusting a block" "| \"This block contradicts an ADR, I'll adjust the block\" | This reread revises no block. Put the finding to your human partner. |"
require rereading-a-technical-design "red flag: no design, nothing to reread" "| \"The batch has no design, so there is nothing to reread\" | A reading is dispatched when its object exists. An ADR the pull request writes is reread whatever the batch carries. |"
```

- [ ] **Step 3: Guard the reader prompts**

In `tests/test-reader-prompt.sh`, insert before the last line `exit $((FAILURES > 0))`:

```bash
# A reader loads no skill of the plugin: the prompt does not name the one that
# runs the rounds.
case "$FLAT" in
    *"running-reread-rounds"*) fail "the prompt does not name the skill that runs the rounds" ;;
    *)                         pass "the prompt does not name the skill that runs the rounds" ;;
esac

```

In `tests/test-technical-reader-prompt.sh`, in the `case "$FLAT"` block under `# The prompt names no skill of the plugin.`, add `|*"running-reread-rounds"*` at the end of the pattern line, before its closing `)`.

- [ ] **Step 4: Run the guards to verify they fail**

Run: `bash tests/test-skill-contracts.sh 2>&1 | grep '\[FAIL\]'` and `bash tests/test-skill-content.sh 2>&1 | grep '\[FAIL\]'`
Expected: in the first, `invokes running-reread-rounds once the first round is dispatched` fails for both rereads, and `no other skill restates the rounds of a reread (present in: rereading-a-spec rereading-a-technical-design)`; in the second, `the rounds revise the spec`, `the rounds revise the design and the constraints`, `the reading of the ADRs goes out once`, `it says what becomes of each finding` and `a fix keeps what the design decides` fail. Keep this output for your report.

- [ ] **Step 5: Rewrite `Findings and Rounds` of `rereading-a-spec`**

In `skills/rereading-a-spec/SKILL.md`, replace the whole section `## Findings and Rounds`, from its heading down to the line before `## Red Flags`, by exactly this, followed by one blank line:

```markdown
## Findings and Rounds

Once the first round is dispatched, invoke
`supercharlouze:running-reread-rounds` and give it the spec as the text the
rounds revise, and what becomes of each finding:

- A sentence that describes a mechanism leaves the spec, and goes to the output.
- A rule that would constrain behaviour observable at the boundary of more than
  one module stays as it is, and goes to the output: the module breakdown is
  your human partner's decision, not a wording.
- A defect the spec already carries on `main` is not fixed: the change did not
  write that passage, and fixing it widens what your human partner reviews. It
  goes once into what the reread found, and opens no round.
- Any other finding is fixed without changing what its sentence rules, or put to
  your human partner when fixing it would.
```

In its `Red Flags` table, delete these five rows and no other:

- the row that starts `| "This reader is done, I'll put its findings up now" |`
- the row that starts `| "I'll hand my human partner the findings to rule on" |`
- the row that starts `| "One more round, the wording can still improve" |`
- the row that starts `| "This section reads better rewritten whole" |`
- the row that starts `| "I reworded the clause, so this finding is a new one" |`

- [ ] **Step 6: Rewrite `Findings and Rounds` of `rereading-a-technical-design`**

In `skills/rereading-a-technical-design/SKILL.md`, replace the whole section `## Findings and Rounds`, from its heading down to the line before `## Red Flags`, by exactly this, followed by one blank line:

```markdown
## Findings and Rounds

Once the first round is dispatched, invoke
`supercharlouze:running-reread-rounds` and give it:

- the technical design and the constraints, as the text the rounds revise;
- the reading of the ADRs to reread, as a reading that goes out in the first
  round only: no revision touches what it reads;
- what becomes of each finding, stated below.

A behaviour the design would make observable that no specification describes is
always put to your human partner. It leaves the design, or your human partner
takes the batch back to its spec delta and the reread ends: this reread writes
no block.

A finding on a block is not fixed: put it to your human partner, who leaves the
block as it is, takes the batch back to its spec delta, which ends the reread,
or has the ADR changed. This reread revises no block.

A finding on an ADR is not fixed either: put it to your human partner, and
return it with what they ruled. Return the same way a finding on a block or on
the design that they settle by having an ADR changed. This reread revises no
ADR.

Any other finding is fixed on the technical design or the constraints without
changing what they decide, or put to your human partner when fixing it would:
they approved what the design decides.
```

In its `Red Flags` table, delete these four rows and no other:

- the row that starts `| "This reader is done, I'll put its findings up now" |`
- the row that starts `| "One more round, the design can still improve" |`
- the row that starts `| "This section reads better rewritten whole" |`
- the row that starts `| "I reworded the clause, so this finding is a new one" |`

- [ ] **Step 7: Run the whole suite**

Run: `bash tests/run-all.sh 2>&1 | grep -c '\[FAIL\]'`
Expected: `0`. On a failure, read it with `bash tests/run-all.sh 2>&1 | grep '\[FAIL\]'` and fix the text, not the guard, unless the guard has a typing slip.

- [ ] **Step 8: Commit**

```bash
git add skills/rereading-a-spec/SKILL.md skills/rereading-a-technical-design/SKILL.md tests/test-skill-contracts.sh tests/test-skill-content.sh tests/test-reader-prompt.sh tests/test-technical-reader-prompt.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: les deux relectures invoquent running-reread-rounds" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: la story est technique alors que les deux relectures invoquent désormais une skill là où elles portaient le texte — la spec ne dit pas quelle skill porte une règle, et l'humain l'a déjà tranché sur la story 13-us-3 — si c'est faux, la story demandait un bloc et une revue d'ouverture.
- Ruling: la phrase qui clôt les conditions d'arrêt des tours devient générique dans la skill, « the pull request that carries the text », là où chaque relecture nommait la spec ou le design — ce nom est celui du texte que la relecture passe — si c'est faux, qui conduit lit « the text » moins précisément que « the spec ».
- Ruling: dans la relecture technique, les arbitrages de l'humain s'appliquent à « the text the rounds revise », le design et les contraintes, là où le texte disait « on the design » — c'est le texte que cette relecture passe, et elle ne retouche ni bloc ni ADR — si c'est faux, un arbitrage sur les contraintes s'applique là où il ne s'appliquait pas.
- Ruling: le red flag « I'll hand my human partner the findings to rule on », que seule la relecture de spec portait, passe dans la skill et vaut donc aussi pour la relecture technique — il répond à la phrase « You instruct the findings », que les deux portaient — si c'est faux, la relecture technique a gagné une ligne qu'elle n'avait pas.
- Ruling: dans la relecture technique, « Fix each one on the technical design or the constraints… » devient le dernier cas, « Any other finding is fixed on… », après les trois cas qui ne se corrigent pas — l'invocation passe ces cas comme ce que devient chaque constat — si c'est faux, l'ordre se lit comme une priorité que le texte n'avait pas.
- Ruling: la skill porte trois phrases qu'aucune relecture ne portait, « Compose each dispatch as the invoking skill composed the first round's », « A reading given as going out in the first round only is not dispatched again » et « A ruling the invoking skill says ends the reread ends the rounds » — elles relient les tours à ce que la relecture passe, que la même section disait d'un seul tenant — si c'est faux, la skill dit plus que les copies.
- Ruling: la skill ne rend que le texte, et le registre des problèmes reste une note de travail de qui conduit — aucune relecture ne rend le registre, et la revue de branche a relevé qu'un registre rendu était un comportement ajouté — si c'est faux, « what the reread found » se compose sans le registre comme avant.
- Ruling: la skill renvoie à « the skill that invoked this one: it says what the reread returns » et non à « the step that invoked this skill » comme les autres skills internes — ce qui suit, dans une relecture, est son `Input and Output` et non une étape — si c'est faux, la formule diffère des autres skills internes sans raison.
- Ruling: les phrases « Dispatch every reader on the model you run on… » et « a later round sends out fewer (`Findings and Rounds`) » restent copiées dans les deux relectures, sous leurs contrats `shared` — elles tiennent en une phrase et appartiennent à l'envoi, que le lot laisse à chaque relecture — si c'est faux, deux copies d'une phrase peuvent dériver.
- Ruling: le renvoi « (`Findings and Rounds`) » de `The Readings` mène désormais à la section qui invoque la skill, et non à la règle sur les tours suivants — une section nommée entre parenthèses est une section de la skill elle-même — si c'est faux, qui conduit cherche la règle un cran trop tôt.
- Ruling: les deux gardes « names no skill that invokes it » des relectures laissent passer `supercharlouze:running-reread-rounds` par l'expression `supercharlouze:([^r]|r[^u]|ru[^n])` — `grep -E` n'a pas de négation de mot, et les relectures invoquent maintenant une skill — si c'est faux, un autre nom en `supercharlouze:run…` passerait dans une relecture.
- Ruling: la garde qui interdit de nommer une skill dans `running-reread-rounds` parcourt toutes les skills déclarées, et pas les seules skills d'entrée comme celles des autres skills internes — les skills qui l'invoquent sont internes, et elle n'en invoque aucune — si c'est faux, la garde refusera le jour où la skill en invoque une.
- Ruling: une garde interdit le nom `running-reread-rounds` dans les deux `reader-prompt.md` — le lot veut qu'un lecteur ne charge aucune skill du plugin, et la liste en dur de `tests/test-technical-reader-prompt.sh` ne lit pas `tests/skills.txt` — si c'est faux, une garde de trop.
- Ruling: la phrase « It is invoked by another skill, never on a request of your human partner » reste dans la skill bien qu'elle redise sa description — toutes les skills internes la portent — si c'est faux, une phrase sans laquelle un agent agirait de même.

## Observed drift
