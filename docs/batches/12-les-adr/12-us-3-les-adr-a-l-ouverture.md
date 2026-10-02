# Les ADR à l'ouverture Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** L'ouverture d'un lot écrit, réécrit ou supprime les ADR que l'humain a décidés, et la relecture technique relit le lot contre les ADR et relit chaque ADR que la pull request écrit ou réécrit.

**Architecture:** `rereading-a-technical-design` gagne deux lectures, lance chaque lecture quand son objet existe, et rend sans les réviser les constats sur un bloc ou sur un ADR ; son prompt de lecteur est réécrit autour de ce que la lecture nomme. `writing-a-batch` écrit les ADR après le document de lot par `supercharlouze:recording-a-decision`, invoque la relecture technique pour tout lot, et énonce les ADR dans le corps de la pull request d'ouverture. `using-batches` et le `README.md` suivent la ligne d'ouverture de la table des revues. Chaque norme a sa garde dans `tests/`, écrite avant le texte.

**Tech Stack:** Markdown pour les skills et le `README.md`, Bash pour les gardes de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/12-les-adr/README.md
**Sections:** Authority and conflict rules, Batch > The technical reread, Batch > Opening a batch
**Blocks:** D13, D15, D16

## Global Constraints

Contraintes du lot, recopiées mot pour mot :

> `D1`, `D2` et `D3` sont transcrits par la même story, avant tout autre bloc sauf
> `D14` et `D20`.
>
> `D4` à `D12` sont transcrits par la même story.
>
> `D13`, `D15` et `D16` sont transcrits par la même story.
>
> `D17`, `D18` et `D19` sont transcrits par la même story, après `D15`.
>
> La story qui transcrit `D2` livre la skill `recording-a-decision`.
>
> Toutes les stories emploient tels quels le répertoire `docs/adr/` et la skill
> `recording-a-decision`.

Gel du fichier de spec :

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

Règle d'autorité :

> When the batch and the spec contradict each other, the spec wins — without
> exception and without deliberation. Implement what the spec says, record a
> `Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
> agent's.

Règles de concision :

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

Condition d'arrêt sur une contrainte ou un ADR qui ne peut pas être tenu :

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

Conditions d'un ADR :

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

Règles du dépôt, qui valent pour chaque tâche :

- Une skill, un test et le `README.md` sont entièrement en anglais.
- Une skill ne cite jamais une section de `docs/specs/supercharlouze.md`. Une section qu'une skill nomme entre parenthèses est l'un de ses propres titres.
- Chaque norme qu'une skill énonce a sa garde dans `tests/`, écrite avant le texte et vue rouge.
- Chaque phrase d'une skill change ce qu'un agent fait. Pas de réfutation d'une version disparue, pas de cas particulier que la règle générale couvre déjà, pas de gras qui hiérarchise, pas de tiret à la place d'une virgule, pas de liste qui annonce combien d'éléments elle tient.
- Une règle est écrite en entier à un seul endroit et pointée ailleurs.
- `rereading-a-technical-design` et son prompt de lecteur ne nomment aucune skill du plugin.
- Cette story ne livre que ce qui réalise `D13`, `D15` et `D16`. `## Amending a Batch` de `skills/writing-a-batch/SKILL.md`, la ligne d'amendement des tables des revues, la table de routage de `skills/using-batches/SKILL.md`, `## The Batch Document`, `skills/closing-a-batch/`, `scripts/` et `commands/` ne sont pas touchés.
- Le texte d'une skill donné dans une tâche est écrit tel quel. Un implémenteur qui le juge faux le dit dans son rapport, et ne le réécrit pas.
- Tout commit passe par `bash ~/.config/github-app/as-agent.sh git -C <worktree> commit …` et se termine par la seule ligne d'attribution `Co-Authored-By: Charlouze <me@charlouze.com>`. Jamais de `Co-Authored-By: Claude …`, de `Claude-Session:` ni de « Generated with Claude Code ».
- Pendant une tâche, seuls les fichiers de test qu'elle touche sont lancés (`bash tests/<fichier>.sh`). La suite complète tourne à la fin de la story. Aucun lancement n'est laissé en arrière-plan.

## Review Focus

- Un lot sans conception ni contraintes dont la pull request écrit un ADR : la relecture technique tourne quand même et relit cet ADR. Gardé en tâche 1 par la règle « une lecture est lancée quand son objet existe », et en tâche 2 par l'invocation pour tout lot.
- Un lot qui a des blocs, aucune conception, et un `docs/adr/` déjà peuplé : les blocs sont relus contre les ADR. Gardé en tâche 1 par l'objet de cette lecture.
- Un lecteur qui reçoit un emplacement que sa lecture n'emploie pas, laissé tel quel. Gardé en tâche 1 par la consigne du prompt.
- Un constat sur un ADR que le conducteur de la relecture corrigerait lui-même. Gardé en tâche 1 par « This reread revises no ADR », et en tâche 2 par le retour à `recording-a-decision` quand la décision change.
- Un constat sur un bloc que l'humain fait corriger sans que la relecture de cohérence le relise. Gardé en tâche 2 par le retour à l'étape 5.

