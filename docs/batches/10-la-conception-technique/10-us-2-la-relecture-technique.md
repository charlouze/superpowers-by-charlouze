# La relecture technique Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Une skill neuve relit la conception technique et les contraintes d'un lot hors du contexte qui les a écrites, et l'ouverture d'un lot l'invoque entre la relecture de cohérence et la relecture du document de lot.

**Architecture:** Le plugin est fait de skills Markdown gardées par une suite structurelle en bash. La skill `rereading-a-technical-design` suit `rereading-a-spec` : un lecteur par lecture, un prompt de lecteur dans `references/`, des constats instruits puis soumis à l'humain, les mêmes conditions d'arrêt des tours, gardées identiques dans les deux skills. `writing-a-batch` l'invoque à une étape nouvelle de l'ouverture, et le README la liste et recommande les skills que ses lecteurs emploient. Chaque tâche écrit d'abord ses gardes, les voit échouer, puis écrit le texte qui les fait passer.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/10-la-conception-technique/README.md
**Sections:** Batch > The technical reread, Batch > Opening a batch
**Blocks:** D7, D8

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
- Chaque commit passe par le wrapper d'identité, et son message se termine par la ligne de co-auteur :

  ```bash
  bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
  <type>: <sujet>

  Co-Authored-By: Charlouze <me@charlouze.com>
  EOF
  ```

- La suite complète (`bash tests/run-all.sh`) prend plus de deux minutes ; en cours de tâche, lance seulement les fichiers de test que la tâche modifie, et la suite complète à la dernière étape de chaque tâche, avec un délai d'au moins dix minutes.

## Review Focus

- Un lot dont `Technical design` vaut `none` et qui déclare des contraintes : la relecture a lieu, et le lecteur lit les contraintes seules (Tâches 1 et 2).
- Un lot correctif, sans bloc : la relecture reçoit les specs telles que `main` les porte (Tâche 2).
- `clean-architecture` ou `software-design-philosophy` absente : le lecteur lit sans, le dit en tête de son rapport, et l'humain l'apprend (Tâche 1).
- Un constat qui révèle un comportement observable qu'aucune spec ne décrit : il est soumis à l'humain, jamais corrigé en silence (Tâche 1).
- La renumérotation de l'ouverture : aucun renvoi ne désigne encore l'ancienne étape 6 ou 7 (Tâche 2).

---

### Task 1: la skill `rereading-a-technical-design`

**Files:**
- Create: `skills/rereading-a-technical-design/SKILL.md`
- Create: `skills/rereading-a-technical-design/references/reader-prompt.md`
- Create: `tests/test-technical-reader-prompt.sh`
- Modify: `tests/test-skill-frontmatter.sh`, `tests/test-cross-references.sh`, `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Produces: la skill `supercharlouze:rereading-a-technical-design`, dont l'entrée est le document de lot et chaque spec que le lot touche, blocs appliqués, et dont la sortie est la conception technique et les contraintes révisées, avec ce que la relecture a trouvé. La Task 2 l'invoque sous ce nom exact.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-frontmatter.sh`, remplace la ligne `EXPECTED_SKILLS=` par :

```bash
EXPECTED_SKILLS="using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch rereading-a-spec rereading-a-technical-design"
```

et remplace tout le bloc qui commence au commentaire `# rereading-a-spec is a building block` et finit au `esac` de `stays invocable by the skills` par :

```bash
# The rereads are building blocks: only a skill invokes them. Each keeps its
# frontmatter, since a skill without one still loads and takes its first line as
# its description. It is hidden from the slash menu, and its description asks
# for an explicit call. `disable-model-invocation` would stop the calling skills
# from invoking it too.
for r in rereading-a-spec rereading-a-technical-design; do
    RFRONT="$(awk 'NR>1 && /^---$/{exit} NR>1{print}' "$REPO_ROOT/skills/$r/SKILL.md" 2>/dev/null || true)"
    case "$RFRONT" in
        *"user-invocable: false"*) pass "$r is hidden from the slash menu" ;;
        *)                          fail "$r is hidden from the slash menu" ;;
    esac
    case "$RFRONT" in
        *"description: Use only when a skill tells you to invoke $r"*)
            pass "$r asks for an explicit call" ;;
        *)  fail "$r asks for an explicit call" ;;
    esac
    case "$RFRONT" in
        *"disable-model-invocation"*) fail "$r stays invocable by the skills" ;;
        *)                            pass "$r stays invocable by the skills" ;;
    esac
done
```

