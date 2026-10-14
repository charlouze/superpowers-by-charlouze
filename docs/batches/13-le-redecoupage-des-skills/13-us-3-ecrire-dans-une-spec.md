# L'extraction de writing-in-a-spec Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La skill interne `writing-in-a-spec` porte ce qu'une spec contient, et les skills qui écrivent dans une spec l'invoquent à la place de leur copie.

**Architecture:** `writing-in-a-spec` reçoit de `using-batches` la section `What a Spec Says` et les lignes de `Red Flags` qui s'y rattachent. `using-batches`, `adopting-a-module`, `writing-a-batch` et `writing-a-user-story` l'invoquent là où elles écrivent un texte de spec, et ne gardent que ce qui est propre à leur étape. Les gardes du texte suivent le texte, et le contrat `shared` sur la question du test devient une garde sur `writing-in-a-spec` et une garde sur chaque skill qui l'invoque.

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

Une skill est écrite en anglais, se termine par des fins de ligne LF et suit les
règles d'écriture du `CLAUDE.md` du dépôt.

Une skill ne cite aucune section de `docs/specs/supercharlouze.md`.

Une garde déplacée garde son libellé et son aiguille ; aucune garde n'est
supprimée sans une garde qui la remplace.

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

- Une skill qui écrit un texte de spec et n'invoque plus rien : un agent écrit
  alors dans une spec sans avoir lu ce qu'elle contient. La garde de la tâche 2
  cherche l'invocation dans chacune des quatre skills.
- Une copie de la question du test qui survit hors de `writing-in-a-spec` : la
  garde négative de la tâche 2 parcourt toutes les skills déclarées.
- Une garde du texte extrait restée pointée sur `using-batches` : elle échoue dès
  que la section en sort, et la tâche 1 la repointe.
- `writing-in-a-spec` qui nomme une skill qui l'invoque : la garde de la tâche 1
  cherche le nom de chaque skill d'entrée déclarée.
- Une fin de ligne CRLF dans le nouveau `SKILL.md` : la garde de forme interne
  échoue sur `user-invocable: false`.

---

### Task 1: `writing-in-a-spec` porte ce qu'une spec contient

**Files:**
- Create: `skills/writing-in-a-spec/SKILL.md`
- Modify: `skills/using-batches/SKILL.md` (section `What a Spec Says`, règle (a) de `Bounded`, trois lignes de `Red Flags`)
- Modify: `tests/skills.txt`
- Modify: `tests/test-skill-content.sh` (bloc `using-batches: what a spec says` et gardes ADR qui visent le texte déplacé)
- Modify: `tests/test-skill-contracts.sh` (trois listes de skills)
- Modify: `tests/test-cross-references.sh` (ligne du `README`)
- Modify: `README.md` (tableau des skills)

**Interfaces:**
- Consumes: `require`, `shared`, `absent`, `declared_skills` de `tests/lib.sh`.
- Produces: la skill `supercharlouze:writing-in-a-spec`, déclarée `internal`, dont le corps porte la section `## What a Spec Says` et la table `## Red Flags`. La tâche 2 s'appuie sur ce nom et sur la phrase `read this sentence as true of their code` qu'elle porte.

- [ ] **Step 1: Déclarer la skill et repointer les gardes**

Dans `tests/skills.txt`, ajouter après la ligne `recording-a-decision internal` :

```
writing-in-a-spec internal
```

Dans `tests/test-skill-content.sh`, le bloc qui commence par le commentaire
`# --- using-batches: what a spec says (spec section "The spec document") ---`
devient `# --- writing-in-a-spec: what a spec says (spec section "The spec document") ---`,
et chaque ligne `require using-batches` de ce bloc devient `require writing-in-a-spec`,
libellé et aiguille inchangés. La ligne `require following-the-rules "the glossary states the content property"`
du même bloc reste telle quelle.

Plus bas dans le même fichier, ces quatre gardes passent de `require using-batches`
à `require writing-in-a-spec`, libellé et aiguille inchangés :

- `"a decision with nothing observable has the ADR for outlet"` ;
- `"a decision housed outside the specs goes to an ADR"` ;
- `"the scope paragraph names both outlets"` ;
- `"the red flag names the ADR as the outlet"`.

Ajouter à la fin du bloc `writing-in-a-spec: what a spec says` :

