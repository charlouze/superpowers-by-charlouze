# Amending a Batch Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extraire dans la skill d'entrée `amending-a-batch` la conduite d'un amendement, que `writing-a-batch` porte aujourd'hui, et renommer `writing-a-batch`, réduite à l'ouverture, en `opening-a-batch`.

**Architecture:** `amending-a-batch` est une skill d'entrée : elle porte ce qu'un amendement change, sa branche, l'écriture de ses ADR, les relectures qu'il doit, la libération des entrées du gaps register et la fin de sa revue, et invoque les mêmes skills internes que l'ouverture. Elle porte aussi les deux requalifications, jusqu'à la story qui extrait `handling-a-stopped-story`. `writing-a-batch`, réduite à l'ouverture, devient `opening-a-batch` dans un commit à lui, puis l'attribution de `NN` devient sa ref.

**Tech Stack:** Markdown pour les skills, Bash pour la suite de `tests/`.

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

### Rules of this repository

- Une skill est entièrement anglaise, et ne cite aucune section de `docs/specs/supercharlouze.md`.
- Une section qu'une skill nomme entre parenthèses est une de ses propres sections.
- Une extraction reprend le comportement que la branche porte : le texte déplacé l'est mot pour mot, sauf là où ce plan donne un texte neuf.
- Les documents sous `docs/` qui citent `writing-a-batch` ne sont pas réécrits.
- Toute commande `git` qui écrit un commit passe par `bash ~/.config/github-app/as-agent.sh git …`. Un commit se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et par aucune autre ligne d'attribution.
- Les `SKILL.md` gardent des fins de ligne LF.
- L'outil Bash de ce poste mange les barres obliques inverses dans les heredocs et dans les `sed` en ligne : un script ou une regex s'écrit dans un fichier, avec l'outil d'écriture de fichiers.
- La suite se lance par `bash tests/run-all.sh`, avec un délai de cinq minutes.

## Review Focus

- Une référence `supercharlouze:<nom>` laissée sur l'ancien nom ou sur la mauvaise skill : après la tâche 1, tout renvoi à un amendement ou à une requalification nomme `amending-a-batch`, et tout renvoi à une ouverture nomme la skill d'ouverture.
- Une garde de l'amendement restée sur la skill d'ouverture : elle échoue, ou pire, elle a été supprimée au lieu de suivre son texte.
- Un texte déplacé qui a perdu une phrase : `git diff` de la tâche 1 se lit section par section contre les lignes 221 à 367 de `skills/writing-a-batch/SKILL.md` d'avant.
- `writing-a-batch-document` touchée par le renommage : son nom ne change pas.
- Une parenthèse de section qui nomme une section d'une autre skill : `tests/test-cross-references.sh` échoue.

---

### Task 1: Extract `amending-a-batch`

**Files:**
- Create: `skills/amending-a-batch/SKILL.md`
- Modify: `skills/writing-a-batch/SKILL.md`, `skills/using-batches/SKILL.md`, `skills/writing-a-user-story/SKILL.md`, `skills/closing-a-batch/SKILL.md`, `README.md`
- Test: `tests/skills.txt`, `tests/test-skill-contracts.sh`, `tests/test-skill-content.sh`, `tests/test-cross-references.sh`, `tests/test-reader-prompt.sh`, `tests/test-technical-reader-prompt.sh`

**Interfaces:**
- Consumes: les skills internes `starting-a-branch`, `writing-a-batch-document`, `writing-in-a-gaps-register`, `applying-a-spec-delta`, `recording-a-decision`, `rereading-a-batch`, `abandoning-a-story`, `finishing-a-pr`, et le socle `following-the-rules`.
- Produces: la skill d'entrée `supercharlouze:amending-a-batch`, avec les sections `Overview`, `What an Amendment Is For`, `The Branch`, `The Document`, `The ADRs`, `The Rereads`, `The Pull Request`, `A Constraint a Story Cannot Hold`, `Requalifying a Corrective Batch`, `Requalifying a Technical Story`, `Red Flags`. `writing-a-batch` ne porte plus que l'ouverture.

Les numéros de ligne ci-dessous sont ceux des fichiers avant cette tâche.

- [ ] **Step 1: Declare the skill and move the guards (red)**

