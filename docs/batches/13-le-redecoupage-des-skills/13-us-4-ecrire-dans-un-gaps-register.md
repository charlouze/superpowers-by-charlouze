# L'extraction de writing-in-a-gaps-register Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La skill interne `writing-in-a-gaps-register` porte la forme du gaps register, les règles d'une entrée et les gestes, et les skills qui écrivent dans un gaps register l'invoquent à la place de leur copie.

**Architecture:** `writing-in-a-gaps-register` reçoit de `adopting-a-module` la forme du gaps register et les règles d'une entrée, et de chaque skill qui en portait une copie le texte des gestes : ajouter, supprimer, réserver, libérer. `adopting-a-module`, `closing-a-batch`, `using-batches`, `writing-a-batch` et `writing-a-user-story` l'invoquent avant d'écrire dans un gaps register, et ne gardent que ce qui est propre à leur étape : quel geste, sur quelle entrée, à quel moment. Les gardes du texte suivent le texte, et chaque contrat `shared` qui exigeait des copies devient une garde sur `writing-in-a-gaps-register` et une garde sur chaque skill qui l'invoque.

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

Aucune tâche ne touche `docs/specs/supercharlouze.gaps.md`.

La violation que ce fichier porte sur `The gaps register` reste : aucune skill ne
fait réserver par un amendement une entrée qu'il ajoute à `Scope`.

Une skill est écrite en anglais, se termine par des fins de ligne LF et suit les
règles d'écriture du `CLAUDE.md` du dépôt.

Une skill ne cite aucune section de `docs/specs/supercharlouze.md`.

Une garde déplacée garde son aiguille ; aucune garde n'est supprimée sans une
garde qui la remplace.

Toute commande `git` qui écrit un commit ou parle au remote passe par
`bash ~/.config/github-app/as-agent.sh git …`.

Un commit se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et par
aucune autre ligne d'attribution.

Un script, une regex ou un fichier s'écrit avec l'outil d'écriture de fichiers,
jamais par un heredoc ni par `sed -i` : le shell du poste mange les barres
obliques inverses. Le poste n'a ni `python` ni `node`.

La suite se lance par `bash tests/run-all.sh` et dure environ deux minutes. Un
seul fichier se lance par `bash tests/<fichier>.sh`.

## Review Focus

- Une skill qui écrit dans un gaps register et n'invoque plus rien : un agent y
  écrit alors sans la forme ni les règles d'une entrée. La garde de la tâche 2
  cherche l'invocation dans chacune des cinq skills.
- Une copie d'une règle d'entrée ou d'un geste qui survit hors de
  `writing-in-a-gaps-register` : la garde négative de la tâche 2 parcourt toutes
  les skills déclarées.
- `writing-in-a-gaps-register` qui nomme une skill qui l'invoque : la garde de la
  tâche 1 cherche le nom de chaque skill d'entrée déclarée.
- Un texte qui ferait réserver une entrée par un amendement : la violation reste,
  et le geste `Reserve` ne dit pas quand il se fait.
- Une règle qui disparaît en route : chaque phrase retirée d'une skill se retrouve
  dans `writing-in-a-gaps-register`, ou reste dans la skill parce qu'elle dit son
  moment.
- Une fin de ligne CRLF dans le nouveau `SKILL.md` : la garde de forme interne
  échoue sur `user-invocable: false`.

---

### Task 1: `writing-in-a-gaps-register` porte la forme, les règles d'une entrée et les gestes

**Files:**
- Create: `skills/writing-in-a-gaps-register/SKILL.md`
- Modify: `tests/skills.txt`
- Modify: `tests/test-skill-content.sh`
- Modify: `tests/test-cross-references.sh`
- Modify: `README.md`

Les skills existantes ne changent pas dans cette tâche : elles gardent leurs
copies jusqu'à la tâche 2.

- [ ] **Step 1: Déclarer la skill**

Dans `tests/skills.txt`, ajouter après la ligne `writing-in-a-spec internal` :

```
writing-in-a-gaps-register internal
```

- [ ] **Step 2: Écrire les gardes de la skill**

Dans `tests/test-skill-content.sh`, juste après la garde
`absent "writing-in-a-spec names no skill that invokes it" …`, ajouter :

