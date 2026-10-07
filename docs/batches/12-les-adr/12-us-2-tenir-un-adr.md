# Tenir un ADR Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Le code d'une story ou d'un changement borné tient les ADR que `main` porte, une story s'arrête devant un ADR qu'elle ne peut pas tenir, son plan suit un ADR contre la conception technique du lot, et elle soumet à l'humain la décision qui mériterait un ADR.

**Architecture:** `using-batches` porte la règle (le code tient les ADR), étend aux ADR la condition d'arrêt de l'override 2 avec ce qui suit l'arrêt, donne au changement borné ses deux règles sur les ADR, et fait lire `docs/adr/` à la conception. `writing-a-user-story` fait lire `docs/adr/` au plan, recopie dans `Global Constraints` la condition d'arrêt étendue, les chemins des ADR tenus et les conditions d'un ADR, et fait écrire l'ADR à la revue de livraison. Le `README.md` suit. Chaque norme a sa garde dans `tests/`, écrite avant le texte.

**Tech Stack:** Markdown pour les skills et le `README.md`, Bash pour les gardes de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/12-les-adr/README.md
**Sections:** Boundary, Architecture decision records, Departures from superpowers, Authority and conflict rules, Batch > Amending a batch, Story > The user story document, Story > Delivering a story, Bounded change
**Blocks:** D4, D5, D6, D7, D8, D9, D10, D11, D12

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

Condition d'arrêt sur une contrainte qui ne peut pas être tenue :

> If, while conducting a story, you discover that a constraint of its batch cannot be held, stop and put the constraint to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

Règles du dépôt, qui valent pour chaque tâche :

- Une skill, un test et le `README.md` sont entièrement en anglais.
- Une skill ne cite jamais une section de `docs/specs/supercharlouze.md`. Une section qu'une skill nomme entre parenthèses est l'un de ses propres titres.
- Chaque norme qu'une skill énonce a sa garde dans `tests/`, écrite avant le texte et vue rouge.
- Chaque phrase d'une skill change ce qu'un agent fait. Pas de réfutation d'une version disparue, pas de cas particulier que la règle générale couvre déjà, pas de gras qui hiérarchise, pas de tiret à la place d'une virgule, pas de liste qui annonce combien d'éléments elle tient.
- Une règle est écrite en entier à un seul endroit et pointée ailleurs.
- Cette story ne livre que ce qui réalise `D4` à `D12`. Aucun texte ne dit qu'un lot écrit, réécrit ou supprime un ADR à son ouverture ou par un amendement, ni que la relecture technique relit contre les ADR : ces règles appartiennent aux stories suivantes. `skills/writing-a-batch/`, `skills/rereading-a-technical-design/`, `skills/closing-a-batch/`, `scripts/` et `commands/` ne sont pas touchés.
- Le texte d'une skill donné dans une tâche est écrit tel quel. Un implémenteur qui le juge faux le dit dans son rapport, et ne le réécrit pas.
- Tout commit passe par `bash ~/.config/github-app/as-agent.sh git -C <worktree> commit …` et se termine par la seule ligne d'attribution `Co-Authored-By: Charlouze <me@charlouze.com>`. Jamais de `Co-Authored-By: Claude …`, de `Claude-Session:` ni de « Generated with Claude Code ».
- Pendant une tâche, seuls les fichiers de test qu'elle touche sont lancés (`bash tests/<fichier>.sh`). La suite complète tourne à la fin de la story. Aucun lancement n'est laissé en arrière-plan.

## Review Focus

- Une story sans contrainte de lot mais avec un ADR sur `main` : la condition d'arrêt entre quand même dans ses `Global Constraints`. Gardé en tâche 1 par le déclencheur à deux branches.
- Un ADR jugé intenable : la story est abandonnée et l'ADR part vers un changement borné, jamais vers un amendement. Gardé en tâche 1 des deux côtés.
- Une condition d'ADR reformulée dans la copie des `Global Constraints`. Gardé en tâche 3 par une garde commune aux deux skills.
- Une tâche qui écrit l'ADR elle-même au lieu de consigner un arbitrage ouvert. Gardé en tâche 3.
- Un changement borné dont la conception a lu un `docs/adr/` périmé. Gardé en tâche 2 par la relecture une fois la branche créée.

---

### Task 1: La condition d'arrêt étendue à l'ADR

