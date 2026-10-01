# La contrainte intenable Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Une story dont le lot déclare des contraintes s'arrête quand l'une d'elles ne peut pas être tenue, et la soumet à l'humain.

**Architecture:** Le plugin est fait de skills Markdown gardées par une suite structurelle en bash. `using-batches` écrit la condition d'arrêt dans son texte anglais de référence, sous l'override 2, et `writing-a-user-story` la recopie mot pour mot dans `Global Constraints` et la nomme à l'étape 5. Les phrases qui comptent les conditions d'arrêt cessent de les compter, dans les skills et le README. Chaque tâche écrit d'abord ses gardes, les voit échouer, puis écrit le texte qui les fait passer.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/10-la-conception-technique/README.md
**Sections:** Departures from superpowers, Story > The user story document
**Blocks:** D3, D12

## Global Constraints

Les contraintes du lot, recopiées mot pour mot :

> `D1` précède `D2`, `D4`, `D5`, `D6`, `D7`, `D8`, `D9`, `D10`, `D11` et `D13`, qui
> nomment la conception technique.
>
> `D2` précède `D13`, qui nomme l'arbitrage de conception technique.
>
> `D3` précède `D10` et `D12`, qui renvoient à la condition d'arrêt qu'il écrit.
>
> `D7` précède `D8` et `D10`, qui nomment la relecture technique.
>
> Un lot ouvert avant la transcription de `D6` n'a pas de champ `Technical design` :
> sa clôture n'a rien à réécrire, et ses stories n'ont pas de conception dont partir.

Le gel du fichier de spec :

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

La primauté de la spec : when the batch and the spec contradict each other, the
spec wins — without exception and without deliberation. Implement what the spec
says, record a `Ruling:`, and carry on. Correcting a spec mid-batch is a human
act, never an agent's.

Les règles de concision :

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

La condition d'arrêt sur une contrainte qui ne peut pas être tenue, puisque ce lot
déclare des contraintes :

> Si, en conduisant une story, tu découvres qu'une contrainte de son lot ne peut
> pas être tenue, arrête-toi et soumets-la à l'humain.
>
> Une contrainte que la spec contredit ne relève pas de cette condition, mais de
> `Authority and conflict rules`.

Les skills sont entièrement en anglais. Une skill ne cite jamais une section de
`docs/specs/supercharlouze.md`.

## Review Focus

- Un agent qui trouve une contrainte contredite par la spec ne s'arrête pas : la
  phrase qui l'exclut de la condition voyage avec la condition, dans
  `using-batches` comme dans la copie de `writing-a-user-story`.
- L'étape 5 de `writing-a-user-story` ne dit pas de la nouvelle condition qu'elle
  abandonne la story ni qu'elle passe la main à `writing-a-batch` : ce qui suit
  l'arrêt est un bloc d'une story ultérieure (`D10`).
- Aucune phrase ne compte plus les conditions d'arrêt du flux : « adds two » ne
  survit ni dans `using-batches`, ni dans `writing-a-user-story`, ni dans
  `writing-a-batch`, ni dans le README.
- Une story technique dont le lot déclare des contraintes porte les deux
  conditions : la nouvelle s'écrit sans exclure aucune autre.
- La copie de la condition dans `writing-a-user-story` est identique, octet pour
  octet après aplatissement, au texte de référence de `using-batches`.

---

### Task 1: `using-batches` écrit la condition d'arrêt sur une contrainte

**Files:**
- Modify: `skills/using-batches/SKILL.md` (section `### Override 2 — the stop conditions the flow adds`)
- Test: `tests/test-declared-overrides.sh`, `tests/test-skill-content.sh`

**Interfaces:**
- Produces: le texte de référence anglais de la condition, que la tâche 2 recopie mot pour mot :
  - `If, while conducting a story, you discover that a constraint of its batch cannot be held, stop and put the constraint to your human partner.`
  - `A constraint the spec contradicts does not fall under this condition: the spec wins.`

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-declared-overrides.sh`, remplacer l'aiguille de `check_verb "the stop conditions are extended, not restated"` :

```bash
check_verb "the stop conditions are extended, not restated" \
    "This plugin adds the conditions below. For corrective batches only:" \
    "extends the stop conditions of superpowers:subagent-driven-development"
```

Dans `tests/test-skill-content.sh`, remplacer la garde `require using-batches "a ruling replaces neither condition"` par :

```bash
require using-batches "a ruling replaces no stop condition" \
    "A ruling replaces none of them"
require using-batches "a story stops on a constraint it cannot hold" \
    "If, while conducting a story, you discover that a constraint of its batch cannot be held, stop and put the constraint to your human partner."
require using-batches "a contradicted constraint falls to the authority rule" \
    "A constraint the spec contradicts does not fall under this condition: the spec wins."
