# L'ADR Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Le flux sait ce qu'est un ADR, à quelles conditions une décision technique en devient un, et l'écrit par une skill interne que le changement borné invoque.

**Architecture:** Une skill interne neuve, `recording-a-decision`, écrit ou réécrit un ADR que l'humain a décidé, après l'avoir confronté aux specs et aux autres ADR, selon un gabarit placé dans ses `references/`. `using-batches` porte la définition de l'ADR et le texte anglais de référence de ses conditions, donne l'ADR pour sortie à la décision technique que le test de l'autre implémentation éjecte, et fait du changement borné le chemin qui écrit, réécrit et supprime des ADR. Chaque norme a sa garde dans `tests/`, écrite avant le texte.

**Tech Stack:** Markdown pour les skills et le `README.md`, Bash pour les gardes de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/12-les-adr/README.md
**Sections:** The model, Architecture decision records, Bounded change
**Blocks:** D1, D2, D3

## Global Constraints

Contraintes du lot, recopiées mot pour mot :

> `D1`, `D2` et `D3` sont transcrits par la même story, avant tout autre bloc sauf
> `D14` et `D20`.
>
> `D4` à `D12` sont transcrits par la même story.
>
> `D13`, `D15` et `D16` sont transcrits par la même story.
>
> `D17`, `D18` et `D19` sont transcrits par la même story, après `D15`.
>
> La story qui transcrit `D2` livre la skill `recording-a-decision`.
>
> Toutes les stories emploient tels quels le répertoire `docs/adr/` et la skill
> `recording-a-decision`.

Gel du fichier de spec :

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

Règle d'autorité :

> When the batch and the spec contradict each other, the spec wins — without
> exception and without deliberation. Implement what the spec says, record a
> `Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
> agent's.

Règles de concision :

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

Condition d'arrêt sur une contrainte qui ne peut pas être tenue :

> If, while conducting a story, you discover that a constraint of its batch cannot be held, stop and put the constraint to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

Règles du dépôt, qui valent pour chaque tâche :

- Une skill, un test et le `README.md` sont entièrement en anglais.
- Une skill ne cite jamais une section de `docs/specs/supercharlouze.md`. Une section qu'une skill nomme entre parenthèses est l'un de ses propres titres.
- Chaque norme qu'une skill énonce a sa garde dans `tests/`, écrite avant le texte et vue rouge.
- Chaque phrase d'une skill change ce qu'un agent fait. Pas de réfutation d'une version disparue, pas de cas particulier que la règle générale couvre déjà, pas de gras qui hiérarchise, pas de tiret à la place d'une virgule, pas de liste qui annonce combien d'éléments elle tient.
- Une règle est écrite en entier à un seul endroit et pointée ailleurs.
- Cette story ne livre que ce qui réalise `D1`, `D2` et `D3`. Aucun texte ne dit que le code tient les ADR, qu'une story ou un changement borné soumet une décision à l'humain, qu'un lot écrit un ADR à son ouverture ou par un amendement, ni que la conception lit `docs/adr/` : ces règles appartiennent aux stories suivantes.
- Tout commit passe par `bash ~/.config/github-app/as-agent.sh git -C <worktree> commit …` et se termine par la seule ligne d'attribution `Co-Authored-By: Charlouze <me@charlouze.com>`.
- La suite se lance par `bash tests/run-all.sh` depuis le worktree, avec un délai de dix minutes.

## Review Focus

- Un ADR qui contredit une spec : `recording-a-decision` le dit à l'humain et n'écrit rien. Gardé en tâche 1.
- Une décision observable à la frontière d'un module : même arrêt. Gardé en tâche 1.
- Un gabarit qui regagnerait une date ou un statut. Gardé en tâche 1.
- Une condition d'ADR reformulée dans `using-batches` : la story suivante la recopie mot pour mot. Gardé en tâche 2.
- Un changement borné qui écrirait un ADR sans passer par `recording-a-decision`. Gardé en tâche 2.

---

### Task 1: La skill `recording-a-decision`

**Files:**
- Create: `skills/recording-a-decision/SKILL.md`
- Create: `skills/recording-a-decision/references/adr-template.md`
- Modify: `README.md` (table `## Skills`)
- Test: `tests/test-skill-frontmatter.sh`, `tests/test-cross-references.sh`, `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: rien.
- Produces: la skill `supercharlouze:recording-a-decision` et le chemin `skills/recording-a-decision/references/adr-template.md`, que la tâche 2 nomme.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-frontmatter.sh` :