---

### Task 1: La relecture technique relit les blocs et les ADR

**Files:**
- Modify: `skills/rereading-a-technical-design/SKILL.md` (tout le fichier)
- Modify: `skills/rereading-a-technical-design/references/reader-prompt.md` (tout le fichier)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`, `tests/test-technical-reader-prompt.sh`

**Interfaces:**
- Consumes: rien.
- Produces: l'entrée de la relecture, que la tâche 2 passe depuis `writing-a-batch` : le document de lot, chaque spec touchée avec ses blocs appliqués, `docs/specs/`, `docs/adr/`, et le chemin de chaque ADR que la pull request écrit ou réécrit. Sa sortie : la conception et les contraintes révisées, les comportements et les blocs repris au spec delta, les constats sur un ADR avec ce que l'humain a tranché, ce que la relecture a trouvé, ou « nothing to reread ».

- [ ] **Step 1: Changer et écrire les gardes**

Dans `tests/test-skill-content.sh`, remplacer ces trois gardes :

```bash
require rereading-a-technical-design "input: the batch and its applied specs" "The input is the batch document, and each spec the batch touches with the batch's blocks applied"
```

```bash
require rereading-a-technical-design "output: the behaviours taken back to the delta" "the behaviours your human partner took back to the spec delta, which ended the reread"
```

```bash
require rereading-a-technical-design "every batch gets every reading"    "Every batch gets every reading"
```

respectivement par :

```bash
require rereading-a-technical-design "the reread also bears on the blocks and the ADRs" "The reread also reads the batch's blocks against the ADRs, and rereads each ADR that the pull request opening or amending the batch writes or rewrites."
require rereading-a-technical-design "input: the batch, its applied specs, the other specs and the ADRs" "The input is: - the batch document; - each spec the batch touches, with the batch's blocks applied; - \`docs/specs/\`, for the specs the batch does not touch; - \`docs/adr/\`, as the pull request that opens or amends the batch leaves it; - the path of each ADR that pull request writes or rewrites."
```

```bash
require rereading-a-technical-design "output: the behaviours and the blocks taken back to the delta" "the behaviours and the blocks your human partner took back to the spec delta, which ended the reread"
require rereading-a-technical-design "output: the findings on an ADR" "the findings on an ADR, each with what your human partner ruled on it;"
require rereading-a-technical-design "output: nothing to reread" "When no reading is dispatched (\`The Readings\`), return \"nothing to reread\"."
```

```bash
require rereading-a-technical-design "a reading is dispatched when its object exists" "Dispatch a reading when its object exists."
require rereading-a-technical-design "no object, nothing dispatched" "When no object exists, dispatch nothing."
require rereading-a-technical-design "the object of the design readings" "The object of these readings is the design: the batch document's \`Technical design\` and \`Constraints\`. It exists unless both read \`none\`."
require rereading-a-technical-design "the object of the reading against the ADRs" "The object of this reading is the batch's blocks and its design. It exists when \`docs/adr/\` carries an ADR, a \`.md\` file placed directly in it, and the batch has a block or a design."
require rereading-a-technical-design "the object of the reading of the ADRs" "The object of this reading is each ADR the pull request writes or rewrites. It exists when the input names one."
```

Après la garde `reading: robustness`, ajouter :

```bash
require rereading-a-technical-design "reading: the ADRs held"  "**Do the blocks and the design hold the ADRs?**"
require rereading-a-technical-design "reading: the ADRs reread" "**Does each ADR to reread stand with the specifications and the other ADRs?**"
require rereading-a-technical-design "the held reading reports a block and a part of the design" "Report a block that writes into a specification a rule an ADR contradicts, and a part of the design that an ADR rules out or that would make the code break one."
require rereading-a-technical-design "the reread reading reports a contradiction and an observable rule" "Report an ADR that contradicts a specification, an ADR that contradicts another ADR, and an ADR that states what a user or a neighbouring module would observe"
```

Remplacer le `case` qui compte les lectures :

```bash
    *[Ff]"ive readings"*|*[Ff]"ive readers"*|*"of the five"*)
```

par :

```bash
    *[Ff]"ive readings"*|*[Ff]"ive readers"*|*"of the five"*|*[Ss]"ix readings"*|*[Ss]"even readings"*|*[Ss]"even readers"*|*"of the seven"*|*[Tt]"wo new readings"*)