`tests/skills.txt` : ajouter la ligne `amending-a-batch entry` après `writing-a-batch entry`.

`tests/test-skill-content.sh` :

1. Ligne 14 (boucle « points at the concision rules ») : ajouter `amending-a-batch` après `writing-a-batch`. La ligne 9 ne change pas.
2. Sur ces lignes, remplacer le premier argument `writing-a-batch` par `amending-a-batch`, sans toucher au reste : 120, 124, 133, 134, 135, 136, 137, 138, 140, 142, 144, 146, 148, 149, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 163, 164, 169, 170, 171, 172, 173, 174, 177, 178, 179, 180, 182, 184, 186, 526.
3. Remplacer la ligne 147 par :

   ```bash
   require amending-a-batch "an amendment's body says what its rereads found" "The body of an amendment says what each of its rereads found, or that it found nothing."
   require amending-a-batch "an amendment's body says when there was nothing to reread" "When the technical reread returned that it had nothing to reread, the body says that instead."
   ```

4. Remplacer les lignes 150 et 151 par :

   ```bash
   require amending-a-batch "its ADRs come once the document is amended" "Do it once the document is amended."
   require amending-a-batch "its ADRs meet the pending blocks of the amended document" "Before writing or rewriting one, invoke \`supercharlouze:applying-a-spec-delta\` and give it the amended document and every block of it that no merged story has declared yet: it returns the copies of the specs, blocks applied."
   require amending-a-batch "an amendment's ADR is confronted with the specs as the batch leaves them" "An ADR is confronted with the specs as the batch leaves them, and those blocks are in no spec yet."
   require amending-a-batch "an amendment's ADR is written by the shared skill" "Invoke \`supercharlouze:recording-a-decision\` for each ADR to write or to rewrite, and hand it those copies."
   require amending-a-batch "an amendment deletes an abandoned ADR" "Delete yourself each ADR your human partner abandoned, in a commit that says why."
   ```

5. Ligne 175 : le commentaire devient `# Both requalifications live in amending-a-batch; using-batches only routes to it.` Ligne 176 : dans le libellé et dans l'aiguille, `writing-a-batch` devient `amending-a-batch`.
6. Ligne 286-287 : l'aiguille devient `"The body of the pull request says what each reread found, or that it found nothing."`.
7. Ligne 572-573 : libellé `"the technical condition hands off to amending-a-batch"`, aiguille `"**the story is abandoned**, and the decision goes to \`supercharlouze:amending-a-batch\`"`.
8. Ligne 1319 : aiguille `"If they rule a constraint untenable, the story is abandoned and \`supercharlouze:amending-a-batch\` amends the constraint."`.
9. Ligne 1325 : aiguille `"If they rule a constraint untenable, the story is abandoned and \`supercharlouze:amending-a-batch\` amends the constraint."`.
10. Après la ligne 190, ajouter :

    ```bash
    # --- amending-a-batch: what the skill routes ---
    require amending-a-batch "the entry point of a constraint names its section" \
        "| A story stopped on a constraint of its batch it cannot hold | A Constraint a Story Cannot Hold |"
    require amending-a-batch "the entry point of a technical story names its section" \
        "| A technical story that turned out to change something observable | Requalifying a Technical Story |"
    ```

`tests/test-skill-contracts.sh` :

1. Ligne 18 : ajouter `amending-a-batch` à la boucle. Ligne 26 : premier argument `amending-a-batch`.
2. Ligne 123 : ajouter `amending-a-batch` à la boucle ; dans le commentaire au-dessus, `` `writing-a-batch` reserves and releases `` devient `` `writing-a-batch` reserves, `amending-a-batch` releases ``. Ligne 138 : premier argument `amending-a-batch`.
3. Lignes 306-307 : remplacer par

   ```bash
   for s in writing-a-batch amending-a-batch; do
       require "$s" "invokes writing-a-batch-document to write or amend the batch document" \
           "nvoke \`supercharlouze:writing-a-batch-document\` and give it"
   done
   ```

