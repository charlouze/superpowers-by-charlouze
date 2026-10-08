# L'extraction de detecting-concurrency Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La skill interne `detecting-concurrency` porte la détection de concurrence, et les skills qui la conduisaient l'invoquent à la place de leur copie.

**Architecture:** `detecting-concurrency` reçoit la spec, les sections et, quand elle existe, la branche du travail, qu'elle écarte de sa lecture. Elle fetch, lit les déclarations des travaux en vol sur le remote, et rend les conflits et les déclarations illisibles. `writing-a-user-story` l'invoque à son étape 1 et `using-batches` pour le changement borné ; chacune lui passe ce qui varie et garde l'arrêt. `following-the-rules` garde la définition d'un conflit et de ce qu'un travail déclare. Les gardes du texte suivent le texte, et chaque contrat `shared` qui exigeait des copies devient une garde sur `detecting-concurrency` et une garde sur chaque skill qui l'invoque.

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

When the batch and the spec contradict each other, the spec wins — without
exception and without deliberation. Implement what the spec says, record a
`Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
agent's.

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

### Le dépôt

Une extraction reprend le comportement que la branche porte : elle déplace un
texte et ne change aucune règle.

Aucune tâche n'écrit qu'un travail qui va toucher une section de plus refait la
détection : la story qui transcrit ce bloc du lot le porte. Ce que `using-batches`
dit d'une déclaration qui change avant l'ouverture de la pull request est repris
tel quel.

Une skill est écrite en anglais, se termine par des fins de ligne LF et suit les
règles d'écriture du `CLAUDE.md` du dépôt.

Une skill ne cite aucune section de `docs/specs/supercharlouze.md`.

`following-the-rules` ne nomme aucune skill.

Une garde déplacée garde son aiguille ; aucune garde n'est supprimée sans une
garde qui la remplace.

Toute commande `git` qui écrit un commit ou parle au remote passe par
`bash ~/.config/github-app/as-agent.sh git …`.

Un commit se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et par
aucune autre ligne d'attribution.

Un script, une regex ou un fichier s'écrit avec l'outil d'écriture ou d'édition
de fichiers, jamais par un heredoc ni par `sed -i` : le shell du poste mange les
barres obliques inverses. Le poste n'a ni `python` ni `node`.

La suite se lance par `bash tests/run-all.sh` et dure environ deux minutes. Un
seul fichier se lance par `bash tests/<fichier>.sh`.

## Review Focus

- Une skill qui détectait la concurrence et n'invoque plus rien : un changement
  borné ou une story part alors sans détection. La garde de la tâche 2 cherche
  l'invocation dans `writing-a-user-story` et dans `using-batches`.
- Une skill appelante qui invoque sans s'arrêter sur ce qui est rendu : la
  détection ne retient plus rien. La garde de la tâche 2 cherche l'arrêt dans les
  deux skills.
- Une copie du déroulé qui survit hors de `detecting-concurrency` : la garde
  négative de la tâche 2 parcourt toutes les skills déclarées.
- `detecting-concurrency` qui nomme une skill qui l'invoque, ou une étape
  numérotée de l'une d'elles : la garde de la tâche 1 lit les skills d'entrée dans
  `tests/skills.txt`.
- Un renvoi `Step 1` resté dans une skill après la disparition du déroulé qu'il
  visait : la tâche 2 le cherche par `grep`.

---

### Task 1: `detecting-concurrency` porte la détection de concurrence

**Files:**
- Create: `skills/detecting-concurrency/SKILL.md`
- Modify: `tests/skills.txt`
- Modify: `tests/test-skill-content.sh` (après la garde « writing-in-a-gaps-register names no skill that invokes it »)
- Modify: `tests/test-cross-references.sh` (après le bloc `GROW`)
- Modify: `README.md` (tableau des skills)

**Interfaces:**
- Consumes: `require`, `absent`, `declared_skills` de `tests/lib.sh` ; la variable `entry_names` que `tests/test-skill-content.sh` définit déjà.
- Produces: la skill `supercharlouze:detecting-concurrency`, que la tâche 2 fait invoquer. Elle reçoit la spec, les sections et, quand elle existe, la branche du travail ; elle rend les conflits et les déclarations illisibles.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/skills.txt`, ajouter après la ligne `writing-in-a-gaps-register internal` :

```
detecting-concurrency internal
```

