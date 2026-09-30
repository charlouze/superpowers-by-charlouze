# La conception technique du lot Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Le document de lot porte un champ `Technical design`, le plan d'une story en part et consigne ses écarts, et la clôture le réécrit pour décrire le mécanisme livré.

**Architecture:** Le plugin est fait de skills Markdown gardées par une suite structurelle en bash. Chaque tâche écrit d'abord ses gardes dans `tests/test-skill-content.sh` ou `tests/test-skill-contracts.sh` (`require`, `shared`, `absent`), les voit échouer, puis écrit le texte de la skill qui les fait passer. Cinq tâches, une par skill touchée et par norme : `using-batches`, `writing-a-batch` (deux normes), `writing-a-user-story`, `closing-a-batch`.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/10-la-conception-technique/README.md
**Sections:** The model, Authority and conflict rules, Batch > The batch document, Batch > Closing a batch, Story > Delivering a story
**Blocks:** D1, D2, D4, D6, D11, D13

## Global Constraints

Les contraintes du lot, recopiées mot pour mot :

> `D1` précède `D2`, `D4`, `D5`, `D6`, `D7`, `D8`, `D9`, `D10`, `D11` et `D13`, qui
> nomment la conception technique.
>
> `D2` précède `D13`, qui nomme l'arbitrage de conception technique.
>
> `D3` précède `D10` et `D12`, qui renvoient à la condition d'arrêt qu'il écrit.
>
> `D7` précède `D8` et `D10`, qui nomment la relecture technique.
>
> Un lot ouvert avant la transcription de `D6` n'a pas de champ `Technical design` :
> sa clôture n'a rien à réécrire, et ses stories n'ont pas de conception dont partir.

Le gel du fichier de spec :

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

La primauté de la spec :

> When the batch and the spec contradict each other, the spec wins — without
> exception and without deliberation. Implement what the spec says, record a
> `Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
> agent's.

Les règles de concision :

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

## Conventions

- `CLAUDE.md` à la racine du dépôt dit comment écrire une skill : elle est entièrement anglaise, ne cite jamais une section de `docs/specs/supercharlouze.md`, et chaque norme a sa garde dans `tests/`, écrite avant le texte.
- Le texte à insérer est donné mot pour mot dans chaque tâche. Garde le retour à la ligne vers 80 colonnes du fichier qui le reçoit : les gardes aplatissent les sauts de ligne, donc le retour à la ligne ne change rien pour elles.
- Chaque commit passe par le wrapper d'identité, et son message se termine par la ligne de co-auteur donnée dans la tâche :

  ```bash
  bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
  <subject>

  Co-Authored-By: Charlouze <me@charlouze.com>
  EOF
  ```

- La suite complète (`bash tests/run-all.sh`) prend plus de deux minutes ; en cours de tâche, lance seulement le fichier de test que la tâche modifie, et la suite complète à la dernière étape de chaque tâche, avec un délai d'au moins dix minutes.

## Review Focus

- Un lot ouvert avant l'existence du champ n'a pas de `Technical design` : la story et la clôture le traitent comme `none`, sans s'arrêter (Tâches 4 et 5).
- Un `Technical design` qui vaut `none` : la clôture n'a rien à réécrire, et aucun arbitrage n'est un arbitrage de conception technique (Tâches 4 et 5).
- Un écart pris pendant l'exécution, et non en écrivant le plan : il arrive dans le `Rulings log` sous la forme `Technical design ruling:` à l'étape 6 (Tâche 4).
- Un bloc retiré à la clôture : la conception réécrite ne garde pas ce qui ne servait que lui, et elle est réécrite après ce retrait (Tâche 5).
- Le code de `main` s'est déjà écarté de la conception, par une story antérieure : le plan part du code (Tâche 4).

---

### Task 1: `using-batches` nomme la conception technique

**Files:**
- Modify: `skills/using-batches/SKILL.md` (`## The Model`, `## Authority and Conflict Rules`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Produces: les termes `Technical design` et `Technical design ruling`, que les tâches 2 à 5 emploient tels quels.

