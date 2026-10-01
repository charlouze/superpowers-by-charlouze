# L'amendement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Un amendement change aussi la conception technique d'un lot ou ses contraintes, passe par la relecture technique, et corrige la contrainte que l'humain a jugée intenable.

**Architecture:** Le plugin est fait de skills Markdown gardées par une suite structurelle en bash. `## Amending a Batch` de `writing-a-batch` porte les trois règles en entier : ce qu'un amendement change, la relecture technique qu'il traverse, et ce qui suit l'arrêt d'une story sur une contrainte. `using-batches`, `writing-a-user-story` et le README y renvoient là où ils nomment déjà l'amendement ou la condition d'arrêt. Chaque tâche écrit d'abord ses gardes, les voit échouer, puis écrit le texte qui les fait passer.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/10-la-conception-technique/README.md
**Sections:** Authority and conflict rules, Batch > Amending a batch
**Blocks:** D5, D9, D10

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

La primauté de la spec : when the batch and the spec contradict each other, the
spec wins — without exception and without deliberation. Implement what the spec
says, record a `Ruling:`, and carry on. Correcting a spec mid-batch is a human
act, never an agent's.

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

La condition d'arrêt sur une contrainte qui ne peut pas être tenue, puisque ce lot
déclare des contraintes :

> If, while conducting a story, you discover that a constraint of its batch cannot be held, stop and put the constraint to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

Les skills sont entièrement en anglais. Une skill ne cite jamais une section de
`docs/specs/supercharlouze.md`.

Tout commit passe par le wrapper d'identité et se termine par la ligne de
co-auteur de l'utilisateur, sans aucune autre ligne d'attribution :

```bash
bash ~/.config/github-app/as-agent.sh git commit -m "<sujet>" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

`bash tests/run-all.sh` dure plus de deux minutes : le lancer avec un délai de dix
minutes.

## Review Focus

- Un amendement qui ne change que `Technical design` ou `Constraints` n'a pas de
  relecture de cohérence : la relecture technique ne l'attend pas. Garde de la
  tâche 2 : « after the coherence reread when it runs one ».
- La relecture technique d'un amendement lit les specs avec les blocs qu'aucune
  story fusionnée n'a déclarés, pas `main` nu. Garde de la tâche 2 : « on each
  spec with every block no merged story has declared yet applied ».
- Un amendement à la conception technique dont la relecture rend un bloc devient
  un amendement au spec delta, revu comme une ouverture. Garde de la tâche 2 :
  « A block it returns makes the amendment one that changes the spec delta ».
- L'arrêt d'une story sur une contrainte n'abandonne rien : seul le jugement
  « intenable » abandonne la story, et le jugement contraire la fait reprendre
  sans amendement. Gardes de la tâche 3 dans les trois skills.
- Aucune phrase ne borne plus un amendement au périmètre, au spec delta et au
  flag, ni dans une skill ni dans le README. Garde `absent` de la tâche 1 et garde
  du README.

---

### Task 1: un amendement couvre la conception technique et les contraintes

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (table des points d'entrée de `## Overview`, `## Amending a Batch`)
- Modify: `skills/using-batches/SKILL.md` (table de routage en tête, table des gates de `## The Git Model`)
- Modify: `README.md` (table des gates)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`, `tests/test-cross-references.sh`

**Interfaces:**
- Produces: la liste de ce qu'un amendement change, dans cet ordre partout : `the scope, the spec delta, the technical design, the constraints or the flag`.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh`, remplacer ces deux lignes :

```bash
require writing-a-batch "an amendment covers the spec delta"     "An amendment changes the scope, the spec delta or the flag of an open batch"
require writing-a-batch "the entry point names the spec delta"   "Changing the scope, the spec delta or the flag of an existing batch"
```

par :

```bash
require writing-a-batch "an amendment covers the design and the constraints" "An amendment changes the scope, the spec delta, the technical design, the constraints or the flag of an open batch"
require writing-a-batch "the entry point names the design and the constraints" "Changing the scope, the spec delta, the technical design, the constraints or the flag of an existing batch"
require writing-a-batch "a design or a constraint that must change is a dead end" "**A batch whose technical design or constraints must change**"
```

Dans le même fichier, remplacer ces deux lignes :