Dans `tests/test-skill-content.sh`, juste après la ligne
`absent "writing-in-a-gaps-register names no skill that invokes it" "${entry_names%|}" writing-in-a-gaps-register`,
ajouter :

```bash

# --- detecting-concurrency: the scan (spec section "Concurrency detection") ---
require detecting-concurrency "says what the invoking skill passes" \
    "The skill that invokes it gives the spec the work targets, the sections it will touch and, when the work already has one, its branch."
require detecting-concurrency "fetches first" "git fetch origin"
require detecting-concurrency "leaves the work's own branch out" \
    "When the work has a branch, leave that branch and its pull request out of everything below."
require detecting-concurrency "the concurrency filter is the branch name" "filter is the branch name"
require detecting-concurrency "a declaration names its spec as well" "\`Spec:\` names the spec"
require detecting-concurrency "a bounded change names both in its body" "names both in the body of its pull request"
require detecting-concurrency "a branch with no declaration yet is read by what it changed" \
    "A pushed branch that carries no declaration yet is read by the sections it has already changed"
require detecting-concurrency "both claiming patterns are read before their pull request" \
    "every remote \`story/*\` or \`bounded/*\` branch that carries no pull request yet"
require detecting-concurrency "returns each conflict with who holds it" \
    "**Each conflict:** the section, and the pull request or the branch that holds it."
require detecting-concurrency "returns each declaration it could not read" \
    "**Each declaration you could not read:** the pull request or the branch, and why"
require detecting-concurrency "an unread declaration is no pass" "An unread declaration is an unknown, not a pass."
require detecting-concurrency "names its blind spot" "Name the blind spot rather than trusting the net."
require detecting-concurrency "sections are declared, not derived" "Sections are declared, not derived"
require detecting-concurrency "git conflict is only a partial net" "partial safety net"
require detecting-concurrency "says when to go back to the step that invoked it" \
    "Once you have them, go on with the step that invoked this skill."
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them.
absent "detecting-concurrency names no skill that invokes it" "${entry_names%|}|Step [0-9]" detecting-concurrency
```

Dans `tests/test-cross-references.sh`, juste après le bloc `case "$GROW" in … esac`
qui se termine par « rules out direct use », ajouter :

```bash

# The README row of detecting-concurrency, like the other internal skills',
# says it is not for direct use and names none of the skills that invoke it.
CROW="$(grep -F '`supercharlouze:detecting-concurrency`' "$REPO_ROOT/README.md" || true)"
case "$CROW" in
    *"using-batches"*|*"writing-a-user-story"*|*"invoked by"*)
        fail "the README row of detecting-concurrency names no caller" ;;
    *)  pass "the README row of detecting-concurrency names no caller" ;;
esac
case "$CROW" in
    *"Never directly"*) pass "the README row of detecting-concurrency rules out direct use" ;;
    *)                  fail "the README row of detecting-concurrency rules out direct use" ;;
esac
```

- [ ] **Step 2: Lancer les gardes et les voir échouer**

Run: `bash tests/test-skill-content.sh 2>&1 | grep FAIL ; bash tests/test-cross-references.sh 2>&1 | grep FAIL ; bash tests/test-skill-frontmatter.sh 2>&1 | grep FAIL`
Expected: un `[FAIL]` par garde `detecting-concurrency:` ajoutée, « the README row of detecting-concurrency rules out direct use », et l'échec de la forme interne ou du répertoire manquant. Garde cette sortie pour ton rapport.

- [ ] **Step 3: Écrire la skill**

Créer `skills/detecting-concurrency/SKILL.md` avec exactement ce contenu, en fins de ligne LF :

````markdown
---
name: detecting-concurrency
description: Use only when a skill tells you to invoke detecting-concurrency, never on a request to check who else is working on a spec - scans the work in flight on the remote for the sections a piece of work will touch, and returns the conflicts and the declarations it could not read
user-invocable: false
---

# Detecting Concurrency

## Overview

This skill checks that nobody else holds the sections a piece of work will
touch. `Authority and Conflict Rules` in `supercharlouze:following-the-rules`
says what a conflict is and what each claimant declares.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the detecting-concurrency skill to check who else holds these sections."

The skill that invokes it gives the spec the work targets, the sections it will
touch and, when the work already has one, its branch.

It returns the conflicts and the declarations it could not read
(`What It Returns`). Once you have them, go on with the step that invoked this
skill.