require using-batches "the human rules on the constraint" \
    "When the constraint condition fires, your human partner rules on the constraint."
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-declared-overrides.sh; bash tests/test-skill-content.sh | grep FAIL`
Expected: FAIL sur les cinq gardes ci-dessus.

- [ ] **Step 3: Rewrite Override 2**

Dans `skills/using-batches/SKILL.md`, remplacer le corps de `### Override 2 — the stop conditions the flow adds`, de sa première ligne jusqu'à la ligne `When either condition fires, …` incluse, par :

```markdown
`superpowers:subagent-driven-development` states *"Four things stop you, and only these"*. This plugin adds the conditions below. For corrective batches only:

> If, while bringing code into conformance with a spec, you discover that it is the **spec** that is wrong and the code that is right, stop. The batch is no longer corrective and must be requalified.

For a technical story only:

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

For a story whose batch declares constraints only:

> If, while conducting a story, you discover that a constraint of its batch cannot be held, stop and put the constraint to your human partner.

A constraint the spec contradicts does not fall under this condition: the spec wins.

A ruling replaces none of them. A ruling is a decision an agent takes on its human partner's behalf, and none of these is an agent's to take: the corrective condition would correct a spec, the technical condition would keep a qualification the story has just lost, and the constraint condition would break a decision another story of the batch relies on. Recording one and carrying on is exactly the failure these conditions exist to prevent.

Justification: the four native conditions assume a valid authority exists, assume the story is the story it says it is, and know nothing of the stories beside it. A corrective batch puts the authority in question; a technical story puts its own qualification in question — "purely technical" is otherwise the door through which behaviour enters with no gate behind it, since a story that transcribes no block passes no opening review; and a constraint is what the other stories of its batch rely on, so a story that cannot hold one cannot settle it alone.

When the corrective or the technical condition fires, you stop, and `supercharlouze:writing-a-batch` conducts the requalification: under `Requalifying a Corrective Batch` for the corrective one, under `Requalifying a Technical Story` for the technical one.

When the constraint condition fires, your human partner rules on the constraint.
```

- [ ] **Step 4: Run the guards to verify they pass**

Run: `bash tests/test-declared-overrides.sh && bash tests/test-skill-content.sh && bash tests/test-cross-references.sh`
Expected: PASS, aucun FAIL.

- [ ] **Step 5: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-declared-overrides.sh tests/test-skill-content.sh
git commit -m "feat: using-batches arrête une story sur une contrainte de son lot qui ne peut pas être tenue"
```

### Task 2: `writing-a-user-story` porte la condition dans `Global Constraints`

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (`## Step 4 — Write the Plan`, `## Step 5 — Execute`, `## Red Flags`)
- Test: `tests/test-skill-contracts.sh`, `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: les deux phrases de référence écrites par la tâche 1 dans `using-batches`.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-contracts.sh`, après la garde `shared "the technical stop condition is copied exactly as stated"`, ajouter :

```bash
# The stop condition on a constraint that cannot be held travels the same way,
# with the sentence that bounds it: an implementer who meets a constraint the
# spec contradicts must find, in the same copy, that this is not the case.
shared "the constraint stop condition is copied exactly as stated" \
    "If, while conducting a story, you discover that a constraint of its batch cannot be held, stop and put the constraint to your human partner. A constraint the spec contradicts does not fall under this condition: the spec wins." \
    using-batches writing-a-user-story
```

Dans `tests/test-skill-content.sh`, après `require writing-a-user-story "GC lists the technical stop condition" …`, ajouter :

```bash
require writing-a-user-story "GC lists the constraint stop condition" \
    "- **in a story whose batch declares constraints only**, the stop condition on a constraint that cannot be held."
require writing-a-user-story "GC carries the constraint stop condition" \
    "carries the stop condition on a constraint that cannot be held, written out in full"
require writing-a-user-story "a batch declares constraints when they are not none" \
    "A batch declares constraints when its \`Constraints\` section is not \`none\`."
require writing-a-user-story "the constraint condition leaves the branch as it is" \
    "your human partner rules on the constraint, and until then the branch and the worktree stay as they are."
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-contracts.sh | grep FAIL; bash tests/test-skill-content.sh | grep FAIL`
Expected: FAIL sur les cinq gardes ci-dessus.

- [ ] **Step 3: Write the list item of `Global Constraints`**

Dans `## Step 4 — Write the Plan`, remplacer la fin de la liste de `Global Constraints` :

```markdown
- **in a technical story only**, the stop condition proper to a technical
  story.
```

par :

```markdown
- **in a technical story only**, the stop condition proper to a technical
  story;
- **in a story whose batch declares constraints only**, the stop condition on a
  constraint that cannot be held.
```

- [ ] **Step 4: Write the copied condition**

Dans `## Step 4 — Write the Plan`, après le paragraphe qui suit la condition propre à une story technique (celui qui finit par « obey it. ») et avant `**Commit the story document — …`, insérer :

