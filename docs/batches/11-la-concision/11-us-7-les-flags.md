# 11-us-7 — Les flags

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Les skills disent ce que disent les sections `Feature flags`, `Code under a feature flag` et `Lifting a feature flag` réécrites.

**Architecture:** Chaque tâche écrit d'abord ses gardes dans `tests/`, puis modifie le texte des skills jusqu'à ce que les gardes passent.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/11-la-concision/README.md
**Sections:** Feature flags, Feature flags > Code under a feature flag, Feature flags > Lifting a feature flag
**Blocks:** D22, D23, D24

## Global Constraints

### Contraintes du lot

- `D28` est transcrit au plus tard avec `D13`, avec `D18` et avec `D29`.
- `D16` et `D25` sont transcrits au plus tard avec `D30`, et `D30` au plus tard avec
  `D9`.
- `D9` est transcrit au plus tard avec `D7`, et `D7` au plus tard avec `D3` et avec
  `D26`.
- `D17` est transcrit au plus tard avec `D6`.
- `D6` et `D12` sont transcrits ensemble.

### Gel du fichier de spec

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

### Autorité

Quand le lot et la spec se contredisent, la spec gagne : implémenter ce qu'elle dit, consigner un `Ruling:`, et poursuivre. Seul un humain corrige une spec en cours de lot.

### Concision

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

### Règles du dépôt

- Les skills livrées sont intégralement en anglais et ne citent aucune section de `docs/specs/supercharlouze.md`. `grep -rnoE '\(\`[A-Z][A-Za-z ]+\`\)' skills/*/SKILL.md` ne renvoie que les lignes de `writing-a-batch` qu'il renvoie aujourd'hui.
- Jamais de `git stash`, sous aucune forme. Pour mettre du travail de côté, faire un commit temporaire.
- Tout `git commit` passe par le wrapper : `bash ~/.config/github-app/as-agent.sh git commit ...`. Une commande git par appel shell, sans variable ni sous-shell.
- Sujet de commit en français, Conventional Commits, type `feat:`. Le message se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et ne porte aucune autre ligne d'attribution.
- Une correction d'un commit de cette branche se commite en `fixup! <sujet du commit corrigé>`.
- `CHANGELOG.md` n'est pas modifié.
- Les gardes se lancent fichier par fichier : `bash tests/test-skill-content.sh` et `bash tests/test-skill-contracts.sh`. Chacun finit sur code 0 quand tout passe.

## Review Focus

- Un implémenteur qui ne lit que les `Global Constraints` d'une story gardée : le bloc des règles du code gardé dit tout ce que dit `Code under a feature flag`, sans renvoi.
- Un texte des skills qui résume ces règles ailleurs que dans le bloc : il reprend les règles nouvelles, pas les anciennes.
- Un lecteur qui cherche la forme de la mention de flag : une seule skill en fixe les formes, et aucune ne la dit fixée par la spec.
- Une garde `absent` dont le motif attrape aussi le texte nouveau : chaque motif est vérifié contre le texte final.

---

### Task 1: Les règles du code gardé

Le bloc que `writing-a-user-story` fait recopier dans les `Global Constraints` d'une story gardée dit ce que dit `Code under a feature flag` réécrite : les situations que le code gardé tient, et ses règles. Disparaissent : la mention de la manière dont le projet active ses flags, la règle séparée de la désactivation et l'exception « aux données produites sous flag activé près », que couvre la règle des mêmes données, et la mise en gras. `using-batches`, qui résume ces règles, suit.

**Files:**
- Modify: `tests/test-skill-content.sh` (bloc `# --- writing-a-user-story: the rules a guarded story copies into Global Constraints`, lignes 380-391)
- Modify: `tests/test-skill-contracts.sh` (ajout avant `exit`)
- Modify: `skills/writing-a-user-story/SKILL.md` (bloc cité après « Copy the block below verbatim: », lignes 469-486)
- Modify: `skills/using-batches/SKILL.md` (paragraphe « Guarded code has rules of its own », ligne 51 ; ligne de `Red Flags` « The flag is just an `if` », ligne 345)

**Interfaces:** aucune.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, remplacer les lignes 380 à 391 (le commentaire et les `require`) par :

