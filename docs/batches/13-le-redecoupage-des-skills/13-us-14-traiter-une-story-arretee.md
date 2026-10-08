# 13-us-14 — Traiter une story arrêtée

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extraire dans la skill d'entrée `handling-a-stopped-story` ce qui suit le déclenchement d'une condition d'arrêt, sans changer le comportement que la branche d'en dessous porte.

**Architecture:** `handling-a-stopped-story` reçoit de `amending-a-batch` les deux requalifications, la contrainte intenable et leurs red flags, et de `using-batches` et `writing-a-user-story` la suite d'une condition d'arrêt, ADR intenable compris. `amending-a-batch` garde la conduite de l'amendement, `using-batches` et `writing-a-user-story` routent vers la skill neuve. Les gardes suivent chaque texte dans la skill qui le porte.

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

Cette story reprend le comportement que la branche d'en dessous porte. Deux
changements que le lot annonce n'entrent pas ici, et aucune tâche ne les écrit :

- la story technique reste abandonnée dès l'arrêt : la phrase « Close its pull
  request without merging it if one is already open; the branch and its worktree
  stay until the choice below is ruled. » se déplace telle quelle ;
- aucune skill ne demande de vider le contexte ni ne donne de prompt après
  l'abandon d'une story arrêtée.

### Working rules

- Toute commande `git` qui écrit un commit ou parle au remote passe par
  `bash ~/.config/github-app/as-agent.sh git …`, `commit --amend`, `rebase` et
  `cherry-pick` compris.
- Un commit se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et par
  aucune autre ligne d'attribution.
- Les `SKILL.md` gardent des fins de ligne LF.
- Écris les fichiers avec l'outil d'écriture ou d'édition de fichiers : l'outil
  Bash de ce poste mange les barres obliques inverses dans les heredocs et les
  `sed` en ligne. Le poste n'a ni `python` ni `node`.
- La suite entière se lance par `bash tests/run-all.sh`, prend environ trois
  minutes, et demande un délai de cinq minutes.
- `SKILLS_DIR=<copie de skills/> bash tests/test-skill-content.sh` fait tourner
  les gardes sur un autre jeu de skills, pour montrer une étape rouge après coup.
- Une skill est entièrement en anglais, et ne cite aucune section de
  `docs/specs/supercharlouze.md`.

## Review Focus

- Un texte déplacé qui a changé de sens en route : chaque phrase gardée par une
  aiguille se retrouve mot pour mot dans la skill qui la porte désormais.
- Une copie restée derrière : `amending-a-batch`, `using-batches` et
  `writing-a-user-story` ne disent plus rien de la décision ni de l'abandon.
- Un changement de D1 ou de D4 entré par mégarde : pas d'abandon retardé de la
  story technique, pas de demande de vider le contexte, pas de prompt.
- Une garde perdue : toute garde supprimée tenait un texte supprimé, et toute
  garde d'un texte déplacé existe sur la skill qui le porte.
- Un renvoi cassé : chaque titre de section que le tableau d'entrée ou une
  phrase de `handling-a-stopped-story` nomme est un titre de cette skill.

---

### Task 1: La skill `handling-a-stopped-story`

**Files:**
- Create: `skills/handling-a-stopped-story/SKILL.md`
- Modify: `tests/skills.txt`
- Modify: `README.md` (tableau des skills)
- Modify: `tests/test-skill-content.sh`
- Modify: `tests/test-skill-contracts.sh`
- Modify: `tests/test-cross-references.sh`
- Modify: `tests/test-technical-reader-prompt.sh`

**Interfaces:**
- Produces: la skill `supercharlouze:handling-a-stopped-story`, déclarée `entry`, avec les sections `Requalifying a Corrective Batch`, `Requalifying a Technical Story`, `A Constraint or an ADR a Story Cannot Hold`, `What the Ruling Asks For` et `Red Flags`. Les tâches 2 et 3 retirent des autres skills les textes qu'elle porte et y écrivent son nom.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, juste avant la ligne
`# --- writing-a-batch-document: the batch document contract (spec section "The batch document") ---`,
insérer ce bloc :

