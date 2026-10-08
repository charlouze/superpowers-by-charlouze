# 13-us-15 — Faire un changement borné

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extraire dans la skill d'entrée `making-a-bounded-change` les règles du changement borné que `using-batches` porte, sans changer le comportement que la branche d'en dessous porte.

**Architecture:** `making-a-bounded-change` reçoit de `using-batches` les règles (a) à (g) du changement borné, la création de sa branche et son red flag. `using-batches` garde la table de routage, ce qui est gardé ou dérouté de `superpowers:brainstorming` et la lecture de `docs/adr/` par la conception, et mène à la skill neuve. `amending-a-batch` et `handling-a-stopped-story` nomment la skill neuve là où elles renvoyaient à `using-batches`. Les gardes suivent chaque texte dans la skill qui le porte.

**Tech Stack:** Markdown pour les skills, Bash pour les gardes de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes

## Global Constraints

### Constraints of the batch

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

### Freeze of the spec file

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

### Authority

When the batch and the spec contradict each other, the spec wins — without
exception and without deliberation. Implement what the spec says, record a
`Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
agent's.

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

### Stop condition of a technical story

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

### Stop condition on a constraint or an ADR

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

### ADRs

> The code this story writes holds these ADRs.

- `docs/adr/une-skill-par-moment-d-invocation.md`

### Conditions of an ADR

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

### What this extraction leaves alone

Cette story reprend le comportement que la branche d'en dessous porte. Aucune
tâche n'écrit ce qui suit :

- la règle (b) garde telle quelle sa phrase sur la déclaration qui change avant
  l'ouverture de la pull request, sans rien dire de plus d'une section ajoutée ;
- le changement borné ne porte pas la correction d'une spec sans toucher au
  code ;
- le changement borné n'invoque pas `supercharlouze:finishing-a-pr` ;
- les sections `Override 3` et `Override 4` de `using-batches` restent où elles
  sont.

### Working rules

- Toute commande `git` qui écrit un commit ou parle au remote passe par
  `bash ~/.config/github-app/as-agent.sh git …`, `commit --amend`, `rebase` et
  `cherry-pick` compris.
- Un commit se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et par
  aucune autre ligne d'attribution.
- Les `SKILL.md` et les fichiers de `tests/` gardent des fins de ligne LF.
- Écris les fichiers avec l'outil d'écriture ou d'édition de fichiers : l'outil
  Bash de ce poste mange les barres obliques inverses dans les heredocs et les
  `sed` en ligne. Le poste n'a ni `python` ni `node`.
- La suite entière se lance par `bash tests/run-all.sh`, prend environ trois
  minutes, et demande un délai de cinq minutes.
- Une skill est entièrement en anglais, et ne cite aucune section de
  `docs/specs/supercharlouze.md`.
- N'invoque pas `supercharlouze:following-the-rules` : la version installée du
  plugin ne la porte pas. Les règles qui valent pour la tâche sont dans cette
  section `Global Constraints`.

## Review Focus

- Un texte déplacé qui a changé en route : les règles (a) à (g) se retrouvent
  mot pour mot dans `making-a-bounded-change`.
- Une copie restée derrière : `using-batches` ne dit plus aucune règle du
  changement borné.
- Un changement entré par mégarde : rien de ce que `What this extraction leaves
  alone` énumère.
- Une garde perdue : toute garde d'un texte déplacé existe sur la skill qui le
  porte, et aucune garde n'est supprimée sans que son texte le soit.
- Un renvoi cassé : aucune skill ne renvoie plus à `using-batches` pour le
  changement borné, ni à une section de `using-batches` qui n'existe plus.

---

### Task 1: La skill `making-a-bounded-change`

**Files:**
- Create: `skills/making-a-bounded-change/SKILL.md`
- Modify: `tests/skills.txt`, `README.md`, `tests/test-skill-contracts.sh`,
  `tests/test-skill-content.sh`, `tests/test-cross-references.sh`,
  `tests/test-declared-overrides.sh`, `tests/test-technical-reader-prompt.sh`

**Interfaces:**
- Consumes: `skills/using-batches/SKILL.md`, lignes 37 à 46 et ligne 112, que
  cette tâche lit et ne modifie pas.
- Produces: la skill `making-a-bounded-change`, déclarée `entry`, avec les
  sections `Overview`, `The Rules` et `Red Flags`. La tâche 2 retire de
  `using-batches` ce que cette skill porte.

- [ ] **Step 1: Déclare la skill**

Dans `tests/skills.txt`, ajoute après la ligne `closing-a-batch entry` :

```
making-a-bounded-change entry
```

- [ ] **Step 2: Déplace les gardes de `tests/test-skill-contracts.sh`**

Chaque remplacement ci-dessous change `using-batches` en
`making-a-bounded-change` dans une garde qui tient un texte du changement borné,
et rien d'autre sur la ligne.

Ligne 18, la boucle de `starting-a-branch` devient :

```bash
for s in adopting-a-module opening-a-batch amending-a-batch writing-a-user-story closing-a-batch making-a-bounded-change; do
```

Ligne 32 devient :

```bash
require making-a-bounded-change "a bounded change passes bounded/<slug>" \
```

Lignes 62 et 63, le commentaire devient :

```bash
# returns: `writing-a-user-story` for a story, `making-a-bounded-change` for the
# bounded change.
```

Lignes 66 à 70, les deux `require` et la boucle deviennent :

```bash
require making-a-bounded-change "a bounded change invokes detecting-concurrency before creating its branch" \
    "Invoke \`supercharlouze:detecting-concurrency\` before creating \`bounded/<slug>\`, and give it that spec and those sections"
