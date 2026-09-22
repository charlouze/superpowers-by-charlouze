# 09-us-3 — L'ouverture sans bloc

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/09-quand-aucune-regle-ne-bouge/README.md
**Sections:** Batch > The batch document, Batch > The coherence reread, Batch > Opening a batch
**Blocks:** D3, D14, D21, D22

**Goal:** Mettre les skills en conformité avec la spec que le premier commit de
cette branche a livrée : l'ouverture d'un lot dont le champ `Spec delta` ne porte
aucun bloc a une forme, une revue et une étape de moins.

**Architecture:** Le code de ce dépôt, ce sont les cinq skills de `skills/` et la
suite d'assertions de `tests/` qui les tient. La modification de spec est déjà
commitée ; les quatre tâches ci-dessous prennent chacune un des quatre blocs
livrés, écrivent d'abord les assertions qui le constatent, les regardent échouer,
puis écrivent la prose qui les satisfait. Tout tient dans
`skills/writing-a-batch/SKILL.md`, seule skill qui rédige un document de lot et
conduit son ouverture, et dans `tests/test-skill-content.sh`, seul fichier de la
suite qui lise le corps d'une skill.

**Tech Stack:** Markdown (skills et specs), Bash (suite d'assertions), `git`.

## Global Constraints

Les contraintes que le lot impose, sa section `Constraints` recopiée mot pour mot :

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

Le gel du fichier de spec :

> Entre le commit de transcription et l'ouverture de la pull request, aucune tâche
> ne modifie le fichier de spec. Une story qui découvre que la spec doit changer
> s'arrête.

La règle d'autorité :

> Quand le lot et la spec se contredisent, **la spec gagne — sans exception et sans
> délibération**. Implémente ce que dit la spec, consigne un `Ruling:`, et continue.
> **Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.**

Deux contraintes propres à cette story, qui la bornent :

- **`docs/specs/supercharlouze.md` est déjà transcrit et n'est plus touché.** Les
  quatre blocs `D3`, `D14`, `D21`, `D22` sont dans le premier commit de la branche.
  Aucune tâche ne rouvre ce fichier.
- **Deux stories sœurs du même lot sont en vol** et tiennent d'autres sections.
  Aucune tâche ne modifie `skills/using-batches/SKILL.md` ni
  `skills/closing-a-batch/SKILL.md` : ce qui s'y trouve appartient à des sections
  que cette story ne tient pas, et ce qui y diverge se consigne sous
  **Observed drift**, jamais sous l'éditeur.

## Files

- Modify: `skills/writing-a-batch/SKILL.md` — les quatre endroits que les blocs
  visent : le gabarit et la prose du champ `Spec delta` (`## The Batch Document`),
  la liste ordonnée de l'ouverture (`## Opening, in Order`), l'entrée de
  `## The Coherence Reread`, et la relecture, le corps de pull request et la revue
  de `## Opening the Pull Request`.
- Modify: `tests/test-skill-content.sh` — les assertions qui constatent chacune de
  ces quatre normes. C'est le seul fichier de la suite qui lise le corps d'une
  skill ; `body_flat` aplatit les sauts de ligne en espaces, donc **toute aiguille
  s'écrit sur une seule ligne, avec un seul espace entre les mots**, quelle que
  soit la façon dont la prose visée est coupée.

---

### Task 1: Le champ `Spec delta` n'est jamais laissé blanc (D3)

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (gabarit `## Spec delta` ~l. 151-157 ;
  paragraphe « Corrective batch » ~l. 237-239 ; liste de relecture de
  `## Opening the Pull Request` ~l. 428-435)
- Test: `tests/test-skill-content.sh` (bloc `--- writing-a-batch: the batch
  document contract ---`, après la ligne `undelivered means nobody declared it`)

**Interfaces:**
- Consumes: rien.
- Produces: la formule `**The \`Spec delta\` field is never left blank.**` et
  l'énumération de ses trois formes, sur lesquelles la Task 4 s'appuie pour dire
  ce que la revue lit quand il n'y a pas de bloc.

- [ ] **Step 1: Write the failing assertions**

Dans `tests/test-skill-content.sh`, insérer juste après la ligne
`require writing-a-batch "undelivered means nobody declared it"      "the delta announced and no story declared"` :

```bash

# The `Spec delta` field is never blank — it carries blocks, or what stands in
# their place (spec section "The batch document"). A blank is an omission nobody
# can review, exactly as an omitted `Feature flag` would be; the three forms are
# what makes "no block" a statable decision rather than a silence.
require writing-a-batch "the delta field is never left blank"       "The \`Spec delta\` field is never left blank"
require writing-a-batch "the field's three forms are named"         "the gaps register entries it reserves, or \`none\` and the reason"
require writing-a-batch "a corrective batch takes the second form"  "A corrective batch takes the second form by definition"
require writing-a-batch "the template forbids a blank delta"        "Never left blank: with no block, the gaps register entries this batch reserves, or \`none\` and the reason"
require writing-a-batch "the document reread checks the field"      "\`Spec delta\` filled"
```

- [ ] **Step 2: Run the assertions to verify they fail**

Run: `bash tests/test-skill-content.sh`
Expected: cinq lignes `[FAIL]` — `the delta field is never left blank`,
`the field's three forms are named`, `a corrective batch takes the second form`,
`the template forbids a blank delta`, `the document reread checks the field` —
et un exit code non nul.

- [ ] **Step 3: Write the prose that satisfies them**

Dans `skills/writing-a-batch/SKILL.md`, **trois** modifications.

1. Dans le gabarit du document de lot, remplacer :

```markdown
## Spec delta

<The exact text this batch writes into the specs, in blocks. Per block: its
`D<n>` identifier, the spec and the section it targets, then the current passage
and the text that replaces it, the passage it removes, or the text it inserts and
where. Including the removal of the gating sentence of any flag an earlier batch
declared and this batch takes on.>
```

par :

```markdown
## Spec delta

<The exact text this batch writes into the specs, in blocks. Per block: its
`D<n>` identifier, the spec and the section it targets, then the current passage
and the text that replaces it, the passage it removes, or the text it inserts and
where. Including the removal of the gating sentence of any flag an earlier batch
declared and this batch takes on. Never left blank: with no block, the gaps
register entries this batch reserves, or `none` and the reason.>
```

2. Remplacer le paragraphe :

```markdown
**Corrective batch** — its spec delta is empty by definition: it restores
behaviour a spec already promises. Replace that section with the *Violations*
entries the batch takes on, reserved in `docs/specs/<module>.gaps.md` as above.
```

par :

```markdown
**The `Spec delta` field is never left blank.** It carries the blocks; or, when
the batch has none, the gaps register entries it reserves, or `none` and the
reason. "No block" is a decision, and a decision is stated — the same reason the
`Feature flag` field is mandatory.

A corrective batch takes the second form by definition: it restores behaviour a
spec already promises, so what it announces are the *Violations* entries it takes
on, reserved in `docs/specs/<module>.gaps.md` as above, and no block. A batch that
reserves nothing either takes the third.
```

3. Dans `## Opening the Pull Request`, remplacer :

```markdown
bears on the whole document. Reread it against the specs with fresh eyes:
scope stated with its "why now", spec delta in blocks — each with its `D<n>`,
the spec and section it targets, and its exact text, every quoted passage
matching `main` —, `Constraints` stated or `none` — including the order of any
section that carries two blocks —, `Feature flag` filled, reservations made for
```

par :

```markdown
bears on the whole document. Reread it against the specs with fresh eyes:
scope stated with its "why now", `Spec delta` filled — its blocks each with its
`D<n>`, the spec and section it targets, and its exact text, every quoted passage
matching `main`, or, with no block, the reserved entries or the `none` and its
reason —, `Constraints` stated or `none` — including the order of any
section that carries two blocks —, `Feature flag` filled, reservations made for
```

- [ ] **Step 4: Run the assertions to verify they pass**

Run: `bash tests/test-skill-content.sh`
Expected: les cinq assertions en `[PASS]`, et **aucune régression** — en
particulier `the delta is exact text, in blocks`, `the reread checks quotes
against main` et `the document reread takes the whole document` restent vertes.

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
git commit -m "feat: le champ Spec delta n'est jamais laissé blanc" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 2: Un delta sans bloc passe la relecture de cohérence (D14)

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (étape 5 de `## Opening, in Order`
  ~l. 40-41 ; entrée de `## The Coherence Reread` ~l. 335-338)
- Test: `tests/test-skill-content.sh` (bloc `--- writing-a-batch: the coherence
  reread ---`, après la ligne `the delta goes through the coherence reread`)

**Interfaces:**
- Consumes: rien.
- Produces: rien qu'une autre tâche consomme.

- [ ] **Step 1: Write the failing assertions**

Dans `tests/test-skill-content.sh`, insérer juste après la ligne
`require writing-a-batch "the delta goes through the coherence reread" "Before opening, the whole spec delta goes through the **coherence reread**"` :

```bash
# A delta with no block skips this reread (spec section "The coherence reread").
# Not a dispensation: this reread reads blocks against the spec they will change,
# so with no block it has nothing to read. The batch-document reread of step 6 is
# untouched, and it is what still bears on a blockless delta.
require writing-a-batch "a blockless delta skips this reread"    "A delta that carries no block skips this step"
require writing-a-batch "the skip is not a dispensation"         "it has nothing to read and no state to build"
require writing-a-batch "step 5 states the skip where it is ordered" "skipped when the delta carries no block"
```

- [ ] **Step 2: Run the assertions to verify they fail**

Run: `bash tests/test-skill-content.sh`
Expected: trois lignes `[FAIL]` — `a blockless delta skips this reread`,
`the skip is not a dispensation`, `step 5 states the skip where it is ordered` —
et un exit code non nul.

- [ ] **Step 3: Write the prose that satisfies them**

Dans `skills/writing-a-batch/SKILL.md`, **deux** modifications.

1. Dans `## Opening, in Order`, remplacer :

```markdown
5. **Put the whole spec delta through the coherence reread**
   (`The Coherence Reread`).
```

par :

```markdown
5. **Put the whole spec delta through the coherence reread** — skipped when the
   delta carries no block (`The Coherence Reread`).
```

2. Dans `## The Coherence Reread`, remplacer :

```markdown
Before opening, the whole spec delta goes through the **coherence reread**, which
reads each touched spec whole, on the state its blocks produce.
```

par :

```markdown
Before opening, the whole spec delta goes through the **coherence reread**, which
reads each touched spec whole, on the state its blocks produce.

**A delta that carries no block skips this step.** That is not a dispensation
granted to a smaller batch: this reread reads blocks against the spec they will
change, so with no block it has nothing to read and no state to build. What such a
batch still owes, it owes at step 6 — the batch-document reread, which bears on
whatever stands in the blocks' place.
```

- [ ] **Step 4: Run the assertions to verify they pass**

Run: `bash tests/test-skill-content.sh`
Expected: les trois assertions en `[PASS]`, et **aucune régression** — en
particulier `the coherence reread is step 5`, `the delta goes through the
coherence reread` et `merging them strands a corrective batch` restent vertes.

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
git commit -m "feat: un spec delta sans bloc passe la relecture de cohérence" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 3: L'ouverture nomme les quatre champs qu'elle rédige (D21)

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (étape 3 de `## Opening, in Order`
  ~l. 35-37)
- Test: `tests/test-skill-content.sh` (bloc `--- writing-a-batch: the ordered
  opening ---`, après la ligne `the opening is stated in order`)

**Interfaces:**
- Consumes: rien.
- Produces: rien qu'une autre tâche consomme.

- [ ] **Step 1: Write the failing assertion**

Dans `tests/test-skill-content.sh`, insérer juste après la ligne
`require writing-a-batch "the opening is stated in order"        "Opening a new batch runs these six steps, in this order"` :

```bash
# Step 3 names every field the opening writes (spec section "Opening a batch").
# `Constraints` was the one missing: a step that lists three fields out of four
# reads as exhaustive, and the field it leaves out is the one each story copies
# verbatim into its `Global Constraints`.
require writing-a-batch "step 3 names every field it writes"    "\`Scope\`, \`Spec delta\`, \`Constraints\`, \`Feature flag\`"
```

- [ ] **Step 2: Run the assertion to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: une ligne `[FAIL] writing-a-batch: step 3 names every field it writes`,
et un exit code non nul.

- [ ] **Step 3: Write the prose that satisfies it**

Dans `skills/writing-a-batch/SKILL.md`, dans `## Opening, in Order`, remplacer :

```markdown
3. **Write the batch document**: scope, spec delta in blocks of exact text, the
   `Feature flag` field (`The Batch Document`, `The Feature Flag Field`,
   `Flags Declared by Earlier Batches`).
```

par :

```markdown
3. **Write the batch document**: `Scope`, `Spec delta`, `Constraints`,
   `Feature flag` (`The Batch Document`, `The Feature Flag Field`,
   `Flags Declared by Earlier Batches`).
```

- [ ] **Step 4: Run the assertion to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: `[PASS] writing-a-batch: step 3 names every field it writes`, et
**aucune régression** — en particulier `the opening is stated in order` et
`template declares the Constraints section` restent vertes.

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
git commit -m "feat: l'ouverture nomme les quatre champs qu'elle rédige" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 4: La revue d'ouverture d'un lot sans bloc (D22)

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## Opening the Pull Request` : corps
  de la pull request ~l. 437-439, et paragraphe de la revue ~l. 441-447)
