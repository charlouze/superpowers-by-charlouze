# L'extraction de abandoning-a-story Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La skill interne `abandoning-a-story` porte le geste d'abandon d'une story, et les skills qui le recopiaient l'invoquent à la place de leur copie.

**Architecture:** `abandoning-a-story` reçoit la branche de la story. Elle ferme sa pull request sans la fusionner s'il y en a une, supprime la branche en local et sur le remote, et retire l'espace de travail. `writing-a-batch` et `writing-a-user-story` l'invoquent là où elles écrivaient le geste, et chacune garde le moment où elle abandonne. Les gardes du texte suivent le texte, et le contrat `shared` qui exigeait des copies devient une garde sur `abandoning-a-story` et une garde sur chaque skill qui l'invoque.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes

## Global Constraints

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

> When the batch and the spec contradict each other, the spec wins — without
> exception and without deliberation. Implement what the spec says, record a
> `Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
> agent's.

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

### La condition d'arrêt d'une story technique

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

### La condition d'arrêt sur une contrainte ou un ADR

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

### Les ADR

> The code this story writes holds these ADRs.

- `docs/adr/une-skill-par-moment-d-invocation.md`

### Les décisions qui méritent un ADR

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

### Ce que cette story ne change pas

Le moment où une story est abandonnée reste celui que chaque skill appelante
porte aujourd'hui. Une story technique dont la condition d'arrêt se déclenche
voit encore sa pull request fermée dès l'arrêt : le bloc sur `Amending a batch`
et l'entrée du gaps register qui le concerne reviennent à une story ultérieure.

### Le poste

Toute commande `git` qui écrit un commit ou parle au remote passe par
`bash ~/.config/github-app/as-agent.sh git …`. Un commit se termine par
`Co-Authored-By: Charlouze <me@charlouze.com>` et par aucune autre ligne
d'attribution.

L'outil Bash mange les barres obliques inverses dans les heredocs et les `sed` en
ligne : un fichier s'écrit et se modifie avec les outils d'écriture et d'édition
de fichiers. Les `SKILL.md` gardent des fins de ligne LF.

La suite se lance par `bash tests/run-all.sh` et prend environ deux minutes.

## Review Focus

- Une skill appelante qui perd son moment d'abandon : après la story,
  `writing-a-batch` dit encore « A pull request already open stays open until
  then. » et `writing-a-user-story` « a pull request already open is closed
  without merging then, not when you stop ». Les gardes existantes de
  `tests/test-skill-content.sh` les tiennent, et aucune tâche ne les retire.
- Une copie du geste qui survit dans une skill appelante : la garde négative de
  la tâche 3 la refuse.
- Un nom de skill d'entrée dans `abandoning-a-story` : la garde de la tâche 1 le
  refuse.
- Une ligne `Red Flags` de `writing-a-batch` qui redit le geste : la tâche 2 la
  réduit à son moment, et la garde négative de la tâche 3 la couvre.

---

### Task 1: La skill `abandoning-a-story`

**Files:**
- Create: `skills/abandoning-a-story/SKILL.md`
- Modify: `tests/skills.txt`
- Modify: `tests/test-skill-content.sh` (après la garde `detecting-concurrency names no skill that invokes it`)
- Modify: `tests/test-cross-references.sh` (après les gardes de la ligne `README` de `detecting-concurrency`)
- Modify: `README.md` (tableau `Skills`)

**Interfaces:**
- Consumes: `require`, `absent` de `tests/lib.sh` ; la variable `entry_names` que `tests/test-skill-content.sh` définit plus haut.
- Produces: la skill `supercharlouze:abandoning-a-story`, que les tâches 2 et 3 font invoquer par la phrase ``invoke `supercharlouze:abandoning-a-story` and give it the story's branch``.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, juste après la ligne
`absent "detecting-concurrency names no skill that invokes it" …`, ajouter :

```bash

# --- abandoning-a-story: the gesture (spec section "Abandoning a story") ---
require abandoning-a-story "says what the invoking skill passes" \
    "The skill that invokes it gives the story's branch."
require abandoning-a-story "closes an open pull request without merging it" \
    "**Close the story's pull request without merging it, if one is open.**"
require abandoning-a-story "a story stopped before its pull request opened has none" \
    "there is nothing to close, only a branch and a worktree to discard"
require abandoning-a-story "deletes the branch on the remote too" \
    "**Delete the branch, locally and on the remote.**"
require abandoning-a-story "a branch left on the remote is a live claim" \
    "reads as a live claim on its sections"