require making-a-bounded-change "a redone detection receives the branch" \
    "invoke it again, and give it \`bounded/<slug>\` as well"
for s in writing-a-user-story making-a-bounded-change; do
```

Lignes 103 et 104, la fin du commentaire devient :

```bash
# `writing-a-user-story` their transcription, and `making-a-bounded-change` the
# spec update of a bounded change. `closing-a-batch` writes into no spec file.
```

Ligne 107, la boucle de `writing-in-a-spec` devient :

```bash
for s in making-a-bounded-change adopting-a-module writing-a-batch-document writing-a-user-story; do
```

Ligne 129, dans le commentaire, `` `using-batches` carries the bounded change ``
devient `` `making-a-bounded-change` carries the bounded change ``.

Ligne 131, la boucle de `writing-in-a-gaps-register` devient :

```bash
for s in adopting-a-module closing-a-batch making-a-bounded-change opening-a-batch amending-a-batch writing-a-user-story; do
```

Ligne 887, dans l'expression de la garde « the technical reread names no skill
that invokes it », ajoute `making-a-bounded-change|` juste après
`handling-a-stopped-story|`.

Ligne 926, la liste de la garde « no skill counts the rules of a bounded
change » devient :

```bash
    using-batches following-the-rules making-a-bounded-change
```

- [ ] **Step 3: Déplace les gardes de `tests/test-skill-content.sh`**

Dans chacune des gardes ci-dessous, le premier argument `using-batches` devient
`making-a-bounded-change`, et l'étiquette et l'aiguille ne changent pas :

- ligne 853, « a bounded change invokes writing-in-a-spec before writing in a spec » ;
- ligne 1359, « a bounded change adds and removes entries » ;
- lignes 1382 à 1390, les cinq gardes « a bounded change may leave the spec
  silent », « a silent bounded change leaves the spec untouched », « a bounded
  change names the spec it targets », « a bounded change touching no section
  declares none » et « a changed declaration redoes the detection » ;
- ligne 1432, « a bounded change writes, rewrites and deletes ADRs » ;
- ligne 1434, « a bounded change invokes recording-a-decision » ;
- ligne 1456, « a bounded change holds the ADRs » ;
- ligne 1458, « a bounded change rereads docs/adr once its branch exists » ;
- ligne 1460, « a bounded change puts to the human the ADR it cannot hold » ;
- ligne 1462, « a bounded change puts to the human the decision that meets the conditions » ;
- ligne 1464, « a bounded change writes the ADR the human wants » ;
- ligne 1470, « a bounded change's decision along the way is put to the human too » ;
- ligne 1472, « the design read may be stale ».

Ne touche pas aux gardes de `using-batches` dont l'étiquette commence par « the
design », « the opening », « an approach », « routing » ou « the bounded
ceremony ».

Ligne 1381, le commentaire devient :

```bash
# --- making-a-bounded-change: the bounded change (spec `Bounded change`) ---
```

Juste après la garde « a changed declaration redoes the detection », ajoute :

```bash
require making-a-bounded-change "a bounded change has no batch and no user story" \
        "A bounded change has no batch and no user story: it is already a single pull request, and whether it carries a spec update is what rule (a) decides."
require making-a-bounded-change "the ceremony of bounded work is kept" \
        "Its ceremony is the one \`superpowers:brainstorming\` gives bounded work, and \`The Rules\` are what its pull request holds besides."