- Test: `tests/test-skill-content.sh` (bloc `--- writing-a-batch: the opening
  review ---`, après la ligne `the reread checks quotes against main`)

**Interfaces:**
- Consumes: de la Task 1, les deux formes que prend le champ quand il ne porte
  aucun bloc — « the gaps register entries it reserves, or `none` and the reason ».
  Cette tâche les redit du point de vue du relecteur : « the reserved entries, or
  the reason for the `none` ».
- Produces: rien qu'une autre tâche consomme.

- [ ] **Step 1: Write the failing assertions**

Dans `tests/test-skill-content.sh`, insérer juste après la ligne
`require writing-a-batch "the reread checks quotes against main"          "every quoted passage matching \`main\`"` :

```bash
# With no block there is no block text to read, and the gate is the same gate
# (spec section "Opening a batch"). What it reads instead is what the field
# carries in their place, so a blockless batch passes the opening review rather
# than passing it by.
require writing-a-batch "a blockless delta still faces the gate" "the review bears on what stands in their place"
require writing-a-batch "what the gate reads in the blocks' place" "the reserved entries, or the reason for the \`none\`"
require writing-a-batch "the PR body carries it to the reviewer" "or, with no block, what stands in their place"
```

- [ ] **Step 2: Run the assertions to verify they fail**