4. Ligne 318 : ajouter `amending-a-batch` à la boucle.
5. Ligne 368 : ajouter `amending-a-batch` à la liste.
6. Ligne 390 : dans l'aiguille, `supercharlouze:writing-a-batch` devient `supercharlouze:amending-a-batch`.
7. Ligne 454 : la boucle devient `for s in amending-a-batch writing-a-user-story; do`.
8. Ligne 468 : la boucle devient `for s in writing-a-batch amending-a-batch rereading-a-batch; do`.
9. Lignes 483-484 : remplacer par

   ```bash
   for s in writing-a-batch amending-a-batch; do
       require "$s" "invokes rereading-a-batch to have a batch reread" \
           "nvoke \`supercharlouze:rereading-a-batch\` and give it"
   done
   ```

10. Lignes 494, 631, 645, 654, 707, 727, 811, 817, 870, 877, 882, 889 : ajouter `amending-a-batch` juste après `writing-a-batch` dans la liste de skills.
11. Ligne 672 : `writing-a-batch` devient `amending-a-batch`.
12. Lignes 650, 856 et 909 : dans la regex, `writing-a-batch|` devient `writing-a-batch|amending-a-batch|`.
13. Lignes 729-730 : dans le commentaire, `writing-a-batch` devient `amending-a-batch`.
14. Après le bloc qui se termine ligne 494, ajouter :

    ```bash

    # An amendment and a requalification are conducted in one place,
    # `amending-a-batch`. The skill that opens a batch carries neither.
    absent "the opening carries no amendment and no requalification" \
        "amendment|[Rr]equalif" \
        writing-a-batch
    ```

`tests/test-cross-references.sh` : remplacer chaque `*"writing-a-batch"*|` par `*"writing-a-batch"*|*"amending-a-batch"*|` (dix occurrences).

`tests/test-reader-prompt.sh` ligne 29 : `for old in writing-a-batch amending-a-batch adopting-a-module; do`.

`tests/test-technical-reader-prompt.sh` ligne 95 : ajouter `*"amending-a-batch"*|` après `*"writing-a-batch"*|`.

- [ ] **Step 2: Run the suite to verify it fails**

Run: `bash tests/run-all.sh 2>&1 | grep FAIL`
Expected: des `[FAIL]` sur `amending-a-batch` (dont `amending-a-batch/SKILL.md exists`), sur `skills directory holds exactly the declared skills` et sur `the opening carries no amendment and no requalification`. Garde la sortie pour ton rapport.

- [ ] **Step 3: Write `skills/amending-a-batch/SKILL.md`**

Le fichier se compose ainsi. « Mot pour mot » renvoie aux lignes de `skills/writing-a-batch/SKILL.md` d'avant cette tâche.

````markdown
---
name: amending-a-batch
description: Use when an open batch must change its scope, its spec delta, its technical design, its constraints or its flag, or when a corrective batch or a technical story must be requalified - amends the batch document and opens the amendment pull request, reviewed like the others
---

# Amending a Batch

## Overview

The batch document carries no mutable state, but it stays amendable by an
**amendment pull request**, reviewed like the others. An amendment changes the
scope, the spec delta, the technical design, the constraints or the flag of an
open batch.

**Announce at start:** "I'm using the amending-a-batch skill to amend batch NN."

**Start by invoking `supercharlouze:following-the-rules`, unless this session already has.**

Every text this skill writes follows `Concision` in `supercharlouze:following-the-rules`.

| Entry point | Section |
|---|---|
| Changing the scope, the spec delta, the technical design, the constraints or the flag of an existing batch | What an Amendment Is For through The Pull Request |
| A story stopped on a constraint of its batch it cannot hold | A Constraint a Story Cannot Hold |
| A corrective batch that turned out not to be corrective | Requalifying a Corrective Batch |
| A technical story that turned out to change something observable | Requalifying a Technical Story |

## What an Amendment Is For

An amendment is the exit from these real dead ends:

<lignes 228 à 240, mot pour mot : les quatre puces, puis « Without this path none of them has an issue: … before closing. »>

A change that touches nothing but ADRs is not an amendment: it goes through a
bounded change, under `supercharlouze:using-batches`.

## The Branch

<lignes 242 à 249, mot pour mot : de « Do it on a branch whose name » à « give it the name you chose. »>

## The Document

To amend the document, invoke `supercharlouze:writing-a-batch-document` and give
it the batch document and what the amendment changes in it. An amendment is not
mutable state flowing along: it is an explicit human decision that goes through
a review.

