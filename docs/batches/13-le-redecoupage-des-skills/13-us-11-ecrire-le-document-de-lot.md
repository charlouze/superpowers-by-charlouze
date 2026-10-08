# Writing a Batch Document Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extraire dans la skill interne `writing-a-batch-document` la forme du document de lot et de ses champs, que `writing-a-batch` porte aujourd'hui.

**Architecture:** `writing-a-batch-document` reçoit de la skill qui l'invoque le `NN` et le slug d'un document à écrire, ou le document existant et ce qui y change. `writing-a-batch` l'invoque à l'ouverture et dans un amendement, et garde la conduite des deux. Les gardes qui tenaient le texte déplacé le suivent dans la nouvelle skill.

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

### The freeze of the spec file

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

### The authority rule

> When the batch and the spec contradict each other, the spec wins — without
> exception and without deliberation. Implement what the spec says, record a
> `Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
> agent's.

### The concision rules

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

### The stop condition of a technical story

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

### The stop condition on a constraint or an ADR

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

### The ADRs

> The code this story writes holds these ADRs.

- `docs/adr/une-skill-par-moment-d-invocation.md`

### The conditions of an ADR

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

## Review Focus

- Une phrase déplacée dont la garde est restée sur `writing-a-batch` : la garde passerait encore sur un reste de texte, ou tomberait en silence. Chaque garde retirée de `writing-a-batch` réapparaît sur `writing-a-batch-document`, et la tâche 2 compte les assertions avant et après.
- Le nom `writing-a-batch-document` commence par celui d'une skill d'entrée : une garde qui cherche `writing-a-batch` le trouve dans le nom de la skill interne. La tâche 1 écrit la garde « names no skill that invokes it » avec un motif qui laisse passer ce nom.
- Un amendement qui ne reçoit plus la consigne d'écrire sans historique : la tâche 2 garde la phrase d'invocation de l'amendement, et la tâche 1 la phrase de la skill.
- Une copie laissée dans une autre skill : la garde négative de la tâche 2 parcourt toutes les skills déclarées.
- Un renvoi à une section de `writing-a-batch` qui n'existe plus : `tests/test-cross-references.sh` échoue sur un titre cité entre parenthèses qui n'est pas un titre de la skill.

---

## File Structure

- Create: `skills/writing-a-batch-document/SKILL.md`, la skill interne.
- Modify: `tests/skills.txt`, qui la déclare.
- Modify: `README.md`, dont le tableau des skills reçoit sa ligne.
- Modify: `skills/writing-a-batch/SKILL.md`, qui l'invoque et perd le texte déplacé.
- Modify: `skills/closing-a-batch/SKILL.md`, qui perd sa copie de la règle du document sans état.
- Modify: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`, `tests/test-cross-references.sh`, dont les gardes suivent le texte.

Les fichiers de `skills/` ont des fins de ligne LF. Écris-les et modifie-les avec les outils d'écriture et d'édition de fichiers, jamais par un heredoc ni par un `sed` en ligne de commande.

### Task 1: La skill `writing-a-batch-document`

**Files:**
- Create: `skills/writing-a-batch-document/SKILL.md`
- Modify: `tests/skills.txt`
- Modify: `README.md` (tableau des skills, après la ligne de `supercharlouze:finishing-a-pr`)
- Test: `tests/test-skill-content.sh`, `tests/test-cross-references.sh`

**Interfaces:**
- Consumes: `require`, `absent`, `declared_skills` de `tests/lib.sh` ; la variable `entry_names` que `tests/test-skill-content.sh` définit avant ses gardes de skills internes.
- Produces: la skill `supercharlouze:writing-a-batch-document`, ses titres `The Document`, `The Spec Delta`, `Technical Design and Constraints`, `The Feature Flag Field`, `Flags Declared by Earlier Batches`, `Red Flags`, et la phrase « The skill that invokes it gives the batch's `NN` and its slug for a document to write, or the batch document and what changes in it for a document to amend. »

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/skills.txt`, ajoute après la ligne `finishing-a-pr internal` :

```
writing-a-batch-document internal
```

Dans `tests/test-skill-content.sh`, ajoute `writing-a-batch-document` aux deux boucles du haut du fichier (« states the language rule » et « points at the concision rules »), après `writing-a-batch`.

Dans le même fichier, juste après la ligne `absent "finishing-a-pr names no skill that invokes it" …`, ajoute :

```bash

# --- writing-a-batch-document: the form of a batch document ---
require writing-a-batch-document "says what the invoking skill gives" \
    "The skill that invokes it gives the batch's \`NN\` and its slug for a document to write, or the batch document and what changes in it for a document to amend."
require writing-a-batch-document "a new document is written whole" \
    "Write a new document whole, from the template below."