- ajouter `recording-a-decision` à la fin de `EXPECTED_SKILLS` ;
- remplacer `for r in rereading-a-spec rereading-a-technical-design; do` par `for r in rereading-a-spec rereading-a-technical-design recording-a-decision; do` ;
- remplacer le début du commentaire qui précède cette boucle, `# The rereads are building blocks: only a skill invokes them.`, par `# The internal skills are building blocks: only a skill invokes them.`.

Dans `tests/test-cross-references.sh` :

- ajouter `recording-a-decision` à la fin de `KNOWN_SKILLS` ;
- ajouter ce bloc après le bloc de gardes de la ligne `rereading-a-technical-design` du `README` :

```bash
# The README row of recording-a-decision, like the rereads', says it is not for
# direct use and names none of the skills that invoke it.
DROW="$(grep -F '`supercharlouze:recording-a-decision`' "$REPO_ROOT/README.md" || true)"
case "$DROW" in
    *"writing-a-batch"*|*"writing-a-user-story"*|*"invoked by"*)
        fail "the README row of recording-a-decision names no caller" ;;
    *)  pass "the README row of recording-a-decision names no caller" ;;
esac
case "$DROW" in
    *"Never directly"*) pass "the README row of recording-a-decision rules out direct use" ;;
    *)                  fail "the README row of recording-a-decision rules out direct use" ;;
esac
```

Dans `tests/test-skill-content.sh` :

- dans les deux boucles `for s in adopting-a-module writing-a-batch writing-a-user-story closing-a-batch; do` du haut du fichier (règle de langue, renvoi à la concision), ajouter `recording-a-decision` à la fin de la liste ;
- ajouter ce bloc juste avant la ligne `# --- writing-a-batch: ending the opening and amendment reviews ---` :

```bash
# --- recording-a-decision ---
# A building block: it writes the ADR its human partner decided, and decides
# nothing itself.
require recording-a-decision "it is invoked by a skill" "It is invoked by another skill, never on a request of your human partner"
require recording-a-decision "an ADR is a file directly in docs/adr" "a \`.md\` file placed directly in \`docs/adr/\`"
require recording-a-decision "the human has decided before it runs" "Your human partner has decided it before this skill runs"
require recording-a-decision "a deletion does not come through it" "Deleting an ADR, and correcting its text without changing its decision, do not come through this skill"
require recording-a-decision "a correction that changes the decision is a rewrite" "A correction that changes the decision is a rewrite, and does."
require recording-a-decision "input: the decision and its reason" "the decision and its reason;"
require recording-a-decision "input: the ADR to rewrite" "the path of the ADR to rewrite, when there is one;"
require recording-a-decision "input: the spec copies handed over" "copies of specs to read in place of the files under \`docs/specs/\`, when the skill that invokes this one hands some"
require recording-a-decision "output: the path or the ruling" "Return the path of the file written, or what your human partner ruled when nothing is written"
require recording-a-decision "it works on the current branch" "Follow these steps on the branch you are working on"
require recording-a-decision "step 1 reads the ADRs and the specs" "1. Read every ADR in \`docs/adr/\` and every spec in \`docs/specs/\`"
require recording-a-decision "a handed copy replaces its spec" "Where you were handed a copy of a spec, read the copy"
require recording-a-decision "step 2 stops on a contradiction or a boundary rule" "2. When the decision contradicts a spec or another ADR, or is observable at a module's boundary, say so to your human partner and write nothing until they have ruled"
require recording-a-decision "step 3 writes from the template" "3. Write the file from \`skills/recording-a-decision/references/adr-template.md\`, creating \`docs/adr/\` if it does not exist"
require recording-a-decision "a rewrite happens in place" "A rewrite replaces the text at the path you were given"
require recording-a-decision "an ADR carries no date and no status" "An ADR carries no date and no status"
require recording-a-decision "it does not commit" "Do not commit"
require recording-a-decision "a rewrite's commit says why" "The commit that rewrites an ADR says why"
require recording-a-decision "red flag: wording around a contradiction" "| \"The decision contradicts a spec, I'll word the ADR so it fits\" |"
require recording-a-decision "red flag: a status line" "| \"Every ADR has a date and a status, I'll add them\" |"
require recording-a-decision "red flag: superseding" "| \"The old decision is worth keeping, I'll mark it superseded\" |"

# The template carries neither a date nor a status, in any spelling.
ADR_TEMPLATE="$REPO_ROOT/skills/recording-a-decision/references/adr-template.md"
if [ ! -f "$ADR_TEMPLATE" ]; then
    fail "recording-a-decision: the template carries no date and no status (no template)"
elif grep -qiE 'date|status|statut' "$ADR_TEMPLATE"; then
    fail "recording-a-decision: the template carries no date and no status"
else
    pass "recording-a-decision: the template carries no date and no status"
fi
for needle in "## Considered options" "## Consequences" "One to three sentences that state the decision and its reason"; do
    if [ -f "$ADR_TEMPLATE" ] && grep -qF "$needle" "$ADR_TEMPLATE"; then
        pass "recording-a-decision: the template carries: $needle"
    else
        fail "recording-a-decision: the template carries: $needle"
    fi
done
```