Dans `tests/test-cross-references.sh`, remplace la ligne `KNOWN_SKILLS=` par :

```bash
KNOWN_SKILLS="using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch rereading-a-spec rereading-a-technical-design"
```

Dans `tests/test-skill-content.sh`, insère avant la ligne `# --- writing-a-batch: ending the opening and amendment reviews ---` :

```bash
# --- rereading-a-technical-design (spec section "The technical reread") ---
# Outside the context that wrote the design and the constraints.
require rereading-a-technical-design "the reread runs outside the writing context" "outside the context that wrote them, by readers dispatched as subagents"
require rereading-a-technical-design "it is invoked by a skill"          "It is invoked by another skill, never on a request of your human partner"
# Its input and its output say everything a caller needs, as for the spec reread.
require rereading-a-technical-design "input: the batch and its applied specs" "The input is the batch document, and each spec the batch touches with the batch's blocks applied"
require rereading-a-technical-design "the readers read main's code"     "The readers read the code as \`main\` carries it"
require rereading-a-technical-design "output: the design revised"        "the technical design and the constraints, revised: every finding worked through, and every ruling of your human partner applied"
require rereading-a-technical-design "output: what the reread found"     "what the reread found, or that it found nothing, written for a pull request body"
# One reader per reading, dispatched from a template.
require rereading-a-technical-design "a reader takes one reading"        "A reader takes one reading"
require rereading-a-technical-design "never two readings to one reader"  "never hand a reader two"
require rereading-a-technical-design "the dispatch is composed from a template" "skills/rereading-a-technical-design/references/reader-prompt.md"
require rereading-a-technical-design "every batch gets every reading"    "Every batch gets every reading"
require rereading-a-technical-design "a reading is pasted word for word" "pasted word for word into the slot the template leaves for it"
require rereading-a-technical-design "a reading is written for a bare reader" "written for a reader that has nothing else"
# The readings the batch document names: coverage, anchoring in the code,
# architecture, module design, robustness.
require rereading-a-technical-design "reading: coverage"       "**Does the design deliver what the batch promises?**"
require rereading-a-technical-design "reading: the code"       "**Does the design stand on the code as it is?**"
require rereading-a-technical-design "reading: architecture"   "**Does the design hold as an architecture?**"
require rereading-a-technical-design "reading: module design"  "**Are the modules this design draws deep?**"
require rereading-a-technical-design "reading: robustness"     "**How does this design fail?**"
require rereading-a-technical-design "coverage reports undescribed behaviour" "a behaviour the design would make observable to a user or a neighbouring module that no specification describes"
require rereading-a-technical-design "the code reading checks the constraints" "and a constraint the code already breaks"
require rereading-a-technical-design "robustness reports a constraint nobody can hold" "a constraint that a story could not hold"
# The skills the readers use are recommended, never required.
require rereading-a-technical-design "architecture names its skill"      "Use the \`clean-architecture\` skill if it is available to you"
require rereading-a-technical-design "module design names its skill"     "Use the \`software-design-philosophy\` skill if it is available to you"
require rereading-a-technical-design "a reader says it read without"     "read without it if it is not, and say so at the top of your report"
require rereading-a-technical-design "the skills are invoked only if present" "invoke their skill only if present"
require rereading-a-technical-design "the human hears of a missing skill" "tell your human partner that the skill is not available, so they can install it"
case "$(body_flat "$REPO_ROOT/skills/rereading-a-technical-design/SKILL.md" 2>/dev/null || true)" in
    *[Ff]"ive readings"*|*[Ff]"ive readers"*|*"of the five"*)
        fail "rereading-a-technical-design: no sentence counts the readings" ;;
    *)  pass "rereading-a-technical-design: no sentence counts the readings" ;;
esac
# Findings are instructed, and what changes a decision goes to the human, who
# approved the design.
require rereading-a-technical-design "findings are instructed, not forwarded" "You instruct the findings; you do not forward them"
require rereading-a-technical-design "a fix keeps what the design decides" "Fix each one on the technical design or the constraints without changing what they decide, or put it to your human partner when fixing it would"
require rereading-a-technical-design "an undescribed behaviour always goes up" "A behaviour the design would make observable that no specification describes is always put to your human partner"
require rereading-a-technical-design "a round runs on the revised text"  "A round runs on the revised text"
require rereading-a-technical-design "the rounds have stop conditions"   "These stop the rounds"
require rereading-a-technical-design "the reread does not replace the review" "prepares the review of the pull request that carries the design, it does not replace it"
```

