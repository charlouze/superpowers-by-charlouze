# 09-us-2 — La story technique

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/09-quand-aucune-regle-ne-bouge/README.md
**Sections:** The model, Departures from superpowers, Batch > Amending a batch, Story > The user story document, Story > Delivering a story, Feature flags
**Blocks:** D1, D2, D4, D5, D7, D12, D13, D23

**Goal:** Mettre les skills en conformité avec la spec que le premier commit de
cette branche a livrée : une story qui ne change rien d'observable à la frontière
de son module se déclare technique, et une condition d'arrêt rattrape cette
qualification quand elle se révèle fausse.

**Architecture:** Le code de ce dépôt, ce sont les cinq skills de `skills/`, le
`README.md` qui les présente, et la suite d'assertions de `tests/` qui les tient.
La modification de spec est déjà commitée ; chaque tâche ci-dessous prend une
pièce de la norme nouvelle — le terme, sa condition d'arrêt, sa déclaration, son
passage aux implémenteurs, l'exemption de flag qu'elle rend documentable, et ce
qui suit son déclenchement —, écrit les assertions qui la constatent, puis
corrige le texte des skills jusqu'à ce qu'elles passent.

**Tech Stack:** Markdown ; Bash pour les assertions (`tests/run-all.sh`).

## Global Constraints

**Contraintes du lot** — section `Constraints` du document de lot, recopiée mot
pour mot :

> **Ordre des blocs.** `D1` pose le seul terme neuf et précède donc `D4`, `D5`, `D7`,
> `D12` et `D13`. `D12` précède `D7` et `D13`, qui renvoient tous deux à la condition
> d'arrêt qu'il écrit. Tous les autres sont indépendants.
>
> **Six sections portent plusieurs blocs, dont l'ordre entre eux est libre** : leurs
> ancres sont disjointes. `The model` (`D1`, `D2`), `Authority and conflict rules`
> (`D9`, `D17`, `D18`), `Batch > Amending a batch` (`D11`, `D13`), `Story > The user
> story document` (`D5`, `D6`, `D7`), `Bounded change` (`D15`, `D16`), `Batch >
> Opening a batch` (`D21`, `D22`).
>
> **Une seule pull request est en vol** : la clôture du lot 08. Elle écrit une ligne
> de changelog au pied de la spec et consolide dans le gaps register — aucun passage
> que ce lot cite, mais l'annotation `reserved by batch-09` vit dans ce même fichier
> de registre, où un conflit de fusion git est possible. Il se résout sur la branche
> de la story.

**Gel du fichier de spec :**

> Entre le premier commit de la branche et l'ouverture de la pull request, aucune
> tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit
> changer s'arrête.

**Règle d'autorité :** quand le lot et la spec se contredisent, **la spec gagne,
sans exception et sans délibération**. Implémente ce que dit la spec, consigne un
`Ruling:`, et continue. **Corriger une spec en cours de lot est un acte humain,
jamais un acte d'agent.**

**Langue :** ossature anglaise, prose dans la langue du projet — et le plugin
lui-même est intégralement anglais. Tout ce qui s'écrit sous `skills/`,
`README.md` et `tests/` est donc en anglais, commentaires de test compris.

---

## Files

- `skills/using-batches/SKILL.md` — le modèle (le terme, la définition du lot),
  l'Override 2 (les conditions d'arrêt), le critère d'exemption de flag.
- `skills/writing-a-user-story/SKILL.md` — l'en-tête du document de story, les
  `Global Constraints`, et l'étape 5 où la condition d'arrêt se déclenche.
- `skills/writing-a-batch/SKILL.md` — le critère d'exemption de flag, et la
  requalification d'une story technique.
- `README.md` — le modèle et les quatre écarts, tels qu'un lecteur humain les lit.
- `tests/test-skill-content.sh` — les assertions par skill.
- `tests/test-skill-contracts.sh` — les assertions qui tiennent deux skills
  ensemble sur un texte identique.
- `tests/test-declared-overrides.sh` — les assertions sur les quatre écarts
  déclarés, côté skill et côté bloc `CLAUDE.md`.

---

### Task 1: Le terme entre dans le modèle

