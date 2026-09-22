# 09-us-5 — La détection par nom de branche

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/09-quand-aucune-regle-ne-bouge/README.md
**Sections:** Story > Concurrency detection
**Blocks:** D10

**Goal:** Mettre les skills en conformité avec la spec que le premier commit de
cette branche a livrée : la détection de concurrence filtre par nom de branche,
sa déclaration nomme la spec en plus des sections, et une branche qui n'en porte
pas encore concerne la spec qu'elle a déjà modifiée.

**Architecture:** Le code de ce dépôt, ce sont les cinq skills de `skills/`, le
`README.md` qui les présente, et la suite d'assertions de `tests/` qui les tient.
La modification de spec est déjà commitée. Trois tâches : la première remplace le
filtre par fichier de spec par le filtre par nom de branche, chez le lecteur
(`writing-a-user-story`, étape 1) comme chez celui qui énonce la règle
(`using-batches`) ; la deuxième étend ce que porte et ce que vaut une
déclaration ; la troisième met la présentation du dépôt en accord avec les deux.

**Tech Stack:** Markdown ; Bash pour les assertions (`tests/run-all.sh`).

## Global Constraints

Ces contraintes font implicitement partie des exigences de chaque tâche.

### Contraintes du lot

Recopiées mot pour mot de la section `Constraints` du document de lot.

**Ordre des blocs.** `D1` pose le seul terme neuf et précède donc `D4`, `D5`, `D7`,
`D12` et `D13`. `D12` précède `D7` et `D13`, qui renvoient tous deux à la condition
d'arrêt qu'il écrit. Tous les autres sont indépendants.

**Six sections portent plusieurs blocs, dont l'ordre entre eux est libre** : leurs
ancres sont disjointes. `The model` (`D1`, `D2`), `Authority and conflict rules`
(`D9`, `D17`, `D18`), `Batch > Amending a batch` (`D11`, `D13`), `Story > The user
story document` (`D5`, `D6`, `D7`), `Bounded change` (`D15`, `D16`), `Batch >
Opening a batch` (`D21`, `D22`).

**Une seule pull request est en vol** : la clôture du lot 08. Elle écrit une ligne
de changelog au pied de la spec et consolide dans le gaps register — aucun passage
que ce lot cite, mais l'annotation `reserved by batch-09` vit dans ce même fichier
de registre, où un conflit de fusion git est possible. Il se résout sur la branche
de la story.

### Gel du fichier de spec

> Entre le commit de transcription et l'ouverture de la pull request, aucune
> tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit
> changer s'arrête.

Le gel couvre `docs/specs/supercharlouze.md` **et** `docs/specs/supercharlouze.gaps.md`,
que le premier commit de cette branche a modifiés tous les deux.

### Règle d'autorité

La spec est l'autorité opposable. Quand le lot et la spec se contredisent, **la
spec gagne, sans exception et sans délibération** : implémente ce que la spec dit,
consigne un `Ruling:`, et continue. **Corriger une spec en cours de lot est un acte
humain, jamais un acte d'agent.**

### Vocabulaire non disponible

Le terme **story technique** est posé par le bloc `D1`, que la story 09-us-2 livre
sur une autre branche et qui n'est pas sur `main`. **Aucun texte écrit ici ne le
nomme.** Le cas qu'il désigne se dit en clair : « une story dont la pull request ne
touche aucune spec ». Le nommer ferait dépendre cette story d'une autre, et rendrait
faux le texte livré si l'autre n'était pas fusionnée.

---

### Task 1: Le filtre de lecture est le nom de la branche

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` — `Step 1 — Detect Concurrency`, points 1 et 3
- Modify: `skills/using-batches/SKILL.md` — paragraphe `**Concurrency.**` de `Authority and Conflict Rules`, et la ligne de `Red Flags` sur le conflit git
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Produces: la phrase partagée `filter is the branch name`, que la tâche 2 ne
  retouche pas et sur laquelle l'assertion `shared` de cette tâche repose.

- [ ] **Step 1: Écrire les assertions qui échouent**

Dans `tests/test-skill-contracts.sh`, à la suite du bloc de `shared` sur les
branches (celui qui finit par `shared "and each says a named branch is not enough"`),
ajouter :

```bash
# The concurrency scan's filter is the branch name, and both ends must spell it
# the same: the one that scans (`writing-a-user-story`) and the one that states
# the rule (`using-batches`). One assertion over both files — two separate ones
# would each stay green while one end reworded away from the other.
shared "the concurrency filter is the branch name on both ends" \
    "filter is the branch name" \
    using-batches writing-a-user-story