```bash

# --- writing-in-a-gaps-register: the register, an entry, the gestures (spec
# section "The gaps register") ---
require writing-in-a-gaps-register "carries the shape of the register"      "# <module> — Gaps register"
require writing-in-a-gaps-register "the categories are kept apart"          "kept apart because they are not treated the same way"
require writing-in-a-gaps-register "the register declares its coverage"     "declares its own coverage"
require writing-in-a-gaps-register "nothing stays once an entry is settled" "Nothing stays behind in this file once an entry is settled"
require writing-in-a-gaps-register "an entry designates a section"          "Each entry designates a section of the spec"
require writing-in-a-gaps-register "a gap entry names its source document"  "came from a document names that document"
require writing-in-a-gaps-register "the entry's shape is still stated without the word" \
    "one list item, never a paragraph of running prose"
require writing-in-a-gaps-register "carries the gestures"                   "## The Gestures"
require writing-in-a-gaps-register "an added entry goes to the end of its category" \
    "An entry is one list item, added at the end of its category"
require writing-in-a-gaps-register "the register's gestures include removal" "the commit that removes it says why"
require writing-in-a-gaps-register "a reservation annotates the entry"      "Append \`reserved by batch-NN\` to the entry"
require writing-in-a-gaps-register "two batches never reserve the same entry" "two batches never reserve the same entry"
require writing-in-a-gaps-register "releasing keeps the entry"              "removes the reservation annotation and leaves the entry"
require writing-in-a-gaps-register "red flag: prose instead of a list" \
    "| \"Prose reads better than a list in the gaps register\" | Then nothing can reserve, remove or release an entry"
require writing-in-a-gaps-register "red flag: an empty register says why it is empty" \
    "| \"The audit found nothing, so the register is empty\" | An empty register must say whether nothing was found or nothing was examined. |"
require writing-in-a-gaps-register "says what the invoking skill passes" \
    "The skill that invokes it says which gesture to make"
require writing-in-a-gaps-register "says when to go back to the step that invoked it" \
    "Once the register is written, go on with the step that invoked this skill."

# An internal skill names the skills it invokes, never those that invoke it.
# Walks the declared entry skills, so one declared later is covered.
absent "writing-in-a-gaps-register names no skill that invokes it" "${entry_names%|}" writing-in-a-gaps-register
```

Dans le même fichier, supprimer ces gardes, que les gardes ci-dessus remplacent
sur la skill qui porte désormais le texte :

- `require adopting-a-module "the register declares its coverage"   "declares its own coverage"`
- `require adopting-a-module "a gap entry names its source document"   "came from a document names that document"`
- `require adopting-a-module "the register's gestures include removal"  "the commit that removes it says why"`
- `require closing-a-batch "releasing keeps the entry"  "removes the reservation annotation and leaves the entry"`
- `require writing-a-batch "corrective batch reserves entries"       "reserved by batch"`

Dans `tests/test-cross-references.sh`, juste après le bloc qui tient la ligne du
`README` de `writing-in-a-spec` (les deux `case "$WROW"`), ajouter :

```bash

# The README row of writing-in-a-gaps-register, like the other internal
# skills', says it is not for direct use and names none of the skills that
# invoke it.
GROW="$(grep -F '`supercharlouze:writing-in-a-gaps-register`' "$REPO_ROOT/README.md" || true)"
case "$GROW" in
    *"using-batches"*|*"writing-a-batch"*|*"writing-a-user-story"*|*"adopting-a-module"*|*"closing-a-batch"*|*"invoked by"*)
        fail "the README row of writing-in-a-gaps-register names no caller" ;;
    *)  pass "the README row of writing-in-a-gaps-register names no caller" ;;
esac
case "$GROW" in
    *"Never directly"*) pass "the README row of writing-in-a-gaps-register rules out direct use" ;;
    *)                  fail "the README row of writing-in-a-gaps-register rules out direct use" ;;
esac
```

- [ ] **Step 3: Voir les gardes échouer**

Run: `bash tests/run-all.sh`
Expected: FAIL. `test-skill-frontmatter.sh` échoue sur la skill déclarée sans
répertoire, `test-skill-content.sh` sur chaque garde de
`writing-in-a-gaps-register`, `test-cross-references.sh` sur « rules out direct
use ».

- [ ] **Step 4: Écrire la skill**

Créer `skills/writing-in-a-gaps-register/SKILL.md`, en fins de ligne LF, avec ce
contenu exact :

