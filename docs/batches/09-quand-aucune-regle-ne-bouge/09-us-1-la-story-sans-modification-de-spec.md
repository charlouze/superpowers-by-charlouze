# 09-us-1 — La story sans modification de spec

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/09-quand-aucune-regle-ne-bouge/README.md
**Sections:** Authority and conflict rules, Story, Story > The user story document, Story > Delivering a story, Story > Abandoning a story
**Blocks:** D6, D8, D9, D17, D18, D19, D20

**Goal:** Mettre les skills en conformité avec la spec que le premier commit de
cette branche a livrée : une pull request de story ne porte jamais sa
modification de spec sans le code, mais elle peut porter le code seul.

**Architecture:** Le code de ce dépôt, ce sont les cinq skills de `skills/`, le
`README.md` qui les présente, et la suite d'assertions de `tests/` qui les tient.
La modification de spec est déjà commitée ; chaque tâche ci-dessous prend une des
quatre affirmations que cette modification a rendues fausses, écrit l'assertion
qui la constate, puis corrige le texte des skills jusqu'à ce qu'elle passe.

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

**Gel du fichier de spec** — tel que la spec l'énonce désormais :

> Entre le premier commit de la branche et l'ouverture de la pull request, aucune
> tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit
> changer s'arrête.

`docs/specs/supercharlouze.md` est donc en lecture seule pour toutes les tâches de
ce plan. Il porte déjà les sept blocs ; c'est l'autorité que chaque tâche lit, et
jamais un fichier qu'elle écrit.

**Règle d'autorité** — quand le lot et la spec se contredisent, la spec gagne, sans
exception et sans délibération. Implémente ce que dit la spec, consigne un
`Ruling:`, et poursuis. **Corriger une spec en cours de lot est un acte humain,
jamais un acte d'agent.**

**Langue** — squelette anglais, prose française. Les skills, le `README.md` et les
tests sont intégralement en anglais : c'est leur langue, et ce plan ne la change
pas. Seul ce document-ci est français.

---

## Files

- `skills/using-batches/SKILL.md` — la doctrine que les quatre autres skills
  supposent connue. Porte l'appariement (l. 125), le tableau des gates (l. 137), le
  premier commit d'une branche de story (l. 127) et le gel (l. 178).
- `skills/writing-a-user-story/SKILL.md` — la procédure. Porte l'appariement en
  Overview (l. 10-15), le cas de la story corrective en Step 3 (l. 287), le gel
  recopié en `Global Constraints` (l. 360), les deux sections vides en Step 4
  (l. 327-337) et l'abandon (l. 564-572).
- `skills/closing-a-batch/SKILL.md` — porte le décompte de ce qu'un abandon laisse
  sur `main` (l. 14).
- `README.md` — porte le tableau des gates destiné aux humains (l. 89).
- `tests/test-skill-contracts.sh` — les couplages entre skills : une assertion pour
  plusieurs fichiers, et les `absent` qui interdisent à une formulation supprimée de
  survivre quelque part.
- `tests/test-skill-content.sh` — ce qu'un skill doit dire, skill par skill.

**Aucune tâche ne touche `docs/specs/supercharlouze.md`** — voir le gel.

## Interfaces

Les tâches ne se passent pas de signatures : elles se passent des **phrases
canoniques**, qui doivent être écrites au mot près parce qu'une assertion `shared`
les cherche dans plusieurs fichiers à la fois.

- Tâche 1 produit : `never carries its spec change without the code that implements it`
- Tâche 2 produit : `Between the first commit of the branch and the opening of the pull request, no task modifies the spec file`
- Tâche 3 conserve : `deletes the gaps register entry it resolves`
- Tâche 4 ne produit aucune phrase partagée : elle supprime deux décomptes.

Les assertions comparent le **corps aplati** du skill : `body_flat` retire la
frontmatter, le `>` de début de ligne d'une citation, et écrase les suites
d'espaces. Une phrase canonique peut donc être coupée par un retour à la ligne,
mais ne doit jamais contenir deux espaces consécutifs.

---

### Task 1: L'appariement dit par la négation