```bash
require writing-in-a-spec "red flag: rewording a mechanism into a rule" \
    "| \"The delta names a mechanism — I'll reword it into a business rule\" | That is the laundering this rule exists to stop"
require writing-in-a-spec "red flag: a number nobody can answer for" \
    "| \"I can't say where this number came from, I'll write 'a few minutes'\" | Vagueness is not prudence"
require writing-in-a-spec "says when to go back to the step that invoked it" \
    "Once the text is written, go on with the step that invoked this skill."
absent "using-batches no longer carries what a spec contains" \
    "## What a Spec Says|The other-implementation test|Four signs recognise it|Naming is not mechanising" \
    using-batches
require using-batches "a bounded change invokes writing-in-a-spec before writing in a spec" \
    "When it updates a spec, invoke \`supercharlouze:writing-in-a-spec\` before writing in it"

# An internal skill names the skills it invokes, never those that invoke it.
# Walks the declared entry skills, so one declared later is covered.
entry_names="$(declared_skills entry | tr '\n' '|')"
absent "writing-in-a-spec names no skill that invokes it" "${entry_names%|}" writing-in-a-spec
```

Dans `tests/test-skill-contracts.sh` :

- dans la garde `shared "whoever writes into a spec spells the other-implementation test identically"`,
  la liste `using-batches writing-a-user-story adopting-a-module` devient
  `writing-in-a-spec writing-a-user-story adopting-a-module` ;
- dans la garde `shared "a rule belongs to exactly one spec"`, la liste
  `using-batches adopting-a-module writing-a-batch writing-a-user-story` devient
  `writing-in-a-spec adopting-a-module writing-a-batch writing-a-user-story` ;
- dans la garde `absent "no skill denies a spec every marker"`, la liste
  `using-batches following-the-rules adopting-a-module` devient
  `using-batches following-the-rules adopting-a-module writing-in-a-spec`.

Dans `tests/test-cross-references.sh`, ajouter après le bloc qui teste `DROW`
(la ligne du `README` de `recording-a-decision`) :

```bash
# The README row of writing-in-a-spec, like the other internal skills', says it
# is not for direct use and names none of the skills that invoke it.
WROW="$(grep -F '`supercharlouze:writing-in-a-spec`' "$REPO_ROOT/README.md" || true)"
case "$WROW" in
    *"using-batches"*|*"writing-a-batch"*|*"writing-a-user-story"*|*"adopting-a-module"*|*"invoked by"*)
        fail "the README row of writing-in-a-spec names no caller" ;;
    *)  pass "the README row of writing-in-a-spec names no caller" ;;
esac
case "$WROW" in
    *"Never directly"*) pass "the README row of writing-in-a-spec rules out direct use" ;;
    *)                  fail "the README row of writing-in-a-spec rules out direct use" ;;
esac
```

- [ ] **Step 2: Lancer les tests et les voir échouer**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh; bash tests/test-cross-references.sh; bash tests/test-skill-frontmatter.sh`
Expected: FAIL sur chaque garde `writing-in-a-spec:`, sur `writing-in-a-spec/SKILL.md exists`, sur `using-batches no longer carries what a spec contains`, sur l'invocation par le changement borné et sur `the README row of writing-in-a-spec rules out direct use`.

- [ ] **Step 3: Créer `skills/writing-in-a-spec/SKILL.md`**

Le fichier s'ouvre sur ce front matter et cette introduction, exactement :

```markdown
---
name: writing-in-a-spec
description: Use only when a skill tells you to invoke writing-in-a-spec, never on a request to write or correct a spec - carries what a spec contains, which every sentence passes before it goes into a spec file
user-invocable: false
---

# Writing in a Spec

## Overview

This skill carries what a spec contains. Apply it to every sentence you are
about to write into a spec file.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the writing-in-a-spec skill to check what goes into this spec."

Once the text is written, go on with the step that invoked this skill.
```

Suit la section `## What a Spec Says` de `skills/using-batches/SKILL.md`, de son
titre jusqu'au paragraphe `**Scope.**` compris, déplacée sans changer un mot.

Le fichier se termine par cette section, dont les trois lignes de table sont
celles que `Red Flags` de `using-batches` porte aujourd'hui, déplacées sans
changer un mot : celle qui commence par `"The delta names a mechanism`, celle qui
commence par `"I can't say where this number came from` et celle qui commence par
`"This rule holds for every module`.

```markdown
## Red Flags

| Thought | Reality |
|---------|---------|
```

Vérifier les fins de ligne : `grep -c $'\r' skills/writing-in-a-spec/SKILL.md` rend `0`.

- [ ] **Step 4: Réécrire `skills/using-batches/SKILL.md`**

Supprimer la section `## What a Spec Says` entière, de son titre jusqu'au
paragraphe `**Scope.**` compris : `## What Is Kept, What Is Rerouted` suit alors
la table de routage.

Supprimer de `## Red Flags` les trois lignes déplacées au Step 3.