```

Après la garde `an undescribed behaviour always goes up`, ajouter :

```bash
require rereading-a-technical-design "a finding on a block goes to the human" "A finding on a block is not fixed: put it to your human partner, who leaves the block as it is or takes the batch back to its spec delta, which ends the reread. This reread revises no block."
require rereading-a-technical-design "a finding on an ADR goes to the human" "A finding on an ADR is not fixed either: put it to your human partner, and return it with what they ruled. This reread revises no ADR."
require rereading-a-technical-design "the copy of a round's state holds the ADRs reread" "The copy holds the batch document and each ADR the round reread."
require rereading-a-technical-design "red flag: fixing an ADR" "| \"The reader is right about this ADR, I'll fix its wording\" | This reread revises no ADR. Put the finding to your human partner, and return it with what they ruled. |"
require rereading-a-technical-design "red flag: adjusting a block" "| \"This block contradicts an ADR, I'll adjust the block\" | This reread revises no block. Put the finding to your human partner. |"
require rereading-a-technical-design "red flag: no design, nothing to reread" "| \"The batch has no design, so there is nothing to reread\" | A reading is dispatched when its object exists. An ADR the pull request writes is reread whatever the batch carries. |"
```

Dans `tests/test-skill-contracts.sh`, après le bloc `absent "the technical reread names no skill that invokes it"`, ajouter :

```bash
# A reading is dispatched when its object exists: the sentence that gave every
# batch every reading must survive nowhere, or a batch with no design would send
# out readings that have nothing to read.
absent "the technical reread no longer gives every batch every reading" \
    "Every batch gets every reading" \
    rereading-a-technical-design
```

Dans `tests/test-technical-reader-prompt.sh`, remplacer le bloc qui va de `has "one reader carries one reading"` à `has "a reader runs nothing"` par :

```bash
has "one reader carries one reading"        "One reader, one reading, one batch"
has "the reading comes from the skill"      "one of the readings that \`## The Readings\` of the skill states, pasted word for word from there"
# A slot the reading does not use says so: left as written, it reads as a path.
has "an unused slot says so"                "In a slot the reading does not use, write \`not used by this reading\`"
has "the batch document is handed over"     "**The batch document:**"
# The reading names what the reader evaluates; the frame defines the names.
has "the reading names what is evaluated"   "Your reading, below, names what you evaluate"
has "the design is the two sections"        "Where it names the design, that is the document's \`Technical design\` section and its \`Constraints\` section"
has "the blocks are the spec delta's changes" "Where it names the blocks, those are the changes its \`Spec delta\` section writes into the specifications"
has "a none section gives nothing"          "A section that reads \`none\` gives you nothing to evaluate"
has "a none section is no finding"          "and its absence is not a finding"
has "the rest says what the batch promises" "The rest of the document says what the batch promises: read it for that"
has "the ADRs to reread are handed over"    "**The ADRs to reread:**"
has "the ADRs to reread are those listed"   "Where your reading names the ADRs to reread, these are the ones"
# What the reading does not name is what it is read against, never evaluated.
has "the applied specs are handed over"     "**The specifications, with the batch's changes applied:**"
has "the other specs are handed over"       "**The other specifications:**"
has "the ADR directory is handed over"      "**The ADR directory:**"
has "the code is handed over"               "**The code as it stands today:**"
has "only what the reading names is evaluated" "Report only on what your reading names. Everything else is what you read it against: report nothing about it"
# A later round's reader gets the state the round before read, and reports on the
# revision alone.
has "a first round's reader gets no previous state" "For the first round, leave out the paragraph on the state the previous round read"
has "a later round's reader gets the state last read" "**The state the previous round read:**"
has "the state last read holds the ADRs reread" "and to the copy of each ADR it reread"
has "a later round reports on the revision" "Report only what the revision between that state and the files above makes wrong: a sentence it added, moved or reworded, and a passage that leaned on a sentence it took out"
has "a later round leaves the unchanged alone" "Report nothing that stands unchanged since that state"
has "a reader loads no unnamed skill"       "Load no skill your reading does not name"
has "everything needed is in the prompt"    "Everything you need is in this prompt"
has "a finding quotes its passage"          "the passage it bears on, quoted with the file and the section it"
has "an empty result is reported"           "Return \"nothing found\" when you found nothing"
has "a reader revises nothing"              "Do not revise what you read, and do not modify the code"
has "a reader dispatches nothing"           "Do not dispatch subagents"
# A reader handed a working tree is tempted to run its test suite. What the suite
# says is the code's business; the reading is about what it names.
has "a reader runs nothing"                 "Run nothing, neither a test, a build nor a script: you read files and search them"

# The frame no longer says the design is all a reader evaluates: a reading may
# name the blocks or the ADRs to reread.
case "$FLAT" in
    *"your findings are about the design"*|*"The document you are evaluating"*|*"Do not revise the design"*|*"You are reading the technical design and the constraints"*)
        fail "the frame is not bound to the design" ;;
    *)  pass "the frame is not bound to the design" ;;