Dans `tests/test-skill-contracts.sh`, dans l'appel `absent "no skill rereads with fresh eyes"`, remplace la ligne de ses skills par :

```bash
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module rereading-a-spec rereading-a-technical-design
```

Dans l'appel `absent "no skill states the plugin's own language"`, remplace de même la ligne de ses skills par :

```bash
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch rereading-a-spec rereading-a-technical-design
```

Puis insère avant la ligne finale `exit $((FAILURES > 0))` :

```bash
# Both rereads dispatch their readers, gather them and close their rounds the
# same way. One assertion per rule over both skills, so neither drifts alone.
shared "both rereads dispatch on the conductor's model" \
    "Dispatch every reader on the model you run on, and name that model in the dispatch" \
    rereading-a-spec rereading-a-technical-design
shared "both rereads wait for every reader" \
    "Every reader returns before anything goes up. Wait for all of them and gather their findings, never a running report" \
    rereading-a-spec rereading-a-technical-design
shared "both rereads open a round only on an unread state" \
    "A fresh round only on a state the reread has not read." \
    rereading-a-spec rereading-a-technical-design
shared "both rereads close a stuck wording" \
    "Two rounds stuck on the same clause close the question of its wording." \
    rereading-a-spec rereading-a-technical-design
shared "both rereads stop on declined findings" \
    "A round returning only findings already examined and declined is one round too many." \
    rereading-a-spec rereading-a-technical-design

# The technical reread knows none of the skills that invoke it.
absent "the technical reread names no skill that invokes it" \
    "supercharlouze:|adopting-a-module|writing-a-batch|calling skill" \
    rereading-a-technical-design
```

Crée `tests/test-technical-reader-prompt.sh` :

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-technical-reader-prompt"

# The technical reader prompt is read by a subagent instead of the skill, so
# nothing else guards it. `test-cross-references.sh` proves the skill's citation
# of it resolves; these assertions are about what it says once opened.
PROMPT="$REPO_ROOT/skills/rereading-a-technical-design/references/reader-prompt.md"

if [ -f "$PROMPT" ]; then
    pass "the technical reader prompt exists"
else
    fail "the technical reader prompt exists"
    exit 1
fi

# The calling skill keeps no reader prompt of its own, which would drift.
if [ -e "$REPO_ROOT/skills/writing-a-batch/references/technical-reader-prompt.md" ]; then
    fail "the calling skill keeps no technical reader prompt of its own"
else
    pass "the calling skill keeps no technical reader prompt of its own"
fi

# Flattened so a phrase matches regardless of how the prose is wrapped.
FLAT="$(tr '\n' ' ' < "$PROMPT" | tr -s ' ')"

has() {
    local label="$1" needle="$2"
    case "$FLAT" in
        *"$needle"*) pass "$label" ;;
        *)           fail "$label" ;;
    esac
}

has "one reader carries one reading"        "One reader, one reading, one batch"
has "the reading comes from the skill"      "one of the readings that \`## The Readings\` of the skill states, pasted word for word from there"
has "the batch document is the object"      "**The document you are evaluating:**"
# The reader evaluates two sections, and a `none` gives it nothing there.
has "the design is the two sections"        "What you evaluate is its \`Technical design\` section and its \`Constraints\` section, which this prompt calls the design"
has "a none section gives nothing"          "A section that reads \`none\` gives you nothing to evaluate"
has "the rest says what the batch promises" "The rest of the document says what the batch promises: read it for that"
# The applied specs and the code are what the design is read against, never
# what is evaluated.
has "the applied specs are handed over"     "**The specifications, with the batch's changes applied:**"
has "the specs are not evaluated"           "Report nothing about them: your findings are about the design"
has "the code is handed over"               "**The code as it stands today:**"
has "the code is not evaluated"             "Report nothing about the code itself: your findings are about the design"
has "a reader loads no unnamed skill"       "Load no skill your reading does not name"
has "everything needed is in the prompt"    "Everything you need is in this prompt"
has "a finding quotes its passage"          "the passage it bears on, quoted with the section it"
has "an empty result is reported"           "Return \"nothing found\" when you found nothing"
has "a reader revises nothing"              "Do not revise the design, and do not modify the code"
has "a reader dispatches nothing"           "Do not dispatch subagents"

# --- the prompt restates no reading ---
# The readings live in `## The Readings` of the skill. A copy pasted in here
# would pass every assertion above while drifting the day that section changes.
BAD=""
while IFS= read -r needle; do
    [ -n "$needle" ] || continue
    case "$FLAT" in
        *"$needle"*) BAD="$BAD '$needle'" ;;
    esac