Dans la règle `**(a)**` de `Bounded`, ajouter à la fin du paragraphe, après
`which canonises the drift it describes.` :

```markdown
 When it updates a spec, invoke `supercharlouze:writing-in-a-spec` before writing in it: that skill carries what a spec contains.
```

- [ ] **Step 5: Mettre à jour le tableau des skills du `README.md`**

La ligne de `using-batches` devient :

```markdown
| `supercharlouze:using-batches` | Entry point — routing, declared overrides |
```

Ajouter après la ligne de `supercharlouze:recording-a-decision` :

```markdown
| `supercharlouze:writing-in-a-spec` | Never directly — a building block the other skills invoke before writing into a spec |
```

- [ ] **Step 6: Lancer la suite entière**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`, aucune ligne `[FAIL]`. Une garde `require using-batches`
qui échoue parce que son aiguille vit dans le texte déplacé se repointe sur
`writing-in-a-spec`, libellé et aiguille inchangés ; aucune n'est supprimée.

- [ ] **Step 7: Commit**

```bash
git add skills/writing-in-a-spec skills/using-batches/SKILL.md tests README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la skill interne writing-in-a-spec porte ce qu'une spec contient" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: les skills qui écrivent un texte de spec invoquent `writing-in-a-spec`

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md` (section `Source Authority`, étape `### 4. Write the spec from those documents only`)
- Modify: `skills/writing-a-user-story/SKILL.md` (paragraphe `**What the spec change may contain.**`)
- Modify: `skills/writing-a-batch/SKILL.md` (section `The Batch Document`, avant `**A block is the unit of the delta.**`)
- Modify: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la skill `supercharlouze:writing-in-a-spec` de la tâche 1, qui porte `read this sentence as true of their code` et `A rule belongs to exactly one spec.` ; la phrase de `using-batches` `When it updates a spec, invoke \`supercharlouze:writing-in-a-spec\` before writing in it`.
- Produces: rien qu'une tâche suivante consomme.

- [ ] **Step 1: Remplacer les contrats `shared` par les gardes**

Dans `tests/test-skill-contracts.sh`, le commentaire qui commence par
`# The content rule lives in one place, \`using-batches\`.` et la garde
`shared "whoever writes into a spec spells the other-implementation test identically"`
qui le suit sont remplacés par :

```bash
# What a spec contains lives in one place, `writing-in-a-spec`. A skill that
# writes a text a spec receives invokes it and restates nothing: a second
# formulation of the same rule is what drifts. `adopting-a-module` writes a
# spec's first version, `writing-a-batch` the blocks a spec will receive,
# `writing-a-user-story` their transcription, and `using-batches` carries the
# bounded change. `closing-a-batch` writes into no spec file.
require writing-in-a-spec "states the question of the other-implementation test" \
    "read this sentence as true of their code"
for s in using-batches adopting-a-module writing-a-batch writing-a-user-story; do
    require "$s" "invokes writing-in-a-spec before writing a text a spec receives" \
        "nvoke \`supercharlouze:writing-in-a-spec\` before"
done
# The question is spelled in the skill that carries it and nowhere else. Walks
# the declared skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill spells the question of the other-implementation test" \
    "read this sentence as true of their code" \
    $(declared_skills | grep -vx writing-in-a-spec)

# The test has one name. The reading a spec reader receives is written in full
# in `rereading-a-spec`, since a reader loads no skill, and it names the test as
# the skill that carries it does.
shared "the other-implementation test bears one name" \
    "other-implementation test" \
    writing-in-a-spec rereading-a-spec adopting-a-module
```

Dans le même fichier, le commentaire qui commence par `# One home per rule: the norm is stated in the four skills`
et la garde `shared "a rule belongs to exactly one spec"` qui le suit sont
remplacés par :

```bash
# One home per rule: `writing-in-a-spec` states that a rule belongs to exactly
# one spec, and the skills that invoke it keep only what their own step does
# when a rule reaches past one module.
require writing-in-a-spec "a rule belongs to exactly one spec, stated where it lives" \
    "**A rule belongs to exactly one spec.** A rule that would constrain behaviour observable at the boundary of more than one module is not a rule looking for a home"
```

- [ ] **Step 2: Lancer le test et le voir échouer**

Run: `bash tests/test-skill-contracts.sh`
Expected: FAIL sur `invokes writing-in-a-spec before writing a text a spec receives` pour `adopting-a-module`, `writing-a-batch` et `writing-a-user-story`, et sur `no other skill spells the question of the other-implementation test (present in: adopting-a-module writing-a-user-story)`.

- [ ] **Step 3: Réécrire `skills/adopting-a-module/SKILL.md`**