require abandoning-a-story "removes the worktree" "**Remove its worktree.**"
require abandoning-a-story "nothing reached main" \
    "the spec change, or the deleted gaps-register entry, travels with the code and dies with the branch"
require abandoning-a-story "changes nothing on main" "Change nothing on \`main\`."
require abandoning-a-story "red flag: the branch can stay" \
    "| \"The story is abandoned, the branch can stay\" | A pushed \`story/*\` branch with no pull request reads as a live claim on its sections. Delete it, locally and on the remote. |"
require abandoning-a-story "says when to go back to the step that invoked it" \
    "Once the story is abandoned, go on with the step that invoked this skill."
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them.
absent "abandoning-a-story names no skill that invokes it" "${entry_names%|}|Step [0-9]" abandoning-a-story
```

Dans `tests/test-cross-references.sh`, juste après le second `esac` des gardes
de la ligne `README` de `detecting-concurrency`, ajouter :

```bash

# The README row of abandoning-a-story, like the other internal skills', says
# it is not for direct use and names none of the skills that invoke it.
AROW="$(grep -F '`supercharlouze:abandoning-a-story`' "$REPO_ROOT/README.md" || true)"
case "$AROW" in
    *"writing-a-batch"*|*"writing-a-user-story"*|*"invoked by"*)
        fail "the README row of abandoning-a-story names no caller" ;;
    *)  pass "the README row of abandoning-a-story names no caller" ;;
esac
case "$AROW" in
    *"Never directly"*) pass "the README row of abandoning-a-story rules out direct use" ;;
    *)                  fail "the README row of abandoning-a-story rules out direct use" ;;
esac
```

- [ ] **Step 2: Voir les gardes échouer**

Run: `bash tests/test-skill-content.sh 2>&1 | grep abandoning-a-story` puis
`bash tests/test-cross-references.sh 2>&1 | grep abandoning-a-story`

Expected: dix `[FAIL] abandoning-a-story: …`, un
`[FAIL] abandoning-a-story names no skill that invokes it (no such skill: abandoning-a-story)`,
et `[FAIL] the README row of abandoning-a-story rules out direct use`. La garde
« names no caller » passe sur une ligne absente : elle ne devient probante
qu'avec la ligne.

- [ ] **Step 3: Écrire la skill**

Créer `skills/abandoning-a-story/SKILL.md`, fins de ligne LF, avec exactement :

```markdown
---
name: abandoning-a-story
description: Use only when a skill tells you to invoke abandoning-a-story, never on a request to drop a story - closes the story's pull request without merging it, deletes its branch locally and on the remote, and removes its worktree
user-invocable: false
---

# Abandoning a Story

## Overview

This skill makes the gesture that abandons a story.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the abandoning-a-story skill to abandon this story."

The skill that invokes it gives the story's branch.

Once the story is abandoned, go on with the step that invoked this skill.

## The Gesture

1. **Close the story's pull request without merging it, if one is open.** A
   story stopped before its pull request opened has none: there is nothing to
   close, only a branch and a worktree to discard.
2. **Delete the branch, locally and on the remote.** A pushed `story/*` branch
   with no pull request reads as a live claim on its sections, so a branch left
   on the remote holds them against every story that follows, and nothing ever
   releases them.
3. **Remove its worktree.** A worktree left behind is where a later session
   resumes a story that no longer exists.

## What It Leaves on `main`

Nothing has to be revoked: the spec change, or the deleted gaps-register entry,
travels with the code and dies with the branch.

Change nothing on `main`. The gaps register reservations and the blocks the
batch announced were put there by the batch's opening pull request, and
abandoning a story leaves them as they are.

## Red Flags

| Thought | Reality |
|---------|---------|
| "The story is abandoned, the branch can stay" | A pushed `story/*` branch with no pull request reads as a live claim on its sections. Delete it, locally and on the remote. |
```

Dans `tests/skills.txt`, ajouter la ligne `abandoning-a-story internal` après
`detecting-concurrency internal`.

Dans `README.md`, ajouter au tableau `Skills`, après la ligne de
`supercharlouze:detecting-concurrency` :

```markdown
| `supercharlouze:abandoning-a-story` | Never directly — a building block the other skills invoke to close an abandoned story's pull request, delete its branch and remove its worktree |
```

- [ ] **Step 4: Voir la suite passer**

Run: `bash tests/run-all.sh 2>&1 | grep -E "FAIL|all tests passed"`

Expected: `all tests passed`, aucun `[FAIL]`.

- [ ] **Step 5: Commit**

Sujet : `feat: la skill interne abandoning-a-story porte le geste d'abandon`