done <<'NEEDLES'
deliver what the batch promises
stand on the code as it is
hold as an architecture
modules this design draws deep
How does this design fail
NEEDLES

if [ -z "$BAD" ]; then
    pass "the prompt restates no reading"
else
    fail "the prompt restates no reading (found:$BAD)"
fi

case "$FLAT" in
    *[Ff]"ive readings"*|*"of the five"*)
        fail "the prompt does not count the readings" ;;
    *)  pass "the prompt does not count the readings" ;;
esac

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run them to verify they fail**

Run: `bash tests/test-skill-frontmatter.sh; bash tests/test-skill-content.sh | grep rereading-a-technical-design; bash tests/test-skill-contracts.sh | grep -E 'both rereads|technical reread'; bash tests/test-technical-reader-prompt.sh`
Expected: FAIL sur chaque garde de `rereading-a-technical-design`, et `test-technical-reader-prompt.sh` s'arrête sur `the technical reader prompt exists`.

- [ ] **Step 3: Write the text**

Crée `skills/rereading-a-technical-design/SKILL.md` :

````markdown
---
name: rereading-a-technical-design
description: Use only when a skill tells you to invoke rereading-a-technical-design, never on a request to reread a text - dispatches one reader per reading, outside the context that wrote the design, and returns the technical design and constraints revised
user-invocable: false
---

# Rereading a Technical Design

## Overview

A batch's technical design and constraints are reread outside the context that
wrote them, by readers dispatched as subagents. The context that wrote a design
rereads its own intentions, and the file it assumed exists is what it cannot
see.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the rereading-a-technical-design skill to have this technical design reread."

## Input and Output

The input is the batch document, and each spec the batch touches with the
batch's blocks applied.

The readers read the code as `main` carries it. Hand them the root of a working
tree whose code is `origin/main`'s: a branch started from `origin/main` that
changes only documents has one.

When the rounds are over, return:

- the technical design and the constraints, revised: every finding worked
  through, and every ruling of your human partner applied;
- what the reread found, or that it found nothing, written for a pull request
  body.

## The Readers

A reader takes one reading. Each reading asks for its own motion, a comparison
with what the batch promises, a search through the code, a judgement of
structure or a reasoning about failures, and one reader holding several does the
cheapest of them and returns. So every reading gets its own reader, and they are
dispatched together.

Compose each dispatch from
`skills/rereading-a-technical-design/references/reader-prompt.md`, which carries
what a reader gets and what it must return.

Dispatch every reader on the model you run on, and name that model in the
dispatch: a harness may give subagents a lighter default, and a lighter reader
misses findings the review then has to find.

## The Readings

Each reading below is the text a reader's prompt carries, pasted word for word
into the slot the template leaves for it. It is written for a reader that has
nothing else: never abbreviate it, and never hand a reader two.

Every batch gets every reading.

> **Does the design deliver what the batch promises?** The batch promises the
> rules its blocks write into the specifications or, when it has no block, what
> its `Scope` says it delivers. Find, for each promise, the part of the design
> that makes the code hold it. Report a promise no part of the design delivers,
> and a behaviour the design would make observable to a user or a neighbouring
> module that no specification describes.

> **Does the design stand on the code as it is?** Check against the code every
> file, unit, name and test that the design assumes exists, and every one it says
> it changes. Report what does not exist, what exists elsewhere or under another
> name, a structure already in place that the design ignores or duplicates, what
> the design would have to change without saying so, and a constraint the code
> already breaks.

> **Does the design hold as an architecture?** Use the `clean-architecture` skill
> if it is available to you, and read without it if it is not, and say so at the
> top of your report. Report a unit the design draws that mixes responsibilities,
> a boundary it crosses, and a dependency that points from a business rule
> towards a mechanism.

> **Are the modules this design draws deep?** Use the
> `software-design-philosophy` skill if it is available to you, and read without
> it if it is not, and say so at the top of your report. Report a module whose
> interface is nearly as complex as what it hides, knowledge that leaks from one
> module into another, a method that only passes its arguments on, and complexity
> the design adds without stating why.

> **How does this design fail?** Report an error the design does not handle, a
> behaviour its testing strategy leaves untested, a risk it takes without naming
> it, such as a migration, a concurrent access, a compatibility break or a cost
> in performance, and a constraint that a story could not hold.