An amendment that takes a gaps register entry out of `Scope` releases its
reservation in the same pull request: invoke
`supercharlouze:writing-in-a-gaps-register` before releasing it.

## The ADRs

An amendment's pull request may also write, rewrite or delete the ADRs your
human partner decided with the amendment. Do it once the document is amended.

Before writing or rewriting one, invoke `supercharlouze:applying-a-spec-delta`
and give it the amended document and every block of it that no merged story has
declared yet: it returns the copies of the specs, blocks applied. An ADR is
confronted with the specs as the batch leaves them, and those blocks are in no
spec yet.

Invoke `supercharlouze:recording-a-decision` for each ADR to write or to
rewrite, and hand it those copies.

Delete yourself each ADR your human partner abandoned, in a commit that says
why.

The pull request body states each ADR it writes, rewrites or deletes.

## The Rereads

<lignes 269 à 280, mot pour mot : de « An amendment that changes the spec delta, the technical design or the constraints » à « makes the amendment one that changes the spec delta. »>

The body of an amendment says what each of its rereads found, or that it found
nothing. When the technical reread returned that it had nothing to reread, the
body says that instead.

## The Pull Request

Say in the pull request body what changed and why.

By exception, an amendment that changes the spec delta is reviewed as an
opening. Its body states the exact text of every new or changed block, and what
the coherence reread found.

<lignes 295 à 298, mot pour mot : « **To end the review of an amendment, invoke … amended batch document.** »>

## A Constraint a Story Cannot Hold

<lignes 285 à 289, mot pour mot : « **When a story stops on a constraint it cannot hold, … and nothing is amended. »>

## Requalifying a Corrective Batch

<lignes 302 à 337, mot pour mot>

## Requalifying a Technical Story

<lignes 341 à 367, mot pour mot>

## Red Flags

| Thought | Reality |
|---------|---------|
<les lignes 388, 390, 391, 392, 393, 397 et 398, mot pour mot, dans cet ordre>
````

Les lignes entre chevrons sont des consignes, pas du texte : le fichier n'en garde aucune.

- [ ] **Step 4: Reduce `skills/writing-a-batch/SKILL.md` to the opening**

1. Ligne 3, la description devient : `description: Use when opening a batch of user stories - writes the batch document and opens the pull request whose review is the human gate`.
2. Supprimer les lignes 21 à 28 : la phrase « Three entry points, all landing in a pull request: », son tableau et la ligne vide qui le suit.
3. Lignes 181-182 : « The body of the pull request, opening or amendment, says what each reread found, or that it found nothing. » devient « The body of the pull request says what each reread found, or that it found nothing. »
4. Supprimer les lignes 221 à 368 : les sections `Amending a Batch`, `Requalifying a Corrective Batch` et `Requalifying a Technical Story`. `## Language` suit alors `## Opening the Pull Request`.
5. Supprimer du tableau `Red Flags` les lignes 388, 390, 391, 392, 393, 397 et 398.

- [ ] **Step 5: Point the other skills and the README at the new skill**

`skills/using-batches/SKILL.md` :

- ligne 23, la cellule de droite devient `` `supercharlouze:amending-a-batch` `` ;
- ligne 77 : `` `supercharlouze:writing-a-batch` conducts the requalification `` devient `` `supercharlouze:amending-a-batch` conducts the requalification `` ;
- ligne 81 devient : ``If they rule a constraint untenable, the story is abandoned and `supercharlouze:amending-a-batch` amends the constraint.``

`skills/writing-a-user-story/SKILL.md` : lignes 482 et 525, `supercharlouze:writing-a-batch` devient `supercharlouze:amending-a-batch`.

`skills/closing-a-batch/SKILL.md` :

- ligne 12 : `` which `supercharlouze:writing-a-batch` owns `` devient `` which `supercharlouze:amending-a-batch` owns `` ;
- ligne 54 : `` written with `supercharlouze:writing-a-batch` — its *Amending a Batch* section owns this path — and reviewed like any other `` devient `` written with `supercharlouze:amending-a-batch` and reviewed like any other ``.

`README.md`, tableau `Skills` : la ligne de `writing-a-batch` devient les deux lignes