esac

# The prompt names no skill of the plugin.
case "$FLAT" in
    *"supercharlouze:"*|*"writing-a-batch"*|*"recording-a-decision"*)
        fail "the prompt names no skill of the plugin" ;;
    *)  pass "the prompt names no skill of the plugin" ;;
esac
```

Dans la liste `NEEDLES` du même fichier, ajouter deux lignes après `How does this design fail` :

```
blocks and the design hold the ADRs
stand with the specifications and the other ADRs
```

et remplacer :

```bash
    *[Ff]"ive readings"*|*"of the five"*)
```

par :

```bash
    *[Ff]"ive readings"*|*"of the five"*|*[Ss]"even readings"*|*"of the seven"*)
```

- [ ] **Step 2: Lancer les gardes et les voir rouges**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL; bash tests/test-technical-reader-prompt.sh | grep FAIL`
Expected: chaque garde ajoutée ou changée ci-dessus est en `[FAIL]`, sauf `the prompt names no skill of the plugin`, verte dès maintenant ; aucune autre.

- [ ] **Step 3: Réécrire `skills/rereading-a-technical-design/SKILL.md`**

Remplacer la ligne `description:` du frontmatter par :

```
description: Use only when a skill tells you to invoke rereading-a-technical-design, never on a request to reread a text - dispatches one reader per reading, outside the context that wrote what it reads, and returns the technical design and constraints revised, with the findings on the blocks and on the ADRs
```

Dans `## Overview`, après le premier paragraphe, ajouter ce paragraphe :

```markdown
The reread also reads the batch's blocks against the ADRs, and rereads each ADR
that the pull request opening or amending the batch writes or rewrites.
```

Remplacer tout `## Input and Output` par :

```markdown
## Input and Output

The input is:

- the batch document;
- each spec the batch touches, with the batch's blocks applied;
- `docs/specs/`, for the specs the batch does not touch;
- `docs/adr/`, as the pull request that opens or amends the batch leaves it;
- the path of each ADR that pull request writes or rewrites.

The readers read the code as `main` carries it. Hand them the root of a working
tree whose code is `origin/main`'s: a branch started from `origin/main` that
changes only documents has one.

When no reading is dispatched (`The Readings`), return "nothing to reread".

When the rounds are over, return:

- the technical design and the constraints, revised: every finding worked
  through, and every ruling of your human partner applied;
- the behaviours and the blocks your human partner took back to the spec delta,
  which ended the reread;
- the findings on an ADR, each with what your human partner ruled on it;
- what the reread found, or that it found nothing, written for a pull request
  body.
```

Dans `## The Readings`, remplacer :

```markdown
Every batch gets every reading. This is the first round's dispatch: a later
round sends out fewer (`Findings and Rounds`).
```

par :

```markdown
Dispatch a reading when its object exists. This is the first round's dispatch: a
later round sends out fewer (`Findings and Rounds`). When no object exists,
dispatch nothing.

The object of these readings is the design: the batch document's
`Technical design` and `Constraints`. It exists unless both read `none`.
```

Après la lecture `**How does this design fail?**` et avant le paragraphe `The architecture and module readings invoke their skill only if present.`, insérer :

```markdown
The object of this reading is the batch's blocks and its design. It exists when
`docs/adr/` carries an ADR, a `.md` file placed directly in it, and the batch
has a block or a design.

> **Do the blocks and the design hold the ADRs?** An ADR records a technical
> decision that the code to come must hold: it is a `.md` file placed directly
> in the ADR directory. Read every one. Report a block that writes into a
> specification a rule an ADR contradicts, and a part of the design that an ADR
> rules out or that would make the code break one.

The object of this reading is each ADR the pull request writes or rewrites. It
exists when the input names one.

> **Does each ADR to reread stand with the specifications and the other ADRs?**
> An ADR records a technical decision that the code to come must hold. Read each
> ADR to reread against every specification, the batch's changes applied, and
> against every other `.md` file placed directly in the ADR directory. Report an
> ADR that contradicts a specification, an ADR that contradicts another ADR, and
> an ADR that states what a user or a neighbouring module would observe: that is
> a rule of a specification, never a decision an ADR records.
```

Dans `## Findings and Rounds`, après le paragraphe qui finit par `this reread writes no block.`, insérer :

```markdown
A finding on a block is not fixed: put it to your human partner, who leaves the
block as it is or takes the batch back to its spec delta, which ends the reread.
This reread revises no block.

A finding on an ADR is not fixed either: put it to your human partner, and
return it with what they ruled. This reread revises no ADR.
```

Dans le même `## Findings and Rounds`, remplacer :

```markdown
A round runs on the revised text. Keep a copy of the state each round read: the
next round's readers are handed it. These stop the rounds, and without them they
chain indefinitely:
```

par :