The architecture and module readings invoke their skill only if present. This
plugin recommends `clean-architecture` and `software-design-philosophy` and
depends on them nowhere, so the absence of one changes how its reader reads,
never whether the reading happens.

When a reader reports that it read without its skill, tell your human partner
that the skill is not available, so they can install it.

## Findings and Rounds

Every reader returns before anything goes up. Wait for all of them and gather
their findings, never a running report: a partial report gets findings ruled on
that the next reader displaces, and asks for the same ruling twice.

You instruct the findings; you do not forward them. Fix each one on the
technical design or the constraints without changing what they decide, or put it
to your human partner when fixing it would: they approved what the design
decides.

A behaviour the design would make observable that no specification describes is
always put to your human partner. It calls for a block, or it leaves the design.

Then put to your human partner what you changed and what you could not settle,
and apply their rulings. Forwarding raw findings makes your human partner
arbitrate a draft, which is the work the review exists to spare them.

A round runs on the revised text. These stop the rounds, and without them they
chain indefinitely:

- **A fresh round only on a state the reread has not read.** A revision that
  adds a sentence produces one, and moving a sentence is an addition, its reach
  changing with its place. A revision that takes a sentence out produces one
  too, but only where something leaned on what left: coherence is a property of
  the state, not of the text that remains, so a removal reopens what depended on
  it and nothing else.
- **Two rounds stuck on the same clause close the question of its wording.**
  Take the clause out, or put it to your human partner.
- **A round returning only findings already examined and declined is one round
  too many.** What is left is a disagreement of judgment, and judgment is
  settled at the review.
- **The reread prepares the review of the pull request that carries the design,
  it does not replace it.**

## Red Flags

| Thought | Reality |
|---|---|
| "I wrote this design, I can reread it myself" | The context that wrote it rereads its intentions, not its text. Dispatch readers outside it. |
| "One reader can take every reading, it is cheaper" | A reader holding several readings does the cheapest and returns. One reader per reading. |
| "The reading is long, I'll summarise it in the prompt" | The reader has nothing else. Paste it word for word. |
| "This reader is done, I'll put its findings up now" | The next reader may displace them. Wait for every reader. |
| "This finding is right, I'll rework the design around it" | Your human partner approved what the design decides. Fix the wording, or put the change to them. |
| "This behaviour is small, the design can carry it without a block" | What a user or a neighbouring module would observe needs a block. Put it to your human partner. |
| "One more round, the design can still improve" | The stop conditions close the rounds. Two rounds on the same clause end the question of its wording: take it out or put it to your human partner. |
````

Crée `skills/rereading-a-technical-design/references/reader-prompt.md` :

````markdown
# Technical Design Reread — Reader Prompt

One reader, one reading, one batch. Fill every `<…>` slot before dispatching: a
slot left as written is a reader with nothing to read.

The reading is one of the readings that `## The Readings` of the skill states,
pasted word for word from there. This file restates none of them: a second copy
here would drift from that section.

---

You are reading the technical design and the constraints of one batch of work.
You did not write them, and you are not being asked to improve them.

**The document you are evaluating:** `<path to the batch document>`

What you evaluate is its `Technical design` section and its `Constraints`
section, which this prompt calls the design. A section that reads `none` gives
you nothing to evaluate. The rest of the document says what the batch promises:
read it for that.

**The specifications, with the batch's changes applied:** `<path to each specification the batch touches, with its blocks applied>`

They state what the code must do once the batch is delivered. Report nothing
about them: your findings are about the design.

**The code as it stands today:** `<root of a working tree whose code is origin/main's>`

Read what your reading needs of it. Report nothing about the code itself: your
findings are about the design.

**Your reading, and only yours:**

<the one reading, word for word from `## The Readings` of the skill>

**Load no skill your reading does not name.** Everything you need is in this
prompt. Going to read the skill that dispatched you would put the other readers'
readings in front of you, and a reader holding several does the cheapest of them
and returns.

**Return, for each finding:** the passage it bears on, quoted with the section it
sits in; what is wrong with that passage under your reading; and how sure you
are. Return "nothing found" when you found nothing: an empty report and a reader
that failed look the same to whoever reads it.

Do not revise the design, and do not modify the code: naming what is wrong is
your job, deciding what replaces it is not. Do not dispatch subagents.
````

- [ ] **Step 4: Run the guards to verify they pass**

Run: `bash tests/test-skill-frontmatter.sh && bash tests/test-cross-references.sh && bash tests/test-skill-content.sh && bash tests/test-skill-contracts.sh && bash tests/test-technical-reader-prompt.sh && bash tests/test-suite-integrity.sh`
Expected: PASS partout.