Dans `tests/test-skill-contracts.sh` :

- dans chaque appel `absent` dont la liste de skills tient à la fois `writing-a-batch` et `writing-a-user-story`, ajouter `recording-a-decision` à la fin de la liste. Les repérer avec `grep -n "writing-a-batch" tests/test-skill-contracts.sh`, et ne toucher ni aux appels `shared` ni aux listes qui ne tiennent pas les deux ;
- ajouter ce bloc juste avant la dernière ligne `exit $((FAILURES > 0))` :

```bash
# The dependency runs one way: recording-a-decision knows neither of the skills
# that conduct a batch or a story, and says nothing they would have to keep in
# step with.
absent "recording-a-decision names no skill that conducts a batch or a story" \
    "writing-a-batch|writing-a-user-story|calling skill" \
    recording-a-decision
```

- [ ] **Step 2: Voir les gardes rouges**

Run: `bash tests/test-skill-frontmatter.sh; bash tests/test-cross-references.sh; bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: des `[FAIL]` sur `recording-a-decision` dans les quatre fichiers, et aucun autre `[FAIL]`.

- [ ] **Step 3: Écrire le gabarit**

Créer `skills/recording-a-decision/references/adr-template.md` avec exactement ce contenu :

```markdown
# <The decision, in a few words>

<One to three sentences that state the decision and its reason.>

## Considered options

<Optional. The alternatives this decision settles between, and why each was set
aside. Drop the section when it would say nothing the sentences above do not.>

## Consequences

<Optional. What the decision rules out or makes harder for the code to come.
Drop the section when it would say nothing the sentences above do not.>
```

- [ ] **Step 4: Écrire la skill**

Créer `skills/recording-a-decision/SKILL.md` avec exactement ce contenu :

```markdown
---
name: recording-a-decision
description: Use only when a skill tells you to invoke recording-a-decision, never on a request to document a decision - writes the ADR your human partner decided, or rewrites in place the one whose decision they replaced, after confronting it with the specs and the other ADRs
user-invocable: false
---

# Recording a Decision

## Overview

An ADR records a technical decision of the project and its reason. It is a `.md`
file placed directly in `docs/adr/`.

This skill writes an ADR, or rewrites in place the one whose decision was
replaced. Your human partner has decided it before this skill runs: without
their decision, write nothing.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the recording-a-decision skill to record this decision."

Deleting an ADR, and correcting its text without changing its decision, do not
come through this skill. A correction that changes the decision is a rewrite,
and does.

## Input and Output

The input is:

- the decision and its reason;
- the path of the ADR to rewrite, when there is one;
- copies of specs to read in place of the files under `docs/specs/`, when the
  skill that invokes this one hands some.

Return the path of the file written, or what your human partner ruled when
nothing is written.

## Procedure

Follow these steps on the branch you are working on.

1. Read every ADR in `docs/adr/` and every spec in `docs/specs/`. Where you were
   handed a copy of a spec, read the copy.
2. When the decision contradicts a spec or another ADR, or is observable at a
   module's boundary, say so to your human partner and write nothing until they
   have ruled. A spec binds the code and an ADR must not contradict it, and what
   is observable at a module's boundary is a rule of that module's spec, which
   only your human partner changes.
