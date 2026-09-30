# 11-us-8 — Le modèle

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Les skills disent ce que disent les sections `Boundary`, `The model`, `Built on superpowers`, `Departures from superpowers` et `Language` réécrites, et la spec n'a plus de section `Purpose`.

**Architecture:** Chaque tâche écrit d'abord ses gardes dans `tests/`, puis modifie le texte livré jusqu'à ce que les gardes passent. `Boundary`, `Purpose` et `Departures from superpowers` ne changent rien à ce que disent les skills, et n'ont pas de tâche.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/11-la-concision/README.md
**Sections:** Boundary, Purpose, The model, Built on superpowers, Departures from superpowers, Language
**Blocks:** D1, D2, D3, D4, D5, D27

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
- Tout ce que le plugin livre est en anglais, `scripts/` et `tests/` compris.
- Jamais de `git stash`, sous aucune forme. Pour mettre du travail de côté, faire un commit temporaire.
- Tout `git commit` et tout `git push` passent par le wrapper : `bash ~/.config/github-app/as-agent.sh git commit ...`. Une commande git par appel shell, sans variable ni sous-shell.
- Sujet de commit en français, Conventional Commits, type `feat:`. Le message se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et ne porte aucune autre ligne d'attribution.
- Une correction d'un commit de cette branche se commite en `fixup! <sujet du commit corrigé>`.
- `CHANGELOG.md` n'est pas modifié.
- La suite se lance par `bash tests/run-all.sh`, qui finit sur `all tests passed`.

## Review Focus

- Un lecteur du glossaire de `using-batches` qui le compare à `The model` : aucune entrée ne contredit la spec, et le lot correctif n'y a plus un spec delta vide.
- Une garde `absent` dont le motif attrape aussi le texte nouveau : chaque motif est vérifié contre le texte final.
- Le mot « divergence » garde son sens d'écart à un bloc dans `writing-a-user-story` : seules les phrases qui définissent la dérive changent.
- Le format de la ligne `Ruling:` reste écrit dans les skills, que la spec ne porte plus.
- Les motifs français des gardes de `tests/` sont des données qui lisent des documents français, pas de la prose : ils restent.

---

### Task 1: Le spec delta d'un lot correctif ne porte aucun bloc

`The model` ne dit plus qu'un lot correctif a un spec delta vide : son spec delta ne porte aucun bloc.

**Files:**
- Modify: `tests/test-skill-content.sh` (ajout avant `exit`)
- Modify: `tests/test-skill-contracts.sh` (ajout avant `exit`)
- Modify: `skills/using-batches/SKILL.md` (`## The Model`, entrée `**Corrective batch**`, ligne 39)
- Modify: `skills/closing-a-batch/SKILL.md` (paragraphe `**A corrective batch has nothing to compare here**`, ligne 99)

**Interfaces:** aucune.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, juste avant `exit $((FAILURES > 0))`, ajouter :

```bash
require using-batches "a corrective batch's delta carries no block" \
        "**Corrective batch** — a batch that brings existing code back into conformance with a spec that is already true. Its spec delta carries no block."
```

Dans `tests/test-skill-contracts.sh`, juste avant `exit $((FAILURES > 0))`, ajouter :

```bash
# A corrective batch's spec delta carries no block; the field itself is never
# left blank.
absent "no skill says a corrective batch's spec delta is empty" \
    "spec delta is empty" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-content.sh | grep FAIL` puis `bash tests/test-skill-contracts.sh | grep FAIL`
Expected: les gardes ci-dessus échouent, rien d'autre.

- [ ] **Step 3: Réécrire la définition dans `using-batches`**

Remplacer :

```markdown
**Corrective batch** — a batch whose spec delta is empty. It brings existing code back into conformance with a spec that is already true.
```

par :

```markdown
**Corrective batch** — a batch that brings existing code back into conformance with a spec that is already true. Its spec delta carries no block.
```

La phrase qui suit (`Its scope is drawn from a module's gaps register, ...`) ne change pas.

- [ ] **Step 4: Aligner `closing-a-batch`**

Remplacer :

```markdown
Its spec delta is empty by definition — it restores behaviour a spec already promises — so it announced no block a spec could fall short of.
```

par :

```markdown
Its spec delta carries no block, since it restores behaviour a spec already promises, so it announced none a spec could fall short of.
```

- [ ] **Step 5: Vérifier que tout passe**