```bash
# --- handling-a-stopped-story: what follows a stop condition ---
require handling-a-stopped-story "the story stays, the human rules, the story is abandoned or resumes" \
    "The story stays as it stands, your human partner rules between the options of that condition, then the story is abandoned or resumes."
require handling-a-stopped-story "the foundation states the conditions" \
    "\`Stop Conditions\` in \`supercharlouze:following-the-rules\` states each of them."
require handling-a-stopped-story "the entry point of a corrective batch names its section" \
    "| A corrective batch that turned out not to be corrective | Requalifying a Corrective Batch |"
require handling-a-stopped-story "the entry point of a technical story names its section" \
    "| A technical story that turned out to change something observable | Requalifying a Technical Story |"
require handling-a-stopped-story "the entry point of a constraint or an ADR names its section" \
    "| A story stopped on a constraint of its batch or an ADR it cannot hold | A Constraint or an ADR a Story Cannot Hold |"
require handling-a-stopped-story "requalifies a corrective batch" \
    "## Requalifying a Corrective Batch"
require handling-a-stopped-story "a corrective story is abandoned once ruled" "1. **Leave the story as it stands until the choice below is ruled, then abandon it.**"
require handling-a-stopped-story "an open pull request waits for the ruling" "A pull request already open stays open until then."
require handling-a-stopped-story "a corrective story goes through abandoning-a-story once ruled" "Once the choice is ruled, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch"
require handling-a-stopped-story "requalification offers a different batch" "**Rule the remaining work a different batch**"
require handling-a-stopped-story "requalification releases what the batch drops" "3. **Release the reservations of the entries the batch no longer takes on.**"
require handling-a-stopped-story "the substance of a requalification is the human's" \
    "Never carry out a requalification by deciding the substance yourself."
require handling-a-stopped-story "requalifies a technical story" \
    "## Requalifying a Technical Story"
require handling-a-stopped-story "a technical story's pull request is closed at the stop" "Close its pull request without merging it if one is already open; the branch and its worktree stay until the choice below is ruled."
require handling-a-stopped-story "a technical story goes through abandoning-a-story once ruled" "Once it is ruled, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch"
require handling-a-stopped-story "an observable change needs a block" \
    "it needs a block, and a block is acquired by an amendment that goes back through the opening review"
require handling-a-stopped-story "an unwanted change amends nothing" \
    "If the human judges the observable change unwanted instead, there is nothing to amend: the story is abandoned and the batch carries on as it was."
require handling-a-stopped-story "the human rules on a constraint or an ADR a story cannot hold" \
    "**When a story stops on a constraint or an ADR it cannot hold, your human partner rules on the constraint or the ADR.**"
require handling-a-stopped-story "the condition leaves the branch as it is" \
    "Until then the branch and the worktree stay as they are."
require handling-a-stopped-story "an untenable constraint or ADR abandons the story" \
    "If they rule it untenable, the story is abandoned: invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch."
require handling-a-stopped-story "what holds resumes the story" \
    "Otherwise the story resumes and holds the constraint or the ADR, and nothing is amended."
require handling-a-stopped-story "the next steps are taken in order, each with its skill" \
    "Take them in the order their row gives, each with the skill that conducts it:"
require handling-a-stopped-story "a corrected spec comes with a reduced scope" \
    "| The spec is corrected, and the batch stays corrective on a reduced scope | The corrected spec ships through its own pull request, and \`supercharlouze:amending-a-batch\` reduces the \`Scope\`. |"
require handling-a-stopped-story "a rewritten batch goes to an amendment" \
    "| The corrective batch is rewritten as an ordinary batch | \`supercharlouze:amending-a-batch\` rewrites it. |"
require handling-a-stopped-story "a different batch closes this one first" \
    "| The remaining work is a different batch | \`supercharlouze:closing-a-batch\` closes this batch, then \`supercharlouze:opening-a-batch\` opens the fresh one. |"
require handling-a-stopped-story "a wanted change goes to an amendment, then to an ordinary story" \
    "| The observable change of a technical story is wanted | \`supercharlouze:amending-a-batch\` adds its block. Once that pull request merges, \`supercharlouze:writing-a-user-story\` rewrites the work as an ordinary story of the amended batch. |"
require handling-a-stopped-story "an untenable constraint goes to an amendment" \
    "| A constraint is untenable | \`supercharlouze:amending-a-batch\` changes or removes it. |"
require handling-a-stopped-story "an untenable ADR goes to a bounded change" \
    "| An ADR is untenable | A bounded change, under \`supercharlouze:using-batches\`, rewrites or deletes it. |"
require handling-a-stopped-story "red flag: only the human corrects a spec" \
    "| \"The spec is wrong here, I'll fix it and keep the batch corrective\" | Only the human corrects a spec. Stop the story, present the requalification choice. |"
require handling-a-stopped-story "red flag: requalification does not start by closing" "| \"Requalification starts by closing the story's pull request\" | Override 2 fires mid-SDD, usually before any pull request exists. Close it only if it is already open. |"
require handling-a-stopped-story "the red flag keeps the ruling with the human" "Whether a constraint can be held is your human partner's ruling."
```