3. Write the file from `skills/recording-a-decision/references/adr-template.md`,
   creating `docs/adr/` if it does not exist. A new ADR goes to
   `docs/adr/<slug>.md`. A rewrite replaces the text at the path you were given.

An ADR carries no date and no status. The file states what holds now, and its
git history keeps what held before.

Do not commit: the skill that invoked this one does. The commit that rewrites
an ADR says why, since the file keeps nothing of the decision it replaced.

## Language

An ADR carries an English skeleton and prose in the project's language. The
section titles `Considered options` and `Consequences` are skeleton. The title,
the sentences and the file's slug are prose.

Every text this skill writes follows `Concision` in `supercharlouze:using-batches`.

## Red Flags

| Thought | Reality |
|---|---|
| "The decision contradicts a spec, I'll word the ADR so it fits" | A reworded contradiction is still one. Say so to your human partner, and write nothing until they have ruled. |
| "This decision shows at the module's boundary, but an ADR is quicker than a spec change" | What is observable at a module's boundary is a rule of its spec. Say so to your human partner. |
| "Every ADR has a date and a status, I'll add them" | An ADR of this flow carries neither. The file states what holds now. |
| "The old decision is worth keeping, I'll mark it superseded" | Rewrite in place. Git history keeps the old text, and the commit says why it changed. |
| "The file is written, I'll commit it" | The skill that invoked this one commits. |
```

- [ ] **Step 5: Ajouter la ligne du `README.md`**

Dans la table de `## Skills`, après la ligne de `supercharlouze:rereading-a-technical-design`, ajouter :

```markdown
| `supercharlouze:recording-a-decision` | Never directly — a building block the other skills invoke to have an ADR written or rewritten |
```

- [ ] **Step 6: Voir les gardes vertes**

Run: `bash tests/test-skill-frontmatter.sh; bash tests/test-cross-references.sh; bash tests/test-skill-content.sh | grep -c FAIL; bash tests/test-skill-contracts.sh | grep -c FAIL`
Expected: aucun `[FAIL]`, les deux compteurs à `0`.

Si une liste `absent` de `tests/test-skill-contracts.sh` devient rouge sur `recording-a-decision`, corriger le texte de la skill sans changer ce qu'il décide, jamais la garde.

- [ ] **Step 7: Lancer la suite et commiter**

Run: `bash tests/run-all.sh` (délai de dix minutes)
Expected: `all tests passed`