```markdown
| `supercharlouze:writing-a-batch` | Opening a batch |
| `supercharlouze:amending-a-batch` | Amending an open batch, or requalifying a corrective batch or a technical story |
```

- [ ] **Step 6: Run the suite to verify it passes**

Run: `bash tests/run-all.sh 2>&1 | tail -3 ; bash tests/run-all.sh 2>&1 | grep -c '\[FAIL\]'`
Expected: `all tests passed`, zéro `[FAIL]`.

Un échec d'une garde négative (`present in: amending-a-batch`) sur un texte déplacé mot pour mot se rapporte, il ne se contourne pas en réécrivant le texte.

- [ ] **Step 7: Commit**

```bash
git add skills tests README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la skill d'entrée amending-a-batch conduit l'amendement d'un lot

Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: Rename `writing-a-batch` to `opening-a-batch`

**Files:**
- Rename: `skills/writing-a-batch/` → `skills/opening-a-batch/`
- Modify: `skills/opening-a-batch/SKILL.md`, `skills/using-batches/SKILL.md`, `skills/adopting-a-module/SKILL.md`, `README.md`
- Test: `tests/skills.txt`, tous les `tests/test-*.sh` qui citent le nom

**Interfaces:**
- Consumes: `skills/writing-a-batch/SKILL.md` tel que la tâche 1 le laisse.
- Produces: la skill d'entrée `supercharlouze:opening-a-batch`. `writing-a-batch-document` garde son nom.

- [ ] **Step 1: Write the guard on the former name (red)**

Dans `tests/test-cross-references.sh`, avant la ligne `exit $((FAILURES > 0))`, ajouter :

```bash
# 9. `writing-a-batch` was renamed `opening-a-batch`. The former name survives
#    in no skill, in no command and not in the README. `writing-a-batch-document`
#    is another skill, which the pattern lets through.
FORMER="$(grep -rnE 'writing-a-batch([^-]|$)' "$REPO_ROOT/skills" "$REPO_ROOT/commands" "$REPO_ROOT/README.md" 2>/dev/null | wc -l | tr -d ' ' || true)"
if [ "$FORMER" = "0" ]; then
    pass "no skill, no command and not the README names writing-a-batch"
else
    fail "no skill, no command and not the README names writing-a-batch ($FORMER found)"
fi
```

- [ ] **Step 2: Run it to verify it fails**

Run: `bash tests/test-cross-references.sh | grep 'names writing-a-batch'`
Expected: `[FAIL] no skill, no command and not the README names writing-a-batch (… found)`

- [ ] **Step 3: Rename**

```bash
bash ~/.config/github-app/as-agent.sh git mv skills/writing-a-batch skills/opening-a-batch
```

Écrire avec l'outil d'écriture de fichiers un script `sed`, hors du dépôt, de trois lignes :

```sed
s/writing-a-batch-document/WABD/g
s/writing-a-batch/opening-a-batch/g
s/WABD/writing-a-batch-document/g
```

L'appliquer par `sed -i -f <script>` à `README.md`, à `tests/skills.txt`, à chaque `tests/test-*.sh` et à chaque fichier de `skills/` qui contient `writing-a-batch`. Ne l'appliquer à rien sous `docs/`.

Puis, à la main :

1. `skills/opening-a-batch/SKILL.md` : le titre `# Writing a Batch` devient `# Opening a Batch`.
2. `tests/test-cross-references.sh` : le script a réécrit le nom chassé dans la garde ajoutée au Step 1. Remettre ce bloc tel que le Step 1 le donne.
3. `tests/test-cross-references.sh` : la garde de la ligne du `README` de `writing-a-batch-document` n'a plus à retirer le nom. Son commentaire perd sa dernière phrase (« Its own name starts with … before the row is read. ») et `case "${NROW//writing-a-batch-document/}" in` devient `case "$NROW" in`.
4. `tests/test-skill-content.sh` : la garde « writing-a-batch-document names no skill that invokes it » n'a plus à ouvrir sa regex. Supprimer la ligne `document_callers="$(…)"`, écrire la garde `absent "writing-a-batch-document names no skill that invokes it" "${entry_names%|}|Step [0-9]" writing-a-batch-document`, et réduire le commentaire au-dessus à ses deux premières phrases (« An internal skill names the skills it invokes, never those that invoke it, nor a numbered step of one of them. »).

