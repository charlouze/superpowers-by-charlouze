# La clôture sans réécriture Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La clôture d'un lot ne réécrit plus sa conception technique.

**Architecture:** `skills/closing-a-batch/SKILL.md` perd le devoir `Rewrite the technical design`, avec ce qui le reflète : sa description, `## Overview`, `## Preconditions` et les lignes de `## Red Flags`. Plus rien dans la skill ne lit les `Technical design ruling:`, qui ne servaient que ce devoir. Les gardes de `tests/` suivent : celles du devoir retiré disparaissent, l'ordre des devoirs et le contrat sur `Technical design ruling:` perdent `closing-a-batch`, et une garde neuve lit le fichier entier pour qu'aucune réécriture n'y survive.

**Tech Stack:** Markdown pour la skill, Bash pour les gardes de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/12-les-adr/README.md
**Sections:** Batch > Closing a batch
**Blocks:** D20

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

- Une skill et un test sont entièrement en anglais.
- Une skill ne cite jamais une section de `docs/specs/supercharlouze.md`. Une section qu'une skill nomme entre parenthèses est l'un de ses propres titres.
- Chaque norme qu'une skill énonce a sa garde dans `tests/`, écrite avant le texte et vue rouge.
- Chaque phrase d'une skill change ce qu'un agent fait. Pas de réfutation d'une version disparue, pas de cas particulier que la règle générale couvre déjà, pas de gras qui hiérarchise, pas de tiret à la place d'une virgule, pas de liste qui annonce combien d'éléments elle tient.
- Une règle est écrite en entier à un seul endroit et pointée ailleurs.
- Cette story ne livre que ce qui réalise `D20`. Seuls `skills/closing-a-batch/SKILL.md`, `tests/test-skill-content.sh` et `tests/test-skill-contracts.sh` sont touchés. La ligne de la table de routage de `skills/using-batches/SKILL.md` sur l'ADR n'est pas touchée.
- Le texte d'une skill donné dans une tâche est écrit tel quel. Un implémenteur qui le juge faux le dit dans son rapport, et ne le réécrit pas.
- Tout commit passe par `bash ~/.config/github-app/as-agent.sh git -C <worktree> commit …` et se termine par la seule ligne d'attribution `Co-Authored-By: Charlouze <me@charlouze.com>`. Jamais de `Co-Authored-By: Claude …`, de `Claude-Session:` ni de « Generated with Claude Code ».
- Pendant une tâche, seuls les fichiers de test qu'elle touche sont lancés (`bash tests/<fichier>.sh`). La suite complète tourne à la fin de la story. Aucun lancement n'est laissé en arrière-plan.

## Review Focus

- La description de la skill, dans le front matter, qui annoncerait encore la réécriture : les gardes `require` et `absent` ne lisent que le corps. La garde neuve de la tâche 1 lit le fichier entier.
- Un agent qui clôt et cherche encore les `Technical design ruling:` pour en tirer quelque chose : la skill ne les nomme plus nulle part. Gardé en tâche 1 par la garde neuve, et le contrat `shared` ne compte plus `closing-a-batch`.
- La borne de l'immuabilité du document de lot, « until closing », doit rester vraie : la clôture retire encore les blocs non livrés et pose `status: closed`. Tenu par la garde `shared` existante de `tests/test-skill-contracts.sh`, que la tâche ne touche pas.
- Les devoirs restants gardent leur ordre, sans le devoir retiré. Gardé en tâche 1.
- Un texte d'une autre skill, de ses `references/`, du `README.md`, de `commands/` ou de `scripts/` qui dirait encore que la clôture réécrit la conception technique, ou en tirerait une raison : la recherche faite à l'écriture du plan n'en trouve aucun, la story `12-us-2-tenir-un-adr` ayant retiré celui de `writing-a-user-story` sous la garde `absent` « describing a mechanism nobody built ».

---

### Task 1: La clôture ne réécrit plus la conception technique

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md` (front matter, `## Overview`, `## Preconditions`, `### Rewrite the technical design`, `## Red Flags`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: rien.
- Produces: rien qu'une autre tâche consomme.

