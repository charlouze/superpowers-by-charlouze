# Un arbitrage ouvert a une destination — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Faire qu'un arbitrage qui parque un constat ou le remonte à l'humain
soit nommé comme tel quand la story le recopie, et qu'il reçoive une destination
avant qu'un lot puisse être clos — au lieu de mourir à la fusion sans laisser de
trace.

**Architecture:** Les blocs D2, D3, D4 et D5 sont déjà transcrits dans la spec :
c'est le premier commit de cette branche. Le travail restant porte ces normes
dans les deux skills qui alimentent le `Rulings log` — `writing-a-user-story`,
dont l'étape 6 recopie, et `using-batches`, qui énonce la même règle en résumé —
puis dans `closing-a-batch`, où la nouvelle exigence se range là où la skill
range déjà un refus : avant les devoirs qui écrivent. Le contrôle du flag
survivant avait imposé cette place et son argument vaut mot pour mot ici, donc
le devoir neuf devient le second et les cinq devoirs qui écrivent se décalent.
Chaque norme ajoutée repart avec une garde dans `tests/test-skill-content.sh`.

**Tech Stack:** Markdown (`skills/*/SKILL.md`), bash (`tests/*.sh`, exécutés par
`tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/08-ce-que-la-cloture-laisse-passer/README.md
**Sections:** The model, Story > Delivering a story, Batch > Closing a batch
**Blocks:** D2, D3, D4, D5

## Global Constraints

Les contraintes du lot, recopiées mot pour mot de sa section `Constraints` :

- **Ordre requis.** D2 à D5 sont transcrits **dans la même story** : D3, D4 et D5
  emploient le terme que D2 pose au glossaire, et D4 et D5 visent la même section.
  Livré par tranches, chaque bloc nommerait quelque chose que la spec ne définit pas
  encore. D1 n'impose aucun ordre.
- **Une dérive constatée en concevant ce lot part en `Observed drift`**, et la
  clôture la versera au gaps register. La spec énonce deux totalités — « le spec
  delta est **le texte exact que ce lot écrit dans les specs**, en blocs » et « la
  revue d'ouverture […] **c'est là que l'humain lit ce que diront les specs** » —
  que ses propres règles contredisent : l'étape 3 de `Delivering a story` fait
  écrire la mention d'un flag par la story sans qu'aucun bloc la porte, la story de
  démontage retire de la spec ce que le lot y avait ajouté avec `Blocks: none`, et
  la levée d'un flag à portée de lot n'exige pas davantage de bloc. Le code fait ce
  que ces règles disent ; ce sont les deux totalités qui ont tort. Constat
  antérieur à ce lot, hors de son périmètre, et à ne pas résorber ici.

- **`Module > The gaps register` est hors périmètre, et le lot le sait.** La phrase
  qui énumère les sources d'une entrée — « une story, dans le code qu'elle
  traverse » — ne nomme pas l'arbitrage ouvert que D4 envoie à la consolidation.
  Elle est donc incomplète après ce lot, sans être fausse : l'énumération des
  **écrivains** reste exacte, et seule la description de ce que la clôture consolide
  reste partielle, comme elle l'est déjà pour les blocs non livrés. La section est
  tenue par la story `05-us-3-une-entree-se-lit-seule`. Ce constat part en
  `Observed drift`, et la clôture de ce lot le versera au gaps register.

Le gel du fichier de spec :

> Entre le commit de transcription et l'ouverture de la pull request, aucune tâche
> ne modifie le fichier de spec. Une story qui découvre que la spec doit changer
> s'arrête.

La règle d'autorité : **quand le lot et la spec se contredisent, la spec gagne —
sans exception et sans délibération.** Implémenter ce que dit la spec, consigner
un `Ruling:`, et poursuivre. **Corriger une spec en cours de lot est un acte
humain, jamais un acte d'agent.**

Deux contraintes de forme valables pour toute tâche :

- **Ossature anglaise, prose française** dans tout document produit ; les skills
  et les tests sont entièrement en anglais, ils n'ont pas de prose métier.
- **`bash tests/run-all.sh` est vert avant chaque commit.**

## Files

- Modify: `skills/writing-a-user-story/SKILL.md` — étape 6 : la recopie nomme ce
  qui reste à trancher ; une ligne de Red Flags.
- Modify: `skills/using-batches/SKILL.md` — la même règle, en résumé, là où la
  skill énonce déjà la recopie.
- Modify: `skills/closing-a-batch/SKILL.md` — un devoir de refus neuf en
  deuxième position, la renumérotation qui suit, la consolidation étendue, et le
  corps de la pull request de clôture.
- Modify: `tests/test-skill-content.sh` — les gardes de chaque norme portée par
  une seule skill.
- Modify: `tests/test-skill-contracts.sh` — les trois couplages entre skills,
  verrouillés par `shared`, et les numéros de devoir cités en commentaire.

---

### Task 1: La recopie nomme ce qui reste à trancher

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (Step 6, Red Flags)
- Modify: `skills/using-batches/SKILL.md` (Authority and Conflict Rules)
- Test: `tests/test-skill-contracts.sh`, `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: rien — première tâche.
- Produces: trois formules que la tâche 2 reprend **mot pour mot** dans
  `closing-a-batch`, parce qu'une assertion `shared` les verrouille aux deux
  bouts : `whose decision was to park a finding or to hand it to your human
  partner`, `the copy names what is left to settle`, et
  `refuses to close a batch while an open ruling has no destination`.

- [ ] **Step 1: Write the failing guards**

Un couplage entre skills se verrouille par une assertion `shared` unique dans
`tests/test-skill-contracts.sh`, jamais par un `require` par skill : le
commentaire du helper le dit, deux assertions séparées restent vertes toutes
les deux pendant qu'un bout dérive. Ajouter donc à la fin de
`tests/test-skill-contracts.sh` :

```bash
# The open ruling is named in the skill whose step 6 copies the rulings and in
# the routing skill that states the same duty in one clause. Three couplings,
# three assertions over both ends: what an open ruling is, what the copy owes
# it, and what refuses to close without it. `require` calls per skill would each
# stay green while one end reworded, and an agent reading that end would
# recognise a different set of rulings, or none.
shared "the open ruling is defined alike wherever it is named" \
    "whose decision was to park a finding or to hand it to your human partner" \
    writing-a-user-story using-batches

shared "the copy names what is left to settle" \
    "the copy names what is left to settle" \
    writing-a-user-story using-batches

shared "both ends name closing as what reads it" \
    "refuses to close a batch while an open ruling has no destination" \
    writing-a-user-story using-batches
```

Puis, dans `tests/test-skill-content.sh`, insérer juste après la dernière ligne
`require writing-a-user-story …` (celle libellée `"hands over to the next
story"`) la seule affirmation que `writing-a-user-story` porte seule :

```bash
# Why the copy has to name it: the ruling form carries a decision and its cost,
# and no place for what is still pending. Stated where the copying happens, and
# nowhere else — the routing skill points at the duty without re-arguing it.
require writing-a-user-story "the form cannot carry what is left" "never the fact that something is still pending"
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-contracts.sh` puis `bash tests/test-skill-content.sh`
Expected: FAIL des deux fichiers — trois lignes `[FAIL]` dans le premier, une
dans le second.

- [ ] **Step 3: Make `writing-a-user-story` name it**

Dans `skills/writing-a-user-story/SKILL.md`, section `## Step 6 — Record Before
the Merge`, remplacer la première puce :

```markdown
- Copy every `Ruling:` line from SDD's closing "Rulings I made" message into
  the **Rulings log** of the story document. The list is exhaustive.
```

par :

```markdown
- Copy every `Ruling:` line from SDD's closing "Rulings I made" message into
  the **Rulings log** of the story document. The list is exhaustive. For a
  ruling whose decision was to park a finding or to hand it to your human
  partner — an **open ruling** — **the copy names what is left to settle**,
  under the copied line. Copying alone cannot produce that: the form
  `Ruling: <decision> — <why> — <what it costs if it is wrong>` carries the
  decision and what it costs, never the fact that something is still pending.
  `supercharlouze:closing-a-batch` refuses to close a batch while an open
  ruling has no destination, and what you write here is what it reads.
```

Puis ajouter, à la fin de la table `## Red Flags` de la même skill, la ligne :

```markdown
| "The ruling line already says I parked the finding" | It says what was decided and what it costs, never that something is still pending. Name what is left to settle under the line, or closing has nothing to read. |
```

- [ ] **Step 4: Make `using-batches` say the same in one clause**

Dans `skills/using-batches/SKILL.md`, section `## Authority and Conflict Rules`,
remplacer la fin du paragraphe **Every conflict is recorded for the human.** :

```markdown
Copy those lines into the story document, on the story's branch, before the merge — they are perishable, and the workspace is already gone.
```

par :

```markdown
Copy those lines into the story document, on the story's branch, before the merge — they are perishable, and the workspace is already gone. For a ruling whose decision was to park a finding or to hand it to your human partner — an **open ruling** — the copy names what is left to settle, because the ruling form alone does not: `supercharlouze:closing-a-batch` refuses to close a batch while an open ruling has no destination, and that is what it reads.
```

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md skills/using-batches/SKILL.md tests/test-skill-contracts.sh tests/test-skill-content.sh
git commit -m "feat: la recopie des arbitrages nomme ce qui reste à trancher"
```

---

### Task 2: La clôture refuse un arbitrage ouvert sans destination

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md` (Overview, The Six Duties, devoir
  neuf, renumérotation, Red Flags)
- Modify: `tests/test-skill-contracts.sh` (numéros de devoir en commentaire)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: de la tâche 1, la définition verrouillée par `shared` —
  `whose decision was to park a finding or to hand it to your human partner` —
  que le devoir neuf doit porter mot pour mot.
- Produces: le devoir `### 2. Refuse to close on an open ruling with no
  destination`, que la tâche 3 cite sous la forme « duty 2 », et la
  numérotation `### 3.` à `### 7.` que la tâche 3 utilise.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh`, bloc
`# --- closing-a-batch: the three duty precisions …` : remplacer d'abord son
titre de commentaire par
`# --- closing-a-batch: the duty precisions (spec section "Closing a batch") ---`,
puis remplacer la ligne :

```bash
require closing-a-batch "duty 1 checks before the writing duties" "it comes before any other duty writes anything"
```

par :

```bash
require closing-a-batch "both checks come before the writing duties" "they come before any other duty writes anything"
```

et ajouter à la fin du même bloc :

```bash
# The open-ruling check (spec section "Closing a batch"). Five assertions: the
# duty exists and is second, the count that places it there, the two
# destinations, the refusal itself, and why Observed drift is not an outlet.
# Drop any one and the duty still reads whole while doing less. What an open
# ruling *is* is not asserted here — it is a coupling with the two skills that
# name it, locked by `shared` in test-skill-contracts.sh.
require closing-a-batch "the open ruling check is duty 2"         "### 2. Refuse to close on an open ruling"
require closing-a-batch "seven duties in all"                     "Do all seven on the same branch"
require closing-a-batch "a violation or a gap goes to the register" "A violation or a gap goes to the gaps register"
require closing-a-batch "any other destination is the human's"    "its destination is your human partner's to give"
require closing-a-batch "refuses without a destination"           "cannot be closed while an open ruling has no destination"
require closing-a-batch "Observed drift is not an outlet"         "Observed drift cannot collect it either"
```

Enfin, dans `tests/test-skill-contracts.sh`, étendre l'assertion que la tâche 1
a posée — la skill qui refuse de clore doit reconnaître exactement les mêmes
arbitrages que celle qui les nomme. Remplacer :

```bash
shared "the open ruling is defined alike wherever it is named" \
    "whose decision was to park a finding or to hand it to your human partner" \
    writing-a-user-story using-batches
```

par :

```bash
shared "the open ruling is defined alike wherever it is named" \
    "whose decision was to park a finding or to hand it to your human partner" \
    writing-a-user-story using-batches closing-a-batch
```

et, dans le commentaire qui la précède, remplacer « in the routing skill that
states the same duty in one clause » par « in the routing skill that states the
same duty in one clause, and in the skill that refuses to close on one ».

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-content.sh` puis `bash tests/test-skill-contracts.sh`
Expected: FAIL des deux — sept lignes `[FAIL]` dans le premier (les six ajoutées
et celle dont le needle vient de changer), et dans le second l'assertion
étendue, qui signale `(missing in: closing-a-batch)`.

- [ ] **Step 3: Retitle the duties and open the count**

Dans `skills/closing-a-batch/SKILL.md`, cinq remplacements dans l'ordre du
fichier.

Remplacer :

```markdown
Six duties, one pull request, on a branch named `batch/NN-<slug>-close`. Duty 1 is allowed to refuse, and because it is allowed to refuse it comes before the five that write.
```

par :

```markdown
Seven duties, one pull request, on a branch named `batch/NN-<slug>-close`. Duties 1 and 2 are allowed to refuse, and because they are allowed to refuse they come before the five that write.
```

Remplacer `## The Six Duties` par `## The Seven Duties`.

Remplacer :

```markdown
Do all six on the same branch, in order. Then open one pull request.

**Duty 1 is a check, not a write, and it comes before any other duty writes anything.** Read the code and the specs for surviving flags this batch declared and decide whether this batch may be closed at all; only then write.
```

par :

```markdown
Do all seven on the same branch, in order. Then open one pull request.

**Duties 1 and 2 are checks, not writes, and they come before any other duty writes anything.** Read the code and the specs for the flags this batch declared and still survive, read the Rulings log of every story document for the rulings it left open, and decide whether this batch may be closed at all; only then write.
```

Remplacer :

```markdown
So: if duty 1 refuses, **stop before writing anything.** Report the surviving flag, present the three exits below, and leave the batch open. The only thing to clean up is an empty branch and its workspace.
```

par :

```markdown
So: if either check refuses, **stop before writing anything.** Report what refused — the surviving flag with the three exits below, or the open rulings still without a destination — and leave the batch open. The only thing to clean up is an empty branch and its workspace.
```

Dans le paragraphe qui commence `The reason is what a refusal costs.`, remplacer
la phrase :

```markdown
Duty 1 writes nothing — it reports and hands the decision to your human partner.
```

par :

```markdown
Neither check writes anything — each reports and hands the decision to your human partner.
```

- [ ] **Step 4: Write the new duty**

Insérer, entre la fin du devoir `### 1. Refuse to close on a flag that survives
without a declared scope` (le paragraphe qui se termine par « the refusal would
manufacture exactly the dead flagged code it is meant to prevent. ») et le titre
`### 2. Write the changelog line`, la section suivante :

```markdown
### 2. Refuse to close on an open ruling with no destination

It writes nothing either, so it stands beside duty 1, before anything is written. Its cost of refusal is the same, and so is the remedy: check on an empty branch and a refusal costs nothing.

Read the **Rulings log** of every story document in the batch. An **open ruling** is one whose decision was to park a finding or to hand it to your human partner — it leaves something to settle after the merge, and step 6 of `supercharlouze:writing-a-user-story` had the story name, under the copied line, what that something is. You are reading what it named.

Every open ruling gets a destination, and there are only two:

- **A violation or a gap goes to the gaps register**, with duty 4's consolidation — a violation where the code contradicts the spec, a gap where it is behaviour no spec describes.
- **Anything else has no home in the register**, so its destination is your human partner's to give, and the closing pull request names it (duty 7).

**A batch cannot be closed while an open ruling has no destination.** Stop before writing anything, list the rulings still without one, and ask.

Nothing else collects them, and that is the whole reason. A parked finding is read once, at the delivery gate; if your human partner merges without acting on it, it dies at the closing and its disappearance leaves no trace — what disappears leaves none. **Observed drift cannot collect it either**, by construction: that section takes divergences between the spec and the code, and a parked finding need not be one. A mechanism prescribed but not yet built is neither a violation nor a gap, and the register has nowhere to put it.

A refusal is what makes this bite, and it is why the rule is not a line in a pull request body. A mention is read or it is not; a refusal is not optional — exactly as it is not for a flag that survives without a declared scope.
```

- [ ] **Step 5: Renumber the five duties that write**

Toujours dans `skills/closing-a-batch/SKILL.md`, renuméroter les titres :

- `### 2. Write the changelog line` → `### 3. Write the changelog line`
- `### 3. Consolidate observed drift` → `### 4. Consolidate observed drift`
- `### 4. Release unconsumed reservations` → `### 5. Release unconsumed reservations`
- `### 5. Record blocks announced but never delivered` → `### 6. Record blocks announced but never delivered`
- `### 6. Set status: closed` → `### 7. Set status: closed`

Puis les huit renvois internes, chacun une occurrence unique :

| Texte actuel | Texte qui le remplace |
|---|---|
| `find reservations duty 4 had already released` | `find reservations duty 5 had already released` |
| `duty 5 catches it undelivered, not this one` | `duty 6 catches it undelivered, not this one` |
| `the same contention duty 2 avoids` | `the same contention duty 3 avoids` |
| `duty 4 is the whole of this duty for a corrective batch` | `duty 5 is the whole of this duty for a corrective batch` |
| `it is the record that the other five were done` | `it is the record that the other six were done` |
| `Duty 1 writes nothing, so it checks first.` | `Duties 1 and 2 write nothing, so they check first.` |
| `Right, and duty 5 checks the rest` | `Right, and duty 6 checks the rest` |
| `The whole point of duty 5 is the difference.` | `The whole point of duty 6 is the difference.` |

- [ ] **Step 6: Add the Red Flags rows**

Ajouter à la fin de la table `## Red Flags` de `closing-a-batch` :

```markdown
| "An open ruling was only a note to the human, and the merge settled it" | Nothing settled it. A parked finding is read once, at the delivery gate, and dies at the closing if nobody acts. Give it a destination or leave the batch open. |
| "The open ruling is out of scope, so Observed drift covers it" | It cannot: that section takes divergences between spec and code, and a parked finding need not be one. |
```

- [ ] **Step 7: Fix the duty numbers cited in the contract tests**

Dans `tests/test-skill-contracts.sh`, les commentaires des lignes ~176, ~180 et
~184 parlent de « duty 5 » pour le devoir qui lit les déclarations `Blocks:`, et
celui de la ligne ~184 renvoie à « duty 5's own contrast ». Remplacer chaque
`duty 5` de ces commentaires par `duty 6`, sans toucher aux assertions
elles-mêmes. Faire de même pour l'étiquette de `tests/test-skill-content.sh` :

- `require closing-a-batch "duty 5 reads the Blocks declarations"` →
  `require closing-a-batch "duty 6 reads the Blocks declarations"`
- `require closing-a-batch "an earlier batch's flag goes to duty 5"` →
  `require closing-a-batch "an earlier batch's flag goes to duty 6"`
- `require closing-a-batch "duty 5 is empty for a corrective batch"` →
  `require closing-a-batch "duty 6 is empty for a corrective batch"`

Les needles ne changent pas ; seules les étiquettes changent.

- [ ] **Step 8: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 9: Commit**

```bash
git add skills/closing-a-batch/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
git commit -m "feat: la clôture refuse un arbitrage ouvert sans destination"
```

---

### Task 3: La consolidation prend les arbitrages ouverts, la pull request nomme le reste

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md` (devoir 4, devoir 7)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: de la tâche 2, le devoir 2 et son tri en deux destinations, et la
  numérotation `### 4.` / `### 7.`.
- Produces: rien — dernière tâche.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh`, ajouter à la fin du bloc
`# --- closing-a-batch: the duty precisions …` :

```bash
# Where the two destinations of duty 2 actually land. Both assertions matter: a
# skill that sorted the rulings and then wrote neither of them anywhere would
# pass every guard above.
require closing-a-batch "the consolidation takes the open rulings" "The open rulings duty 2 sent to the register join them here"
require closing-a-batch "the PR body names the other destinations" "names the destination of every open ruling that did not join the register"
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — deux lignes `[FAIL]`.

- [ ] **Step 3: Extend the consolidation duty**

Dans `skills/closing-a-batch/SKILL.md`, devoir
`### 4. Consolidate observed drift`, ajouter un paragraphe juste après celui qui
commence par `Collect the **Observed drift** section of every story document` :

```markdown
**The open rulings duty 2 sent to the register join them here**, filed the same way: a violation under **Violations**, a gap under **Gaps**. They arrive from the Rulings log and not from `Observed drift`, because a parked finding is not a divergence between spec and code — which is exactly why the story that made it could not record it there.
```

- [ ] **Step 4: Make the closing pull request name the rest**

Toujours dans `skills/closing-a-batch/SKILL.md`, devoir
`### 7. Set status: closed`, dans le paragraphe qui commence par `Then push and
open the pull request.`, insérer après la première phrase :

```markdown
**Its body names the destination of every open ruling that did not join the register** — the one your human partner gave at duty 2. Those have nowhere else to go: the register does not take them, and the batch document records scope, not arbitrations. Written here, they are read at the closing gate by the person who gave them.
```

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/closing-a-batch/SKILL.md tests/test-skill-content.sh
git commit -m "feat: la consolidation prend les arbitrages ouverts et la clôture nomme le reste"
```

## Rulings log

## Observed drift