---

### Task 2: `writing-a-batch` invoque `abandoning-a-story`

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`Amending a Batch`, `Requalifying a Corrective Batch`, `Requalifying a Technical Story`, `Red Flags`)
- Modify: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la skill `supercharlouze:abandoning-a-story` de la tâche 1.
- Produces: dans `writing-a-batch`, la phrase ``invoke `supercharlouze:abandoning-a-story` and give it the story's branch``, que la garde de la tâche 3 cherche.

- [ ] **Step 1: Remplacer les gardes**

Dans `tests/test-skill-content.sh`, remplacer la ligne

```bash
require writing-a-batch "a story abandoned on a constraint leaves no branch behind" "delete its branch locally and on the remote, and remove its worktree, since a branch left on the remote reads as a live claim on its sections"
```

par

```bash
require writing-a-batch "a story abandoned on a constraint goes through abandoning-a-story" "the story is abandoned: invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch"
```

et la ligne

```bash
require writing-a-batch "a corrective story's remote branch is a live claim" "a branch left on the remote is read as a live claim on its sections by every sibling's concurrency scan"
```

par

```bash
require writing-a-batch "a corrective story goes through abandoning-a-story once ruled" "Once the choice is ruled, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch"
require writing-a-batch "a technical story's pull request is closed at the stop" "Close its pull request without merging it if one is already open; the branch and its worktree stay until the choice below is ruled."
require writing-a-batch "a technical story goes through abandoning-a-story once ruled" "Once it is ruled, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch"
require writing-a-batch "red flag: requalification does not start by closing" "| \"Requalification starts by closing the story's pull request\" | Override 2 fires mid-SDD, usually before any pull request exists. Close it only if it is already open. |"
```

- [ ] **Step 2: Voir les gardes échouer**

Run: `bash tests/test-skill-content.sh 2>&1 | grep -E "abandoning-a-story|closed at the stop|does not start by closing"`

Expected: cinq `[FAIL] writing-a-batch: …`, et les gardes de la tâche 1 en `[PASS]`.

- [ ] **Step 3: Réécrire les passages**

Dans `skills/writing-a-batch/SKILL.md`, section `Amending a Batch`, remplacer

```markdown
**When a story stops on a constraint it cannot hold, your human partner rules on
the constraint.** If they rule it untenable, an amendment changes or removes the
constraint and the story is abandoned: close its pull request without merging it
if one is open, delete its branch locally and on the remote, and remove its
worktree, since a branch left on the remote reads as a live claim on its
sections. Otherwise the story resumes and holds the constraint, and nothing is
amended.
```

par

```markdown
**When a story stops on a constraint it cannot hold, your human partner rules on
the constraint.** If they rule it untenable, an amendment changes or removes the
constraint and the story is abandoned: invoke
`supercharlouze:abandoning-a-story` and give it the story's branch. Otherwise
the story resumes and holds the constraint, and nothing is amended.
```

Section `Requalifying a Corrective Batch`, remplacer le point 1 en entier, de
`1. **Leave the story as it stands` jusqu'à `posted by the opening pull request.`,
par

```markdown
1. **Leave the story as it stands until the choice below is ruled, then abandon
   it.** A pull request already open stays open until then. Once the choice is
   ruled, invoke `supercharlouze:abandoning-a-story` and give it the story's
   branch.
```

Section `Requalifying a Technical Story`, remplacer le point 1 en entier, de
`1. **Abandon the story.**` jusqu'à `reads as a live claim on its sections.`,
par

```markdown
1. **Abandon the story.** Close its pull request without merging it if one is
   already open; the branch and its worktree stay until the choice below is
   ruled. Once it is ruled, invoke `supercharlouze:abandoning-a-story` and give
   it the story's branch.
```

Table `Red Flags`, remplacer la ligne

```markdown
| "Requalification starts by closing the story's pull request" | Override 2 fires mid-SDD, usually before any pull request exists. Close it only if it is already open; otherwise discard the branch, locally and on the remote, and its worktree — a branch left on the remote reads as a live claim on its sections. |
```

par

```markdown
| "Requalification starts by closing the story's pull request" | Override 2 fires mid-SDD, usually before any pull request exists. Close it only if it is already open. |
```

- [ ] **Step 4: Voir la suite passer**

Run: `bash tests/run-all.sh 2>&1 | grep -E "FAIL|all tests passed"`