## The Scan

Fetch first: the work in flight arrives from the remote, and a scan of a stale
state answers about a state that is already behind.

```bash
git fetch origin
```

When the work has a branch, leave that branch and its pull request out of
everything below.

1. **List the open pull requests together with their head ref**, and keep those
   whose branch is `story/*` or `bounded/*`. Bare `gh pr list` does not print the
   head ref, so ask for it explicitly:

   ```bash
   gh pr list --state open --limit 100 --json number,headRefName
   gh pr view <n> --json number,headRefName   # one pull request at a time
   ```

   **The filter is the branch name, not the files the pull request touches.**
   Only those branches claim sections, so the head ref
   answers on its own — nothing to fetch and no file to read. And a pull request
   that touches no spec at all still holds its sections: a corrective story's
   first commit deletes a gaps register entry, so a filter on the spec file made
   it invisible to every sibling for its whole life.

2. **For each of those, read its declaration — wherever that pull request
   keeps it.** A story keeps it in its story document, which lives on the
   *other* pull request's head branch and not in your worktree, so read it at
   the head ref: `Spec:` names the spec, `Sections:` the sections. A **bounded
   change** (`bounded/<slug>`) has no story document at all: it names both in the
   body of its pull request, so read the body. Look in the place that kind of
   pull request actually uses — demanding a story document from a bounded
   change would find nothing, and "nothing found" is an unknown
   (`What It Returns`), so every piece of work would stop for as long as any
   bounded pull request stayed open. That is a false stop, and a false stop jams
   the nominal path instead of protecting it.

   ```bash
   gh api "repos/{owner}/{repo}/contents/<path>?ref=<headRefName>" --jq .content | base64 -d
   git fetch origin <headRefName> && git show FETCH_HEAD:<path>   # local alternative
   gh pr view <n> --json body --jq .body                          # bounded change: bounded/<slug>
   ```

   **A declaration naming a spec other than the work's holds nothing against
   it.** The branch name says who claims sections; the declaration says in which
   spec. That is why the filter of point 1 can be as wide as it is — it lets in
   every claimant, and the declaration sorts them.

3. **Read the same declaration on every remote `story/*` or `bounded/*` branch
   that carries no pull request yet.** A story's pull request opens only at the
   end of its implementation, so a sibling holds its sections for that whole
   stretch without appearing in point 1 above. Its branch, however, is on the
   remote from its very first commit, so the remote sees it:

   ```bash
   git ls-remote --heads origin 'story/*' 'bounded/*'
   git show origin/<branch>:docs/batches/NN-<slug>/NN-us-N-<slug>.md
   git diff -U0 origin/main...origin/<branch> -- docs/specs/<module>.md   # no declaration yet
   ```

   Skip the branches already covered by a pull request in point 1.

   A pushed branch that carries no declaration yet is read by the sections it
   has already changed. That is a story branch between its spec commit and its
   plan commit, or a bounded change before its pull request opens. Diff it
   against `main` on the work's spec file, and take as claimed every section a
   hunk touches, named by the heading path it falls under in the branch's
   version, or in `main`'s for a removed section. A branch that changed nothing
   in that spec file claims nothing against the work.
4. Intersect all of those with the sections the work will touch.

## What It Returns

- **Each conflict:** the section, and the pull request or the branch that holds
  it.
- **Each declaration you could not read:** the pull request or the branch, and
  why: fetch failed, story document without its `Sections:` field, pull request
  body silent on a bounded change.

**An unread declaration is an unknown, not a pass.** Silently treating it as
empty turns the one real net into "found nothing". A pushed branch that has not
declared yet is not an unknown: point 3 reads it by what it changed. Nor is a
bounded change having no story document: its declaration is in its pull request
body, read per point 2.

## What the Scan Does Not See

**Name the blind spot rather than trusting the net.** What this scan sees is
what is on the remote: open pull requests, and pushed `story/*` and `bounded/*`
branches. A piece of work that has created its branch but not yet pushed it is
invisible to every sibling, and no amount of care here finds it. Read the scan
as complete for work already on the remote, and as blind to everything else.

Sections are declared, not derived, wherever a declaration exists: reading a
diff to guess which sections a story touches is fragile, whereas the story's
author knows them. The diff stands in only for a pushed branch that has not
declared yet, and it shows only what that branch has already changed.

