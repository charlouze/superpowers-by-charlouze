# L'arbitrage ouvert — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Donner à l'arbitrage ouvert un nom au glossaire et une forme dans le
Rulings log, pour que ce qui reste à trancher se lise sans avoir à reconnaître
une catégorie dans de la prose.

**Architecture:** Les blocs D2 et D8 sont déjà transcrits dans la spec : c'est le
premier commit de cette branche. D2 pose `Arbitrage ouvert` (`open ruling`) au
glossaire de `The model`, D8 fixe sa forme dans
`Story > The user story document`, là où le Rulings log est défini. Le travail
restant est du mécanisme, et il vit en un seul endroit : l'étape 4 de
`writing-a-user-story`, qui crée les deux sections vides du document de story.
C'est le pendant, côté skill, de la section de spec que D8 vise. Les deux règles
qui font *recopier* les arbitrages — `using-batches` « Every conflict is recorded
for the human » et l'étape 6 de `writing-a-user-story` — ne portent rien de plus,
puisque la forme est écrite une fois là où le log est défini.

**Tech Stack:** Markdown (skills du plugin), bash (suite de tests maison,
`tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/08-ce-que-la-cloture-laisse-passer/README.md
**Sections:** The model, Story > The user story document
**Blocks:** D2, D8

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

### Le gel du fichier de spec

> Between the transcription commit and the opening of the pull request, no task
> modifies the spec file. A story that discovers the spec must change stops.

`docs/specs/supercharlouze.md` a reçu D2 et D8 au premier commit de cette
branche. Aucune tâche de ce plan n'y touche. Le gel est levé à l'ouverture de la
pull request, où les demandes de revue sont des décisions humaines, y compris sur
la formulation de la modification de spec.

### La règle d'autorité

Quand le lot et la spec se contredisent, **la spec gagne — sans exception et sans
délibération.** Implémenter ce que dit la spec, consigner un `Ruling:`, et
continuer. **Corriger une spec en cours de lot est un acte humain, jamais un acte
d'agent.**

---

### Task 1: La forme de l'arbitrage ouvert dans `writing-a-user-story`

L'étape 4 de `writing-a-user-story` est l'endroit où le Rulings log est défini :
c'est elle qui fait créer `## Rulings log` et `## Observed drift`, vides, en même
temps que l'en-tête. C'est donc là que s'écrit la forme d'un arbitrage ouvert, et
nulle part ailleurs — un second texte qui l'énoncerait dériverait du premier.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` — insérer un paragraphe dans
  `## Step 4 — Write the Plan`, juste après le paragraphe qui commence par
  « Write them at the same time as the header, not at Step 6. » et se termine par
  « a reviewer cannot tell the second from an omission. », donc avant
  `` `Global Constraints` — which `superpowers:writing-plans` defines… ``
- Test: `tests/test-skill-content.sh` — deux assertions dans le bloc
  `writing-a-user-story`, à placer juste après la ligne
  `require writing-a-user-story "records observed drift"             "Observed drift"`

**Interfaces:**
- Consumes: rien — c'est la première et la seule tâche de cette story.
- Produces: la chaîne littérale `` An open ruling is written `Open ruling:` `` dans
  `skills/writing-a-user-story/SKILL.md`. C'est elle que gardent les assertions, et
  c'est elle que les stories suivantes du lot 08 (D9, D5) retrouveront comme
  point d'ancrage du vocabulaire.

**Contexte pour l'implémenteur.** `tests/test-skill-content.sh` compare des
chaînes littérales au corps d'un SKILL.md aplati : `body_flat` prend tout ce qui
suit le second `---` du frontmatter, remplace les retours à la ligne par des
espaces et écrase les suites d'espaces. Une aiguille traverse donc un retour à la
ligne sans rien de spécial, mais elle ne doit contenir aucune suite de deux
espaces. La forme d'une assertion est
`require <skill> "<label>" "<aiguille>"`, et les backticks d'une aiguille
s'échappent : `"\`Open ruling:\`"`.

- [ ] **Step 1: Écrire les deux assertions qui échouent**

Dans `tests/test-skill-content.sh`, juste après la ligne
`require writing-a-user-story "records observed drift"             "Observed drift"` :

```bash
require writing-a-user-story "an open ruling has its own form"    "An open ruling is written \`Open ruling:\`"
require writing-a-user-story "an open ruling says what is left"   "ends with what is left to settle, then with the gaps register category"
```

Deux assertions et non une : la première garde le marqueur, la seconde garde ce
que la ligne doit porter. Le marqueur seul passerait sur un texte qui aurait perdu
l'exigence de nommer ce qui reste à trancher, et c'est précisément cette exigence
qui fait l'intérêt du marqueur.

- [ ] **Step 2: Lancer les tests et vérifier qu'ils échouent**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur `writing-a-user-story: an open ruling has its own form` et sur
`writing-a-user-story: an open ruling says what is left`. Toutes les autres
assertions passent.

- [ ] **Step 3: Écrire le paragraphe dans le skill**

Dans `skills/writing-a-user-story/SKILL.md`, insérer ce paragraphe après
« …a reviewer cannot tell the second from an omission. » et avant
`` `Global Constraints` — which… `` :

```markdown
**An open ruling is written `Open ruling:`** where the others are written
`Ruling:`, and its line ends with what is left to settle, then with the gaps
register category that takes it when it joins one. An open ruling is a ruling
whose decision leaves something to settle; written in the common form, nothing
says that something is still open, nor what — and whoever reads the log would
have to recognise a category in prose.
```

Le texte est en anglais : le plugin lui-même est intégralement anglais, il n'a pas
de prose métier. Respecter la largeur de ligne du fichier, qui enroule autour de
76 colonnes.

Ne rien ajouter ailleurs. L'étape 6 du même skill, qui fait recopier les
arbitrages, et la règle « Every conflict is recorded for the human » de
`using-batches` restent telles quelles : la forme est écrite une fois, là où le
log est défini, et un second énoncé de la même règle est exactement ce qui dérive.

- [ ] **Step 4: Lancer la suite entière et vérifier qu'elle passe**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`, avec les deux nouvelles assertions en `[PASS]`.

- [ ] **Step 5: Commiter**

```bash
git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh
git commit -m "feat: un arbitrage ouvert se reconnaît à sa forme"
```

Le type est `feat:` : le changement touche `skills/` et y ajoute une norme.

---

## Rulings log

## Observed drift

Les deux constats ci-dessous ont été faits en concevant le lot 08, et sa section
`Constraints` les verse ici. Tous deux sont antérieurs au lot, hors de son
périmètre, et n'étaient pas à résorber par cette story.

- **Les deux totalités de `Batch`** — « le spec delta est **le texte exact que ce
  lot écrit dans les specs**, en blocs » et « la revue d'ouverture […] **c'est là
  que l'humain lit ce que diront les specs** » — que les propres règles de la spec
  contredisent : l'étape 3 de `Delivering a story` fait écrire la mention d'un flag
  par la story sans qu'aucun bloc la porte, la story de démontage retire de la spec
  ce que le lot y avait ajouté avec `Blocks: none`, et la levée d'un flag à portée
  de lot n'exige pas davantage de bloc. Le code fait ce que ces règles disent ; ce
  sont les deux totalités qui ont tort.

- **L'énumération de `Blocks: none`** dans `Story > The user story document` cite la
  story de lot correctif et la story de démontage, et omet la story de levée d'un
  flag à portée de lot, qui n'en transcrit pas davantage.

**Leur canal n'a pas de définition qui les couvre.** `The model` définit la dérive
comme une divergence entre la spec de `main` et son code ; ces deux constats sont
des contradictions entre règles d'une même spec. Ils partent tout de même en
`Observed drift`, faute d'autre chemin et parce que le précédent existe sur
`main` — la story `05-us-1-le-domicile-d-une-regle` y a versé un constat de même
nature, classé en *gap* à la clôture. Que cette section serve à plus que ce que sa
définition dit est un constat de plus, qu'aucun lot ne tient.