La spec affirmait l'appariement sans condition à trois endroits (`Authority and
conflict rules`, son tableau des revues, et la tête de `Story`) ; `D17`, `D18` et
`D19` l'ont réécrit par la négation. Les skills et le `README.md` portent encore
l'affirmation sans condition, et un agent qui les lit croira qu'une story sans
modification de spec est illégale.

**Files:**
- Modify: `skills/using-batches/SKILL.md:125` et `skills/using-batches/SKILL.md:137`
- Modify: `skills/writing-a-user-story/SKILL.md:10-15`
- Modify: `README.md:89`
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: rien.
- Produces: la phrase canonique `never carries its spec change without the code that
  implements it`, que `using-batches` et `writing-a-user-story` portent tous les
  deux.

- [ ] **Step 1: Write the failing assertions**

Ajoute à la fin de `tests/test-skill-contracts.sh`, avant le bloc final qui sort
sur `$FAILURES` :

```bash
# The pairing of a spec change with its code is stated by the negation, because a
# story may carry code alone — a corrective batch's story does today. Both skills
# that state it must spell it alike: the doctrine and the procedure drifting apart
# here is exactly how an agent ends up believing a story owes the spec a sentence.
shared "the pairing is stated by the negation" \
    "never carries its spec change without the code that implements it" \
    using-batches writing-a-user-story

# The mirror. The positive assertion above stays green on a file that carries both
# the negation and the old unconditional claim, and it is the old one an agent would
# obey — it is the shorter and the more emphatic of the two.
absent "no skill pairs spec change and code unconditionally" \
    "ship together or not at all|\*both\* the spec change" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Run the suite to verify the new assertions fail**

Run: `bash tests/run-all.sh`

Expected: `test-skill-contracts` echoue sur trois lignes —
`[FAIL] the pairing is stated by the negation (missing in: using-batches
writing-a-user-story)` et `[FAIL] no skill pairs spec change and code
unconditionally (present in: using-batches writing-a-user-story)`, et `run-all.sh`
sort en erreur.

- [ ] **Step 3: Rewrite the doctrine paragraph in `using-batches`**

Remplace la ligne 125 de `skills/using-batches/SKILL.md` :

```markdown
**A story's pull request carries the spec change and the code that implements it.** They ship together or not at all, in the same pull request. That is what gives `main` its central property: **its spec always describes exactly what its code does.** There is no intermediate state to signal, therefore no marker, no semantics to explain to agents that know nothing about this plugin, and no exception to the drift rule.
```

par :

```markdown
**A story's pull request never carries its spec change without the code that implements it.** Stated as a negation, and not as a pairing, because the other direction is legitimate: a corrective batch's story carries code alone, and so does any story that transcribes no block. What the negation forbids is the one order that would break `main` — a norm landing ahead of the code that honours it. That is what gives `main` its central property: **its spec always describes exactly what its code does.** There is no intermediate state to signal, therefore no marker, no semantics to explain to agents that know nothing about this plugin, and no exception to the drift rule.
```

- [ ] **Step 4: Rewrite the gate table row in `using-batches`**

Remplace la ligne 137 de `skills/using-batches/SKILL.md` :

```markdown
| Story delivery | the pull request carrying the spec change and the code |
```

par :

```markdown
| Story delivery | the pull request carrying a story's code, and its spec change if it has one |
```

- [ ] **Step 5: Rewrite the Overview of `writing-a-user-story`**

Remplace les lignes 10 à 15 de `skills/writing-a-user-story/SKILL.md` :

```markdown
A story is the unit of technical delivery: **one story, one branch, one pull
request** — and that pull request carries *both* the spec change and the code
that implements it. They ship together or not at all. That is what gives
`main` its central property: **its spec always describes exactly
what its code does.** No intermediate state to signal, no marker, no exception
to the drift rule.
```

par :

```markdown
A story is the unit of technical delivery: **one story, one branch, one pull
request** — and that pull request never carries its spec change without the code
that implements it. The reverse is legitimate: a story that transcribes no block
carries code alone. That is what gives `main` its central property: **its spec
always describes exactly what its code does.** No intermediate state to signal,
no marker, no exception to the drift rule.
```

- [ ] **Step 6: Rewrite the gate table row in `README.md`**

Remplace la ligne 89 de `README.md` :

```markdown
| Story delivery | the spec change and the code that implements it, in one diff |
```

par :

```markdown
| Story delivery | a story's code, and its spec change if it has one, in one diff |
```

- [ ] **Step 7: Run the suite to verify it passes**

Run: `bash tests/run-all.sh`

Expected: `all tests passed`.

- [ ] **Step 8: Commit**

```bash
git add skills/using-batches/SKILL.md skills/writing-a-user-story/SKILL.md README.md tests/test-skill-contracts.sh
git commit -m "fix: dis l'appariement spec et code par la négation"
```

---

### Task 2: Le gel ancré sur le premier commit de la branche

