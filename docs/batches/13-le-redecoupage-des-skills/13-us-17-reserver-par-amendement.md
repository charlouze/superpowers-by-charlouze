# La réservation par amendement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Un amendement qui ajoute une entrée du gaps register à `Scope` la réserve dans sa pull request.

**Architecture:** `amending-a-batch` invoque `writing-in-a-gaps-register` pour réserver l'entrée qu'un amendement ajoute à `Scope`, et lui passe le `NN` du lot. Les skills qui disaient qu'une réservation vient de la pull request d'ouverture ne le disent plus.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** Module > The gaps register
**Blocks:** none

Cette story n'est pas technique : son premier commit supprime l'entrée du gaps register qu'elle résorbe, et une story technique ne retire rien.

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

### Authority rule

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

### Stop condition on a constraint or an ADR

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

### ADRs

> The code this story writes holds these ADRs.

- `docs/adr/une-skill-par-moment-d-invocation.md`

### Decisions worth an ADR

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

- Une skill est entièrement en anglais, et ne cite aucune section de `docs/specs/supercharlouze.md`.
- Une section qu'une skill nomme entre parenthèses est l'une des siennes.
- Un `SKILL.md` garde des fins de ligne LF.
- Une garde de `tests/` est écrite avant le texte qu'elle tient, et l'exécutant montre son échec avant de l'écrire.
- Toute commande `git` qui écrit un commit ou parle au remote passe par `bash ~/.config/github-app/as-agent.sh git …`.
- Un commit se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et par aucune autre ligne d'attribution.
- Une correction d'un commit de cette branche est un `fixup!` de ce commit.
- L'outil Bash de ce poste mange les barres obliques inverses dans les heredocs et dans les `sed` en ligne : un fichier qui en contient s'écrit avec l'outil d'écriture ou d'édition de fichiers.
- La skill `supercharlouze:following-the-rules` n'existe pas dans la version installée du plugin : ne tente pas de l'invoquer, ce plan porte les règles qui valent ici.
- La suite se lance par `bash tests/run-all.sh`, dure environ trois minutes et demande un délai de cinq minutes.

## Review Focus

Aucun : la story change le texte de skills, que les gardes de `tests/` lisent en entier, et aucune entrée ne leur échappe.

---

### Task 1: Faire réserver par l'amendement l'entrée qu'il ajoute à `Scope`

**Files:**
- Modify: `tests/test-skill-contracts.sh` (commentaire et gardes des appelantes de `writing-in-a-gaps-register`)
- Modify: `tests/test-skill-content.sh` (après la garde « an amendment releases what it drops »)
- Modify: `skills/amending-a-batch/SKILL.md` (sections `The Document` et `Red Flags`)

**Interfaces:**
- Consumes: le geste `Reserve` de `skills/writing-in-a-gaps-register/SKILL.md`, qui attend de l'appelante le numéro du lot.
- Produces: rien qu'une autre tâche lise.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-contracts.sh`, remplace dans le commentaire

```
# `making-a-bounded-change` carries the bounded change, `opening-a-batch` reserves, `amending-a-batch`
# releases, `delivering-a-story` removes the entry its story resolves.
```

par

```
# `making-a-bounded-change` carries the bounded change, `opening-a-batch` reserves, `amending-a-batch`
# reserves and releases, `delivering-a-story` removes the entry its story resolves.
```

Dans le même fichier, remplace

```bash
require amending-a-batch "an amendment invokes the release" \
    "releases its reservation in the same pull request: invoke \`supercharlouze:writing-in-a-gaps-register\` before releasing it"
```

par

```bash
require amending-a-batch "an amendment invokes the reservation with its number" \
    "reserves it in the same pull request: invoke \`supercharlouze:writing-in-a-gaps-register\` before reserving it, and give it this batch's \`NN\`"
require amending-a-batch "an amendment invokes the release with its number" \
    "releases its reservation in the same pull request: invoke \`supercharlouze:writing-in-a-gaps-register\` before releasing it, and give it this batch's \`NN\`"
```

Dans `tests/test-skill-content.sh`, ajoute sous la ligne `require amending-a-batch "an amendment releases what it drops" …` :