require writing-a-batch-document "an amended document keeps no history" \
    "Amend a document in place, in the fields the change touches, and keep in it no history of what it said before."
require writing-a-batch-document "says when to go back to the step that invoked it" \
    "Once the document is written, go on with the step that invoked this skill."
require writing-a-batch-document "the document lives in the batch directory" \
    "Write \`docs/batches/NN-<slug>/README.md\`"
require writing-a-batch-document "the flag decision follows the model of the foundation" \
    "Decide it by \`The Model\` in \`supercharlouze:following-the-rules\`"
require writing-a-batch-document "the field has three shapes" \
    "Three shapes of the field, and there are no others"
require writing-a-batch-document "a cross-module batch writes one line per guarded module" \
    "one line per guarded module"
require writing-a-batch-document "the gating sentence is left to the story" \
    "do not write it into the spec yourself"
require writing-a-batch-document "a block is written under the rules of a spec" \
    "**Invoke \`supercharlouze:writing-in-a-spec\` before writing a block.**"
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them. Its own name starts with the name of an entry
# skill, which the pattern lets through.
document_callers="$(printf '%s' "${entry_names%|}" | sed 's/writing-a-batch/writing-a-batch([^-]|$)/')"
absent "writing-a-batch-document names no skill that invokes it" "$document_callers|Step [0-9]" writing-a-batch-document
```

Dans `tests/test-cross-references.sh`, juste après le bloc `case "$FROW" in … esac` qui vérifie « rules out direct use » pour `finishing-a-pr`, ajoute :

```bash

# The README row of writing-a-batch-document, like the other internal skills',
# says it is not for direct use and names none of the skills that invoke it. Its
# own name starts with the name of the skill that invokes it, so the name is
# taken out before the row is read.
NROW="$(grep -F '`supercharlouze:writing-a-batch-document`' "$REPO_ROOT/README.md" || true)"
case "${NROW//writing-a-batch-document/}" in
    *"writing-a-batch"*|*"invoked by"*)
        fail "the README row of writing-a-batch-document names no caller" ;;
    *)  pass "the README row of writing-a-batch-document names no caller" ;;
esac
case "$NROW" in
    *"Never directly"*) pass "the README row of writing-a-batch-document rules out direct use" ;;
    *)                  fail "the README row of writing-a-batch-document rules out direct use" ;;
esac
```

Vérifie d'abord que la variable `NROW` n'est pas déjà utilisée dans ce fichier ; si elle l'est, nomme-la `BDROW`.

- [ ] **Step 2: Lancer les gardes et les voir échouer**

Run: `bash tests/test-skill-content.sh | grep FAIL ; bash tests/test-cross-references.sh | grep FAIL ; bash tests/test-skill-frontmatter.sh | grep FAIL`
Expected: des lignes `[FAIL] writing-a-batch-document: …`, `[FAIL] the README row of writing-a-batch-document rules out direct use`, `[FAIL] writing-a-batch-document/SKILL.md exists`.

- [ ] **Step 3: Écrire la skill**

Crée `skills/writing-a-batch-document/SKILL.md` avec exactement ce contenu, fins de ligne LF :

~~~~~markdown
---
name: writing-a-batch-document
description: Use only when a skill tells you to invoke writing-a-batch-document, never on a request to write or change a batch document - gives the form of a batch document and of its fields, for a document to write and for one to amend
user-invocable: false
---

# Writing a Batch Document

## Overview

This skill carries the form of a batch document and of its fields.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the writing-a-batch-document skill to write
this batch document."

The skill that invokes it gives the batch's `NN` and its slug for a document to
write, or the batch document and what changes in it for a document to amend.

Write a new document whole, from the template below.

Amend a document in place, in the fields the change touches, and keep in it no
history of what it said before.

Once the document is written, go on with the step that invoked this skill.

## The Document

Write `docs/batches/NN-<slug>/README.md`:

```markdown
---
status: open
---

# NN — <title>

## Scope

<What this batch delivers, including every gaps register entry it takes on.>

## Spec delta

<The exact text this batch writes into the specs, in blocks. Per block: its
`D<n>` identifier, the spec and the section it targets, then its change shown in
the paragraph that contains it. Including the removal of the gating sentence of
any flag an earlier batch declared and this batch takes on. Never left blank:
with no block, `none` and the reason.>

## Technical design

<The design your human partner approved during the brainstorming: the mechanism
the stories are planned from. Never left blank: with no design, `none` and the
reason.>

## Constraints

<Only the migration and compatibility constraints, the technical decisions the
rest of the technical design relies on, and the required order of the stories
and of the blocks. `none` if there are none.>

## Feature flag

