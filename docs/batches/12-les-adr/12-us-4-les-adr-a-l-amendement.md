# Les ADR à l'amendement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Un amendement écrit, réécrit ou supprime les ADR que l'humain a décidés, et passe par la relecture technique quand il en écrit ou en réécrit un.

**Architecture:** `## Amending a Batch` de `writing-a-batch` renvoie à `## The ADRs` pour écrire, réécrire ou supprimer des ADR, étend à l'ADR écrit ou réécrit le déclencheur de la relecture technique, et énonce les ADR dans le corps de la pull request. `using-batches` et le `README.md` suivent la ligne d'amendement de la table des revues, et la ligne de routage sur l'ADR gagne sa borne. Chaque norme a sa garde dans `tests/`, écrite avant le texte.

**Tech Stack:** Markdown pour les skills et le `README.md`, Bash pour les gardes de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/12-les-adr/README.md
**Sections:** Authority and conflict rules, Batch > Amending a batch
**Blocks:** D17, D18, D19

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

Condition d'arrêt sur une contrainte ou un ADR qui ne peut pas être tenu :

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

Conditions d'un ADR :

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

Règles du dépôt, qui valent pour chaque tâche :

- Une skill, un test et le `README.md` sont entièrement en anglais.
- Une skill ne cite jamais une section de `docs/specs/supercharlouze.md`. Une section qu'une skill nomme entre parenthèses est l'un de ses propres titres.
- Chaque norme qu'une skill énonce a sa garde dans `tests/`, écrite avant le texte et vue rouge.
- Chaque phrase d'une skill change ce qu'un agent fait. Pas de réfutation d'une version disparue, pas de cas particulier que la règle générale couvre déjà, pas de gras qui hiérarchise, pas de tiret à la place d'une virgule, pas de liste qui annonce combien d'éléments elle tient.
- Une règle est écrite en entier à un seul endroit et pointée ailleurs.
- Cette story ne livre que ce qui réalise `D17`, `D18` et `D19`. `## The Batch Document` et `## The ADRs` de `skills/writing-a-batch/SKILL.md`, `skills/rereading-a-technical-design/`, `skills/recording-a-decision/`, `skills/closing-a-batch/`, `scripts/` et `commands/` ne sont pas touchés.
- Le texte d'une skill donné dans une tâche est écrit tel quel. Un implémenteur qui le juge faux le dit dans son rapport, et ne le réécrit pas.
- Tout commit passe par `bash ~/.config/github-app/as-agent.sh git -C <worktree> commit …` et se termine par la seule ligne d'attribution `Co-Authored-By: Charlouze <me@charlouze.com>`. Jamais de `Co-Authored-By: Claude …`, de `Claude-Session:` ni de « Generated with Claude Code ».
- Pendant une tâche, seuls les fichiers de test qu'elle touche sont lancés (`bash tests/<fichier>.sh`). La suite complète tourne à la fin de la story. Aucun lancement n'est laissé en arrière-plan.

## Review Focus

- Un amendement qui ne change que le périmètre ou le flag et qui écrit un ADR : il passe par la relecture technique. Gardé en tâche 1 par le déclencheur étendu et par sa ligne de `## Red Flags`.
- Un amendement qui écrit un ADR alors que des blocs sont déjà livrés : l'ADR est confronté aux specs avec les seuls blocs qu'aucune story fusionnée n'a déclarés. Gardé en tâche 1 par la phrase sur les copies.
- Un humain qui veut réécrire un ADR sans rien changer au document de lot : ce n'est pas un amendement. Gardé en tâche 1 par la règle et sa ligne de `## Red Flags`, et en tâche 2 par la borne de la ligne de routage.
- Un bloc que la relecture technique d'un amendement rend comme repris au spec delta : l'amendement devient un amendement qui change le spec delta. Gardé en tâche 1.
- Un amendement qui supprime un ADR sans le dire à la revue. Gardé en tâche 1 par la phrase sur le corps de la pull request.