`D9` a déplacé le début du gel : il ne part plus du « commit de transcription »,
qui n'existe pas pour une story sans bloc, mais du premier commit de la branche.
Les deux skills qui énoncent le gel le datent encore de la transcription, et
`writing-a-user-story` le recopie sous cette forme dans les `Global Constraints`
de chaque plan — donc sous les yeux de chaque implémenteur.

**Files:**
- Modify: `skills/using-batches/SKILL.md:178`
- Modify: `skills/writing-a-user-story/SKILL.md:359-362`
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: rien de la tâche 1.
- Produces: la phrase canonique `Between the first commit of the branch and the
  opening of the pull request, no task modifies the spec file`.

- [ ] **Step 1: Write the failing assertions**

Ajoute à la fin de `tests/test-skill-contracts.sh`, avant le bloc final qui sort
sur `$FAILURES` :

```bash
# The freeze is copied verbatim into the Global Constraints of every plan, so the
# skill that states the norm and the skill that copies it must spell it identically.
# Two separate assertions would each stay green while the copied wording drifted
# from the stated one, and the implementers only ever read the copy.
shared "the freeze is spelled alike wherever it is stated" \
    "Between the first commit of the branch and the opening of the pull request, no task modifies the spec file" \
    using-batches writing-a-user-story

# The mirror. A story that transcribes no block has no transcription commit, so a
# freeze anchored there starts nowhere — and a skill carrying both anchors would
# leave the positive assertion green while still handing implementers the old one.
# The needle is the old opening and not the bare phrase, because both skills go on
# to name the transcription commit in order to say the freeze no longer starts there.
absent "no skill anchors the freeze on a transcription commit" \
    "Between the transcription commit" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Run the suite to verify the new assertions fail**

Run: `bash tests/run-all.sh`

Expected: `[FAIL] the freeze is spelled alike wherever it is stated (missing in:
using-batches writing-a-user-story)` et `[FAIL] no skill anchors the freeze on a
transcription commit (present in: using-batches writing-a-user-story)`.

- [ ] **Step 3: Rewrite the freeze in `using-batches`**

Remplace, dans la ligne 178 de `skills/using-batches/SKILL.md`, le fragment :

```markdown
**The spec file is frozen, with a start and an end.** Between the transcription commit and the opening of the pull request, no task modifies the spec file; a story that discovers the spec must change stops.
```

par :

```markdown
**The spec file is frozen, with a start and an end.** Between the first commit of the branch and the opening of the pull request, no task modifies the spec file; a story that discovers the spec must change stops. The start is the branch's first commit and not its transcription commit, because a story that transcribes no block has no transcription commit and would then be frozen from nowhere.
```

Le reste de la ligne — « Once the pull request is open the freeze lifts… » jusqu'à
« …under the eyes of every implementer and every reviewer. » — est inchangé.

- [ ] **Step 4: Rewrite the freeze quoted in `writing-a-user-story`**

Remplace les lignes 359 à 362 de `skills/writing-a-user-story/SKILL.md` :

```markdown
> Between the transcription commit and the opening of the pull request, no task
> modifies the spec file. A story that discovers the spec must change stops.
```

par :

```markdown
> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.
```

Puis, dans le paragraphe qui suit immédiatement cette citation et qui commence par
« The freeze exists because the spec file now travels in the same branch as the
code », ajoute en fin de paragraphe :

```markdown
The start is the branch's first commit, not its transcription commit: a story that
transcribes no block has none, and a freeze anchored there would start nowhere.
```

- [ ] **Step 5: Run the suite to verify it passes**

Run: `bash tests/run-all.sh`

Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/using-batches/SKILL.md skills/writing-a-user-story/SKILL.md tests/test-skill-contracts.sh
git commit -m "fix: ancre le gel de la spec sur le premier commit de la branche"
```

---

### Task 3: Ce que porte le premier commit quand aucun bloc n'est transcrit

`D8` répond à une question que les skills laissaient sans réponse : une story qui
ne transcrit aucun bloc a quand même un premier commit, et ce commit porte
désormais l'en-tête de son document de story et ses deux sections vides, plus ce
que cette story-là retire. `D6` en est le corollaire : les deux sections sont
créées « en même temps que l'en-tête », et non plus « au moment du plan », puisque
l'en-tête peut précéder le plan. Les skills ne décrivent ce premier commit que pour
le cas correctif, et Step 4 fait encore naître les deux sections avec le plan.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md:287-293` et
  `skills/writing-a-user-story/SKILL.md:327-337`
- Modify: `skills/using-batches/SKILL.md:127`
- Test: `tests/test-skill-contracts.sh:291-297`, `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: rien des tâches 1 et 2.
- Produces: conserve intacte la phrase canonique `deletes the gaps register entry it
  resolves`, que l'assertion `shared` existante cherche dans les deux skills. La
  généralisation l'entoure, elle ne la réécrit pas.

