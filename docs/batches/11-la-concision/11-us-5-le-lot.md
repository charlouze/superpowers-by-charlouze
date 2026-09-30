# 11-us-5 — Le lot : Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Les skills livrées disent ce que les sections `Batch`, `Batch > Opening a batch` et `Batch > Amending a batch` réécrites exigent.

**Architecture:** Chaque changement de comportement reçoit d'abord ses gardes (`require`, `absent`) dans `tests/*.sh`, puis le texte des skills qui les rend vertes.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/11-la-concision/README.md
**Sections:** Batch, Batch > Opening a batch, Batch > Amending a batch
**Blocks:** D11, D14, D15

## Global Constraints

1. Contraintes du lot, recopiées mot pour mot :
   - `D28` est transcrit au plus tard avec `D13`, avec `D18` et avec `D29`.
   - `D16` et `D25` sont transcrits au plus tard avec `D30`, et `D30` au plus tard avec
     `D9`.
   - `D9` est transcrit au plus tard avec `D7`, et `D7` au plus tard avec `D3` et avec
     `D26`.
   - `D17` est transcrit au plus tard avec `D6`.
   - `D6` et `D12` sont transcrits ensemble.
2. Entre le commit de transcription et l'ouverture de la pull request, aucune tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit changer s'arrête.
3. Quand le lot et la spec se contredisent, la spec gagne, sans exception ni délibération : implémenter ce que dit la spec, consigner un `Ruling:`, et poursuivre. Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.
4. Tout texte écrit suit les règles de `Concision` de `skills/using-batches/SKILL.md` : une chose exacte par phrase, une règle par paragraphe, aucune mise en relief ajoutée, rien qui tombe sous le sens, aucun récit de la manière d'y arriver.
5. Les skills sont intégralement anglaises et ne citent aucune section de `docs/specs/supercharlouze.md`. `grep -rnoE '\(\`[A-Z][A-Za-z ]+\`\)' skills/*/SKILL.md` ne gagne aucune ligne.
6. Ne pas toucher `CHANGELOG.md`, ni `docs/specs/`, ni `docs/batches/`.
7. Git : jamais `git stash`. Chaque `git commit` et `git push` passe par `bash ~/.config/github-app/as-agent.sh git …`. Une commande git par appel shell, sans variable ni sous-shell. Sujet en français, Conventional Commits, type `feat:`. Le message se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et ne porte aucune autre ligne d'attribution. Une correction d'un commit de cette branche est un commit `fixup! <sujet du commit corrigé>`.
8. `bash tests/run-all.sh` finit sur `all tests passed` à la fin de chaque tâche.

## Review Focus

- Une ancienne formulation qui subsiste à côté de la nouvelle : chaque changement porte une garde `absent` sur l'ancienne.
- Un renvoi de section interne à une skill (`(\`Opening the Pull Request\`)`) qui ne résout plus après renumérotation.
- Une aiguille de garde coupée par un retour à la ligne différent : `body_flat` aplatit les lignes, l'aiguille s'écrit sur une ligne avec des espaces simples.

---

### Task 1: L'ouverture relit son document dans une étape à elle

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## Opening, in Order`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, section `# --- writing-a-batch: the ordered opening`, remplacer :

```bash
require writing-a-batch "the opening is stated in order"        "Opening a new batch runs these six steps, in this order"
```

par :

```bash
require writing-a-batch "the opening is stated in order"        "Opening a new batch runs these steps, in this order"
```

et remplacer :

```bash
require writing-a-batch "the document reread is step 6"         "Reread the batch document, then open the pull request"
```

par :

```bash
require writing-a-batch "the document reread is step 6"         "6. **Reread the whole batch document**"
require writing-a-batch "the pull request is step 7"            "7. **Open the pull request** from \`batch/NN-<slug>\`"
```

À la fin de `tests/test-skill-contracts.sh`, avant le bilan final, ajouter :