Do not fall back on git. A merge conflict is only a **partial safety net** —
git conflicts on lines, not on sections, so two stories editing the same
section in distant places merge cleanly. Relying on it lets through exactly the
case this scan exists to catch.

## Red Flags

| Thought | Reality |
|---------|---------|
| "No merge conflict, so no one else is on this section" | Git conflicts on lines, not sections; two edits far apart in one section merge cleanly. Read the declarations. |
| "No open pull request touches this spec, so the section is free" | The filter is the branch name, not the files: a pull request that touches no spec holds its sections all the same. And a story holds them from its first commit until its pull request opens — read the pushed `story/*` and `bounded/*` branches too. |
| "This pull request has no story document, so its declaration cannot be read" | Not if it is a `bounded/<slug>`: a bounded change declares its sections in its pull request body. Read it there. Returning it as unread would halt every piece of work for as long as one bounded pull request stays open. |
````

Dans `README.md`, ajouter après la ligne du tableau qui commence par
`` | `supercharlouze:writing-in-a-gaps-register` | `` :

```markdown
| `supercharlouze:detecting-concurrency` | Never directly — a building block the other skills invoke to check that nobody else holds the sections a piece of work will touch |
```

- [ ] **Step 4: Lancer la suite et la voir verte**

Run: `bash tests/run-all.sh 2>&1 | grep -E 'FAIL|all tests passed'`
Expected: `all tests passed`, aucun `[FAIL]`. Si une garde négative qui parcourt toutes les skills échoue sur `detecting-concurrency`, arrête-toi et rapporte-la : le texte de la skill ne se retouche pas sans le dire.

Vérifier les fins de ligne : `grep -c $'\r' skills/detecting-concurrency/SKILL.md` rend `0`.

- [ ] **Step 5: Commit**

```bash
git add skills/detecting-concurrency tests/skills.txt tests/test-skill-content.sh tests/test-cross-references.sh README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la skill interne detecting-concurrency porte la détection de concurrence" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: les skills qui détectaient la concurrence invoquent `detecting-concurrency`

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (étape 1, renvois à `Step 1`, `Red Flags`)
- Modify: `skills/using-batches/SKILL.md` (règle (b) du changement borné)
- Modify: `skills/following-the-rules/SKILL.md` (`Authority and Conflict Rules`, `Red Flags`)
- Modify: `skills/writing-a-batch/SKILL.md` (`Allocating NN`)
- Modify: `tests/test-skill-contracts.sh` (lignes 31 à 66, commentaire vers la ligne 517)
- Modify: `tests/test-skill-content.sh` (gardes de `writing-a-user-story` vers les lignes 598 à 600 et 766)

**Interfaces:**
- Consumes: la skill `supercharlouze:detecting-concurrency` de la tâche 1 et ses gardes ; `require`, `absent`, `absent_everywhere`, `declared_skills` de `tests/lib.sh`.
- Produces: rien qu'une tâche suivante consomme.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-contracts.sh`, remplacer tout le passage qui va du
commentaire `# The concurrency scan's filter is the branch name, and both ends must spell it`
jusqu'à la fin de la garde `absent "a branch with no declaration yet is not an unknown" …`
(ses trois lignes comprises) par :

```bash
# The concurrency scan lives in one place, `detecting-concurrency`. A skill
# whose work claims sections invokes it, passes what varies and stops on what it
# returns: `writing-a-user-story` for a story, `using-batches` for the bounded
# change.
require writing-a-user-story "a story invokes detecting-concurrency with its spec and its sections" \
    "invoke \`supercharlouze:detecting-concurrency\` and give it the story's spec and those sections"
require using-batches "a bounded change invokes detecting-concurrency before creating its branch" \
    "Invoke \`supercharlouze:detecting-concurrency\` before creating \`bounded/<slug>\`, and give it that spec and those sections"
require using-batches "a redone detection receives the branch" \
    "invoke it again, and give it \`bounded/<slug>\` as well"
for s in writing-a-user-story using-batches; do
    require "$s" "stops on what detecting-concurrency returns" \
        "Stop if it returns a conflict or a declaration it could not read"
done
# What it carries is spelled there and nowhere else. Walks the declared skills,
# so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the concurrency scan" \
    "filter is the branch name|carries no declaration yet|or .bounded/[*]. branch that carries no pull request yet|unread declaration is an unknown|Sections are declared, not derived|conflicts on lines, not|names both in the body of its pull request|Step 1 of .supercharlouze" \
    $(declared_skills | grep -vx detecting-concurrency)
# `following-the-rules` keeps what a conflict is and what a claimant declares.
require following-the-rules "a conflict is judged on a section of one spec" \
    "touching the same section of the same spec are a conflict"
require following-the-rules "each claimant declares its spec and its sections" \
    "Each claimant declares its spec and its sections"

# The former filter — keep only the pull requests and the branches whose diff
# touches the spec file — made invisible every story whose pull request touches
# no spec at all. It must survive nowhere, or the scan regains the blind spot
# this one closes.
absent_everywhere "no skill filters the concurrency scan by the spec file a diff touches" \
    "touches this story's spec file|touches this spec file|touch this spec file|files include this story's spec file"

# A branch that has not declared yet used to stop a story as soon as it had
# changed the story's spec file. The sections it changed now stand in for its
# declaration, so that stop must survive nowhere.
absent_everywhere "a branch with no declaration yet is not an unknown" \
    "concerns the spec it has already changed|it is an unknown and stops you|stop on an unknown"
```