```markdown
**In a story whose batch declares constraints, `Global Constraints` carries the
stop condition on a constraint that cannot be held, written out in full.** A
batch declares constraints when its `Constraints` section is not `none`. Copy the
block below verbatim, exactly as `supercharlouze:using-batches` states it:

> If, while conducting a story, you discover that a constraint of its batch cannot be held, stop and put the constraint to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

A constraint is a decision another story of the batch relies on, so an
implementer who works around it breaks a story they cannot see.
```

- [ ] **Step 5: Name the condition at Step 5**

Dans `## Step 5 — Execute`, remplacer :

```markdown
**Override 2 — the stop conditions the flow adds.** SDD states that four things
stop you and only these. This plugin adds two, and each one ends the same way:
**the story is abandoned**, and the decision goes to
`supercharlouze:writing-a-batch`.
```

par :

```markdown
**Override 2 — the stop conditions the flow adds.** SDD states that four things
stop you and only these. This plugin adds its own. The corrective and the
technical conditions end the same way: **the story is abandoned**, and the
decision goes to `supercharlouze:writing-a-batch`.
```

Puis, juste avant le paragraphe qui commence par `It is named as an override for the same reason as the other three`, insérer :

```markdown
In a story whose batch declares constraints: if, while conducting it, you
discover that a constraint of its batch cannot be held, stop and put the
constraint to your human partner. A constraint the spec contradicts is not this
case, since the spec wins. When you stop, your human partner rules on the
constraint, and until then the branch and the worktree stay as they are.
```

- [ ] **Step 6: Answer the excuse in `Red Flags`**

Ajouter, à la fin du tableau de `## Red Flags` :

```markdown
| "This constraint cannot be held, I'll work around it and record a ruling" | A ruling replaces no stop condition. Another story of the batch relies on that constraint: stop and put it to your human partner. |
```

- [ ] **Step 7: Run the guards to verify they pass**

Run: `bash tests/test-skill-contracts.sh && bash tests/test-skill-content.sh && bash tests/test-cross-references.sh`
Expected: PASS, aucun FAIL.

- [ ] **Step 8: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md tests/test-skill-contracts.sh tests/test-skill-content.sh
git commit -m "feat: writing-a-user-story recopie la condition d'arrêt sur une contrainte dans Global Constraints"
```

### Task 3: plus rien ne compte les conditions d'arrêt

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (`## Requalifying a Corrective Batch`), `README.md` (`### The four departures`)
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: Override 2 réécrit par la tâche 1, l'étape 5 réécrite par la tâche 2.

- [ ] **Step 1: Write the failing guard**

À la fin de `tests/test-skill-contracts.sh`, avant `exit`, ajouter :

```bash
# The flow's stop conditions are named, never counted: a count goes false in
# every skill the day a condition is added, as it did when the constraint
# condition joined the corrective and the technical ones.
absent "no skill counts the stop conditions the flow adds" \
    "adds (two|three|four)( stop conditions|[.,])" \
    using-batches writing-a-user-story writing-a-batch
```

- [ ] **Step 2: Run the guard to verify it fails**

Run: `bash tests/test-skill-contracts.sh | grep FAIL`
Expected: FAIL « no skill counts the stop conditions the flow adds (present in: writing-a-batch) ».

- [ ] **Step 3: Stop counting in `writing-a-batch`**

Dans `## Requalifying a Corrective Batch`, remplacer :

```markdown
**Trigger — Override 2, the stop condition proper to a corrective batch.** This
plugin adds two stop conditions to
`superpowers:subagent-driven-development`, and this is the corrective one: while
```

par :

```markdown
**Trigger — Override 2, the stop condition proper to a corrective batch.** This
plugin adds stop conditions to `superpowers:subagent-driven-development`, and
this is the corrective one: while
```

- [ ] **Step 4: Stop counting in the README**

Dans `README.md`, remplacer l'élément 2 de `### The four departures` :

```markdown
2. **The flow adds two stop conditions.** If the code turns out to be right and
   the spec wrong, a corrective batch is no longer corrective and must be
   requalified. If a story declared technical turns out to change something
   observable at its module's boundary, it is no longer technical. An agent may
   neither correct a spec nor keep a qualification it has lost.
```

par :

```markdown
2. **The flow adds stop conditions.** If the code turns out to be right and the
   spec wrong, a corrective batch is no longer corrective and must be
   requalified. If a story declared technical turns out to change something
   observable at its module's boundary, it is no longer technical. If a story
   finds that a constraint of its batch cannot be held, it stops and puts the
   constraint to the human. An agent may neither correct a spec, nor keep a
   qualification it has lost, nor bend a constraint.
```

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: PASS, aucun FAIL. La suite dure plus de deux minutes : la lancer avec un délai de dix minutes.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-batch/SKILL.md README.md tests/test-skill-contracts.sh
git commit -m "feat: les conditions d'arrêt du flux ne sont plus comptées"
```

## Rulings log

## Observed drift
