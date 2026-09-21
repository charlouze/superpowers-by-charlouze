# La destination d'un arbitrage ouvert — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Donner à un arbitrage ouvert une destination obligatoire — le gaps
register par la clôture, ou la revue de livraison — pour qu'aucun ne meure
silencieusement à la fusion de sa story.

**Architecture:** Les blocs D5, D9 et D10 sont déjà transcrits dans la spec :
c'est le premier commit de cette branche. Le travail restant est du mécanisme,
et il se répartit entre les deux skills que ces blocs visent. D9 vise
`Story > Delivering a story` : son pendant est l'étape 7 de
`writing-a-user-story`, la revue de livraison, seul endroit où un arbitrage
ouvert peut encore être tranché. D5 vise `Batch > Closing a batch` : son pendant
est le devoir 3 de `closing-a-batch`, qui apprend à lire une seconde section du
document de story. **D10 n'appelle aucun travail de skill** : il retire de la
spec une énumération d'écrivains que chaque skill porte déjà chez elle —
`adopting-a-module` crée le register, `closing-a-batch` consolide,
`using-batches` règle (d) écrit directement — et aucune skill ne reproduit cette
énumération. La tâche 2 le vérifie plutôt que de le supposer.

L'ordre des tâches suit celui des deux moitiés de la destination : le refus à la
livraison d'abord, puisque c'est lui qui garantit qu'un arbitrage ouvert
parvenant à la clôture porte sa catégorie ; la lecture par la clôture ensuite.