```bash
# The batch-document reread is a step of its own, before the pull request opens.
absent "no skill folds the document reread into opening the pull request" \
    "Reread the batch document, then open the pull request|these six steps" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/run-all.sh`
Expected: FAIL sur les gardes ajoutées ou modifiées.

- [ ] **Step 3: Réécrire le texte**

Dans `## Opening, in Order`, remplacer `Opening a new batch runs these six steps, in this order.` par `Opening a new batch runs these steps, in this order.`, et l'étape 6 :

```markdown
6. **Reread the batch document, then open the pull request**
   (`Opening the Pull Request`).
```

par :

```markdown
6. **Reread the whole batch document** (`Opening the Pull Request`).
7. **Open the pull request** from `batch/NN-<slug>`, in the same section.
```

Le contrôle de la contrainte 5 compte cinq lignes avant et après : l'étape `Open the pull request` ne met pas son renvoi entre parenthèses.

- [ ] **Step 4: Vérifier que tout passe**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-content.sh tests/test-skill-contracts.sh skills/writing-a-batch/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: l'ouverture relit son document de lot avant sa pull request" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: Un amendement du spec delta est revu comme une ouverture

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## Amending a Batch`)
- Test: `tests/test-skill-content.sh`

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, après la ligne `require writing-a-batch "an amendment branch follows no pattern" …`, ajouter :

```bash
require writing-a-batch "a delta amendment is reviewed as an opening" "An amendment that changes the spec delta is reviewed as an opening"
require writing-a-batch "its blocks go through both rereads"   "its new or changed blocks go through the coherence reread, and the whole document through the batch-document reread"
require writing-a-batch "its body carries what an opening body carries" "the exact text of every new or changed block, and what the coherence reread found"
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/run-all.sh`
Expected: FAIL sur ces gardes.

- [ ] **Step 3: Écrire le texte**

Dans `## Amending a Batch`, juste après le paragraphe qui se termine par `it is an explicit human decision that goes through a review.`, insérer :

```markdown
An amendment that changes the spec delta is reviewed as an opening. Before its
pull request opens, its new or changed blocks go through the coherence reread, and the whole document through the batch-document reread. Its body states the exact text of every new or changed block, and what the coherence reread found. The human reads a block added by amendment at the same gate, and as closely, as one written at opening.
```