Expected: un seul `[FAIL]`, celui du contrat
`both accounts of an abandonment name the same residue (missing in: writing-a-batch)`,
que la tâche 3 remplace. Aucun autre.

- [ ] **Step 5: Commit**

Sujet : `feat: writing-a-batch invoque abandoning-a-story`

---

### Task 3: `writing-a-user-story` invoque `abandoning-a-story`

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (`Step 5 — Execute`, `Step 7 — Answer the Review`, `Red Flags`)
- Modify: `tests/test-skill-content.sh`
- Modify: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la skill de la tâche 1 ; la phrase d'invocation que la tâche 2 a écrite dans `writing-a-batch`.
- Produces: rien qu'une tâche suivante consomme.

- [ ] **Step 1: Remplacer les gardes**

Dans `tests/test-skill-content.sh`, remplacer la ligne

```bash
require writing-a-user-story "abandoning removes the worktree too"  "remove its worktree and delete its branch, locally and on the remote"
```

par

```bash
require writing-a-user-story "abandoning goes through abandoning-a-story" "**To abandon a story, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch.**"
require writing-a-user-story "a requalified story goes through abandoning-a-story once ruled" "Once the requalification is ruled, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch."
```

Dans `tests/test-skill-contracts.sh`, remplacer le bloc

```bash
# The same sentence about what an abandoned story leaves behind is written in
# two skills, and it names the gesture the register now uses. One assertion over
# both: separate ones would let the two accounts of an abandonment drift apart,
# and an agent reading either would believe it had the whole picture.
shared "both accounts of an abandonment name the same residue" \
    "the spec change, or the deleted gaps-register entry, travels with the code and dies with the branch" \
    writing-a-batch writing-a-user-story
```

par

```bash
# The gesture that abandons a story lives in one place, `abandoning-a-story`. A
# skill that abandons a story invokes it and passes the story's branch.
for s in writing-a-batch writing-a-user-story; do
    require "$s" "invokes abandoning-a-story with the story's branch" \
        "invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch"
done
# What it carries is spelled there and nowhere else. Walks the declared skills,
# so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the abandonment gesture" \
    "dies with the branch|live claim on its sections|[Dd]elete (its|the story|the abandoned) branch|[Rr]emove its worktree|worktree removed|discard the branch" \
    $(declared_skills | grep -vx abandoning-a-story)
```

- [ ] **Step 2: Voir les gardes échouer**

Run: `bash tests/test-skill-content.sh 2>&1 | grep "goes through abandoning-a-story"` puis
`bash tests/test-skill-contracts.sh 2>&1 | grep -E "abandoning-a-story|abandonment gesture"`

Expected: les deux gardes de `writing-a-user-story` en `[FAIL]` dans le premier
fichier ; dans le second,
`[PASS] writing-a-batch: invokes abandoning-a-story with the story's branch`,
`[FAIL] writing-a-user-story: invokes abandoning-a-story with the story's branch` et
`[FAIL] no other skill restates the abandonment gesture (present in: writing-a-user-story)`.

- [ ] **Step 3: Réécrire les passages**

Dans `skills/writing-a-user-story/SKILL.md`, `Step 5 — Execute`, remplacer le
paragraphe

```markdown
Nothing on `main` changes either way — the spec change, or the deleted
gaps-register entry, travels with the code and dies with the branch. The
reservation posted on `main` by the batch's opening pull request is untouched:
the amendment that takes its entry out of `Scope` releases it, or
`supercharlouze:closing-a-batch` does. Once the requalification is
ruled, delete the abandoned branch, locally and on the remote, and remove its
worktree — the branch left on the remote would read as a live claim on its
sections, and the worktree left behind is where a later session resumes work
under a qualification the batch — or the story — no longer has.
```

par

```markdown
The reservation posted on `main` by the batch's opening pull request is
untouched: the amendment that takes its entry out of `Scope` releases it, or
`supercharlouze:closing-a-batch` does.

Once the requalification is ruled, invoke `supercharlouze:abandoning-a-story`
and give it the story's branch.
```

`Step 7 — Answer the Review`, remplacer les deux paragraphes qui commencent par
`**Abandoning is almost free.**` et par
`**Clean up after an abandoned or requalified story:`, en entier, par

```markdown
**To abandon a story, invoke `supercharlouze:abandoning-a-story` and give it the
story's branch.** What remains on `main` belongs to
`supercharlouze:closing-a-batch`: the blocks the batch announced and no story
delivered, and the gaps register reservation posted by the batch's opening pull
request, unless an amendment took its entry out of `Scope` and released it. Do
not count them — a story that transcribed no block announced nothing in the spec
delta and leaves the reservation alone.
```