Dans le même fichier, dans le commentaire au-dessus de la garde
« no skill says a bounded change declares only its sections », remplacer
`Step 1 of writing-a-user-story` par `detecting-concurrency`, en gardant le
commentaire lisible.

Dans `tests/test-skill-content.sh`, supprimer ces quatre gardes, que la tâche 1
a réécrites sur `detecting-concurrency` avec la même aiguille :

```bash
require writing-a-user-story "a declaration names its spec as well"  "\`Spec:\` names the spec"
require writing-a-user-story "a bounded change names both in its body" "names both in the body of its pull request"
require writing-a-user-story "git conflict is only a partial net" "partial safety net"
require writing-a-user-story "sections are declared, not derived"   "Sections are declared, not derived"
```

- [ ] **Step 2: Lancer les gardes et les voir échouer**

Run: `bash tests/test-skill-contracts.sh 2>&1 | grep FAIL`
Expected: les quatre gardes d'invocation et d'arrêt échouent, et « no other skill restates the concurrency scan » échoue en nommant `following-the-rules` et `writing-a-user-story`. Garde cette sortie pour ton rapport.

- [ ] **Step 3: Réécrire l'étape 1 de `writing-a-user-story`**

Dans `skills/writing-a-user-story/SKILL.md`, remplacer tout le corps de
`## Step 1 — Detect Concurrency`, du premier paragraphe jusqu'à la ligne qui
précède `## Step 2 — Allocate us-N and Create the Branch`, par :

```markdown
Decide which sections this story will touch, then invoke
`supercharlouze:detecting-concurrency` and give it the story's spec and those
sections.

**Stop if it returns a conflict or a declaration it could not read.** Report
what it returned, and let your human partner sequence the two pieces of work or
decide on the unread declaration.
```

Le titre `## Step 1 — Detect Concurrency` reste, et les autres étapes gardent
leur numéro.

Puis, dans le même fichier, réécrire chaque renvoi à l'ancien déroulé. Lis
chaque passage : un retour à la ligne peut couper la formule.

