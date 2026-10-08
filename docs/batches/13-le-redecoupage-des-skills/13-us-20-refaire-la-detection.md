# Refaire la détection Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Une story ou un changement borné qui, avant l'ouverture de sa pull request, va toucher une section de plus refait la détection de concurrence pour elle, et s'arrête sur un conflit ou une déclaration illisible.

**Architecture:** `delivering-a-story` écrit la seconde invocation de `detecting-concurrency` dans son étape 1, en passant la branche de la story, et y renvoie aux trois étapes où une section de plus apparaît. `making-a-bounded-change` déclenche la sienne sur la section que le changement va toucher. Chaque norme a sa garde dans `tests/`, écrite avant le texte.

**Tech Stack:** Markdown pour les skills, Bash pour les gardes de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** Story > Concurrency detection
**Blocks:** D5

## Global Constraints

Avant de commencer, lis `skills/following-the-rules/SKILL.md` dans ce worktree : il porte les règles d'exécution. Ne l'invoque pas comme skill, la version installée du plugin ne l'a pas.

### Les contraintes du lot

Les skills portent les noms que `Technical design` leur donne.

`using-batches` garde son nom, que le bloc d'instructions des projets installés
cite.

La story qui renomme une skill redonne, avec le nouveau nom, le prompt en attente
qui nomme l'ancien.

Une skill interne porte `user-invocable: false` et une description de la forme
« Use only when a skill tells you to invoke <nom>, never on … ».

Une skill interne nomme les skills qu'elle invoque, jamais celles qui
l'invoquent.

Un texte de plus d'une ou deux phrases que plusieurs skills partagent vit dans une
skill interne, jamais dans une ref.

Une story fusionnée laisse chaque référence `supercharlouze:<nom>` résolue et la
suite de tests verte.

Jusqu'à la story qui transcrit D6, D7 et D8, `Global Constraints` recopie ses
textes, et les contrats `shared` qui les tiennent identiques suivent ces textes
dans les skills qui les portent.

Chaque skill extraite l'est par une story à elle.

Les stories se livrent une à la fois, dans cet ordre, libre entre les skills d'un
même rang que « puis » ne sépare pas :

1. l'outillage des tests ;
2. `following-the-rules` ;
3. `writing-in-a-spec`, `writing-in-a-gaps-register`, `detecting-concurrency`,
   `abandoning-a-story`, `applying-a-spec-delta` et `running-reread-rounds` ;
4. `starting-a-branch`, puis `finishing-a-pr` ;
5. `writing-a-batch-document`, puis `rereading-a-batch` ;
6. `amending-a-batch`, dont la story renomme `writing-a-batch` en
   `opening-a-batch` ;
7. `handling-a-stopped-story`, `making-a-bounded-change`, puis le renommage de
   `writing-a-user-story` en `delivering-a-story`.

La story qui résorbe la violation sur `The gaps register` suit l'extraction de
`amending-a-batch`.

La story qui extrait `following-the-rules` résorbe le gap sur `Code under a
feature flag` et `The user story document`.

D1 et D4 sont transcrits par une même story, qui suit l'extraction de
`handling-a-stopped-story`.

D2 et D3 sont transcrits par une même story, qui suit l'extraction de
`making-a-bounded-change`.

D6, D7 et D8 sont transcrits par une même story, qui suit le renommage en
`delivering-a-story`.

La story qui transcrit D5 suit ce renommage.

### Le gel du fichier de spec

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

### L'autorité

Quand le lot et la spec se contredisent, la spec gagne : implémente ce qu'elle dit, consigne un `Ruling:`, et poursuis. Seul l'humain corrige une spec en cours de lot.

### La concision

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

### Une contrainte ou un ADR intenable

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

### Les ADR tenus

> The code this story writes holds these ADRs.

- `docs/adr/une-skill-par-moment-d-invocation.md`

### Une décision qui mérite un ADR

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

### Ce poste