- [ ] **Step 1: Changer et écrire les gardes**

Dans `tests/test-skill-content.sh`, remplacer :

```bash
require closing-a-batch "the preconditions read the design and its rulings" \
    "the technical design rulings the rewrite starts from"
```

par :

```bash
require closing-a-batch "the preconditions read what closing consolidates" \
    "The story documents carry what you are about to consolidate: the drift they observed and the open rulings their \`Rulings log\` leaves."
```

Remplacer :

```bash
require closing-a-batch "the Rulings log feeds the rewrite too" \
    "its \`Technical design ruling:\` lines are what *Rewrite the technical design* starts from"
```

par :

```bash
require closing-a-batch "red flag: the Rulings log's open rulings are closing's" \
    "| \"The Rulings log is the delivery review's business, not mine\" | Its open rulings classified as a violation or a gap are yours to consolidate. The review settled the rest. |"
```

Dans la garde `closing-a-batch: the duties keep their order`, remplacer le motif :

```bash
    *"### Refuse to close on a flag"*"### Consolidate what the story documents left"*"### Release unconsumed reservations"*"### Withdraw the blocks no story delivered"*"### Rewrite the technical design"*"### Set status: closed"*)
```

par :

```bash
    *"### Refuse to close on a flag"*"### Consolidate what the story documents left"*"### Release unconsumed reservations"*"### Withdraw the blocks no story delivered"*"### Set status: closed"*)
```

Remplacer tout le bloc qui va de la ligne `# Closing rewrites the technical design into the mechanism delivered (spec` jusqu'à la garde `the overview names the rewrite` incluse (ses deux lignes `require closing-a-batch "the overview names the rewrite" \` et `    "*Rewrite the technical design* brings its design in line with what was delivered"`) par :

```bash
# Closing no longer rewrites the technical design (spec section "Closing a
# batch"): nothing in closing-a-batch, its description included, says it does,
# nor reads the `Technical design ruling:` lines that served only that rewrite.
# The whole file is read, front matter included, because `require` and `absent`
# read only the body.
CLOSING_FILE="$REPO_ROOT/skills/closing-a-batch/SKILL.md"
if [ ! -f "$CLOSING_FILE" ] || tr '\n' ' ' < "$CLOSING_FILE" | tr -s ' ' \
    | grep -Eq "[Rr]ewrites? the technical design|technical design you are about to rewrite|the rewrite starts from|mechanism the batch delivered|Technical design ruling"; then
    fail "closing-a-batch: no longer rewrites the technical design"
else
    pass "closing-a-batch: no longer rewrites the technical design"
fi
```

Dans `tests/test-skill-contracts.sh`, remplacer :

```bash
# A story writes its departures from the design in a form closing reads back,
# and the batch document spells the same form.
shared "the batch, the story and closing spell a technical design ruling alike" \
    "\`Technical design ruling:\`" \
    writing-a-batch writing-a-user-story closing-a-batch
```

par :

```bash
# A story writes its departures from the design in the form the batch document
# spells.
shared "the batch and the story spell a technical design ruling alike" \
    "\`Technical design ruling:\`" \
    writing-a-batch writing-a-user-story
```

- [ ] **Step 2: Voir les gardes rouges**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: exactement ces trois lignes, toutes de `tests/test-skill-content.sh` :

```
  [FAIL] closing-a-batch: the preconditions read what closing consolidates
  [FAIL] closing-a-batch: red flag: the Rulings log's open rulings are closing's
  [FAIL] closing-a-batch: no longer rewrites the technical design
```

La garde d'ordre et le contrat `shared` restent verts : ils sont moins exigeants qu'avant.

- [ ] **Step 3: La description**

Dans `skills/closing-a-batch/SKILL.md`, remplacer la ligne :

```markdown
description: Use when every user story of a batch is merged or abandoned - consolidates what the story documents left, releases reservations, withdraws undelivered blocks, rewrites the technical design, checks flags and closes the batch
```

par :