<See `The Feature Flag Field`. Never omitted.>
```

`status: open | closed` is a front matter value, so it is English even in a
French project.

The document follows `Language` in `supercharlouze:following-the-rules`: English
skeleton, prose in the project's language.

Every text of the document follows `Concision` in `supercharlouze:following-the-rules`.

**The batch document carries no mutable state.** It is written once, when the
batch opens, and nothing in the normal course of the batch modifies it **until
closing**, which withdraws from it the blocks no story delivered and flips its
front matter to `status: closed`. Before closing, it changes only through an
amendment. Two consequences follow, and both are deliberate:

- **The list of stories does not appear in it.** The list of stories is the
  content of the batch directory, completed by the open pull requests and by
  the pushed `story/*` branches that carry no pull request yet. A
  hand-maintained one would be edited by every story, conflicting on the same
  file every time, for information the system already holds.
- **Story state does not appear either.** A story's state *is* the state of its
  pull request. A checkbox copies, worse, a truth `gh pr list` gives exactly, and
  goes stale at the first merge that happens outside your session.

## The Spec Delta

The delta is written here as **exact text, in blocks**: each block is
transcribed word for word by a story, in that story's own pull request.

**Invoke `supercharlouze:writing-in-a-spec` before writing a block.** A block is
the exact text a spec will receive, so what a spec contains holds for every
sentence of it.

**A block is the unit of the delta.** Each one carries an identifier `D<n>`,
unique within the batch, and names the spec and the section it targets.

A block shows what it changes in the paragraph that contains it. A fragment and
its replacement, quoted apart, leave the reviewer to rebuild the paragraph, and
the sentence the change contradicts two lines further on goes unseen. Give the
paragraph in a `diff` fence: its lines as `main` carries them, each removed line
prefixed `-`, each added line `+`, each unchanged line a space. The story
transcribes against those lines, so take the paragraph from `main` as it stands.

A block that changes a whole section is the exception: one that rewrites it
gives the section as it will read, one that inserts it gives it and names the
section it follows, one that removes it names it.

````markdown
### D4 — `docs/specs/facturation.md`, `Subscription > Renewal`

```diff
 A subscription renews on its anniversary date, for the same length.
-The customer is notified seven days before.
+The customer is notified fourteen days before, and may decline the renewal
+until the day before.
```
````

**No block is attached to a story.** The story chooses, as it is written, the
blocks it transcribes; the batch document names no story and carries no list of
them. A section that changes twice in the course of the batch carries two blocks,
and `Constraints` states their order.

**A rule belongs to exactly one spec.** A batch may cut across modules, so its
delta may well carry blocks aimed at several specs — that is ordinary. What is
not: two blocks writing the same rule into two specs. That is not a delta with a
duplicate in it, it is a module breakdown asking to be revisited, and this is the
one place in the flow where it becomes visible, because this is the one document
that faces several specs at once. Stop and put it to your human partner before
going on. No wording of the delta settles it, and a review is not where a
breakdown gets decided in passing.

**The `Spec delta` field is never left blank.** It carries the blocks, or `none`
and the reason. "No block" is a decision, and a decision is stated.

A corrective batch has no block by definition: it restores behaviour a spec
already promises. Its `Spec delta` reads `none` with that reason, and its
`Scope` lists the *Violations* entries it takes on.

## Technical Design and Constraints

`Technical design` carries the design your human partner approved during
`superpowers:brainstorming`, which this document replaces as the design doc.
Each story's plan starts from it, and a story may depart from it by recording
a `Technical design ruling:`.

What a user or a neighbouring module would observe goes in a block, never in
`Technical design`.

Nothing normative goes in `Constraints`: the spec is the binding authority on
behaviour. Every story's `Global Constraints` copies this section **verbatim**,
which makes it part of every task's requirements. Write it as constraints an
implementer can obey, not as background. Left out, each story would silently
invent its own migration rule, its own order, and its own version of a decision
the rest of the design relies on.

A technical decision goes in `Constraints` only if the rest of the technical
design relies on it, such as a name or a format several parts of the design use.
Every other technical decision goes in `Technical design`, where a story may
depart from it.

A batch's constraints bind only its stories.

## The Feature Flag Field

The `Feature flag` field is **mandatory and never left empty**. "No flag" must be
a stated and reviewed decision, not an omission.

Decide it by `The Model` in `supercharlouze:following-the-rules`: the exemption
criterion and the families that answer it by construction, one flag per (batch,
module), and the scope and the lifting condition a flag declares when it
outlives its batch.

Three shapes of the field, and there are no others:

```markdown
Feature flag: `billing.recurring`, off by default — scope: this batch
Feature flag: `billing.recurring`, off by default — scope: beyond this batch,
              lifted when the `facturation` module is fully delivered
Feature flag: none — corrective batch, restores behaviour the spec already promises
```

A cross-module batch is not a fourth shape: it writes **one line per guarded
module**, each of one of those three shapes, and each naming its module so the
lifting story knows which spec it belongs to:

```markdown
Feature flag: `facturation.recurrent`, off by default — scope: this batch — module `facturation`
Feature flag: `relance.recurrent`, off by default — scope: this batch — module `relance`
```

The flag's name, its default and, when the scope extends, its lifting condition
are written into the spec section concerned by the story that transcribes that
section. State them here so the story author knows the gating sentence is owed;
do not write it into the spec yourself.

## Flags Declared by Earlier Batches

**The specs are the registry of flags.** A flag exists as long as its gating
sentence stands in a spec section, with its default and, when it outlives its
batch, its lifting condition. There is no other list to keep, and the batch
document copies none: anyone reading or changing that section sees the flag.

So read the gating sentences of the specs this batch touches. When this batch's
work satisfies one's lifting condition, and your human partner agrees, **state
its lifting in the `Spec delta`**, as a block that removes its gating sentence.
Lifting a flag is a change of spec like any other, delivered by a lifting story,
and a lifting left undelivered is withdrawn at closing like any block the delta
announced and no story declared.

A flag whose condition is met and that no batch takes on stays where it is: in
the spec, with its condition, in front of whoever touches that section next.

## Red Flags

| Thought | Reality |
|---------|---------|
| "No flag needed, this batch is small" | Small is not the criterion. Would one story, merged alone, leave a user facing something incomplete? |
| "I'll add the story list to the batch document, it's clearer" | Every story would then conflict on that file, for information the directory already holds. |
| "This batch satisfies that flag's lifting condition, I'll lift it in passing" | Lifting is a spec change. State it in the `Spec delta`, where the gate sees it, and a lifting story delivers it. |
| "The delta only needs to say what changes — the story will find the words" | The delta is the exact text. The opening review is where the human reads what the specs will say; wording left to a story reaches them only once code is built on it. |
| "The flag will obviously be removed at the end, no need to say when" | A flag outliving its batch without a stated lifting condition is indistinguishable from a forgotten one, and blocks closing. |
| "The rule holds for both modules, so the delta carries it twice" | A rule belongs to exactly one spec, so two blocks writing the same rule into two specs signal the breakdown, not a delta. Stop and put it to your human partner. |
| "The design is obvious from the delta, `Technical design` can say `none`" | An obvious design is still a design: write it. `none` is for a batch with no design to plan from, and it carries its reason; written `none`, it leaves each story to invent its own mechanism. |
| "This technical decision matters, so it goes in `Constraints`" | Only if the rest of the technical design relies on it. Otherwise it goes in `Technical design`, where a story may depart from it by a ruling. |
~~~~~

Dans `README.md`, ajoute après la ligne de `supercharlouze:finishing-a-pr` du tableau des skills :

```markdown
| `supercharlouze:writing-a-batch-document` | Never directly — a building block the other skills invoke to give a batch document its form: its fields, its blocks and its flag decision |
```

- [ ] **Step 4: Lancer la suite entière**

Run: `bash tests/run-all.sh 2>&1 | grep -c '\[PASS\]' ; bash tests/run-all.sh 2>&1 | grep '\[FAIL\]'`
Expected: aucun `[FAIL]`. Note le nombre de `[PASS]` dans ton rapport. La suite prend environ trois minutes : lance-la avec un délai de cinq minutes.

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-batch-document tests/skills.txt tests/test-skill-content.sh tests/test-cross-references.sh README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la skill interne writing-a-batch-document porte la forme du document de lot

Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: `writing-a-batch` invoque la skill

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md`
- Modify: `skills/closing-a-batch/SKILL.md` (le deuxième paragraphe de `Overview`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la skill `supercharlouze:writing-a-batch-document` de la tâche 1 et ses phrases, telles que la tâche 1 les a écrites.
- Produces: dans `writing-a-batch`, les phrases « To write the batch document, invoke `supercharlouze:writing-a-batch-document` and give it this batch's `NN` and its slug. » et « To amend the document, invoke `supercharlouze:writing-a-batch-document` and give it the batch document and what the amendment changes in it. »

- [ ] **Step 1: Noter le nombre d'assertions de départ**

Run: `bash tests/run-all.sh 2>&1 | grep -c '\[PASS\]'`
Note ce nombre : il sert à l'étape 5.

- [ ] **Step 2: Déplacer les gardes dans `tests/test-skill-content.sh`**

Chaque garde ci-dessous est une ligne `require writing-a-batch "<label>" …`. Remplace dans chacune `require writing-a-batch ` par `require writing-a-batch-document `, sans toucher au label ni à l'aiguille :

- "batch document carries no mutable state"
- "no story list in the batch document"
- "the story list counts pushed branches"
- "declares the Feature flag field"
- "flag field is never left empty"
- "flag is per batch and module"
- "extended scope names its lifting condition"
- "the specs are the registry of flags"
- "a lifting is stated in the spec delta"
- "an obvious design is still written"
- "template declares the Constraints section"
- "Constraints carry nothing normative"
- "Constraints keep shared decisions from being reinvented"
- "the delta is exact text, in blocks"
- "a block carries a unique D<n>"
- "a block shows its change in its paragraph"
- "the paragraph is given as a diff"
- "the paragraph is taken from main"
- "no block is attached to a story"
- "two changes to a section are two blocks"
- "a lifting is a block removing the sentence"
- "the batch document faces several specs"
- "twin blocks are not a delta"
- "undelivered means nobody declared it"
- "the delta field is never left blank"
- "the field carries blocks or none"
- "a corrective batch lists its entries in Scope"
- "the template forbids a blank delta"
- "the template's Scope names the entries"
- "the template's Constraints are bounded"
- "a decision is a constraint only if the design relies on it"
- "every other decision is design"
- "a batch's constraints bind only its stories"
- "the template places the design after the delta"
- "the template places the design before the constraints"
- "the design field is never left blank"
- "the design comes from the brainstorming"
- "a story may depart from the design"
- "an observable behaviour is a block, not design"

La garde "Constraints are copied verbatim to stories" change de skill et d'aiguille :

```bash
require writing-a-batch-document "Constraints are copied verbatim to stories" "Every story's \`Global Constraints\` copies this section **verbatim**"
```

Les gardes de `writing-a-batch` qui ne sont pas dans cette liste restent sur `writing-a-batch`, dont "writes no spec at opening", "the document reread checks the widened Constraints", "the PR body puts the constraints to the reviewer", "the document reread checks the field", "the document reread checks the design field" et "the PR body puts the design to the reviewer".

Remplace le commentaire `# --- writing-a-batch: the batch document contract (spec section "The batch document") ---` par :

```bash
# --- writing-a-batch-document: the batch document contract (spec section "The batch document") ---
# The guards that stay on writing-a-batch here hold what its reread and its pull
# request body say of the document.
```

Juste après la ligne `require writing-a-batch "writes no spec at opening" …`, ajoute :

```bash
require writing-a-batch "the opening has the document written by the shared skill" \
    "To write the batch document, invoke \`supercharlouze:writing-a-batch-document\` and give it this batch's \`NN\` and its slug."
require writing-a-batch "an amendment has the document amended by the shared skill" \
    "To amend the document, invoke \`supercharlouze:writing-a-batch-document\` and give it the batch document and what the amendment changes in it."
require writing-a-batch "no block is transcribed at opening" \
    "No block is transcribed at opening: each one is transcribed by a story, in that story's own pull request"
require writing-a-batch "an amendment says in its body what changed" \
    "Say in the pull request body what changed and why."
```

Dans la boucle `for s in using-batches writing-a-batch; do` qui chasse `Refactor and infrastructure`, ajoute `writing-a-batch-document` à la liste.

- [ ] **Step 3: Déplacer et remplacer les gardes dans `tests/test-skill-contracts.sh`**

a. Dans la boucle « invokes writing-in-a-spec before writing a text a spec receives », remplace `writing-a-batch` par `writing-a-batch-document`, et dans le commentaire au-dessus, `` `writing-a-batch` the blocks a spec will receive `` par `` `writing-a-batch-document` the blocks a spec will receive ``.

b. Dans la boucle « names the rule its step stops on », remplace `writing-a-batch` par `writing-a-batch-document`.

c. Remplace le contrat `shared "the flag exemption names the technical batch identically" …` et son commentaire par :

```bash
# The three families that answer the exemption criterion by construction are
# listed in the foundation. The skill that writes the `Feature flag` field
# points at them, and no other skill spells them a second time.
require following-the-rules "the flag exemption names the technical batch" \
    "**A batch all of whose stories are technical** — none of them changes what is observable at its module's boundary, so every pull request is deployable as it stands. That is what the qualification means, not a tolerance granted to it."
require writing-a-batch-document "points at the exemption criterion and its families" \
    "Decide it by \`The Model\` in \`supercharlouze:following-the-rules\`: the exemption criterion and the families that answer it by construction"
# shellcheck disable=SC2046
absent "no other skill spells the exemption families" \
    "That is what the qualification means|Gating it would delay a conformance fix|nothing is ever half delivered" \
    $(declared_skills | grep -vx following-the-rules)
```

d. Remplace le contrat `shared "each flag is independent of the others" …` et son commentaire par :

```bash
# Each flag is independent of the others. The foundation says it, and the skill
# that writes the `Feature flag` field points at the foundation for one flag
# per (batch, module).
require following-the-rules "each flag is independent of the others" \
    "Each flag is switched on, switched off and lifted independently of the others: one flag's lifting story waits for no other flag's."
require writing-a-batch-document "points at one flag per batch and module" \
    "one flag per (batch, module)"
# shellcheck disable=SC2046
absent "no other skill restates the independence of the flags" \
    "lifted independently of the others" \
    $(declared_skills | grep -vx following-the-rules)
```

e. Remplace le contrat `shared "the batch document's immutability is bounded at closing, spelled alike" …` et le commentaire qui le précède par ce qui suit, en laissant en place le commentaire et la garde `absent_everywhere "no skill denies that the batch document changes at closing"` qui le suivent :

```bash
# The batch document's immutability has a bound, and the bound is the closure
# (spec section `Batch`). `writing-a-batch-document` states the rule and its
# bound; `closing-a-batch` is the end that performs it and says only what it
# does to the document.
require writing-a-batch-document "the batch document's immutability is bounded at closing" \
    "nothing in the normal course of the batch modifies it **until closing**"
require closing-a-batch "closing is the one moment that touches the batch document" \
    "It is also the only moment in a batch's normal course that touches the batch document itself: *Withdraw the blocks no story delivered* removes them from it, and *Set status: closed* flips its front matter."
# shellcheck disable=SC2046
absent "no other skill restates the immutability of the batch document" \
    "nothing in the normal course of the batch modifies it" \
    $(declared_skills | grep -vx writing-a-batch-document)
```

f. Dans le contrat `shared "the batch and the story spell a technical design ruling alike"`, remplace `writing-a-batch writing-a-user-story` par `writing-a-batch-document writing-a-user-story`.

g. Dans les deux gardes `absent "Constraints are no longer bounded to migration and order"` et `absent "no constraint is judged against the stories"`, ajoute `writing-a-batch-document` à la liste des skills, après `writing-a-batch`.

h. Juste avant le commentaire « # The end of a review is conducted in one place, `finishing-a-pr`. », ajoute :

```bash
# The form of a batch document lives in one place, `writing-a-batch-document`.
# A skill that writes or amends one invokes it and passes what varies: the
# number and the slug of a document to write, or the document and what changes
# in it.
require writing-a-batch "invokes writing-a-batch-document to write or amend the batch document" \
    "nvoke \`supercharlouze:writing-a-batch-document\` and give it"
# The form is spelled there and nowhere else. Walks the declared skills, so one
# declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the form of a batch document" \
    "exact text, in blocks|unique within the batch|Give the paragraph in a .diff. fence|No block is attached to a story|faces several specs at once|Nothing normative goes in .Constraints.|bind only its stories|Three shapes of the field|one line per guarded module|There is no other list to keep|list of stories does not appear|history of its own scope" \
    $(declared_skills | grep -vx writing-a-batch-document)

```

- [ ] **Step 4: Lancer les gardes et les voir échouer**

Run: `bash tests/test-skill-content.sh | grep FAIL ; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: `[FAIL] writing-a-batch: the opening has the document written by the shared skill`, `[FAIL] writing-a-batch: an amendment has the document amended by the shared skill`, `[FAIL] writing-a-batch: no block is transcribed at opening`, `[FAIL] writing-a-batch: an amendment says in its body what changed`, `[FAIL] writing-a-batch: invokes writing-a-batch-document to write or amend the batch document`, `[FAIL] closing-a-batch: closing is the one moment that touches the batch document`, et les trois gardes négatives « no other skill … » avec `present in: writing-a-batch` (et `closing-a-batch` pour l'immutabilité). Aucune garde de `writing-a-batch-document` n'échoue. Colle cette sortie dans ton rapport.

- [ ] **Step 5: Réécrire `skills/writing-a-batch/SKILL.md`**

a. Dans `Opening, in Order`, l'étape 3 devient :

```markdown
3. **Write the batch document**: `Scope`, `Spec delta`, `Technical design`,
   `Constraints`, `Feature flag` (`The Batch Document`), then write, rewrite or
   delete the ADRs your human partner decided (`The ADRs`).
```

b. La section `## The Batch Document` garde son titre. Tout ce qui va de la ligne « Write `docs/batches/NN-<slug>/README.md`: » jusqu'au paragraphe « **A rule belongs to exactly one spec.** … not where a breakdown gets decided in passing. » compris est remplacé par :

```markdown
To write the batch document, invoke `supercharlouze:writing-a-batch-document`
and give it this batch's `NN` and its slug.

This pull request does **no writing into the specs**. No block is transcribed at
opening: each one is transcribed by a story, in that story's own pull request
(`supercharlouze:writing-a-user-story`). Transcribing the whole delta now would
put behaviour into the spec that no code delivers — drift by definition, and the
reviewers of a story would then report as missing what is merely not built yet.
```

Les trois paragraphes qui suivent restent tels quels : « **The gaps register is not a spec.** … », « **Reserving gaps-register entries — any batch, not only a corrective one.** … » et « **The two categories of the register do not feed the same kind of batch.** … ».

Tout ce qui suit ces trois paragraphes dans la section est supprimé : « **The `Spec delta` field is never left blank.** … », « A corrective batch has no block by definition: … » et « **The batch document carries no mutable state.** … » avec ses deux puces.

c. Les sections `## The Feature Flag Field` et `## Flags Declared by Earlier Batches` sont supprimées en entier. `## The ADRs` suit alors `## The Batch Document`.

d. Dans `Amending a Batch`, la phrase « Edit the batch document in place, with no history of its own scope inside it, and say in the pull request body what changed and why. » devient :

```markdown
To amend the document, invoke `supercharlouze:writing-a-batch-document` and give
it the batch document and what the amendment changes in it. Say in the pull
request body what changed and why.
```

e. Dans `Red Flags`, supprime les lignes dont la première colonne est :

- "No flag needed, this batch is small"
- "I'll add the story list to the batch document, it's clearer"
- "This batch satisfies that flag's lifting condition, I'll lift it in passing"
- "The delta only needs to say what changes — the story will find the words"
- "The flag will obviously be removed at the end, no need to say when"
- "The rule holds for both modules, so the delta carries it twice"
- "The design is obvious from the delta, `Technical design` can say `none`"
- "This technical decision matters, so it goes in `Constraints`"

Rien d'autre ne change dans cette skill.

- [ ] **Step 6: Réécrire le paragraphe de `skills/closing-a-batch/SKILL.md`**

Le deuxième paragraphe de `Overview`, qui commence par « It is also the only moment in a batch's normal course that touches the batch document itself. », devient, sur une seule ligne comme le reste de ce fichier :

```markdown
It is also the only moment in a batch's normal course that touches the batch document itself: *Withdraw the blocks no story delivered* removes them from it, and *Set status: closed* flips its front matter. Anything else that would edit the document goes through an amendment pull request of its own, which `supercharlouze:writing-a-batch` owns.
```

Si une garde de `tests/` tenait une phrase de l'ancien paragraphe que le nouveau ne porte plus, arrête-toi et rapporte-la avec son aiguille, sans la modifier.

- [ ] **Step 7: Lancer la suite entière**

Run: `bash tests/run-all.sh 2>&1 | grep -c '\[PASS\]' ; bash tests/run-all.sh 2>&1 | grep '\[FAIL\]'`
Expected: aucun `[FAIL]`. Le nombre de `[PASS]` vaut celui de l'étape 1 plus 13 : à l'étape 2, quatre `require` ajoutés et une skill de plus dans la boucle `Refactor and infrastructure` ; à l'étape 3, deux gardes de plus pour chacun des trois contrats `shared` remplacés en (c), (d) et (e), et deux gardes en (h). Si le nombre diffère, compte les gardes ajoutées et retirées dans ton diff et explique l'écart dans ton rapport.

- [ ] **Step 8: Vérifier qu'aucun renvoi ne pend**

Run: `grep -n 'The Feature Flag Field\|Flags Declared by Earlier Batches' skills/writing-a-batch/SKILL.md skills/closing-a-batch/SKILL.md skills/using-batches/SKILL.md skills/writing-a-user-story/SKILL.md skills/adopting-a-module/SKILL.md`
Expected: aucune ligne.

- [ ] **Step 9: Commit**

```bash
git add skills/writing-a-batch skills/closing-a-batch tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: writing-a-batch invoque writing-a-batch-document

Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: la story reste technique alors que `writing-a-batch` se met à invoquer une skill — la spec ne dit pas quelle skill porte une règle, et l'arbitrage est déjà rendu pour les extractions de ce lot — si c'est faux, la story aurait dû s'arrêter sur sa condition d'arrêt.
- Ruling: `writing-a-batch-document` renvoie à `The Model` du socle pour le critère d'exemption d'un flag, ses familles, le flag par (lot, module), l'indépendance des flags et la portée étendue, au lieu de les recopier — le socle les porte en entier, et `Technical design` fait d'une copie du socle un renvoi — si c'est faux, celui qui remplit `Feature flag` sans avoir le socle en contexte n'a plus le critère sous les yeux.
- Ruling: les contrats `shared` sur les familles d'exemption et sur l'indépendance des flags deviennent une garde sur le socle, une garde sur le renvoi de `writing-a-batch-document` et une garde négative sur toutes les autres skills — `Technical design` remplace un contrat qui exigeait des copies — si c'est faux, une reformulation du socle n'est plus confrontée à une seconde copie.
- Ruling: l'arrêt sur deux blocs qui écrivent la même règle dans deux specs suit les blocs dans `writing-a-batch-document`, et dit « before going on » là où `writing-a-batch` disait « before opening the batch » — la règle porte sur ce que le delta contient, et la skill sert aussi un amendement — si c'est faux, l'arrêt appartenait à la conduite de l'ouverture et doit y revenir.
- Ruling: l'invocation de `writing-in-a-spec` avant d'écrire un bloc suit les blocs dans `writing-a-batch-document`, et `writing-a-batch` ne l'invoque plus — c'est la skill qui écrit le texte qu'une spec recevra — si c'est faux, une skill qui écrirait un bloc sans passer par `writing-a-batch-document` n'a plus la règle de contenu.
- Ruling: restent dans `writing-a-batch` l'absence d'écriture dans les specs à l'ouverture, le paragraphe « The gaps register is not a spec », la réservation et les deux catégories du register — c'est la conduite de l'ouverture, que le lot donne à `opening-a-batch` — si c'est faux, ces textes sont à extraire une seconde fois.
- Ruling: `closing-a-batch` perd sa copie de la règle du document sans état, garde ce que la clôture fait du document, et n'invoque pas `writing-a-batch-document` — elle retire des blocs et change le statut, sans écrire un champ — si c'est faux, la clôture modifie un document dont elle n'a pas la forme en contexte.
- Ruling: `writing-a-batch-document` dit « a story », « closing » et « an amendment » là où le texte nommait `supercharlouze:writing-a-user-story` et `supercharlouze:closing-a-batch` — une skill interne ne nomme aucune skill d'entrée — si c'est faux, un lecteur ne sait plus quelle skill transcrit un bloc ou clôt le lot.
- Ruling: deux phrases de `The Feature Flag Field` ne sont reprises nulle part : la raison pour laquelle le champ est examiné à l'ouverture, et le refus de `closing-a-batch` de clore un lot dont le flag survit sans portée déclarée, que seule la ligne de `Red Flags` rappelle — la première décrit la revue, la seconde ce que fait une autre skill — si c'est faux, celui qui déclare un flag ne sait plus ce que coûte une portée non déclarée.
- Ruling: la phrase sur `status: open | closed`, valeur de front matter en anglais, est retirée de `writing-a-batch-document` — `Language` du socle la porte, et la skill y renvoie — si c'est faux, un document de lot reçoit un statut traduit.
- Ruling: la section `Language` de `writing-a-batch` reste telle quelle, bien qu'elle cite les champs du document — elle recopie le socle comme celles des autres skills d'entrée, et ce n'est pas le texte que cette story extrait — si c'est faux, la règle de langue du document vit en deux endroits jusqu'à la réécriture de la skill.
- Ruling: le red flag de `using-batches` sur le champ `Feature flag` jamais vide reste — une phrase, que `Technical design` ne demande pas d'extraire — si c'est faux, il dérive de `writing-a-batch-document`.
- Ruling: `Amending a Batch` s'ouvre toujours sur « The batch document carries no mutable state, but it stays amendable » — c'est l'entrée en matière de l'amendement, pas la règle — si c'est faux, la garde négative sur la règle ne voit pas cette reformulation.
- Ruling: la garde de `tests/test-skill-contracts.sh` sur l'invocation de `writing-a-batch-document` passe si une seule des deux invocations subsiste — `tests/test-skill-content.sh` tient chacune des deux phrases en entier — si c'est faux, la perte d'une invocation ne fait échouer qu'un fichier de test.
- Ruling: la garde négative sur la forme du document chasse douze formules, pas toutes les normes extraites — un motif plus large toucherait des phrases légitimes, comme « The specs are the registry of flags » dans `closing-a-batch` — si c'est faux, une copie d'une norme non chassée passe la suite.
- Ruling: les deux corrections de la relecture finale ont été relues par qui conduit l'exécution, sur leur diff, sans seconde relecture par un sous-agent — elles tiennent en deux hunks dictés mot pour mot — si c'est faux, une régression de ces deux hunks n'a été vue par personne d'autre.
- Ruling: les sous-agents ont travaillé sans charger `following-the-rules`, que la version installée du plugin ne porte pas encore — leurs consignes recopiaient les règles qui valaient pour leur tâche — si c'est faux, une règle d'exécution du socle n'a pas été suivie.

## Observed drift