```bash
require amending-a-batch "an amendment reserves what it adds" "An amendment that adds a gaps register entry to \`Scope\` reserves it in the same pull request"
require amending-a-batch "an entry without its annotation reads as free" "An entry taken on without its annotation still reads as free, and another batch can reserve it too."
require amending-a-batch "red flag: a reservation is not an opening ceremony" "| \"Reservations are posted at opening, this amendment only edits \`Scope\`\" | A batch reserves every entry it takes on, whenever it takes it on. Reserve in this pull request the entry the amendment adds, or another batch can reserve it too. |"
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-contracts.sh 2>&1 | grep FAIL ; bash tests/test-skill-content.sh 2>&1 | grep FAIL`
Expected: cinq lignes `[FAIL]`, celles des cinq gardes ci-dessus, et aucune autre.

- [ ] **Step 3: Écrire le texte de la skill**

Dans `skills/amending-a-batch/SKILL.md`, section `The Document`, remplace

```markdown
An amendment that takes a gaps register entry out of `Scope` releases its
reservation in the same pull request: invoke
`supercharlouze:writing-in-a-gaps-register` before releasing it.
```

par

```markdown
An amendment that adds a gaps register entry to `Scope` reserves it in the same
pull request: invoke `supercharlouze:writing-in-a-gaps-register` before
reserving it, and give it this batch's `NN`. An entry taken on without its
annotation still reads as free, and another batch can reserve it too.

An amendment that takes a gaps register entry out of `Scope` releases its
reservation in the same pull request: invoke
`supercharlouze:writing-in-a-gaps-register` before releasing it, and give it
this batch's `NN`.
```

Dans la table `Red Flags` de la même skill, ajoute après la ligne « The scope changed, I'll slip the edit… » :

```markdown
| "Reservations are posted at opening, this amendment only edits `Scope`" | A batch reserves every entry it takes on, whenever it takes it on. Reserve in this pull request the entry the amendment adds, or another batch can reserve it too. |
```

- [ ] **Step 4: Vérifier que la suite passe**

Run: `bash tests/run-all.sh 2>&1 | tail -5`
Expected: aucune ligne `[FAIL]`, et le total des assertions passe de 1431 à 1435.

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-contracts.sh tests/test-skill-content.sh skills/amending-a-batch/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -F <fichier de message>
```

Message :

```
feat: un amendement réserve l'entrée du gaps register qu'il ajoute à Scope

`amending-a-batch` invoque `writing-in-a-gaps-register` pour réserver
l'entrée, et lui passe le `NN` du lot à la réservation comme à la
libération.

Co-Authored-By: Charlouze <me@charlouze.com>
```

### Task 2: Ne plus dire qu'une réservation vient de la seule ouverture

**Files:**
- Modify: `tests/test-skill-contracts.sh` (après la garde « no skill merely revises reservations »)
- Modify: `tests/test-skill-content.sh` (après la garde « an amendment's release is the one exception »)
- Modify: `skills/closing-a-batch/SKILL.md` (`Overview` et `Release unconsumed reservations`)
- Modify: `skills/delivering-a-story/SKILL.md` (paragraphe « To abandon a story… »)
- Modify: `skills/abandoning-a-story/SKILL.md` (paragraphe « Change nothing on `main`. »)
- Modify: `skills/opening-a-batch/SKILL.md` (paragraphe « Reserving gaps-register entries »)

**Interfaces:**
- Consumes: rien.
- Produces: rien qu'une autre tâche lise.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-contracts.sh`, ajoute sous la garde `absent_everywhere "no skill merely revises reservations" …` (ses deux lignes) :

```bash

# A batch reserves an entry at its opening or by an amendment: no skill says a
# reservation comes from the opening alone.
absent_everywhere "no skill ties a reservation to the opening alone" \
    "reserved at opening|Reservation is a property of the opening pull request|reservation posted by the batch's opening pull request|by the batch's own opening pull request|put there by the batch's opening pull request,|it got there when the batch's opening pull request merged"
```

Dans `tests/test-skill-content.sh`, ajoute sous la ligne `require closing-a-batch "an amendment's release is the one exception" …` :