- Toute commande `git` qui écrit un commit ou parle au remote passe par `bash ~/.config/github-app/as-agent.sh git …`, y compris `rebase`, `commit --amend` et `cherry-pick`.
- Un commit se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et par aucune autre ligne d'attribution.
- Ni `python` ni `node`. L'outil Bash mange les barres obliques inverses dans les heredocs et les `sed` en ligne : écris les fichiers avec l'outil d'édition de fichiers.
- Les `SKILL.md` gardent des fins de ligne LF.
- La suite entière se lance par `bash tests/run-all.sh`, prend environ trois minutes, et demande un délai de cinq minutes. Un seul fichier se lance par `bash tests/test-skill-contracts.sh`.
- Une skill est entièrement anglaise et ne cite aucune section de `docs/specs/supercharlouze.md`.
- Montre l'étape rouge de chaque garde dans ton rapport.
- Une correction d'un commit de cette story est un `fixup!` de ce commit.

## Review Focus

- Une section de plus qui apparaît à la transcription, avant que le document de story existe : l'étape 3 renvoie à la détection, et la section entre dans `Sections:` à l'étape 4.
- Une section de plus que seul le rapport d'une tâche révèle : l'étape 5 dit à qui conduit l'exécution de la chercher dans les rapports et les relectures.
- Une seconde détection qui lit la branche du travail comme un conflit : chaque skill passe sa branche.
- Une seconde détection sans arrêt écrit : chaque skill porte « Stop again if it returns a conflict or a declaration it could not read ».
- Une section ajoutée après l'ouverture de la pull request : la règle s'arrête à l'ouverture, et les deux skills le disent.

---

### Task 1: Une story refait la détection avant de toucher une section de plus

**Files:**
- Modify: `skills/delivering-a-story/SKILL.md` (étapes 1, 3, 4 et 5, table `Red Flags`)
- Test: `tests/test-skill-contracts.sh` (après la boucle « stops on what detecting-concurrency returns », vers la ligne 81)

**Interfaces:**
- Consumes: `require` de `tests/lib.sh` ; `detecting-concurrency` reçoit déjà la spec, les sections et, quand elle existe, la branche du travail, qu'elle écarte de sa lecture.
- Produces: la phrase d'arrêt `Stop again if it returns a conflict or a declaration it could not read` et la ligne de `Red Flags`, que la tâche 2 reprend mot pour mot dans `making-a-bounded-change`.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-contracts.sh`, juste après le `done` de la boucle « stops on what detecting-concurrency returns », insère :

```bash
# A story about to touch a section the detection was not run for detects again,
# and passes its branch, which the scan leaves out. The rule is written in
# `Step 1`; the steps where one more section turns up point at it.
require delivering-a-story "a story detects again before it touches one more section" \
    "**Detect again before the story touches a section the detection was not run for**, as long as its pull request is not open: invoke \`supercharlouze:detecting-concurrency\` again, and give it the story's spec, that section and the story's branch."
require delivering-a-story "stops on what a redone detection returns" \
    "Stop again if it returns a conflict or a declaration it could not read"
require delivering-a-story "a section detected again joins the declaration before it is touched" \
    "add the section to it, then commit and push before touching it"
require delivering-a-story "the transcription waits for the detection of one more section" \
    "**A block or a removal that reaches a section the detection was not run for is not written yet:** detect again first (Step 1)."
require delivering-a-story "the plan's sections go through the detection before the story document is committed" \
    "One the detection was not run for goes through it before the story document is committed (Step 1)."
require delivering-a-story "a section a task reveals is detected before anything else is dispatched" \
    "shows the story reaching a section \`Sections:\` does not name, detect again before dispatching anything else"
require delivering-a-story "red flag: the first detection does not cover one more section" \
    "| \"It's one more section of the same spec, the detection already ran\" | It ran for the sections it was given, and never looked at this one. Detect again before touching it, and stop if it is held or a declaration cannot be read. |"
```

- [ ] **Step 2: Voir les gardes rouges**

Run: `bash tests/test-skill-contracts.sh 2>&1 | grep -F "[FAIL]"`
Expected: sept lignes `[FAIL] delivering-a-story: …`, une par garde ci-dessus, et aucune autre.

- [ ] **Step 3: Écrire la règle dans l'étape 1**

Dans `skills/delivering-a-story/SKILL.md`, section `## Step 1 — Detect Concurrency`, après le paragraphe « **Stop if it returns a conflict or a declaration it could not read.** … decide on the unread declaration. », ajoute ces deux paragraphes :