Dans `tests/test-skill-contracts.sh`, ajouter `handling-a-stopped-story` à la
fin de la liste de skills de ces deux gardes, dont voici l'intitulé :

- `absent "no skill closes a corrective story's pull request at the stop"` : la
  liste devient
  `using-batches following-the-rules opening-a-batch amending-a-batch writing-a-user-story recording-a-decision handling-a-stopped-story` ;
- `absent "no skill counts the stop conditions the flow adds"` : la liste devient
  `using-batches following-the-rules writing-a-user-story opening-a-batch amending-a-batch recording-a-decision handling-a-stopped-story`.

Dans la même file, dans la garde
`absent "the technical reread names no skill that invokes it"`, insérer
`handling-a-stopped-story|` juste avant `writing-a-user-story|` dans
l'expression.

Dans `tests/test-technical-reader-prompt.sh`, dans le `case "$FLAT"` que précède
le commentaire `# The prompt names no skill of the plugin.`, insérer
`*"handling-a-stopped-story"*|` juste avant `*"writing-a-user-story"*|`.

Dans `tests/test-cross-references.sh`, dans le `case "$AROW"` de la garde
« the README row of abandoning-a-story names no caller », insérer
`*"handling-a-stopped-story"*|` juste avant `*"writing-a-user-story"*|`. Puis,
juste après le `esac` qui ferme la garde « the README row of abandoning-a-story
rules out direct use », insérer :

```bash

# The README row of handling-a-stopped-story says when the skill is used.
HROW="$(grep -F '`supercharlouze:handling-a-stopped-story`' "$REPO_ROOT/README.md" || true)"
case "$HROW" in
    *"A story has stopped on a stop condition the flow adds"*)
        pass "the README row of handling-a-stopped-story says when it is used" ;;
    *)  fail "the README row of handling-a-stopped-story says when it is used" ;;
esac
```

- [ ] **Step 2: Montrer le rouge**

Run: `bash tests/test-skill-content.sh 2>&1 | grep -c 'FAIL.*handling-a-stopped-story'` puis `bash tests/test-cross-references.sh 2>&1 | grep handling-a-stopped-story`
Expected: les gardes `handling-a-stopped-story` échouent, la skill et sa ligne du `README` n'existant pas. Rapporte le nombre d'échecs.

- [ ] **Step 3: Déclarer la skill**

Dans `tests/skills.txt`, insérer la ligne `handling-a-stopped-story entry` juste
après la ligne `amending-a-batch entry`.

Dans `README.md`, insérer cette ligne du tableau des skills juste après celle de
`supercharlouze:amending-a-batch` :

```markdown
| `supercharlouze:handling-a-stopped-story` | A story has stopped on a stop condition the flow adds |
```

- [ ] **Step 4: Écrire la skill**

Créer `skills/handling-a-stopped-story/SKILL.md`, fins de ligne LF, avec
exactement ce contenu :

````markdown
---
name: handling-a-stopped-story
description: Use when a story has stopped on a stop condition this flow adds - a corrective batch whose spec is wrong, a technical story that changes something observable, a constraint or an ADR that cannot be held - keeps the story as it stands, puts the choice to your human partner, then abandons the story or resumes it
---

# Handling a Stopped Story

## Overview

A story that stops on one of the stop conditions this flow adds settles nothing
by itself. The story stays as it stands, your human partner rules between the
options of that condition, then the story is abandoned or resumes.

**Announce at start:** "I'm using the handling-a-stopped-story skill to handle this stopped story."

**Start by invoking `supercharlouze:following-the-rules`, unless this session already has.**

`Stop Conditions` in `supercharlouze:following-the-rules` states each of them.