---

### Task 1: Un amendement écrit, réécrit ou supprime des ADR

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## Amending a Batch`, `## Red Flags`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: `## The ADRs` et `## The Technical Reread` de `skills/writing-a-batch/SKILL.md`, déjà sur la branche et non modifiées.
- Produces: rien qu'une autre tâche consomme.

- [ ] **Step 1: Changer et écrire les gardes**

Dans `tests/test-skill-content.sh`, remplacer :

```bash
require writing-a-batch "an amendment goes through the technical reread" "An amendment that changes the spec delta, the technical design or the constraints goes through the technical reread before its pull request opens, after the coherence reread when it runs one"
```

par :

```bash
require writing-a-batch "an amendment goes through the technical reread" "An amendment that changes the spec delta, the technical design or the constraints, or that writes or rewrites an ADR, goes through the technical reread before its pull request opens, after the coherence reread when it runs one"
```

Remplacer :

```bash
require writing-a-batch "a behaviour taken back makes a delta amendment" "A behaviour it returns as taken back to the spec delta makes the amendment one that changes the spec delta"
```

par :

```bash
require writing-a-batch "a behaviour or a block taken back makes a delta amendment" "A behaviour or a block it returns as taken back to the spec delta makes the amendment one that changes the spec delta"
```

Après la garde `its body carries what an opening body carries`, ajouter :

```bash
require writing-a-batch "an amendment writes, rewrites or deletes ADRs" "An amendment's pull request may also write, rewrite or delete the ADRs your human partner decided."
require writing-a-batch "its ADRs are written as the opening's" "Do it as \`The ADRs\` does, on a copy of each spec the batch touches with every block no merged story has declared yet applied."
require writing-a-batch "its body puts the ADRs to the reviewer" "Its body states, among what the reviewer has to rule on, each ADR it writes, rewrites or deletes."
require writing-a-batch "a change of ADRs alone is a bounded change" "A change that touches nothing but ADRs is not an amendment: it goes through a bounded change."
require writing-a-batch "red flag: an amendment for an ADR alone" "| \"My human partner wants this ADR rewritten, I'll amend the batch for it\" | An amendment changes the batch document. A change that touches nothing but ADRs goes through a bounded change. |"
require writing-a-batch "red flag: an amendment's ADR is reread" "| \"This amendment only changes the scope, the ADR it writes needs no reread\" | An amendment that writes or rewrites an ADR goes through the technical reread, whatever else it changes. |"
```

Dans `tests/test-skill-contracts.sh`, après le bloc `absent "no skill bounds an amendment to scope, spec delta and flag"`, ajouter :

```bash
# An amendment that writes or rewrites an ADR goes through the technical reread.
# A leftover ending the trigger on the constraints would let an ADR written by an
# amendment reach the review unread.
absent "an amendment's technical reread is not bound to the batch document" \
    "or the constraints goes through the technical reread" \
    writing-a-batch
```

- [ ] **Step 2: Lancer les gardes et les voir rouges**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: les huit gardes de `test-skill-content.sh` ajoutées ou changées ci-dessus et la garde ajoutée à `test-skill-contracts.sh` sont en `[FAIL]` ; aucune autre.

- [ ] **Step 3: Écrire `## Amending a Batch`**

Dans `skills/writing-a-batch/SKILL.md`, dans `## Amending a Batch`, entre le paragraphe qui finit par `it is an explicit human decision that goes through a review.` et le paragraphe qui commence par `By exception, an amendment that changes the spec delta is reviewed as an opening.`, insérer :

```markdown
An amendment's pull request may also write, rewrite or delete the ADRs your
human partner decided. Do it as `The ADRs` does, on a copy of each spec the
batch touches with every block no merged story has declared yet applied. Its
body states, among what the reviewer has to rule on, each ADR it writes,
rewrites or deletes.

A change that touches nothing but ADRs is not an amendment: it goes through a
bounded change.
```