# The former filter — keep only the pull requests and the branches whose diff
# touches the spec file — made invisible every story whose pull request touches
# no spec at all. It must survive nowhere, or the scan regains the blind spot
# this one closes.
absent "no skill filters the concurrency scan by the spec file a diff touches" \
    "touches this story's spec file|touches this spec file|touch this spec file|files include this story's spec file" \
    using-batches writing-a-user-story
```

- [ ] **Step 2: Lancer les assertions pour les voir échouer**

Run: `bash tests/test-skill-contracts.sh`
Expected: FAIL — `[FAIL] the concurrency filter is the branch name on both ends`
et `[FAIL] no skill filters the concurrency scan by the spec file a diff touches`.

- [ ] **Step 3: Réécrire le point 1 de l'étape 1 de `writing-a-user-story`**

Remplacer :

```markdown
1. **List the open pull requests together with the files they touch**, and keep
   those whose files include this story's spec file. Bare `gh pr list` does not
   print the files of a pull request, so it can never answer this question —
   ask for them explicitly, together with the head ref point 2 reads:

   ```bash
   gh pr list --state open --limit 100 --json number,headRefName,files
   gh pr view <n> --json number,headRefName,files   # one pull request at a time
   ```
```

par :

```markdown
1. **List the open pull requests together with their head ref**, and keep those
   whose branch is `story/*` or `fix/*`. Bare `gh pr list` does not print the
   head ref, so ask for it explicitly:

   ```bash
   gh pr list --state open --limit 100 --json number,headRefName
   gh pr view <n> --json number,headRefName   # one pull request at a time
   ```

   **The filter is the branch name, not the files the pull request touches.**
   Those two patterns are the only branches that claim sections, so the head ref
   answers on its own — nothing to fetch and no file to read. And a pull request
   that touches no spec at all still holds its sections: a corrective story's
   first commit deletes a gaps register entry, so a filter on the spec file made
   it invisible to every sibling for its whole life.
```

- [ ] **Step 4: Réécrire le point 3 de l'étape 1 de `writing-a-user-story`**

Dans le même fichier, remplacer le bloc de commandes du point 3 :

```markdown
   ```bash
   git ls-remote --heads origin 'story/*'
   git fetch origin
   git diff --name-only origin/main...origin/<branch>   # does it touch this spec file?
   git show origin/<branch>:docs/batches/NN-<slug>/NN-us-N-<slug>.md
   ```

   Keep the branches whose diff against `main` touches this story's spec file —
   the same filter point 1 applies to pull requests. Skip the branches already
   covered by a pull request there, and skip your own. A kept branch whose
   story document does not exist yet is a story between its spec commit and its
   plan commit: it holds the spec file and has not yet declared its sections,
   which is an unknown and stops you exactly as point 6 does. That window is one
   plan-writing step long.
```

par :

```markdown
   ```bash
   git ls-remote --heads origin 'story/*'
   git fetch origin
   git show origin/<branch>:docs/batches/NN-<slug>/NN-us-N-<slug>.md
   git diff --name-only origin/main...origin/<branch>   # no document yet: which spec has it already changed?
   ```

   `story/*` is the whole filter here — the same one point 1 applies to pull
   requests. Skip the branches already covered by a pull request there, and skip
   your own.