````markdown
---
name: writing-in-a-gaps-register
description: Use only when a skill tells you to invoke writing-in-a-gaps-register, never on a request to record a gap or a violation - carries the shape of a gaps register, the rules of an entry, and the gestures that add, remove, reserve and release one
user-invocable: false
---

# Writing in a Gaps Register

## Overview

This skill carries the shape of a gaps register, `docs/specs/<module>.gaps.md`,
the rules of an entry, and the gestures that write in it.

The skill that invokes it says which gesture to make, on which entry of which
register, and gives the batch number when the gesture reserves or releases.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the writing-in-a-gaps-register skill to write in this gaps register."

Once the register is written, go on with the step that invoked this skill.

## The Shape of the Register

```markdown
# <module> — Gaps register

## Coverage

<Which parts of the module were audited, which were not, and why. Written even
— especially — when nothing was found.>

## Violations

- **<spec section>** — <how the code contradicts it.>
- **<spec section>** — <another one.> `reserved by batch-08`

## Gaps

- **<spec section, or the section that should exist>** — <behaviour no spec
  describes.>
- **<spec section, or the section that should exist>** — <a mechanism
  `<the validated document, by its archive path>`
  prescribes and no spec carries.>
```

Two categories, each under its own heading, kept apart because they are not
treated the same way:

- **Violations** — the code contradicts the spec. Feeds a *corrective batch*.
- **Gaps** — a real behaviour or requirement no spec describes. Feeds an ordinary
  batch that finally specifies them.

**The register also declares its own coverage:** which parts of the module were
audited, which were not, and why. An empty register that means "nothing was
examined" must never look like an empty register that means "everything conforms" —
they are opposite facts and they look identical unless you write the difference
down. Declare the coverage especially when you found nothing.

**Nothing stays behind in this file once an entry is settled.** The register
carries what is still open, and what an entry was — and why it left — is read in
the history of the file (`git log -p docs/specs/<module>.gaps.md`).

## An Entry

Each entry designates a section of the spec. **An entry that came from a document
names that document**, so your human partner can promote it knowing what they are
promoting instead of re-reading the whole thing.

**Each entry is one list item, never a paragraph of running prose.** Every
gesture below needs a thing it can point at, whether to annotate it in place or
to take it out whole.

A register written as flowing paragraphs breaks every one of them: there is no
item to annotate, none to remove cleanly, no list to append one to — what gets
added is more prose, which the next writer cannot point at either — and nothing a
corrective batch can draw a scope from. Write entries so the gestures are
mechanical.

**What qualifies an entry lives in the entry.** Besides its coverage, the register
carries nothing but entries: no prose qualifies a *group* of them — where they came
from, how they were classified, how many there are. Entries are added and removed
one at a time, and nothing keeps such a paragraph honest: it goes false without
anyone touching it. What it would say of several entries is repeated in each, and
where an entry came from is read in the history of the file. Writing several
entries at once is exactly when a group paragraph feels natural.

**An entry designates no other entry.** A settled entry leaves the file whole, and
it takes with it anything that pointed at it — by name or by position. What an
entry needs from its neighbour it states itself.

## The Gestures

### Add

An entry is one list item, added at the end of its category.

Within a batch, only the closing pull request adds entries to the gaps register.
Every addition contends with every other on the same module, which is why a batch
adds through one pull request.

A finding already deleted from the register is re-entered only if the entry says
what has changed since.

Read the file's history before adding an entry
(`git log -p docs/specs/<module>.gaps.md`). An entry that left this file left for
a reason, written in the commit that removed it: resolved, promoted, moot, false,
or set aside by your human partner.

### Remove

Delete the entry from the file, whole, in the same pull request as what settles
it, and the commit that removes it says why.

### Reserve

Append `reserved by batch-NN` to the entry, `NN` being the number of the batch
that takes it on.

The annotation is what stops another batch from taking the same entry: two
batches never reserve the same entry.

### Release

Releasing removes the reservation annotation and leaves the entry: what it
describes is still open, it is simply no longer claimed.

## Red Flags

| Thought | Reality |
|---------|---------|
| "Prose reads better than a list in the gaps register" | Then nothing can reserve, remove or release an entry, and the gestures break. |
| "The audit found nothing, so the register is empty" | An empty register must say whether nothing was found or nothing was examined. |
````

Vérifier les fins de ligne : `grep -c $'\r' skills/writing-in-a-gaps-register/SKILL.md`
rend `0`.