```markdown
A round runs on the revised text. Keep a copy of the state each round read: the
next round's readers are handed it. The copy holds the batch document and each
ADR the round reread. These stop the rounds, and without them they chain
indefinitely:
```

À la fin de la table de `## Red Flags`, ajouter ces lignes :

```markdown
| "The reader is right about this ADR, I'll fix its wording" | This reread revises no ADR. Put the finding to your human partner, and return it with what they ruled. |
| "This block contradicts an ADR, I'll adjust the block" | This reread revises no block. Put the finding to your human partner. |
| "The batch has no design, so there is nothing to reread" | A reading is dispatched when its object exists. An ADR the pull request writes is reread whatever the batch carries. |
```

- [ ] **Step 4: Réécrire `skills/rereading-a-technical-design/references/reader-prompt.md`**

Remplacer tout le fichier par :

```markdown
# Technical Design Reread — Reader Prompt

One reader, one reading, one batch. Fill every `<…>` slot before dispatching: a
slot left as written is a reader with nothing to read. In a slot the reading
does not use, write `not used by this reading`. For the first round, leave out
the paragraph on the state the previous round read, with its heading.

The reading is one of the readings that `## The Readings` of the skill states,
pasted word for word from there. This file restates none of them: a second copy
here would drift from that section.

---

You are reading part of one batch of work. You did not write what you read, and
you are not being asked to improve it.

**The batch document:** `<path to the batch document>`

Your reading, below, names what you evaluate. Where it names the design, that is
the document's `Technical design` section and its `Constraints` section. Where
it names the blocks, those are the changes its `Spec delta` section writes into
the specifications. A section that reads `none` gives you nothing to evaluate,
and its absence is not a finding. The rest of the document says what the batch
promises: read it for that.

**The ADRs to reread:** `<path to each ADR the pull request writes or rewrites>`

Where your reading names the ADRs to reread, these are the ones.

**The state the previous round read:** `<path to the copy of the batch document that the round before read, and to the copy of each ADR it reread>`

A round has already read that state. Report only what the revision between that
state and the files above makes wrong: a sentence it added, moved or reworded,
and a passage that leaned on a sentence it took out. Report nothing that stands
unchanged since that state.

**The specifications, with the batch's changes applied:** `<path to each specification the batch touches, with its blocks applied>`

They state what the code must do once the batch is delivered.

**The other specifications:** `<the directory of the project's specifications, for those the batch does not touch>`

**The ADR directory:** `<the directory of the project's ADRs, as the pull request leaves it>`

**The code as it stands today:** `<root of a working tree whose code is origin/main's>`

Read what your reading needs of it.

**Your reading, and only yours:**

<the one reading, word for word from `## The Readings` of the skill>

Report only on what your reading names. Everything else is what you read it
against: report nothing about it.

**Load no skill your reading does not name.** Everything you need is in this
prompt. Going to read the skill that dispatched you would put the other readers'
readings in front of you, and a reader holding several does the cheapest of them
and returns.

**Return, for each finding:** the passage it bears on, quoted with the file and
the section it sits in; what is wrong with that passage under your reading; and
how sure you are. Return "nothing found" when you found nothing: an empty report
and a reader that failed look the same to whoever reads it.

Do not revise what you read, and do not modify the code: naming what is wrong is
your job, deciding what replaces it is not. Do not dispatch subagents. Run
nothing, neither a test, a build nor a script: you read files and search them.
```

- [ ] **Step 5: Lancer les gardes et les voir vertes**

Run: `bash tests/test-skill-content.sh | grep -c FAIL; bash tests/test-skill-contracts.sh | grep -c FAIL; bash tests/test-technical-reader-prompt.sh | grep -c FAIL; bash tests/test-cross-references.sh | grep -c FAIL`
Expected: `0` quatre fois.

- [ ] **Step 6: Commit**

```bash
bash ~/.config/github-app/as-agent.sh git -C <worktree> add skills/rereading-a-technical-design tests/test-skill-content.sh tests/test-skill-contracts.sh tests/test-technical-reader-prompt.sh
bash ~/.config/github-app/as-agent.sh git -C <worktree> commit -m "feat: la relecture technique relit les blocs et les ADR

Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 2: L'ouverture d'un lot écrit les ADR et invoque toujours la relecture technique

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## Opening, in Order`, une section neuve `## The ADRs`, `## The Technical Reread`, `## Opening the Pull Request`, `## Red Flags`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: l'entrée et la sortie de `rereading-a-technical-design` que la tâche 1 fixe ; l'entrée de `supercharlouze:recording-a-decision`, déjà sur la branche : la décision et sa raison, le chemin de l'ADR à réécrire, et des copies de specs à lire à la place des fichiers de `docs/specs/`.
- Produces: rien qu'une autre tâche consomme.

- [ ] **Step 1: Changer et écrire les gardes**