require making-a-bounded-change "a bounded change carries no flag" \
        "**(c) It carries no feature flag.**"
require making-a-bounded-change "red flag: a small fix that leaves the spec silent" \
        "| \"This is a small fix, the spec can stay silent about it\" | Only if nothing observable at the module's boundary changes."
```

- [ ] **Step 4: Déplace les gardes des trois autres fichiers**

Dans `tests/test-cross-references.sh`, lignes 70 et 71 deviennent :

```bash
# 4. The bounded path is spelled out (spec 8.2), in the skill that carries it.
UB="$(awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$REPO_ROOT/skills/making-a-bounded-change/SKILL.md" | tr '\n' ' ')"
```

Dans le même fichier, ajoute `*"making-a-bounded-change"*|` en tête du motif qui
fait échouer chacune de ces gardes de ligne du `README` :
`recording-a-decision` (ligne 123), `writing-in-a-spec` (ligne 136),
`writing-in-a-gaps-register` (ligne 150), `detecting-concurrency` (ligne 163)
et `starting-a-branch` (ligne 223). Exemple, ligne 123 :

```bash
    *"making-a-bounded-change"*|*"opening-a-batch"*|*"amending-a-batch"*|*"writing-a-user-story"*|*"adopting-a-module"*|*"invoked by"*)
```

Toujours dans ce fichier, juste après le bloc `HROW` (la garde « the README row
of handling-a-stopped-story says when it is used »), ajoute :

```bash

# The README row of making-a-bounded-change says when the skill is used.
MROW="$(grep -F '`supercharlouze:making-a-bounded-change`' "$REPO_ROOT/README.md" || true)"
case "$MROW" in
    *"A well-scoped change that needs no batch, or an ADR to write, rewrite or delete outside a batch"*)
        pass "the README row of making-a-bounded-change says when it is used" ;;
    *)  fail "the README row of making-a-bounded-change says when it is used" ;;
esac
```

Dans `tests/test-declared-overrides.sh`, remplace les lignes 123 à 129 (du
commentaire « The bounded change's rule on updating the spec » jusqu'au `fi`)
par :

```bash
# The bounded change's rule on updating the spec in the same pull request lives
# in making-a-bounded-change.
BOUNDED_FLAT="$(tr '\n' ' ' < "$REPO_ROOT/skills/making-a-bounded-change/SKILL.md")"
if has "same pull request" "$BOUNDED_FLAT"; then
    pass "making-a-bounded-change states: same pull request"
else
    fail "making-a-bounded-change states: same pull request"
fi
```

Dans `tests/test-technical-reader-prompt.sh`, ligne 95, ajoute
`*"making-a-bounded-change"*|` juste après `*"handling-a-stopped-story"*|`.

- [ ] **Step 5: Lance les gardes et constate le rouge**

Run: `bash tests/test-skill-contracts.sh | grep FAIL; bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-frontmatter.sh | grep FAIL; bash tests/test-cross-references.sh | grep FAIL; bash tests/test-declared-overrides.sh | tail -3`

Expected: des `[FAIL]` sur `making-a-bounded-change` dans les quatre premiers
fichiers, dont `making-a-bounded-change/SKILL.md exists`, et
`test-declared-overrides.sh` qui s'arrête sur le fichier absent.

- [ ] **Step 6: Écris la skill**

Crée `skills/making-a-bounded-change/SKILL.md`. Ses lignes 1 à 19 sont
exactement :

```markdown
---
name: making-a-bounded-change
description: Use when a piece of work is bounded, in a project whose CLAUDE.md says specs and plans are overridden - a well-scoped change that needs no batch, or an ADR your human partner wants written, rewritten or deleted outside a batch - holds the change to a single pull request on a bounded/<slug> branch, with its spec update, its declaration and its ADRs
---

# Making a Bounded Change

## Overview

A bounded change has no batch and no user story: it is already a single pull request, and whether it carries a spec update is what rule (a) decides.

Its ceremony is the one `superpowers:brainstorming` gives bounded work, and `The Rules` are what its pull request holds besides.

**Announce at start:** "I'm using the making-a-bounded-change skill to make this bounded change."

**Start by invoking `supercharlouze:following-the-rules`, unless this session already has.**

## The Rules

```

Ses lignes 20 à 29 sont les lignes 37 à 46 de `skills/using-batches/SKILL.md`,
recopiées sans y changer un caractère : les règles (a) à (g), avec le paragraphe
en retrait de la règle (b) et les deux lignes vides qui l'entourent.

Ses lignes 30 à 37 sont exactement, la ligne 30 étant vide :

```markdown