```markdown
**Detect again before the story touches a section the detection was not run
for**, as long as its pull request is not open: invoke
`supercharlouze:detecting-concurrency` again, and give it the story's spec, that
section and the story's branch. **Stop again if it returns a conflict or a
declaration it could not read.** The first detection answered for the sections
it was given, so a section added afterwards was never looked at.

When the story document already carries `Sections:`, add the section to it, then
commit and push before touching it: that field is what a sibling's scan reads.
```

- [ ] **Step 4: Renvoyer à la règle depuis l'étape 3**

Section `## Step 3 — Commit the Spec Change First`, après le premier paragraphe (il finit par « (see Lifting and Teardown Stories below). ») et avant « Three properties are load-bearing. », ajoute :

```markdown
**A block or a removal that reaches a section the detection was not run for is
not written yet:** detect again first (Step 1).
```

- [ ] **Step 5: Renvoyer à la règle depuis l'étape 4**

Section `## Step 4 — Write the Plan`, le paragraphe qui commence par « `Spec:` is the field » finit par « `Sections:` is what the *next* story's concurrency scan reads. ». Ajoute après lui ce paragraphe :

```markdown
`Sections:` names every section the tasks of the plan will touch. One the
detection was not run for goes through it before the story document is
committed (Step 1).
```

- [ ] **Step 6: Renvoyer à la règle depuis l'étape 5**

Section `## Step 5 — Execute`, juste avant le paragraphe « No task writes in `docs/adr/`. … », ajoute :

```markdown
**When a task report or a review shows the story reaching a section `Sections:`
does not name, detect again before dispatching anything else** (Step 1).
Implementers do not know which sections the detection was run for, so only you
can catch it.
```

- [ ] **Step 7: Ajouter le red flag**

Table `## Red Flags`, après la ligne qui commence par `| "I'll push the branch when the work is done" |`, ajoute :

```markdown
| "It's one more section of the same spec, the detection already ran" | It ran for the sections it was given, and never looked at this one. Detect again before touching it, and stop if it is held or a declaration cannot be read. |
```

- [ ] **Step 8: Voir les gardes vertes**

Run: `bash tests/test-skill-contracts.sh 2>&1 | grep -cF "[FAIL]"`
Expected: `0`

Run: `bash tests/run-all.sh 2>&1 | tail -5` (délai de cinq minutes)
Expected: aucune ligne `[FAIL]`, la suite se termine sans erreur.

- [ ] **Step 9: Commit**

```bash
git add skills/delivering-a-story/SKILL.md tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: une story refait la détection avant de toucher une section de plus" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: Un changement borné refait la détection pour la section qu'il va toucher

**Files:**
- Modify: `skills/making-a-bounded-change/SKILL.md` (paragraphe en retrait sous la règle (b), table `Red Flags`)
- Modify: `README.md` (section `### Two stories at once`)
- Test: `tests/test-skill-contracts.sh` (garde « a redone detection receives the branch », vers la ligne 76, et ce qui la suit)
- Test: `tests/test-skill-content.sh` (garde « a changed declaration redoes the detection », vers la ligne 1418)

**Interfaces:**
- Consumes: la phrase d'arrêt et la ligne de `Red Flags` que la tâche 1 a écrites dans `delivering-a-story`, reprises mot pour mot ; `require`, `shared` et `absent_everywhere` de `tests/lib.sh`.
- Produces: rien qu'une tâche suivante utilise.

- [ ] **Step 1: Réécrire et ajouter les gardes**

Dans `tests/test-skill-contracts.sh`, remplace

```bash
require making-a-bounded-change "a redone detection receives the branch" \
    "invoke it again, and give it \`bounded/<slug>\` as well"
```

par

```bash
require making-a-bounded-change "a redone detection receives the section and the branch" \
    "invoke it again, and give it that section and \`bounded/<slug>\` as well"
```

Dans le même fichier, remplace les deux gardes de la tâche 1

```bash
require delivering-a-story "stops on what a redone detection returns" \
    "Stop again if it returns a conflict or a declaration it could not read"
```