Run: `bash tests/run-all.sh | grep -E 'FAIL|all tests'`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add tests/test-skill-content.sh tests/test-skill-contracts.sh skills/using-batches/SKILL.md skills/closing-a-batch/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: le spec delta d'un lot correctif ne porte aucun bloc" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: Le glossaire définit la pull request, la revue et la relecture

`The model` définit désormais la pull request, et sépare la revue de la relecture. Le glossaire de `using-batches` les reprend.

**Files:**
- Modify: `tests/test-skill-content.sh` (ajout avant `exit`)
- Modify: `skills/using-batches/SKILL.md` (`## The Model`, après l'entrée `**Delta block**`, ligne 41)

**Interfaces:** aucune.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, juste avant `exit $((FAILURES > 0))`, ajouter :

```bash
# --- using-batches: the glossary terms of the review (spec section "The model") ---
require using-batches "defines the pull request" \
        "**Pull request** — a change proposed for \`main\`, which the human reviews before it reaches \`main\`."
require using-batches "defines the gate" \
        "**Gate** — the human's review of a pull request, whose merge moves a module, a batch or a story forward."
require using-batches "defines the reread" \
        "**Reread** — an agent's check of a piece of work. A reread is not a gate."
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: les gardes ci-dessus échouent, rien d'autre.

- [ ] **Step 3: Ajouter les entrées**

Après le paragraphe qui commence par `**Delta block**`, insérer ces paragraphes (ligne vide avant, entre et après) :

```markdown
**Pull request** — a change proposed for `main`, which the human reviews before it reaches `main`.

**Gate** — the human's review of a pull request, whose merge moves a module, a batch or a story forward.

**Reread** — an agent's check of a piece of work. A reread is not a gate.
```

- [ ] **Step 4: Vérifier que tout passe**

Run: `bash tests/run-all.sh | grep -E 'FAIL|all tests'`
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-content.sh skills/using-batches/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: le glossaire distingue la revue de la relecture" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 3: La dérive est une contradiction

`The model` définit la dérive comme une contradiction entre la spec de `main` et son code, et non plus comme une divergence. Les phrases du plugin qui définissent la dérive suivent. Les autres emplois de « divergence », qui désignent l'écart d'une transcription à son bloc, ne changent pas.

**Files:**
- Modify: `tests/test-skill-contracts.sh` (ajout avant `exit`)
- Modify: `tests/test-cross-references.sh` (ajout après la garde `the README requires no continuous deployment`)
- Modify: `skills/using-batches/SKILL.md` (paragraphe `**The drift rule therefore has no exception:**`, ligne 133)
- Modify: `skills/writing-a-user-story/SKILL.md` (`## Step 6`, puce `Record under **Observed drift**`, ligne 589)
- Modify: `README.md` (lignes 125-126)

**Interfaces:** aucune.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-contracts.sh`, juste avant `exit $((FAILURES > 0))`, ajouter :

```bash
# Drift is a contradiction between spec and code, not a divergence. A divergence
# from a block is another matter and keeps its word.
absent "no skill calls a divergence between spec and code drift" \
    "divergence between (the )?spec" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch
shared "drift is a contradiction between spec and code" \
    "contradiction between the spec on \`main\` and the code on \`main\`" \
    using-batches
```

Dans `tests/test-cross-references.sh`, juste après le bloc `if grep -qi "continuous" ...` qui finit par `fi`, ajouter :

```bash

# The README defines drift as the spec does: a contradiction, not a divergence.
if grep -qi "divergence between the spec" "$REPO_ROOT/README.md"; then
    fail "the README calls drift a contradiction"
else
    pass "the README calls drift a contradiction"
fi
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-contracts.sh | grep FAIL` puis `bash tests/test-cross-references.sh | grep FAIL`
Expected: les gardes ci-dessus échouent, rien d'autre.

- [ ] **Step 3: Réécrire les phrases**

Dans `skills/using-batches/SKILL.md`, remplacer `any divergence between the spec on \`main\` and the code on \`main\` is drift` par `any contradiction between the spec on \`main\` and the code on \`main\` is drift`.

Dans `skills/writing-a-user-story/SKILL.md`, remplacer :

```markdown
- Record under **Observed drift** every divergence between spec and code you
  noticed *outside* this story's scope.
```

par :

```markdown
- Record under **Observed drift** every contradiction between spec and code you
  noticed *outside* this story's scope.
```

Dans `README.md`, remplacer `any divergence between the spec` par `any contradiction between the spec` (le texte coupé à la ligne suivante, `on \`main\` and the code on \`main\` is drift`, ne change pas).

- [ ] **Step 4: Vérifier que tout passe**

Run: `bash tests/run-all.sh | grep -E 'FAIL|all tests'`
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-contracts.sh tests/test-cross-references.sh skills/using-batches/SKILL.md skills/writing-a-user-story/SKILL.md README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la dérive est une contradiction entre la spec et le code" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 4: Les skills gardent la forme de la ligne `Ruling:`

`Built on superpowers` ne donne plus la forme de la ligne d'arbitrage. `using-batches` et `adopting-a-module` la donnent déjà, mot pour mot : la tâche la garde.

**Files:**
- Modify: `tests/test-skill-contracts.sh` (ajout avant `exit`)

**Interfaces:** aucune.

- [ ] **Step 1: Écrire la garde**

Dans `tests/test-skill-contracts.sh`, juste avant `exit $((FAILURES > 0))`, ajouter :

```bash
# The spec names what a ruling carries; the skills keep the form of its line.
shared "the skills keep the form of a ruling line" \
    "\`Ruling: <decision> — <why> — <what it costs if it is wrong>\`" \
    using-batches adopting-a-module
```

- [ ] **Step 2: Vérifier que la garde passe**

Run: `bash tests/test-skill-contracts.sh | grep "form of a ruling line"`
Expected: `[PASS] the skills keep the form of a ruling line`.

- [ ] **Step 3: Vérifier que la garde mord**

Remplacer provisoirement `<what it costs if it is wrong>` par `<cost>` dans `skills/adopting-a-module/SKILL.md`, lancer `bash tests/test-skill-contracts.sh | grep "form of a ruling line"`, constater `[FAIL] the skills keep the form of a ruling line (missing in: adopting-a-module)`, puis rétablir le texte : `git diff skills/` ne montre rien.

- [ ] **Step 4: Commit**

```bash
git add tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: les skills gardent la forme de la ligne d'arbitrage" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 5: L'anglais du plugin couvre ses scripts et ses tests

`Language` range `scripts` et `tests` dans ce que le plugin livre, intégralement en anglais. `using-batches` les ajoute à sa liste. Des commentaires de `tests/` contredisent cette section : l'un cite en français une phrase que la spec ne porte plus, l'autre dit que `tests/` n'est pas livré.

**Files:**
- Modify: `tests/test-skill-content.sh` (ajout avant `exit`)
- Modify: `skills/using-batches/SKILL.md` (`## Language`, puce `**The plugin itself is entirely English**`, ligne 291)
- Modify: `tests/test-gaps-register.sh` (commentaire de la garde `no gaps register entry designates another`, lignes 60-63)
- Modify: `tests/test-cross-references.sh` (commentaire de la garde qui cherche les renvois numérotés au document de conception archivé, lignes 131-132)

**Interfaces:** aucune.

- [ ] **Step 1: Écrire la garde**

Dans `tests/test-skill-content.sh`, juste avant `exit $((FAILURES > 0))`, ajouter :

```bash
require using-batches "the plugin's English covers its scripts and tests" \
        "skills, commands, scripts, tests, README, CLAUDE.md block, messages"
```

- [ ] **Step 2: Vérifier que la garde échoue**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: la garde ci-dessus échoue, rien d'autre.

- [ ] **Step 3: Compléter la liste de `using-batches`**

Remplacer `**The plugin itself is entirely English** — skills, commands, README, CLAUDE.md block, messages.` par `**The plugin itself is entirely English** — skills, commands, scripts, tests, README, CLAUDE.md block, messages.`

- [ ] **Step 4: Réécrire les commentaires**

Dans `tests/test-gaps-register.sh`, remplacer :

```bash
# used — not only when they point at a named entry. An entry that refers to
# itself, or that quotes the spec's own sentence "Les entrées s'ajoutent et se
# suppriment une par une", turns this guard red without containing any
# cross-reference at all.
```

par :

```bash
# used — not only when they point at a named entry. An entry that refers to
# itself, or that quotes a spec sentence naming entries, turns this guard red
# without containing any cross-reference at all.
```

Dans `tests/test-cross-references.sh`, remplacer :

```bash
#    tests/ is deliberately out of range — it is not shipped to users, and the
#    gaps register entry this guard answers to names only the shipped artifacts.
```

par :

```bash
#    tests/ is deliberately out of range: the gaps register entry this guard
#    answers to names only the documents, skills, commands and scripts.
```

- [ ] **Step 5: Vérifier que tout passe**

Run: `bash tests/run-all.sh | grep -E 'FAIL|all tests'`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add tests/test-skill-content.sh tests/test-gaps-register.sh tests/test-cross-references.sh skills/using-batches/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: l'anglais du plugin couvre ses scripts et ses tests" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 6: Les cas de `Blocks: none` sont des exemples

`The user story document` ne dit plus quelles stories déclarent `Blocks: none`, seulement qu'une story qui ne transcrit aucun bloc le déclare. `writing-a-user-story` énumère des cas après deux-points, ce qui se lit comme une liste fermée : elle les donne en exemples.

**Files:**
- Modify: `tests/test-skill-content.sh` (ajout avant `exit`)
- Modify: `skills/writing-a-user-story/SKILL.md` (`## Step 4`, paragraphe qui commence par `` `Blocks:` declares ``, lignes 351-354)

**Interfaces:** aucune.

- [ ] **Step 1: Écrire la garde**

Dans `tests/test-skill-content.sh`, juste avant `exit $((FAILURES > 0))`, ajouter :

```bash
require writing-a-user-story "the cases of Blocks: none are examples" \
        "\`none\` for a story that transcribes none, such as a corrective batch's story, a technical story or a teardown story."
```

- [ ] **Step 2: Vérifier que la garde échoue**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: la garde ci-dessus échoue, rien d'autre.

- [ ] **Step 3: Réécrire l'énumération**

Remplacer :

```markdown
`none` for a story that transcribes none: a corrective batch's story, a technical
story, a teardown story.
```

par :

```markdown
`none` for a story that transcribes none, such as a corrective batch's story, a
technical story or a teardown story.
```

- [ ] **Step 4: Vérifier que tout passe**

Run: `bash tests/run-all.sh | grep -E 'FAIL|all tests'`
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-content.sh skills/writing-a-user-story/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: les cas de Blocks: none sont des exemples" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: les tâches passent par un seul implémenteur et une seule relecture de tâche — chacune est une garde et une retouche de texte de même forme — si c'est faux, une relecture couvre tous les commits et une correction vise un commit antérieur.
- Ruling: l'implémenteur a mis à jour la garde existante « Blocks none covers the technical story », hors de la liste de fichiers de la tâche « Les cas de `Blocks: none` sont des exemples » — elle figeait l'énumération que la tâche réécrit, et la laisser rouge cassait la suite — si c'est faux, une garde que le plan ne nommait pas a changé ; la correction finale l'a ensuite supprimée, redondante avec la nouvelle.
- Ruling: la puce de `using-batches` sur l'anglais du plugin devient une exception et perd « it has only skeleton » — `Language` réécrite la présente comme une exception, et les skills sont surtout de la prose — si c'est faux, la puce redevient une règle parallèle aux autres.
- Ruling: la ligne de 93 caractères de `writing-a-user-story` (`Step 4`) reste — aucune largeur n'est imposée et le fichier en porte déjà 39 plus longues — si c'est faux, une remise à la ligne.
- Ruling: les motifs français des gardes de `tests/` restent — ce sont des données qui lisent des documents et des sujets de commit français, pas de la prose — si c'est faux, `Language` interdit ces gardes et il faut lire ces documents autrement.
- Ruling: l'entrée `The model / The user story document` du gaps register, qui cite encore la dérive comme une divergence, est consignée sous `Observed drift` et non corrigée ici — seule la clôture ajoute ou réécrit des entrées dans un lot — si c'est faux, la clôture laisse une entrée qui cite mal `The model`.
- Ruling: à la revue, la dérive est un code de `main` qui contredit la spec de `main`, ou un comportement de `main` qu'aucune spec ne décrit, dans `The model`, `using-batches`, `writing-a-user-story` et le README ; le constat qui était consigné sous `Observed drift` est retiré, et l'arbitrage sur l'entrée `The model / The user story document` devient sans objet, puisque « divergence » y résume de nouveau la définition — « contradiction » laissait hors de la dérive les gaps que `Observed drift` reçoit et que la clôture consolide — si c'est faux, la dérive redevient une contradiction, et `Observed drift` reçoit des gaps qu'aucune définition ne lui donne.
- Ruling: à la revue, aucune skill ne dit plus que le plugin est intégralement anglais : `using-batches`, `adopting-a-module` et `writing-a-batch` perdent cette phrase, que `Language` garde dans la spec, et l'arbitrage sur la puce de `using-batches` devient sans objet — cette règle vaut pour le dépôt du plugin, pas pour les projets où les skills travaillent — si c'est faux, un agent qui modifie le plugin ne trouve cette règle que dans la spec.

## Observed drift