**Files:**
- Modify: `skills/using-batches/SKILL.md` (`### Override 2 — the stop conditions the flow adds`)
- Modify: `skills/writing-a-user-story/SKILL.md` (`## Step 4 — Write the Plan`, `## Step 5 — Execute`, `## Red Flags`)
- Modify: `README.md` (`### The four departures`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`, `tests/test-declared-overrides.sh`, `tests/test-cross-references.sh`

**Interfaces:**
- Consumes: rien.
- Produces: le texte anglais de référence de la condition d'arrêt, `If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.`, et le déclencheur `only if the batch declares constraints or \`docs/adr/\` carries an ADR`, que la tâche 3 réemploie dans la liste des `Global Constraints`.

- [ ] **Step 1: Changer et écrire les gardes**

Dans `tests/test-skill-content.sh`, remplacer ces gardes de `writing-a-user-story` :

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

par :

```bash
require writing-a-user-story "GC lists the stop condition on a constraint or an ADR" \
    "- **only if the batch declares constraints or \`docs/adr/\` carries an ADR**, the stop condition on a constraint or an ADR that cannot be held"
require writing-a-user-story "GC carries the stop condition on a constraint or an ADR" \
    "carries the stop condition on a constraint or an ADR that cannot be held, written out in full"
require writing-a-user-story "a batch declares constraints when they are not none" \
    "A batch declares constraints when its \`Constraints\` section is not \`none\`."
require writing-a-user-story "docs/adr carries an ADR when a .md file sits in it" \
    "\`docs/adr/\` carries an ADR when a \`.md\` file is placed directly in it, in this story's worktree."
require writing-a-user-story "working around a constraint or an ADR breaks what the implementer cannot see" \
    "A constraint is a decision another story of the batch relies on, and an ADR is a decision your human partner took for all the code to come, so an implementer who works around either breaks something they cannot see."
require writing-a-user-story "the condition leaves the branch as it is" \
    "your human partner rules on the constraint or the ADR, and until then the branch and the worktree stay as they are."
require writing-a-user-story "an untenable ADR abandons the story" \
    "If they rule an ADR untenable, the story is abandoned and a bounded change rewrites or deletes the ADR."
require writing-a-user-story "what holds resumes the story" \
    "Otherwise resume the story and hold it."
require writing-a-user-story "red flag: a ruling replaces no stop condition" \
    "| \"This constraint, or this ADR, cannot be held, I'll work around it and record a ruling\" | A ruling replaces no stop condition. Another story of the batch relies on that constraint, and your human partner decided that ADR: stop and put it to them. |"
```

Remplacer ces gardes :

```bash
require using-batches "a story stops on a constraint it cannot hold" \
    "If, while conducting a story, you discover that a constraint of its batch cannot be held, stop and put the constraint to your human partner."
require using-batches "a contradicted constraint is not this case" \
    "A constraint the spec contradicts does not fall under this condition: the spec wins."
require using-batches "the human rules on the constraint" \
    "When the constraint condition fires, your human partner rules on the constraint."
require using-batches "an untenable constraint goes to an amendment" \
    "If they rule it untenable, the story is abandoned and \`supercharlouze:writing-a-batch\` amends the constraint, under \`Amending a Batch\`; otherwise the story resumes and holds it."
require writing-a-user-story "an untenable constraint abandons the story" \
    "If they rule it untenable, the story is abandoned and \`supercharlouze:writing-a-batch\` amends the constraint; otherwise resume the story and hold the constraint."
```

par :

```bash
require using-batches "a story stops on a constraint or an ADR it cannot hold" \
    "If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner."
require using-batches "a contradicted constraint is not this case" \
    "A constraint the spec contradicts does not fall under this condition: the spec wins."
require using-batches "a ruling would break a decision of the batch or of the human" \
    "and the condition on a constraint or an ADR would break a decision another story of the batch relies on, or one your human partner took for all the code to come."
require using-batches "the justification covers the ADR" \
    "and an ADR is a decision your human partner took, so only they judge it untenable."
require using-batches "the human rules on the constraint or the ADR" \
    "When the condition on a constraint or an ADR fires, your human partner rules on the constraint or the ADR."
require using-batches "an untenable constraint goes to an amendment" \
    "If they rule a constraint untenable, the story is abandoned and \`supercharlouze:writing-a-batch\` amends the constraint, under \`Amending a Batch\`."
require using-batches "an untenable ADR goes to a bounded change" \
    "If they rule an ADR untenable, the story is abandoned and a bounded change rewrites or deletes the ADR."
require using-batches "what holds resumes the story" \
    "Otherwise the story resumes and holds it."
require writing-a-user-story "an untenable constraint abandons the story" \
    "If they rule a constraint untenable, the story is abandoned and \`supercharlouze:writing-a-batch\` amends the constraint."
```

Dans `tests/test-skill-contracts.sh`, remplacer :

```bash
# The stop condition on a constraint that cannot be held travels the same way,
# with the sentence that bounds it: an implementer who meets a constraint the
# spec contradicts must find, in the same copy, that this is not the case.
shared "the constraint stop condition is copied exactly as stated" \
    "If, while conducting a story, you discover that a constraint of its batch cannot be held, stop and put the constraint to your human partner. A constraint the spec contradicts does not fall under this condition: the spec wins." \
    using-batches writing-a-user-story
```

par :

```bash
# The stop condition on a constraint or an ADR that cannot be held travels the
# same way, with the sentence that bounds it: an implementer who meets a
# constraint the spec contradicts must find, in the same copy, that this is not
# the case.
shared "the stop condition on a constraint or an ADR is copied exactly as stated" \
    "If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner. A constraint the spec contradicts does not fall under this condition: the spec wins." \
    using-batches writing-a-user-story

# The condition no longer bears on a constraint alone, nor fires only in a batch
# that declares constraints: the former wording must survive nowhere, or a story
# with an ADR and no constraint would carry no stop condition.
absent "the stop condition is no longer bounded to a constraint" \
    "a constraint of its batch cannot be held|constraint condition|whose batch declares constraints only" \
    using-batches writing-a-user-story
```

Dans `tests/test-declared-overrides.sh`, ajouter juste après le bloc `check_verb "the stop conditions are extended, not restated" …` :

```bash
# The condition on a constraint is introduced with both of its triggers: a batch
# that declares constraints, or an ADR on `main`.
if has "For a story only if its batch declares constraints or \`main\` carries an ADR when its branch starts:" "$SKILL_FLAT"; then
    pass "using-batches introduces the stop condition on a constraint or an ADR"
else
    fail "using-batches introduces the stop condition on a constraint or an ADR"
fi
```

Dans `tests/test-cross-references.sh`, ajouter juste avant la ligne `# 5. No shipped artifact cites a numbered section of the archived design` :

```bash
# The README extends the stop condition on a constraint to an ADR.
case "$README_FLAT" in
    *"If a story finds that a constraint of its batch or an ADR cannot be held, it stops and puts it to the human. An agent may neither correct a spec, nor keep a qualification it has lost, nor bend a constraint or an ADR."*)
        pass "the README's stop condition covers the ADR" ;;
    *)  fail "the README's stop condition covers the ADR" ;;
esac
```

- [ ] **Step 2: Voir les gardes rouges**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL; bash tests/test-declared-overrides.sh | grep FAIL; bash tests/test-cross-references.sh | grep FAIL`
Expected: un `[FAIL]` par garde changée ou neuve, sauf les deux gardes inchangées (`a contradicted constraint is not this case`, `a batch declares constraints when they are not none`) et la garde `absent`, qui est rouge. Aucun autre `[FAIL]`.

- [ ] **Step 3: `using-batches`, override 2**

Dans `skills/using-batches/SKILL.md`, remplacer :

```markdown
For a story whose batch declares constraints only:

> If, while conducting a story, you discover that a constraint of its batch cannot be held, stop and put the constraint to your human partner.
```

par :

```markdown
For a story only if its batch declares constraints or `main` carries an ADR when its branch starts:

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
```

Dans le paragraphe `A ruling replaces none of them. …`, remplacer :

```markdown
and the constraint condition would break a decision another story of the batch relies on.
```

par :

```markdown
and the condition on a constraint or an ADR would break a decision another story of the batch relies on, or one your human partner took for all the code to come.
```

Dans le paragraphe `Justification: …`, remplacer la fin :

```markdown
and a constraint is what the other stories of its batch rely on, so a story that cannot hold one cannot settle it alone.
```

par :

```markdown
a constraint is what the other stories of its batch rely on, so a story that cannot hold one cannot settle it alone; and an ADR is a decision your human partner took, so only they judge it untenable.
```

Remplacer le paragraphe :

```markdown
When the constraint condition fires, your human partner rules on the constraint. If they rule it untenable, the story is abandoned and `supercharlouze:writing-a-batch` amends the constraint, under `Amending a Batch`; otherwise the story resumes and holds it.
```

par :

```markdown
When the condition on a constraint or an ADR fires, your human partner rules on the constraint or the ADR.

If they rule a constraint untenable, the story is abandoned and `supercharlouze:writing-a-batch` amends the constraint, under `Amending a Batch`.

If they rule an ADR untenable, the story is abandoned and a bounded change rewrites or deletes the ADR.

Otherwise the story resumes and holds it.
```

- [ ] **Step 4: `writing-a-user-story`, `## Step 4 — Write the Plan`**

Dans la liste de ce que `Global Constraints` porte, remplacer :

```markdown
- **in a story whose batch declares constraints only**, the stop condition on a
  constraint that cannot be held.
```

par :

```markdown
- **only if the batch declares constraints or `docs/adr/` carries an ADR**, the
  stop condition on a constraint or an ADR that cannot be held.
```

Remplacer, du paragraphe `**In a story whose batch declares constraints, \`Global Constraints\` carries the stop condition on a constraint that cannot be held, written out in full.** …` jusqu'à `implementer who works around it breaks a story they cannot see.` inclus, par :

```markdown
**In a story whose batch declares constraints, or whose `docs/adr/` carries an
ADR, `Global Constraints` carries the stop condition on a constraint or an ADR
that cannot be held, written out in full.** A batch declares constraints when its
`Constraints` section is not `none`. `docs/adr/` carries an ADR when a `.md` file
is placed directly in it, in this story's worktree. Copy the block below
verbatim, exactly as `supercharlouze:using-batches` states it:

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

A constraint is a decision another story of the batch relies on, and an ADR is a
decision your human partner took for all the code to come, so an implementer who
works around either breaks something they cannot see.
```

- [ ] **Step 5: `writing-a-user-story`, `## Step 5 — Execute`**

Remplacer le paragraphe qui commence par `In a story whose batch declares constraints: if, while conducting it, you` et finit par `otherwise resume the story and hold the constraint.` par :

```markdown
In a story whose batch declares constraints or whose `docs/adr/` carries an ADR:
if, while conducting it, you discover that a constraint of its batch or an ADR
cannot be held, stop and put it to your human partner. A constraint the spec
contradicts is not this case, since the spec wins. When you stop, your human
partner rules on the constraint or the ADR, and until then the branch and the
worktree stay as they are.

If they rule a constraint untenable, the story is abandoned and
`supercharlouze:writing-a-batch` amends the constraint.

If they rule an ADR untenable, the story is abandoned and a bounded change
rewrites or deletes the ADR.

Otherwise resume the story and hold it.
```

- [ ] **Step 6: `writing-a-user-story`, `## Red Flags`**

Remplacer la ligne dont la pensée est `"This constraint cannot be held, I'll work around it and record a ruling"` par :

```markdown
| "This constraint, or this ADR, cannot be held, I'll work around it and record a ruling" | A ruling replaces no stop condition. Another story of the batch relies on that constraint, and your human partner decided that ADR: stop and put it to them. |
```

- [ ] **Step 7: `README.md`, `### The four departures`**

Remplacer :

```markdown
   observable at its module's boundary, it is no longer technical. If a story
   finds that a constraint of its batch cannot be held, it stops and puts the
   constraint to the human. An agent may neither correct a spec, nor keep a
   qualification it has lost, nor bend a constraint.
```

par :

```markdown
   observable at its module's boundary, it is no longer technical. If a story
   finds that a constraint of its batch or an ADR cannot be held, it stops and
   puts it to the human. An agent may neither correct a spec, nor keep a
   qualification it has lost, nor bend a constraint or an ADR.
```

- [ ] **Step 8: Voir les gardes vertes**

Run: `bash tests/test-skill-content.sh | grep -c FAIL; bash tests/test-skill-contracts.sh | grep -c FAIL; bash tests/test-declared-overrides.sh | grep -c FAIL; bash tests/test-cross-references.sh | grep -c FAIL`
Expected: `0`, `0`, `0`, `0`.

- [ ] **Step 9: Commiter**

```bash
git add skills/using-batches/SKILL.md skills/writing-a-user-story/SKILL.md README.md tests
bash ~/.config/github-app/as-agent.sh git -C "$PWD" commit -m "feat: une story s'arrête devant un ADR qu'elle ne peut pas tenir" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 2: Le code tient les ADR, dans `using-batches` et dans le `README.md`

**Files:**
- Modify: `skills/using-batches/SKILL.md` (`## The Model`, `## The Git Model`, `## What Is Kept, What Is Rerouted`, `## Red Flags`)
- Modify: `README.md` (table des revues, `### What stays outside a batch`)
- Test: `tests/test-skill-content.sh`, `tests/test-cross-references.sh`

**Interfaces:**
- Consumes: rien.
- Produces: dans `## The Model` de `using-batches`, la règle `The code of a story or of a bounded change holds the ADRs \`main\` carries when its branch starts.`, que la tâche 3 applique à la story.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, ajouter à la fin du bloc `# --- using-batches: the ADR …`, après la garde `a bounded change writes, rewrites and deletes ADRs` et celles qui la suivent dans ce bloc :

```bash
require using-batches "the code holds the ADRs main carries" \
        "The code of a story or of a bounded change holds the ADRs \`main\` carries when its branch starts."
require using-batches "no ADR binds the code already on main" \
        "No ADR binds the code already on \`main\`."
require using-batches "the delivery gate carries the ADRs the review asks for" \
        "| Story delivery | the pull request carrying a story's code, its spec change if it has one, and the ADRs the review asks for |"
require using-batches "the bounded ceremony has an exception" \
        "**Bounded** — ceremony unchanged, except for the reading of \`docs/adr/\` stated below, with these rules:"
require using-batches "the design steps have the same exception" \
        "are **kept intact**, except for the reading of \`docs/adr/\` stated below"
require using-batches "the design reads docs/adr before proposing an approach" \
        "On the bounded path and on the architectural path, read every ADR in \`docs/adr/\` before proposing an approach"
require using-batches "the design puts to the human the decision that meets the conditions" \
        "put to your human partner each technical decision the design takes that meets the conditions of an ADR (\`The Model\`)"
require using-batches "a bounded change holds the ADRs" \
        "**(f) It holds the ADRs \`main\` carries when its branch starts.**"
require using-batches "a bounded change rereads docs/adr once its branch exists" \
        "Once \`bounded/<slug>\` is created, reread \`docs/adr/\` and hold what you find there"
require using-batches "a bounded change puts to the human the ADR it cannot hold" \
        "When you cannot hold an ADR, put it to your human partner: if they rule it untenable, rewrite or delete it under rule (e); otherwise hold it."
require using-batches "a bounded change puts to the human the decision that meets the conditions" \
        "**(g) It puts to your human partner the technical decision it takes that meets the conditions of an ADR (\`The Model\`).**"
require using-batches "a bounded change writes the ADR the human wants" \
        "If they want it as an ADR, write it under rule (e)."
require using-batches "red flag: a decision is put to the human" \
        "| \"This decision is technical, no need to bring it to my human partner\" |"
```

Dans `tests/test-cross-references.sh`, remplacer :

```bash
case "$README_FLAT" in
    *"and it may write, rewrite and delete ADRs, or carry nothing but ADRs."*)
        pass "the README lets a bounded change write ADRs" ;;
    *)  fail "the README lets a bounded change write ADRs" ;;
esac
```

par :

```bash
case "$README_FLAT" in
    *"it may write, rewrite and delete ADRs, or carry nothing but ADRs;"*)
        pass "the README lets a bounded change write ADRs" ;;
    *)  fail "the README lets a bounded change write ADRs" ;;
esac
case "$README_FLAT" in
    *"it holds the ADRs \`main\` carries when its branch starts, and puts to the human one it cannot hold;"*)
        pass "the README makes a bounded change hold the ADRs" ;;
    *)  fail "the README makes a bounded change hold the ADRs" ;;
esac
case "$README_FLAT" in
    *"and it puts to the human the technical decision it takes that would earn an ADR."*)
        pass "the README makes a bounded change put its decision to the human" ;;
    *)  fail "the README makes a bounded change put its decision to the human" ;;
esac
# The delivery gate carries the ADRs the review asks for, in the README's gate
# table too.
case "$README_FLAT" in
    *"| Story delivery | a story's code, its spec change if it has one, and the ADRs the review asks for, in one diff |"*)
        pass "the README's delivery gate carries the ADRs the review asks for" ;;
    *)  fail "the README's delivery gate carries the ADRs the review asks for" ;;
esac
```

- [ ] **Step 2: Voir les gardes rouges**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-cross-references.sh | grep FAIL`
Expected: un `[FAIL]` par garde neuve ou changée, et aucun autre.

- [ ] **Step 3: `## The Model`**

Dans `skills/using-batches/SKILL.md`, après le paragraphe `An ADR whose decision is replaced is rewritten in place, and one whose decision is abandoned is deleted.` et avant `**Corrective batch**`, ajouter :

```markdown
The code of a story or of a bounded change holds the ADRs `main` carries when its branch starts.

No ADR binds the code already on `main`.
```

- [ ] **Step 4: `## The Git Model`**

Remplacer :

```markdown
| Story delivery | the pull request carrying a story's code, and its spec change if it has one |
```

par :

```markdown
| Story delivery | the pull request carrying a story's code, its spec change if it has one, and the ADRs the review asks for |
```

- [ ] **Step 5: `## What Is Kept, What Is Rerouted`**

Remplacer `**Bounded** — ceremony unchanged, with these rules:` par :

```markdown
**Bounded** — ceremony unchanged, except for the reading of `docs/adr/` stated below, with these rules:
```

Après la règle (e) et avant le paragraphe `No batch, no user story: …`, ajouter :

```markdown
- **(f) It holds the ADRs `main` carries when its branch starts.** Once `bounded/<slug>` is created, reread `docs/adr/` and hold what you find there: the design read it where you stood, and the branch starts from `main` as the remote carries it. When you cannot hold an ADR, put it to your human partner: if they rule it untenable, rewrite or delete it under rule (e); otherwise hold it.
- **(g) It puts to your human partner the technical decision it takes that meets the conditions of an ADR (`The Model`).** That holds for a decision taken along the way as for one taken at design. If they want it as an ADR, write it under rule (e).
```

Dans le paragraphe `**Architectural** — …`, remplacer :

```markdown
are **kept intact**: that is the design work itself, and it has no reason to change.
```

par :

```markdown
are **kept intact**, except for the reading of `docs/adr/` stated below: that is the design work itself.
```

Après le paragraphe `**Architectural** — …` et avant `## Declared Overrides`, ajouter :

```markdown
**The design reads `docs/adr/`.** On the bounded path and on the architectural path, read every ADR in `docs/adr/` before proposing an approach, and put to your human partner each technical decision the design takes that meets the conditions of an ADR (`The Model`). An approach that breaks an ADR is one the code may not take, and only your human partner decides an ADR.
```

- [ ] **Step 6: `## Red Flags`**

Ajouter à la fin de la table de `## Red Flags` :

```markdown
| "This decision is technical, no need to bring it to my human partner" | If undoing it is expensive, it surprises whoever does not know its context and it settles between real alternatives, put it to them: only they decide an ADR. |
```

- [ ] **Step 7: `README.md`**

Dans la table des revues, remplacer :

```markdown
| Story delivery | a story's code, and its spec change if it has one, in one diff |
```

par :

```markdown
| Story delivery | a story's code, its spec change if it has one, and the ADRs the review asks for, in one diff |
```

Dans `### What stays outside a batch`, remplacer :

```markdown
it may write to a gaps register directly; and it may write, rewrite and delete
ADRs, or carry nothing but ADRs. Only architectural work opens a batch.
```

par :

```markdown
it may write to a gaps register directly; it may write, rewrite and delete ADRs,
or carry nothing but ADRs; it holds the ADRs `main` carries when its branch
starts, and puts to the human one it cannot hold; and it puts to the human the
technical decision it takes that would earn an ADR. Only architectural work opens
a batch.
```

- [ ] **Step 8: Voir les gardes vertes**

Run: `bash tests/test-skill-content.sh | grep -c FAIL; bash tests/test-cross-references.sh | grep -c FAIL; bash tests/test-skill-contracts.sh | grep -c FAIL`
Expected: `0`, `0`, `0`.

- [ ] **Step 9: Commiter**

```bash
git add skills/using-batches/SKILL.md README.md tests
bash ~/.config/github-app/as-agent.sh git -C "$PWD" commit -m "feat: le code d'un changement borné tient les ADR que main porte" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 3: L'ADR dans le plan, l'exécution et la revue d'une story

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (`## Step 4 — Write the Plan`, `## Step 5 — Execute`, `## Step 6 — Record Before the Merge`, `## Step 7 — Answer the Review`, `## Red Flags`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: de la tâche 1, l'élément de liste `- **only if the batch declares constraints or \`docs/adr/\` carries an ADR**, the stop condition on a constraint or an ADR that cannot be held.` et la définition `\`docs/adr/\` carries an ADR when a \`.md\` file is placed directly in it, in this story's worktree.` ; de la story précédente, le texte de référence des conditions d'un ADR dans `## The Model` de `skills/using-batches/SKILL.md`.
- Produces: rien qu'une autre tâche consomme.

- [ ] **Step 1: Changer et écrire les gardes**

Dans `tests/test-skill-content.sh`, remplacer :

```bash
require writing-a-user-story "main's code wins where it departed" \
    "Exception: where the code on \`main\` has departed from the design, as an earlier story of the batch may have, the plan starts from the code."
```

par :

```bash
require writing-a-user-story "an ADR wins over the design, then main's code" \
    "Exceptions: where an ADR contradicts the design, the plan follows the ADR; elsewhere, where the code on \`main\` has departed from the design, as an earlier story of the batch may have, the plan starts from the code."
require writing-a-user-story "the plan reads docs/adr in the story's worktree" \
    "Read every ADR in \`docs/adr/\`, in this story's worktree, before writing the plan"
```

Remplacer :

```bash
    "Write as a \`Technical design ruling:\`, with the three parts of a \`Ruling:\`, every departure from the batch's \`Technical design\` that the plan or the execution took, except where the plan follows the code on \`main\`."
```

par :

```bash
    "Write as a \`Technical design ruling:\`, with the three parts of a \`Ruling:\`, every departure from the batch's \`Technical design\` that the plan or the execution took, except where the plan follows an ADR or the code on \`main\`."
```

Dans la garde `GC lists the stop condition on a constraint or an ADR` de la tâche 1, le motif ne change pas : il s'arrête avant la ponctuation finale.

Ajouter, après la garde `the condition leaves the branch as it is` :

```bash
require writing-a-user-story "GC lists the ADRs the code holds" \
    "- **only if \`docs/adr/\` carries an ADR**, the paths of the ADRs this story's code holds;"
require writing-a-user-story "GC lists the conditions of an ADR" \
    "- the conditions of an ADR, with the obligation to record as an \`Open ruling:\` the decision that meets them."
require writing-a-user-story "GC carries the paths of the ADRs" \
    "**When \`docs/adr/\` carries an ADR, \`Global Constraints\` lists the path of each one, under the sentence below.**"
require writing-a-user-story "the sentence the paths sit under" \
    "The code this story writes holds these ADRs."
require writing-a-user-story "an ADR left out of the list binds nobody" \
    "An implementer reads only this list, so an ADR whose path is missing from it binds nobody."
require writing-a-user-story "GC carries the conditions of an ADR" \
    "**In every story, \`Global Constraints\` carries the conditions of an ADR, written out in full, with the obligation to record the decision that meets them.**"
require writing-a-user-story "a task records the decision as an open ruling" \
    "When you take a technical decision that meets them, record it as an \`Open ruling:\` whose line ends with whether your human partner wants it as an ADR. Write nothing in \`docs/adr/\`."
require writing-a-user-story "no task writes in docs/adr" \
    "No task writes in \`docs/adr/\`"
require writing-a-user-story "step 6 records the decision that meets the conditions" \
    "Write as an \`Open ruling:\` every technical decision the plan or the execution took that meets the conditions of an ADR, its line ending with whether your human partner wants it as an ADR."
require writing-a-user-story "the review settles the ADR" \
    "If they want the ADR, invoke \`supercharlouze:recording-a-decision\` and commit the file it writes in a commit of its own."
require writing-a-user-story "nothing written is recorded" \
    "If nothing is written, record in the \`Rulings log\` what they ruled."
require writing-a-user-story "a later correction of the ADR is a fixup" \
    "A correction of the ADR's text asked for afterwards, which does not change its decision, is a \`fixup!\` of that commit."
require writing-a-user-story "red flag: a departure left out surprises the review" \
    "| \"My plan departs only slightly from the design, no ruling needed\" | Every departure is a \`Technical design ruling:\`. One left out reaches the delivery review as a surprise. |"
require writing-a-user-story "red flag: no task writes the ADR" \
    "| \"This decision deserves an ADR, I'll write it with the code\" | No task writes in \`docs/adr/\`. Record an \`Open ruling:\`, and write the ADR at the review if your human partner wants it. |"
```

Dans `tests/test-skill-contracts.sh`, ajouter juste après la garde `absent "the stop condition is no longer bounded to a constraint" …` de la tâche 1 :

```bash
# The conditions of an ADR are copied into every story's Global Constraints.
# `using-batches` states them and `writing-a-user-story` has them copied: a
# condition spelled differently in the copy is no longer the threshold the
# human agreed to.
shared "the conditions of an ADR are copied exactly as stated" \
    "A technical decision is recorded as an ADR only if it meets these conditions: - undoing it is expensive; - it surprises whoever does not know its context; - it settles between real alternatives." \
    using-batches writing-a-user-story

# Closing no longer answers for a design nobody built: the red flag that said so
# must survive nowhere.
absent "an unrecorded departure no longer leaves the design false" \
    "describing a mechanism nobody built" \
    writing-a-user-story
```

- [ ] **Step 2: Voir les gardes rouges**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: un `[FAIL]` par garde neuve ou changée, et aucun autre.

- [ ] **Step 3: `## Step 4 — Write the Plan`, le plan**

Dans `skills/writing-a-user-story/SKILL.md`, remplacer :

```markdown
**The plan starts from the batch's `Technical design`**, and its `Architecture:`
line derives from it. Exception: where the code on `main` has departed from the
design, as an earlier story of the batch may have, the plan starts from the code.
```

par :

```markdown
**The plan starts from the batch's `Technical design`**, and its `Architecture:`
line derives from it. Exceptions: where an ADR contradicts the design, the plan
follows the ADR; elsewhere, where the code on `main` has departed from the
design, as an earlier story of the batch may have, the plan starts from the code.

Read every ADR in `docs/adr/`, in this story's worktree, before writing the plan:
the worktree carries the ADRs `main` carried when the branch started, which are
the ones this story's code holds.
```

- [ ] **Step 4: `## Step 4 — Write the Plan`, `Global Constraints`**

Dans la liste de ce que `Global Constraints` porte, remplacer :

```markdown
- **only if the batch declares constraints or `docs/adr/` carries an ADR**, the
  stop condition on a constraint or an ADR that cannot be held.
```

par :

```markdown
- **only if the batch declares constraints or `docs/adr/` carries an ADR**, the
  stop condition on a constraint or an ADR that cannot be held;
- **only if `docs/adr/` carries an ADR**, the paths of the ADRs this story's code
  holds;
- the conditions of an ADR, with the obligation to record as an `Open ruling:`
  the decision that meets them.
```

Après le paragraphe qui finit par `works around either breaks something they cannot see.` et avant `**Commit the story document — …`, ajouter :

```markdown
**When `docs/adr/` carries an ADR, `Global Constraints` lists the path of each
one, under the sentence below.** Copy it verbatim:

> The code this story writes holds these ADRs.

An implementer reads only this list, so an ADR whose path is missing from it
binds nobody.

**In every story, `Global Constraints` carries the conditions of an ADR, written
out in full, with the obligation to record the decision that meets them.** Copy
the block below verbatim. Its conditions are those `supercharlouze:using-batches`
states:

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, record it as an
> `Open ruling:` whose line ends with whether your human partner wants it as an
> ADR. Write nothing in `docs/adr/`.

Only your human partner decides an ADR, so an implementer who takes such a
decision reports it and leaves the file to the review.
```

- [ ] **Step 5: `## Step 5 — Execute`**

Après le paragraphe `Otherwise resume the story and hold it.` que la tâche 1 a écrit, et avant le paragraphe `It is named as an override for the same reason as the other three: …`, ajouter :

```markdown
No task writes in `docs/adr/`. The ADR a decision of this story deserves is
written at the review (Step 7), once your human partner wants it.
```

- [ ] **Step 6: `## Step 6 — Record Before the Merge`**

Dans la puce `Write as a \`Technical design ruling:\` …`, remplacer `except where the plan follows the code on \`main\`.` par `except where the plan follows an ADR or the code on \`main\`.`, en gardant le pliage des lignes à 80 colonnes.

Après cette puce et avant la puce `Record under **Observed drift** …`, ajouter :

```markdown
- Write as an `Open ruling:` every technical decision the plan or the execution
  took that meets the conditions of an ADR, its line ending with whether your
  human partner wants it as an ADR.
```

- [ ] **Step 7: `## Step 7 — Answer the Review`**

Après le paragraphe qui finit par `your human partner has the rulings in front of them here, and nowhere later.` et avant `**Ending the review.**`, ajouter :

```markdown
**Your human partner settles an open ruling on a decision that meets the
conditions of an ADR.** If they want the ADR, invoke
`supercharlouze:recording-a-decision` and commit the file it writes in a commit
of its own. If nothing is written, record in the `Rulings log` what they ruled.
A correction of the ADR's text asked for afterwards, which does not change its
decision, is a `fixup!` of that commit.
```

- [ ] **Step 8: `## Red Flags`**

Remplacer la ligne dont la pensée est `"My plan departs only slightly from the design, no ruling needed"` par :

```markdown
| "My plan departs only slightly from the design, no ruling needed" | Every departure is a `Technical design ruling:`. One left out reaches the delivery review as a surprise. |
```

Ajouter à la fin de la table :

```markdown
| "This decision deserves an ADR, I'll write it with the code" | No task writes in `docs/adr/`. Record an `Open ruling:`, and write the ADR at the review if your human partner wants it. |
```

- [ ] **Step 9: Voir les gardes vertes**

Run: `bash tests/test-skill-content.sh | grep -c FAIL; bash tests/test-skill-contracts.sh | grep -c FAIL; bash tests/test-cross-references.sh | grep -c FAIL`
Expected: `0`, `0`, `0`.

- [ ] **Step 10: Commiter**

```bash
git add skills/writing-a-user-story/SKILL.md tests
bash ~/.config/github-app/as-agent.sh git -C "$PWD" commit -m "feat: une story soumet à l'humain la décision qui mériterait un ADR" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: le changement borné gagne deux règles, (f) et (g), au lieu d'une règle (e) étendue — la règle (e) dit ce qu'il peut écrire, les deux neuves disent ce qu'il doit tenir et soumettre, et un paragraphe porte une seule règle — si c'est faux, trois règles sont à refondre en une.
- Technical design ruling: la phrase d'introduction que l'override 2 étend aux ADR est celle qui introduit la condition sur une contrainte, « For a story only if its batch declares constraints or `main` carries an ADR when its branch starts: », et la phrase « This plugin adds the conditions below » reste telle quelle — elle ne nomme aucune condition, donc rien n'y est à étendre — si c'est faux, la garde de `tests/test-declared-overrides.sh` tient la mauvaise phrase.
- Technical design ruling: `## Step 6 — Record Before the Merge` de `writing-a-user-story` gagne une puce qui fait consigner en `Open ruling:` la décision technique que le plan ou l'exécution a prise et qui réunit les conditions d'un ADR, là où la conception ne demande à cette étape que l'exception sur l'ADR suivi — la spec fait soumettre cette décision par la story, et un implémenteur ne fait que la rapporter — si c'est faux, la puce répète ce que les `Global Constraints` disent déjà à l'implémenteur.
- Technical design ruling: le bloc que les `Global Constraints` recopient sur les conditions d'un ADR dit aussi « Write nothing in `docs/adr/` », en plus de la phrase de `## Step 5 — Execute` que la conception demande — les `Global Constraints` sont le seul texte qu'un implémenteur lit — si c'est faux, la règle est écrite deux fois dans la skill, sous deux gardes.
- Technical design ruling: ce bloc dit à l'implémenteur de signaler la décision dans son rapport, et que celle-ci est consignée en `Open ruling:`, là où la conception parle de « l'obligation de consigner comme `Open ruling:` » — un implémenteur n'écrit pas dans le document de story — si c'est faux, le bloc est à réécrire à l'impératif, sous sa garde.
- Technical design ruling: `## Red Flags` gagne des lignes que la conception ne demande pas : dans `using-batches`, celle sur la décision technique qu'un agent garderait pour lui ; dans `writing-a-user-story`, celle sur l'ADR qu'une tâche écrirait avec le code, et l'ADR dans celle sur le code de `main` — `CLAUDE.md` veut que l'excuse qui fait sauter une règle ait sa réponse dans cette table — si c'est faux, ces lignes sont à retirer, avec leurs gardes.
- Ruling: sur le chemin architectural, la conception soumet à l'humain la décision qui réunit les conditions, sans que cette story dise ce qui écrit l'ADR ensuite — l'écriture à l'ouverture d'un lot appartient au bloc sur `Opening a batch`, qu'une story suivante transcrit, et d'ici là la table de routage mène au changement borné — si c'est faux, un agent qui conçoit un lot entre les deux stories ne sait pas où écrire l'ADR que l'humain a voulu.
- Ruling: `writing-a-user-story` dit le déclencheur « `docs/adr/` carries an ADR », lu dans le worktree de la story, là où `using-batches` dit « `main` carries an ADR when its branch starts » — la conception technique demande la première forme, et la skill dit que le worktree porte les ADR que `main` portait au départ de la branche — si c'est faux, deux formulations d'un même déclencheur sont à réunir.
- Ruling: le texte livré s'écarte du texte que ce plan donne, après les relectures, en ces points : « Otherwise … holds the constraint or the ADR » dans les deux skills ; la ligne de `## Red Flags` de `using-batches`, qui renvoie aux conditions sans les répéter ; le bloc des `Global Constraints` sur les conditions ; le paragraphe de `## Step 7 — Answer the Review`, scindé en trois ; la ligne de `## Red Flags` de `writing-a-user-story` sur le code de `main`, qui gagne l'ADR ; la place de « No task writes in `docs/adr/` », en fin de `## Step 5 — Execute` ; et des gardes ajoutées — chaque point résorbe un constat de relecture, et le plan n'est pas réécrit après son exécution — si c'est faux, le plan se lit comme ce qui a été livré alors qu'il ne l'est plus sur ces points.
- Ruling: la borne de la ligne de la table de routage de `using-batches`, qui mène au changement borné l'humain qui veut un ADR écrit, réécrit ou supprimé, nomme aussi la revue de livraison d'une story et l'installation, et cette story ne touche pas la ligne : la story `12-us-7-les-adr-a-l-installation` la corrige, en une seule fois — `## Step 7 — Answer the Review` de `writing-a-user-story` fait écrire un ADR par une story, à sa revue de livraison, quand l'humain le demande, et l'installation supprime l'ADR qu'il abandonne — si c'est faux, la ligne écarte du changement borné une demande d'ADR que ni la revue de livraison ni l'installation ne traite, et jusqu'à la fusion de la story `12-us-7-les-adr-a-l-installation` un agent qui lit la ligne à l'un de ces deux moments ouvre un changement borné à tort.

## Observed drift
