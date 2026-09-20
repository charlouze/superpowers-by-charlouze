# Ce que tient le code gardé — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Faire suivre les skills à la norme du code gardé — les quatre règles
atteignent l'implémenteur par les `Global Constraints`, et une période
d'observation ne confond plus le défaut déclaré par la spec avec l'état effectif
du flag.

**Architecture:** Les quatre blocs D1 à D4 sont déjà transcrits dans la spec :
c'est le premier commit de cette branche. Le travail restant les fait voyager
jusqu'au code. La spec de ce plugin ne va pas dans les projets qui l'utilisent —
seules les skills y vont —, donc le texte intégral des règles du code gardé est
écrit dans `writing-a-user-story`, la skill qui écrit les `Global Constraints`,
et nulle part ailleurs : `using-batches` y renvoie sans le recopier, parce qu'une
seconde formulation de la même règle est exactement ce qui dérive. Les gardes
structurelles suivent le même découpage — une assertion par règle neuve, et le
nom de la nouvelle section de spec entre dans la liste des renvois vérifiés.

**Tech Stack:** Markdown (skills, spec, document de lot), bash (`tests/*.sh`,
assertions `require` et `shared` sur le corps aplati des SKILL.md).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/06-coder-sous-flag/README.md
**Sections:** Boundary, Story > The user story document, Feature flags, Feature flags > Code under a feature flag, Feature flags > Lifting a feature flag
**Blocks:** D1, D2, D3, D4

## Global Constraints

Les contraintes du lot 06, sa section `Constraints` recopiée mot pour mot :

> `none`

**Le gel du fichier de spec :**

> Between the transcription commit and the opening of the pull request, no task
> modifies the spec file. A story that discovers the spec must change stops.

Le fichier gelé est `docs/specs/supercharlouze.md`. Il a déjà reçu les quatre
blocs, au premier commit de la branche. Aucune tâche de ce plan ne le modifie.

**La règle d'autorité :** quand le lot et la spec se contredisent, **la spec
gagne — sans exception et sans délibération.** Implémente ce que dit la spec,
enregistre un `Ruling:`, et continue. **Corriger une spec en cours de lot est un
acte humain, jamais un acte d'agent.**

Le lot n'est pas correctif : la condition d'arrêt du lot correctif ne s'applique
pas. Aucune tâche de ce plan n'écrit de code gardé par un flag — le lot déclare
`Feature flag: none` —, donc les règles du code gardé ne sont pas à recopier
ici ; elles sont ce que ce plan **écrit**, pas ce qui le contraint.

**Langue :** ossature anglaise, prose dans la langue du projet. Ce plugin n'a que
de l'ossature : tout ce qui est écrit dans `skills/` et `tests/` est en anglais.
Ce document-ci porte sa prose en français.

---

## Files