- [ ] **Step 1: Write the failing guards**

In `tests/test-skill-content.sh`, replace this line:

```bash
require using-batches "a batch carries only what a spec cannot" "Besides its spec delta, a batch carries only what a spec cannot carry: its scope, its flags, the order of its stories and of its blocks, and its migration and compatibility constraints."
```

with:

```bash
require using-batches "a batch carries only what a spec cannot" "Besides its spec delta, a batch carries only what a spec cannot carry: its scope, its flags, its constraints and its technical design."
require using-batches "defines the technical design" \
        "**Technical design** — the mechanism a batch plans for its stories, each of which may depart from it."
require using-batches "the spec binds, the design guides" \
        "the spec binds a story, the technical design only guides it"
require using-batches "defines the technical design ruling" \
        "**Technical design ruling** — a ruling by which a story departs from its batch's technical design."
```

In `tests/test-skill-contracts.sh`, just before the final `exit $((FAILURES > 0))`, add:

```bash
# A batch's constraints now include its shared technical decisions, so the old
# enumeration of what a batch carries must not survive beside the new one.
absent "a batch no longer lists only migration constraints" \
    "its flags, the order of its stories and of its blocks, and its migration" \
    using-batches
```

- [ ] **Step 2: Run them to verify they fail**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: FAIL on the four `using-batches` guards and on `a batch no longer lists only migration constraints`.

- [ ] **Step 3: Write the text**

In `skills/using-batches/SKILL.md`, under `## The Model`, right after the paragraph that starts `**Technical story** —`, insert:

```markdown
**Technical design** — the mechanism a batch plans for its stories, each of which may depart from it. It lives in the batch document's `Technical design` field, and a story's plan starts from it: the spec binds a story, the technical design only guides it.

**Technical design ruling** — a ruling by which a story departs from its batch's technical design.
```

Under `## Authority and Conflict Rules`, replace:

```markdown
**The spec is the binding authority.** Besides its spec delta, a batch carries only what a spec cannot carry: its scope, its flags, the order of its stories and of its blocks, and its migration and compatibility constraints.
```

with:

```markdown
**The spec is the binding authority.** Besides its spec delta, a batch carries only what a spec cannot carry: its scope, its flags, its constraints and its technical design.
```

- [ ] **Step 4: Run the guards to verify they pass**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL; bash tests/test-cross-references.sh | grep FAIL`
Expected: no output.

- [ ] **Step 5: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: le modèle nomme la conception technique d'un lot

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 2: le document de lot porte `Technical design`

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## Opening, in Order`, `## The Batch Document`, `## Opening the Pull Request`, `## Red Flags`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: le terme `Technical design ruling` (Task 1).
- Produces: le champ `## Technical design` du gabarit, placé entre `## Spec delta` et `## Constraints` ; la phrase du corps de pull request `the technical design, or the reason for its \`none\`;`, que la Task 3 prolonge.

- [ ] **Step 1: Write the failing guards**

In `tests/test-skill-content.sh`, replace this line:

```bash
require writing-a-batch "step 3 names every field it writes"    "\`Scope\`, \`Spec delta\`, \`Constraints\`, \`Feature flag\`"
```

with:

```bash
require writing-a-batch "step 3 names every field it writes"    "3. **Write the batch document**: \`Scope\`, \`Spec delta\`, \`Technical design\`, \`Constraints\`, \`Feature flag\`"
require writing-a-batch "the document reread names every field" "The batch-document reread bears on the whole document: \`Scope\`, \`Spec delta\`, \`Technical design\`, \`Constraints\`, \`Feature flag\`."
```

Right after the line `require writing-a-batch "the document reread checks the field"      "\`Spec delta\` filled"`, add:

```bash
# The batch document carries the technical design of its stories (spec section
# "The batch document"): between the delta and the constraints, never blank.
require writing-a-batch "the template places the design after the delta" \
    "with no block, \`none\` and the reason.> ## Technical design <The design your human partner approved during the brainstorming"
require writing-a-batch "the template places the design before the constraints" \
    "with no design, \`none\` and the reason.> ## Constraints"
require writing-a-batch "the design comes from the brainstorming" \
    "\`Technical design\` carries the design your human partner approved during \`superpowers:brainstorming\`"
require writing-a-batch "a story may depart from the design" \
    "a story may depart from it by recording a \`Technical design ruling:\`"
require writing-a-batch "an observable behaviour is a block, not design" \
    "What a user or a neighbouring module would observe goes in a block, never in \`Technical design\`."
require writing-a-batch "the document reread checks the design field" \
    "\`Technical design\` filled, with the design or with \`none\` and the reason"
require writing-a-batch "the PR body puts the design to the reviewer" \
    "the technical design, or the reason for its \`none\`;"
```

- [ ] **Step 2: Run them to verify they fail**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: FAIL on the nine guards above.

- [ ] **Step 3: Write the text**

In `skills/writing-a-batch/SKILL.md`:

(a) Under `## Opening, in Order`, replace

```markdown
3. **Write the batch document**: `Scope`, `Spec delta`, `Constraints`,
   `Feature flag` (`The Batch Document`, `The Feature Flag Field`,
   `Flags Declared by Earlier Batches`).
```

with

```markdown
3. **Write the batch document**: `Scope`, `Spec delta`, `Technical design`,
   `Constraints`, `Feature flag` (`The Batch Document`,
   `The Feature Flag Field`, `Flags Declared by Earlier Batches`).
```

(b) In the same section, replace

```markdown
The batch-document reread bears on the whole document: `Scope`, `Spec delta`,
`Constraints`, `Feature flag`.
```

with

```markdown
The batch-document reread bears on the whole document: `Scope`, `Spec delta`,
`Technical design`, `Constraints`, `Feature flag`.
```

(c) In the template under `## The Batch Document`, between the `## Spec delta` placeholder (ending `with no block, \`none\` and the reason.>`) and `## Constraints`, insert:

```markdown
## Technical design

<The design your human partner approved during the brainstorming: the mechanism
the stories are planned from. Never left blank: with no design, `none` and the
reason.>

```

(d) Right after the paragraph that ends `Left out, each story would silently invent its own migration rule
and its own order.`, insert these two paragraphs:

```markdown
`Technical design` carries the design your human partner approved during
`superpowers:brainstorming`, which this document replaces as the design doc. Each
story's plan starts from it, and a story may depart from it by recording a
`Technical design ruling:`.

What a user or a neighbouring module would observe goes in a block, never in
`Technical design`.
```

(e) Under `## Opening the Pull Request`, replace

```markdown
each one reserved, corrective or ordinary; `Spec delta` filled, with blocks or
with `none` and the reason; `Constraints` carrying only migration and
```

with

```markdown
each one reserved, corrective or ordinary; `Spec delta` filled, with blocks or
with `none` and the reason; `Technical design` filled, with the design or with
`none` and the reason; `Constraints` carrying only migration and
```

(f) In the same section, replace

```markdown
reviewer has to rule on: the exact text of every block, or the reason for the
`none`; the flag decision;
```

with

```markdown
reviewer has to rule on: the exact text of every block, or the reason for the
`none`; the technical design, or the reason for its `none`; the flag decision;
```

(g) At the end of the `## Red Flags` table, add the row:

```markdown
| "The design is obvious from the delta, `Technical design` can say `none`" | `none` is for a batch with no design to plan from, and it carries its reason. Every story plans from this field; left empty, each one invents its own mechanism. |
```

- [ ] **Step 4: Run the guards to verify they pass**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-cross-references.sh | grep FAIL`
Expected: no output.

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: le document de lot porte la conception technique de ses stories

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 3: `Constraints` porte les décisions techniques qu'aucune story ne peut défaire

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## The Batch Document`, `## Opening the Pull Request`, `## Red Flags`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: le paragraphe `` `Technical design` carries the design… `` et la phrase du corps de pull request `the technical design, or the reason for its \`none\`;` (Task 2).