| Entry point | Section |
|---|---|
| A corrective batch that turned out not to be corrective | Requalifying a Corrective Batch |
| A technical story that turned out to change something observable | Requalifying a Technical Story |
| A story stopped on a constraint of its batch or an ADR it cannot hold | A Constraint or an ADR a Story Cannot Hold |

Once the story is abandoned, `What the Ruling Asks For` says what comes next.

## Requalifying a Corrective Batch

**Trigger — Override 2, the stop condition proper to a corrective batch.** This
plugin adds stop conditions to `superpowers:subagent-driven-development`, and
this is the corrective one: while
bringing code into conformance with a spec, if a story discovers that the
**spec** is wrong and the code is right, it stops. The batch is no longer
corrective and must be requalified. The four native stop conditions assume a
valid authority exists; here the authority itself is in question, and no agent
may correct a spec.

**Procedure.**

1. **Leave the story as it stands until the choice below is ruled, then abandon
   it.** A pull request already open stays open until then. Once the choice is
   ruled, invoke `supercharlouze:abandoning-a-story` and give it the story's
   branch.
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
3. **Release the reservations of the entries the batch no longer takes on.** A
   reduced or rewritten scope releases them in the amendment pull request that
   changes `Scope`. A batch closed in favour of a fresh one releases them at its
   closing, before the fresh batch reserves them at its own opening: two batches
   never reserve the same entry.

Never carry out a requalification by deciding the substance yourself. Correcting
a spec is a human act, never an agent act. Your job is to present the choice with
its consequences, then execute what is ruled.

## Requalifying a Technical Story

**Trigger — the stop condition of a technical story.** `supercharlouze:following-the-rules`
states it and `supercharlouze:writing-a-user-story` copies it into the
`Global Constraints` of every technical story: a story that discovers it changes
something observable at its module's boundary is no longer technical. It reaches
you already stopped, from inside `superpowers:subagent-driven-development`.

**Procedure.**

1. **Abandon the story.** Close its pull request without merging it if one is
   already open; the branch and its worktree stay until the choice below is
   ruled. Once it is ruled, invoke `supercharlouze:abandoning-a-story` and give
   it the story's branch.
2. **Put the choice to the human**, who alone may rule. If they judge the
   observable change wanted, it needs a block, and a block is acquired by an
   amendment that goes back through the opening review — the exact text of a block
   is what that review reads, and a story that transcribes none never passes it.

If the human judges the observable change unwanted instead, there is nothing to
amend: the story is abandoned and the batch carries on as it was.

## A Constraint or an ADR a Story Cannot Hold

**When a story stops on a constraint or an ADR it cannot hold, your human
partner rules on the constraint or the ADR.** Until then the branch and the
worktree stay as they are.

If they rule it untenable, the story is abandoned: invoke
`supercharlouze:abandoning-a-story` and give it the story's branch.

Otherwise the story resumes and holds the constraint or the ADR, and nothing is
amended.

## What the Ruling Asks For

A ruling that abandons the story may ask for next steps. Take them in the order
their row gives, each with the skill that conducts it:

| Ruling | Next steps |
|---|---|
| The spec is corrected, and the batch stays corrective on a reduced scope | The corrected spec ships through its own pull request, and `supercharlouze:amending-a-batch` reduces the `Scope`. |
| The corrective batch is rewritten as an ordinary batch | `supercharlouze:amending-a-batch` rewrites it. |
| The remaining work is a different batch | `supercharlouze:closing-a-batch` closes this batch, then `supercharlouze:opening-a-batch` opens the fresh one. |
| The observable change of a technical story is wanted | `supercharlouze:amending-a-batch` adds its block. Once that pull request merges, `supercharlouze:writing-a-user-story` rewrites the work as an ordinary story of the amended batch. |
| A constraint is untenable | `supercharlouze:amending-a-batch` changes or removes it. |
| An ADR is untenable | A bounded change, under `supercharlouze:using-batches`, rewrites or deletes it. |

## Red Flags

| Thought | Reality |
|---------|---------|
| "The spec is wrong here, I'll fix it and keep the batch corrective" | Only the human corrects a spec. Stop the story, present the requalification choice. |
| "Requalification starts by closing the story's pull request" | Override 2 fires mid-SDD, usually before any pull request exists. Close it only if it is already open. |
| "The story is right, this constraint cannot be held, I'll amend it" | Whether a constraint can be held is your human partner's ruling. Put it to them: the amendment follows a ruling of untenable, and the story resumes on any other. |
````