Puis la suite complète : `bash tests/run-all.sh` (délai d'au moins dix minutes).
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills/rereading-a-technical-design tests/test-technical-reader-prompt.sh tests/test-skill-frontmatter.sh tests/test-cross-references.sh tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: une skill relit la conception technique et les contraintes d'un lot

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 2: l'ouverture d'un lot passe par la relecture technique

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## Opening, in Order`, `## The Coherence Reread`, une section neuve `## The Technical Reread`, `## Opening the Pull Request`, `## Red Flags`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la skill `supercharlouze:rereading-a-technical-design` (Task 1), et ses lectures, dont aucune ne doit être recopiée ici.
- Produces: l'étape 6 de l'ouverture et la section `## The Technical Reread` de `writing-a-batch`.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh`, dans le bloc `# --- writing-a-batch: the ordered opening, and the two rereads it places ---`, remplace son titre par :

```bash
# --- writing-a-batch: the ordered opening, and the rereads it places ---
```

remplace les lignes `require writing-a-batch "the document reread is step 6"` à `require writing-a-batch "two rereads, two objects"` incluses par :

```bash
require writing-a-batch "the technical reread is step 6"        "6. **Put the technical design and the constraints through the technical reread** — skipped when the batch has neither (\`The Technical Reread\`)."
require writing-a-batch "the document reread is step 7"         "7. **Reread the whole batch document**"
require writing-a-batch "the pull request is step 8"            "8. **Open the pull request** from \`batch/NN-<slug>\`"
require writing-a-batch "the document reread is named where it runs" "**The batch-document reread**, step 7, comes after the technical reread"
require writing-a-batch "each reread has its own object"        "The rereads are steps 5, 6 and 7, and each has its own object"
require writing-a-batch "the technical reread's object is stated" "The technical reread bears on the technical design and the constraints, against the specs with the blocks applied and against the code on \`main\`."
```

et remplace la ligne `require writing-a-batch "merging them strands a corrective batch"` par :

```bash
require writing-a-batch "merging them strands a corrective batch" "leaving a corrective batch, which has no blocks, without a reread of its document"
```

Dans le commentaire du bloc `# --- writing-a-batch: the coherence reread`, remplace `The batch-document reread of step 6 is` par `The batch-document reread of step 7 is`, et insère avant la ligne `# --- rereading-a-spec (spec sections "Module adoption" and "The coherence reread") ---` :

```bash
# --- writing-a-batch: the technical reread (spec section "The technical reread") ---
# The step exists, what it skips, what it hands the shared reread, where its
# revisions go, and the declaration that makes it observable.
require writing-a-batch "the design goes through the technical reread" "the technical design and the constraints go through the **technical reread**"
require writing-a-batch "a batch with neither skips it"         "A batch whose \`Technical design\` and \`Constraints\` both read \`none\` skips this step"
require writing-a-batch "the batch goes to the technical reread" "Invoke \`supercharlouze:rereading-a-technical-design\` with the batch document and each spec the batch touches"
require writing-a-batch "a spec no block targets goes as it is" "the applied copy the coherence reread built, or the spec itself when no block targets it"
require writing-a-batch "revisions go back into the design"     "Carry every revision it returns back into \`Technical design\` and \`Constraints\`"
require writing-a-batch "the pull request body says what it found" "The body of the pull request that runs it, opening or amendment, says what it found, or that it found nothing"
require writing-a-batch "the red flag sends the design to the reread" "Invoke \`supercharlouze:rereading-a-technical-design\`. |"
```

Dans `tests/test-skill-contracts.sh`, insère avant la ligne finale `exit $((FAILURES > 0))` :

```bash
# The readings of the technical reread live in its skill; the batch skill that
# invokes it carries none of them.
absent "the batch skill carries no technical reading of its own" \
    "deliver what the batch promises|stand on the code as it is|hold as an architecture|modules this design draws deep|How does this design fail" \
    writing-a-batch

# The opening now places more than two rereads; the former count must not survive.
absent "the opening counts no rereads" \
    "[Tt]wo rereads|[Tt]hree rereads" \
    writing-a-batch
```

- [ ] **Step 2: Run them to verify they fail**

Run: `bash tests/test-skill-content.sh | grep writing-a-batch | grep FAIL; bash tests/test-skill-contracts.sh | grep -E 'technical reading|counts no rereads'`
Expected: FAIL sur chaque garde nouvelle ou modifiée, et sur `the opening counts no rereads` ; `the batch skill carries no technical reading of its own` passe déjà.

- [ ] **Step 3: Write the text**

Dans `skills/writing-a-batch/SKILL.md`, section `## Opening, in Order`, remplace les étapes 6 et 7 :

```markdown
6. **Reread the whole batch document** (`Opening the Pull Request`).
7. **Open the pull request** from `batch/NN-<slug>`, in the same section.
```

par :

```markdown
6. **Put the technical design and the constraints through the technical
   reread** — skipped when the batch has neither (`The Technical Reread`).
7. **Reread the whole batch document** (`Opening the Pull Request`).
8. **Open the pull request** from `batch/NN-<slug>`, in the same section.
```

et remplace le paragraphe qui suit la liste :

```markdown
**The two rereads are steps 5 and 6, and they have different objects.** The
coherence reread bears on the blocks and on the state they produce, read whole.
The batch-document reread bears on the whole document: `Scope`, `Spec delta`,
`Technical design`, `Constraints`, `Feature flag`. Merge them and the second is
the one that disappears, leaving a corrective batch, which has no blocks, with
no reread at all.
```

par :

```markdown
**The rereads are steps 5, 6 and 7, and each has its own object.** The
coherence reread bears on the blocks and on the state they produce, read whole.
The technical reread bears on the technical design and the constraints, against
the specs with the blocks applied and against the code on `main`. The
batch-document reread bears on the whole document: `Scope`, `Spec delta`,
`Technical design`, `Constraints`, `Feature flag`. Merge the batch-document
reread into another and it disappears wherever that one is skipped, leaving a
corrective batch, which has no blocks, without a reread of its document.
```

Section `## The Coherence Reread`, remplace `batch still owes, it owes at step 6 — the batch-document reread` par `batch still owes, it owes at step 7 — the batch-document reread`.

Insère, entre la fin de `## The Coherence Reread` (sa phrase `A reread nobody can see from the pull request is a practice again, not a rule.`) et `## Opening the Pull Request`, la section :

```markdown
## The Technical Reread

After the coherence reread, the technical design and the constraints go through
the **technical reread**, which reads them against the specs with the blocks
applied and against the code on `main`.

**A batch whose `Technical design` and `Constraints` both read `none` skips this
step.**

Invoke `supercharlouze:rereading-a-technical-design` with the batch document and
each spec the batch touches: the applied copy the coherence reread built, or the
spec itself when no block targets it.

Carry every revision it returns back into `Technical design` and `Constraints`.

The body of the pull request that runs it, opening or amendment, says what it
found, or that it found nothing.
```

Section `## Opening the Pull Request`, remplace :

```markdown
**The batch-document reread**, step 6, comes after the coherence reread and
bears on the whole document.
```

par :

```markdown
**The batch-document reread**, step 7, comes after the technical reread and
bears on the whole document.
```

Section `## Red Flags`, ajoute après la ligne `| "I wrote these blocks, I can reread them myself" | … |` :

```markdown
| "I wrote this design, I can reread it myself" | The context that argued it into existence rereads its intentions, not its text. Invoke `supercharlouze:rereading-a-technical-design`. |
```

Enfin, vérifie qu'aucun renvoi ne désigne l'ancienne numérotation :

Run: `grep -n "step 6\|step 7\|step 8" skills/writing-a-batch/SKILL.md`
Expected: seulement `step 7, comes after the technical reread` et `it owes at step 7`.

- [ ] **Step 4: Run the guards to verify they pass**

Run: `bash tests/test-skill-content.sh && bash tests/test-skill-contracts.sh && bash tests/test-cross-references.sh`
Expected: PASS partout.

Puis la suite complète : `bash tests/run-all.sh` (délai d'au moins dix minutes).
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: l'ouverture d'un lot fait relire sa conception technique

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 3: le README liste la relecture technique et recommande ses skills

**Files:**
- Modify: `README.md` (`## Skills`, `## Requirements`)
- Test: `tests/test-cross-references.sh`

**Interfaces:**
- Consumes: le nom `supercharlouze:rereading-a-technical-design` (Task 1), et les noms `clean-architecture` et `software-design-philosophy` que ses lectures emploient.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-cross-references.sh`, insère après le `esac` de `the README row of rereading-a-spec rules out direct use` :

```bash
# The README row of rereading-a-technical-design, like the spec reread's, says it
# is not for direct use and names none of the skills that invoke it.
TROW="$(grep -F '`supercharlouze:rereading-a-technical-design`' "$REPO_ROOT/README.md" || true)"
case "$TROW" in
    *"writing-a-batch"*|*"invoked by"*)
        fail "the README row of rereading-a-technical-design names no caller" ;;
    *)  pass "the README row of rereading-a-technical-design names no caller" ;;