Blocs `D1` et `D2`. Le modèle de `using-batches` gagne la story technique, et la
définition du lot cesse de promettre du comportement : un lot dont toutes les
stories sont techniques n'en ajoute aucun.

**Files:**
- Modify: `skills/using-batches/SKILL.md` (section `## The Model`)
- Modify: `README.md` (liste `### The model`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Produces: le terme `Technical story` et sa définition, que les tâches 2 à 6
  citent sans le redéfinir.

- [ ] **Step 1: Write the failing assertions**

Dans `tests/test-skill-content.sh`, immédiatement après le groupe
`# --- using-batches: the delta block (spec section "The model") ---` et ses
assertions, ajouter :

```bash
# --- using-batches: the technical story (spec section "The model") ---
require using-batches "defines the technical story" \
    "**Technical story** — a story that changes nothing observable at its module's boundary."
require using-batches "the qualification is declared" \
    "a declared qualification, caught by its stop condition if it turns out to be false"
require using-batches "a batch no longer promises behaviour" \
    "It groups several user stories, and targets one or more specs."
```

- [ ] **Step 2: Run the assertions to verify they fail**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL on the three new labels — `using-batches: defines the technical
story`, `using-batches: the qualification is declared`, `using-batches: a batch
no longer promises behaviour`.

- [ ] **Step 3: Write the model entries**

Dans `skills/using-batches/SKILL.md`, remplacer la définition du lot :

```markdown
**Batch** — the delivery unit, at `docs/batches/NN-<slug>/`. It groups several user stories, and exists to add behaviour to one or more specs. A batch may cut across modules.
```

par :

```markdown
**Batch** — the delivery unit, at `docs/batches/NN-<slug>/`. It groups several user stories, and targets one or more specs. A batch may cut across modules.
```

puis ajouter, immédiatement après l'entrée `**User story**` et avant
`**Corrective batch**` :

```markdown
**Technical story** — a story that changes nothing observable at its module's boundary. A dependency bump, an internal rename, a preparatory refactor are technical: no rule moves, so no block is transcribed. It is a declared qualification, caught by its stop condition if it turns out to be false.
```

- [ ] **Step 4: Follow the reading guide**

Dans `README.md`, section `### The model`, remplacer la puce du lot :

```markdown
- **Batch** — the delivery unit, at `docs/batches/NN-<slug>/`. It groups stories
  and exists to make specs grow. Its document carries, in blocks, the exact text
  those specs will receive.
```

par :

```markdown
- **Batch** — the delivery unit, at `docs/batches/NN-<slug>/`. It groups stories
  and targets one or more specs. Its document carries, in blocks, the exact text
  those specs will receive.
```

puis ajouter, immédiatement après la puce `**User story**` :

```markdown
- **Technical story** — a story that changes nothing observable at its module's
  boundary: a dependency bump, an internal rename, a preparatory refactor. It
  declares the qualification, and a stop condition catches it if it is false.
```

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/using-batches/SKILL.md README.md tests/test-skill-content.sh
git commit -m "feat: le modèle nomme la story technique"
```

---

### Task 2: La condition d'arrêt de la story technique

Bloc `D12`. L'Override 2 cesse d'être la cinquième condition d'arrêt du seul lot
correctif : le flux en ajoute deux, et un arbitrage ne remplace ni l'une ni
l'autre.

**Files:**
- Modify: `skills/using-batches/SKILL.md` (`### Override 2`)
- Modify: `README.md` (`### The four departures`, écart 2)
- Test: `tests/test-declared-overrides.sh`, `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: le terme `Technical story` (Task 1).
- Produces: le texte exact de la condition d'arrêt de la story technique, que la
  Task 4 recopie mot pour mot dans `writing-a-user-story` et que la Task 6 cite
  comme déclencheur.

- [ ] **Step 1: Write the failing assertions**

Dans `tests/test-declared-overrides.sh`, remplacer :

```bash
check_verb "the stop conditions are extended, not restated" \
    "This plugin adds one, for corrective batches only" \
    "extends the stop conditions of superpowers:subagent-driven-development"
```

par :

```bash
check_verb "the stop conditions are extended, not restated" \
    "This plugin adds two" \
    "extends the stop conditions of superpowers:subagent-driven-development"
```

et, plus bas, remplacer le commentaire :

```bash
# "fifth" alone is satisfied by the heading of Override 2 ("fifth stop condition"),
# so the needle is a fragment of the prohibition itself.
```

par :

```bash
# "fifth" alone is satisfied by the count of the overrides themselves, so the
# needle is a fragment of the prohibition itself.
```

Dans `tests/test-skill-content.sh`, à la suite des assertions ajoutées par la
Task 1, ajouter :

```bash
require using-batches "a technical story has a stop condition too" \
    "you discover that it changes something observable at the module's boundary, stop. The story is no longer technical."
require using-batches "a ruling replaces neither condition" \
    "A ruling replaces neither of them"
```

- [ ] **Step 2: Run the assertions to verify they fail**

Run: `bash tests/test-declared-overrides.sh; bash tests/test-skill-content.sh`
Expected: FAIL on `using-batches states what the override does: the stop
conditions are extended, not restated`, `using-batches: a technical story has a
stop condition too`, and `using-batches: a ruling replaces neither condition`.

- [ ] **Step 3: Rewrite Override 2**

Dans `skills/using-batches/SKILL.md`, remplacer le titre et les deux premiers
paragraphes de l'Override 2 :

```markdown
### Override 2 — fifth stop condition (corrective batches)

`superpowers:subagent-driven-development` states *"Four things stop you, and only these"*. This plugin adds one, for corrective batches only:

> If, while bringing code into conformance with a spec, you discover that it is the **spec** that is wrong and the code that is right, stop. The batch is no longer corrective and must be requalified.

Justification: the four conditions assume a valid authority exists. Here the authority itself is what is in question, and an agent may not correct a spec.
```

par :

```markdown
### Override 2 — the stop conditions the flow adds

`superpowers:subagent-driven-development` states *"Four things stop you, and only these"*. This plugin adds two. For corrective batches only:

> If, while bringing code into conformance with a spec, you discover that it is the **spec** that is wrong and the code that is right, stop. The batch is no longer corrective and must be requalified.

For a technical story only:

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

A ruling replaces neither of them. A ruling is a decision an agent takes on its human partner's behalf, and neither of these is an agent's to take: the first would correct a spec, the second would keep a qualification the story has just lost. Recording one and carrying on is exactly the failure both conditions exist to prevent.

Justification: the four native conditions assume a valid authority exists, and assume the story is the story it says it is. The first is what a corrective batch puts in question; the second is what a technical story puts in question — "purely technical" is otherwise the door through which behaviour enters with no gate behind it, since a story that transcribes no block passes no opening review.
```

- [ ] **Step 4: Follow the reading guide**

Dans `README.md`, section `### The four departures`, remplacer l'écart 2 :

```markdown
2. **A corrective batch has one more stop condition.** If the code turns out to
   be right and the spec wrong, the batch is no longer corrective and must be
   requalified. An agent may not correct a spec.
```

par :

```markdown
2. **The flow adds two stop conditions.** If the code turns out to be right and
   the spec wrong, a corrective batch is no longer corrective and must be
   requalified. If a story declared technical turns out to change something
   observable at its module's boundary, it is no longer technical. An agent may
   neither correct a spec nor keep a qualification it has lost.
```

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/using-batches/SKILL.md README.md tests/test-declared-overrides.sh tests/test-skill-content.sh
git commit -m "feat: une story technique qui se dément s'arrête"
```

---

### Task 3: La story déclare sa qualification

Blocs `D5` et `D23`. L'en-tête du document de story gagne `Technical: yes`, et
l'énumération des cas `Blocks: none` gagne la story technique.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (`## Step 4 — Write the Plan`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: le terme `Technical story` (Task 1).
- Produces: le champ `Technical: yes`, que la Task 4 prend comme déclencheur du
  sixième élément des `Global Constraints`.

- [ ] **Step 1: Write the failing assertions**

Dans `tests/test-skill-content.sh`, dans le groupe
`# --- writing-a-user-story`, à la suite de
`require writing-a-user-story "teardown story exists"`, ajouter :

```bash
require writing-a-user-story "a technical story declares itself" \
    "**A technical story carries \`Technical: yes\` in its header**"
require writing-a-user-story "a technical story touches no section" \
    "its \`Sections:\` is \`none\`"
require writing-a-user-story "no other story carries that field" \
    "No other story carries that field"
require writing-a-user-story "Blocks none covers the technical story" \
    "a corrective batch's story, a technical story, a teardown story"
```

- [ ] **Step 2: Run the assertions to verify they fail**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL on the four new labels.

- [ ] **Step 3: Extend the header**

Dans `skills/writing-a-user-story/SKILL.md`, `## Step 4 — Write the Plan`,
remplacer :

```markdown
Call `superpowers:writing-plans`. The plan **is** the story document: save it
into the batch directory, and extend the standard header with four fields.
```

par :

```markdown
Call `superpowers:writing-plans`. The plan **is** the story document: save it
into the batch directory, and extend the standard header with four fields — five
on a technical story.
```

- [ ] **Step 4: Say what a technical story declares**

Toujours dans `## Step 4`, remplacer :

```markdown
`Blocks:` declares the blocks of the spec delta this story transcribes — the
`D<n>` identifiers the batch document defines — and it is what
`supercharlouze:closing-a-batch` reads to find the blocks nobody delivered. It is
`none` for a story that transcribes none: a corrective batch's story, a teardown
story. Write it even though the blocks are already committed by now, because
Step 3's commit says what the spec received, and this field says which blocks
this story answered for — which is the question closing asks.
```

par (le bloc de remplacement contient lui-même une clôture ``` : la citation
ci-dessous est donc délimitée par quatre backticks, et ce sont les trois
backticks intérieurs qui s'écrivent dans la skill) :

````markdown
`Blocks:` declares the blocks of the spec delta this story transcribes — the
`D<n>` identifiers the batch document defines — and it is what
`supercharlouze:closing-a-batch` reads to find the blocks nobody delivered. It is
`none` for a story that transcribes none: a corrective batch's story, a technical
story, a teardown story. Write it even though the blocks are already committed by
now, because Step 3's commit says what the spec received, and this field says
which blocks this story answered for — which is the question closing asks.

**A technical story carries `Technical: yes` in its header**, and touches no
section: its `Sections:` is `none`. No other story carries that field — an
absent field is the ordinary case, so nothing has to be written to say "not
technical", and the qualification is visible wherever it is claimed.

```markdown
**Spec:** docs/specs/facturation.md
**Batch:** docs/batches/07-facturation-recurrente/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes
```

The qualification is yours to declare and nobody else's to check at this point:
what catches a false one is the stop condition, in `Global Constraints` below,
and it fires during the implementation rather than here.
````

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh
git commit -m "feat: une story technique porte sa qualification dans son en-tête"
```

---

### Task 4: Global Constraints porte la condition jusqu'aux implémenteurs

Bloc `D7`. La liste des `Global Constraints` perd son compte et gagne un
sixième élément : les sous-agents de SDD ne lisent rien d'autre.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (liste des `Global Constraints`
  et le bloc qui écrit la condition en entier)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: le texte exact de la condition d'arrêt (Task 2), le champ
  `Technical: yes` (Task 3).

- [ ] **Step 1: Write the failing assertions**

Dans `tests/test-skill-content.sh`, groupe
`# --- writing-a-user-story: what Global Constraints carries`, remplacer :

```bash
require writing-a-user-story "GC counts five things"              "carries five things"
require writing-a-user-story "GC carries the fifth stop condition" "the fifth stop condition of Step 5, written out in full"
```

par :

```bash
require writing-a-user-story "GC carries the corrective stop condition" "the stop condition proper to a corrective batch, written out in full"
require writing-a-user-story "GC carries the technical stop condition" "carries a sixth thing: the stop condition proper to a technical story"
require writing-a-user-story "GC lists a sixth item"              "6. **in a technical story only**, the stop condition proper to a technical story"
```

Dans `tests/test-skill-contracts.sh`, à la suite du bloc
`shared "the corrective stop condition is copied exactly as stated"`, ajouter :

```bash
# The technical story's stop condition travels the same way: `using-batches`
# states it and `writing-a-user-story` has it copied into a story's Global
# Constraints. Same argument as above — a copy that adds or drops a sentence is no
# longer the condition the spec names. One assertion over both ends.
shared "the technical stop condition is copied exactly as stated" \
    "If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical." \
    using-batches writing-a-user-story
```

- [ ] **Step 2: Run the assertions to verify they fail**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh`
Expected: FAIL on `writing-a-user-story: GC carries the corrective stop
condition`, `writing-a-user-story: GC carries the technical stop condition`,
`writing-a-user-story: GC lists a sixth item`, and `the technical stop condition
is copied exactly as stated`.

- [ ] **Step 3: Open the list**

Dans `skills/writing-a-user-story/SKILL.md`, remplacer :

```markdown
`Global Constraints` — which `superpowers:writing-plans` defines as implicitly
part of every task's requirements — carries five things:

1. the constraints the batch imposes;
2. the freeze of the spec file;
3. the authority rule;
4. **in a corrective batch only**, the fifth stop condition;
5. **in a story that writes code guarded by a flag only**, the rules for code
   under a flag.
```

par :

```markdown
`Global Constraints` — which `superpowers:writing-plans` defines as implicitly
part of every task's requirements — carries:

1. the constraints the batch imposes;
2. the freeze of the spec file;
3. the authority rule;
4. **in a corrective batch only**, the stop condition proper to a corrective
   batch;
5. **in a story that writes code guarded by a flag only**, the rules for code
   under a flag;
6. **in a technical story only**, the stop condition proper to a technical
   story.
```

- [ ] **Step 4: Rename the corrective block**

Toujours dans le même fichier, remplacer :

```markdown
**In a corrective batch, `Global Constraints` carries a fourth thing: the fifth
stop condition of Step 5, written out in full.** Copy it verbatim, exactly as
`supercharlouze:using-batches` states it:
```

par :

```markdown
**In a corrective batch, `Global Constraints` carries a fourth thing: the stop
condition proper to a corrective batch, written out in full.** Copy it verbatim,
exactly as `supercharlouze:using-batches` states it:
```

- [ ] **Step 5: Write the technical block**

Toujours dans le même fichier, à la fin de la section `## Step 4 — Write the
Plan` — après le bloc des règles du code gardé et avant le paragraphe qui ordonne
de commiter le document de story —, ajouter :

```markdown
**In a technical story, `Global Constraints` carries a sixth thing: the stop
condition proper to a technical story, written out in full.** Copy it verbatim,
exactly as `supercharlouze:using-batches` states it:

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

The freeze above stops a task that finds the spec must change, and it is not this.
A technical story was written on the claim that nothing needed changing at all, so
nobody is looking at the spec when the claim fails: what fails is the
qualification the story carries, and losing it sends the work back to the opening
gate rather than forward. And the discovery happens inside SDD's implementer
subagents, whose only channel to this skill's rules is this list — a stop
condition stated to you and not written here never reaches the agent who has to
obey it.
```

- [ ] **Step 6: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 7: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
git commit -m "feat: les Global Constraints portent la condition d'arrêt technique"
```

---

### Task 5: La famille d'exemption de flag devient documentable

Bloc `D4`. « Refactor and infrastructure » nommait une famille qu'aucun champ
`Spec delta` ne pouvait porter ; elle cède la place au lot dont toutes les
stories sont techniques.

**Files:**
- Modify: `skills/using-batches/SKILL.md` (critère d'exemption)
- Modify: `skills/writing-a-batch/SKILL.md` (`## The Feature Flag Field`)
- Test: `tests/test-skill-contracts.sh`, `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: le terme `Technical story` (Task 1).

- [ ] **Step 1: Write the failing assertions**

Dans `tests/test-skill-contracts.sh`, à la suite du bloc
`shared "the technical stop condition is copied exactly as stated"`, ajouter :

```bash
# The three families that answer the exemption criterion by construction are
# listed in both skills. A family spelled two ways is a family a reader cannot
# claim: the batch document quotes the wording, and the opening review reads it.
# One assertion over both ends.
shared "the flag exemption names the technical batch identically" \
    "**A batch all of whose stories are technical** — none of them changes what is observable at its module's boundary" \
    using-batches writing-a-batch
```

Dans `tests/test-skill-content.sh`, à la fin du fichier et avant
`exit $((FAILURES > 0))`, ajouter :

```bash
# `Refactor and infrastructure` named a family no `Spec delta` field could carry:
# a batch of that kind has no block, and nothing said what its field held. Nothing
# may name it again — an assertion on the new family alone would stay green beside
# a leftover copy of the old one.
for s in using-batches writing-a-batch; do
    case "$(body_flat "$REPO_ROOT/skills/$s/SKILL.md")" in
        *"Refactor and infrastructure"*) fail "$s: the old exemption family is gone" ;;
        *)                               pass "$s: the old exemption family is gone" ;;
    esac