Its branch is `bounded/<slug>`: invoke `supercharlouze:starting-a-branch` and give it the name `bounded/<slug>`.

## Red Flags

| Thought | Reality |
|---------|---------|
| "This is a small fix, the spec can stay silent about it" | Only if nothing observable at the module's boundary changes. The moment behaviour moves, the spec is updated in the same pull request, and either way the change declares the spec it targets and the sections it touches. |
```

- [ ] **Step 7: Vérifie la recopie**

Run: `diff <(sed -n 37,46p skills/using-batches/SKILL.md) <(sed -n 20,29p skills/making-a-bounded-change/SKILL.md) && echo identical`

Expected: `identical`.

Run: `diff <(sed -n 112p skills/using-batches/SKILL.md) <(sed -n 37p skills/making-a-bounded-change/SKILL.md) && echo identical`

Expected: `identical`.

- [ ] **Step 8: Ajoute la ligne du `README`**

Dans le tableau `Skills` de `README.md`, ajoute après la ligne de
`supercharlouze:closing-a-batch` :

```markdown
| `supercharlouze:making-a-bounded-change` | A well-scoped change that needs no batch, or an ADR to write, rewrite or delete outside a batch |
```

- [ ] **Step 9: Lance la suite entière**

Run: `bash tests/run-all.sh 2>&1 | grep -E 'FAIL|passed|failed' | tail -20`

Expected: aucun `[FAIL]`.

- [ ] **Step 10: Commit**

```bash
git add skills/making-a-bounded-change tests README.md
bash ~/.config/github-app/as-agent.sh git commit -F <fichier de message>
```

Le message, écrit dans un fichier avec l'outil d'écriture :

```
feat: la skill d'entrée making-a-bounded-change porte les règles du changement borné

Co-Authored-By: Charlouze <me@charlouze.com>
```

### Task 2: `using-batches` route le changement borné

**Files:**
- Modify: `skills/using-batches/SKILL.md`, `tests/test-skill-contracts.sh`,
  `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la skill `making-a-bounded-change` de la tâche 1, qui porte les
  règles (a) à (g), la création de la branche et le red flag.
- Produces: `using-batches` sans aucune règle du changement borné, dont la table
  de routage mène à `supercharlouze:making-a-bounded-change`.

- [ ] **Step 1: Écris les gardes**

Dans `tests/test-skill-content.sh`, la garde « routing sends an ADR to a bounded
change » (ligne 1422 avant la tâche 1) prend pour aiguille :

```bash
        "| Your human partner wants an ADR written, rewritten or deleted outside the adoption of a module, the opening of a batch, its amendment, the delivery review of a story and the installation | \`supercharlouze:making-a-bounded-change\` |"
```

Dans le même fichier, la garde « the bounded ceremony has an exception » prend
pour aiguille :

```bash
        "**Bounded** — ceremony unchanged, except for the reading of \`docs/adr/\` stated below. \`supercharlouze:making-a-bounded-change\` carries the rules its pull request holds."
```

Dans `tests/test-skill-contracts.sh`, juste avant la dernière ligne
`exit $((FAILURES > 0))`, ajoute, suivi d'une ligne vide :

```bash
# The rules of a bounded change live in one place, `making-a-bounded-change`.
# `using-batches` routes to it and restates none of them. Walks the declared
# skills, so one declared later is covered.
require using-batches "the routing table leads bounded work to making-a-bounded-change" \
    "| Bounded work | \`supercharlouze:making-a-bounded-change\` |"
require using-batches "the routing table reroutes nothing of a spike" \
    "| Spike | Nothing is rerouted |"
# shellcheck disable=SC2046
absent "no other skill restates the rules of a bounded change" \
    "if and only if nothing observable at the module's boundary changes|That silence is not a tolerance|It carries no feature flag|add an entry and delete one|may carry nothing but ADRs|redoes the detection|under rule \(e\)|reread .docs/adr/. and hold what you find there|the spec can stay silent about it" \
    $(declared_skills | grep -vx making-a-bounded-change)
absent "using-batches keeps no section the bounded path is sent to" \
    "under .What Is Kept, What Is Rerouted. below|except what .What Is Kept, What Is Rerouted. states below|with these rules:" \
    using-batches
```

- [ ] **Step 2: Lance les gardes et constate le rouge**

Run: `bash tests/test-skill-contracts.sh | grep FAIL; bash tests/test-skill-content.sh | grep FAIL`