(Rewrapper à 80 colonnes environ ; l'aiguille reste sur une ligne une fois aplatie.)

- [ ] **Step 4: Vérifier que tout passe**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-content.sh skills/writing-a-batch/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: un amendement du spec delta est revu comme une ouverture" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 3: Un lot libère les entrées qu'il ne prend plus en charge

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## Amending a Batch`, `## Requalifying a Corrective Batch`)
- Modify: `skills/closing-a-batch/SKILL.md` (`### Release unconsumed reservations`)
- Modify: `skills/adopting-a-module/SKILL.md` (tableau des gestes sur le gaps register)
- Modify: `skills/using-batches/SKILL.md` (`### Override 2`)
- Modify: `skills/writing-a-user-story/SKILL.md` (`**Override 2`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, après les gardes ajoutées par la tâche 2, ajouter :

```bash
require writing-a-batch "an amendment releases what it drops" "An amendment that takes a gaps register entry out of \`Scope\` releases its reservation in the same pull request"
require writing-a-batch "requalification offers a different batch" "**Rule the remaining work a different batch**"
require writing-a-batch "requalification releases what the batch drops" "3. **Release the reservations of the entries the batch no longer takes on.**"
require closing-a-batch "an amendment already released what it dropped" "An entry an amendment took out of \`Scope\` is not among them: that amendment released it."
require adopting-a-module "an amendment releases a reservation" "| Release | \`supercharlouze:writing-a-batch\`, in an amendment pull request |"
require using-batches "requalification releases what the batch drops" "The reservations of the entries the batch no longer takes on are released."
require writing-a-user-story "abandoning leaves the reservation to the amendment or closing" "the amendment that takes its entry out of the scope releases it, or \`supercharlouze:closing-a-batch\` does"
```

À la fin de `tests/test-skill-contracts.sh`, avant le bilan final, ajouter :

```bash
# Entries a batch no longer takes on are released, not merely revised, and an
# amendment releases them before closing does.
absent "no skill merely revises reservations" \
    "reservations are revised|Revise the gaps register reservations|a scope revised mid-flight|and \`supercharlouze:closing-a-batch\` releases it\." \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/run-all.sh`
Expected: FAIL sur les gardes ajoutées.

- [ ] **Step 3: Réécrire les textes**

`skills/writing-a-batch/SKILL.md`, `## Amending a Batch` : après le paragraphe ajouté par la tâche 2, insérer :

```markdown
An amendment that takes a gaps register entry out of `Scope` releases its
reservation in the same pull request: it removes the entry's
`reserved by batch-NN` annotation and leaves the entry.
```

`## Requalifying a Corrective Batch`, étape 1 : remplacer la dernière phrase

```markdown
The gaps-register
   reservation is untouched by all of this — it lives on `main`, posted by the
   opening pull request, and `supercharlouze:closing-a-batch` releases it.
```

par :

```markdown
Abandoning the story
   leaves the gaps-register reservations untouched: they live on `main`, posted
   by the opening pull request.
```

Étape 2 : remplacer la liste des choix et le paragraphe qui la suit par :

```markdown
2. **Put the choice to the human**, who alone may rule:
   - **Correct the spec**: the batch stays corrective, on a reduced scope,
     and the corrected spec ships through its own pull request;
   - **Rewrite the batch as an ordinary batch**, with a real spec delta, through
     an **amendment pull request** reviewed as an opening;
   - **Rule the remaining work a different batch**: it gets a fresh `NN`, and
     this batch is closed with `supercharlouze:closing-a-batch` rather than left
     open.

   The rewrite keeps `NN` and its directory: the number identifies a delivery
   unit, and any story already merged lives under it, so a new number would
   strand them.
```

Étape 3 : remplacer

```markdown
3. **Revise the gaps register reservations** in either case: entries annotated
   `reserved by batch-NN` that are no longer in scope must be released, and
   `supercharlouze:closing-a-batch` releases whatever is left unconsumed.
```

par :

```markdown
3. **Release the reservations of the entries the batch no longer takes on.** A
   reduced or rewritten scope releases them in the amendment pull request that
   changes `Scope`. A batch closed in favour of a fresh one releases them at its
   closing, before the fresh batch reserves them at its own opening: two batches
   never reserve the same entry.
```

`skills/closing-a-batch/SKILL.md`, `### Release unconsumed reservations` : remplacer `Those are the **unconsumed reservations** — a story abandoned, a scope revised mid-flight.` par `Those are the **unconsumed reservations**: a story abandoned, an entry no story resolved. An entry an amendment took out of \`Scope\` is not among them: that amendment released it.`

`skills/adopting-a-module/SKILL.md`, tableau `| Gesture | Who | What it does to the entry |` : après la ligne `| Release | \`supercharlouze:closing-a-batch\`, at closing | …`, ajouter :

```markdown
| Release | `supercharlouze:writing-a-batch`, in an amendment pull request | removes the `reserved by batch-NN` of an entry the amendment takes out of the batch's `Scope`, and leaves the entry |
```

`skills/using-batches/SKILL.md`, `### Override 2` : remplacer `Either way the gaps register reservations are revised.` par `The reservations of the entries the batch no longer takes on are released.`

`skills/writing-a-user-story/SKILL.md`, paragraphe `**Abandoning here does not start by closing a pull request` : remplacer

```markdown
The
reservation posted on `main` by the batch's opening pull request is untouched,
and `supercharlouze:closing-a-batch` releases it.
```

par :

```markdown
The
reservation posted on `main` by the batch's opening pull request is untouched:
the amendment that takes its entry out of the scope releases it, or
`supercharlouze:closing-a-batch` does.
```

- [ ] **Step 4: Vérifier que tout passe**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-content.sh tests/test-skill-contracts.sh skills/writing-a-batch/SKILL.md skills/closing-a-batch/SKILL.md skills/adopting-a-module/SKILL.md skills/using-batches/SKILL.md skills/writing-a-user-story/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: un lot libère les entrées qu'il ne prend plus en charge" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 4: Une story technique requalifiée n'amène que le flag que son bloc exige

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## Requalifying a Technical Story`)
- Modify: `skills/writing-a-user-story/SKILL.md` (`**Override 2`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, remplacer :

```bash
require writing-a-batch "the lost qualification takes the exemption with it" \
    "declares one by that same amendment"
```

par :

```bash
require writing-a-batch "the amendment declares the flag the block requires" \
    "The same amendment declares the flag the block requires, if it requires one."
require writing-a-batch "the exemption question is asked again" \
    "Ask the exemption criterion again of the batch with its new block"
require writing-a-user-story "the human rules the block and its flag" \
    "a block for the observable change, and the flag that block requires, if it requires one"
```

À la fin de `tests/test-skill-contracts.sh`, avant le bilan final, ajouter :

```bash
# A requalified technical story brings the flag its block requires, if any, not a
# flag by default.
absent "no skill makes a lost technical exemption declare a flag" \
    "declares one by that same amendment|a flag if the batch was exempted because all of its stories were technical" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/run-all.sh`
Expected: FAIL sur les gardes ajoutées ou modifiées.

- [ ] **Step 3: Réécrire les textes**

`skills/writing-a-batch/SKILL.md`, `## Requalifying a Technical Story`, remplacer l'étape 3 :

```markdown
3. **A batch exempted from a flag because all of its stories were technical
   declares one by that same amendment.** The exemption rested on the
   qualification the story has just lost; leaving it standing would ship
   observable behaviour with nothing guarding it, which is the whole of what the
   criterion prevents.
```

par :

```markdown
3. **The same amendment declares the flag the block requires, if it requires
   one.** Ask the exemption criterion again of the batch with its new block:
   would one story, merged alone, leave a user facing something incomplete? The exemption drawn from all stories being technical no
   longer holds, so the answer alone decides.
```

`skills/writing-a-user-story/SKILL.md`, `**Override 2` : remplacer

```markdown
and only your human partner may rule what follows — a block for the observable
change, and a flag if the batch was exempted because all of its stories were
technical.
```

par :

```markdown
and only your human partner may rule what follows: a block for the observable
change, and the flag that block requires, if it requires one.
```

- [ ] **Step 4: Vérifier que tout passe**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-content.sh tests/test-skill-contracts.sh skills/writing-a-batch/SKILL.md skills/writing-a-user-story/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: une story technique requalifiée n'amène que le flag que son bloc exige" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 5: La skill garde d'où vient la liste des stories

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## The Batch Document`)
- Test: `tests/test-skill-content.sh`

- [ ] **Step 1: Écrire la garde**

Dans `tests/test-skill-content.sh`, après `require writing-a-batch "no story list in the batch document" …`, ajouter :

```bash
require writing-a-batch "the story list counts pushed branches" "completed by the open pull requests and by the pushed \`story/*\` branches that carry no pull request yet"
```

- [ ] **Step 2: Vérifier que la garde échoue**

Run: `bash tests/run-all.sh`
Expected: FAIL sur cette garde.

- [ ] **Step 3: Réécrire le texte**

Dans `## The Batch Document`, remplacer `The list of stories is the content of the batch directory, completed by the open pull requests.` par `The list of stories is the content of the batch directory, completed by the open pull requests and by the pushed \`story/*\` branches that carry no pull request yet.`

- [ ] **Step 4: Vérifier que tout passe**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-content.sh skills/writing-a-batch/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la liste des stories compte les branches poussées" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: « revu comme une ouverture » est lu comme toute la revue d'ouverture, préparée comme elle. Un amendement qui change le spec delta fait passer ses blocs nouveaux ou changés par la relecture de cohérence, appliqués avec tous les blocs qu'aucune story fusionnée n'a encore déclarés, puis le document entier par la relecture du document de lot ; le corps de sa pull request porte ce que porte celui d'une ouverture — la revue d'ouverture est préparée par ces relectures — si c'est faux, un amendement de delta porte des relectures que la spec n'exige pas.
- Ruling: les entrées que le lot ne prend plus en charge sont libérées dans la pull request d'amendement qui change `Scope` ; un lot clos au profit d'un `NN` neuf les libère à sa clôture, avant que le nouveau lot les réserve — la spec ne nomme pas la pull request qui libère, et le document de lot ne change que par amendement ou à sa clôture — si c'est faux, les skills nomment un moment de libération que l'humain ne voulait pas.
- Ruling: l'implémenteur de la tâche 3 s'est arrêté avant de commiter un arbre conforme au plan ; l'arbre a été vérifié (gardes rouges sur HEAD, `all tests passed` après), commité tel quel puis relu — le refaire aurait produit le même texte — si c'est faux, un défaut de cet arbre n'a eu que la relecture de tâche et la revue finale.
- Ruling: la revue finale a été corrigée en une vague de `fixup!` : les constats importants (la réservation n'est plus confiée à la seule clôture ; la relecture de cohérence d'un amendement lit l'état de tous les blocs en attente), l'exception marquée comme telle, la phrase redite retirée, les choix de requalification dans `using-batches`, des lignes trop longues, `Scope` écrit comme champ — tous dans les sections de la story — si c'est faux, une partie de ce polissage déborde la story.
- Ruling: l'étape `Open the pull request` de l'ouverture renvoie à sa section par « in the same section » et non entre parenthèses — une parenthèse ajouterait une ligne au contrôle des citations de section — si c'est faux, la liste des étapes se lit de façon inégale.
- Ruling: restent hors de la story la réservation d'une entrée ajoutée à `Scope` par amendement, la suppression d'une violation rendue caduque par une correction de spec, le résumé de la revue d'amendement dans le README, la mention d'un amendement dans le premier choix de requalification et le tableau `Red Flags` de `writing-a-batch` — aucun ne bouge avec D11, D14 ou D15 — si c'est faux, ils reviennent dans un lot ultérieur.
- Ruling: la spec l'emporte : la story d'un lot correctif est abandonnée une fois la requalification tranchée, et une pull request déjà ouverte n'est fermée qu'alors ; `writing-a-batch`, `using-batches` et `writing-a-user-story` ne la font plus fermer dès l'arrêt — si c'est faux, une pull request reste ouverte jusqu'à ce que l'humain tranche.

## Observed drift

- `Module > The gaps register` : la spec dit « Un lot réserve les entrées qu'il prend en charge », sans limiter la réservation à l'ouverture. `writing-a-batch` ne fait poser l'annotation `reserved by batch-NN` que par la pull request d'ouverture, et `## Amending a Batch` ne dit rien d'une entrée ajoutée à `Scope` : un lot qui prend une entrée en charge par amendement ne la réserve pas, et un autre lot peut alors la réserver aussi.
- `Batch > Amending a batch` : la spec dit « Quand la condition d'arrêt d'une story technique se déclenche, la story est abandonnée », donc dès l'arrêt. Or abandonner une story, et fermer sa pull request, est toujours une décision humaine : `writing-a-batch` et `writing-a-user-story` gardent la branche et le worktree jusqu'à ce que l'humain décide. C'est la spec qui a tort, et la corriger est un acte humain — Gaps.
