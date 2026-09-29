# L'autorité Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Les skills et le `README.md` s'accordent avec les sections `Authority and conflict rules`, `Batch > The batch document` et `Story` réécrites : un lot ne porte que ce qu'une spec ne peut pas porter, un bloc montre son changement dans son paragraphe, l'amendement couvre le spec delta, et le prompt de l'étape suivante se donne à l'annonce de la fusion.

**Architecture:** Une tâche par comportement qui bouge. Chacune écrit d'abord ses gardes dans `tests/`, les voit échouer, puis modifie les skills et le `README.md`.

**Tech Stack:** Markdown (skills, README), bash (gardes de `tests/`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/11-la-concision/README.md
**Sections:** Authority and conflict rules, Batch > The batch document, Story
**Blocks:** D6, D12, D17

## Global Constraints

Contraintes du lot, recopiées mot pour mot :

- `D28` est transcrit au plus tard avec `D13`, avec `D18` et avec `D29`.
- `D16` et `D25` sont transcrits au plus tard avec `D30`, et `D30` au plus tard avec
  `D9`.
- `D9` est transcrit au plus tard avec `D7`, et `D7` au plus tard avec `D3` et avec
  `D26`.
- `D17` est transcrit au plus tard avec `D6`.
- `D6` et `D12` sont transcrits ensemble.

Gel du fichier de spec :

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

Règle d'autorité : quand le lot et la spec se contredisent, la spec gagne, sans exception et sans délibération. Implémenter ce que dit la spec, consigner un `Ruling:`, et poursuivre. Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.

Conventions du plugin :

- Tout fichier livré (`skills/`, `README.md`, `CONTRIBUTING.md`, `commands/`, `scripts/`, `tests/`) est intégralement anglais.
- Aucune skill ne cite une section de `docs/specs/supercharlouze.md`. Contrôle : `grep -rnoE '\(\`[A-Z][A-Za-z ]+\`\)' skills/*/SKILL.md` renvoie exactement les lignes 33 à 43 de `skills/writing-a-batch/SKILL.md`, renvois internes à la skill, et aucune autre.
- Tout texte écrit suit `Concision` dans `skills/using-batches/SKILL.md` : une règle par paragraphe, aucun gras d'emphase dans le texte neuf, rien qui tombe sous le sens, aucun récit de la façon dont on y est arrivé.
- Les passages `Old` des tâches sont donnés aplatis : l'implémenteur les retrouve dans le fichier quel que soit le retour à la ligne, et remet le texte `New` en forme comme le paragraphe qu'il remplace (80 colonnes au plus, sauf dans `using-batches`, dont certains paragraphes tiennent sur une ligne).
- Une aiguille de garde qui vise un texte en citation `>` tient sur une seule ligne physique de la citation.
- `CHANGELOG.md` n'est pas touché.
- Chaque commit passe par `bash ~/.config/github-app/as-agent.sh git commit ...`. Sujet en français, type `feat:`. Le message se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et ne porte aucune autre ligne d'attribution.

## Review Focus

- Une garde `absent` dont la regex attrape aussi le texte neuf : elle doit passer sur le fichier modifié, pas seulement échouer sur l'ancien.
- Une garde `require` dont l'aiguille enjambe un retour à la ligne dans une citation `>` : elle ne peut jamais passer.
- Un renvoi entre parenthèses à un nom de champ (`` (`Scope`) ``) : il ajoute une ligne au contrôle des citations de spec.
- Une occurrence oubliée hors des lignes nommées (tableau de Red Flags, `README.md`) qui dit encore l'ancien comportement : chaque tâche relance le `grep` qu'elle nomme.
- Le texte neuf qui raconte l'ancienne règle (« no longer », « instead of quoting ») : il réfute une version que le lecteur ne verra pas.

---

### Task 1: Un lot ne porte que ce qu'une spec ne peut pas porter

**Files:**
- Modify: `skills/using-batches/SKILL.md` (section `## Authority and Conflict Rules`)
- Modify: `skills/writing-a-batch/SKILL.md` (template, `Constraints`, `Spec delta`, batch-document reread, pull request body, gate, requalification, `## Language`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Produces: la phrase du reread de `writing-a-batch` garde `every quoted passage matching \`main\``, que la Task 2 remplace.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, sous `# --- writing-a-batch: the batch document contract ...`, remplacer les lignes suivantes :

```bash
require writing-a-batch "the field's three forms are named"         "It carries the blocks; or, when the batch has none, the gaps register entries it reserves, or \`none\` and the reason"
require writing-a-batch "a corrective batch takes the second form"  "A corrective batch takes the second form by definition"
require writing-a-batch "the template forbids a blank delta"        "Never left blank: with no block, the gaps register entries this batch reserves, or \`none\` and the reason"
```

par :

```bash
require writing-a-batch "the field carries blocks or none"          "It carries the blocks, or \`none\` and the reason"
require writing-a-batch "a corrective batch lists its entries in Scope" "Its \`Spec delta\` reads \`none\` with that reason, and its \`Scope\` lists the *Violations* entries it takes on"
require writing-a-batch "the template forbids a blank delta"        "Never left blank: with no block, \`none\` and the reason"
require writing-a-batch "the template's Scope names the entries"    "<What this batch delivers, including every gaps register entry it takes on.>"
require writing-a-batch "the template's Constraints are bounded"    "<Only the migration and compatibility constraints, and the required order of the stories and of the blocks."
require writing-a-batch "Constraints carry only what they name"     "\`Constraints\` carries only the migration and compatibility constraints, and the required order of the stories and of the blocks"
```

Sous `# --- writing-a-batch: the opening review ...`, remplacer :

```bash
require writing-a-batch "what the gate reads in the blocks' place" "the reserved entries, or the reason for the \`none\`"
require writing-a-batch "the PR body carries it to the reviewer" "or, with no block, what stands in their place"
```

par :

```bash
require writing-a-batch "what the gate reads in the blocks' place" "the reason for the \`none\`, and the entries \`Scope\` takes on"
require writing-a-batch "the PR body carries it to the reviewer" "the exact text of every block, or the reason for the \`none\`"
```

Sous `# --- using-batches: preconditions for every pull request of this system ---`, ajouter :

```bash
require using-batches "a batch carries only what a spec cannot" "Besides its spec delta, a batch carries only what a spec cannot carry: its scope, its flags, the order of its stories and of its blocks, and its migration and compatibility constraints."
```

Dans `tests/test-skill-contracts.sh`, juste avant le bloc `# The specs carry no changelog any more.`, ajouter :

```bash
# A batch no longer says why it happens now, and its reserved entries go under
# `Scope`, not under `Spec delta`. The positive assertions stay green beside a
# leftover of the old wording, so the old wording is hunted too.
absent "no skill asks a batch why it happens now" \
    "why now|happens now" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

absent "no skill files reserved entries under the spec delta" \
    "gaps register entries it reserves, or|gaps register entries this batch reserves|replacing the reserved gaps entries|delivery perimeter|required ordering of the user stories" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh`
Expected: FAIL sur chaque garde ajoutée ou modifiée ci-dessus.

- [ ] **Step 3: Modifier `skills/using-batches/SKILL.md`**

Old: `**The spec is the binding authority.** The batch carries only what a spec cannot carry: delivery scope, story order, migration and compatibility constraints, and why this work happens now.`

New: `**The spec is the binding authority.** Besides its spec delta, a batch carries only what a spec cannot carry: its scope, its flags, the order of its stories and of its blocks, and its migration and compatibility constraints.`

- [ ] **Step 4: Modifier `skills/writing-a-batch/SKILL.md`**

Dans le gabarit du document de lot :

Old: `<What this batch delivers, and why now.>`
New: `<What this batch delivers, including every gaps register entry it takes on.>`

Old: `declared and this batch takes on. Never left blank: with no block, the gaps register entries this batch reserves, or \`none\` and the reason.>`
New: `declared and this batch takes on. Never left blank: with no block, \`none\` and the reason.>`

Old: `<Migration and compatibility constraints, the required ordering of the user stories, and the order of any two blocks that change the same section. \`none\` if there are none.>`
New: `<Only the migration and compatibility constraints, and the required order of the stories and of the blocks. \`none\` if there are none.>`

Paragraphe `Constraints` :

Old: `**\`Constraints\` is where the batch says what a spec cannot.** The spec is the binding authority on behaviour; what belongs to the batch and only to it is the delivery perimeter, the ordering of the user stories, and the migration and compatibility constraints — so that is what goes here, and nothing normative. \`supercharlouze:writing-a-user-story\` copies this section **verbatim** into`

New: `\`Constraints\` carries only the migration and compatibility constraints, and the required order of the stories and of the blocks. The scope has its own field, and nothing normative goes here: the spec is the binding authority on behaviour. \`supercharlouze:writing-a-user-story\` copies this section **verbatim** into`

(La suite du paragraphe, de `every story's \`Global Constraints\`` à `its own order.`, reste inchangée.)

Champ `Spec delta` :

Old: `**The \`Spec delta\` field is never left blank.** It carries the blocks; or, when the batch has none, the gaps register entries it reserves, or \`none\` and the reason. "No block" is a decision, and a decision is stated — the same reason the \`Feature flag\` field is mandatory.`

New: `**The \`Spec delta\` field is never left blank.** It carries the blocks, or \`none\` and the reason. "No block" is a decision, and a decision is stated, for the same reason the \`Feature flag\` field is mandatory.`

Old: `A corrective batch takes the second form by definition: it restores behaviour a spec already promises, so what it announces are the *Violations* entries it takes on, reserved in \`docs/specs/<module>.gaps.md\` as above, and no block. A batch that reserves nothing either takes the third.`

New: `A corrective batch has no block by definition: it restores behaviour a spec already promises. Its \`Spec delta\` reads \`none\` with that reason, and its \`Scope\` lists the *Violations* entries it takes on, reserved in \`docs/specs/<module>.gaps.md\` as above. A field carries what its name says: \`Scope\` says what the batch delivers, \`Spec delta\` only what the specs receive.`

Relecture du document de lot (section `## Opening the Pull Request`) :

Old: `Reread it against the specs with fresh eyes: scope stated with its "why now", \`Spec delta\` filled — its blocks each with its \`D<n>\`, the spec and section it targets, and its exact text, every quoted passage matching \`main\`, or, with no block, what stands in their place —, \`Constraints\` stated or \`none\` — including the order of any section that carries two blocks —, \`Feature flag\` filled, reservations made for every gaps register entry this batch takes on — corrective or ordinary — and the lifting of any earlier flag this batch takes on stated as a block.`

New: `Reread it against the specs with fresh eyes: \`Scope\` stating what the batch delivers, with every gaps register entry it takes on, each one reserved, corrective or ordinary; \`Spec delta\` filled, its blocks each with its \`D<n>\`, the spec and section it targets, and its exact text, every quoted passage matching \`main\`, or \`none\` and the reason; \`Constraints\` carrying only migration and compatibility constraints and the required order of stories and blocks, or \`none\`; \`Feature flag\` filled; and the lifting of any earlier flag this batch takes on stated as a block.`

Corps de la pull request :

Old: `Its body states what the reviewer has to rule on: the exact text of every block — or, with no block, what stands in their place —, the flag decision, the scope, and any flag lifting the delta announces.`

New: `Its body states what the reviewer has to rule on: the exact text of every block, or the reason for the \`none\`; the flag decision; the scope, with the entries it takes on; and any flag lifting the delta announces.`

Revue d'un lot sans bloc :

Old: `**Where the delta carries no block, the review bears on what stands in their place**: the reserved entries, or the reason for the \`none\`. The gate does not move and nothing is waived — a batch with no block is read at the same review, on the only text its \`Spec delta\` holds.`

New: `**Where the delta carries no block, the review bears on what stands in their place**: the reason for the \`none\`, and the entries \`Scope\` takes on. The gate does not move and nothing is waived: a batch with no block is read at the same review.`

Requalification d'un lot correctif, étape 2 :

Old: `Hence an amendment pull request on the existing document, replacing the reserved gaps entries with a \`Spec delta\`, reviewed at the gate like an opening.`

New: `Hence an amendment pull request on the existing document, replacing the \`none\` of its \`Spec delta\` with blocks, reviewed at the gate like an opening.`

Section `## Language` :

Old: `The prose is in the project's language: the scope, the "why now", the spec delta, the justification of the flag decision.`
New: `The prose is in the project's language: the scope, the spec delta, the justification of the flag decision.`

- [ ] **Step 5: Vérifier**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

Run: `grep -rnE 'why now|happens now|delivery perimeter|entries it reserves' skills README.md CONTRIBUTING.md`
Expected: aucune ligne.

Run: `grep -rnoE '\(\`[A-Z][A-Za-z ]+\`\)' skills/*/SKILL.md`
Expected: les lignes 33 à 43 de `skills/writing-a-batch/SKILL.md`, aucune autre.

- [ ] **Step 6: Commit**

```bash
git add skills/using-batches/SKILL.md skills/writing-a-batch/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: un lot ne porte que ce qu'une spec ne peut pas porter" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 2: Un bloc montre son changement dans le paragraphe qui le contient

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## Opening, in Order`, template, paragraphe du bloc, batch-document reread, `## The Coherence Reread`)
- Modify: `skills/writing-a-user-story/SKILL.md` (`## Step 3 — Commit the Spec Change First`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la phrase `every quoted passage matching \`main\`` que la Task 1 a laissée dans le reread de `writing-a-batch`.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, remplacer :

```bash
require writing-a-batch "a block quotes what it replaces"           "quotes the current passage, then the text that replaces it"
```

par :

```bash
require writing-a-batch "a block shows its change in its paragraph"  "A block shows what it changes in the paragraph that contains it"
require writing-a-batch "the paragraph is given as a diff"           "Give the paragraph in a \`diff\` fence"
require writing-a-batch "the paragraph is taken from main"           "take the paragraph from \`main\` as it stands"
```

Remplacer :

```bash
require writing-a-batch "the reread checks quotes against main"          "every quoted passage matching \`main\`"
```

par :

```bash
require writing-a-batch "the reread checks each block against main"      "every block's unchanged and removed lines matching \`main\`"
```

Remplacer :

```bash
require writing-a-batch "a stale block will not apply"                "A block whose quoted passage is no longer in \`main\` will not apply"
```

par :

```bash
require writing-a-batch "a stale block will not apply"                "A block whose unchanged and removed lines no longer match \`main\` will not apply"
```

Sous `# --- writing-a-user-story: the story's blocks ...`, après la ligne `require writing-a-user-story "transcription is word for word" ...`, ajouter :

```bash
require writing-a-user-story "a diff block yields its paragraph"    "is transcribed as the paragraph it produces"
require writing-a-user-story "main moved under a block's paragraph" "The paragraph a block changes no longer reads in \`main\` as the block shows it"
```

Dans `tests/test-skill-contracts.sh`, juste avant le bloc `# The specs carry no changelog any more.`, ajouter :

```bash
# A block shows its change in the paragraph that contains it. The former form,
# a quoted passage then its replacement, must survive nowhere.
absent "no skill has a block quote a passage" \
    "quoted passage|quotes the current passage|passage a block quotes|Quote the passage|the passage it removes" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh`
Expected: FAIL sur chaque garde ajoutée ou modifiée ci-dessus.

- [ ] **Step 3: Modifier `skills/writing-a-batch/SKILL.md`**

`## Opening, in Order` :

Old: `The batch-document reread bears on the whole document — scope, \`Constraints\`, the flag field, every quoted passage.`
New: `The batch-document reread bears on the whole document — scope, \`Constraints\`, the flag field, every block's paragraph.`

Gabarit, champ `Spec delta` :

Old: `Per block: its \`D<n>\` identifier, the spec and the section it targets, then the current passage and the text that replaces it, the passage it removes, or the text it inserts and where.`
New: `Per block: its \`D<n>\` identifier, the spec and the section it targets, then its change shown in the paragraph that contains it.`

Paragraphe du bloc. Old :

```
**A block is the unit of the delta.** Each one carries an identifier `D<n>`, unique within the batch, and names the spec and the section it targets. To modify a passage, it quotes the current passage, then the text that replaces it; to remove one, it quotes it; to add text, it gives that text and where it goes. Quote the passage as `main` carries it now: the story transcribes against it.
```

New :

`````markdown
**A block is the unit of the delta.** Each one carries an identifier `D<n>`,
unique within the batch, and names the spec and the section it targets.

A block shows what it changes in the paragraph that contains it. A fragment and
its replacement, quoted apart, leave the reviewer to rebuild the paragraph, and
the sentence the change contradicts two lines further on goes unseen. Give the
paragraph in a `diff` fence: its lines as `main` carries them, each removed line
prefixed `-`, each added line `+`, each unchanged line a space. The story
transcribes against those lines, so take the paragraph from `main` as it stands.
A block that rewrites a whole section gives the section as it will read; a block
that inserts a section gives it and names the section it follows; a block that
removes a section names it.

````markdown
### D4 — `docs/specs/facturation.md`, `Abonnement > Renouvellement`

```diff
 A subscription renews on its anniversary date, for the same length.
-The customer is notified seven days before.
+The customer is notified fourteen days before, and may decline the renewal
+until the day before.
```
````
`````

Relecture du document de lot :

Old: `every quoted passage matching \`main\``
New: `every block's unchanged and removed lines matching \`main\``

`## The Coherence Reread` :

Old: `**A block whose quoted passage is no longer in \`main\` will not apply**, so building this copy is also the first thing that catches a delta that has gone stale since the batch was drafted.`
New: `**A block whose unchanged and removed lines no longer match \`main\` will not apply**, so building this copy is also the first thing that catches a delta that has gone stale since the batch was drafted.`

- [ ] **Step 4: Modifier `skills/writing-a-user-story/SKILL.md`**

Après le paragraphe qui commence par `**Word for word.**` et finit par `meant to be delivered.`, insérer ce paragraphe :

```
A block shown as a `diff` fence is transcribed as the paragraph it produces: its
unchanged lines and its added lines, without their prefix.
```

Dans la liste des écarts :

Old: `- **\`main\` moved.** The passage a block quotes is no longer there as written, because another story or a bounded change landed on that section since the batch opened.`
New: `- **\`main\` moved.** The paragraph a block changes no longer reads in \`main\` as the block shows it, because another story or a bounded change landed on that section since the batch opened.`

- [ ] **Step 5: Vérifier**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

Run: `grep -rnE 'quoted passage|quotes the current|passage a block quotes' skills README.md`
Expected: aucune ligne.

Run: `grep -rnoE '\(\`[A-Z][A-Za-z ]+\`\)' skills/*/SKILL.md`
Expected: les lignes 33 à 43 de `skills/writing-a-batch/SKILL.md`, aucune autre.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-batch/SKILL.md skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: un bloc montre son changement dans son paragraphe" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 3: L'amendement couvre le spec delta

**Files:**
- Modify: `skills/using-batches/SKILL.md` (tableau de routage, tableau des revues)
- Modify: `skills/writing-a-batch/SKILL.md` (tableau des points d'entrée, `## Amending a Batch`)
- Modify: `README.md` (tableau des revues)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`, `tests/test-cross-references.sh`

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, après `require writing-a-batch "amendment pull request exists" ...`, ajouter :

```bash
require writing-a-batch "an amendment covers the spec delta"     "An amendment changes the scope, the spec delta or the flag of an open batch"
require writing-a-batch "the entry point names the spec delta"   "Changing the scope, the spec delta or the flag of an existing batch"
```

Sous `# --- using-batches: the shape of a review's end ---`, ajouter :

```bash
require using-batches "the amendment gate covers the spec delta" "the decision to change its scope, its spec delta or its flag"
require using-batches "routing names the spec delta"             "A batch must change its scope, its spec delta or its flag"
```

Dans `tests/test-skill-contracts.sh`, juste avant le bloc `# The specs carry no changelog any more.`, ajouter :

```bash
# An amendment changes the scope, the spec delta or the flag of an open batch.
# A leftover naming only scope and flag would send a spec delta change nowhere.
absent "no skill bounds an amendment to scope and flag" \
    "scope or (its |the |of )?flag" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

Dans `tests/test-cross-references.sh`, juste avant le commentaire `# 5. No shipped artifact cites a numbered section`, ajouter :

```bash
# The amendment gate covers the spec delta, in the README's gate table too.
if grep -q "a change of scope, of spec delta or of flag on an open batch" "$REPO_ROOT/README.md"; then
    pass "the README's amendment gate covers the spec delta"
else
    fail "the README's amendment gate covers the spec delta"
fi
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh; bash tests/test-cross-references.sh`
Expected: FAIL sur chaque garde ajoutée ci-dessus.

- [ ] **Step 3: Modifier `skills/using-batches/SKILL.md`**

Old: `| A batch must change scope or flag, or a corrective batch must be requalified | \`supercharlouze:writing-a-batch\` |`
New: `| A batch must change its scope, its spec delta or its flag, or a corrective batch must be requalified | \`supercharlouze:writing-a-batch\` |`

Old: `| Batch amendment | the pull request carrying the decision to change its scope or its flag |`
New: `| Batch amendment | the pull request carrying the decision to change its scope, its spec delta or its flag |`

- [ ] **Step 4: Modifier `skills/writing-a-batch/SKILL.md`**

Old: `| Changing the scope or the flag of an existing batch | Amending a Batch |`
New: `| Changing the scope, the spec delta or the flag of an existing batch | Amending a Batch |`

Début de `## Amending a Batch`. Old :

```
The batch document carries no mutable state, but it stays amendable by an **amendment pull request**, reviewed like the others. That is the exit from two real dead ends:

- **An exempted batch that discovers it needed a flag** — a batch whose stories were all technical and one of them turned out not to be, a single-story batch that splits in two.
- **A batch whose scope is reduced or abandoned**, including reducing it after a requalification, or giving a flag an extended scope so a later batch can decide.

Without this path neither situation has an issue: the `Feature flag` field was decided at opening, and closing checks it against reality.
```

New :

```
The batch document carries no mutable state, but it stays amendable by an
**amendment pull request**, reviewed like the others. An amendment changes the
scope, the spec delta or the flag of an open batch. That is the exit from these
real dead ends:

- **An exempted batch that discovers it needed a flag** — a batch whose stories
  were all technical and one of them turned out not to be, a single-story batch
  that splits in two.
- **A batch whose scope is reduced or abandoned**, including reducing it after a
  requalification, or giving a flag an extended scope so a later batch can decide.
- **A batch whose spec delta must change**: a corrective batch rewritten as an
  ordinary one, or a technical story whose observable change needs a block.

Without this path none of them has an issue: the batch document is written
at opening, and nothing else changes it before closing.
```

- [ ] **Step 5: Modifier `README.md`**

Old: `| Batch amendment | a change of scope or of flag on an open batch |`
New: `| Batch amendment | a change of scope, of spec delta or of flag on an open batch |`

- [ ] **Step 6: Vérifier**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

Run: `grep -rnE 'scope or (its |the |of )?flag' skills README.md CONTRIBUTING.md commands`
Expected: aucune ligne.

- [ ] **Step 7: Commit**

```bash
git add skills/using-batches/SKILL.md skills/writing-a-batch/SKILL.md README.md tests/test-skill-content.sh tests/test-skill-contracts.sh tests/test-cross-references.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: l'amendement couvre le spec delta" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 4: Le prompt de l'étape suivante se donne à l'annonce de la fusion

**Files:**
- Modify: `skills/using-batches/SKILL.md` (`## The Git Model`)
- Modify: `skills/writing-a-batch/SKILL.md` (`## Opening the Pull Request`, `## Amending a Batch`)
- Modify: `skills/adopting-a-module/SKILL.md` (fin de revue)
- Modify: `skills/writing-a-user-story/SKILL.md` (`## Step 7 — Answer the Review`)
- Modify: `skills/closing-a-batch/SKILL.md` (fin de revue)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, remplacer :

```bash
require adopting-a-module "names the next step after the clear"  "names \`supercharlouze:writing-a-batch\` as the next step"
```
par :
```bash
require adopting-a-module "names the next step after the clear"  "name \`supercharlouze:writing-a-batch\` as the next step"
```

Remplacer :
```bash
require writing-a-batch "opening hands over to the first story"   "names \`supercharlouze:writing-a-user-story\` as the next step"
```
par :
```bash
require writing-a-batch "opening hands over to the first story"   "name \`supercharlouze:writing-a-user-story\` as the next step"
```

Remplacer :
```bash
require writing-a-user-story "hands over to the next story"         "names the next story as the next step"
```
par :
```bash
require writing-a-user-story "hands over to the next story"         "name the next story as the next step"
```

Sous `# --- using-batches: the shape of a review's end ---`, ajouter :

```bash
require using-batches "the prompt waits for the merge"      "The prompt waits for the merge announcement, not for the announcement that the pull request is ready"
```

Dans `tests/test-skill-contracts.sh`, juste après l'appel `shared "every review-ending skill names the merge a clear moment" ...`, ajouter :

```bash
# The next step is named, and its prompt given, when the human announces the
# merge, not when the agent announces the pull request ready: given then, the
# review that follows buries it. One assertion over the review-ending
# skills, and the former timing hunted in all of them.
shared "every review-ending skill acts on the merge announcement" \
    "your human partner announces the merge" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

absent "no skill hands over the next step at the ready announcement" \
    "the announcement (says so|names|therefore names)|announcing it ready is where|an announcement that names|when it announces the pull request ready" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh`
Expected: FAIL sur chaque garde ajoutée ou modifiée ci-dessus.

- [ ] **Step 3: Modifier `skills/using-batches/SKILL.md`**

Old :

```
The agent cannot clear its own context. So when it announces the pull request
ready, it says that merging it will be that moment. Where a next step exists, it
names that step and gives — in a block to copy and paste — the prompt that starts
it after the clear. **That prompt stands on its own:** it names the skill to
invoke and the document to start from, and never refers back to the conversation.
```

New :

```
The agent cannot clear its own context. So when your human partner announces the
merge, the agent says this is that moment. Where a next step exists, it names
that step and gives, in a block to copy and paste, the prompt that starts it in a
fresh context. **That prompt stands on its own:** it names the skill to invoke and
the document to start from, and never refers back to the conversation.

The prompt waits for the merge announcement, not for the announcement that the
pull request is ready. Between the two the review may go on, and a prompt given
earlier ends up buried under it, or names a document the review has since
changed.
```

- [ ] **Step 4: Modifier `skills/writing-a-batch/SKILL.md`**

Old: `The announcement therefore names \`supercharlouze:writing-a-user-story\` as the next step and gives its prompt in a block to copy and paste.`
New: `When your human partner announces the merge, name \`supercharlouze:writing-a-user-story\` as the next step and give its prompt in a block to copy and paste.`

(La suite, de `**That prompt stands on its own:**` à `this conversation.`, reste inchangée.)

Old: `**An amendment merges into the same clear moment as an opening**, and ends its review the same way: fixups during the review, agreement in the conversation, squash, and an announcement that names the next step. What differs is which step that is — an amendment hands back to whatever the batch was doing when it stopped, so the announcement names that, and its prompt names the amended batch document by path.`

New: `**An amendment merges into the same clear moment as an opening**, and ends its review the same way: fixups during the review, agreement in the conversation, squash, the pull request announced ready, then the next step named when your human partner announces the merge. What differs is which step that is: an amendment hands back to whatever the batch was doing when it stopped, so name that, and give a prompt that names the amended batch document by path.`

- [ ] **Step 5: Modifier `skills/adopting-a-module/SKILL.md`**

Old: `**Merging this pull request is a moment to clear the context**, and announcing it ready is where you say so.`
New: `**Merging this pull request is a moment to clear the context**, and your human partner's announcement of the merge is where you say so.`

Old: `So the announcement names \`supercharlouze:writing-a-batch\` as the next step, and gives the prompt for it in a block to copy and paste after the clear.`
New: `So when your human partner announces the merge, name \`supercharlouze:writing-a-batch\` as the next step, and give the prompt for it in a block to copy and paste.`

(La suite, de `**That prompt stands on its own:**` à `this conversation.`, reste inchangée.)

- [ ] **Step 6: Modifier `skills/writing-a-user-story/SKILL.md`**

Old: `**Merging it is a moment to clear the context**, and the announcement says so. On this path`
New: `**Merging it is a moment to clear the context.** On this path`

Old: `So the announcement names the next story as the next step — unless this story took the batch's last undelivered blocks, in which case it names \`supercharlouze:closing-a-batch\` instead, matching how an amendment hands back to whatever the batch was doing when it stopped — and gives its prompt in a block to copy and paste.`

New: `So when your human partner announces the merge, name the next story as the next step, or \`supercharlouze:closing-a-batch\` if this story took the batch's last undelivered blocks, and give its prompt in a block to copy and paste.`

(La suite, de `**That prompt stands on its own:**` à `was for.`, reste inchangée.)

- [ ] **Step 7: Modifier `skills/closing-a-batch/SKILL.md`**

Old: `**Merging a closing review is a moment to clear the context.** It is the one gate with **no next step to name**, so it **hands over no prompt** — what comes after a closed batch is chosen outside this model.`

New: `**Merging a closing review is a moment to clear the context.** When your human partner announces the merge, say that this is that moment. It is the one gate with **no next step to name**, so it **hands over no prompt**: what comes after a closed batch is chosen outside this model.`

- [ ] **Step 8: Vérifier**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

Run: `grep -rnE 'the announcement (says|names|therefore)|announcing it ready|after the clear' skills README.md`
Expected: aucune ligne.

- [ ] **Step 9: Commit**

```bash
git add skills/using-batches/SKILL.md skills/writing-a-batch/SKILL.md skills/adopting-a-module/SKILL.md skills/writing-a-user-story/SKILL.md skills/closing-a-batch/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: le prompt suivant se donne à l'annonce de la fusion" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 5: Tout ce qui atteint `main` peut partir en production

**Files:**
- Modify: `skills/using-batches/SKILL.md` (`**Feature flag**`, `## The Git Model`)
- Modify: `skills/writing-a-batch/SKILL.md` (`## The Feature Flag Field`)
- Modify: `README.md` (`### Why everything lands on \`main\``)
- Test: `tests/test-declared-overrides.sh`, `tests/test-skill-contracts.sh`, `tests/test-cross-references.sh`

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-declared-overrides.sh`, remplacer :

```bash
for needle in "same pull request" "continuous" "feature flag" "drift"; do
```
par :
```bash
for needle in "same pull request" "may ship to production" "feature flag" "drift"; do
```

Dans `tests/test-skill-contracts.sh`, juste avant le bloc `# The specs carry no changelog any more.`, ajouter :

```bash
# Everything that reaches `main` may ship to production. The flow presumes no
# more of the project: a skill still requiring continuous deployment asks more
# than the flow does.
absent "no skill requires continuous deployment" \
    "[Cc]ontinuous" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

Dans `tests/test-cross-references.sh`, juste avant le commentaire `# 5. No shipped artifact cites a numbered section`, ajouter :

```bash
# The README presumes no continuous deployment either.
if grep -qi "continuous" "$REPO_ROOT/README.md"; then
    fail "the README requires no continuous deployment"
else
    pass "the README requires no continuous deployment"
fi
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-declared-overrides.sh; bash tests/test-skill-contracts.sh; bash tests/test-cross-references.sh`
Expected: FAIL sur chaque garde ajoutée ou modifiée ci-dessus.

- [ ] **Step 3: Modifier `skills/using-batches/SKILL.md`**

Old: `` `main` is deployed continuously, so every merged story ships; a batch whose stories would expose incomplete behaviour declares a flag.``
New: `Everything that reaches \`main\` may ship to production, so every merged story may reach users; a batch whose stories would expose incomplete behaviour declares a flag.`

Old: `- **\`main\` is deployed continuously** — every merge ships to production.`
New: `- **Everything that reaches \`main\` may ship to production**, whenever the project deploys.`

Old: `**One branch, one name.** \`main\` is that protected, continuously deployed branch, and this plugin calls it`
New: `**One branch, one name.** \`main\` is that protected branch, whose every merge may ship, and this plugin calls it`

- [ ] **Step 4: Modifier `skills/writing-a-batch/SKILL.md`**

Old: `The batch is delivered onto a continuously deployed \`main\`: every merged story ships.`
New: `The batch is delivered onto \`main\`, and everything that reaches \`main\` may ship to production: every merged story may reach users.`

- [ ] **Step 5: Modifier `README.md`**

Old: `` everything goes through a pull request, and `main` is deployed continuously, so every merge ships. Feature flags exist because of the second one.``
New: `` everything goes through a pull request, and everything that reaches `main` may ship to production, which is why feature flags exist.``

- [ ] **Step 6: Vérifier**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

Run: `grep -rniE 'continuous|every merge ships' skills README.md CONTRIBUTING.md commands`
Expected: aucune ligne.

- [ ] **Step 7: Commit**

```bash
git add skills/using-batches/SKILL.md skills/writing-a-batch/SKILL.md README.md tests/test-declared-overrides.sh tests/test-skill-contracts.sh tests/test-cross-references.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: tout ce qui atteint main peut partir en production" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: les skills suivent le tableau des revues de `Authority and conflict rules`, où un amendement change le périmètre, le spec delta ou le flag, bien que `Batch > Amending a batch` s'ouvre encore sur « le périmètre ou le flag » — le tableau est le bloc le plus récent, cette section laisse déjà un amendement réécrire le spec delta (requalification, bloc d'une story technique), et son propre bloc `D15` l'aligne plus tard — si c'est faux, les skills élargissent l'amendement une story trop tôt, et la story de `Amending a batch` devra le restreindre.
- Ruling: `writing-a-batch` et `writing-a-user-story` ne disent pas « c'est ce moment » à l'annonce de la fusion — `using-batches` le dit pour toute revue, et le répéter dans chaque skill dit ce qui tombe sous le sens — si c'est faux, un agent qui termine la revue d'un lot ou d'une story nomme l'étape suivante sans dire que la fusion est le moment de vider le contexte.
- Ruling: la story reprend dans `writing-a-user-story` « each knowing the stories of its batch already written », que le plan ne listait pas — la section `Story` réécrite dit qu'une story s'écrit en connaissant les stories de son lot déjà écrites, et la skill ne nommait que la précédente — si c'est faux, une phrase de la skill va plus loin que ce que l'humain voulait.

## Observed drift