- [ ] **Step 5: Montrer le vert**

Run: `bash tests/run-all.sh` (délai de cinq minutes)
Expected: aucune ligne `FAIL`. Une garde qui parcourt toutes les skills déclarées
peut échouer sur un texte de la skill neuve : rapporte-la avec son intitulé et
l'aiguille en cause, sans réécrire la skill ni la garde, et attends.

- [ ] **Step 6: Commit**

```bash
git add skills/handling-a-stopped-story tests README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la skill d'entrée handling-a-stopped-story conduit ce qui suit une condition d'arrêt

Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: `amending-a-batch` ne garde que l'amendement

**Files:**
- Modify: `skills/amending-a-batch/SKILL.md`
- Modify: `README.md` (ligne de `amending-a-batch`)
- Modify: `tests/test-skill-content.sh`
- Modify: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la skill `supercharlouze:handling-a-stopped-story` de la tâche 1, qui porte déjà chaque texte que cette tâche retire.
- Produces: `amending-a-batch` sans section `A Constraint a Story Cannot Hold`, `Requalifying a Corrective Batch` ni `Requalifying a Technical Story`.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, supprimer chaque garde `require
amending-a-batch` dont l'intitulé est l'un de ceux-ci :

- "the entry point names the design and the constraints"
- "the human rules on a constraint a story cannot hold"
- "an untenable constraint is amended"
- "a story abandoned on a constraint goes through abandoning-a-story"
- "a constraint that holds resumes the story"
- "the red flag keeps the ruling with the human"
- "requalification offers a different batch"
- "requalification releases what the batch drops"
- "a corrective story is abandoned once ruled"
- "an open pull request waits for the ruling"
- "a corrective story goes through abandoning-a-story once ruled"
- "a technical story's pull request is closed at the stop"
- "a technical story goes through abandoning-a-story once ruled"
- "red flag: requalification does not start by closing"
- "carries the requalification procedure"
- "requalifies a technical story" (deux lignes)
- "an observable change needs a block" (deux lignes)

Supprimer aussi le bloc entier `# --- amending-a-batch: what the skill routes ---`
avec ses deux gardes, et la ligne vide qui le suit.

Remplacer la garde "the amendment declares the flag the block requires" par :

```bash
require amending-a-batch "the amendment declares the flag the block requires" \
    "An amendment that adds the block of an observable change a technical story revealed declares the flag that block requires, if it requires one."
```

Juste après la garde "the exemption question is asked again", ajouter :

```bash
require amending-a-batch "a stopped story is ruled on before it is amended for" \
    "**When a story has stopped and nothing is ruled yet, go to \`supercharlouze:handling-a-stopped-story\` first**"
```

Dans `tests/test-skill-contracts.sh`, la boucle de la garde "invokes
abandoning-a-story with the story's branch" devient
`for s in handling-a-stopped-story writing-a-user-story; do`.

Dans la même file, juste après la garde
`absent "the opening carries no amendment and no requalification"` et sa liste,
ajouter :

```bash

# What follows a stop condition is conducted in one place,
# `handling-a-stopped-story`. The skill that amends a batch abandons no story
# and puts no choice to the human.
absent "the amendment carries no handling of a stopped story" \
    "abandoning-a-story|Put the choice to the human|[Rr]equalifying|rules on the constraint" \
    amending-a-batch
```

- [ ] **Step 2: Montrer le rouge**

Run: `bash tests/test-skill-content.sh 2>&1 | grep FAIL; bash tests/test-skill-contracts.sh 2>&1 | grep FAIL`
Expected: trois échecs, "the amendment declares the flag the block requires", "a stopped story is ruled on before it is amended for" et "the amendment carries no handling of a stopped story".

- [ ] **Step 3: Réécrire `amending-a-batch`**

Dans `skills/amending-a-batch/SKILL.md` :

1. La ligne `description:` devient :

   ```
   description: Use when an open batch must change its scope, its spec delta, its technical design, its constraints or its flag - amends the batch document and opens the amendment pull request, reviewed like the others
   ```

2. Supprimer le tableau `| Entry point | Section |` en entier, ses six lignes,
   et une des deux lignes vides qui l'entourent.