- Modify: `skills/writing-a-user-story/SKILL.md` — Step 4 (`Global Constraints`
  passe à cinq choses et porte le texte intégral des règles du code gardé),
  `Lifting and Teardown Stories` (période d'observation, défaut déclaré), et sa
  table `Red Flags`.
- Modify: `skills/using-batches/SKILL.md` — la doctrine `Feature flag` renvoie
  aux règles du code gardé, et sa table `Red Flags` gagne deux lignes.
- Modify: `tests/test-skill-content.sh` — assertions `require` sur les deux
  skills ; une assertion existante change de compte.
- Modify: `tests/test-cross-references.sh` — la liste des sections de spec citées
  gagne `Code under a feature flag`.

Aucun fichier n'est créé. `docs/specs/supercharlouze.md` est gelé.

---

### Task 1: `Global Constraints` porte les règles du code gardé

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (Step 4, paragraphe
  `Global Constraints` et le bloc qui suit la condition d'arrêt corrective)
- Modify: `tests/test-cross-references.sh:113` (liste des sections citées)
- Test: `tests/test-skill-content.sh` (section
  `--- writing-a-user-story: what Global Constraints carries ---`)

**Interfaces:**
- Consumes: la section `Code under a feature flag` de
  `docs/specs/supercharlouze.md`, transcrite au premier commit de la branche.
- Produces: le bloc cité en anglais qui énonce les quatre règles du code gardé et
  la phrase `Lifting will only remove.` — c'est le texte que la tâche 3 désigne
  sans le recopier, et le seul exemplaire du dépôt.

- [ ] **Step 1: Écrire les assertions qui échouent**

Dans `tests/test-skill-content.sh`, remplacer la ligne existante :

```bash
require writing-a-user-story "GC counts four things"              "carries four things"
```

par le bloc suivant, à la même place :

```bash
require writing-a-user-story "GC counts five things"              "carries five things"
require writing-a-user-story "GC carries the guarded-code rules"  "carries a fifth thing: the rules for code under a flag"
require writing-a-user-story "the owning batch does not decide"   "whether the flag was declared by this story's batch or by another one"
require writing-a-user-story "both states coexist on the same data" "work side by side on the same data"
require writing-a-user-story "switching off loses nothing"        "with no error and no data loss"
require writing-a-user-story "flag off restores the former behaviour" "With the flag off, the user finds the behaviour"
require writing-a-user-story "both states and their coexistence are tested" "the flag-on behaviour, of the flag-off behaviour, and of their coexistence"
require writing-a-user-story "lifting only removes"               "without writing anything new"
require writing-a-user-story "the plugin's spec does not travel"  "does not travel into the projects that use it"
```

Dans `tests/test-cross-references.sh`, à l'assertion 6, remplacer :

```bash
for h in "Installing on a project" "The spec document" "Authority and conflict rules"; do
```

par :

```bash
for h in "Installing on a project" "The spec document" "Authority and conflict rules" "Code under a feature flag"; do
```

- [ ] **Step 2: Lancer les tests et vérifier qu'ils échouent**

Run: `bash tests/test-skill-content.sh; bash tests/test-cross-references.sh`

Expected: les neuf `require` neufs de `test-skill-content` en `[FAIL]`.
`test-cross-references` en `[PASS]` sur `Code under a feature flag` — la section
existe déjà dans la spec, transcrite au premier commit ; cette assertion garde
le renvoi que la tâche ajoute à l'étape suivante, elle ne le pilote pas.

- [ ] **Step 3: Faire passer `Global Constraints` à cinq choses**

Dans `skills/writing-a-user-story/SKILL.md`, remplacer :

```markdown
`Global Constraints` — which `superpowers:writing-plans` defines as implicitly
part of every task's requirements — carries four things: the constraints the
batch imposes, the freeze of the spec file, the authority rule, and — in a
corrective batch only — the fifth stop condition. The first is the batch's
```

par :

```markdown
`Global Constraints` — which `superpowers:writing-plans` defines as implicitly
part of every task's requirements — carries five things: the constraints the
batch imposes, the freeze of the spec file, the authority rule, — in a
corrective batch only — the fifth stop condition, and — in a story that writes
code guarded by a flag only — the rules for code under a flag. The first is the
batch's
```

- [ ] **Step 4: Écrire le texte à recopier**

Dans le même fichier, insérer le bloc suivant **après** le paragraphe qui se
termine par « a stop condition stated to you and not written here never reaches
the agent who has to obey it. », et **avant** le paragraphe qui commence par
« **Commit the story document** » :

```markdown
**In a story that writes code guarded by a feature flag, `Global Constraints`
carries a fifth thing: the rules for code under a flag, written out in full.**
This holds whether the flag was declared by this story's batch or by another one:
what decides is that this story writes guarded code, not which batch owns the
flag. Copy the block below verbatim:

> Code guarded by a feature flag holds for activation for some users only, for
> activation for everyone, and for deactivation, whatever way the project
> switches its flags. It holds four rules:
>
> - **Both states coexist.** A user with the flag on and a user with the flag
>   off work side by side on the same data. What one produces, the other can
>   read and use.
> - **Switching off stays possible at all times.** Turning the flag off, for one
>   user or for everyone, leaves what the on state produced readable and usable,
>   with no error and no data loss.
> - **Nothing else changes.** With the flag off, the user finds the behaviour
>   from before the batch, save for the data produced with the flag on.
> - **Each state is verified.** The story's pull request carries tests of
>   the flag-on behaviour, of the flag-off behaviour, and of their coexistence.
>
> **Lifting will only remove.** Guarded code is written so that lifting the flag
> comes down to deleting the branching and the behaviour from before the batch,
> without writing anything new.

Those rules are the spec's `Code under a feature flag` section, and this is the
only place they are written out. This plugin's spec **does not travel into the
projects that use it** — only the skills do — so a norm nobody reads while
writing the code bites on nothing. They reach the implementer the way the freeze
does, through the only channel SDD's subagents read.
```

- [ ] **Step 5: Lancer les tests et vérifier qu'ils passent**

Run: `bash tests/run-all.sh`

Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh tests/test-cross-references.sh
git commit -m "feat: les règles du code gardé atteignent les Global Constraints"
```

---

### Task 2: Une période d'observation ne change pas le défaut déclaré

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (section
  `Lifting and Teardown Stories`)
- Test: `tests/test-skill-content.sh` (section
  `--- writing-a-user-story: ... ---`, à la suite des assertions de la tâche 1)

**Interfaces:**
- Consumes: rien de la tâche 1 — les deux tâches touchent des sections
  différentes du même fichier.
- Produces: la formule `The declared default and the effective state are two
  different things.`, que la ligne `Red Flags` de la tâche 3 suppose écrite
  quelque part dans les skills.

- [ ] **Step 1: Écrire les assertions qui échouent**

Dans `tests/test-skill-content.sh`, ajouter à la suite des assertions de la
tâche 1 :

```bash
require writing-a-user-story "an observation period is two stories" "the first moves the declared default of the gating sentence from \`off\` to \`on\`"
require writing-a-user-story "declared default is not the effective state" "The declared default and the effective state are two different things"
require writing-a-user-story "only a story changes the declared default" "Only a story changes the declared default"
```

- [ ] **Step 2: Lancer le test et vérifier qu'il échoue**

Run: `bash tests/test-skill-content.sh`

Expected: les trois `require` neufs en `[FAIL]`.

- [ ] **Step 3: Écrire les deux normes**

Dans `skills/writing-a-user-story/SKILL.md`, section
`Lifting and Teardown Stories`, remplacer :

```markdown
It is a story and not a closing chore because it carries code, and code
deserves a review and a test cycle. If you want an observation period between
switching on and cleaning up, split it into two stories — enable, then remove.
The model supports that without changing anything.
```

par :

```markdown
It is a story and not a closing chore because it carries code, and code
deserves a review and a test cycle. An observation period is two stories: the
first moves the declared default of the gating sentence from `off` to `on`, the
second deletes the branching and the gating sentence. The model supports that
without changing anything.

**The declared default and the effective state are two different things.** The
spec declares a default; switching the flag on for some users, or off again, is
a move the project makes, and it changes nothing about what the spec declares.
Only a story changes the declared default — so a flag switched on everywhere is
not a flag that has been lifted, and its gating sentence still stands in the
spec for `supercharlouze:closing-a-batch` to find.
```

- [ ] **Step 4: Lancer les tests et vérifier qu'ils passent**

Run: `bash tests/run-all.sh`

Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh
git commit -m "feat: une période d'observation fait passer le défaut déclaré de off à on"
```

---

### Task 3: `using-batches` renvoie aux règles sans les recopier

**Files:**
- Modify: `skills/using-batches/SKILL.md` (doctrine `Feature flag` de la section
  `The Model`, et table `Red Flags`)
- Modify: `skills/writing-a-user-story/SKILL.md` (table `Red Flags`)
- Test: `tests/test-skill-content.sh` (section `--- using-batches: ... ---`)

**Interfaces:**
- Consumes: le bloc cité écrit par la tâche 1 dans `writing-a-user-story` — ce
  renvoi le désigne, et `tests/test-cross-references.sh` vérifie déjà que
  `supercharlouze:writing-a-user-story` résout.
- Produces: rien qu'une tâche ultérieure consomme.

- [ ] **Step 1: Écrire les assertions qui échouent**

Dans `tests/test-skill-content.sh`, section des assertions `using-batches`,
ajouter :

```bash
require using-batches "guarded code has rules of its own" "Guarded code has rules of its own, and they travel into the plan"
require using-batches "the guarded-code rules are written in one place" "a second copy of a rule is exactly what drifts"
```

- [ ] **Step 2: Lancer le test et vérifier qu'il échoue**

Run: `bash tests/test-skill-content.sh`

Expected: les deux `require` neufs en `[FAIL]`.

- [ ] **Step 3: Écrire le renvoi dans la doctrine du flag**

Dans `skills/using-batches/SKILL.md`, insérer le paragraphe suivant **après**
celui qui commence par « **Its lifetime is short, and by default the batch bounds
it.** » et **avant** celui qui commence par « **The exemption criterion is one
question:** » :

```markdown
**Guarded code has rules of its own, and they travel into the plan.** What code under a flag must hold — the two states coexisting on the same data, deactivation always possible, nothing else changing, each state tested, and a lifting that only removes — is written out in full in `supercharlouze:writing-a-user-story`, which copies it into the `Global Constraints` of every story that writes guarded code. It is written there and not here because that is the skill that writes those constraints, and a second copy of a rule is exactly what drifts.
```

- [ ] **Step 4: Ajouter les lignes `Red Flags`**

Dans `skills/using-batches/SKILL.md`, ajouter à la table `Red Flags`, juste après
la ligne qui commence par `| "The flag is still there but the batch is done` :

```markdown
| "The flag is just an `if`, the guarded code can do as it likes" | Guarded code holds four rules: both states coexist on the same data, switching off is always possible, nothing else changes, and each state is tested. They go into the story's `Global Constraints`. |
| "The flag is on for everyone, so it is lifted" | The declared default and the effective state are two different things. A flag exists as long as its gating sentence stands in the spec, and only a story removes it. |
```

Dans `skills/writing-a-user-story/SKILL.md`, ajouter à la table `Red Flags`,
juste après la ligne qui commence par
`| "The flag is an implementation detail` :

```markdown
| "This story writes guarded code, but the flag is another batch's" | The rules for code under a flag go into `Global Constraints` all the same. What decides is that this story writes guarded code, not which batch owns the flag. |
```

- [ ] **Step 5: Lancer les tests et vérifier qu'ils passent**

Run: `bash tests/run-all.sh`

Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/using-batches/SKILL.md skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh
git commit -m "feat: la doctrine du flag renvoie aux règles du code gardé"
```

---

## Rulings log

- **Ruling:** le défaut de ponctuation relevé en revue finale sur la phrase qui
  énonce ce que porte `Global Constraints` — une virgule collée à un tiret cadratin,
  et `batch's` orphelin en fin de ligne — vient du texte de remplacement prescrit
  par ce plan, pas de l'implémenteur. **Décidé :** corrigé dans la skill par un
  commit `fixup!`, le plan laissé tel que le gate l'a lu. **Si c'est faux :** le
  plan et la skill diffèrent sur la ponctuation d'une phrase, visible dans la
  pull request.
- **Ruling:** deux gloses compressées des quatre règles coexistent dans
  `using-batches` — le renvoi de la doctrine du flag et une ligne `Red Flags` — et
  la règle du registre des flags y prend une troisième formulation, qu'aucune
  assertion `shared` ne verrouille. **Décidé :** parquées. Les deux étaient
  prescrites par ce plan, une ligne `Red Flags` est compressée par convention, et
  ni l'une ni l'autre n'est une reformulation complète : la division « écrit en
  entier à un seul endroit » tient. **Si c'est faux :** une glose dérive du bloc
  canonique et un lecteur se fie à la mauvaise.
- **Ruling:** la phrase qui clôt D1 — « Le code gardé **est écrit de sorte que**
  lever le flag se réduise à supprimer le branchement » — est en tension avec le
  corollaire que porte `The spec document` : la spec ne légifère pas sur la qualité
  du code. Un autre développeur au branchement plus lourd ne la lirait pas comme
  vraie de son code. **Décidé :** transcrite telle quelle et laissée debout, la
  question remontée à l'humain. Le texte a été validé au gate d'ouverture (#29),
  il est désormais la spec, et corriger une spec est un acte humain. **Si c'est
  faux :** une phrase de spec prescrit la manière d'écrire le code, et il faut un
  changement borné pour la reformuler.

## Observed drift