Expected: six `[FAIL]`, tous sur `using-batches` : les deux lignes de la table,
les deux gardes négatives (« present in: using-batches »), « routing sends an ADR
to a bounded change » et « the bounded ceremony has an exception ».

- [ ] **Step 3: Réécris `using-batches`**

Dans `skills/using-batches/SKILL.md`, les deux dernières lignes de la table
`Route by situation` (celle qui commence par `| Your human partner wants an ADR`
et celle qui commence par `| Spike or bounded work`) deviennent ces trois
lignes :

```markdown
| Your human partner wants an ADR written, rewritten or deleted outside the adoption of a module, the opening of a batch, its amendment, the delivery review of a story and the installation | `supercharlouze:making-a-bounded-change` |
| Bounded work | `supercharlouze:making-a-bounded-change` |
| Spike | Nothing is rerouted |
```

Dans la section `What Is Kept, What Is Rerouted`, remplace tout ce qui va de la
ligne qui commence par `**Bounded** — ceremony unchanged` jusqu'à la ligne qui
commence par `No batch, no user story:` comprise (les règles (a) à (g) et les
lignes vides entre elles) par cette seule ligne :

```markdown
**Bounded** — ceremony unchanged, except for the reading of `docs/adr/` stated below. `supercharlouze:making-a-bounded-change` carries the rules its pull request holds.
```

La ligne vide qui la sépare de `**Spike** — unchanged.` au-dessus et de
`**Architectural** —` au-dessous reste.

Dans la table `Red Flags`, supprime la dernière ligne, qui commence par
`| "This is a small fix, the spec can stay silent about it" |`.

Ne change rien d'autre : ni le paragraphe `**The design reads `docs/adr/`.**`,
ni les sections `Override 1` à `Override 4`.

- [ ] **Step 4: Lance la suite entière**

Run: `bash tests/run-all.sh 2>&1 | grep -E 'FAIL|passed|failed' | tail -20`

Expected: aucun `[FAIL]`.

- [ ] **Step 5: Commit**

```bash
git add skills/using-batches tests
bash ~/.config/github-app/as-agent.sh git commit -F <fichier de message>
```

Le message :

```
refactor: using-batches mène le changement borné à making-a-bounded-change

Co-Authored-By: Charlouze <me@charlouze.com>
```

### Task 3: Les renvois au changement borné nomment la skill

**Files:**
- Modify: `skills/amending-a-batch/SKILL.md`,
  `skills/handling-a-stopped-story/SKILL.md`, `tests/test-skill-content.sh`,
  `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: le nom `supercharlouze:making-a-bounded-change` de la tâche 1.
- Produces: aucune skill ne renvoie plus à `supercharlouze:using-batches` pour
  le changement borné.

- [ ] **Step 1: Écris les gardes**

Dans `tests/test-skill-content.sh`, la garde « a change of ADRs alone is a
bounded change » de `amending-a-batch` prend pour aiguille :

```bash
"A change that touches nothing but ADRs is not an amendment: it goes through a bounded change, under \`supercharlouze:making-a-bounded-change\`."
```

Dans le même fichier, la garde « an untenable ADR goes to a bounded change » de
`handling-a-stopped-story` prend pour aiguille :

```bash
    "| An ADR is untenable | A bounded change, under \`supercharlouze:making-a-bounded-change\`, rewrites or deletes it. |"
```

Dans `tests/test-skill-contracts.sh`, juste avant la dernière ligne
`exit $((FAILURES > 0))`, ajoute, suivi d'une ligne vide :

```bash
# A skill that sends work to a bounded change names the skill that carries it.
absent_everywhere "no skill sends a bounded change to using-batches" \
    "bounded change, under .supercharlouze:using-batches"
```

- [ ] **Step 2: Lance les gardes et constate le rouge**

Run: `bash tests/test-skill-contracts.sh | grep FAIL; bash tests/test-skill-content.sh | grep FAIL`

Expected: trois `[FAIL]` : la garde négative (« present in: amending-a-batch
handling-a-stopped-story ») et les deux gardes réécrites.

- [ ] **Step 3: Réécris les deux renvois**

Dans `skills/amending-a-batch/SKILL.md`, section `What an Amendment Is For`, le
paragraphe devient :

```markdown
A change that touches nothing but ADRs is not an amendment: it goes through a
bounded change, under `supercharlouze:making-a-bounded-change`.
```

Dans `skills/handling-a-stopped-story/SKILL.md`, la dernière ligne de la table de
`What the Ruling Asks For` devient :

```markdown
| An ADR is untenable | A bounded change, under `supercharlouze:making-a-bounded-change`, rewrites or deletes it. |
```

- [ ] **Step 4: Lance la suite entière**

Run: `bash tests/run-all.sh 2>&1 | grep -E 'FAIL|passed|failed' | tail -20`

Expected: aucun `[FAIL]`.

- [ ] **Step 5: Commit**

```bash
git add skills tests
bash ~/.config/github-app/as-agent.sh git commit -F <fichier de message>
```

Le message :

```
refactor: les renvois au changement borné nomment making-a-bounded-change