```bash
require using-batches "the amendment gate covers the spec delta" "the decision to change its scope, its spec delta or its flag"
require using-batches "routing names the spec delta"             "A batch must change its scope, its spec delta or its flag"
```

par :

```bash
require using-batches "the amendment gate covers the design and the constraints" "the decision to change its scope, its spec delta, its technical design, its constraints or its flag"
require using-batches "routing names the design and the constraints" "A batch must change its scope, its spec delta, its technical design, its constraints or its flag"
```

Dans `tests/test-skill-contracts.sh`, juste après la garde `absent "no skill bounds an amendment to scope and flag"` et sa liste de skills, ajouter :

```bash

# An amendment also changes the technical design and the constraints. A leftover
# ending the list on the spec delta would send a constraint ruled untenable
# nowhere.
absent "no skill bounds an amendment to scope, spec delta and flag" \
    "spec delta or (its |the |of )?flag" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

Dans `tests/test-cross-references.sh`, remplacer :

```bash
# The amendment gate covers the spec delta, in the README's gate table too.
if grep -q "a change of scope, of spec delta or of flag on an open batch" "$REPO_ROOT/README.md"; then
    pass "the README's amendment gate covers the spec delta"
else
    fail "the README's amendment gate covers the spec delta"
fi
```

par :

```bash
# The amendment gate covers the technical design and the constraints, in the
# README's gate table too.
if grep -q "a change of scope, of spec delta, of technical design, of constraints or of flag on an open batch" "$REPO_ROOT/README.md"; then
    pass "the README's amendment gate covers the design and the constraints"
else
    fail "the README's amendment gate covers the design and the constraints"
fi
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL; bash tests/test-cross-references.sh | grep FAIL`
Expected: FAIL sur les cinq gardes `require`, sur la garde `absent` (present in: using-batches writing-a-batch) et sur la garde du README.

- [ ] **Step 3: Rewrite `writing-a-batch`**

Dans la table des points d'entrée de `## Overview`, remplacer :

```markdown
| Changing the scope, the spec delta or the flag of an existing batch | Amending a Batch |
```

par :

```markdown
| Changing the scope, the spec delta, the technical design, the constraints or the flag of an existing batch | Amending a Batch |
```

Dans `## Amending a Batch`, remplacer :

```markdown
**amendment pull request**, reviewed like the others. An amendment changes the
scope, the spec delta or the flag of an open batch. That is the exit from these
real dead ends:
```

par :

```markdown
**amendment pull request**, reviewed like the others. An amendment changes the
scope, the spec delta, the technical design, the constraints or the flag of an
open batch. That is the exit from these real dead ends:
```

Puis, à la fin de la liste des impasses, après l'élément `**A batch whose spec delta must change**`, ajouter :

```markdown
- **A batch whose technical design or constraints must change**: a design the
  remaining stories should no longer start from, or a constraint your human
  partner ruled untenable.
```

- [ ] **Step 4: Rewrite `using-batches`**

Dans la table de routage, remplacer :

```markdown
| A batch must change its scope, its spec delta or its flag, or a corrective batch must be requalified | `supercharlouze:writing-a-batch` |
```

par :

```markdown
| A batch must change its scope, its spec delta, its technical design, its constraints or its flag, or a corrective batch must be requalified | `supercharlouze:writing-a-batch` |
```

Dans la table des gates de `## The Git Model`, remplacer :

```markdown
| Batch amendment | the pull request carrying the decision to change its scope, its spec delta or its flag |
```

par :

```markdown
| Batch amendment | the pull request carrying the decision to change its scope, its spec delta, its technical design, its constraints or its flag |
```

- [ ] **Step 5: Rewrite the README's gate table**

Dans `README.md`, remplacer :

```markdown
| Batch amendment | a change of scope, of spec delta or of flag on an open batch |
```

par :

```markdown
| Batch amendment | a change of scope, of spec delta, of technical design, of constraints or of flag on an open batch |
```

- [ ] **Step 6: Run the guards to verify they pass**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL; bash tests/test-cross-references.sh | grep FAIL`
Expected: aucune ligne.

- [ ] **Step 7: Commit**

```bash
git add skills/writing-a-batch/SKILL.md skills/using-batches/SKILL.md README.md tests/test-skill-content.sh tests/test-skill-contracts.sh tests/test-cross-references.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: un lot ouvert s'amende dans sa conception technique ou ses contraintes" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: un amendement passe par la relecture technique

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## Amending a Batch`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: `## The Technical Reread` et `## The Coherence Reread` de `writing-a-batch`, tels que `main` les porte.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh`, remplacer cette ligne :