Dans la même section, remplacer :

```markdown
An amendment that changes the spec delta, the technical design or the
constraints goes through the technical reread before its pull request opens,
after the coherence reread when it runs one. Conduct it as
`The Technical Reread` does, on the amended document and on each spec with every
block no merged story has declared yet applied, in a copy built as
`The Coherence Reread` builds it. A behaviour it returns as taken back to the
spec delta makes the amendment one that changes the spec delta.
```

par :

```markdown
An amendment that changes the spec delta, the technical design or the
constraints, or that writes or rewrites an ADR, goes through the technical
reread before its pull request opens, after the coherence reread when it runs
one. Conduct it as `The Technical Reread` does, on the amended document and on
each spec with every block no merged story has declared yet applied, in a copy
built as `The Coherence Reread` builds it. A behaviour or a block it returns as
taken back to the spec delta makes the amendment one that changes the spec
delta.
```

- [ ] **Step 4: Écrire les `Red Flags`**

À la fin de la table de `## Red Flags` du même fichier, ajouter ces lignes :

```markdown
| "My human partner wants this ADR rewritten, I'll amend the batch for it" | An amendment changes the batch document. A change that touches nothing but ADRs goes through a bounded change. |
| "This amendment only changes the scope, the ADR it writes needs no reread" | An amendment that writes or rewrites an ADR goes through the technical reread, whatever else it changes. |
```

- [ ] **Step 5: Lancer les gardes et les voir vertes**

Run: `bash tests/test-skill-content.sh | grep -c FAIL; bash tests/test-skill-contracts.sh | grep -c FAIL; bash tests/test-cross-references.sh | grep -c FAIL`
Expected: `0` trois fois.

- [ ] **Step 6: Commit**

```bash
bash ~/.config/github-app/as-agent.sh git -C <worktree> add skills/writing-a-batch tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git -C <worktree> commit -m "feat: l'amendement d'un lot écrit les ADR que l'humain a décidés

Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 2: La revue d'amendement porte les ADR, dans `using-batches` et dans le `README.md`

**Files:**
- Modify: `skills/using-batches/SKILL.md` (la table de routage, la table des revues de `## The Git Model`)
- Modify: `README.md` (la table des revues)
- Test: `tests/test-skill-content.sh`, `tests/test-cross-references.sh`

**Interfaces:**
- Consumes: rien.
- Produces: rien qu'une autre tâche consomme.

- [ ] **Step 1: Changer et écrire les gardes**

Dans `tests/test-skill-content.sh`, remplacer :

```bash
require using-batches "routing sends an ADR to a bounded change" \
        "| Your human partner wants an ADR written, rewritten or deleted | A bounded change, under \`What Is Kept, What Is Rerouted\` below |"
```

par :

```bash
require using-batches "routing sends an ADR to a bounded change" \
        "| Your human partner wants an ADR written, rewritten or deleted outside the opening or the amendment of a batch | A bounded change, under \`What Is Kept, What Is Rerouted\` below |"
```

Après la garde `the opening gate carries the ADRs changed with the batch document`, ajouter :

```bash
require using-batches "the amendment gate carries the ADRs changed with the decision" \
        "| Batch amendment | the pull request carrying the decision to change its scope, its spec delta, its technical design, its constraints or its flag, and the ADRs written, rewritten or deleted with it |"
```

Dans `tests/test-cross-references.sh`, après le bloc `the README's opening gate carries the ADRs changed with the batch document`, ajouter :

```bash
# The amendment gate carries the ADRs written, rewritten or deleted with the
# amendment, in the README's gate table too.
case "$README_FLAT" in
    *"| Batch amendment | a change of scope, of spec delta, of technical design, of constraints or of flag on an open batch, and the ADRs written, rewritten or deleted with it |"*)
        pass "the README's amendment gate carries the ADRs changed with the amendment" ;;
    *)  fail "the README's amendment gate carries the ADRs changed with the amendment" ;;
esac
```