```markdown
description: Use when every user story of a batch is merged or abandoned - consolidates what the story documents left, releases reservations, withdraws undelivered blocks, checks flags and closes the batch
```

- [ ] **Step 4: `## Overview`**

Remplacer :

```markdown
— *Withdraw the blocks no story delivered* removes them from it, *Rewrite the technical design* brings its design in line with what was delivered, and *Set status: closed* flips its front matter.
```

par :

```markdown
— *Withdraw the blocks no story delivered* removes them from it, and *Set status: closed* flips its front matter.
```

- [ ] **Step 5: `## Preconditions`**

Dans la puce `**Read the batch document …**`, remplacer :

```markdown
The story documents carry what you are about to consolidate — the drift they observed, the open rulings their `Rulings log` leaves, and the technical design rulings the rewrite starts from; the batch document carries the blocks you are about to check against the `Blocks:` declarations of the story documents, and the technical design you are about to rewrite.
```

par :

```markdown
The story documents carry what you are about to consolidate: the drift they observed and the open rulings their `Rulings log` leaves. The batch document carries the blocks you are about to check against the `Blocks:` declarations of the story documents.
```

- [ ] **Step 6: Le devoir retiré**

Supprimer la section entière, de son titre jusqu'à la ligne vide qui précède `### Set status: closed` :

```markdown
### Rewrite the technical design

When the batch document's `Technical design` is not `none`, rewrite it to describe the mechanism the batch delivered. Start from the `Technical design ruling:` lines in the `Rulings log` of every merged story, and check them against the code on `main`.

Drop what served only the blocks you just withdrew.

The rewritten text is true at closing. After closing, the code is the authority: no later batch keeps this field in step.

The next design on this module reads this field, and a design the stories departed from would send it planning on a mechanism that does not exist.

```

`### Withdraw the blocks no story delivered` est alors suivi, après sa dernière ligne et une ligne vide, de `### Set status: closed`.

- [ ] **Step 7: `## Red Flags`**

Remplacer la ligne :

```markdown
| "The Rulings log is the delivery review's business, not mine" | Its open rulings classified as a violation or a gap are yours to consolidate, and its `Technical design ruling:` lines are what *Rewrite the technical design* starts from. The review settled the rest. |
```

par :

```markdown
| "The Rulings log is the delivery review's business, not mine" | Its open rulings classified as a violation or a gap are yours to consolidate. The review settled the rest. |
```

Supprimer la ligne :

```markdown
| "The technical design was only the plan, it can stay as written" | Then the batch document describes a mechanism the stories departed from, and the next design on this module starts from it. Rewrite it from the `Technical design ruling:` lines and the code. |
```

- [ ] **Step 8: Voir les gardes vertes**

Run: `bash tests/test-skill-content.sh | grep -c FAIL; bash tests/test-skill-contracts.sh | grep -c FAIL; bash tests/test-cross-references.sh | grep -c FAIL; bash tests/test-skill-frontmatter.sh | grep -c FAIL`
Expected: `0` quatre fois.

- [ ] **Step 9: Commiter**

```bash
bash ~/.config/github-app/as-agent.sh git -C <worktree> add skills/closing-a-batch/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git -C <worktree> commit -m "feat: la clôture d'un lot laisse sa conception technique telle quelle" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: la première alternative de la garde neuve devient `[Rr]ewrit[a-z]* (the|its) (batch's )?technical design`, plus large que le texte du plan, et le plan n'est pas réécrit après son exécution — la relecture de la branche a trouvé des formes de réécriture que l'ancienne alternative laissait passer, alors que le commentaire de la garde dit que rien ne les dit — si c'est faux, la garde refuse une phrase légitime de la forme « rewrite … the technical design ».
- Ruling: l'en-tête `# --- closing-a-batch (spec 4.1, 4.2, 5.4) ---` de `tests/test-skill-content.sh` reste tel quel — il précède cette story, et sept autres renvois numérotés à la spec subsistent dans `tests/`, qu'aucun bloc de ce lot ne vise — si c'est faux, ces huit renvois restent à réécrire par leurs titres de section.

## Observed drift