```bash
# --- writing-a-user-story: the rules a guarded story copies into Global
# Constraints (spec section "Code under a feature flag") ---
require writing-a-user-story "guarded code holds up in every situation" "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off:"
require writing-a-user-story "both states work on the same data" "The two states work on the same data: what one produces, the other reads and uses, with no error and no data loss."
require writing-a-user-story "flag off restores the former behaviour" "With the flag off, the user finds the behaviour from before the batch."
require writing-a-user-story "both states and their coexistence are tested" "The story's pull request tests the flag-on behaviour, the flag-off behaviour, and their coexistence."
require writing-a-user-story "lifting only removes" "Lifting the flag comes down to deleting the branching and the behaviour from before the batch, without writing anything new."
require using-batches "the guarded-code summary follows the rules" "both states working on the same data, the behaviour from before the batch with the flag off, each state and their coexistence tested, and a lifting that only removes"
require using-batches "the guarded-code red flag follows the rules" "both states work on the same data, the flag off gives back the behaviour from before the batch, the pull request tests each state and their coexistence, and lifting only removes"
```

Dans `tests/test-skill-contracts.sh`, juste avant la ligne `exit $((FAILURES > 0))`, ajouter :

```bash
# The rules for code under a flag were rewritten. The former wording must survive
# nowhere: the positive needles would stay green beside it.
absent "no skill keeps the former guarded-code rules" \
    "Whatever way the project switches its flags|Switching off stays possible at all times|It holds four rules|coexisting on the same data|switching off is always possible|save for the data produced with the flag on" \
    using-batches writing-a-user-story
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-content.sh | grep FAIL` puis `bash tests/test-skill-contracts.sh | grep FAIL`
Expected: les `require` et le `absent` ci-dessus échouent, rien d'autre.

- [ ] **Step 3: Réécrire le bloc de `writing-a-user-story`**

Remplacer le bloc cité qui commence par `> Whatever way the project switches its flags` et finit par `> without writing anything new.` par :

```markdown
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
```

- [ ] **Step 4: Aligner `using-batches`**

Dans le paragraphe qui commence par `**Guarded code has rules of its own, and they travel into the plan.**`, remplacer l'incise `— the two states coexisting on the same data, deactivation always possible, nothing else changing, each state tested, and a lifting that only removes —` par :

```markdown
— both states working on the same data, the behaviour from before the batch with the flag off, each state and their coexistence tested, and a lifting that only removes —
```

Dans `## Red Flags`, remplacer la cellule de droite de la ligne `"The flag is just an `if`, the guarded code can do as it likes"` par :

```markdown
Guarded code holds up when the flag is on for some users, on for everyone, and off: both states work on the same data, the flag off gives back the behaviour from before the batch, the pull request tests each state and their coexistence, and lifting only removes. These rules go into the story's `Global Constraints`.
```

- [ ] **Step 5: Vérifier que tout passe**

Run: `bash tests/test-skill-content.sh | grep -c FAIL` puis `bash tests/test-skill-contracts.sh | grep -c FAIL`
Expected: `0` pour chacun.

- [ ] **Step 6: Commit**

```bash
git add tests/test-skill-content.sh tests/test-skill-contracts.sh skills/writing-a-user-story/SKILL.md skills/using-batches/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: les règles du code gardé suivent la spec réécrite" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: La forme de la mention de flag

La spec ne fixe plus la forme de la mention de flag. `writing-a-user-story`, qui fait écrire la mention, en fixe les formes, et `using-batches` y renvoie au lieu de la dire fixée par la spec.

**Files:**
- Modify: `tests/test-skill-contracts.sh` (garde `shared "the gating sentence is spelled in the spec's one form"`, lignes 208-213 ; ajout avant `exit`)
- Modify: `tests/test-skill-content.sh` (ajout avant `exit`)
- Modify: `skills/writing-a-user-story/SKILL.md` (`## Step 3`, paragraphe « If the batch declares a feature flag for this story's module » et son bloc, lignes 265-271)
- Modify: `skills/using-batches/SKILL.md` (paragraphe « The flag is a specified object », ligne 45)