et

```bash
require delivering-a-story "red flag: the first detection does not cover one more section" \
    "| \"It's one more section of the same spec, the detection already ran\" | It ran for the sections it was given, and never looked at this one. Detect again before touching it, and stop if it is held or a declaration cannot be read. |"
```

par ce bloc, placé à la fin des gardes de la tâche 1 :

```bash
# Both pieces of work stop a redone detection in the same words, and answer the
# same excuse.
for s in delivering-a-story making-a-bounded-change; do
    require "$s" "stops on what a redone detection returns" \
        "Stop again if it returns a conflict or a declaration it could not read"
done
shared "red flag: the first detection does not cover one more section" \
    "| \"It's one more section of the same spec, the detection already ran\" | It ran for the sections it was given, and never looked at this one. Detect again before touching it, and stop if it is held or a declaration cannot be read. |" \
    delivering-a-story making-a-bounded-change
# The detection is redone for a section the work is about to touch, not for a
# declaration that changed: a bounded change has no declaration before its pull
# request opens.
absent_everywhere "no skill redoes the detection on a changed declaration" \
    "declaration that changes before the pull request opens|still cheap to undo"
```

Dans `tests/test-skill-content.sh`, remplace

```bash
require making-a-bounded-change "a changed declaration redoes the detection" \
        "redoes the detection"
```

par

```bash
require making-a-bounded-change "one more section redoes the detection" \
        "**Before its pull request opens, a bounded change about to touch a section the detection was not run for redoes the detection:**"
```

- [ ] **Step 2: Voir les gardes rouges**

Run: `bash tests/test-skill-contracts.sh 2>&1 | grep -F "[FAIL]"; bash tests/test-skill-content.sh 2>&1 | grep -F "[FAIL]"`
Expected: cinq lignes `[FAIL]` — « a redone detection receives the section and the branch », « stops on what a redone detection returns » pour `making-a-bounded-change`, le red flag (`missing in: making-a-bounded-change`), « no skill redoes the detection on a changed declaration » (`present in: making-a-bounded-change`) et « one more section redoes the detection » — et aucune autre.

- [ ] **Step 3: Réécrire le paragraphe de la règle (b)**

Dans `skills/making-a-bounded-change/SKILL.md`, remplace le paragraphe en retrait (deux espaces) qui commence par « **A declaration that changes before the pull request opens redoes the detection:** » et finit par « still cheap to undo. » par ce paragraphe, sur une seule ligne et avec le même retrait de deux espaces :

```markdown
  **Before its pull request opens, a bounded change about to touch a section the detection was not run for redoes the detection:** invoke it again, and give it that section and `bounded/<slug>` as well. Stop again if it returns a conflict or a declaration it could not read. The detection answered for the sections it was given, so a section added afterwards was never intersected against anything — not found free, simply never looked at.
```

- [ ] **Step 4: Ajouter le red flag**

Table `## Red Flags` de la même skill, après la ligne qui commence par `| "This is a small fix, the spec can stay silent about it" |`, ajoute :

```markdown
| "It's one more section of the same spec, the detection already ran" | It ran for the sections it was given, and never looked at this one. Detect again before touching it, and stop if it is held or a declaration cannot be read. |
```

- [ ] **Step 5: Mettre le `README` à jour**

Dans `README.md`, section `### Two stories at once`, le paragraphe qui commence par « A conflict is also a story and a bounded change touching the same section. » finit par « so a pull request that touches no spec at all is seen like any other. ». Ajoute après lui ce paragraphe :

```markdown
A piece of work about to touch one more section before its pull request opens
runs the detection again for that section.
```

- [ ] **Step 6: Voir les gardes vertes**

Run: `bash tests/run-all.sh 2>&1 | grep -F "[FAIL]"; bash tests/run-all.sh 2>&1 | tail -5` (délai de cinq minutes par lancement)
Expected: aucune ligne `[FAIL]`, la suite se termine sans erreur.

- [ ] **Step 7: Commit**

```bash
git add skills/making-a-bounded-change/SKILL.md README.md tests/test-skill-contracts.sh tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: un changement borné refait la détection pour la section qu'il va toucher" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

## Observed drift