3. À la fin de la section `What an Amendment Is For`, après le paragraphe
   « A change that touches nothing but ADRs is not an amendment… », ajouter ce
   paragraphe :

   ```markdown
   **When a story has stopped and nothing is ruled yet, go to
   `supercharlouze:handling-a-stopped-story` first**: an amendment follows your
   human partner's ruling, and never stands in for it.
   ```

4. À la fin de la section `The Document`, ajouter ce paragraphe :

   ```markdown
   An amendment that adds the block of an observable change a technical story
   revealed declares the flag that block requires, if it requires one. Ask the
   exemption criterion again of the batch with its new block: would one story,
   merged alone, leave a user facing something incomplete? The exemption drawn
   from all stories being technical no longer holds, so the answer alone
   decides.
   ```

5. Supprimer en entier les sections `## A Constraint a Story Cannot Hold`,
   `## Requalifying a Corrective Batch` et `## Requalifying a Technical Story` :
   `## Red Flags` suit alors la section `## The Pull Request`.

6. Dans `## Red Flags`, supprimer les trois lignes dont la pensée est
   "The spec is wrong here, I'll fix it and keep the batch corrective",
   "Requalification starts by closing the story's pull request" et
   "The story is right, this constraint cannot be held, I'll amend it".

Dans `README.md`, la ligne de `amending-a-batch` devient :

```markdown
| `supercharlouze:amending-a-batch` | Amending an open batch |
```

- [ ] **Step 4: Montrer le vert**

Run: `bash tests/run-all.sh` (délai de cinq minutes)
Expected: aucune ligne `FAIL`.

- [ ] **Step 5: Commit**

```bash
git add skills/amending-a-batch tests README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: amending-a-batch ne garde que l'amendement

Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 3: `using-batches` et `writing-a-user-story` routent vers la skill

**Files:**
- Modify: `skills/using-batches/SKILL.md`
- Modify: `skills/writing-a-user-story/SKILL.md`
- Modify: `tests/test-skill-content.sh`
- Modify: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la skill `supercharlouze:handling-a-stopped-story` de la tâche 1.
- Produces: rien qu'une tâche ultérieure consomme.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh` :

1. Remplacer le commentaire
   `# Both requalifications live in amending-a-batch; using-batches only routes to it.`
   et la garde "the corrective and the technical conditions route to
   amending-a-batch" qui le suit par :

   ```bash
   # What follows a stop lives in handling-a-stopped-story; using-batches only routes to it.
   require using-batches "a fired stop condition routes to handling-a-stopped-story" "When one of them fires, you stop, and \`supercharlouze:handling-a-stopped-story\` conducts what follows."
   require using-batches "the routing table leads to handling-a-stopped-story" "| A story has stopped on a stop condition this flow adds | \`supercharlouze:handling-a-stopped-story\` |"
   require using-batches "the routing table leads an amendment to amending-a-batch" "| A batch must change its scope, its spec delta, its technical design, its constraints or its flag | \`supercharlouze:amending-a-batch\` |"
   ```

2. Remplacer la garde "the technical condition hands off to amending-a-batch",
   le commentaire de deux lignes « A corrective story is abandoned once the
   requalification is ruled… » et la garde "a corrective story is abandoned once
   ruled" de `writing-a-user-story` par :

   ```bash
   require writing-a-user-story "a fired stop condition routes to handling-a-stopped-story" \
       "**When one of them fires, stop: \`supercharlouze:handling-a-stopped-story\` conducts what follows.**"
   ```

3. Supprimer les gardes dont l'intitulé est l'un de ceux-ci :

   - `writing-a-user-story` "abandoning leaves the reservation to the amendment or closing"
   - `writing-a-user-story` "the condition leaves the branch as it is"
   - `writing-a-user-story` "an untenable ADR abandons the story"
   - `writing-a-user-story` "what holds resumes the story"
   - `writing-a-user-story` "a requalified story goes through abandoning-a-story once ruled"
   - `writing-a-user-story` "an untenable constraint abandons the story"
   - `using-batches` "the human rules on the constraint or the ADR"
   - `using-batches` "an untenable constraint goes to an amendment"
   - `using-batches` "an untenable ADR goes to a bounded change"
   - `using-batches` "what holds resumes the story"