Dans `tests/test-skill-content.sh`, remplacer :

```bash
require writing-a-batch "the technical reread is step 6"        "6. **Put the technical design and the constraints through the technical reread** — skipped when the batch has neither (\`The Technical Reread\`)."
```

par :

```bash
require writing-a-batch "step 3 ends on the ADRs"               "then write, rewrite or delete the ADRs your human partner decided (\`The ADRs\`)"
require writing-a-batch "the technical reread is step 6"        "6. **Put the batch through the technical reread** (\`The Technical Reread\`)."
```

Remplacer :

```bash
require writing-a-batch "the technical reread's object is stated" "The technical reread bears on the technical design and the constraints, against the specs with the blocks applied and against the code on \`main\`."
```

par :

```bash
require writing-a-batch "the technical reread's object is stated" "The technical reread bears on the technical design and the constraints, on the blocks read against the ADRs, and on the ADRs this pull request writes or rewrites."
```

Remplacer :

```bash
require writing-a-batch "the design goes through the technical reread" "the technical design and the constraints go through the **technical reread**"
require writing-a-batch "a batch with neither skips it"         "A batch whose \`Technical design\` and \`Constraints\` both read \`none\` skips this step"
```

par :

```bash
require writing-a-batch "the batch goes through the technical reread" "After the coherence reread, the batch goes through the **technical reread**"
require writing-a-batch "the technical reread reads against the ADRs" "the blocks, the technical design and the constraints against the ADRs as this pull request leaves them, and each ADR this pull request writes or rewrites against the specs and the other ADRs"
require writing-a-batch "the technical reread is invoked for every batch" "**Invoke it for every batch.** It returns that it has nothing to reread when that is so"
require writing-a-batch "the invocation hands the specs, the ADRs and their paths" "Hand it also \`docs/specs/\`, \`docs/adr/\` and the path of each ADR this pull request writes or rewrites."
require writing-a-batch "a block taken back restarts the delta" "A block it returns as taken back to the spec delta does the same, with the block as your human partner corrects it."
require writing-a-batch "the technical reread changes no ADR" "It changes no ADR either."
require writing-a-batch "an ADR corrected on a finding goes back through the reread" "When your human partner has an ADR corrected on a finding it returns, invoke \`supercharlouze:recording-a-decision\` if the correction changes the ADR's decision, and correct the text yourself if it does not. Then invoke the technical reread again."
```

Après la garde `the red flag sends the design to the reread`, ajouter :

```bash
# --- writing-a-batch: the ADRs of an opening (spec section "Opening a batch") ---
require writing-a-batch "the ADRs change in the opening pull request" "The ADRs your human partner decided during the brainstorming to write, to rewrite or to abandon change in this pull request, with the batch document."
require writing-a-batch "the applied copies are built before an ADR is written" "Once the batch document is written, build a copy of each spec the batch touches with its blocks applied, as \`The Coherence Reread\` builds it."
require writing-a-batch "an ADR is confronted with the specs as the batch leaves them" "An ADR is confronted with the specs as the batch leaves them, and no block is in a spec yet."
require writing-a-batch "an ADR is written by the shared skill" "Invoke \`supercharlouze:recording-a-decision\` for each ADR to write or to rewrite, and hand it those copies."
require writing-a-batch "an abandoned ADR is deleted" "Delete yourself each ADR your human partner abandoned. The commit that deletes one says why, as the commit that rewrites one does."
require writing-a-batch "the PR body puts the ADRs to the reviewer" "any flag lifting the delta announces; and each ADR this pull request writes, rewrites or deletes."
require writing-a-batch "red flag: skipping the technical reread" "| \"The batch has no design and no constraints, I'll skip the technical reread\" | Invoke it for every batch. It says itself when it has nothing to reread, and it rereads the ADRs this pull request writes. |"
require writing-a-batch "red flag: writing the ADR by hand" "| \"My human partner decided this ADR, I'll write the file myself\" | Invoke \`supercharlouze:recording-a-decision\`. It confronts the decision with the specs, blocks applied, and with the other ADRs. |"
require writing-a-batch "red flag: an ADR nobody decided" "| \"This design decision deserves an ADR, I'll write it with the batch\" | Only your human partner decides an ADR. Put the decision to them, and write it once they want it. |"
```

Dans `tests/test-skill-contracts.sh`, remplacer le bloc :

```bash
absent "the batch skill carries no technical reading of its own" \
    "deliver what the batch promises|stand on the code as it is|hold as an architecture|modules this design draws deep|How does this design fail" \
    writing-a-batch
```

par :