```

La phrase sur la branche sans document est remplacée par la tâche 2, qui écrit ce
qu'elle devient. Laisser le point 3 s'arrêter là : la tâche 2 reprend exactement à
cet endroit.

- [ ] **Step 5: Réécrire le paragraphe `**Concurrency.**` de `using-batches`**

Remplacer :

```markdown
**Concurrency.** Two stories touching the same section of the same spec are a conflict. Detection is by declaration: each story document lists the sections it touches, and a starting story compares them against the open pull requests **and against every remote `story/*` branch that carries no pull request yet whose diff against `main` touches this story's spec file**. That filter is part of the rule, not an optimisation: without it the scan orders a read of every story branch in the repository, and stops on the first one whose declaration cannot be read — an arrest no conflict justifies. Both sources are needed:
```

par :

```markdown
**Concurrency.** Two stories touching the same section of the same spec are a conflict. Detection is by declaration: each story document lists the sections it touches, and a starting story compares them against the open pull requests **whose branch is `story/*` or `fix/*`**, and against every remote `story/*` branch that carries no pull request yet. **The filter is the branch name**, because those two patterns are the only branches that claim sections. Filtering instead on the spec file a pull request touches looked like the same thing and was not: a story whose pull request touches no spec at all — a corrective story deletes a gaps register entry and nothing else — held its sections while being invisible to every sibling. Both sources are needed:
```

Le reste du paragraphe — depuis `a story's pull request opens only at the very
end` jusqu'à `exactly the case worth catching.` — est inchangé.

- [ ] **Step 6: Réécrire la ligne de `Red Flags` de `using-batches`**

Remplacer :

```markdown
| "Git will conflict if two stories touch the same section" | Git conflicts on lines, not sections; two edits far apart in one section merge cleanly. Compare the declared `Sections:` fields against the open pull requests and against every remote `story/*` branch that carries no pull request yet and whose diff against `main` touches this spec file — the filter keeps the scan from reading, and stopping on, branches that hold nothing you want. |
```

par :

```markdown
| "Git will conflict if two stories touch the same section" | Git conflicts on lines, not sections; two edits far apart in one section merge cleanly. Compare the declared `Sections:` fields against the open pull requests whose branch is `story/*` or `fix/*`, and against every remote `story/*` branch that carries no pull request yet — the filter is the branch name, and a pull request that touches no spec holds its sections all the same. |
```

- [ ] **Step 7: Lancer la suite entière**

Run: `bash tests/run-all.sh`
Expected: PASS — les deux assertions de l'étape 1 passent, et rien d'autre ne
rougit.

- [ ] **Step 8: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md skills/using-batches/SKILL.md tests/test-skill-contracts.sh
git commit -m "feat: la détection de concurrence filtre par nom de branche"
```

---

### Task 2: Ce que porte une déclaration, et ce qu'elle vaut

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` — `Step 1 — Detect Concurrency`, points 2, 3 et 6
- Modify: `skills/using-batches/SKILL.md` — paragraphe `**Concurrency.**`, phrase finale sur la déclaration
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: le point 3 tel que la tâche 1 le laisse — sa dernière phrase est
  `Skip the branches already covered by a pull request there, and skip your own.`
- Produces: la phrase partagée `concerns the spec it has already changed`.

- [ ] **Step 1: Écrire les assertions qui échouent**

Dans `tests/test-skill-contracts.sh`, à la suite des deux assertions ajoutées par
la tâche 1 :

```bash
# The branch name says who claims sections; the declaration says in which spec.
# A pushed branch that carries no declaration yet has only its diff to say so,
# and both ends must state it the same way: the one that scans and the one that
# states the rule.
shared "a branch with no declaration yet is scoped by what it changed" \
    "concerns the spec it has already changed" \
    using-batches writing-a-user-story
```

Dans `tests/test-skill-content.sh`, dans le bloc `writing-a-user-story`, à la
suite de `require writing-a-user-story "concurrency via declared Sections"` :

```bash
require writing-a-user-story "a declaration names its spec as well"  "\`Spec:\` names the spec"
require writing-a-user-story "a bounded change names both in its body" "names both in the body of its pull request"
```

- [ ] **Step 2: Lancer les assertions pour les voir échouer**

Run: `bash tests/test-skill-contracts.sh && bash tests/test-skill-content.sh`
Expected: FAIL — `[FAIL] a branch with no declaration yet is scoped by what it
changed`, `[FAIL] a declaration names its spec as well`, `[FAIL] a bounded change
names both in its body`.

- [ ] **Step 3: Réécrire le point 2 de l'étape 1 de `writing-a-user-story`**

Remplacer :

```markdown
2. **For each of those, read its `Sections:` declaration — wherever that pull
   request keeps it.** A story keeps it in its story document, which lives on
   the *other* pull request's head branch and not in your worktree, so read it
   at the head ref. A **bounded change** (`fix/<slug>`) has no story document at
   all: it declares its sections in the body of its pull request, so read the
   body. Look in the place that kind of pull request actually uses — demanding a
```

par :

```markdown
2. **For each of those, read its declaration — wherever that pull request keeps
   it.** A story keeps it in its story document, which lives on the *other* pull
   request's head branch and not in your worktree, so read it at the head ref:
   `Spec:` names the spec, `Sections:` the sections. A **bounded change**
   (`fix/<slug>`) has no story document at all: it names both in the body of its
   pull request, so read the body. Look in the place that kind of pull request
   actually uses — demanding a