```bash
require writing-a-batch "its whole document goes through the document reread" "Then the whole document goes through the batch-document reread"
```

par :

```bash
require writing-a-batch "its whole document goes through the document reread" "After its rereads, an amendment that changes the spec delta puts the whole document through the batch-document reread"
require writing-a-batch "an amendment goes through the technical reread" "An amendment that changes the spec delta, the technical design or the constraints goes through the technical reread before its pull request opens, after the coherence reread when it runs one"
require writing-a-batch "its technical reread is the opening's" "Conduct it as \`The Technical Reread\` does"
require writing-a-batch "its technical reread reads the pending blocks applied" "on the amended document and on each spec with every block no merged story has declared yet applied"
require writing-a-batch "a block the technical reread returns makes a delta amendment" "A block it returns makes the amendment one that changes the spec delta"
require writing-a-batch "its body says what the technical reread found" "Its body says what the technical reread found, or that it found nothing"
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: FAIL sur les six gardes ci-dessus.

- [ ] **Step 3: Rewrite the rereads of an amendment**

Dans `## Amending a Batch`, remplacer le paragraphe :

```markdown
By exception, an amendment that changes the spec delta is reviewed as an
opening. Before its pull request opens, apply its new or changed blocks together
with every block no merged story has declared yet, and invoke
`supercharlouze:rereading-a-spec` on each applied copy, with the path of the
spec it applies to, as `The Coherence Reread` does. Then the whole document
goes through the batch-document reread. Its body states the exact text of every
new or changed block, and what the coherence reread found.
```

par :

```markdown
By exception, an amendment that changes the spec delta is reviewed as an
opening. Before its pull request opens, apply its new or changed blocks together
with every block no merged story has declared yet, and invoke
`supercharlouze:rereading-a-spec` on each applied copy, with the path of the
spec it applies to, as `The Coherence Reread` does. Its body states the exact
text of every new or changed block, and what the coherence reread found.

An amendment that changes the spec delta, the technical design or the
constraints goes through the technical reread before its pull request opens,
after the coherence reread when it runs one. Conduct it as
`The Technical Reread` does, on the amended document and on each spec with every
block no merged story has declared yet applied. A block it returns makes the
amendment one that changes the spec delta. Its body says what the technical
reread found, or that it found nothing.

After its rereads, an amendment that changes the spec delta puts the whole
document through the batch-document reread.
```