- [ ] **Step 2: Lancer les gardes et les voir rouges**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-cross-references.sh | grep FAIL`
Expected: les trois gardes ajoutées ou changées sont en `[FAIL]`, aucune autre.

- [ ] **Step 3: Écrire les textes**

Dans `skills/using-batches/SKILL.md`, dans la table de routage, remplacer :

```markdown
| Your human partner wants an ADR written, rewritten or deleted | A bounded change, under `What Is Kept, What Is Rerouted` below |
```

par :

```markdown
| Your human partner wants an ADR written, rewritten or deleted outside the opening or the amendment of a batch | A bounded change, under `What Is Kept, What Is Rerouted` below |
```

Dans la table des revues de `## The Git Model`, remplacer :

```markdown
| Batch amendment | the pull request carrying the decision to change its scope, its spec delta, its technical design, its constraints or its flag |
```

par :

```markdown
| Batch amendment | the pull request carrying the decision to change its scope, its spec delta, its technical design, its constraints or its flag, and the ADRs written, rewritten or deleted with it |
```

Dans `README.md`, dans la table des revues, remplacer :

```markdown
| Batch amendment | a change of scope, of spec delta, of technical design, of constraints or of flag on an open batch |
```

par :

```markdown
| Batch amendment | a change of scope, of spec delta, of technical design, of constraints or of flag on an open batch, and the ADRs written, rewritten or deleted with it |
```

- [ ] **Step 4: Lancer les gardes et les voir vertes**

Run: `bash tests/test-skill-content.sh | grep -c FAIL; bash tests/test-cross-references.sh | grep -c FAIL; bash tests/test-skill-contracts.sh | grep -c FAIL; bash tests/test-declared-overrides.sh | grep -c FAIL`
Expected: `0` quatre fois.

- [ ] **Step 5: Commit**