esac
case "$TROW" in
    *"Never directly"*) pass "the README row of rereading-a-technical-design rules out direct use" ;;
    *)                  fail "the README row of rereading-a-technical-design rules out direct use" ;;
esac

# The rereads use three skills when they are installed; the README recommends
# them all, since nothing else tells a user they exist.
for s in domain-driven-design clean-architecture software-design-philosophy; do
    if grep -q "\`$s\`" "$REPO_ROOT/README.md"; then
        pass "the README recommends $s"
    else
        fail "the README recommends $s"
    fi
done
```

- [ ] **Step 2: Run them to verify they fail**

Run: `bash tests/test-cross-references.sh`
Expected: FAIL sur `rules out direct use` pour `rereading-a-technical-design`, et sur les trois `the README recommends`.

- [ ] **Step 3: Write the text**

Dans `README.md`, section `## Skills`, ajoute après la ligne de `supercharlouze:rereading-a-spec` :

```markdown
| `supercharlouze:rereading-a-technical-design` | Never directly — a building block the other skills invoke to have a batch's technical design reread |
```

Section `## Requirements`, insère après la ligne `Projects organised as git submodules are not supported.` et avant le paragraphe `**Strongly recommended: give the agent a git identity of its own.**` :

```markdown
**Recommended: the `domain-driven-design`, `clean-architecture` and
`software-design-philosophy` skills.** The rereads use them when they are
installed, and read without them otherwise.
```