done
```

- [ ] **Step 2: Run the assertions to verify they fail**

Run: `bash tests/test-skill-contracts.sh; bash tests/test-skill-content.sh`
Expected: FAIL on `the flag exemption names the technical batch identically
(missing in: using-batches writing-a-batch)`, `using-batches: the old exemption
family is gone`, and `writing-a-batch: the old exemption family is gone`.

- [ ] **Step 3: Replace the family in using-batches**

Dans `skills/using-batches/SKILL.md`, remplacer :

```markdown
- **Refactor and infrastructure** — they change no behaviour, so every pull request is deployable as it stands. That is the definition of a refactor, not a tolerance granted to it.
```

par :

```markdown
- **A batch all of whose stories are technical** — none of them changes what is observable at its module's boundary, so every pull request is deployable as it stands. That is what the qualification means, not a tolerance granted to it.
```

- [ ] **Step 4: Replace the family in writing-a-batch**

Dans `skills/writing-a-batch/SKILL.md`, `## The Feature Flag Field`, remplacer :

```markdown
- **Refactor and infrastructure** — they change no behaviour, so every pull
  request is deployable as is. That is the definition of a refactor, not a
  tolerance granted to it.
```

par :

```markdown
- **A batch all of whose stories are technical** — none of them changes what is
  observable at its module's boundary, so every pull request is deployable as it
  stands. That is what the qualification means, not a tolerance granted to it.
```

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/using-batches/SKILL.md skills/writing-a-batch/SKILL.md tests/test-skill-contracts.sh tests/test-skill-content.sh
git commit -m "feat: l'exemption de flag nomme le lot dont toutes les stories sont techniques"
```

---

### Task 6: Ce qui suit le déclenchement

Bloc `D13`. Quand la condition d'arrêt se déclenche, la story est abandonnée, et
le changement observable — s'il est voulu — passe par un amendement qui repasse la
revue d'ouverture.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (`## Step 5 — Execute`)
- Modify: `skills/writing-a-batch/SKILL.md` (nouvelle section après
  `## Requalifying a Corrective Batch`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: le texte exact de la condition d'arrêt (Task 2), la famille
  d'exemption de flag (Task 5).

- [ ] **Step 1: Write the failing assertions**

Dans `tests/test-skill-content.sh`, ajouter aux groupes correspondants :

```bash
require writing-a-user-story "the technical condition hands off to writing-a-batch" \
    "**abandon the story**, then hand the decision to \`supercharlouze:writing-a-batch\`"
require writing-a-batch "requalifies a technical story" \
    "## Requalifying a Technical Story"
require writing-a-batch "an observable change needs a block" \
    "it needs a block, and a block is acquired by an amendment that goes back through the opening review"
require writing-a-batch "the lost qualification takes the exemption with it" \
    "declares one by that same amendment"
```

Le besoin en `require writing-a-batch "requalifies a technical story"` porte sur
un titre de section : `body_flat` aplatit les sauts de ligne, donc le `##` et son
libellé restent contigus dans l'aiguille.

- [ ] **Step 2: Run the assertions to verify they fail**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL on the four new labels.

- [ ] **Step 3: Rewrite the Override 2 paragraph of Step 5**

Dans `skills/writing-a-user-story/SKILL.md`, `## Step 5 — Execute`, remplacer :

```markdown
**Override 2 — fifth stop condition (corrective batches).** SDD states that
four things stop you and only these. In a corrective batch, this plugin adds
one: if, while bringing code into conformity with the spec, you discover that
the **spec** is wrong and the code is right, stop. The batch is no longer
corrective and must be requalified — **abandon the story**, then hand the
decision to `supercharlouze:writing-a-batch`. The four native
conditions assume a valid authority exists; here the authority itself is in
question, and an agent may not correct a spec.
```

par :

```markdown
**Override 2 — the stop conditions the flow adds.** SDD states that four things
stop you and only these. This plugin adds two, and each one ends the same way:
**abandon the story**, then hand the decision to
`supercharlouze:writing-a-batch`.

In a corrective batch: if, while bringing code into conformity with the spec, you
discover that the **spec** is wrong and the code is right, stop. The batch is no
longer corrective and must be requalified. The four native conditions assume a
valid authority exists; here the authority itself is in question, and an agent may
not correct a spec.

In a technical story, whatever its batch: if, while conducting it, you discover
that it changes something observable at the module's boundary, stop. The story is
no longer technical. The four native conditions also assume the story is the story
it says it is; here the qualification it was written under is what is in question,
and only your human partner may rule what follows — a block for the observable
change, and a flag if the batch was exempted because all of its stories were
technical.
```

- [ ] **Step 4: Repair the stale reference to the renamed override**

La Task 2 a renommé l'Override 2 ; `writing-a-batch` le désigne encore par son
ancien titre. Dans `skills/writing-a-batch/SKILL.md`,
`## Requalifying a Corrective Batch`, remplacer :

```markdown
**Trigger — Override 2, the fifth stop condition (corrective batches).** This
plugin adds a fifth stop condition to
`superpowers:subagent-driven-development`: while bringing code into conformance
with a spec, if a story discovers that the **spec** is wrong and the code is
right, it stops. The batch is no longer corrective and must be requalified. The
other four stop conditions assume a valid authority exists; here the authority
itself is in question, and no agent may correct a spec.
```

par :

```markdown
**Trigger — Override 2, the stop condition proper to a corrective batch.** This
plugin adds two stop conditions to
`superpowers:subagent-driven-development`, and this is the corrective one: while
bringing code into conformance with a spec, if a story discovers that the
**spec** is wrong and the code is right, it stops. The batch is no longer
corrective and must be requalified. The four native stop conditions assume a
valid authority exists; here the authority itself is in question, and no agent
may correct a spec.
```

- [ ] **Step 5: Write the requalification section**

Dans `skills/writing-a-batch/SKILL.md`, ajouter après la fin de
`## Requalifying a Corrective Batch` et avant `## Language` :

```markdown
## Requalifying a Technical Story

**Trigger — the stop condition of a technical story.** `supercharlouze:using-batches`
states it and `supercharlouze:writing-a-user-story` copies it into the
`Global Constraints` of every technical story: a story that discovers it changes
something observable at its module's boundary is no longer technical. It reaches
you already stopped, from inside `superpowers:subagent-driven-development`.

**Procedure.**

1. **Abandon the story**, exactly as a requalified corrective story is abandoned:
   this fires mid-implementation, so the usual situation is a branch and a
   worktree and **no pull request at all**. Close one without merging it only if
   it is already open, then delete the branch locally and on the remote and remove
   its worktree. Nothing reached `main`, so nothing has to be revoked — and a
   branch left on the remote reads as a live claim on its sections.
2. **Put the choice to the human**, who alone may rule. If they judge the
   observable change wanted, it needs a block, and a block is acquired by an
   amendment that goes back through the opening review — the exact text of a block
   is what that review reads, and a story that transcribes none never passes it.
3. **A batch exempted from a flag because all of its stories were technical
   declares one by that same amendment.** The exemption rested on the
   qualification the story has just lost; leaving it standing would ship
   observable behaviour with nothing guarding it, which is the whole of what the
   criterion prevents.

**Concluded by** the merge of the amendment pull request: the work is rewritten as
an ordinary story of the amended batch, with `supercharlouze:writing-a-user-story`.

If the human judges the observable change unwanted instead, there is nothing to
amend: the story is abandoned and the batch carries on as it was.
```

- [ ] **Step 6: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 7: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
git commit -m "feat: une story technique qui perd sa qualification passe par un amendement"
```

## Rulings log

## Observed drift