```bash
absent "the batch skill carries no technical reading of its own" \
    "deliver what the batch promises|stand on the code as it is|hold as an architecture|modules this design draws deep|How does this design fail|blocks and the design hold the ADRs|stand with the specifications and the other ADRs" \
    writing-a-batch

# The opening invokes the technical reread for every batch, and the reread says
# itself when it has nothing to reread: the former skip must survive nowhere, or
# a batch with no design would open with its ADRs unread.
absent "the opening no longer skips the technical reread" \
    "skipped when the batch has neither|both read \`none\` skips this step" \
    writing-a-batch
```

- [ ] **Step 2: Lancer les gardes et les voir rouges**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: chaque garde ajoutée ou changée ci-dessus est en `[FAIL]`, sauf la partie de `the batch skill carries no technical reading of its own`, verte ; aucune autre.

- [ ] **Step 3: Écrire `## Opening, in Order`**

Dans `skills/writing-a-batch/SKILL.md`, remplacer l'étape 3 :

```markdown
3. **Write the batch document**: `Scope`, `Spec delta`, `Technical design`,
   `Constraints`, `Feature flag` (`The Batch Document`,
   `The Feature Flag Field`, `Flags Declared by Earlier Batches`).
```

par :

```markdown
3. **Write the batch document**: `Scope`, `Spec delta`, `Technical design`,
   `Constraints`, `Feature flag` (`The Batch Document`,
   `The Feature Flag Field`, `Flags Declared by Earlier Batches`), then write,
   rewrite or delete the ADRs your human partner decided (`The ADRs`).
```

Remplacer l'étape 6 :

```markdown
6. **Put the technical design and the constraints through the technical
   reread** — skipped when the batch has neither (`The Technical Reread`).
```

par :

```markdown
6. **Put the batch through the technical reread** (`The Technical Reread`).
```

Dans le paragraphe `**The rereads are steps 5, 6 and 7, and each has its own object.**`, remplacer la phrase :

```markdown
The technical reread bears on the technical design and the constraints, against
the specs with the blocks applied and against the code on `main`.
```

par :

```markdown
The technical reread bears on the technical design and the constraints, on the
blocks read against the ADRs, and on the ADRs this pull request writes or
rewrites.
```

et rewrapper le paragraphe sans changer ses autres phrases.

- [ ] **Step 4: Écrire `## The ADRs`**

Insérer cette section entre la fin de `## Flags Declared by Earlier Batches` et `## The Coherence Reread` :

```markdown
## The ADRs

The ADRs your human partner decided during the brainstorming to write, to
rewrite or to abandon change in this pull request, with the batch document.

Once the batch document is written, build a copy of each spec the batch touches
with its blocks applied, as `The Coherence Reread` builds it. An ADR is
confronted with the specs as the batch leaves them, and no block is in a spec
yet.

Invoke `supercharlouze:recording-a-decision` for each ADR to write or to
rewrite, and hand it those copies.

Delete yourself each ADR your human partner abandoned. The commit that deletes
one says why, as the commit that rewrites one does.
```

- [ ] **Step 5: Réécrire `## The Technical Reread`**

Remplacer toute la section, de son titre jusqu'à la ligne qui précède `## Opening the Pull Request`, par :

```markdown
## The Technical Reread

After the coherence reread, the batch goes through the **technical reread**. It
reads the technical design and the constraints against the specs with the blocks
applied and against the code on `main`, the blocks, the technical design and the
constraints against the ADRs as this pull request leaves them, and each ADR this
pull request writes or rewrites against the specs and the other ADRs.

**Start it only once the coherence reread has closed its rounds.** Run side by
side, each reread revises what the other is reading, and neither reads a state
that holds.

**Invoke it for every batch.** It returns that it has nothing to reread when
that is so, and a skip decided here would be a second copy of its rule.

Invoke `supercharlouze:rereading-a-technical-design` with the batch document and
each spec the batch touches: the applied copy the coherence reread built, or the
spec itself when no block targets it. Hand it also `docs/specs/`, `docs/adr/`
and the path of each ADR this pull request writes or rewrites.

Carry every revision it returns back into `Technical design` and `Constraints`.

The technical reread never changes `Spec delta`, and sends nothing back through
the coherence reread. A behaviour it returns as taken back to the spec delta
sends the opening back to step 5, with the block your human partner rules. A
block it returns as taken back to the spec delta does the same, with the block
as your human partner corrects it.

It changes no ADR either. When your human partner has an ADR corrected on a
finding it returns, invoke `supercharlouze:recording-a-decision` if the
correction changes the ADR's decision, and correct the text yourself if it does
not. Then invoke the technical reread again.

The body of the pull request that runs it, opening or amendment, says what it
found, or that it found nothing.
```

- [ ] **Step 6: Écrire le corps de la pull request et les `Red Flags`**

Dans `## Opening the Pull Request`, remplacer :

```markdown
the flag decision; the scope, with the entries it takes on; and any flag
lifting the delta announces.
```

par :

```markdown
the flag decision; the scope, with the entries it takes on; any flag lifting
the delta announces; and each ADR this pull request writes, rewrites or deletes.
```