Run: `bash tests/test-skill-content.sh`
Expected: trois lignes `[FAIL]` — `a blockless delta still faces the gate`,
`what the gate reads in the blocks' place`, `the PR body carries it to the
reviewer` — et un exit code non nul.

- [ ] **Step 3: Write the prose that satisfies them**

Dans `skills/writing-a-batch/SKILL.md`, **deux** modifications.

1. Remplacer :

```markdown
Then open the pull request from `batch/NN-<slug>`. Its body states what the
reviewer has to rule on: the exact text of every block, the flag decision, the
scope, and any flag lifting the delta announces.
```

par :

```markdown
Then open the pull request from `batch/NN-<slug>`. Its body states what the
reviewer has to rule on: the exact text of every block — or, with no block, what
stands in their place —, the flag decision, the scope, and any flag lifting the
delta announces.
```

2. Remplacer :

```markdown
**The review of the batch pull request is the human gate.** Until it merges, no
story is written and no spec is touched. It bears on the exact text of every
block: this is where the human reads what the specs will say, before any code is
written on it — block by block, in the batch document, and not later as a diff of
the spec.
```

par :

```markdown
**The review of the batch pull request is the human gate.** Until it merges, no
story is written and no spec is touched. It bears on the exact text of every
block: this is where the human reads what the specs will say, before any code is
written on it — block by block, in the batch document, and not later as a diff of
the spec.

**Where the delta carries no block, the review bears on what stands in their
place**: the reserved entries, or the reason for the `none`. The gate does not
move and nothing is waived — a batch with no block is read at the same review, on
the only text its `Spec delta` holds.
```

- [ ] **Step 4: Run the assertions to verify they pass**

Run: `bash tests/test-skill-content.sh`
Expected: les trois assertions en `[PASS]`, et **aucune régression** — en
particulier `the opening review bears on the exact text`, `the text is read in the
batch document` et `the PR body puts the block text to the reviewer` restent
vertes.

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
git commit -m "feat: la revue d'ouverture porte sur ce qui tient lieu de blocs" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

## Rulings log

## Observed drift