| Aujourd'hui | Devient |
|---|---|
| `The remote ones are the sources Step 1 reads` | `The remote ones are the sources the concurrency scan reads` |
| `The listing of `main` is the one Step 1 never reads` | ``The listing of `main` is the one that scan never reads`` |
| `Step 1's third source and this step's allocation both read` | `The concurrency scan and this step's allocation both read` |
| `since a sibling running Step 1 reads pushed `story/*` branches` | ``since a sibling's concurrency scan reads pushed `story/*` branches`` |
| `shrinks the blind spot named in Step 1 from` | `shrinks the blind spot of that scan from` |
| `is what the *next* story's Step 1 reads` | `is what the *next* story's concurrency scan reads` |
| `a sibling's Step 1 reads this branch only by` | `a sibling's concurrency scan reads this branch only by` |
| `is exactly what every sibling's Step 1 reads as a live claim` | `is exactly what every sibling's concurrency scan reads as a live claim` |

Dans la table `Red Flags` du même fichier, supprimer ces trois lignes, que
`detecting-concurrency` porte :

- celle qui commence par `| "No merge conflict, so no one else is on this section" |` ;
- celle qui commence par `| "No open pull request touches this spec, so the section is free" |` ;
- celle qui commence par `| "This pull request has no story document, so I must stop" |`.

Run: `grep -n 'Step 1' skills/writing-a-user-story/SKILL.md`
Expected: une seule ligne, le titre `## Step 1 — Detect Concurrency`.

- [ ] **Step 4: Réécrire la règle (b) de `using-batches`**

Dans `skills/using-batches/SKILL.md`, la règle (b) tient en trois paragraphes.
Remplacer ces trois paragraphes par les deux ci-dessous, en gardant
l'indentation de deux espaces du second et la ligne vide avant `- **(c)` :

```markdown
- **(b) It undergoes the same concurrency detection as a story**, and therefore declares in the body of its pull request **the spec it targets and the sections it touches**, `none` when it touches none — otherwise it would hit a story in flight through a back door. The spec is named because nothing else in the declaration says which document those section titles belong to, and a bounded change that updates no spec file leaves a reader nothing to infer it from; two identically titled sections in two different specs are not a conflict. And `none` is a declaration, not a blank: it is what a bounded change that changes nothing observable has to say, where a blank body is indistinguishable from one nobody filled in — which is an unknown, and an unknown stops the reader. Invoke `supercharlouze:detecting-concurrency` before creating `bounded/<slug>`, and give it that spec and those sections. Stop if it returns a conflict or a declaration it could not read: report what it returned, and let your human partner sequence the two pieces of work or decide on the unread declaration.

  **A declaration that changes before the pull request opens redoes the detection:** invoke it again, and give it `bounded/<slug>` as well. The detection answered about the sections declared when it ran, so a section added afterwards was never intersected against anything — not found free, simply never looked at. Redoing it costs one scan, and the opening is the last point where the widening is still cheap to undo.
```

Ce qui disparaît : la phrase « Run **Step 1 of …** … cannot be read. », la
phrase « Symmetrically, … stays open. », et le paragraphe « Before its pull
request opens, a bounded change's branch carries no declaration … does not
carry. ». `detecting-concurrency` dit où se lit la déclaration d'un changement
borné et comment se lit une branche qui n'a pas encore déclaré.

- [ ] **Step 5: Réduire `following-the-rules` à la définition**

Dans `skills/following-the-rules/SKILL.md`, sous `## Authority and Conflict Rules`,
remplacer les trois paragraphes qui vont de `**Concurrency.**` à
`…so two stories editing the same section far apart merge cleanly.` par :

```markdown
**Concurrency.** Two stories, or a story and a bounded change, touching the same section of the same spec are a conflict. Only `story/*` and `bounded/*` branches claim sections.

Each claimant declares its spec and its sections: a story in its story document, where `Spec:` names the spec and `Sections:` the sections; a bounded change in its pull request body.
```

Dans la table `Red Flags` du même fichier, supprimer la ligne qui commence par
`| "Git will conflict if two stories touch the same section" |`.

N'ajoute aucun nom de skill dans ce fichier.

- [ ] **Step 6: Mettre à jour `writing-a-batch`**

Dans `skills/writing-a-batch/SKILL.md`, sous `## Allocating NN`, remplacer

```markdown
concurrency scan of `supercharlouze:writing-a-user-story`** — read it as one
```

par

```markdown
scan of `supercharlouze:detecting-concurrency`** — read it as one
```

et remettre le paragraphe à la largeur de ses voisins si la ligne devient trop
courte.

- [ ] **Step 7: Lancer la suite et la voir verte**

Run: `bash tests/run-all.sh 2>&1 | grep -E 'FAIL|all tests passed'`
Expected: `all tests passed`, aucun `[FAIL]`.

Si « no other skill restates the concurrency scan » nomme encore une skill,
cherche l'aiguille dans cette skill et retire la copie ; si le passage n'est pas
une copie du déroulé, arrête-toi et rapporte-le.

Run: `grep -rn 'Step 1 of\|Step 1 answered' skills/`
Expected: aucune ligne.

Run: `grep -rnoE '\(`[A-Z][A-Za-z ]+`\)' skills/*/SKILL.md`
Expected: seules des sections de la skill qui les nomme, dont `What It Returns` dans `detecting-concurrency`.

- [ ] **Step 8: Commit**

```bash
git add skills tests
bash ~/.config/github-app/as-agent.sh git commit -m "feat: les skills qui détectaient la concurrence invoquent detecting-concurrency" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

## Observed drift
