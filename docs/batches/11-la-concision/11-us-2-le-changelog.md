# Le changelog Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Les skills cessent d'écrire un changelog, la clôture retire du document de lot les blocs non livrés, le changement borné vit sur `bounded/<slug>`, la détection de concurrence lit une branche qui n'a encore rien déclaré par les sections qu'elle a modifiées, et la mention d'un flag devient le seul marqueur admis dans une spec.

**Architecture:** Une tâche par changement du plugin. Chacune écrit d'abord ses gardes dans `tests/`, les voit échouer, puis modifie les skills et le `README.md`.

**Tech Stack:** Markdown (skills, README), bash (gardes de `tests/`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/11-la-concision/README.md
**Sections:** Module > The spec document, Batch > Closing a batch, Story > Concurrency detection, Bounded change, Changelog
**Blocks:** D9, D16, D19, D25, D30

## Global Constraints

1. Contraintes du lot, recopiées mot pour mot :
   - `D28` est transcrit au plus tard avec `D13`, avec `D18` et avec `D29`.
   - `D16` et `D25` sont transcrits au plus tard avec `D30`, et `D30` au plus tard avec
     `D9`.
   - `D9` est transcrit au plus tard avec `D7`, et `D7` au plus tard avec `D3` et avec
     `D26`.
   - `D17` est transcrit au plus tard avec `D6`.
   - `D6` et `D12` sont transcrits ensemble.
2. Gel du fichier de spec :

   > Between the first commit of the branch and the opening of the pull request, no
   > task modifies the spec file. A story that discovers the spec must change stops.

3. Autorité : quand le lot et la spec se contredisent, la spec gagne, sans exception et sans délibération. Implémenter ce que dit la spec, consigner un `Ruling:`, et poursuivre. Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.
4. Tout texte écrit suit la section `Concision` de `skills/using-batches/SKILL.md` : une règle par paragraphe, chaque phrase dit une chose exacte une seule fois, rien qui tombe sous le sens, aucun gras de mise en relief, aucun récit de la manière dont on y est arrivé.
5. Les skills livrées sont intégralement en anglais et ne citent jamais une section de `docs/specs/supercharlouze.md`. Contrôle : `grep -rnoE '\(`[A-Z][A-Za-z ]+`\)' skills/*/SKILL.md` ne gagne aucune ligne.
6. Un détail que la spec a perdu (une méthode, une raison, un exemple) reste dans la skill qui s'en sert. Seul ce que la spec a changé change dans les skills.
7. Hors périmètre : `CHANGELOG.md` à la racine (celui de release-please), et les sections `Concision` et `Conversation` de `using-batches`.
8. Commits : sujet en français, Conventional Commits, type `feat:`, un sujet par commit, message terminé par `Co-Authored-By: Charlouze <me@charlouze.com>` et sans autre attribution. Toute commande `git commit` passe par `bash ~/.config/github-app/as-agent.sh git commit …`. Une commande git par appel shell, sans variable ni sous-shell autour. Aucune tâche ne pousse.

## Review Focus

- Plus aucun fichier de `skills/`, frontmatter compris, ni le `README.md`, ne nomme un changelog.
- La clôture ne compte ni ne numérote ses devoirs : chaque renvoi nomme un devoir par son titre.
- Un bloc non livré n'entre au gaps register que si l'humain le décide.
- Une branche poussée qui n'a rien déclaré n'arrête plus une story ; seule une déclaration illisible l'arrête.
- Les deux bouts de chaque couplage (`using-batches` et `writing-a-user-story`) disent la détection dans les mêmes mots.

---

### Task 1: Aucune skill n'écrit plus de changelog

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md`
- Modify: `skills/adopting-a-module/SKILL.md` (puce `Changelog` de l'étape 4, gabarit de spec)
- Modify: `skills/using-batches/SKILL.md` (`What a Spec Says`, table des revues, règle (a) du changement borné, `Red Flags`)
- Modify: `skills/writing-a-batch/SKILL.md` (`Amending a Batch`)
- Modify: `README.md` (diagramme `gitGraph`, table des revues)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`, `tests/test-cross-references.sh`

**Interfaces:**
- Produces: la clôture compte cinq devoirs, numérotés 1 à 5 : 1 flags, 2 consolidation, 3 réservations, 4 blocs non livrés, 5 statut. La Task 2 réécrit le devoir 4.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh` :
- supprimer `require closing-a-batch "one changelog line per batch"           "one line per batch"` ;
- supprimer `require using-batches "the rule covers the changelog cell"      "including the changelog's \`change\` cell"` ;
- remplacer les lignes `require using-batches "a silent bounded change writes no changelog line" \` / `"the spec stays silent and no changelog line is written"` par :

```bash
require using-batches "a silent bounded change leaves the spec untouched" \
        "the spec stays silent. That third case is not a tolerance"
```

- ajouter, sous `# --- closing-a-batch (spec 4.1, 4.2, 5.4) ---` :

```bash
require closing-a-batch "five duties"                            "Five duties, one pull request"
require closing-a-batch "the flag check precedes the four writers" "it comes before the four that write"
```

Dans `tests/test-skill-contracts.sh`, juste avant `exit $((FAILURES > 0))` :

```bash
# The specs carry no changelog any more. No shipped skill file names one:
# frontmatter and references included, which `body_flat` would skip.
CHANGELOG_HITS="$(grep -rli 'changelog' "$REPO_ROOT/skills" || true)"
if [ -z "$CHANGELOG_HITS" ]; then
    pass "no skill file names a changelog"
else
    fail "no skill file names a changelog (present in: $(echo $CHANGELOG_HITS))"
fi
```

Dans `tests/test-cross-references.sh` :
- remplacer `for needle in "out-of-batch" "if and only if nothing observable" "fix/" "no feature flag"; do` par `for needle in "if and only if nothing observable" "fix/" "no feature flag"; do` ;
- ajouter après le bloc `the README does not assert the unconditional spec update` :

```bash
# The specs carry no changelog any more, and the README says nothing of one.
if grep -qi "changelog" "$REPO_ROOT/README.md"; then
    fail "the README names no changelog"
else
    pass "the README names no changelog"
fi
```

- [ ] **Step 2: Run the guards and see them fail**

Run: `bash tests/run-all.sh 2>&1 | grep FAIL`
Expected: FAIL sur `five duties`, `the flag check precedes the four writers`, `a silent bounded change leaves the spec untouched`, `no skill file names a changelog`, `the README names no changelog`.

- [ ] **Step 3: Rewrite closing-a-batch**

Dans `skills/closing-a-batch/SKILL.md` :
- frontmatter : `writes the changelog, consolidates what the story documents left` devient `consolidates what the story documents left` ;
- `Six duties, one pull request, on a branch named \`batch/NN-<slug>-close\`. Duty 1 is allowed to refuse, and because it is allowed to refuse it comes before the five that write.` devient `Five duties, one pull request, on a branch named \`batch/NN-<slug>-close\`. Duty 1 is allowed to refuse, and because it is allowed to refuse it comes before the four that write.` ;
- `## The Six Duties` devient `## The Five Duties`, et `Do all six on the same branch` devient `Do all five on the same branch` ;
- `The five others all write: changelog lines into every touched spec, consolidated findings and recorded shortfalls into the gaps registers, released reservations, the closed status.` devient `The four others all write: consolidated findings into the gaps registers, released reservations, the amended batch document, the closed status.` ;
- `a second attempt would append the changelog line a second time, re-append every consolidated finding, and find reservations duty 4 had already released` devient `a second attempt would re-append every consolidated finding, and find reservations duty 3 had already released` ;
- supprimer la section `### 2. Write the changelog line` en entier, jusqu'à la ligne qui précède `### 3.` ;
- renuméroter : `### 3. Consolidate` → `### 2. Consolidate`, `### 4. Release` → `### 3. Release`, `### 5. Record blocks` → `### 4. Record blocks`, `### 6. Set status` → `### 5. Set status` ;
- `duty 5 catches it undelivered, not this one` devient `duty 4 catches it undelivered, not this one` ;
- `Adding an entry appends at the end of its category and competes with every other addition to the same module — the same contention duty 2 avoids, solved the same way: a single writer per batch.` devient `Adding an entry appends at the end of its category and competes with every other addition to the same module, and a single writer per batch removes that contention.` ;
- `duty 4 is the whole of this duty for a corrective batch` devient `duty 3 is the whole of this duty for a corrective batch` ;
- `it is the record that the other five were done` devient `it is the record that the other four were done` ;
- `## Language` : retirer `the \`change\` cell of a changelog line, ` de l'énumération de la prose ;
- `## Red Flags` : supprimer la ligne `"The changelog is already up to date, each story added its line"` ; `duty 5 checks the rest` devient `duty 4 checks the rest` ; `The whole point of duty 5 is the difference.` devient `The whole point of duty 4 is the difference.`

Puis `grep -n "duty [0-9]\|duties" skills/closing-a-batch/SKILL.md` : chaque renvoi désigne le devoir de ce numéro.

- [ ] **Step 4: Rewrite the other skills and the README**

`skills/adopting-a-module/SKILL.md` :
- supprimer la puce qui commence par `- Add the empty \`Changelog\` table` (trois lignes, jusqu'à `\`out-of-batch\` line, from its own pull request.`) ;
- dans le gabarit `The shape of the spec`, supprimer les lignes `## Changelog`, la ligne vide qui suit, `| batch | date | change |` et `|---|---|---|`, ainsi que la ligne vide qui les précède.

`skills/using-batches/SKILL.md` :
- `the review held against it, the drift rule, the gaps register, the changelog. It would read as a norm and be none.` devient `the review held against it, the drift rule, the gaps register. It would read as a norm and be none.` ;
- `**Scope.** These clauses bear on the spec file, **all of its lines**, including the changelog's \`change\` cell: this is a property of the document` devient `**Scope.** These clauses bear on the spec file, **all of its lines**: this is a property of the document` ;
- table des revues : `| Batch closing | the pull request carrying the changelog, the consolidation and \`status: closed\` |` devient `| Batch closing | the pull request carrying the consolidation and \`status: closed\` |` ;
- règle (a) : `it updates the spec in the same pull request as the code, with an \`out-of-batch\` changelog line — handling only the "alters" case would reopen the same hole one notch over.` devient `it updates the spec in the same pull request as the code. Handling only the "alters" case would reopen the same hole one notch over.` ; `the spec stays silent and no changelog line is written.` devient `the spec stays silent.` ;
- `## Red Flags`, ligne `"This is a small fix, the spec can stay silent about it"` : la réponse devient `Only if nothing observable at the module's boundary changes. The moment behaviour moves, the spec is updated in the same pull request, and either way the change declares the spec it targets and the sections it touches.`

`skills/writing-a-batch/SKILL.md`, `## Amending a Batch` : `Edit the batch document **in place** — no\nchangelog inside it, no history of its own scope — and say in the pull request\nbody what changed and why.` devient `Edit the batch document in place, with no history of its own scope inside it, and say in the pull request body what changed and why.`

`README.md` :
- `commit id: "changelog, consolidation, closed"` devient `commit id: "consolidation, closed"` ;
- `| Batch closing | the changelog, the consolidation, \`status: closed\` |` devient `| Batch closing | the consolidation, \`status: closed\` |`.

- [ ] **Step 5: Run the suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`. Puis `grep -rni changelog skills README.md` ne renvoie rien, et `git diff --stat` ne montre ni `CHANGELOG.md` ni `docs/specs/`.

- [ ] **Step 6: Commit**

```bash
git add skills tests README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: aucune skill n'écrit plus de changelog" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 2: La clôture retire du document de lot les blocs non livrés

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md` (frontmatter, `Overview`, devoir 4)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la numérotation à cinq devoirs de la Task 1 ; le devoir 4 s'appelle `### 4. Record blocks announced but never delivered` en entrée.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh`, sous les autres `require closing-a-batch` du devoir des blocs :

```bash
require closing-a-batch "the duty withdraws undelivered blocks"  "### 4. Withdraw the blocks no story delivered"
require closing-a-batch "a withdrawn block leaves the batch document" "Remove it from the batch document's \`Spec delta\`"
require closing-a-batch "the human decides whether each joins the register" "Ask your human partner whether it joins the gaps register"
```

Dans `tests/test-skill-contracts.sh`, avant le bloc `no skill file names a changelog` :

```bash
# Closing used to file every undelivered block as a gap on its own. The human
# now decides, block by block; a leftover of the old duty would file them all.
absent "no skill files an undelivered block as a gap on its own" \
    "Write the shortfall into the gaps register|inscribed in the gaps register as" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Run the guards and see them fail**

Run: `bash tests/run-all.sh 2>&1 | grep FAIL`
Expected: FAIL sur les `require` ci-dessus et sur `no skill files an undelivered block as a gap on its own`.

- [ ] **Step 3: Rewrite the duty**

Dans `skills/closing-a-batch/SKILL.md` :
- frontmatter : `releases reservations, checks flags and closes the batch` devient `releases reservations, withdraws undelivered blocks, checks flags and closes the batch` ;
- `Overview` : `*Record blocks announced but never delivered* amends it so it no longer promises what it did not deliver` devient `*Withdraw the blocks no story delivered* removes them from it` ;
- remplacer le titre et les trois premiers paragraphes du devoir 4 (du titre jusqu'au paragraphe qui commence par `Both, not either.` inclus) par :

```markdown
### 4. Withdraw the blocks no story delivered

Read the `Blocks:` field of every story document in the batch directory, and collect the `D<n>` identifiers they declare; a `none` declares nothing. A block the batch document's `Spec delta` defines and that no collected declaration names is a block announced but never delivered: a story abandoned, a scope cut along the way. For each one:

1. Remove it from the batch document's `Spec delta`, so the document no longer promises what the batch did not deliver.
2. Ask your human partner whether it joins the gaps register. If they say yes, write it under **Gaps** in the register of the module concerned.

Without this duty the abandonment is invisible. It is not drift, since the spec and the code agree: both are silent about the feature. And nothing else records it.

Whether an undelivered block is still wanted is your human partner's call. A block may have been dropped because its scope was given up, and a gap filed for it would ask a later batch to deliver what nobody wants.
```

Les paragraphes qui suivent (`The batch directory on \`main\` holds exactly the batch's merged stories.`, `Read the declarations, not the specs.`, `A corrective batch has nothing to compare here`) restent.

- [ ] **Step 4: Run the suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills tests
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la clôture retire du document de lot les blocs non livrés" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 3: La branche d'un changement borné devient `bounded/<slug>`

**Files:**
- Modify: `skills/using-batches/SKILL.md`, `skills/writing-a-user-story/SKILL.md`, `skills/writing-a-batch/SKILL.md`, `README.md`
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`, `tests/test-cross-references.sh`

**Interfaces:**
- Produces: le patron `bounded/<slug>`, et `bounded/*` comme patron qui revendique des sections. La Task 4 s'appuie sur ces noms.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh`, la garde `the patterns are all named` remplace `` \`fix/<slug>\` `` par `` \`bounded/<slug>\` `` dans son aiguille.

Dans `tests/test-cross-references.sh`, la liste des aiguilles devient `for needle in "if and only if nothing observable" "bounded/" "no feature flag"; do`, et on ajoute après le bloc `the README names no changelog` :

```bash
# A bounded change lives on `bounded/<slug>`; the former name survives nowhere.
if grep -q "fix/" "$REPO_ROOT/README.md"; then
    fail "the README names no fix/ branch"
else
    pass "the README names no fix/ branch"
fi
```

Dans `tests/test-skill-contracts.sh`, avant le bloc `no skill file names a changelog` :

```bash
# A bounded change's branch is `bounded/<slug>`. A skill still naming the former
# pattern would scan, or create, a branch nobody else reads as a claim.
absent "no skill names the former bounded branch" \
    "\`fix/" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Run the guards and see them fail**

Run: `bash tests/run-all.sh 2>&1 | grep FAIL`
Expected: FAIL sur `the patterns are all named`, `bounded path states: bounded/`, `the README names no fix/ branch`, `no skill names the former bounded branch`.

- [ ] **Step 3: Rename the pattern**

Remplacer `fix/<slug>` par `bounded/<slug>` et `fix/*` par `bounded/*` partout dans `skills/using-batches/SKILL.md`, `skills/writing-a-user-story/SKILL.md`, `skills/writing-a-batch/SKILL.md` et `README.md`. Occurrences attendues : `grep -n "fix/" skills/*/SKILL.md README.md` les liste toutes (using-batches : `Concurrency`, règle (b), paragraphe de l'angle mort, dernière phrase de `Bounded`, `Red Flags` ; writing-a-user-story : Step 1 points 1 et 2, `Red Flags` ; writing-a-batch : `Amending a Batch` ; README : `Two stories at once`, `What stays outside a batch`). Ne rien reformuler d'autre : la Task 4 réécrit la détection.

- [ ] **Step 4: Run the suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`. Puis `grep -rn "fix/" skills README.md` ne renvoie rien.

- [ ] **Step 5: Commit**

```bash
git add skills tests README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la branche d'un changement borné devient bounded/<slug>" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 4: La détection lit une branche qui n'a rien déclaré par les sections qu'elle a modifiées

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (Step 1, Step 2, `Red Flags`)
- Modify: `skills/using-batches/SKILL.md` (`The Git Model`, `Authority and Conflict Rules > Concurrency`, règle (b) du changement borné, `Red Flags`)
- Modify: `skills/adopting-a-module/SKILL.md` (restauration du nom de branche)
- Modify: `README.md` (`Why everything lands on main`, `Two stories at once`)
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: `bounded/<slug>` et `bounded/*` (Task 3).
- Produces: des phrases partagées, mot pour mot, par `using-batches` et `writing-a-user-story` :
  - `every remote \`story/*\` or \`bounded/*\` branch that carries no pull request yet`
  - `A pushed branch that carries no declaration yet is read by the sections it has already changed`

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-contracts.sh`, remplacer le bloc `shared "a branch with no declaration yet is scoped by what it changed" \` / `"concerns the spec it has already changed" \` / `using-batches writing-a-user-story` par :

```bash
shared "a branch with no declaration yet is read by what it changed" \
    "A pushed branch that carries no declaration yet is read by the sections it has already changed" \
    using-batches writing-a-user-story

# Pushed branches with no pull request are read under both patterns that claim
# sections. A scan of `story/*` alone misses a pushed bounded change.
shared "both claiming patterns are read before their pull request" \
    "every remote \`story/*\` or \`bounded/*\` branch that carries no pull request yet" \
    using-batches writing-a-user-story

# A branch that has not declared yet used to stop a story as soon as it had
# changed the story's spec file. The sections it changed now stand in for its
# declaration, so that stop must survive nowhere.
absent "a branch with no declaration yet is not an unknown" \
    "concerns the spec it has already changed|it is an unknown and stops you" \
    using-batches writing-a-user-story
```

- [ ] **Step 2: Run the guards and see them fail**

Run: `bash tests/run-all.sh 2>&1 | grep FAIL`
Expected: FAIL sur ces gardes.

- [ ] **Step 3: Rewrite Step 1 of writing-a-user-story**

Dans `skills/writing-a-user-story/SKILL.md` :

Le premier paragraphe de Step 1 devient :

```markdown
Two stories, or a story and a bounded change, touching the same section of the
same spec are a conflict. Decide which sections this story will touch, then
check that nobody else holds them.
```

Le point 3 (du titre en gras jusqu'au paragraphe `A branch whose story document does not exist yet …` inclus) devient :

````markdown
3. **Read the same declaration on every remote `story/*` or `bounded/*` branch
   that carries no pull request yet.** A story's pull request opens only at the
   end of Step 5, so a sibling holds its sections for the whole length of an
   implementation without appearing in point 1 above. Its branch, however, is on
   the remote from its very first commit (Step 3), so the remote sees it:

   ```bash
   git ls-remote --heads origin 'story/*' 'bounded/*'
   git fetch origin
   git show origin/<branch>:docs/batches/NN-<slug>/NN-us-N-<slug>.md
   git diff origin/main...origin/<branch> -- docs/specs/<module>.md   # no declaration yet
   ```

   Skip the branches already covered by a pull request in point 1, and skip
   your own.

   A pushed branch that carries no declaration yet is read by the sections it
   has already changed. That is a story branch between its spec commit and its
   plan commit, or a bounded change before its pull request opens. Diff it
   against `main` on your spec file, and take as claimed every section a hunk
   touches, named by the heading path it falls under in the branch's version,
   or in `main`'s for a removed section. A branch that changed nothing in your
   spec file claims nothing against you.
````

Le point 6 devient :

```markdown
6. **Stop if you could not read a declaration**: fetch failed, story document
   without its `Sections:` field, pull request body silent on a bounded change.
   An unread declaration is an unknown, not a pass. Name the pull request or the
   branch and say why, and let your human partner decide. Silently treating it
   as empty turns the one real net into "found nothing". A pushed branch that has
   not declared yet is not an unknown: point 3 reads it by what it changed. Nor
   is a bounded change having no story document: its declaration is in its pull
   request body, read per point 2.
```

Le paragraphe `Name the blind spot rather than trusting the net.` : `open pull requests, and pushed story branches` devient `open pull requests, and pushed \`story/*\` and \`bounded/*\` branches`.

Le paragraphe `Sections are **declared, not derived**` devient :

```markdown
Sections are declared, not derived, wherever a declaration exists: reading a
diff to guess which sections a story touches is fragile, whereas the story's
author knows them. The diff stands in only for a pushed branch that has not
declared yet, and it shows only what that branch has already changed.
```

Step 2 : `The two remote ones are exactly the two scans Step 1\nruns` devient `The two remote ones are the two sources Step 1 reads`.

`Red Flags`, ligne `"No open pull request touches this spec, so the section is free"` : `read the pushed \`story/*\` branches too` devient `read the pushed \`story/*\` and \`bounded/*\` branches too`.

- [ ] **Step 4: Rewrite the rule in using-batches**

Dans `skills/using-batches/SKILL.md` :

`The Git Model` : `Concurrency detection has exactly two sources, the open pull requests and the pushed \`story/*\` branches` devient `Concurrency detection has exactly two sources, the open pull requests and the pushed \`story/*\` and \`bounded/*\` branches`.

Le paragraphe `**Concurrency.**` de `Authority and Conflict Rules` est remplacé par ces paragraphes :

```markdown
**Concurrency.** Two stories, or a story and a bounded change, touching the same section of the same spec are a conflict. Only `story/*` and `bounded/*` branches claim sections, so the filter is the branch name. Filtering instead on the spec file a pull request touches made a corrective story invisible, since its pull request touches no spec at all.

Each claimant declares its spec and its sections: a story in its story document, where `Spec:` names the spec and `Sections:` the sections; a bounded change in its pull request body. A starting story reads the declarations of the open pull requests on those branches, and of every remote `story/*` or `bounded/*` branch that carries no pull request yet. A pushed branch that carries no declaration yet is read by the sections it has already changed. Both sources are needed: a story's pull request opens only at the very end of its implementation, and for that whole stretch its pushed branch is the only thing that shows it holds its sections.

The git merge conflict is only a partial safety net. Git conflicts on lines, not on sections, so two stories editing the same section far apart merge cleanly.
```

Règle (b) du changement borné : `the same open pull requests and the same pushed \`story/*\` branches to scan` devient `the same open pull requests and the same pushed \`story/*\` and \`bounded/*\` branches to scan`.

Le paragraphe `**A bounded change is in turn invisible until its own pull request opens, and that is accepted.**` est remplacé par :

```markdown
  Before its pull request opens, a bounded change's branch carries no declaration, since the declaration lives in the pull request body. Once pushed, it is read like any branch that has not declared yet, by the sections it has already changed. Unpushed, it is invisible, like any branch the remote does not carry.
```

`Red Flags`, ligne `"Git will conflict if two stories touch the same section"` : la réponse devient `Git conflicts on lines, not sections; two edits far apart in one section merge cleanly. Compare the declared \`Sections:\` fields against the open pull requests whose branch is \`story/*\` or \`bounded/*\`, and against every remote \`story/*\` or \`bounded/*\` branch that carries no pull request yet. The filter is the branch name, and a pull request that touches no spec holds its sections all the same.`

- [ ] **Step 5: Align adopting-a-module and the README**

`skills/adopting-a-module/SKILL.md` : `the\nconcurrency scan reads \`story/*\`` devient `the concurrency scan reads \`story/*\` and \`bounded/*\``.

`README.md` :
- `Concurrency detection has exactly two\n  sources — the open pull requests and the pushed \`story/*\` branches —` devient `Concurrency detection has exactly two\n  sources, the open pull requests and the pushed \`story/*\` and \`bounded/*\` branches,` ;
- la section `### Two stories at once`, du paragraphe `Detection is by **declaration**` jusqu'à `thing showing what it holds.`, devient :

```markdown
A conflict is also a story and a bounded change touching the same section.
Detection is by declaration. Each story document lists the spec it targets and
the sections it touches, and a bounded change lists them in its pull request
body. A starting story reads those declarations from the open pull requests
whose branch is `story/*` or `bounded/*`, and from every pushed `story/*` or
`bounded/*` branch that carries no pull request yet. A pushed branch that has
not declared yet is read by the sections it has already changed. The branch
name is the filter: those two patterns are the only branches that claim
sections, so a pull request that touches no spec at all is seen like any other.
```

- [ ] **Step 6: Run the suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`. Puis `grep -rnoE '\(`[A-Z][A-Za-z ]+`\)' skills/*/SKILL.md` ne gagne aucune ligne par rapport au début de la tâche.

- [ ] **Step 7: Commit**

```bash
git add skills tests README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la détection lit une branche muette par les sections qu'elle a modifiées" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 5: La mention d'un flag est le seul marqueur qu'une spec admet

**Files:**
- Modify: `skills/using-batches/SKILL.md` (`The Model > Spec`)
- Modify: `skills/adopting-a-module/SKILL.md` (étape 4)
- Test: `tests/test-skill-contracts.sh`

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-contracts.sh`, avant le bloc `no skill file names a changelog` :

```bash
# A spec carries no date, no status and no work-in-progress marker, except the
# gating sentence of a flag. Both skills that describe a spec say it alike.
shared "a flag's gating sentence is the one marker a spec admits" \
    "no work-in-progress marker, except a flag's gating sentence" \
    using-batches adopting-a-module

absent "no skill denies a spec every marker" \
    "A spec carries none, ever" \
    using-batches adopting-a-module
```

- [ ] **Step 2: Run the guards and see them fail**

Run: `bash tests/run-all.sh 2>&1 | grep FAIL`
Expected: FAIL sur ces gardes.

- [ ] **Step 3: State the exception**

`skills/using-batches/SKILL.md`, définition de `Spec` : `It carries no date, no status, no work-in-progress marker.` devient `It carries no date, no status, no work-in-progress marker, except a flag's gating sentence.`

`skills/adopting-a-module/SKILL.md`, étape 4 : `- **No date, no status, no in-progress marker.** A spec carries none, ever. On\n  \`main\`, spec and code always travel in the same pull request, so no state exists\n  that would need one.` devient `- No date, no status, no work-in-progress marker, except a flag's gating sentence.\n  On \`main\`, spec and code always travel in the same pull request, so no other\n  state exists that would need one.`

- [ ] **Step 4: Run the suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills tests
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la mention d'un flag est le seul marqueur qu'une spec admet" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: la table des revues de `using-batches` et du `README.md` ne nomme plus le changelog dans la ligne de clôture, alors que la table de `Authority and conflict rules` le nomme encore — `Batch > Closing a batch` énumère ce que porte la pull request de clôture et n'en parle plus, et une spec sans table `Changelog` ne laisse rien à y écrire — si c'est faux, une ligne de table est à rétablir dans deux fichiers.
- Ruling: `Module > Module adoption` renvoie encore à la clause « On ne reformule pas un mécanisme en règle » que la transcription retire de `The spec document` ; la spec reste en l'état (gel), et `using-batches` garde la clause — le bloc qui réécrit `Module > Module adoption` retire ce renvoi — si c'est faux, un renvoi pendant subsiste dans la spec jusqu'à la story qui transcrit ce bloc.
- Ruling: `closing-a-batch` sort de la garde qui exige de chaque skill écrivant dans une spec la même formulation du test de l'autre implémentation — la clôture n'écrit plus dans aucune spec depuis que le changelog a disparu — si c'est faux, la clôture perd un rappel du test.
- Ruling: la ligne de clôture des tables de revue reste « the consolidation and `status: closed` », sans nommer le retrait des blocs non livrés — elle omettait déjà la libération des réservations, et la table de spec correspondante appartient au bloc qui réécrit `Authority and conflict rules` — si c'est faux, la table sous-décrit ce que porte la clôture.
- Ruling: les imprécisions mineures relevées sur la détection de concurrence restent en l'état, sauf le `git diff -U0` — la revue finale les juge sans effet pratique, et `-U0` rend exacte la lecture des sections d'une branche qui n'a rien déclaré — si c'est faux, quelques lignes de `writing-a-user-story` et du `README.md` restent imprécises.
- Ruling: à la revue, `closing-a-batch` ne compte ni ne numérote plus ses devoirs : chacun est nommé par son titre, leur ordre est celui de leurs titres, et une garde exige les deux. Les tâches du plan décrivent encore la renumérotation qu'elles ont exécutée — un numéro obligeait à retoucher chaque renvoi dès qu'un devoir s'ajoutait ou disparaissait, et l'ordre tient déjà dans celui des titres — si c'est faux, les numéros reviennent et chaque devoir ajouté ou retiré les remet à jour.
- Ruling: à la revue, les phrases que cette story a écrites ou réécrites ne comptent plus ce qu'elles énumèrent : les sources de la détection de concurrence, les règles du changement borné dans le `README.md`, les listings de l'attribution de `us-N`, le cas où la spec reste muette. Les décomptes plus anciens, hors des sections de cette story, restent en l'état — un décompte ne dit rien que la liste ne dise, et devient faux le jour où un élément s'ajoute ou disparaît — si c'est faux, les décomptes reviennent.

## Observed drift