- [ ] **Step 4: Run the guards to verify they pass**

Run: `bash tests/test-cross-references.sh`
Expected: PASS partout.

Puis la suite complète : `bash tests/run-all.sh` (délai d'au moins dix minutes).
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add README.md tests/test-cross-references.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
docs: le README recommande les skills qu'emploient les relectures

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

## Rulings log

- Ruling: les conditions d'arrêt des tours et les règles de dispatch sont recopiées dans les deux skills de relecture plutôt que renvoyées de l'une à l'autre — le document de lot demande les mêmes conditions d'arrêt, et une skill ne charge pas l'autre ; des gardes `shared` les tiennent identiques — si c'est faux, une règle vit en deux copies que seules les gardes relient.
- Ruling: une seule vague corrige le constat important de la relecture finale et quatre mineurs — chacun tient en une garde et une phrase — un correctif faux alourdit la relecture ciblée.
- Ruling: la phrase « The architecture and module readings invoke their skill only if present » reste, malgré la relecture finale qui la jugeait redondante — elle est le pendant de celle de `rereading-a-spec`, et la couper dans une seule des deux skills les ferait diverger — si c'est faux, une phrase redondante reste dans la skill.
- Technical design ruling: le README recommande `domain-driven-design` avec `clean-architecture` et `software-design-philosophy` — la conception supposait qu'il recommandait déjà `domain-driven-design`, alors que seule `rereading-a-spec` le disait — si c'est faux, le README recommande une skill de plus que prévu.
- Technical design ruling: le lecteur reçoit le document de lot entier, et non la seule conception et les seules contraintes — la lecture de couverture a besoin de ce que le lot promet, que portent ses blocs ou, sans bloc, son `Scope` — si c'est faux, un lecteur lit des sections qu'il n'évalue pas.
- Technical design ruling: la lecture de couverture rapporte aussi un comportement observable qu'aucune spec ne décrit, et la skill le soumet toujours à l'humain — ce qui est observable va dans un bloc, jamais dans `Technical design` — si c'est faux, une lecture rapporte ce qu'une autre relecture aurait trouvé.
- Technical design ruling: la lecture d'ancrage rapporte une contrainte que le code enfreint déjà, et celle de robustesse une contrainte qu'une story ne pourrait pas tenir — la relecture technique relit les contraintes autant que la conception, et la conception ne les attribuait à aucune lecture — si c'est faux, deux lectures portent un objet que la conception ne leur donnait pas.
- Technical design ruling: la relecture technique rend les blocs que l'humain juge nécessaires, et `writing-a-batch` les écrit dans `Spec delta` puis refait passer le delta par la relecture de cohérence — sans cela un bloc décidé à l'étape 6 ouvrait le lot sans avoir été relu — si c'est faux, une relecture de cohérence de plus à l'ouverture.

## Observed drift