- [ ] **Step 5: Ajouter la ligne du `README`**

Dans le tableau `## Skills` de `README.md`, après la ligne de
`supercharlouze:writing-in-a-spec`, ajouter :

```markdown
| `supercharlouze:writing-in-a-gaps-register` | Never directly — a building block the other skills invoke before writing into a gaps register |
```

- [ ] **Step 6: Voir la suite passer**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`. Une garde négative qui parcourt toutes les skills
déclarées et échoue sur la skill neuve signale une formule chassée dans le texte
de l'étape 4 : rends compte de la garde et de la formule avant de toucher au
texte.

- [ ] **Step 7: Commit**

```bash
git add skills/writing-in-a-gaps-register tests README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la skill interne writing-in-a-gaps-register porte le gaps register" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 2: les skills qui écrivent dans un gaps register invoquent `writing-in-a-gaps-register`

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md`
- Modify: `skills/closing-a-batch/SKILL.md`
- Modify: `skills/using-batches/SKILL.md`
- Modify: `skills/writing-a-batch/SKILL.md`
- Modify: `skills/writing-a-user-story/SKILL.md`
- Modify: `tests/test-skill-contracts.sh`
- Modify: `tests/test-skill-content.sh`

**Interfaces:** la tâche 1 a livré `supercharlouze:writing-in-a-gaps-register`,
dont les sections sont `The Shape of the Register`, `An Entry`, `The Gestures`
(`Add`, `Remove`, `Reserve`, `Release`) et `Red Flags`.

- [ ] **Step 1: Remplacer les contrats `shared` par des gardes**

Dans `tests/test-skill-contracts.sh`, remplacer chacun de ces contrats `shared`
par un `require` sur `writing-in-a-gaps-register`, même libellé et même aiguille,
en gardant son commentaire réduit à ce qui reste vrai (le texte vit dans une
seule skill) :

| Libellé du contrat | Skills qu'il listait |
|---|---|
| `both writers read the file's history before adding` | `closing-a-batch using-batches` |
| `the removal duty is spelled alike wherever it is stated` | `adopting-a-module writing-a-user-story closing-a-batch using-batches` |
| `every writer that adds an entry keeps a group's qualification out` | `adopting-a-module closing-a-batch using-batches` |
| `every writer that adds an entry keeps entries from pointing at each other` | `adopting-a-module closing-a-batch using-batches` |
| `only the closing pull request adds entries within a batch` | `closing-a-batch using-batches writing-a-user-story` |
| `a deleted finding is re-entered only with what changed` | `closing-a-batch using-batches` |
| `the writers that append keep the entry format` | `closing-a-batch using-batches` |

Exemple de la forme attendue, pour le premier :

```bash
# Removal leaves no trace in the register, so what a module already rejected is
# readable only in the file's history. The skill that carries the gestures
# states that read.
require writing-in-a-gaps-register "both writers read the file's history before adding" \
    "Read the file's history before adding an entry"
```

Supprimer ces trois gardes, que la tâche 1 a déjà posées sur
`writing-in-a-gaps-register` ou que les gardes ci-dessous remplacent :

- dans `tests/test-skill-contracts.sh`, `shared "the entry's shape is still stated without the word" … adopting-a-module`, avec son commentaire ;
- dans `tests/test-skill-contracts.sh`, `shared "the adoption's gesture table names the closing that adds" … adopting-a-module`, avec son commentaire : la règle que cette ligne de table portait est tenue par `only the closing pull request adds entries within a batch` ;
- dans `tests/test-skill-content.sh`, `require adopting-a-module "an amendment releases a reservation" "| Release | \`supercharlouze:writing-a-batch\`, in an amendment pull request |"`.

Dans `tests/test-skill-contracts.sh`, juste après le `shared "the
other-implementation test bears one name" …`, ajouter :

