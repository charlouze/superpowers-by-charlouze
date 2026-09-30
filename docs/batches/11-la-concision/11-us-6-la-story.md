# La story Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Les skills tiennent ce que la spec dit désormais du document de story, de sa livraison et de son abandon.

**Architecture:** Chaque changement de comportement touche `skills/writing-a-user-story/SKILL.md` et ses gardes bash dans `tests/`. Chaque garde s'écrit avant le texte qu'elle vérifie. Ce que la spec retire et que la skill garde reçoit une garde sans changement de texte.

**Tech Stack:** Markdown, bash (`tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/11-la-concision/README.md
**Sections:** Story > The user story document, Story > Delivering a story, Story > Abandoning a story
**Blocks:** D18, D20, D21

## Global Constraints

1. Contraintes du lot :
   - `D28` est transcrit au plus tard avec `D13`, avec `D18` et avec `D29`.
   - `D16` et `D25` sont transcrits au plus tard avec `D30`, et `D30` au plus tard avec
     `D9`.
   - `D9` est transcrit au plus tard avec `D7`, et `D7` au plus tard avec `D3` et avec
     `D26`.
   - `D17` est transcrit au plus tard avec `D6`.
   - `D6` et `D12` sont transcrits ensemble.
2. Entre le premier commit de la branche et l'ouverture de la pull request, aucune tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit changer s'arrête.
3. Quand le lot et la spec se contredisent, la spec gagne, sans exception ni délibération : implémenter ce qu'elle dit, consigner un `Ruling:`, poursuivre. Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.
4. Règles de concision :

   > Ces règles valent pour tout texte que le flux écrit : ses documents, les corps de
   > ses pull requests et ses messages de commit.
   >
   > Chaque phrase dit une chose exacte, une seule fois, et se comprend seule.
   >
   > Chaque paragraphe porte une seule règle.
   >
   > Une règle dit jusqu'où elle vaut, et une exception se présente comme telle.
   >
   > Un texte dit ce qu'il livre ou décide, sans raconter comment on y est arrivé ni
   > pourquoi. Exception : la raison que ce flux demande explicitement.
   >
   > Aucune phrase n'est mise en relief.

## Review Focus

- Le bloc de concision copié dans `Global Constraints` diverge de `## Concision` de `skills/using-batches/SKILL.md` : la garde `shared` de la tâche 1 le détecte.
- Un élément de `Global Constraints` est compté ou numéroté : la garde `absent` de la tâche 1 le détecte.
- Une skill cite une section de la spec entre parenthèses : `grep -rnoE '\(\`[A-Z][A-Za-z ]+\`\)' skills/*/SKILL.md` doit rendre les mêmes lignes qu'avant la story.
- Un texte ajouté met une phrase en relief (gras d'emphase) ou dit ce qui va de soi.
- `CHANGELOG.md` est modifié : il appartient à release-please.

---

### Task 1: `Global Constraints` porte les règles de concision

La spec ajoute les règles de `Concision` à ce que porte `Global Constraints`. La skill donne le texte à recopier, en anglais, écrit pour un implémenteur qui ne lit rien d'autre, et nomme chaque élément de `Global Constraints` sans le compter ni le numéroter.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (Step 4, liste de `Global Constraints` et paragraphes qui la détaillent)
- Test: `tests/test-skill-content.sh` (bloc `what Global Constraints carries`), `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la section `## Concision` de `skills/using-batches/SKILL.md`, dont les phrases de règle sont reprises à l'identique.
- Produces: rien pour les autres tâches.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, bloc `# --- writing-a-user-story: what Global Constraints carries`, remplacer les lignes :

```bash
require writing-a-user-story "GC carries the authority rule"      "That rule is the third thing \`Global Constraints\` carries"
require writing-a-user-story "GC carries the technical stop condition" "carries a sixth thing: the stop condition proper to a technical story"
require writing-a-user-story "GC lists a sixth item"              "6. **in a technical story only**, the stop condition proper to a technical story"
require writing-a-user-story "GC carries the guarded-code rules"  "carries a fifth thing: the rules for code under a flag"
```

par :

```bash
require writing-a-user-story "GC carries the authority rule"      "That rule is the authority rule \`Global Constraints\` carries"
require writing-a-user-story "GC lists the concision rules"       "- the concision rules;"
require writing-a-user-story "GC carries the concision rules"     "In every story, \`Global Constraints\` carries the concision rules, written out in full"
require writing-a-user-story "the concision block names what it covers" "These rules hold for every document, pull request body and commit message this story writes"
require writing-a-user-story "GC carries the guarded-code rules"  "carries the rules for code under a flag, written out in full"
require writing-a-user-story "GC carries the technical stop condition" "carries the stop condition proper to a technical story, written out in full"
require writing-a-user-story "GC lists the technical stop condition" "- **in a technical story only**, the stop condition proper to a technical story"
```

Dans `tests/test-skill-contracts.sh`, juste après l'assertion `shared "the technical stop condition is copied exactly as stated"`, ajouter :

```bash
# The concision rules are copied into every story's Global Constraints.
# `using-batches` states them and `writing-a-user-story` has them copied; a rule
# spelled differently in the copy is no longer the rule the implementers obey.
for rule in \
    "Every sentence says one exact thing, once, and stands on its own." \
    "Every paragraph carries one rule." \
    "A rule says how far it holds, and an exception presents itself as one." \
    "A text says what it delivers or decides, without telling how it got there or why." \
    "No sentence is set in relief"; do
    shared "the concision rule is copied as stated: $rule" "$rule" \
        using-batches writing-a-user-story
done

# The mirror: an item of Global Constraints is named, never counted or numbered.
# An ordinal goes false in every paragraph the day an item is added or removed.
absent "no Global Constraints item is counted or numbered" \
    "(first|second|third|fourth|fifth|sixth|seventh|eighth) thing|[0-9]\. the (constraints|freeze|authority|concision)|[0-9]\. \*\*in a " \
    writing-a-user-story
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh`
Expected: FAIL sur les nouvelles gardes (`GC lists the concision rules`, `the concision rule is copied as stated: …`, `no Global Constraints item is counted or numbered`, etc.).

- [ ] **Step 3: Modifier la skill**

Dans `skills/writing-a-user-story/SKILL.md`, Step 4, remplacer la liste :

```markdown
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

par :

```markdown
- the constraints the batch imposes;
- the freeze of the spec file;
- the authority rule;
- the concision rules;
- **in a corrective batch only**, the stop condition proper to a corrective
  batch;
- **in a story that writes code guarded by a flag only**, the rules for code
  under a flag;
- **in a technical story only**, the stop condition proper to a technical
  story.
```

Remplacer « That rule is the third thing `Global Constraints` carries. » par « That rule is the authority rule `Global Constraints` carries. », puis insérer juste après ce paragraphe :

```markdown
In every story, `Global Constraints` carries the concision rules, written out in
full. Copy the block below verbatim:

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
> why. Exception: a reason the plan explicitly asks for, such as the why of a
> `Ruling:` line.
>
> No sentence is set in relief: no bold or capitals that rank one sentence
> above its neighbours.

The implementers write the story's commit messages, and often its documents;
this list is the only channel through which they read the rules those texts
follow.
```

Puis retirer les ordinaux :
- « **In a corrective batch, `Global Constraints` carries a fourth thing: the stop condition proper to a corrective batch, written out in full.** » devient « **In a corrective batch, `Global Constraints` carries the stop condition proper to a corrective batch, written out in full.** ».
- « **In a story that writes code guarded by a feature flag, `Global Constraints` carries a fifth thing: the rules for code under a flag, written out in full.** » devient « **In a story that writes code guarded by a feature flag, `Global Constraints` carries the rules for code under a flag, written out in full.** ».
- « **In a technical story, `Global Constraints` carries a sixth thing: the stop condition proper to a technical story, written out in full.** » devient « **In a technical story, `Global Constraints` carries the stop condition proper to a technical story, written out in full.** ».

Garder le reste de chaque paragraphe à l'identique.

- [ ] **Step 4: Vérifier que tout passe**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

Run: `grep -rnoE '\(\`[A-Z][A-Za-z ]+\`\)' skills/*/SKILL.md`
Expected: les mêmes lignes qu'avant la story.

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: le plan d'une story porte les règles de concision" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: une story ne porte que le flag de son module

La spec ne demande la mention d'un flag que si le lot déclare un flag pour le module de la story. La skill le demandait dès que le lot déclarait un flag.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (Step 3, paragraphe « If the batch declares a feature flag »)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: rien.
- Produces: rien.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, juste après la ligne `require writing-a-user-story "spec change states flag and default" "states the flag and its default"`, ajouter :

```bash
require writing-a-user-story "the gating sentence follows the story's module" "If the batch declares a feature flag for this story's module"
require writing-a-user-story "a story carries its own module's flag only" "its spec change carries its own module's flag and no other"
```

Dans `tests/test-skill-contracts.sh`, juste avant la dernière ligne `exit $((FAILURES > 0))`, ajouter :

```bash
# The mirror: a story states a flag only when its batch declares one for the
# story's module. The former unconditional sentence must not survive.
absent "no story states a flag its module does not carry" \
    "If the batch declares a feature flag, the transcribed" \
    writing-a-user-story
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh`
Expected: FAIL sur les nouvelles gardes.

- [ ] **Step 3: Modifier la skill**

Dans `skills/writing-a-user-story/SKILL.md`, Step 3, remplacer :

```markdown
If the batch declares a feature flag, the transcribed spec change **states the flag
and its default**, and — when the declared scope reaches beyond the batch — its
lifting condition:
```

par :

```markdown
If the batch declares a feature flag for this story's module, the transcribed spec
change states the flag and its default and, when the declared scope reaches beyond
the batch, its lifting condition:
```

Puis, juste après le paragraphe qui se termine par « The sentence disappears in the lifting story, and that is a spec change like any other. », insérer :

```markdown
A batch that guards two modules declares one flag per module, and a story targets
one module: its spec change carries its own module's flag and no other.
```

- [ ] **Step 4: Vérifier que tout passe**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: une story ne porte que le flag de son module" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 3: la story dit quoi faire d'un écart avec un bloc

La spec ne dit plus qu'un écart a « deux causes légitimes » : elle dit quoi faire quand `main` a changé sous un bloc, et quand le texte d'un bloc pose problème. La skill abandonne la liste de causes pour cette forme, que `## Concision` de `using-batches` donne justement en exemple.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (Step 3, propriété « Named in the pull request »)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: rien.
- Produces: rien.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, remplacer la ligne :

```bash
require writing-a-user-story "a divergence has two legitimate causes" "only two legitimate causes"
```

par :

```bash
require writing-a-user-story "main moved: fit the block"            "When \`main\` moved under a block, fit the block to what \`main\` now carries"
require writing-a-user-story "a problematic block goes to the human" "When the block's text is a problem, stop and put it to your human partner before transcribing it"
```

Dans `tests/test-skill-contracts.sh`, juste avant la dernière ligne `exit $((FAILURES > 0))`, ajouter :

```bash
# The mirror: the divergence rule says what to do, and no longer lists causes.
absent "no story skill lists the causes of a divergence" \
    "legitimate cause" \
    writing-a-user-story
```

- [ ] **Step 2: Vérifier que les gardes échouent**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh`
Expected: FAIL sur les nouvelles gardes.

- [ ] **Step 3: Modifier la skill**

Dans `skills/writing-a-user-story/SKILL.md`, Step 3, remplacer :

```markdown
**Named in the pull request.** Every divergence from a block is named in the body
of the pull request Step 5 opens, and ruled on at the delivery review. A
divergence has only two legitimate causes:

- **`main` moved.** The paragraph a block changes no longer reads in `main` as
  the block shows it, because another story or a bounded change landed on that
  section since the batch opened. Fit the block to what `main` now carries,
  without changing its meaning, and say in the pull request what you fitted
  and why.
- **The block's text is a problem.** Stop, and put it to your human partner
  before transcribing it. Do not transcribe a text you believe is wrong, and do
  not repair it on your own: the opening gate is where that text was ruled on,
  and reopening it is your human partner's act.
```

par :

```markdown
**Named in the pull request.** Every divergence from a block is named in the body
of the pull request Step 5 opens, and ruled on at the delivery review.

When `main` moved under a block, fit the block to what `main` now carries, without
changing its meaning, and say in the pull request what you fitted and why. `main`
moved when the paragraph a block changes no longer reads in `main` as the block
shows it, because another story or a bounded change landed on that section since
the batch opened.

When the block's text is a problem, stop and put it to your human partner before
transcribing it. Do not transcribe a text you believe is wrong, and do not repair
it on your own: the opening gate is where that text was ruled on, and reopening it
is your human partner's act.
```

Le paragraphe suivant, « **Neither case amends the batch document.** … », reste tel quel.

- [ ] **Step 4: Vérifier que tout passe**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`. La garde existante « The paragraph a block changes no longer reads in \`main\` as the block shows it » passe toujours.

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la story dit quoi faire d'un écart avec un bloc" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 4: garder ce que la spec retire et que la skill garde

La spec ne dit plus : l'unicité du basename par le préfixe `NN-`, que `Spec:` est l'autorité de toute revue, que `Sections:` se déclare et ne se déduit pas, que la transcription n'est jamais le delta complet, que le lot ouvert a sa pull request fusionnée et `status: open`, que le plan s'écrit dans le document du premier commit, que le plan se pousse immédiatement, que les arbitrages se poussent, que la fusion livre la story, et que l'abandon retire le worktree. `skills/writing-a-user-story/SKILL.md` porte déjà chacun de ces points ; la tâche les garde sans toucher au texte.

**Files:**
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: rien.
- Produces: rien.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, juste avant la ligne `# --- closing-a-batch (spec 4.1, 4.2, 5.4) ---`, ajouter :

```bash
# --- writing-a-user-story: what the spec leaves to the skill (sections
# "The user story document", "Delivering a story", "Abandoning a story") ---
# The spec states the rules; these details are the method, and the skill is the
# only place that still carries them.
require writing-a-user-story "the NN- prefix keeps basenames unique" "The \`NN-\` prefix keeps basenames unique across batches"
require writing-a-user-story "Spec: is the binding authority"       "\`Spec:\` is the field \`subagent-driven-development\` already reads as the binding authority"
require writing-a-user-story "sections are declared, not derived"   "Sections are declared, not derived"
require writing-a-user-story "never the batch's whole delta"        "and never the batch's whole delta"
require writing-a-user-story "an open batch has its opening merged" "Its opening pull request is merged and its document says \`status: open\`"
require writing-a-user-story "the plan goes into the first commit's document" "Step 4 then writes the plan into that document rather than creating it"
require writing-a-user-story "the plan is pushed immediately"       "and push it immediately"
require writing-a-user-story "the records are pushed"               "Commit both on the branch and push, so they merge with it"
require writing-a-user-story "the merge delivers the story"         "The story is delivered when its pull request is merged"
require writing-a-user-story "abandoning removes the worktree too"  "remove its worktree and delete its branch, locally and on the remote"
```

- [ ] **Step 2: Vérifier que les gardes passent**

Ces gardes portent sur du texte déjà présent : elles passent dès leur ajout.

Run: `bash tests/run-all.sh`
Expected: `all tests passed`. Une garde qui échoue signale une aiguille mal recopiée : corriger l'aiguille, jamais la skill.

- [ ] **Step 3: Commit**

```bash
git add tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -m "test: garde ce que la skill de story porte hors de la spec" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: les tâches 2, 3 et 4 sont confiées à un seul implémenteur et un seul relecteur, un commit par tâche — ce sont de petites modifications de même forme sur des ancres disjointes — un défaut dans l'une retarde les autres.
- Ruling: la garde de la tâche 3 sur « the paragraph a block changes no longer reads in `main` » passe en minuscule initiale — le nouveau texte place la phrase en milieu de phrase, et le plan affirmait à tort que la garde passerait inchangée — la garde ne reconnaîtra plus une réécriture qui remettrait la phrase en tête.
- Ruling: l'exception du bloc de concision devient « a reason that is explicitly asked for, such as the why of a ruling », et la glose sur la mise en relief perd « or capitals » — le texte du plan désignait le plan comme demandeur et ajoutait les capitales, que ni la spec ni `using-batches` ne disent — un implémenteur peut lire l'exception générique plus largement que celle du flux.
- Ruling: le commentaire de la garde des règles de concision dit que seule la première phrase de chaque règle est fixée, l'exception et la glose étant adaptées à l'implémenteur — des aiguilles sur les phrases entières échoueraient par construction — une dérive des moitiés adaptées reste sans garde.
- Ruling: le paragraphe qui répétait qu'une story ne porte que le flag de son module est retiré avec sa garde — la condition « for this story's module » le dit déjà, et `using-batches` énonce le flag par module — le lecteur de la seule skill de story ne voit plus le cas des deux modules écrit en toutes lettres.
- Ruling: le paragraphe qui justifiait le bloc de concision par le seul canal des implémenteurs est retiré — la même raison est déjà donnée pour le gel et pour les règles du code gardé — aucun coût.
- Ruling: le gras des éléments conditionnels de la liste de `Global Constraints` est gardé — texte existant, que la story ne réécrit pas — une incohérence visuelle avec l'élément des règles de concision.
- Ruling: le commentaire de `tests/test-skill-content.sh` qui affirme à tort que `body_flat` garde les préfixes de citation est laissé tel quel — il précède la story et sort de ses sections — il peut tromper qui modifiera ces gardes.

## Observed drift