**Tech Stack:** Markdown (skills du plugin), bash (suite de tests maison,
`tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/08-ce-que-la-cloture-laisse-passer/README.md
**Sections:** Batch > Closing a batch, Story > Delivering a story, Module > The gaps register
**Blocks:** D5, D9, D10

## Global Constraints

### Les contraintes du lot

Section `Constraints` du lot 08, recopiée mot pour mot :

- **Ordre requis.** D5, D8 et D9 emploient le terme que D2 pose au glossaire : ils
  sont transcrits dans la même story que D2, ou après elle. D5 emploie en outre le
  classement que D8 fait écrire dans le `Rulings log` : il ne précède pas D8. D1 et
  D10 n'imposent aucun ordre.
- **Deux constats faits en concevant ce lot partent en `Observed drift`**, et la
  clôture les versera au gaps register. Tous deux sont antérieurs à ce lot, hors de
  son périmètre, et ne sont pas à résorber ici.

  **Les deux totalités de `Batch`** — « le spec delta est **le texte exact que ce
  lot écrit dans les specs**, en blocs » et « la revue d'ouverture […] **c'est là
  que l'humain lit ce que diront les specs** » — que les propres règles de la spec
  contredisent : l'étape 3 de `Delivering a story` fait écrire la mention d'un flag
  par la story sans qu'aucun bloc la porte, la story de démontage retire de la spec
  ce que le lot y avait ajouté avec `Blocks: none`, et la levée d'un flag à portée
  de lot n'exige pas davantage de bloc. Le code fait ce que ces règles disent ; ce
  sont les deux totalités qui ont tort.

  **L'énumération de `Blocks: none`** dans `Story > The user story document` cite la
  story de lot correctif et la story de démontage, et omet la story de levée d'un
  flag à portée de lot, qui n'en transcrit pas davantage.

- **Consigner avec eux que leur canal n'a pas de définition qui les couvre.**
  `The model` définit la dérive comme une divergence entre la spec de `main` et son
  code ; ces deux constats sont des contradictions entre règles d'une même spec.
  Ils partent tout de même en `Observed drift`, faute d'autre chemin et parce que le
  précédent existe sur `main` — la story `05-us-1-le-domicile-d-une-regle` y a versé
  un constat de même nature, classé en *gap* à la clôture. Que cette section serve à
  plus que ce que sa définition dit est un constat de plus, qu'aucun lot ne tient.

**La deuxième et la troisième contrainte sont déjà honorées, et ailleurs.** La
story `08-us-1-l-arbitrage-ouvert` porte ces deux constats dans son
`Observed drift`, avec la réserve qu'énonce la troisième. La clôture ne lit que
les sections `Observed drift` des stories : les réinscrire ici lui donnerait des
doublons à consolider. **Aucune tâche de ce plan ne les recopie**, et la section
`Observed drift` de ce document ne les accueille pas.

La contrainte d'ordre, elle, est satisfaite par construction : D2 et D8 sont sur
`main`, fusionnés par `08-us-1`, avant que cette branche existe.

### Le gel du fichier de spec

> Between the transcription commit and the opening of the pull request, no task
> modifies the spec file. A story that discovers the spec must change stops.

`docs/specs/supercharlouze.md` a reçu D5, D9 et D10 au premier commit de cette
branche. Aucune tâche de ce plan n'y touche. Le gel est levé à l'ouverture de la
pull request, où les demandes de revue sont des décisions humaines, y compris sur
la formulation de la modification de spec.

### La règle d'autorité

Quand le lot et la spec se contredisent, **la spec gagne — sans exception et sans
délibération.** Implémenter ce que dit la spec, consigner un `Ruling:`, et
continuer. **Corriger une spec en cours de lot est un acte humain, jamais un acte
d'agent.**

---

### Task 1: Le refus à la livraison dans `writing-a-user-story`

L'étape 7 de `writing-a-user-story` est la revue de livraison : le dernier
endroit où un arbitrage ouvert peut encore être tranché, parce qu'à la clôture la
story est fusionnée et sa branche supprimée. C'est donc là que s'écrit le refus,
et nulle part ailleurs. L'étape 6, qui fait recopier les arbitrages, ne porte rien
de plus : la forme `Open ruling:` et sa catégorie sont déjà écrites à l'étape 4,
là où le Rulings log est défini.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` — insérer deux paragraphes dans
  `## Step 7 — Answer the Review`, juste après le paragraphe « The story is
  delivered when its pull request is merged. There is nothing to tick and nothing
  to reconcile: its state *is* the state of its pull request. » et avant
  `**Ending the review.**` ; puis ajouter une ligne au tableau `## Red Flags`
- Test: `tests/test-skill-content.sh` — deux assertions dans le bloc
  `writing-a-user-story`, à placer juste après la ligne
  `require writing-a-user-story "answers review feedback"             "review feedback"`

**Interfaces:**
- Consumes: la chaîne littérale `` An open ruling is written `Open ruling:` ``,
  déjà dans `skills/writing-a-user-story/SKILL.md` à l'étape 4, livrée par
  `08-us-1`. Le texte de cette tâche s'appuie sur ce vocabulaire sans le
  redéfinir.
- Produces: les chaînes littérales
  `A story does not merge leaving an open ruling without a destination` et
  `do not announce the pull request ready while an open ruling without a destination stands`
  dans `skills/writing-a-user-story/SKILL.md`. La tâche 2 ne les consomme pas :
  les deux skills se répondent par la spec, pas par citation.

**Contexte pour l'implémenteur.** `tests/test-skill-content.sh` compare des
chaînes littérales au corps d'un SKILL.md aplati : `body_flat` prend tout ce qui
suit le second `---` du frontmatter, remplace les retours à la ligne par des
espaces et écrase les suites d'espaces. Une aiguille traverse donc un retour à la
ligne sans rien de spécial, mais elle ne doit contenir aucune suite de deux
espaces. La forme d'une assertion est `require <skill> "<label>" "<aiguille>"`.

`skills/writing-a-user-story/SKILL.md` **enroule sa prose autour de 76 colonnes** :
le texte proposé ci-dessous est déjà à cette largeur, le coller tel quel.

- [ ] **Step 1: Écrire les deux assertions qui échouent**

Dans `tests/test-skill-content.sh`, juste après la ligne
`require writing-a-user-story "answers review feedback"             "review feedback"` :

```bash
require writing-a-user-story "an open ruling needs a destination"  "A story does not merge leaving an open ruling without a destination"
require writing-a-user-story "the review is the last place to act" "do not announce the pull request ready while an open ruling without a destination stands"
```

- [ ] **Step 2: Les faire échouer**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur `writing-a-user-story: an open ruling needs a destination` et
sur `writing-a-user-story: the review is the last place to act`. Tout le reste
passe.

- [ ] **Step 3: Écrire le refus dans l'étape 7**

Dans `skills/writing-a-user-story/SKILL.md`, insérer entre le paragraphe « The
story is delivered when its pull request is merged… » et `**Ending the review.**` :

```markdown
**A story does not merge leaving an open ruling without a destination.** Read the
`Rulings log` at the review and take every `Open ruling:` line it carries. One
that is a violation or a gap already has its destination: the gaps register, where
`supercharlouze:closing-a-batch` files it alongside the `Observed drift` sections.
Every other one is settled here, before the merge, and the `Rulings log` records
what was settled.

The review is the last place where an open ruling can still be acted on. By
closing, the story is merged and its branch is gone: closing can note that a
ruling was never taken up, it can no longer take it up. So do not announce the
pull request ready while an open ruling without a destination stands — your human
partner has the rulings in front of them here, and nowhere later.
```

- [ ] **Step 4: Ajouter la ligne au tableau `## Red Flags`**

Dans le même fichier, juste après la ligne
`| "This drift is small, I'll just add it to the gaps register" | …` :

```markdown
| "Every ruling is recorded, the log is done" | An open ruling also needs a destination. A violation or a gap goes to the register through closing; anything else is settled at the review, before the merge. |
```

- [ ] **Step 5: Faire passer les tests**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh
```

Message (sujet en français, corps expliquant pourquoi la revue et pas la clôture) :

```
feat: un arbitrage ouvert ne franchit pas la fusion sans destination
```

---

### Task 2: La clôture apprend où lire dans `closing-a-batch`

Le devoir 3 de `closing-a-batch` ne lisait que la section `Observed drift` des
documents de story. Il lit désormais aussi leur `Rulings log`, dont les
arbitrages ouverts classés en violation ou en gap lui reviennent. Ce qui change
n'est pas ce qu'il écrit — le tri entre **Violations** et **Gaps** est le même —
mais d'où il tire ce qu'il écrit ; le titre du devoir, la précondition qui fait
lire les documents et la description du frontmatter le disent tous trois, et
doivent suivre ensemble sous peine de se contredire.

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md` — la `description` du frontmatter, la
  puce de `## Preconditions` qui commence par `**Read the batch document`, la
  phrase de `## The Six Duties` qui commence par `The five others all write:`, le
  titre et le premier paragraphe du devoir `### 3. Consolidate observed drift`, et
  une ligne ajoutée au tableau `## Red Flags`
- Test: `tests/test-skill-content.sh` — deux assertions dans le bloc
  `closing-a-batch`, à placer juste après la ligne
  `require closing-a-batch "consolidates Observed drift"            "Observed drift"`

**Interfaces:**
- Consumes: rien de la tâche 1. Les deux skills se répondent par la spec.
- Produces: les chaînes littérales `Two sections carry it` et
  `the ones classified as a violation or a gap are yours` dans
  `skills/closing-a-batch/SKILL.md`. Aucune tâche ultérieure ne les consomme :
  c'est la dernière tâche de cette story.

**Contexte pour l'implémenteur.** Même mécanique de test qu'à la tâche 1. Trois
assertions existantes portent sur le texte que cette tâche réécrit et **doivent
continuer à passer** : `"Observed drift"`, `"whatever a story reported as"` et
`"one line per batch"`. Les deux premières visent le devoir 3 ; le texte proposé
ci-dessous les conserve mot pour mot. Ne pas les modifier.

Contrairement à `writing-a-user-story`, `skills/closing-a-batch/SKILL.md`
**écrit chaque paragraphe sur une seule ligne**, sans enroulement. Les
paragraphes proposés ci-dessous sont dans cette forme : les coller tels quels,
sans les ré-enrouler.

- [ ] **Step 1: Écrire les deux assertions qui échouent**

Dans `tests/test-skill-content.sh`, juste après la ligne
`require closing-a-batch "consolidates Observed drift"            "Observed drift"` :

```bash
require closing-a-batch "reads both sections of a story"         "Two sections carry it"
require closing-a-batch "consolidates the open rulings too"      "the ones classified as a violation or a gap are yours"
```

- [ ] **Step 2: Les faire échouer**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur `closing-a-batch: reads both sections of a story` et sur
`closing-a-batch: consolidates the open rulings too`. Tout le reste passe.

- [ ] **Step 3: Réécrire le titre et le premier paragraphe du devoir 3**

Dans `skills/closing-a-batch/SKILL.md`, remplacer le titre
`### 3. Consolidate observed drift` par :

```markdown
### 3. Consolidate what the story documents left
```

et remplacer le paragraphe qui le suit — « Collect the **Observed drift**
section of every story document… and it is not the only source the register
has. » — par :

```markdown
Collect from every story document in the batch what it left for you, and write it into the gaps register of the module concerned, `docs/specs/<module>.gaps.md`. **Two sections carry it.** The **Observed drift** section holds what the story saw outside its own scope. The **Rulings log** holds its `Open ruling:` lines, each of which names the gaps register category that takes it — the ones classified as a violation or a gap are yours, and the rest were settled at the delivery review, where an open ruling can still be acted on. From either section, whatever a story reported as code contradicting the spec goes under **Violations**, whatever it reported as behaviour no spec describes goes under **Gaps**. A story finds its gaps in the code it went through; those are this duty's sources, and they are not the only sources the register has.

**An open ruling that names no category should not reach you.** A story does not merge leaving one without a destination — the delivery review settles those, and it is the last moment that can: here the story is merged and its branch is gone, so you can note that a ruling was never taken up and no longer take it up. If you find one, report it with the rest of your findings and let your human partner rule; do not classify it yourself.
```

- [ ] **Step 4: Faire suivre la précondition, la phrase du préambule et la description**

Toujours dans `skills/closing-a-batch/SKILL.md`, trois endroits nomment ce que le
devoir 3 consolide et deviendraient faux :

1. Dans `## Preconditions`, la puce `**Read the batch document …**` : remplacer
   « The story documents carry the drift you are about to consolidate; » par
   « The story documents carry what you are about to consolidate — the drift they
   observed, and the open rulings their `Rulings log` leaves; »
2. Dans `## The Six Duties`, remplacer « consolidated drift and recorded
   shortfalls into the gaps registers » par « consolidated findings and recorded
   shortfalls into the gaps registers »
3. Dans le frontmatter, remplacer `consolidates observed drift` par
   `consolidates what the story documents left`, le reste de la `description`
   inchangé

- [ ] **Step 5: Ajouter la ligne au tableau `## Red Flags`**

Après la dernière ligne du tableau
(`| "No story reported drift, so there is nothing to consolidate" | …`) :

```markdown
| "The Rulings log is the delivery review's business, not mine" | Its open rulings classified as a violation or a gap are yours to consolidate. The review settled the rest. |
```

- [ ] **Step 6: Vérifier que D10 n'appelle rien**

D10 retire de la spec l'énumération des écrivains du gaps register. Aucune skill
ne doit reproduire cette énumération : chacune dit chez elle qu'elle écrit.

Run: `grep -rn "gaps register" skills/ | grep -i "adoption pull request\|only the closing"`
Expected: aucune sortie. Ce qui reste — `adopting-a-module` qui produit le
register, la phrase du devoir 3 « Stories deliberately do not write into the
register », `using-batches` règle (d) — est chez son écrivain, et reste tel quel.
Si la commande sort quelque chose, ne pas le supprimer d'office : le signaler.

- [ ] **Step 7: Faire passer toute la suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`, avec en particulier
`closing-a-batch: consolidates Observed drift`,
`closing-a-batch: sorts story findings, defines nothing` et
`closing-a-batch: one changelog line per batch` toujours au vert.

- [ ] **Step 8: Commit**

```bash
git add skills/closing-a-batch/SKILL.md tests/test-skill-content.sh
```

Message (sujet en français) :

```
feat: la clôture lit le Rulings log autant que l'Observed drift
```

## Rulings log

## Observed drift