- [ ] **Step 4: Run the guards to verify they pass**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-cross-references.sh | grep FAIL`
Expected: aucune ligne.

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: un amendement passe par la relecture technique" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 3: l'humain juge la contrainte qu'une story ne peut pas tenir

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## Amending a Batch`, `## Red Flags`)
- Modify: `skills/using-batches/SKILL.md` (`### Override 2 — the stop conditions the flow adds`)
- Modify: `skills/writing-a-user-story/SKILL.md` (`## Step 5 — Execute`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la liste de ce qu'un amendement change, écrite par la tâche 1, et les paragraphes de relecture écrits par la tâche 2 dans `## Amending a Batch`.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh`, après la ligne `require writing-a-batch "an amendment releases what it drops" …`, ajouter :

```bash
require writing-a-batch "the human rules on a constraint a story cannot hold" "**When a story stops on a constraint it cannot hold, your human partner rules on the constraint.**"
require writing-a-batch "an untenable constraint is amended" "If they rule it untenable, the story is abandoned and an amendment changes or removes the constraint"
require writing-a-batch "a constraint that holds resumes the story" "Otherwise the story resumes and holds the constraint, and nothing is amended."
require writing-a-batch "the red flag keeps the ruling with the human" "Whether a constraint can be held is your human partner's ruling."
```

Dans le même fichier, après la garde `require using-batches "the human rules on the constraint" …`, ajouter :

```bash
require using-batches "an untenable constraint goes to an amendment" \
    "If they rule it untenable, the story is abandoned and \`supercharlouze:writing-a-batch\` amends the constraint, under \`Amending a Batch\`; otherwise the story resumes and holds it."
require writing-a-user-story "an untenable constraint abandons the story" \
    "If they rule it untenable, the story is abandoned and \`supercharlouze:writing-a-batch\` amends the constraint; otherwise resume the story and hold the constraint."
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: FAIL sur les six gardes ci-dessus.

- [ ] **Step 3: Write the rule in `writing-a-batch`**

Dans `## Amending a Batch`, juste avant le paragraphe qui commence par `An amendment that takes a gaps register entry out of`, insérer :

```markdown
**When a story stops on a constraint it cannot hold, your human partner rules on
the constraint.** If they rule it untenable, the story is abandoned and an
amendment changes or removes the constraint: close the story's pull request
without merging it if one is open, delete its branch locally and on the remote,
and remove its worktree, since a branch left on the remote reads as a live claim
on its sections. Otherwise the story resumes and holds the constraint, and
nothing is amended.
```

À la fin du tableau de `## Red Flags`, ajouter :

```markdown
| "The story is right, this constraint cannot be held, I'll amend it" | Whether a constraint can be held is your human partner's ruling. Put it to them: the amendment follows a ruling of untenable, and the story resumes on any other. |
```

- [ ] **Step 4: Complete Override 2 in `using-batches`**

Dans `### Override 2 — the stop conditions the flow adds`, remplacer :

```markdown
When the constraint condition fires, your human partner rules on the constraint.
```

par :

```markdown
When the constraint condition fires, your human partner rules on the constraint. If they rule it untenable, the story is abandoned and `supercharlouze:writing-a-batch` amends the constraint, under `Amending a Batch`; otherwise the story resumes and holds it.
```

- [ ] **Step 5: Complete Step 5 of `writing-a-user-story`**

Dans `## Step 5 — Execute`, remplacer :

```markdown
case, since the spec wins. When you stop, your human partner rules on the
constraint, and until then the branch and the worktree stay as they are.
```

par :

```markdown
case, since the spec wins. When you stop, your human partner rules on the
constraint, and until then the branch and the worktree stay as they are. If they
rule it untenable, the story is abandoned and `supercharlouze:writing-a-batch`
amends the constraint; otherwise resume the story and hold the constraint.
```

- [ ] **Step 6: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`, aucun FAIL.

- [ ] **Step 7: Commit**

```bash
git add skills/writing-a-batch/SKILL.md skills/using-batches/SKILL.md skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: l'humain juge la contrainte qu'une story ne peut pas tenir" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Technical design ruling: `using-batches` et le README étendent leur table des gates et leur ligne de routage à la conception technique et aux contraintes, ce que la conception ne prévoit pas — tous deux énumèrent ce qu'un amendement change, et la liste à trois éléments devient fausse — si c'est à tort, deux tables changent hors de la conception.
- Technical design ruling: `using-batches` et `writing-a-user-story` disent ce qui suit le jugement de l'humain sur une contrainte, que la conception n'écrit que dans `writing-a-batch` — la story arrêtée lit ces deux skills, pas `writing-a-batch` — si c'est à tort, la règle complète de `writing-a-batch` a deux résumés qui peuvent dériver.
- Ruling: `Amending a Batch` ne redit pas que le corps de la pull request déclare ce que la relecture technique a trouvé, et la garde que le plan prévoyait pour cette phrase est retirée — `The Technical Reread` le dit déjà pour l'ouverture comme pour l'amendement, et le paragraphe y renvoie — si c'est à tort, un amendement ouvre sa pull request sans dire ce que la relecture technique a trouvé.
- Ruling: `Amending a Batch` dit que la copie des specs se construit comme `The Coherence Reread` la construit, nomme l'amendement avant l'abandon de la story, et une garde tient le nettoyage de la story abandonnée, ce que le plan ne prévoyait pas — un amendement sans relecture de cohérence n'avait pas de copie dont partir, et le nettoyage se lisait comme une suite de l'amendement — si c'est à tort, deux phrases de skill changent de forme sans changer de règle.
- Ruling: `writing-a-user-story` renvoie à `supercharlouze:writing-a-batch` sans nommer `Amending a Batch` — la table des points d'entrée de `writing-a-batch` y conduit — si c'est à tort, un agent arrêté sur une contrainte cherche la section.

## Observed drift