```bash
git add skills/recording-a-decision README.md tests
bash ~/.config/github-app/as-agent.sh git -C "$PWD" commit -m "feat: une skill interne écrit ou réécrit un ADR" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 2: L'ADR dans `using-batches` et dans le `README.md`

**Files:**
- Modify: `skills/using-batches/SKILL.md` (table de routage, `## The Model`, `## What a Spec Says`, `## The Git Model`, `## What Is Kept, What Is Rerouted`, `## Red Flags`)
- Modify: `README.md` (`### The model`, `### What stays outside a batch`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`, `tests/test-cross-references.sh`

**Interfaces:**
- Consumes: la skill `supercharlouze:recording-a-decision` de la tâche 1.
- Produces: dans `## The Model` de `skills/using-batches/SKILL.md`, le texte anglais de référence des conditions d'un ADR, que la story suivante recopie mot pour mot dans les `Global Constraints` de `writing-a-user-story`.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, ajouter ce bloc juste avant la ligne `# --- using-batches: the glossary terms of the review (spec section "The model") ---` :

```bash
# --- using-batches: the ADR (spec sections "The model", "Architecture decision
# records" and "Bounded change") ---
require using-batches "defines the ADR" \
        "**ADR** — the document that records a technical decision of the project and its reason: a \`.md\` file placed directly in \`docs/adr/\`, at \`docs/adr/<slug>.md\`."
require using-batches "an ADR carries no date and no status" \
        "It carries no date and no status."
# The reference text of the conditions. Word for word: another skill copies it.
require using-batches "the conditions of an ADR, word for word" \
        "A technical decision is recorded as an ADR only if it meets these conditions: - undoing it is expensive; - it surprises whoever does not know its context; - it settles between real alternatives."
require using-batches "the human decides every ADR" \
        "**Your human partner decides every ADR.** An agent neither writes, rewrites nor deletes one unless they have decided it."
require using-batches "what is observable is a spec rule, never an ADR" \
        "What is observable at a module's boundary is a rule of that module's spec, never an ADR."
require using-batches "an ADR contradicts no spec and no other ADR" \
        "An ADR contradicts no spec and no other ADR."
require using-batches "a replaced decision is rewritten in place" \
        "An ADR whose decision is replaced is rewritten in place, and one whose decision is abandoned is deleted."
require using-batches "the commit that rewrites or deletes an ADR says why" \
        "**The commit that rewrites or deletes an ADR says why.**"
require using-batches "routing sends an ADR to a bounded change" \
        "| Your human partner wants an ADR written, rewritten or deleted | A bounded change, under \`What Is Kept, What Is Rerouted\` below |"
require using-batches "a decision with nothing observable has the ADR for outlet" \
        "A technical decision that fails this question has an ADR for outlet, under the conditions \`The Model\` states."
require using-batches "a decision housed outside the specs goes to an ADR" \
        "A technical decision that no module boundary makes observable is not a rule: its outlet is an ADR."
require using-batches "the scope paragraph names both outlets" \
        "that is where a behaviour the test ejects goes, and a technical decision it ejects goes to an ADR"
require using-batches "the red flag names the ADR as the outlet" \
        "A technical decision with nothing observable at a module's boundary is no rule at all: its outlet is an ADR. |"
require using-batches "a bounded change writes, rewrites and deletes ADRs" \
        "**(e) It may write, rewrite and delete ADRs, and may carry nothing but ADRs.**"
require using-batches "a bounded change invokes recording-a-decision" \
        "Invoke \`supercharlouze:recording-a-decision\` to write or rewrite one, and delete yourself the one your human partner abandons."
```

Dans `tests/test-skill-contracts.sh`, ajouter ce bloc juste avant le bloc `# The dependency runs one way: recording-a-decision knows neither…` que la tâche 1 a posé :

```bash
# The rules of a bounded change are listed, never counted: a count goes false
# the day a rule is added, as it did when the ADR rule joined them.
absent "no skill counts the rules of a bounded change" \
    "with (four|five|six|seven) rules|the (four|five|six|seven) rules" \
    using-batches
```

Dans `tests/test-cross-references.sh` :

- dans le commentaire qui commence par `# The README states the same four rules for a human reader`, remplacer `the same four rules` par `the same rules` ;
- ajouter ce bloc juste avant la ligne `# 5. No shipped artifact cites a numbered section of the archived design` :

```bash
# The README defines the ADR in its model, and states what a bounded change may
# do with one.
case "$README_FLAT" in
    *"- **ADR** — the document that records a technical decision of the project and its reason, at \`docs/adr/<slug>.md\`."*)
        pass "the README defines the ADR" ;;
    *)  fail "the README defines the ADR" ;;
esac
case "$README_FLAT" in
    *"and it may write, rewrite and delete ADRs, or carry nothing but ADRs."*)
        pass "the README lets a bounded change write ADRs" ;;
    *)  fail "the README lets a bounded change write ADRs" ;;
esac
```

- [ ] **Step 2: Voir les gardes rouges**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL; bash tests/test-cross-references.sh | grep FAIL`
Expected: un `[FAIL]` par garde neuve, et aucun autre.

- [ ] **Step 3: La table de routage**

Dans `skills/using-batches/SKILL.md`, ajouter cette ligne juste avant la ligne `| Spike or bounded work | …` :

```markdown
| Your human partner wants an ADR written, rewritten or deleted | A bounded change, under `What Is Kept, What Is Rerouted` below |
```

- [ ] **Step 4: `## The Model`**

Après le paragraphe `**Technical design ruling** — a ruling by which a story departs from its batch's technical design.` et avant `**Corrective batch**`, ajouter :

```markdown
**ADR** — the document that records a technical decision of the project and its reason: a `.md` file placed directly in `docs/adr/`, at `docs/adr/<slug>.md`. It carries no date and no status.

A technical decision is recorded as an ADR only if it meets these conditions:

- undoing it is expensive;
- it surprises whoever does not know its context;
- it settles between real alternatives.

**Your human partner decides every ADR.** An agent neither writes, rewrites nor deletes one unless they have decided it.

What is observable at a module's boundary is a rule of that module's spec, never an ADR.

An ADR contradicts no spec and no other ADR.

An ADR whose decision is replaced is rewritten in place, and one whose decision is abandoned is deleted.
```

- [ ] **Step 5: `## What a Spec Says`**

Remplacer :

```markdown
The question that settles all four: *what does a user or a neighbouring module lose if this sentence is false?* If the answer is "nothing observable", it is not a rule — it is a gap, and it goes to the register.
```

par :

```markdown
The question that settles all four: *what does a user or a neighbouring module lose if this sentence is false?* If the answer is "nothing observable", it is not a rule — it is a gap, and it goes to the register. A technical decision that fails this question has an ADR for outlet, under the conditions `The Model` states.
```

Remplacer :

```markdown
the gaps register. It would read as a norm and be none.
```

par :

```markdown
the gaps register. It would read as a norm and be none. A technical decision
that no module boundary makes observable is not a rule: its outlet is an ADR.
```

Dans le paragraphe `**Scope.**`, remplacer :

```markdown
a register entry names a mechanism, that is its job, and that is where everything the test ejects goes.
```

par :

```markdown
a register entry names a mechanism, that is its job, and that is where a behaviour the test ejects goes, and a technical decision it ejects goes to an ADR.
```

- [ ] **Step 6: `## The Git Model`**

Après le paragraphe qui commence par `**The drift rule therefore has no exception:**` et avant `**Human gates are pull request reviews.**`, ajouter :

```markdown
**The commit that rewrites or deletes an ADR says why.** The file keeps nothing of the decision it replaced, so the commit is where its reason stays readable.
```

- [ ] **Step 7: `## What Is Kept, What Is Rerouted`**

Remplacer `**Bounded** — ceremony unchanged, with four rules:` par `**Bounded** — ceremony unchanged, with these rules:`.

Après le dernier paragraphe de la règle (d), `Within a batch, only the closing pull request adds entries to the gaps register: …`, et avant `No batch, no user story: …`, ajouter :

```markdown
- **(e) It may write, rewrite and delete ADRs, and may carry nothing but ADRs.** Invoke `supercharlouze:recording-a-decision` to write or rewrite one, and delete yourself the one your human partner abandons.
```

- [ ] **Step 8: `## Red Flags`**

Dans la ligne dont la pensée est `"This rule holds for every module, so it lives above them all"`, remplacer la fin de la cellule de droite :

```markdown
signals a module breakdown to revisit, and that is your human partner's decision. |
```

par :

```markdown
signals a module breakdown to revisit, and that is your human partner's decision. A technical decision with nothing observable at a module's boundary is no rule at all: its outlet is an ADR. |
```

- [ ] **Step 9: `README.md`**

Dans `### The model`, après la puce `**Technical story**` et avant la puce `**Feature flag**`, ajouter :

```markdown
- **ADR** — the document that records a technical decision of the project and
  its reason, at `docs/adr/<slug>.md`. A decision earns one only if undoing it
  is expensive, it surprises whoever does not know its context, and it settles
  between real alternatives. A human decides every one.
```

Dans `### What stays outside a batch`, remplacer :

```markdown
sections it touches, like a story; it carries no flag, being complete on its own;
and it may write to a gaps register directly. Only architectural work opens a
batch.
```

par :

```markdown
sections it touches, like a story; it carries no flag, being complete on its own;
it may write to a gaps register directly; and it may write, rewrite and delete
ADRs, or carry nothing but ADRs. Only architectural work opens a batch.
```

- [ ] **Step 10: Voir les gardes vertes**

Run: `bash tests/test-skill-content.sh | grep -c FAIL; bash tests/test-skill-contracts.sh | grep -c FAIL; bash tests/test-cross-references.sh | grep -c FAIL`
Expected: `0`, `0`, `0`.

- [ ] **Step 11: Lancer la suite et commiter**

Run: `bash tests/run-all.sh` (délai de dix minutes)
Expected: `all tests passed`

```bash
git add skills/using-batches/SKILL.md README.md tests
bash ~/.config/github-app/as-agent.sh git -C "$PWD" commit -m "feat: une décision technique a l'ADR pour sortie" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

## Observed drift
