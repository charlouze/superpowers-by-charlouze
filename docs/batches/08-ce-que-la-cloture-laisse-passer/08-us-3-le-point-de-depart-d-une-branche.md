# Le point de départ d'une branche — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remplacer, partout où le flux la pose, la précondition « être dans le
checkout principal, sur un `main` à jour » par la seule chose qu'elle protégeait —
le point de départ de la branche, `main` telle que le remote la porte.

**Architecture:** La règle ne parle plus d'un répertoire mais d'un point de départ.
Les cinq skills et la commande `init` qui posaient la précondition la réécrivent ;
la vérification du point de départ rejoint, dans chaque skill, le paragraphe qui
rétablit déjà le nom conventionnel de la branche, puisque la règle de spec lie les
deux. Conséquence directe : le répertoire de travail n'étant plus garanti être
`main`, l'allocation d'un numéro ne peut plus le lister — elle lit `origin/main`,
ce que la spec exigeait déjà.

**Tech Stack:** Markdown (skills, commande), bash (suite de tests structurelle,
`bash tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/08-ce-que-la-cloture-laisse-passer/README.md
**Sections:** Authority and conflict rules
**Blocks:** D1

## Global Constraints

Contraintes du lot, reprises telles quelles :

- **Ordre requis.** D5, D8 et D9 emploient le terme que D2 pose au glossaire : ils
  sont transcrits dans la même story que D2, ou après elle. D5 emploie en outre le
  classement que D8 fait écrire dans le `Rulings log` : il ne précède pas D8. D1 et
  D10 n'imposent aucun ordre.
- **Deux constats faits en concevant ce lot partent en `Observed drift`**, et la
  clôture les versera au gaps register. Tous deux sont antérieurs à ce lot, hors de
  son périmètre, et ne sont pas à résorber ici.

  **Les deux totalités de `Batch`** — « le spec delta est **le texte exact que ce
  lot écrit dans les specs**, en blocs » et « la revue d'ouverture […] **c'est là
  que l'humain lit ce que diront les specs** » — que les propres règles de la spec
  contredisent : l'étape 3 de `Delivering a story` fait écrire la mention d'un flag
  par la story sans qu'aucun bloc la porte, la story de démontage retire de la spec
  ce que le lot y avait ajouté avec `Blocks: none`, et la levée d'un flag à portée
  de lot n'exige pas davantage de bloc. Le code fait ce que ces règles disent ; ce
  sont les deux totalités qui ont tort.

  **L'énumération de `Blocks: none`** dans `Story > The user story document` cite la
  story de lot correctif et la story de démontage, et omet la story de levée d'un
  flag à portée de lot, qui n'en transcrit pas davantage.

- **Consigner avec eux que leur canal n'a pas de définition qui les couvre.**
  `The model` définit la dérive comme une divergence entre la spec de `main` et son
  code ; ces deux constats sont des contradictions entre règles d'une même spec.
  Ils partent tout de même en `Observed drift`, faute d'autre chemin et parce que le
  précédent existe sur `main` — la story `05-us-1-le-domicile-d-une-regle` y a versé
  un constat de même nature, classé en *gap* à la clôture. Que cette section serve à
  plus que ce que sa définition dit est un constat de plus, qu'aucun lot ne tient.

**Ces deux constats sont déjà portés par l'`Observed drift` de
`08-us-1-l-arbitrage-ouvert`, qui a fusionné.** La clôture ne lit que les sections
`Observed drift` des stories : les réinscrire ici donnerait deux exemplaires à
consolider. Cette story ne les reprend pas.

**Gel du fichier de spec :**

> Entre le commit de transcription et l'ouverture de la pull request, aucune tâche
> ne modifie le fichier de spec. Une story qui découvre que la spec doit changer
> s'arrête.

**Autorité :** quand le lot et la spec se contredisent, la spec gagne — sans
exception et sans délibération. Implémente ce que dit la spec, consigne un
`Ruling:`, et poursuis. Corriger une spec en cours de lot est un acte humain,
jamais un acte d'agent.

**Langue :** ossature anglaise — titres de section, noms de champs, libellés de
gabarit, en-têtes de tableau, motifs de chemin et de branche —, prose en français.
Les textes édités par ce plan sont ceux des skills, qui sont entièrement anglais :
ils restent anglais.

---

## File Structure

| Fichier | Ce qu'il porte ici |
|---|---|
| `skills/using-batches/SKILL.md` | La précondition énoncée une fois pour toute pull request du flux, et son red flag |
| `skills/writing-a-user-story/SKILL.md` | La précondition sur le chemin story, la vérification à la création de branche, son red flag, et l'allocation de `us-N` |
| `skills/writing-a-batch/SKILL.md` | La précondition sur le chemin lot, la vérification à la création de branche, et l'allocation de `NN` |
| `skills/adopting-a-module/SKILL.md` | La précondition sur le chemin adoption, la note d'ordre des étapes, et deux red flags |
| `skills/closing-a-batch/SKILL.md` | La précondition sur le chemin clôture, la vérification à la création de branche, et son red flag |
| `commands/init.md` | La même précondition, sur le chemin d'installation |
| `tests/test-skill-content.sh` | Les assertions qui gardent les deux propriétés |

Deux tâches, sur une couture réelle : la tâche 1 réécrit la règle partout où elle
est posée ; la tâche 2 répare le seul mécanisme que cette réécriture rend faux —
lister un répertoire de travail dont plus rien ne garantit qu'il porte `main`.

---

### Task 1: La précondition nomme le point de départ, pas le répertoire

**Files:**
- Modify: `tests/test-skill-content.sh:218-219`
- Modify: `skills/using-batches/SKILL.md:141`, `skills/using-batches/SKILL.md:279`
- Modify: `skills/writing-a-user-story/SKILL.md:43-63`, `skills/writing-a-user-story/SKILL.md:186-194`, `skills/writing-a-user-story/SKILL.md:654`
- Modify: `skills/writing-a-batch/SKILL.md:73-82`, `skills/writing-a-batch/SKILL.md:124-128`
- Modify: `skills/adopting-a-module/SKILL.md:75-91`, `skills/adopting-a-module/SKILL.md:431-432`
- Modify: `skills/closing-a-batch/SKILL.md:24-25`, `skills/closing-a-batch/SKILL.md:128`
- Modify: `skills/adopting-a-module/SKILL.md` — paragraphe de `### 3. Create the branch`
- Modify: `commands/init.md:13-14`
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la règle transcrite au premier commit de la branche, dans
  `docs/specs/supercharlouze.md`, section `Authority and conflict rules` : « Toute
  branche du flux part de `main` telle que le remote la porte ».
- Produces: la formule « starts from `main` as the remote carries it » et la phrase
  « Where you are standing does not matter », que les assertions de la tâche 1 et la
  tâche 2 tiennent pour acquises.

- [ ] **Step 1: Réécrire les deux assertions qui gardent l'ancienne précondition**

Dans `tests/test-skill-content.sh`, remplacer exactement ces deux lignes :

```bash
require writing-a-user-story "checks it is in the main checkout"  "main checkout"
require writing-a-user-story "refreshes main from the remote"     "up to date with the remote"
```

par :

```bash
require writing-a-user-story "branches from main as the remote carries it" "starts from \`main\` as the remote carries it"
require writing-a-user-story "the directory it runs in does not matter"    "Where you are standing does not matter"
```

- [ ] **Step 2: Lancer la suite pour vérifier que les deux assertions échouent**

Run: `bash tests/run-all.sh`
Expected: FAIL — `[FAIL] writing-a-user-story: branches from main as the remote
carries it` et `[FAIL] writing-a-user-story: the directory it runs in does not
matter`. Aucune autre assertion ne passe au rouge.

- [ ] **Step 3: Réécrire la précondition commune dans `using-batches`**

Dans `skills/using-batches/SKILL.md`, remplacer le paragraphe qui commence par
`**Preconditions for every pull request of this system**` par :

```markdown
**Preconditions for every pull request of this system**, checked before creating a branch: fetch, then start the branch from **`main` as the remote carries it**, never from another branch. That is what keeps a session chaining two pieces of work from stacking the second on the first one's branch, and what makes numbering and concurrency detection reason on the remote state. **Where you are standing does not matter**, and it must not: a session the harness launched inside a worktree cannot run git against the shared checkout at all, so a precondition on the directory would be unreachable exactly there. The starting point is reachable from anywhere — inside a reused workspace, `git fetch origin && git switch -c <branch> origin/main` satisfies it without leaving. `gh` is assumed available and authenticated; without it both degrade to a partial safety net and stop preventing anything.
```

- [ ] **Step 4: Réécrire le red flag de `using-batches`**

Remplacer la ligne :

```markdown
| "I'm already in the previous story's worktree, I'll start the next one here" | Preconditions first: main checkout, `main` refreshed. Otherwise the new story's code lands on the previous story's branch. |
```

par :

```markdown
| "I'm already in the previous story's worktree, I'll start the next one here" | Working there is fine; branching from there is not. Fetch, and start `story/NN-us-N-<slug>` from `main` as the remote carries it, or the new story's code lands on the previous story's branch. |
```

- [ ] **Step 5: Réécrire la précondition de `writing-a-user-story`**

Dans `skills/writing-a-user-story/SKILL.md`, remplacer les deux premières puces de
`## Preconditions` — celle qui commence par `- **You are in the main checkout.**` et
celle qui commence par ``- **`main` is checked out and up to date with the
remote.**`` — par :

```markdown
- **This story's branch starts from `main` as the remote carries it.** Fetch,
  then branch from `origin/main`, never from another branch. Two things ride on
  it. `superpowers:finishing-a-development-branch` *preserves* the worktree on
  the pull request path, so a session that chains two stories without leaving it
  lets `superpowers:using-git-worktrees` skip creation — its Step 0 sees
  `GIT_DIR != GIT_COMMON`, concludes "already in a linked worktree" and reuses
  the existing one — and this story's code would land on the previous story's
  branch. And merges arrive from the remote, so a starting point taken from a
  stale `main` leaves number allocation and concurrency detection reasoning on a
  state that is already behind.
- **Where you are standing does not matter**, and it must not: a session the
  harness launched inside a worktree cannot run git against the shared checkout,
  so a precondition on the directory would be unreachable exactly there. Inside a
  reused workspace, `git fetch origin && git switch -c story/NN-us-N-<slug>
  origin/main` satisfies the rule without leaving it.
```

Puis supprimer le paragraphe qui suivait la liste et ne gardait plus rien :

```markdown
That first check assumes a plain repository. In a submodule, `GIT_DIR` and
`GIT_COMMON` differ without a worktree being involved; a submodule project is
outside the path this plugin covers.
```

Il gardait le contrôle `GIT_DIR` / `GIT_COMMON` que la précondition faisait faire.
Ce contrôle n'est plus fait ici — `superpowers:using-git-worktrees` le fait dans son
Step 0, avec sa propre garde submodule.

- [ ] **Step 6: Étendre la vérification à la création de branche dans `writing-a-user-story`**

Dans `## Step 2 — Allocate us-N and Create the Branch`, remplacer les quatre
premières phrases du paragraphe qui commence par `Create the branch and the
workspace by invoking` — jusqu'à `**A named branch is not enough.**` exclu — par :

```markdown
Create the branch and the workspace by invoking
`superpowers:using-git-worktrees`. That skill prefers the harness's native
tooling, which picks its own branch name, may leave a detached HEAD, and may
branch from wherever you happened to be. If it produces another name, a detached
HEAD, a starting point other than `origin/main`, or if isolation is declined,
restore the conventional name and the starting point before going on:
`story/NN-us-N-<slug>`, from `origin/main`. `git merge-base --is-ancestor
origin/main HEAD` answers the second, and `git switch -c story/NN-us-N-<slug>
origin/main` inside the workspace puts it right.
```

La suite du paragraphe — depuis `**A named branch is not enough.**` — ne change pas.

- [ ] **Step 7: Réécrire le red flag de `writing-a-user-story`**

Remplacer la ligne :

```markdown
| "I'm already in a worktree, that's fine" | Then this story's code lands on the previous story's branch. Return to the main checkout. |
```

par :

```markdown
| "I'm already in a worktree, that's fine" | It is, as a place to work. A branch that starts there is not: this story's code would land on the previous story's branch. Branch from `origin/main`, wherever you stand. |
```

- [ ] **Step 8: Réécrire la précondition de `writing-a-batch`**

Dans `skills/writing-a-batch/SKILL.md`, remplacer les points numérotés 2 et 3 par un
seul point 2, et renuméroter l'actuel 4 en 3 :

```markdown
2. **The branch you are about to create starts from `main` as the remote carries
   it.** Fetch, then branch from `origin/main`, never from a branch left over
   from an earlier story. `superpowers:finishing-a-development-branch` preserves
   the worktree on the pull request path, so a session that chains two pieces of
   work without leaving it would otherwise stack this batch on the previous
   branch; and without the fetch, number allocation reasons on a state that is
   already behind. **Where you are standing does not matter**, and it must not: a
   session the harness launched inside a worktree cannot run git against the
   shared checkout, so a precondition on the directory would be unreachable
   exactly there.
3. **`gh` is available and authenticated.** Number allocation queries it. Without
   it you still have a partial safety net — the collision becomes visible when
   the pull request opens — but nothing prevents it.
```

- [ ] **Step 9: Étendre la vérification à la création de branche dans `writing-a-batch`**

Remplacer les quatre premières phrases du paragraphe qui commence par `Create the
branch and workspace by invoking` — jusqu'à `**A named branch is not enough.**`
exclu — par :

```markdown
Create the branch and workspace by invoking `superpowers:using-git-worktrees`.
That skill prefers the harness's native tooling, which picks its own branch name,
may leave you on a detached HEAD, and may branch from wherever you happened to
be. This plugin enforces its own naming and its own starting point: if you end up
elsewhere, restore the conventional name and the starting point before going on —
`batch/NN-<slug>`, from `origin/main`, with `git switch -c batch/NN-<slug>
origin/main` inside the workspace.
```

La suite du paragraphe — depuis `**A named branch is not enough.**` — ne change pas.

- [ ] **Step 10: Réécrire la précondition de `adopting-a-module`**

Dans `skills/adopting-a-module/SKILL.md`, remplacer les deux puces — celle qui
commence par `- **You are in the main checkout.**` et celle qui commence par
``- **You are on `main`, refreshed from the remote.**`` — par :

```markdown
- **The branch you are about to create starts from `main` as the remote carries
  it.** Fetch, then branch from `origin/main`, never from another branch. The
  reason matters, because this is exactly the rule an agent talks itself out of:
  `superpowers:finishing-a-development-branch` *preserves* the worktree on the
  pull request path, so `superpowers:using-git-worktrees` Step 0 sees
  `GIT_DIR != GIT_COMMON`, concludes "already in a linked worktree", reuses it,
  and the adoption lands on the previous piece of work's branch. And merges
  arrive from the remote: an adoption written from a stale starting point audits
  code that is no longer there. **Where you are standing does not matter**, and
  it must not: a session the harness launched inside a worktree cannot run git
  against the shared checkout, so a precondition on the directory would be
  unreachable exactly there. Inside a reused workspace,
  `git fetch origin && git switch -c adopt/<module> origin/main` satisfies the
  rule without leaving it.
```

- [ ] **Step 11: Corriger la note d'ordre des étapes de `adopting-a-module`**

Remplacer :

```markdown
*separate directory*: writing the spec first would leave it uncommitted in the
main checkout on `main`, and the new workspace would open empty.
```

par :

```markdown
*separate directory*: writing the spec first would leave it uncommitted where you
started, and the new workspace would open empty.
```

- [ ] **Step 12: Réécrire les deux red flags de `adopting-a-module`**

Remplacer :

```markdown
| "I'll write the two documents first and create the branch to carry them" | using-git-worktrees opens a separate, empty directory. The branch comes first, at step 3, or both files stay stranded on `main`. |
| "I'm already in a worktree, that will do" | Its Step 0 sees `GIT_DIR != GIT_COMMON`, reuses it, and the adoption lands on the previous branch. Main checkout first. |
```

par :

```markdown
| "I'll write the two documents first and create the branch to carry them" | using-git-worktrees opens a separate, empty directory. The branch comes first, at step 3, or both files stay stranded where you started. |
| "I'm already in a worktree, that will do" | The worktree is not the problem; the branch is. Step 0 reuses the workspace, and the adoption lands on the previous branch unless you create the branch from `origin/main` yourself. |
```

- [ ] **Step 13: Réécrire la précondition de `closing-a-batch`**

Dans `skills/closing-a-batch/SKILL.md`, remplacer la puce qui commence par
``- **You are in the main checkout, on `main`, refreshed from the remote.**`` par :

```markdown
- **The close branch starts from `main` as the remote carries it.** Fetch, then branch from `origin/main`, never from another branch. Otherwise two things go wrong at once: `superpowers:finishing-a-development-branch` *preserves* the worktree on the pull request path, so from inside one `superpowers:using-git-worktrees` Step 0 sees `GIT_DIR != GIT_COMMON`, concludes "already in a linked worktree" and reuses it, and this closure lands on the previous branch instead of its own; and a starting point behind the remote hides the very stories you are about to account for, so you would consolidate from an incomplete set. **Where you are standing does not matter**, and it must not: a session the harness launched inside a worktree cannot run git against the shared checkout, so a precondition on the directory would be unreachable exactly there — `git fetch origin && git switch -c batch/NN-<slug>-close origin/main` satisfies the rule from inside one.
```

- [ ] **Step 14: Étendre la vérification à la création de branche dans `closing-a-batch`**

Dans la puce suivante, remplacer :

```markdown
If it lands on a differently named branch or a detached HEAD, restore the conventional name before going on.
```

par :

```markdown
If it lands on a differently named branch, a detached HEAD, or a starting point other than `origin/main`, restore the conventional name and the starting point before going on.
```

- [ ] **Step 15: Réécrire le red flag de `closing-a-batch`**

Remplacer la ligne :

```markdown
| "I'm already in a worktree from this batch's last story, I'll close from here" | using-git-worktrees would reuse it and the closure would land on that story's branch. Back to the main checkout first. |
```

par :

```markdown
| "I'm already in a worktree from this batch's last story, I'll close from here" | Close from there if you like, but branch from `origin/main`: otherwise using-git-worktrees reuses the workspace and the closure lands on that story's branch. |
```

- [ ] **Step 16: Réécrire la première étape de `commands/init.md`**

Remplacer :

```markdown
1. From the main checkout, on an up-to-date `main`, create the branch
   `chore/supercharlouze-init`.
```

par :

```markdown
1. Fetch, then create the branch `chore/supercharlouze-init` from `main` as the
   remote carries it.
```

- [ ] **Step 17: Étendre la vérification à la création de branche dans `adopting-a-module`**

Dans `skills/adopting-a-module/SKILL.md`, section `### 3. Create the branch`,
remplacer :

```markdown
and may leave you on a detached HEAD. If it leaves you on a differently named
branch or on a detached HEAD, restore the conventional name before going on:
`adopt/<module>`.
```

par :

```markdown
and may leave you on a detached HEAD, and may branch from wherever you happened
to be. If it leaves you on a differently named branch, a detached HEAD, or a
starting point other than `origin/main`, restore the conventional name and the
starting point before going on: `adopt/<module>`, from `origin/main`.
```

- [ ] **Step 18: Étendre le contrat partagé par les quatre skills qui créent une branche**

`tests/test-skill-contracts.sh` exige des quatre skills qui créent une branche une
phrase de restauration **littéralement identique** — c'est ce qui empêche la
propriété de pourrir à un bout pendant qu'elle tient aux trois autres. La règle de
spec en fait désormais restaurer deux choses : le nom, et le point de départ. Le
contrat s'étend donc, il ne se relâche pas.

Remplacer :

```bash
shared "every branch-creating skill restores the conventional name" \
    "restore the conventional name before going on" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch
```

par :

```bash
shared "every branch-creating skill restores the name and the starting point" \
    "restore the conventional name and the starting point before going on" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch
```

Et, dans le commentaire qui précède ce bloc, remplacer la phrase :

```bash
# skill that creates a branch owes more than "some named branch exists": it
# restores the conventional name. The loose reading leaves a branch that is
# invisible to both scans, holding neither its number nor its sections.
```

par :

```bash
# skill that creates a branch owes more than "some named branch exists": it
# restores the conventional name, and the starting point the flow requires. The
# loose reading leaves a branch that is invisible to both scans, holding neither
# its number nor its sections — or one that is visible and built on the wrong
# base.
```

- [ ] **Step 19: Lancer la suite et vérifier qu'elle passe**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`. Les deux assertions réécrites au step 1 sont vertes,
et aucune autre n'est passée au rouge — en particulier
`test-cross-references.sh`, qui relit tout chemin cité en backticks.

- [ ] **Step 20: Vérifier qu'aucune trace de l'ancienne précondition ne subsiste**

Run: `grep -rn "main checkout\|up to date with the remote\|refreshed from the remote" skills/ commands/ tests/`
Expected: aucune sortie. Si la commande sort quelque chose, le passage a été oublié.

- [ ] **Step 21: Commit**

```bash
git add skills/ commands/init.md tests/test-skill-content.sh tests/test-skill-contracts.sh
git commit -m "feat: une branche du flux part de main telle que le remote la porte"
```

---

### Task 2: L'allocation d'un numéro lit `main` sur le remote

Le répertoire de travail n'est plus garanti porter `main` : `ls docs/batches/`
peut désormais lister un `main` en retard, ou le contenu d'une branche de story.
La spec, elle, dit depuis toujours « non utilisé dans `docs/batches/` **sur
`main`** ». La lecture rejoint donc ce que la règle demandait déjà.

**Files:**
- Modify: `tests/test-skill-content.sh`
- Modify: `skills/writing-a-batch/SKILL.md` — bloc `bash` de `## Allocating NN`
- Modify: `skills/writing-a-user-story/SKILL.md` — bloc `bash` de `## Step 2 — Allocate us-N and Create the Branch`
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: rien de la tâche 1 au-delà du fait que la précondition ne garantit plus
  le contenu du répertoire de travail.
- Produces: la commande `git ls-tree --name-only origin/main docs/batches/`, que les
  deux assertions ajoutées au step 1 gardent.

- [ ] **Step 1: Ajouter les deux assertions qui gardent la lecture**

Dans `tests/test-skill-content.sh`, ajouter — dans le bloc `writing-a-batch` pour la
première, dans le bloc `writing-a-user-story` pour la seconde :

```bash
require writing-a-batch "allocation reads main on the remote" "git ls-tree --name-only origin/main docs/batches/"
require writing-a-user-story "allocation reads main on the remote" "git ls-tree --name-only origin/main docs/batches/"
```

- [ ] **Step 2: Lancer la suite pour vérifier que les deux échouent**

Run: `bash tests/run-all.sh`
Expected: FAIL — `[FAIL] writing-a-batch: allocation reads main on the remote` et
`[FAIL] writing-a-user-story: allocation reads main on the remote`.

- [ ] **Step 3: Faire lire `origin/main` à l'allocation de `NN`**

Dans `skills/writing-a-batch/SKILL.md`, section `## Allocating NN`, remplacer le
bloc :

````markdown
```bash
ls docs/batches/
gh pr list --state open --json number,headRefName
git ls-remote --heads origin 'batch/*' 'story/*'
```
````

par :

````markdown
```bash
git fetch origin
git ls-tree --name-only origin/main docs/batches/
gh pr list --state open --json number,headRefName
git ls-remote --heads origin 'batch/*' 'story/*'
```
````

Puis, juste sous le bloc, insérer ce paragraphe :

```markdown
The first source is read on `origin/main` and not in the working tree, because
nothing guarantees the working tree carries `main`: the flow's only requirement is
where the branch *starts*, and this listing may be run from a workspace on another
branch entirely.
```

- [ ] **Step 4: Faire lire `origin/main` à l'allocation de `us-N`**

Dans `skills/writing-a-user-story/SKILL.md`, section `## Step 2 — Allocate us-N and
Create the Branch`, remplacer le bloc :

````markdown
```bash
ls docs/batches/NN-<slug>/
gh pr list --state open --limit 100 --json number,headRefName
git ls-remote --heads origin 'story/*'
```
````

par :

````markdown
```bash
git fetch origin
git ls-tree --name-only origin/main docs/batches/NN-<slug>/
gh pr list --state open --limit 100 --json number,headRefName
git ls-remote --heads origin 'story/*'
```
````

Puis, dans le paragraphe qui suit et qui commence par `All three are necessary.`,
remplacer la phrase :

```markdown
An artifact only reaches `main` when its pull request merges, so the directory
listing knows nothing about what is in flight;
```

par :

```markdown
An artifact only reaches `main` when its pull request merges, so that listing
knows nothing about what is in flight; it is read on `origin/main` and not in the
working tree, because nothing guarantees the working tree carries `main` — the
flow's only requirement is where the branch *starts*;
```

Et, plus bas dans le même paragraphe, remplacer :

```markdown
Going by the directory alone gives the same number to two stories written
while a third is in review;
```

par :

```markdown
Going by that listing alone gives the same number to two stories written
while a third is in review;
```

- [ ] **Step 5: Lancer la suite et vérifier qu'elle passe**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Vérifier qu'aucune allocation ne lit plus le répertoire de travail**

Run: `grep -rn "^ls docs/batches" skills/`
Expected: aucune sortie.

- [ ] **Step 7: Commit**

```bash
git add skills/writing-a-batch/SKILL.md skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh
git commit -m "fix: l'allocation d'un numéro lit docs/batches/ sur main"
```

---

## Rulings log

## Observed drift