**Interfaces:** aucune.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-contracts.sh`, remplacer le commentaire et la garde qui commencent par `# The gating sentence has one form, fixed by the spec's template.` par :

```bash
# `writing-a-user-story` fixes the forms of the gating sentence, and
# `using-batches` quotes the one without a lifting condition. Two spellings of
# the same sentence is how a live flag stops being found. One assertion over the
# skills that write it out.
shared "the gating sentence is spelled in its fixed form" \
    "🔒 \`billing.recurring\`, off by default" \
    using-batches writing-a-user-story

# The forms of the gating sentence are neither counted nor designated by their
# rank: the one with a lifting condition is recognised by that condition.
absent "no skill counts or ranks the forms of the gating sentence" \
    "gating sentence of the first form|or of the second when|one of the two forms" \
    using-batches writing-a-user-story
```

Dans le même fichier, juste avant `exit $((FAILURES > 0))`, ajouter :

```bash
# The spec no longer fixes the form of the gating sentence; a skill does.
absent "no skill says the spec fixes the gating sentence's form" \
    "form the spec fixes|form fixed by the spec" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch
```

Dans `tests/test-skill-content.sh`, juste avant `exit $((FAILURES > 0))`, ajouter :

```bash
require writing-a-user-story "the story skill fixes the forms of the gating sentence" \
        "states the flag and its default in a gating sentence, which adds its lifting condition when the declared scope reaches beyond the batch: \`\`\`markdown 🔒 \`billing.recurring\`, off by default 🔒 \`billing.recurring\`, off by default — lifted when"
require writing-a-user-story "the gating sentence names its variable parts" \
        "The flag's name, its default and its lifting condition vary; the rest of each form is fixed."
require using-batches "the form of the gating sentence comes from the story skill" \
        "in one of the forms \`supercharlouze:writing-a-user-story\` fixes"
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-content.sh | grep FAIL` puis `bash tests/test-skill-contracts.sh | grep FAIL`
Expected: les `require` ci-dessus et la garde `no skill says the spec fixes the gating sentence's form` échouent, rien d'autre.

- [ ] **Step 3: Fixer les formes de la mention dans `writing-a-user-story`**

Dans `## Step 3`, remplacer :

````markdown
If the batch declares a feature flag for this story's module, the transcribed spec
change states the flag and its default and, when the declared scope reaches beyond
the batch, its lifting condition:

```markdown
🔒 `billing.recurring`, off by default — lifted when the `facturation` module is fully delivered
```
````

par :

````markdown
If the batch declares a feature flag for this story's module, the transcribed spec
change states the flag and its default in a gating sentence, which adds its
lifting condition when the declared scope reaches beyond the batch:

```markdown
🔒 `billing.recurring`, off by default
🔒 `billing.recurring`, off by default — lifted when the `facturation` module is fully delivered
```

The flag's name, its default and its lifting condition vary; the rest of each form
is fixed.
````

- [ ] **Step 4: Renvoyer `using-batches` à cette forme**

Dans le paragraphe qui commence par `**The flag is a specified object, not an implementation detail.**`, remplacer `in the form the spec fixes` par :

```markdown
in one of the forms `supercharlouze:writing-a-user-story` fixes
```

- [ ] **Step 5: Vérifier que tout passe**

Run: `bash tests/test-skill-content.sh | grep -c FAIL` puis `bash tests/test-skill-contracts.sh | grep -c FAIL`
Expected: `0` pour chacun.

- [ ] **Step 6: Commit**

```bash
git add tests/test-skill-content.sh tests/test-skill-contracts.sh skills/writing-a-user-story/SKILL.md skills/using-batches/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la skill de story fixe les formes de la mention de flag" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 3: Chaque flag est indépendant

`Feature flags` réécrite ajoute que chaque flag s'active, se désactive et se lève indépendamment des autres. Les skills qui déclarent le flag par couple (lot, module) le disent à la suite, dans les mêmes mots.

**Files:**
- Modify: `tests/test-skill-contracts.sh` (ajout avant `exit`)
- Modify: `skills/using-batches/SKILL.md` (`## The Model`, après le paragraphe « The flag is per (batch, module). », ligne 47)
- Modify: `skills/writing-a-batch/SKILL.md` (`## The Feature Flag Field`, après le paragraphe « One flag per (batch, module). », lignes 300-305)