- [ ] **Step 1: Write the failing guards**

In `tests/test-skill-content.sh`, replace this line:

```bash
require writing-a-batch "the template's Constraints are bounded"    "<Only the migration and compatibility constraints, and the required order of the stories and of the blocks."
```

with:

```bash
require writing-a-batch "the template's Constraints are bounded"    "<Only the migration and compatibility constraints, the technical decisions no story can depart from without breaking another story, and the required order of the stories and of the blocks."
# A technical decision is a constraint only when departing from it in one story
# breaks another (spec section "The batch document"); every other one is design.
require writing-a-batch "a decision is a constraint only if departing breaks another story" \
    "A technical decision goes in \`Constraints\` only if a story departing from it would break another story"
require writing-a-batch "every other decision is design" \
    "Every other technical decision goes in \`Technical design\`, where a story may depart from it."
require writing-a-batch "the document reread checks the widened Constraints" \
    "\`Constraints\` carrying only migration and compatibility constraints, the technical decisions no story can depart from without breaking another, and the required order of stories and blocks, or \`none\`"
require writing-a-batch "the PR body puts the constraints to the reviewer" \
    "the technical design, or the reason for its \`none\`; the constraints; the flag decision;"
```

In `tests/test-skill-contracts.sh`, just before the final `exit $((FAILURES > 0))`, add:

```bash
# Constraints now carry shared technical decisions as well, so the old bound —
# migration and compatibility, then the order — must not survive anywhere.
absent "Constraints are no longer bounded to migration and order" \
    "migration and compatibility constraints,? and the required order" \
    writing-a-batch
```

- [ ] **Step 2: Run them to verify they fail**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: FAIL on the five `writing-a-batch` guards above and on `Constraints are no longer bounded to migration and order`.

- [ ] **Step 3: Write the text**

In `skills/writing-a-batch/SKILL.md`:

(a) In the template, replace

```markdown
<Only the migration and compatibility constraints, and the required order of
the stories and of the blocks. `none` if there are none.>
```

with

```markdown
<Only the migration and compatibility constraints, the technical decisions no
story can depart from without breaking another story, and the required order of
the stories and of the blocks. `none` if there are none.>
```

(b) Right before the paragraph that starts `` `Technical design` carries the design your human partner approved ``, insert:

```markdown
A technical decision goes in `Constraints` only if a story departing from it
would break another story, such as a name or a format two stories both rely on.
Every other technical decision goes in `Technical design`, where a story may
depart from it.
```

(c) Under `## Opening the Pull Request`, replace

```markdown
`none` and the reason; `Constraints` carrying only migration and
compatibility constraints and the required order of stories and blocks, or
`none`;
```

with

```markdown
`none` and the reason; `Constraints` carrying only migration and
compatibility constraints, the technical decisions no story can depart from
without breaking another, and the required order of stories and blocks, or
`none`;
```

(d) In the same section, replace

```markdown
`none`; the technical design, or the reason for its `none`; the flag decision;
```

with

```markdown
`none`; the technical design, or the reason for its `none`; the constraints;
the flag decision;
```

(e) At the end of the `## Red Flags` table, add the row:

```markdown
| "This technical decision matters, so it goes in `Constraints`" | Only if a story departing from it would break another story. Otherwise it goes in `Technical design`, where a story may depart from it by a ruling. |
```