- [ ] **Step 4: Run the suite to verify it passes**

Run: `bash tests/run-all.sh 2>&1 | tail -3 ; bash tests/run-all.sh 2>&1 | grep -c '\[FAIL\]'`
Expected: `all tests passed`, zéro `[FAIL]`.

Run: `grep -rnE 'writing-a-batch([^-]|$)' skills commands README.md CONTRIBUTING.md tests | grep -v 'test-cross-references.sh'`
Expected: aucune ligne.

- [ ] **Step 5: Commit**

```bash
git add -A skills tests README.md
bash ~/.config/github-app/as-agent.sh git commit -m "refactor: writing-a-batch devient opening-a-batch

Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 3: Move the allocation of `NN` into a reference

**Files:**
- Create: `skills/opening-a-batch/references/allocating-nn.md`
- Modify: `skills/opening-a-batch/SKILL.md`
- Test: `tests/test-skill-contracts.sh`, `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la section `Allocating NN` de `skills/opening-a-batch/SKILL.md`.
- Produces: la ref `skills/opening-a-batch/references/allocating-nn.md`, que seule `opening-a-batch` cite.

- [ ] **Step 1: Move the guards to the reference (red)**

Dans `tests/test-skill-contracts.sh`, la garde « allocation fetches before it reads the remote » de l'ouverture lit `skills/opening-a-batch/SKILL.md`. Elle lit désormais la ref, et le commentaire au-dessus devient :

```bash
# Allocation reads `origin/main` before the branch exists, so it fetches itself.
# The opening keeps its allocation in a reference, read at that step.
case "$(body_flat "$REPO_ROOT/skills/opening-a-batch/references/allocating-nn.md" 2>/dev/null || true)" in
    *"git fetch origin git ls-tree --name-only origin/main docs/batches/"*)
        pass "opening-a-batch: allocation fetches before it reads the remote" ;;
    *)  fail "opening-a-batch: allocation fetches before it reads the remote" ;;
esac
case "$(body_flat "$REPO_ROOT/skills/opening-a-batch/SKILL.md")" in
    *"git ls-tree"*|*"smallest integer"*)
        fail "opening-a-batch: the allocation is written in its reference alone" ;;
    *)  pass "opening-a-batch: the allocation is written in its reference alone" ;;
esac
require opening-a-batch "the opening allocates NN from its reference" \
    "Allocate \`NN\` as \`skills/opening-a-batch/references/allocating-nn.md\` says"
```

La garde de `writing-a-user-story` qui suit ne change pas.

- [ ] **Step 2: Run it to verify it fails**

Run: `bash tests/test-skill-contracts.sh | grep 'opening-a-batch: .*alloc'`
Expected: trois `[FAIL]`.

- [ ] **Step 3: Write the reference and reduce the section**

`skills/opening-a-batch/references/allocating-nn.md` : le titre `# Allocating NN`, une ligne vide, puis le texte de la section `Allocating NN` de `skills/opening-a-batch/SKILL.md`, mot pour mot, de « `NN` is the **smallest integer not used » à « a story branch is the sole trace of its batch. ». Fins de ligne LF.

Dans `skills/opening-a-batch/SKILL.md`, la section devient :

```markdown
## Allocating NN

Allocate `NN` as `skills/opening-a-batch/references/allocating-nn.md` says: it
fetches, then reads `main`, the open pull requests and the pushed branches.

The branch is `batch/NN-<slug>`. Path and branch patterns are English and fixed;
the slug follows the project's language, because it names a business object.

Invoke `supercharlouze:starting-a-branch` and give it the name `batch/NN-<slug>`.
```

- [ ] **Step 4: Run the suite to verify it passes**

Run: `bash tests/run-all.sh 2>&1 | tail -3 ; bash tests/run-all.sh 2>&1 | grep -c '\[FAIL\]'`
Expected: `all tests passed`, zéro `[FAIL]`.

- [ ] **Step 5: Commit**

```bash
git add skills tests
bash ~/.config/github-app/as-agent.sh git commit -m "refactor: l'attribution de NN devient une ref de opening-a-batch

Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

## Observed drift