Table `Red Flags`, supprimer la ligne

```markdown
| "The story is abandoned, the branch can stay" | A pushed `story/*` branch with no pull request reads as a live claim on its sections. Delete it, locally and on the remote. |
```

- [ ] **Step 4: Voir la suite passer**

Run: `bash tests/run-all.sh 2>&1 | grep -E "FAIL|all tests passed"`

Expected: `all tests passed`, aucun `[FAIL]`.

- [ ] **Step 5: Prouver le rouge de la garde négative**

Copier `skills/` dans un répertoire temporaire hors du dépôt, y rajouter à la fin
de `closing-a-batch/SKILL.md` la phrase `Delete its branch and remove its worktree.`,
puis lancer `SKILLS_DIR=<copie> bash tests/test-skill-contracts.sh 2>&1 | grep "abandonment gesture"`.

Expected: `[FAIL] no other skill restates the abandonment gesture (present in: closing-a-batch)`.

Supprimer la copie.

- [ ] **Step 6: Commit**

Sujet : `feat: writing-a-user-story invoque abandoning-a-story`

## Rulings log

Ruling: la story reste technique alors que `writing-a-batch` et `writing-a-user-story` se mettent à invoquer une skill là où elles portaient le texte — la spec ne dit pas quelle skill porte une règle, et l'humain l'a déjà arbitré ainsi sur l'extraction de `writing-in-a-spec` — si c'est faux, la story aurait dû s'arrêter sur sa condition d'arrêt et passer par un amendement.

Ruling: la fermeture de la pull request d'une story technique dès l'arrêt reste écrite dans `writing-a-batch` et `writing-a-user-story`, hors de `abandoning-a-story` — c'est le moment d'abandon que ces skills portent aujourd'hui, que change le bloc sur `Amending a batch`, transcrit par une story ultérieure ; `abandoning-a-story` ne ferme une pull request que s'il y en a une d'ouverte, donc l'invoquer ensuite ne refait rien — si c'est faux, une phrase du geste reste recopiée chez deux appelantes jusqu'à cette story.

Ruling: `abandoning-a-story` retire l'espace de travail avant de supprimer la branche, à l'inverse de l'ordre que le plan écrit — git refuse de supprimer une branche qu'un espace de travail a en checkout, `writing-a-user-story` écrivait déjà « remove its worktree and delete its branch », et la spec ne fixe pas d'ordre — si c'est faux, deux points de la skill et la garde qui tient leur ordre sont à inverser.

Ruling: `writing-a-user-story` garde la phrase qui attribue à `closing-a-batch` ce qu'un abandon laisse sur `main`, et `abandoning-a-story` dit seulement de ne rien changer sur `main` — une skill interne ne nomme pas une skill d'entrée, et la phrase dit à qui abandonne de ne pas compter ce résidu — si c'est faux, la phrase décrit ce que fait une autre skill et se retire de `writing-a-user-story` avec ses deux gardes.

Ruling: `writing-a-user-story` invoque `abandoning-a-story` à deux endroits, après une requalification tranchée à l'étape 5 et dans la règle générale de l'étape 7, et `writing-a-batch` à trois — chaque passage qui écrivait le geste devient une invocation, et l'abandon sur une contrainte ou un ADR intenable s'appuie comme avant sur la règle générale de l'étape 7 — si c'est faux, un agent arrêté sur une contrainte ne trouve l'invocation qu'en lisant l'étape 7.

Ruling: la ligne `Red Flags` « The story is abandoned, the branch can stay » quitte `writing-a-user-story` pour `abandoning-a-story` — l'excuse porte sur le geste, et une garde interdit désormais sa réponse hors de la skill qui le porte — si c'est faux, un agent qui n'invoque pas la skill ne lit plus cette réponse.

Ruling: une garde négative interdit le geste d'abandon dans toute skill déclarée autre que `abandoning-a-story`, en plus des deux gardes que `Technical design` demande — sans elle, une appelante qui regagnerait une copie laisserait toutes les gardes vertes — si c'est faux, une skill future qui parle légitimement de supprimer une branche de story devra reformuler ou la garde s'affiner.

Ruling: les commits des trois tâches sont fondus en un seul avant l'ouverture de la pull request — une story livre une idée, et le commit de la deuxième tâche laissait rouge le contrat `shared` que la troisième remplace — si c'est faux, le détail par tâche n'est plus lisible dans l'historique.

## Observed drift