```bash

# The shape of a gaps register, the rules of an entry and the gestures live in
# one place, `writing-in-a-gaps-register`. A skill that writes in a register
# invokes it and restates nothing: `adopting-a-module` creates the file and
# removes the entry of a gap it promotes, `closing-a-batch` adds and releases,
# `using-batches` carries the bounded change, `writing-a-batch` reserves and
# releases, `writing-a-user-story` removes the entry its story resolves.
for s in adopting-a-module closing-a-batch using-batches writing-a-batch writing-a-user-story; do
    require "$s" "invokes writing-in-a-gaps-register before writing in a gaps register" \
        "nvoke \`supercharlouze:writing-in-a-gaps-register\` before"
done
# What it carries is spelled there and nowhere else. Walks the declared skills,
# so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the rules of a gaps register entry or its gestures" \
    "What qualifies an entry lives in the entry|An entry designates no other entry|is one list item|Read the file's history before adding an entry|re-entered only if the entry says what has changed|the commit that removes it says why|removes the reservation annotation|declares its own coverage|— Gaps register|Within a batch, only the closing pull request adds entries to the gaps register" \
    $(declared_skills | grep -vx writing-in-a-gaps-register)

# Each caller passes what varies: the batch number of a reservation and of its
# release, the reason of a removal, the coverage an audit gives.
require writing-a-batch "the opening invokes the reservation with its number" \
    "invoke \`supercharlouze:writing-in-a-gaps-register\` before reserving one, and give it this batch's \`NN\`"
require writing-a-batch "an amendment invokes the release" \
    "releases its reservation in the same pull request: invoke \`supercharlouze:writing-in-a-gaps-register\` before releasing it"
require adopting-a-module "the adoption writes the coverage from its audit" \
    "Write the register's \`Coverage\` from this audit"
require adopting-a-module "a promotion gives the removal its reason" \
    "that is the reason the commit that removes it gives"
require writing-a-user-story "a story adds no entry itself" \
    "Do not add those observations to the gaps register yourself"
require closing-a-batch "the consolidation is written into each entry" \
    "write \"consolidated by batch NN\" into each entry that needs it, never above them"
```

- [ ] **Step 2: Voir les gardes échouer**

Run: `bash tests/test-skill-contracts.sh`
Expected: FAIL sur les cinq « invokes writing-in-a-gaps-register before writing
in a gaps register », sur « no other skill restates… » (présent dans
`adopting-a-module`, `closing-a-batch`, `using-batches`, `writing-a-user-story`)
et sur les gardes de ce que chaque appelant passe, sauf « a story adds no entry
itself » et « the consolidation is written into each entry », déjà vertes.

- [ ] **Step 3: Réécrire `adopting-a-module`**

À l'étape `4. Write the spec from those documents only`, dans la première puce,
remplacer la phrase

```markdown
Create `docs/specs/<module>.gaps.md` the first time you need it.
```

par

```markdown
Create `docs/specs/<module>.gaps.md` the first time you need it, and invoke
`supercharlouze:writing-in-a-gaps-register` before writing in it.
```

en recalant les retours à la ligne de la puce.

À l'étape `5. Audit the code against the spec`, remplacer tout ce qui va de
« Read the code against each section you just wrote » jusqu'à « Declare the
coverage especially when you found nothing. » inclus — les deux catégories, le
paragraphe sur l'élément de liste, la table des gestes, le paragraphe sur les
paragraphes continus, les trois paragraphes en gras sur une entrée, le gabarit du
registre et le paragraphe sur la couverture — par :

```markdown
Read the code against each section you just wrote, and add to the gaps register
what the audit reveals: under **Violations** what contradicts the spec, under
**Gaps** a real behaviour or requirement no spec describes.

Write the register's `Coverage` from this audit: which parts of the module you
read against the spec, which you did not, and why.
```

Le paragraphe « Fix nothing in the code while you are here. … » reste.

À l'étape `6. Offer to promote the gaps`, remplacer

```markdown
this is an adoption that promotes a gap into the
spec, and the commit that removes it says why.
```

par

```markdown
this is an adoption that promotes a gap into the
spec, and that is the reason the commit that removes it gives.
```

Dans `Red Flags`, supprimer les lignes « The audit found nothing, so the register
is empty » et « Prose reads better than a list in the gaps register ».

- [ ] **Step 4: Réécrire `closing-a-batch`**

Dans `### Consolidate what the story documents left`, remplacer tout ce qui va de
« Within a batch, only the closing pull request adds entries to the gaps
register. » jusqu'à la fin du paragraphe « **An entry designates no other
entry.** … » par ces trois paragraphes :

```markdown
**Invoke `supercharlouze:writing-in-a-gaps-register` before adding an entry.**

"Out of scope for this batch" is never a reason to drop an observation. It is precisely why the observation belongs in the register: the register is what a later corrective batch draws its scope from. Dropped here, the finding dies with the session that made it.

You arrive with a batch's worth of findings at once: write "consolidated by batch NN" into each entry that needs it, never above them.
```