Co-Authored-By: Charlouze <me@charlouze.com>
```

## Rulings log

- Ruling: la story reste technique alors que `using-batches` se met à mener vers une skill neuve — la spec ne dit pas quelle skill porte une règle, et l'arbitrage a été rendu sur la story de `writing-in-a-spec` — si c'est faux, la story demandait un bloc et une revue d'ouverture.
- Ruling: les règles (a) à (g) gardent leurs lettres et leur tournure « It… », sous une section `The Rules` — une extraction reprend le texte que la branche d'en dessous porte, et les règles se citent par leur lettre — si c'est faux, la skill reste écrite en constats là où `CLAUDE.md` demande des instructions.
- Ruling: la ligne « Spike or bounded work » de la table de routage devient deux lignes, « Bounded work » qui mène à la skill et « Spike » qui dit « Nothing is rerouted » — la section à laquelle la ligne renvoyait ne dit plus rien du changement borné — si c'est faux, le spike a perdu un renvoi vers `What Is Kept, What Is Rerouted`, qui n'en dit qu'une phrase.
- Ruling: la lecture de `docs/adr/` par la conception reste écrite dans `using-batches`, et l'`Overview` de `making-a-bounded-change` y renvoie — `Technical design` la donne à `using-batches`, et une règle s'écrit en un seul endroit — si c'est faux, un agent arrivé à la skill sans passer par `using-batches` doit ouvrir une seconde skill pour la lire.
- Ruling: le changement borné n'invoque pas `supercharlouze:finishing-a-pr` — `using-batches` ne portait aucune copie de la fin d'une revue, et la story de `finishing-a-pr` a déjà consigné cet état — si c'est faux, la revue d'un changement borné se termine sans la règle des `fixup!` ni la demande de vider le contexte.
- Ruling: la règle (b) garde telle quelle sa phrase sur la déclaration qui change avant l'ouverture de la pull request — le bloc sur la section de plus revient à la story qui le transcrit — si c'est faux, cette story-là trouve une phrase à réécrire plutôt qu'à ajouter.
- Ruling: les sections `Override 3` et `Override 4` restent dans `using-batches` — leur déplacement revient à la story qui renomme la skill de story — si c'est faux, `using-batches` porte en entier deux overrides que `Technical design` donne à `delivering-a-story` jusqu'à cette story.
- Ruling: les red flags de `using-batches` qui parlent du spec delta, du champ `Feature flag`, du flag qui survit à son lot et de la fusion locale restent où ils sont — aucun ne tient à une règle du changement borné — si c'est faux, le routeur garde des red flags dont la règle vit dans une autre skill.
- Ruling: le paragraphe du `README` sur le changement borné ne change pas — il décrit le flow à un utilisateur et ne dit pas quelle skill porte les règles — si c'est faux, le `README` redit des règles sans nommer la skill qui les porte.
- Ruling: la garde « no skill sends a bounded change to using-batches » ne chasse que la tournure « bounded change, under `supercharlouze:using-batches` » — c'est la seule que les skills portaient — si c'est faux, un renvoi écrit autrement passe la garde.
- Ruling: l'`Overview` nomme `supercharlouze:using-batches` sans nommer le paragraphe qui porte la lecture de `docs/adr/` — un renvoi entre parenthèses ne nomme qu'une section de la skill qui l'écrit, et ce paragraphe n'a pas de titre — si c'est faux, l'agent cherche le paragraphe dans la skill.
- Ruling: les trois commits des tâches et la correction de la relecture finale sont fondus en un seul `feat:` — la story livre une idée, donc une ligne au changelog — si c'est faux, l'historique a perdu le détail des tâches.
- Ruling: la relecture finale de la branche est partie sur le même modèle que les tâches — c'est la décision de l'humain pour les sous-agents de ce lot — si c'est faux, une relecture plus capable aurait vu ce que celle-ci a manqué.

## Observed drift