- [ ] **Step 1: Retarget the existing contract and add the new assertion**

Dans `tests/test-skill-contracts.sh`, remplace le commentaire et l'assertion des
lignes 291 à 297 :

```bash
# A corrective story's first commit is described in two places — the skill that
# prescribes it and the one that explains why it is the single exception of form
# to "the spec change ships first". One assertion over both: two `require` calls
# would each stay green while one end drifted back to striking the entry.
shared "a corrective story's first commit deletes its entry" \
    "deletes the gaps register entry it resolves" \
    writing-a-user-story using-batches
```

par :

```bash
# The first commit of a story that transcribes no block is described in two places —
# the skill that prescribes it and the one that explains why it is the exception of
# form to "the spec change ships first". One assertion over both: two `require`
# calls would each stay green while one end drifted back to striking the entry.
shared "a story with no block still deletes its entry that way" \
    "deletes the gaps register entry it resolves" \
    writing-a-user-story using-batches

# What that first commit carries besides the removal, so the branch holds a document
# from its first commit and the plan has somewhere to be written at Step 4.
shared "that first commit carries the story document's header" \
    "the header of the story document and its empty \`Rulings log\` and \`Observed drift\` sections" \
    writing-a-user-story using-batches

# The mirror: the case is no longer the corrective batch's alone, and a skill that
# still scopes it there sends any other blockless story looking for a rule that
# names a batch kind it does not belong to.
absent "no skill scopes the blockless first commit to a corrective story" \
    "\*\*Corrective story\.\*\*|A corrective story is the one exception" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Run the suite to verify the new assertions fail**

Run: `bash tests/run-all.sh`

Expected: `[FAIL] that first commit carries the story document's header (missing
in: writing-a-user-story using-batches)` et `[FAIL] no skill scopes the blockless
first commit to a corrective story (present in: using-batches
writing-a-user-story)`. L'assertion renommée passe déjà : c'est voulu, elle garde
la phrase que la généralisation ne doit pas perdre.

- [ ] **Step 3: Generalise the paragraph in `writing-a-user-story` Step 3**

Remplace les lignes 287 à 293 de `skills/writing-a-user-story/SKILL.md` :

```markdown
**Corrective story.** The delta being empty, this first commit does not touch
the spec. It deletes the gaps register entry it resolves from
`docs/specs/<module>.gaps.md`, and the commit that removes it says why. That
plays the same role: fixing the scope in the branch's history before any code
exists. Removing an entry takes out lines nobody else is writing, so two stories
removing different entries do not collide — and what the entry said, and why it
went, stay readable in the history of the file.
```

par :

```markdown
**A story that transcribes no block** still has this first commit, and it still
fixes the scope in the branch's history before any code exists. It carries the
header of the story document and its empty `Rulings log` and `Observed drift`
sections — Step 4 then writes the plan into that document rather than creating it
— together with what this particular story removes.

A corrective batch's story removes an entry: it deletes the gaps register entry it
resolves from `docs/specs/<module>.gaps.md`, and the commit that removes it says
why. Removing an entry takes out lines nobody else is writing, so two stories
removing different entries do not collide — and what the entry said, and why it
went, stay readable in the history of the file. Any other blockless story removes
from the spec what no block announces, and that removal is this same commit.
```

- [ ] **Step 4: Adjust Step 4 so it does not create a document that exists**

Remplace, dans `skills/writing-a-user-story/SKILL.md`, les lignes 327 à 337 :

```markdown
Then create, at the end of the document, the two sections Step 6 fills — empty
now, and left empty if nothing turns up:

```markdown
## Rulings log

## Observed drift
```

Write them at the same time as the header, not at Step 6. An empty section says
*checked, nothing found*; a missing section says *never examined*, and a
reviewer cannot tell the second from an omission.
```

par :

```markdown
Then create, at the end of the document, the two sections Step 6 fills — empty
now, and left empty if nothing turns up:

```markdown
## Rulings log

## Observed drift
```