**Interfaces:** aucune.

- [ ] **Step 1: Écrire la garde**

Dans `tests/test-skill-contracts.sh`, juste avant `exit $((FAILURES > 0))`, ajouter :

```bash
# Each flag is independent of the others. The skills that declare a flag per
# (batch, module) say it in the same words.
shared "each flag is independent of the others" \
    "Each flag is switched on, switched off and lifted independently of the others: one flag's lifting story waits for no other flag's." \
    using-batches writing-a-batch
```

- [ ] **Step 2: Vérifier que la garde échoue**

Run: `bash tests/test-skill-contracts.sh | grep FAIL`
Expected: `[FAIL] each flag is independent of the others (missing in: using-batches writing-a-batch)`, rien d'autre.

- [ ] **Step 3: Ajouter le paragraphe dans `using-batches`**

Après le paragraphe qui commence par `**The flag is per (batch, module).**`, insérer un paragraphe (ligne vide avant et après) :

```markdown
Each flag is switched on, switched off and lifted independently of the others: one flag's lifting story waits for no other flag's.
```

- [ ] **Step 4: Ajouter le paragraphe dans `writing-a-batch`**

Après le paragraphe qui commence par `**One flag per (batch, module).**` et finit par `it would be impossible to
write.`, insérer un paragraphe (ligne vide avant et après), coupé à 80 colonnes comme ses voisins :

```markdown
Each flag is switched on, switched off and lifted independently of the others:
one flag's lifting story waits for no other flag's.
```

- [ ] **Step 5: Vérifier que tout passe**

Run: `bash tests/test-skill-contracts.sh | grep -c FAIL`
Expected: `0`.

- [ ] **Step 6: Commit**

```bash
git add tests/test-skill-contracts.sh skills/using-batches/SKILL.md skills/writing-a-batch/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: chaque flag s'active et se lève indépendamment des autres" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: `writing-a-user-story` fixe désormais les formes de la mention de flag, que `Feature flags` ne fixe plus — le `Scope` du lot laisse les formats des documents aux skills et dit qu'aucun autre comportement ne change — si c'est faux, une mention écrite hors de ces formes redevient admise et la forme doit revenir dans la spec.
- Ruling: les skills gardent comme méthode ce que la réécriture retire de `Feature flags` et `Lifting a feature flag` : les familles d'exemption, la période d'observation en deux stories, la distinction entre défaut déclaré et état effectif, le flag qui existe tant que sa mention figure dans la spec, la validation d'une levée à portée étendue à la revue d'ouverture — le `Scope` du lot fait reprendre aux skills la méthode que la spec perd — si c'est faux, chacun de ces passages est une règle que plus aucune spec ne porte, à retirer des skills.
- Ruling: le bloc de règles du code gardé ne porte pas l'indépendance des flags — `Global Constraints` porte les règles de `Code under a feature flag`, et l'indépendance est posée dans `Feature flags` — si c'est faux, un implémenteur qui écrit du code gardé ne voit pas qu'il ne doit rien lier à l'état d'un autre flag.
- Ruling: le bloc de règles du code gardé ne dit plus « whatever way the project switches its flags » — `Code under a feature flag` ne le dit plus et le bloc dit ce qu'elle dit — si c'est faux, un implémenteur peut supposer une manière d'activer les flags que le projet n'a pas.
- Ruling: la ligne `Red Flags` de `using-batches` garde les règles du code gardé en entier — le plan la demande ainsi, elle réfute la pensée qu'elle cite, et les reformulations partielles d'une règle sont un gap non réservé du registre, laissé à l'humain — si c'est faux, cette copie peut dériver du bloc de `writing-a-user-story` sans qu'aucune garde ne le voie.
- Ruling: l'entrée `Mention de flag` de `The model` dit encore que sa forme est fixée dans `Feature flags`, ce qui est faux depuis cette transcription — la story qui transcrira la réécriture de `The model` retire cette phrase, et la spec est gelée ici — si c'est faux, la spec se contredit jusqu'à la fusion de cette story-là.

## Observed drift