Dans `Source Authority`, le paragraphe qui commence par
`**And you do not read *through* a mechanism to deduce the intention it served.**`
devient, en entier :

```markdown
**And you do not read *through* a mechanism to deduce the intention it served.**
Adoption is where that is most tempting: a validated document describes a
mechanism, the intention behind it looks one paraphrase away, and it is not.
What a document states as an intention is normative and goes in; what it
states as a mechanism becomes a gap. Deducing an intention from a mechanism is
reconstruction from the code by another road, whether you read that mechanism in
the code or in a validated document. An intention comes from a validated document
or from your human partner.
```

Dans `### 4. Write the spec from those documents only`, le paragraphe
`Merge, deduplicate, reconcile. The spec is normative — what the code must do — not descriptive.`
est suivi d'un paragraphe neuf, avant la liste :

```markdown
**Invoke `supercharlouze:writing-in-a-spec` before writing the first sentence.**
It carries what a spec contains, and the other-implementation test.
```

Le reste de l'étape ne change pas.

- [ ] **Step 4: Réécrire `skills/writing-a-user-story/SKILL.md`**

Le début du paragraphe `**What the spec change may contain.**`, jusqu'à
`read this sentence as true of their code?*` compris, soit :

```markdown
**What the spec change may contain.** The transcription applies the content rule of
`supercharlouze:using-batches` — a spec carries business rules and intentions,
the mechanism stays in the code — to every sentence it writes. Ask it of each:
*would another developer, having implemented the same intention differently,
read this sentence as true of their code?* The delta was written by a human at
```

devient :

```markdown
**What the spec change may contain.** Invoke `supercharlouze:writing-in-a-spec`
before transcribing a block, and apply what it carries to every sentence you
write. The delta was written by a human at
```

La suite du paragraphe ne change pas.

- [ ] **Step 5: Réécrire `skills/writing-a-batch/SKILL.md`**

Dans `The Batch Document`, ajouter un paragraphe neuf juste avant celui qui
commence par `**A block is the unit of the delta.**` :

```markdown
**Invoke `supercharlouze:writing-in-a-spec` before writing a block.** A block is
the exact text a spec will receive, so what a spec contains holds for every
sentence of it.
```

- [ ] **Step 6: Lancer la suite entière**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`, aucune ligne `[FAIL]`.

Run: `grep -rn "content rule of" skills/`
Expected: aucune ligne.

- [ ] **Step 7: Commit**

```bash
git add skills tests
bash ~/.config/github-app/as-agent.sh git commit -m "feat: les skills qui écrivent un texte de spec invoquent writing-in-a-spec" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

Ruling: `writing-a-batch` invoque `writing-in-a-spec` avant d'écrire un bloc, alors qu'elle ne renvoyait à aucune règle de contenu — jusqu'à cette story le texte vivait dans `using-batches`, que celui qui ouvre un lot a chargée, et un bloc est le texte exact qu'une spec reçoit — si c'est faux, l'ouverture d'un lot charge une skill de trop et un paragraphe de `writing-a-batch` est à retirer.

Ruling: la story reste technique — la spec dit ce qu'une spec contient et ne dit pas quelle skill le porte, donc déplacer ce texte et l'invoquer ne change rien de ce qu'elle décrit — si c'est faux, la story est à requalifier et le lot à amender.

Ruling: les paragraphes de `adopting-a-module`, `writing-a-batch` et `writing-a-user-story` qui s'ouvrent sur « A rule belongs to exactly one spec. » restent — chacun porte ce que fait son étape quand une règle déborde d'un module, et la règle est écrite en entier dans `writing-in-a-spec` — si c'est faux, trois reformulations partielles de la règle continuent de dériver jusqu'aux stories qui extraient ces skills.

Ruling: la lecture de `rereading-a-spec` sur ce qu'une spécification doit tenir reste telle quelle, tenue à `writing-in-a-spec` par le seul nom du test — elle est écrite pour un lecteur qui ne charge aucune skill et n'a jamais été une copie mot pour mot du texte extrait — si c'est faux, la lecture et la skill dérivent sans qu'une garde le montre.

Ruling: la phrase « It is invoked by another skill, never on a request of your human partner. » de `writing-in-a-spec` reste, bien qu'elle redise la description — les autres skills internes portent la même — si c'est faux, une phrase est à couper.

Ruling: la ligne de `Red Flags` déplacée dans `writing-in-a-spec` garde « record a `Ruling:` », qui ne désigne rien dans une adoption ni dans un changement borné — une extraction déplace un texte sans le changer — si c'est faux, un agent qui adopte un module lit une consigne qu'il ne peut pas suivre.

## Observed drift