Write them at the same time as the header, never at Step 6. An empty section says
*checked, nothing found*; a missing section says *never examined*, and a reviewer
cannot tell the second from an omission. A story that transcribed no block wrote
both at Step 3, with the header: they are already there, and this step writes the
plan into the document between them.
```

- [ ] **Step 5: Generalise the sentence in `using-batches`**

Remplace, dans la ligne 127 de `skills/using-batches/SKILL.md`, le fragment :

```markdown
A corrective story is the one exception in form and not in purpose: its spec delta is empty, so its first commit deletes the gaps register entry it resolves instead, which fixes its scope in the branch's history exactly the same way.
```

par :

```markdown
A story that transcribes no block is the exception in form and not in purpose: it has no spec change to ship first, so its first commit carries the header of the story document and its empty `Rulings log` and `Observed drift` sections, plus what that story removes — a corrective batch's story deletes the gaps register entry it resolves — which fixes its scope in the branch's history exactly the same way.
```

Le reste de la ligne — « **The spec change is the first commit of every story
branch**… » en tête, « Batch-opening and batch-closing branches carry no spec
change at all… » en fin — est inchangé.

- [ ] **Step 6: Run the suite to verify it passes**

Run: `bash tests/run-all.sh`

Expected: `all tests passed`.

- [ ] **Step 7: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md skills/using-batches/SKILL.md tests/test-skill-contracts.sh
git commit -m "fix: dis ce que porte le premier commit d'une story sans bloc"
```

---

### Task 4: Ce qui subsiste sur `main` après un abandon

`D20` a retiré le décompte : l'abandon ne laisse plus « deux résidus » mais « ce qui
subsiste ». Le décompte était faux dès qu'une story ne transcrit aucun bloc — il n'y
a alors aucune intention annoncée au spec delta et jamais livrée, donc un seul
résidu. Deux skills comptent encore.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md:564-572`
- Modify: `skills/closing-a-batch/SKILL.md:14`
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: rien des tâches 1 à 3.
- Produces: aucune phrase partagée. Cette tâche supprime deux décomptes et
  n'introduit pas de couplage.

- [ ] **Step 1: Write the failing assertion**

Ajoute à la fin de `tests/test-skill-contracts.sh`, avant le bloc final qui sort
sur `$FAILURES` :

```bash
# What an abandonment leaves on `main` is not a fixed count: a story that
# transcribed no block announced no intention in the spec delta, so it leaves the
# reservation alone. A skill that counts hands closing a checklist of the wrong
# length, and closing is the only skill that picks these up.
absent "no skill counts what an abandonment leaves on main" \
    "Two residues|two residues|two things it never touched" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Run the suite to verify the new assertion fails**

Run: `bash tests/run-all.sh`

Expected: `[FAIL] no skill counts what an abandonment leaves on main (present in:
writing-a-user-story closing-a-batch)`.

- [ ] **Step 3: Drop the count in `writing-a-user-story`**

Remplace les lignes 564 à 572 de `skills/writing-a-user-story/SKILL.md` :

```markdown
**Abandoning is almost free.** Closing the pull request without merging throws
the transcription away with the code — nothing to revoke, no spec to put back
straight. If the abandonment happens before the pull request exists — a
requalification under Override 2, a story dropped mid-run — there is nothing to
close, only a branch and a worktree to discard. Two residues remain on `main`:
the gaps register
reservation posted by the batch's opening pull request, and the blocks the
batch announced and no story delivered. Both belong to
`supercharlouze:closing-a-batch`.
```

par :

```markdown
**Abandoning is almost free.** Closing the pull request without merging throws
the transcription away with the code — nothing to revoke, no spec to put back
straight. If the abandonment happens before the pull request exists — a
requalification under Override 2, a story dropped mid-run — there is nothing to
close, only a branch and a worktree to discard. What remains on `main` belongs to
`supercharlouze:closing-a-batch`: the gaps register reservation posted by the
batch's opening pull request, and the blocks the batch announced and no story
delivered. Do not count them — a story that transcribed no block announced
nothing in the spec delta and leaves the reservation alone.
```

- [ ] **Step 4: Drop the count in `closing-a-batch`**

Remplace, dans la ligne 14 de `skills/closing-a-batch/SKILL.md`, le fragment :

```markdown
But two things it never touched are still on `main`, put there by the batch's own opening pull request: the gaps register entry the batch reserved, and the blocks the batch announced in its spec delta.
```

par :

```markdown
But what it never touched is still on `main`, put there by the batch's own opening pull request: the gaps register entry the batch reserved, and the blocks the batch announced in its spec delta. Either may be absent — a batch with no blocks announced none, a batch that reserved nothing left nothing to release — so what closing owes here is a look at both, not a tally.
```

- [ ] **Step 5: Run the suite to verify it passes**

Run: `bash tests/run-all.sh`

Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md skills/closing-a-batch/SKILL.md tests/test-skill-contracts.sh
git commit -m "fix: ne compte plus ce qu'un abandon laisse sur main"
```

---

## Rulings log

## Observed drift