```bash
require closing-a-batch "closing releases whatever the batch reserved" "For every gaps register entry this batch reserved (\`reserved by batch-NN\`) that is still in the file, release it."
require closing-a-batch "what an abandonment leaves came from the opening or an amendment" "put there by the batch's opening pull request or by one of its amendments: the gaps register entry the batch reserved"
require abandoning-a-story "what stays on main came from the opening or an amendment" "were put there by the batch's opening pull request or by one of its amendments, and abandoning a story leaves them as they are."
require delivering-a-story "an abandonment leaves closing the reservation the batch posted" "and the gaps register reservation the batch posted, unless an amendment took its entry out of \`Scope\` and released it"
require opening-a-batch "whatever batch takes an entry on reserves it" "**Whatever batch takes an entry on** reserves it, so that two batches cannot draw the same entry."
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-contracts.sh 2>&1 | grep FAIL ; bash tests/test-skill-content.sh 2>&1 | grep FAIL`
Expected: six lignes `[FAIL]`, celles des six gardes ci-dessus ; la première nomme `abandoning-a-story`, `closing-a-batch`, `delivering-a-story` et `opening-a-batch`.

- [ ] **Step 3: Écrire le texte des skills**

Dans `skills/closing-a-batch/SKILL.md`, chaque paragraphe tient sur une ligne. Remplace dans `Overview`

```
put there by the batch's own opening pull request: the gaps register entry the batch reserved
```

par

```
put there by the batch's opening pull request or by one of its amendments: the gaps register entry the batch reserved
```

Dans la section `Release unconsumed reservations` de la même skill, remplace

```
For every gaps register entry this batch reserved at opening (`reserved by batch-NN`) that is still in the file, release it.
```

par

```
For every gaps register entry this batch reserved (`reserved by batch-NN`) that is still in the file, release it.
```

et remplace

```
The reservation lives on `main` — it got there when the batch's opening pull request merged — and abandoning a story touches nothing on `main`.
```

par

```
The reservation lives on `main`, and abandoning a story touches nothing on `main`.
```

Dans `skills/delivering-a-story/SKILL.md`, remplace

```markdown
delivered, and the gaps register reservation posted by the batch's opening pull
request, unless an amendment took its entry out of `Scope` and released it. Do
not count them — a story that transcribed no block announced nothing in the spec
delta and leaves the reservation alone.
```

par

```markdown
delivered, and the gaps register reservation the batch posted, unless an
amendment took its entry out of `Scope` and released it. Do not count them — a
story that transcribed no block announced nothing in the spec delta and leaves
the reservation alone.
```

Dans `skills/abandoning-a-story/SKILL.md`, remplace

```markdown
Change nothing on `main`. The gaps register reservations and the blocks the
batch announced were put there by the batch's opening pull request, and
abandoning a story leaves them as they are.
```

par

```markdown
Change nothing on `main`. The gaps register reservations and the blocks the
batch announced were put there by the batch's opening pull request or by one of
its amendments, and abandoning a story leaves them as they are.
```

Dans `skills/opening-a-batch/SKILL.md`, remplace

```markdown
Reservation is a property of the opening pull request of **whatever batch takes
an entry on**, and it exists so that two batches cannot draw the same entry. So:
```

par

```markdown
**Whatever batch takes an entry on** reserves it, so that two batches cannot
draw the same entry. So:
```

Le reste de ce paragraphe ne change pas.

- [ ] **Step 4: Vérifier que la suite passe**

Run: `bash tests/run-all.sh 2>&1 | tail -5`
Expected: aucune ligne `[FAIL]`, et le total des assertions passe de 1435 à 1441.

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-contracts.sh tests/test-skill-content.sh skills/closing-a-batch/SKILL.md skills/delivering-a-story/SKILL.md skills/abandoning-a-story/SKILL.md skills/opening-a-batch/SKILL.md
bash ~/.config/github-app/as-agent.sh git commit -F <fichier de message>
```

Message :

```
feat: la clôture libère ce que le lot a réservé, à l'ouverture ou par amendement

`closing-a-batch`, `delivering-a-story`, `abandoning-a-story` et
`opening-a-batch` ne disent plus qu'une réservation vient de la seule
pull request d'ouverture.

Co-Authored-By: Charlouze <me@charlouze.com>
```

## Rulings log

## Observed drift