Dans `### Release unconsumed reservations`, remplacer le premier paragraphe par :

```markdown
For every gaps register entry this batch reserved at opening (`reserved by batch-NN`) that is still in the file, release it. Invoke `supercharlouze:writing-in-a-gaps-register` before releasing one. Those are the **unconsumed reservations**: a story abandoned, an entry no story resolved. An entry an amendment took out of `Scope` is not among them: that amendment released it. An entry a story did resolve is not there to release: the story deleted it from the file, atomically with the code that resolved it.
```

Dans `### Withdraw the blocks no story delivered`, remplacer la phrase

```markdown
If they say yes, write it under **Gaps** in the register of the module concerned.
```

par

```markdown
If they say yes, invoke `supercharlouze:writing-in-a-gaps-register` and add it under **Gaps** in the register of the module concerned.
```

- [ ] **Step 5: Réécrire `using-batches`**

Dans `What Is Kept, What Is Rerouted`, remplacer la règle (d) et ses six
sous-paragraphes, jusqu'à « … and `supercharlouze:closing-a-batch` consolidates
them. » inclus, par cette seule puce :

```markdown
- **(d) It writes to a gaps register directly.** Belonging to no batch, it may both add an entry and delete one in `docs/specs/<module>.gaps.md`, from its own pull request, contending only with another bounded change. Invoke `supercharlouze:writing-in-a-gaps-register` before writing in it.
```

- [ ] **Step 6: Réécrire `writing-a-batch`**

Dans le paragraphe « **Reserving gaps-register entries — any batch, not only a
corrective one.** », remplacer

```markdown
reserve every entry it takes on **in this same pull request**, annotating the
entry `reserved by batch-NN`.
```

par

```markdown
reserve every entry it takes on **in this same pull request**: invoke
`supercharlouze:writing-in-a-gaps-register` before reserving one, and give it
this batch's `NN`.
```

Dans `Amending a Batch`, remplacer

```markdown
An amendment that takes a gaps register entry out of `Scope` releases its
reservation in the same pull request: it removes the entry's
`reserved by batch-NN` annotation and leaves the entry.
```

par

```markdown
An amendment that takes a gaps register entry out of `Scope` releases its
reservation in the same pull request: invoke
`supercharlouze:writing-in-a-gaps-register` before releasing it.
```

Rien d'autre ne change dans cette skill : aucun texte n'y fait réserver une
entrée par un amendement.

- [ ] **Step 7: Réécrire `writing-a-user-story`**

Dans `Step 3`, remplacer

```markdown
A corrective batch's story removes an entry: it deletes the gaps register entry it
resolves from `docs/specs/<module>.gaps.md`, and the commit that removes it says
why. Removing an entry takes out lines nobody else is writing, so two stories
removing different entries do not collide — and what the entry said, and why it
went, stay readable in the history of the file.
```

par

```markdown
A corrective batch's story removes an entry: it deletes the gaps register entry it
resolves from `docs/specs/<module>.gaps.md`. Invoke
`supercharlouze:writing-in-a-gaps-register` before deleting it. Removing an entry
takes out lines nobody else is writing, so two stories removing different entries
do not collide.
```

Dans `Step 6`, remplacer

```markdown
Do not add those observations to the gaps register yourself. Within a batch, only the closing pull request adds entries to the gaps register, and `supercharlouze:closing-a-batch` consolidates them there.
```

par

```markdown
Do not add those observations to the gaps register yourself: `supercharlouze:closing-a-batch` consolidates them there.
```

- [ ] **Step 8: Voir la suite passer**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`. Une garde qui échoue parce qu'elle cherchait dans
une skill appelante un texte parti dans `writing-in-a-gaps-register` se repointe
sur cette skill, aiguille inchangée ; rends compte de chacune. Une garde qui
échoue pour une autre raison n'est pas contournée : rends-en compte.

Vérifier aussi qu'aucune skill ne cite une section de la spec :

```bash
bash tests/test-cross-references.sh
```

- [ ] **Step 9: Commit**

```bash
git add skills tests
bash ~/.config/github-app/as-agent.sh git commit -m "feat: les skills qui écrivent dans un gaps register invoquent writing-in-a-gaps-register" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

## Observed drift