- [ ] **Step 4: Run the guards to verify they pass**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: no output.

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: les contraintes d'un lot portent les décisions qu'aucune story ne peut défaire

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 4: le plan d'une story part de la conception technique

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (`## Step 4 — Write the Plan`, `## Step 6 — Record Before the Merge`, `## Red Flags`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: le champ `Technical design` (Task 2).
- Produces: la forme de ligne `Technical design ruling:`, que la Task 5 lit à la clôture.

- [ ] **Step 1: Write the failing guards**

In `tests/test-skill-content.sh`, right after the line `require writing-a-user-story "an open ruling says what is left"   "ends with what is left to settle, then with the gaps register category"`, add:

```bash
# The plan starts from the batch's technical design, and every departure is a
# technical design ruling (spec section "Delivering a story").
require writing-a-user-story "the plan starts from the technical design" \
    "**The plan starts from the batch's \`Technical design\`**, and its \`Architecture:\` line derives from it."
require writing-a-user-story "main's code wins where it departed" \
    "Exception: where the code on \`main\` has departed from the design, as an earlier story of the batch may have, the plan starts from the code."
require writing-a-user-story "a departure is recorded as the plan is written" \
    "Any other departure of the plan from the design is a technical design ruling. Write it in the \`Rulings log\` as you write the plan"
require writing-a-user-story "a technical design ruling has its own form" \
    "**A technical design ruling is written \`Technical design ruling:\`** where the others are written \`Ruling:\`"
require writing-a-user-story "no design, nothing to start from" \
    "or whose document has no such field because it was opened before the field existed, gives the plan nothing to start from"
require writing-a-user-story "step 6 keeps the form for execution departures" \
    "A ruling that departs from the batch's \`Technical design\` is written as a \`Technical design ruling:\`."
```

- [ ] **Step 2: Run them to verify they fail**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: FAIL on the six guards above.

- [ ] **Step 3: Write the text**

In `skills/writing-a-user-story/SKILL.md`:

(a) Under `## Step 4 — Write the Plan`, right after the paragraph that starts `**An open ruling is written \`Open ruling:\`**` and ends `would have to recognise a category in prose.`, insert:

```markdown
**The plan starts from the batch's `Technical design`**, and its `Architecture:`
line derives from it. Exception: where the code on `main` has departed from the
design, as an earlier story of the batch may have, the plan starts from the code.

Any other departure of the plan from the design is a technical design ruling.
Write it in the `Rulings log` as you write the plan: the design was approved at
the opening gate, and a departure nobody recorded reaches the delivery review as
a surprise.

**A technical design ruling is written `Technical design ruling:`** where the
others are written `Ruling:`, with the same three parts.
`supercharlouze:closing-a-batch` rewrites the design from these lines, so a
departure written as a plain `Ruling:` leaves the design describing a mechanism
nobody built.

A batch whose `Technical design` is `none`, or whose document has no such field
because it was opened before the field existed, gives the plan nothing to start
from: no ruling of this story is a technical design ruling.
```

(b) Under `## Step 6 — Record Before the Merge`, replace

```markdown
- Copy every `Ruling:` line from SDD's closing "Rulings I made" message into
  the **Rulings log** of the story document. The list is exhaustive.
```

with

```markdown
- Copy every `Ruling:` line from SDD's closing "Rulings I made" message into
  the **Rulings log** of the story document. The list is exhaustive. A ruling
  that departs from the batch's `Technical design` is written as a
  `Technical design ruling:`.
```

(c) At the end of the `## Red Flags` table, add the rows:

```markdown
| "My plan departs only slightly from the design, no ruling needed" | Every departure is a `Technical design ruling:`. Closing rewrites the design from those lines; one missing leaves the batch describing a mechanism nobody built. |
| "`main`'s code contradicts the design, so the design wins" | The design only guides. Where `main`'s code departed from it, the plan starts from the code. |
```

- [ ] **Step 4: Run the guards to verify they pass**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-cross-references.sh | grep FAIL`
Expected: no output.

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: le plan d'une story part de la conception technique de son lot

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 5: la clôture réécrit la conception technique

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md` (front matter `description`, `## Overview`, new `### Rewrite the technical design`, `## Red Flags`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la forme `Technical design ruling:` (Task 4).

- [ ] **Step 1: Write the failing guards**

In `tests/test-skill-content.sh`, replace

```bash
    *"### Refuse to close on a flag"*"### Consolidate what the story documents left"*"### Release unconsumed reservations"*"### Withdraw the blocks no story delivered"*"### Set status: closed"*)
```

with

```bash
    *"### Refuse to close on a flag"*"### Consolidate what the story documents left"*"### Release unconsumed reservations"*"### Withdraw the blocks no story delivered"*"### Rewrite the technical design"*"### Set status: closed"*)
```

Right after the line `require closing-a-batch "released entries are not re-filed"      "do not re-file the released entries as fresh gaps"`, add:

```bash
# Closing rewrites the technical design into the mechanism delivered (spec
# section "Closing a batch"), from the stories' departures and the code.
require closing-a-batch "the design is rewritten into what was delivered" \
    "When the batch document's \`Technical design\` is not \`none\`, rewrite it to describe the mechanism the batch delivered."
require closing-a-batch "the rewrite starts from the stories' departures" \
    "Start from the \`Technical design ruling:\` lines in the \`Rulings log\` of every merged story, and check them against the code on \`main\`."
require closing-a-batch "the rewrite drops what served withdrawn blocks" \
    "Drop what served only the blocks you just withdrew."
require closing-a-batch "the code is the authority after closing" \
    "The rewritten text is true at closing. After closing, the code is the authority"
require closing-a-batch "a document without the field has nothing to rewrite" \
    "A batch document with no \`Technical design\` field was opened before the field existed, and has nothing to rewrite."
require closing-a-batch "the overview names the rewrite" \
    "*Rewrite the technical design* brings its design in line with what was delivered"
```

In `tests/test-skill-contracts.sh`, just before the final `exit $((FAILURES > 0))`, add:

```bash
# A story writes its departures from the design in a form closing reads back.
shared "the story and closing spell a technical design ruling alike" \
    "\`Technical design ruling:\`" \
    writing-a-user-story closing-a-batch
```

- [ ] **Step 2: Run them to verify they fail**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: FAIL on `closing-a-batch: the duties keep their order`, on the six guards above, and on `the story and closing spell a technical design ruling alike`.

- [ ] **Step 3: Write the text**

In `skills/closing-a-batch/SKILL.md`:

(a) In the front matter, replace the `description:` line with:

```yaml
description: Use when every user story of a batch is merged or abandoned - consolidates what the story documents left, releases reservations, withdraws undelivered blocks, rewrites the technical design, checks flags and closes the batch
```

(b) In `## Overview`, replace

```markdown
*Withdraw the blocks no story delivered* removes them from it, and *Set status: closed* flips its front matter.
```

with

```markdown
*Withdraw the blocks no story delivered* removes them from it, *Rewrite the technical design* brings its design in line with what was delivered, and *Set status: closed* flips its front matter.
```

(c) Right before the heading `### Set status: closed`, insert this section:

```markdown
### Rewrite the technical design

When the batch document's `Technical design` is not `none`, rewrite it to describe the mechanism the batch delivered. Start from the `Technical design ruling:` lines in the `Rulings log` of every merged story, and check them against the code on `main`.

Drop what served only the blocks you just withdrew.

The rewritten text is true at closing. After closing, the code is the authority: no later batch keeps this field in step.

A batch document with no `Technical design` field was opened before the field existed, and has nothing to rewrite.

The next design on this module reads this field, and a design the stories departed from would send it planning on a mechanism that does not exist.

```

(d) At the end of the `## Red Flags` table, add the row:

```markdown
| "The technical design was only the plan, it can stay as written" | Then the batch document describes a mechanism the stories departed from, and the next design on this module starts from it. Rewrite it from the `Technical design ruling:` lines and the code. |
```

- [ ] **Step 4: Run the whole suite**

Run: `bash tests/run-all.sh 2>&1 | grep -E "FAIL|passed|failed" | tail -20` (timeout: 10 minutes)
Expected: no `[FAIL]` line.

- [ ] **Step 5: Commit**

```bash
git add skills/closing-a-batch/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: la clôture réécrit la conception technique pour décrire le mécanisme livré

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

## Rulings log

## Observed drift