```bash
bash ~/.config/github-app/as-agent.sh git -C <worktree> add skills/using-batches README.md tests/test-skill-content.sh tests/test-cross-references.sh
bash ~/.config/github-app/as-agent.sh git -C <worktree> commit -m "feat: la revue d'amendement porte les ADR du lot

Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: les tâches 1 et 2 sont confiées à un seul implémenteur, en un envoi, et relues ensemble — les deux transcrivent un texte donné en entier, de même forme — si c'est faux, un défaut d'une tâche est relu avec l'autre.
- Ruling: les deux commits `feat:` que ce plan donne sont fondus en un seul — release-please publie chaque `feat:` de la branche, et la story livre un seul gain à l'utilisateur du plugin — si c'est faux, le changelog porte une ligne là où il en aurait porté deux.
- Technical design ruling: le corps de la pull request d'un amendement énonce chaque ADR écrit, réécrit ou supprimé, sans « parmi ce que l'humain tranche » — le corps d'un amendement dit ce qui a changé et pourquoi, et ne porte pas la liste de ce que la revue tranche qu'un corps d'ouverture porte — si c'est faux, ces mots sont à rétablir, sous leur garde.
- Technical design ruling: `## Amending a Batch` dit que les ADR d'un amendement sont ceux que l'humain a décidés avec l'amendement, qu'ils s'écrivent une fois le document amendé, et que là où `## The ADRs` applique les blocs du lot, l'amendement applique ceux du document amendé qu'aucune story fusionnée n'a déclarés, là où la conception dit seulement « comme l'ouverture » — `## The ADRs` parle du brainstorming et applique tous les blocs du lot, dont un bloc déjà livré ne s'applique plus — si c'est faux, deux phrases répètent ce que le renvoi à `## The ADRs` disait déjà.
- Technical design ruling: `## Amending a Batch` dit qu'un bloc repris au spec delta par la relecture technique fait de l'amendement un amendement qui change le spec delta, comme un comportement repris, et que cet amendement passe alors par la relecture de cohérence, puis de nouveau par la relecture technique, ce que la conception ne dit pas — `## The Technical Reread` renvoie « l'ouverture à l'étape 5 », qu'un amendement n'a pas — si c'est faux, une fin de phrase est à retirer, avec sa garde.
- Technical design ruling: `## Red Flags` de `writing-a-batch` gagne deux lignes que la conception ne demande pas, sur l'amendement ouvert pour un ADR seul et sur l'ADR d'un amendement qu'on ne relirait pas — `CLAUDE.md` veut que l'excuse qui fait sauter une règle ait sa réponse dans cette table — si c'est faux, ces lignes sont à retirer, avec leurs gardes.
- Ruling: `## The ADRs` et `## The Technical Reread` de `writing-a-batch` ne sont pas retouchées, et gardent « during the brainstorming » et « sends the opening back to step 5 » — `## Amending a Batch` dit ce qui diffère pour un amendement, et une règle s'écrit en entier à un seul endroit — si c'est faux, un agent qui suit le renvoi lit une phrase écrite pour l'ouverture avant de lire ce qui la remplace.
- Ruling: un amendement dont le seul ADR est abandonné sur un constat de la relecture technique relance quand même cette relecture, comme `## The Technical Reread` le dit après une suppression, et aucune phrase ne le redit — la relecture rend « nothing to reread » quand plus rien n'a d'objet — si c'est faux, une relecture relit une conception que rien n'a changée.
- Ruling: aucune phrase ne dit qu'un amendement qui ne change que le périmètre ou le flag et écrit un ADR peut voir sa conception technique révisée par la relecture — le corps de la pull request dit déjà ce qui a changé et pourquoi — si c'est faux, une révision de la conception arrive à la revue sans être annoncée comme telle.
- Ruling: le paragraphe « The design reads `docs/adr/`. » de `using-batches` ne gagne aucune phrase sur l'amendement — un amendement ne passe pas par le brainstorming, et la ligne de routage bornée et `## Amending a Batch` disent qui écrit l'ADR — si c'est faux, une phrase est à ajouter à ce paragraphe.
- Ruling: la garde du `README.md` sur la ligne d'amendement qui couvre la conception et les contraintes reste, et une garde neuve tient la ligne entière — la première tient une norme qui vaut toujours — si c'est faux, deux gardes tiennent la même ligne.
- Ruling: le texte livré s'écarte du texte que ce plan donne, après la relecture de la branche, en ces points de `## Amending a Batch` : les ADR « decided with the amendment » ; « once the document is amended », et la phrase sur les blocs à appliquer, qui remplace celle sur les copies ; le corps de la pull request sans « among what the reviewer has to rule on » ; le renvoi à `supercharlouze:using-batches` pour le changement borné ; et le passage par les deux relectures de l'amendement dont un bloc ou un comportement est repris ; avec leurs gardes — chaque point résorbe un constat de relecture, et le plan n'est pas réécrit après son exécution — si c'est faux, le plan se lit comme ce qui a été livré alors qu'il ne l'est plus sur ces points.
- Open ruling: la ligne de la table de routage de `using-batches` est bornée à « outside the opening or the amendment of a batch », comme la conception du lot la donne, alors que `## Step 7 — Answer the Review` de `writing-a-user-story` fait écrire un ADR par une story, à sa revue de livraison — la story `12-us-2-tenir-un-adr` a consigné cet arbitrage et l'a laissé à la story qui borne la ligne, et la conception ne nomme que l'ouverture et l'amendement — si c'est faux, un agent lit la ligne pendant une revue de livraison et ouvre un changement borné pour un ADR que la story devait écrire — reste à trancher : la borne nomme-t-elle aussi la revue de livraison d'une story ; recommandation : oui, la ligne devient « outside the opening or the amendment of a batch and the delivery review of a story », avec sa garde dans `tests/test-skill-content.sh`.

## Observed drift