```

Puis, à la fin du même point, après le bloc de commandes `gh api … | base64 -d`,
ajouter le paragraphe :

```markdown
   **A declaration naming a spec other than yours holds nothing against you.**
   The branch name says who claims sections; the declaration says in which spec.
   That is why the filter of point 1 can be as wide as it is — it lets in every
   claimant, and the declaration sorts them.
```

- [ ] **Step 4: Compléter le point 3 de l'étape 1 de `writing-a-user-story`**

Après la phrase que la tâche 1 a laissée en dernier — `Skip the branches already
covered by a pull request there, and skip your own.` — ajouter :

```markdown
   **A branch whose story document does not exist yet concerns the spec it has
   already changed.** It is a story between its spec commit and its plan commit:
   it holds sections it has not declared. If that spec is yours, it is an unknown
   and stops you exactly as point 6 does; if it is another module's, it holds
   nothing against you. That window is one plan-writing step long, and only a
   story that transcribes a block ever has it — a story whose first commit
   carries its story document declares from its first commit.
```

- [ ] **Step 5: Réécrire le point 6 de l'étape 1 de `writing-a-user-story`**

Remplacer :

```markdown
   "found nothing". The same applies to a story branch kept at point 3. What is
```

par :

```markdown
   "found nothing". The same applies to a story branch kept at point 3 that
   carries no declaration yet **and has already changed your spec file** — one
   that has changed another module's is scoped away by point 3, not an unknown.
   What is
```

- [ ] **Step 6: Compléter le paragraphe `**Concurrency.**` de `using-batches`**

À la fin du paragraphe, après `Relying on it would let through exactly the case
worth catching.`, ajouter :

```markdown
 The declaration is read where each kind of pull request keeps it — a story document for a story, where `Spec:` names the spec and `Sections:` the sections; the pull request body for a bounded change, which has no story document and names both there. A pushed branch that carries no declaration yet **concerns the spec it has already changed**, which is what keeps a wide filter from ordering a stop on every branch in the repository.
```

- [ ] **Step 7: Lancer la suite entière**

Run: `bash tests/run-all.sh`
Expected: PASS — les trois assertions de l'étape 1 passent, et celles de la
tâche 1 restent vertes.

- [ ] **Step 8: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md skills/using-batches/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
git commit -m "feat: une déclaration de concurrence nomme sa spec"
```

---

### Task 3: La présentation du dépôt suit

**Files:**
- Modify: `README.md` — section `Two stories at once`
- Test: `tests/run-all.sh` (aucune assertion ne porte sur le contenu du `README.md` :
  il présente, il ne norme pas — `tests/test-cross-references.sh` n'y vérifie que
  les références `supercharlouze:<name>`)

**Interfaces:**
- Consumes: la règle telle que les tâches 1 et 2 l'ont écrite dans
  `skills/using-batches/SKILL.md`.

- [ ] **Step 1: Réécrire le deuxième paragraphe de `Two stories at once`**

Remplacer :

```markdown
Detection is by **declaration**, never by diff. Each story document lists the
sections it touches, and a starting story reads those declarations from the open
pull requests *and* from every pushed `story/*` branch that carries no pull
request yet. Both sources are needed: a story's pull request opens only at the
very end, so for the whole length of an implementation its pushed branch is the
only thing showing what it holds.
```

par :

```markdown
Detection is by **declaration**, never by diff. Each story document lists the
spec it targets and the sections it touches, and a starting story reads those
declarations from the open pull requests whose branch is `story/*` or `fix/*`
*and* from every pushed `story/*` branch that carries no pull request yet.
**The branch name is the filter**: those two patterns are the only branches that
claim sections, so a pull request that touches no spec at all is seen like any
other. Both sources are needed: a story's pull request opens only at the very
end, so for the whole length of an implementation its pushed branch is the only
thing showing what it holds.
```

- [ ] **Step 2: Vérifier que la suite reste verte**

Run: `bash tests/run-all.sh`
Expected: PASS — rien ne rougit.

- [ ] **Step 3: Relire les trois textes ensemble**

Run: `git diff origin/main -- README.md skills/using-batches/SKILL.md skills/writing-a-user-story/SKILL.md`
Expected: les trois disent la même chose du filtre — le nom de la branche — et de
ce que porte une déclaration, sans qu'aucun n'introduise de terme que `main`
ignore.

- [ ] **Step 4: Commit**

```bash
git add README.md
git commit -m "docs: le README présente le filtre par nom de branche"
```

## Rulings log

## Observed drift