À la fin de la table de `## Red Flags`, ajouter ces lignes :

```markdown
| "The batch has no design and no constraints, I'll skip the technical reread" | Invoke it for every batch. It says itself when it has nothing to reread, and it rereads the ADRs this pull request writes. |
| "My human partner decided this ADR, I'll write the file myself" | Invoke `supercharlouze:recording-a-decision`. It confronts the decision with the specs, blocks applied, and with the other ADRs. |
| "This design decision deserves an ADR, I'll write it with the batch" | Only your human partner decides an ADR. Put the decision to them, and write it once they want it. |
```

- [ ] **Step 7: Lancer les gardes et les voir vertes**

Run: `bash tests/test-skill-content.sh | grep -c FAIL; bash tests/test-skill-contracts.sh | grep -c FAIL; bash tests/test-cross-references.sh | grep -c FAIL`
Expected: `0` trois fois.

- [ ] **Step 8: Commit**

```bash
bash ~/.config/github-app/as-agent.sh git -C <worktree> add skills/writing-a-batch tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git -C <worktree> commit -m "feat: l'ouverture d'un lot écrit les ADR que l'humain a décidés

Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 3: La revue d'ouverture porte les ADR, dans `using-batches` et dans le `README.md`

**Files:**
- Modify: `skills/using-batches/SKILL.md` (`## The Git Model`, `## What Is Kept, What Is Rerouted`)
- Modify: `README.md` (`### The life of a batch`)
- Test: `tests/test-skill-content.sh`, `tests/test-cross-references.sh`

**Interfaces:**
- Consumes: rien.
- Produces: rien qu'une autre tâche consomme.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, après la garde `the delivery gate carries the ADRs the review asks for`, ajouter :

```bash
require using-batches "the opening gate carries the ADRs changed with the batch document" \
        "| Batch opening | the pull request carrying the batch document, and the ADRs written, rewritten or deleted with it |"
require using-batches "the opening writes the ADRs the design decided" \
        "On the architectural path, \`supercharlouze:writing-a-batch\` writes, rewrites or deletes at the opening the ADRs they decide."
```

Dans `tests/test-cross-references.sh`, après le bloc `the README's delivery gate carries the ADRs the review asks for`, ajouter :

```bash
# The opening gate carries the ADRs written, rewritten or deleted with the batch
# document, in the README's gate table too.
case "$README_FLAT" in
    *"| Batch opening | the exact text each spec will receive, before a line of code is written against it, and the ADRs written, rewritten or deleted with it |"*)
        pass "the README's opening gate carries the ADRs changed with the batch document" ;;
    *)  fail "the README's opening gate carries the ADRs changed with the batch document" ;;
esac
```

- [ ] **Step 2: Lancer les gardes et les voir rouges**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-cross-references.sh | grep FAIL`
Expected: les trois gardes ajoutées sont en `[FAIL]`, aucune autre.

- [ ] **Step 3: Écrire les textes**

Dans `skills/using-batches/SKILL.md`, dans la table des revues de `## The Git Model`, remplacer :

```markdown
| Batch opening | the pull request carrying the batch document |
```

par :

```markdown
| Batch opening | the pull request carrying the batch document, and the ADRs written, rewritten or deleted with it |
```

Dans `## What Is Kept, What Is Rerouted`, à la fin du paragraphe `**The design reads \`docs/adr/\`.**`, après la phrase `An approach that breaks an ADR is one the code may not take, and only your human partner decides an ADR.`, ajouter dans le même paragraphe :

```markdown
On the architectural path, `supercharlouze:writing-a-batch` writes, rewrites or deletes at the opening the ADRs they decide.
```

Dans `README.md`, dans la table des revues, remplacer :

```markdown
| Batch opening | the exact text each spec will receive, before a line of code is written against it |
```

par :

```markdown
| Batch opening | the exact text each spec will receive, before a line of code is written against it, and the ADRs written, rewritten or deleted with it |
```

Ne pas toucher à la table de routage de `using-batches`, ni aux lignes `Batch amendment` des deux tables.

- [ ] **Step 4: Lancer les gardes et les voir vertes**

Run: `bash tests/test-skill-content.sh | grep -c FAIL; bash tests/test-cross-references.sh | grep -c FAIL; bash tests/test-skill-contracts.sh | grep -c FAIL; bash tests/test-declared-overrides.sh | grep -c FAIL`
Expected: `0` quatre fois.

- [ ] **Step 5: Commit**

```bash
bash ~/.config/github-app/as-agent.sh git -C <worktree> add skills/using-batches README.md tests/test-skill-content.sh tests/test-cross-references.sh
bash ~/.config/github-app/as-agent.sh git -C <worktree> commit -m "feat: la revue d'ouverture porte les ADR du lot

Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

## Observed drift