Dans `tests/test-skill-contracts.sh`, remplacer le commentaire de deux lignes
« using-batches routes a requalification to amending-a-batch: … » par :

```bash
# using-batches routes a stopped story to handling-a-stopped-story: it neither
# opens on what a requalification does not do nor copies its procedure.
```

et, juste après la garde `absent "using-batches copies no requalification
procedure"` et sa liste, ajouter :

```bash

# What follows a stop is spelled in handling-a-stopped-story and nowhere else:
# a skill that routes to it says nothing of the ruling nor of the abandonment.
absent "no routing skill restates what follows a stop" \
    "conducts the requalification|rule a constraint untenable|rule an ADR untenable|requalification is ruled|decision goes to|or a corrective batch must be requalified" \
    using-batches writing-a-user-story
```

- [ ] **Step 2: Montrer le rouge**

Run: `bash tests/test-skill-content.sh 2>&1 | grep FAIL; bash tests/test-skill-contracts.sh 2>&1 | grep FAIL`
Expected: cinq échecs, les quatre gardes de routage ajoutées, moins celle de la
ligne de `amending-a-batch` si elle passe déjà, et "no routing skill restates
what follows a stop". Rapporte la liste exacte.

- [ ] **Step 3: Réécrire `using-batches`**

Dans `skills/using-batches/SKILL.md` :

1. Dans la table `Route by situation`, la ligne « A batch must change its scope…,
   or a corrective batch must be requalified » est remplacée par ces deux
   lignes, dans cet ordre :

   ```markdown
   | A story has stopped on a stop condition this flow adds | `supercharlouze:handling-a-stopped-story` |
   | A batch must change its scope, its spec delta, its technical design, its constraints or its flag | `supercharlouze:amending-a-batch` |
   ```

2. Dans `### Override 2 — the stop conditions the flow adds`, les cinq
   paragraphes qui suivent le paragraphe `Justification:` (de « When the
   corrective or the technical condition fires… » à « Otherwise the story
   resumes and holds the constraint or the ADR. ») sont remplacés par ce seul
   paragraphe :

   ```markdown
   When one of them fires, you stop, and `supercharlouze:handling-a-stopped-story` conducts what follows.
   ```

- [ ] **Step 4: Réécrire `writing-a-user-story`**

Dans `skills/writing-a-user-story/SKILL.md`, section `## Step 5 — Execute` :

1. Le paragraphe qui commence par `**Override 2 — the stop conditions the flow
   adds.**` devient :

   ```markdown
   **Override 2 — the stop conditions the flow adds.** SDD states that four things
   stop you and only these. This plugin adds its own. **When one of them fires,
   stop: `supercharlouze:handling-a-stopped-story` conducts what follows.**
   ```

2. Les paragraphes « In a corrective batch: if, while bringing code into
   conformity… » et « In a technical story, whatever its batch: … » restent tels
   quels.

3. Supprimer les cinq paragraphes qui les suivent : « **Abandoning here does not
   start by closing a pull request…** », « In a corrective batch, the story is
   abandoned once the requalification is ruled… », « In a technical story, close
   the story's pull request… », « The reservation posted on `main`… » et « Once
   the requalification is ruled, invoke… ».

4. Le paragraphe « In a story whose batch declares constraints or whose
   `docs/adr/` carries an ADR: … » perd sa dernière phrase et devient :

   ```markdown
   In a story whose batch declares constraints or whose `docs/adr/` carries an ADR:
   if, while conducting it, you discover that a constraint of its batch or an ADR
   cannot be held, stop and put it to your human partner. A constraint the spec
   contradicts is not this case, since the spec wins.
   ```

5. Supprimer les trois paragraphes qui le suivent : « If they rule a constraint
   untenable… », « If they rule an ADR untenable… » et « Otherwise resume the
   story and hold the constraint or the ADR. ».

6. Le paragraphe « It is named as an override for the same reason as the other
   three… » et la suite restent tels quels.

- [ ] **Step 5: Montrer le vert**

Run: `bash tests/run-all.sh` (délai de cinq minutes)
Expected: aucune ligne `FAIL`.

- [ ] **Step 6: Commit**

```bash
git add skills/using-batches skills/writing-a-user-story tests
bash ~/.config/github-app/as-agent.sh git commit -m "feat: using-batches et writing-a-user-story mènent à handling-a-stopped-story

Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

## Observed drift
