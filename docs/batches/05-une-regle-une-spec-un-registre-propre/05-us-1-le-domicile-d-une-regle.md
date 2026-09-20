# Le domicile d'une règle — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Donner un domicile unique à toute règle — une seule spec — et faire de
la règle qui semble en concerner plusieurs un signal de découpage à revoir, que
l'agent remonte à l'humain au lieu de la recopier ou de lui inventer un toit
commun.

**Architecture:** Le bloc D1 est déjà transcrit dans la section `Module` de la
spec : c'est le premier commit de cette branche. Le travail restant porte cette
norme dans les quatre skills où l'on écrit du texte normatif — `using-batches`
qui énonce ce dont une spec parle, `adopting-a-module` qui écrit une spec,
`writing-a-batch` qui écrit un spec delta, `writing-a-user-story` qui le
transcrit — puis la verrouille. Une **seule phrase** est commune aux quatre,
`A rule belongs to exactly one spec.`, et chaque skill dit ensuite ce qui la
concerne à son propre moment : ce que l'agent d'adoption a sous les yeux n'est
pas ce que voit celui qui transcrit un bloc. La garde finale est un `shared` de
`test-skill-contracts.sh` sur la phrase commune — une assertion unique sur les
quatre fichiers, la seule forme qui rougit quand un bout dérive, là où quatre
assertions séparées resteraient vertes chacune de son côté.

**Tech Stack:** Markdown (skills, spec, document de lot), bash (`tests/*.sh`,
assertions par `require` dans `test-skill-content.sh` et par `shared` dans
`test-skill-contracts.sh`, sur le corps aplati des SKILL.md).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/05-une-regle-une-spec-un-registre-propre/README.md
**Sections:** Module
**Blocks:** D1

## Global Constraints

Les contraintes du lot, recopiées mot pour mot depuis sa section `Constraints` :

- **Ordre requis.** D3, D4 et D7 visent la même section, `The gaps register` :
  ils sont transcrits dans cet ordre, ou dans la même story. Les autres blocs
  n'imposent aucun ordre.
- **Le gaps register du plugin est nettoyé de ses entrées barrées**, dans la même
  pull request que D3 et D4. Ce que le barré portait en commentaire — résorbée,
  sans objet, fausse — disparaît avec lui ; la pull request dit en une phrase ce
  qu'elle retire et pourquoi. Les réservations `reserved by batch-NN` d'entrées
  non barrées restent telles quelles.
- **L'entrée vivante *Concurrency detection* est reformulée** par cette même pull
  request, et seulement sur ce point : son texte cite « il barre une entrée du
  gaps register », geste que le lot supprime. Son fond ne change pas.
- **Les deux formulations jumelles restent identiques.** La phrase sur l'entrée
  qui « voyage avec le code et meurt avec la branche » vit en double, dans
  `writing-a-batch` et dans `writing-a-user-story`, et rien ne les verrouille
  ensemble : la story qui corrige l'une corrige l'autre.
- **Chaque story met à jour les skills qui appliquent ses blocs**, dans la même
  pull request que sa transcription : `using-batches`, `adopting-a-module`,
  `writing-a-batch`, `writing-a-user-story` et `closing-a-batch` selon les blocs
  qu'elle prend. Une skill qui continuerait de faire barrer une entrée après la
  fusion de D3 est une dérive.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`, dans
  la même pull request qu'elle.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**
- **Aucun renvoi numéroté.** Un renvoi nomme la section qu'il vise ; il ne la
  compte pas.
- **La boucle du `Scope` est consignée.** La story qui transcrit D1 l'écrit sous
  `Observed drift` : ce que le test éjecte et qui n'est le gap d'aucun module
  n'a pas de sortie. La clôture l'inscrira au gaps register.
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit
  la spec, la constatation part sous `Observed drift` dans le document de story.
- **Le lot 04 est ouvert en parallèle**, et ses blocs restants visent d'autres
  sections que celles de ce lot. Une story de ce lot qui trouverait un passage
  cité déplacé par une story de 04 applique la règle ordinaire : elle ajuste le
  bloc à ce que porte `main`, sans en changer le sens, et le nomme dans sa pull
  request.
- **Hors périmètre** : où vit une idée qui émerge hors du lot en cours,
  l'historique d'une story et le moment du rebase, les stories en parallèle, les
  stories préparées puis lancées en bloc, la conduite à tenir en écrivant du code
  sous flag, Conventional Commits, l'identité GitHub de l'agent, et la refonte du
  `README.md`.
- **Une seule entrée du gaps register est résorbée** : *The gaps register* — « le
  registre n'a pas de vocabulaire pour retirée parce que fausse » —, réservée par
  ce lot et résorbée par D3. Le reste de ce que le lot fait au fichier est du
  ménage, énoncé plus haut : la suppression des entrées barrées et la
  reformulation de l'entrée *Concurrency detection*. Aucune autre entrée n'est
  résorbée, ni ajoutée.

Et les deux règles que cette story ajoute pour elle-même :

**Le gel du fichier de spec.** Entre le commit de transcription et l'ouverture de
la pull request, aucune tâche ne modifie `docs/specs/supercharlouze.md`. Une
tâche qui découvre que la spec doit changer s'arrête. Le bloc D1 y est déjà
transcrit — c'est le premier commit de la branche — et aucune tâche de ce plan
n'a de raison d'y revenir.

**La règle d'autorité.** Quand le lot et la spec se contredisent, la spec gagne,
sans exception et sans délibération : implémente ce que dit la spec, consigne un
`Ruling:`, et continue. Corriger une spec est un acte humain, jamais un acte
d'agent.

---

## File Structure

Aucun fichier n'est créé. Cinq fichiers sont modifiés :

- `skills/using-batches/SKILL.md` — énonce la norme là où il dit ce dont une spec
  parle, à côté de l'emprunt réduit que D1 met explicitement hors de cause.
- `skills/adopting-a-module/SKILL.md` — deux endroits : l'étape qui délimite le
  module, dont une phrase devient fausse, et l'étape qui écrit la spec.
- `skills/writing-a-batch/SKILL.md` — la section `Spec delta`, seul endroit du
  flux où une même règle peut se retrouver écrite vers deux specs.
- `skills/writing-a-user-story/SKILL.md` — l'étape de transcription, où le cas se
  présente sous une forme que la règle d'autorité ne sait pas trancher.
- `tests/test-skill-content.sh` — une assertion `require` par skill, sur ce que
  cette skill dit de propre à son moment.
- `tests/test-skill-contracts.sh` — une assertion `shared` sur la phrase commune
  aux quatre skills.

Les aiguilles (`needle`) sont comparées par `case` sur le corps aplati du
`SKILL.md`, donc en **glob** : aucune ne contient `[`, `]`, `*` ou `?`, et aucune
ne contient deux espaces consécutifs, que `tr -s ' '` écraserait.

---

### Task 1: `using-batches` énonce la norme

**Files:**
- Modify: `skills/using-batches/SKILL.md` (section `What a Spec Says`, après le
  paragraphe `A module redefines what it borrows`; et la table `Red Flags`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: rien.
- Produces: la phrase commune `A rule belongs to exactly one spec.`, mot pour mot,
  que les tâches 2, 3 et 4 reprennent à l'identique et que la tâche 5 verrouille.

- [ ] **Step 1: Write the failing test**

Dans `tests/test-skill-content.sh`, dans le bloc `--- using-batches ---`, ajouter
à la suite des `require using-batches` existants :

```bash
require using-batches "a rule belongs to exactly one spec"  "A rule belongs to exactly one spec."
require using-batches "a shared rule signals the breakdown" "it is a module breakdown asking to be revisited"
require using-batches "no spec above the specs"             "There is no spec above the specs"
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur les trois nouvelles lignes —
`[FAIL] using-batches: a rule belongs to exactly one spec` et les deux suivantes.

- [ ] **Step 3: Write the prose**

Dans `skills/using-batches/SKILL.md`, section `## What a Spec Says`, insérer
**juste après** le paragraphe qui commence par `**A module redefines what it
borrows.**` et **avant** le paragraphe `**Scope.**` :

```markdown
**A rule belongs to exactly one spec.** A rule that would constrain behaviour
observable at the boundary of more than one module is not a rule looking for a
home — it is a module breakdown asking to be revisited, and a breakdown is a
human decision. Stop and put the case to your human partner, rather than copying
the rule from one spec into another or giving it a home above them both. The
reduced borrowing of a term — a term a neighbouring module owns, redefined here
and reduced to what this module uses — is not concerned: it redefines a term, it
does not share a rule.

There is no spec above the specs, and that is the point. A rule housed outside
the module specs — in a CLAUDE.md, in an architecture note — sits beyond
everything that makes a spec binding: the review held against it, the drift rule,
the gaps register, the changelog. It would read as a norm and be none.
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: PASS sur les trois lignes, et aucune régression ailleurs.

- [ ] **Step 5: Add the Red Flags row**

Dans la table `## Red Flags` de `skills/using-batches/SKILL.md`, ajouter une
ligne :

```markdown
| "This rule holds for every module, so it lives above them all" | There is no spec above the specs. A rule belongs to exactly one spec; a rule that seems to belong to several signals a module breakdown to revisit, and that is your human partner's decision. |
```

- [ ] **Step 6: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 7: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-skill-content.sh
git commit -m "feat: une règle appartient à une seule spec, et il n'y a pas de spec au-dessus des specs"
```

---

### Task 2: `adopting-a-module` s'arrête devant une règle qui déborde

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md` (étape `### 1. Delimit the module`,
  étape `### 4. Write the spec from those documents only`, table `Red Flags`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la phrase commune produite par la tâche 1, reprise mot pour mot.
- Produces: rien que les tâches suivantes lisent.

- [ ] **Step 1: Write the failing test**

Dans `tests/test-skill-content.sh`, dans le bloc `--- adopting-a-module ---`,
ajouter à la suite des `require adopting-a-module` existants :

```bash
require adopting-a-module "a rule belongs to exactly one spec" "A rule belongs to exactly one spec."
require adopting-a-module "a spilling rule questions the breakdown" "the breakdown is what is in question"
require adopting-a-module "names the one late signal on a boundary" "One late signal exists, and only one"
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur les trois nouvelles lignes.

- [ ] **Step 3: Amend the sentence that D1 makes false**

Dans `### 1. Delimit the module`, la phrase actuelle affirme que rien plus loin
dans le flux ne rattrape une frontière fausse. Ce n'est plus vrai : D1 est
exactement ce rattrapage. Remplacer

```markdown
Prefer one coarse module to several small ones; how many a project needs depends
on the size of the product, not on a fixed count. A wrong boundary contaminates
the spec, the gaps register, and every batch that follows, and nothing later in
the flow will catch it.
```

par

```markdown
Prefer one coarse module to several small ones; how many a project needs depends
on the size of the product, not on a fixed count. A wrong boundary contaminates
the spec, the gaps register, and every batch that follows. One late signal
exists, and only one: **a rule belongs to exactly one spec**, so a rule that
later turns out to constrain behaviour observable at the boundary of more than
one module sends the breakdown back to your human partner. Do not lean on it —
it fires batches later, and only for the boundaries a rule happens to straddle.
```

- [ ] **Step 4: Write the prose in step 4**

Dans `### 4. Write the spec from those documents only`, insérer, à la suite du
paragraphe qui exige que chaque phrase écrite passe le test de l'autre
implémentation :

```markdown
**A rule belongs to exactly one spec.** If a rule you are about to write would
constrain behaviour observable at the boundary of more than one module, stop
before writing it: the breakdown is what is in question, not the wording, and a
breakdown is your human partner's decision. Do not write it into both specs, and
do not give it a home above them. You are adopting one module, so the second
module may not even have a spec yet — that changes nothing: the signal is the
rule's reach, not what already exists next door.
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: PASS sur les trois lignes, et aucune régression — en particulier
`adopting-a-module: the human delimits the module`, dont l'aiguille
`You never delimit one yourself` vit dans le paragraphe voisin de celui que le
Step 3 réécrit.

- [ ] **Step 6: Add the Red Flags row**

Dans la table `## Red Flags` de `skills/adopting-a-module/SKILL.md`, ajouter :

```markdown
| "This rule concerns the neighbouring module too, I'll write it in both specs" | A rule belongs to exactly one spec. A rule that reaches past one boundary signals the breakdown, and the breakdown is your human partner's decision. Stop. |
```

- [ ] **Step 7: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 8: Commit**

```bash
git add skills/adopting-a-module/SKILL.md tests/test-skill-content.sh
git commit -m "feat: l'adoption s'arrête devant une règle qui déborde d'un module"
```

---

### Task 3: `writing-a-batch` refuse un delta qui écrit la même règle deux fois

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (section `Spec delta`, après le
  paragraphe `No block is attached to a story.`; table `Red Flags`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la phrase commune produite par la tâche 1, reprise mot pour mot.
- Produces: rien que les tâches suivantes lisent.

- [ ] **Step 1: Write the failing test**

Dans `tests/test-skill-content.sh`, dans le bloc `--- writing-a-batch ---`,
ajouter à la suite des `require writing-a-batch` existants :

```bash
require writing-a-batch "a rule belongs to exactly one spec" "A rule belongs to exactly one spec."
require writing-a-batch "twin blocks are not a delta"        "two blocks writing the same rule into two specs"
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur les deux nouvelles lignes.

- [ ] **Step 3: Write the prose**

Dans `skills/writing-a-batch/SKILL.md`, section `## Spec delta`, insérer **juste
après** le paragraphe qui commence par `**No block is attached to a story.**` :

```markdown
**A rule belongs to exactly one spec.** A batch may cut across modules, so its
delta may well carry blocks aimed at several specs — that is ordinary. What is
not: two blocks writing the same rule into two specs. That is not a delta with a
duplicate in it, it is a module breakdown asking to be revisited, and this is the
one place in the flow where it becomes visible, because this is the one document
that faces several specs at once. Stop and put it to your human partner before
opening the batch. No wording of the delta settles it, and the opening gate is
not where a breakdown gets decided in passing.
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: PASS sur les deux lignes, et aucune régression.

- [ ] **Step 5: Add the Red Flags row**

Dans la table `## Red Flags` de `skills/writing-a-batch/SKILL.md`, ajouter :

```markdown
| "The rule holds for both modules, so the delta carries it twice" | A rule belongs to exactly one spec. Two blocks writing the same rule into two specs signal the breakdown, not a delta. Stop and put it to your human partner. |
```

- [ ] **Step 6: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 7: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
git commit -m "feat: un spec delta n'écrit pas la même règle dans deux specs"
```

---

### Task 4: `writing-a-user-story` distingue ce cas de la règle d'autorité

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` (Step 3, sous
  `**What the spec change may contain.**`; table `Red Flags`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la phrase commune produite par la tâche 1, reprise mot pour mot.
- Produces: les quatre ends que la tâche 5 verrouille ensemble.

- [ ] **Step 1: Write the failing test**

Dans `tests/test-skill-content.sh`, dans le bloc `--- writing-a-user-story ---`,
ajouter à la suite des `require writing-a-user-story` existants :

```bash
require writing-a-user-story "a rule belongs to exactly one spec" "A rule belongs to exactly one spec."
require writing-a-user-story "no ruling houses a rule twice"      "no ruling puts a rule in two places"
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur les deux nouvelles lignes.

- [ ] **Step 3: Write the prose**

Dans `skills/writing-a-user-story/SKILL.md`, Step 3, insérer à la fin du
paragraphe `**What the spec change may contain.**` — après la phrase qui renvoie
un clause éjectée vers **Observed drift** :

```markdown
**A rule belongs to exactly one spec.** One case looks like that conflict and is
not: a block whose rule would constrain behaviour observable at the boundary of
more than one module. The authority rule cannot settle it, because no ruling puts
a rule in two places, and transcribing it into this spec alone would leave the
neighbouring module bound by something its own spec never says. Stop and put it
to your human partner: what is in question is the breakdown, and a breakdown is
their decision.
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: PASS sur les deux lignes, et aucune régression — en particulier les
aiguilles portant sur la règle d'autorité et sur **Observed drift**, dont le
paragraphe voisin n'est pas touché.

- [ ] **Step 5: Add the Red Flags row**

Dans la table `## Red Flags` de `skills/writing-a-user-story/SKILL.md`, ajouter :

```markdown
| "The block's rule spills onto the next module — the spec wins, I record a Ruling" | No ruling puts a rule in two places. A rule belongs to exactly one spec, and a rule that reaches further signals the breakdown. Stop and put it to your human partner. |
```

- [ ] **Step 6: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 7: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh
git commit -m "feat: une règle qui déborde n'est pas un conflit que la règle d'autorité tranche"
```

---

### Task 5: la phrase commune est verrouillée sur les quatre skills

**Files:**
- Modify: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la phrase `A rule belongs to exactly one spec.`, présente à
  l'identique dans les quatre `SKILL.md` après les tâches 1 à 4.
- Produces: rien.

Les quatre `require` des tâches 1 à 4 tiennent chacun un bout. Quatre assertions
séparées restent vertes chacune de son côté quand une seule des quatre phrases
dérive, et c'est précisément ce que `shared` existe pour attraper : une assertion
unique sur les quatre fichiers, rouge dès qu'un bout ne dit plus exactement la
même chose que les autres.

- [ ] **Step 1: Add the shared assertion**

Dans `tests/test-skill-contracts.sh`, ajouter, avec les autres appels à
`shared` :

```bash
# Un lieu unique par règle : la norme s'énonce dans les quatre skills qui écrivent
# du texte normatif, et elle s'y énonce mot pour mot. Une assertion unique, jamais
# une par fichier : quatre assertions séparées resteraient vertes pendant qu'un
# bout s'éloigne des trois autres.
shared "a rule belongs to exactly one spec" "A rule belongs to exactly one spec." \
    using-batches adopting-a-module writing-a-batch writing-a-user-story
```

- [ ] **Step 2: Run the test to verify it passes**

Run: `bash tests/test-skill-contracts.sh`
Expected: PASS — `a rule belongs to exactly one spec`.

- [ ] **Step 3: Verify the guard actually bites**

Une assertion qui passe du premier coup n'a rien prouvé. La faire rougir une
fois, à la main, sur un bout et un seul :

```bash
sed -i 's/A rule belongs to exactly one spec\./A rule belongs to one spec./' skills/writing-a-batch/SKILL.md
bash tests/test-skill-contracts.sh
```

Expected: FAIL — `a rule belongs to exactly one spec`, nommant
`writing-a-batch` comme le fichier manquant.

- [ ] **Step 4: Revert the mutation and confirm green**

```bash
git checkout -- skills/writing-a-batch/SKILL.md
bash tests/run-all.sh
```

Expected: `all tests passed`, et `git status` ne montre que
`tests/test-skill-contracts.sh` modifié.

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-contracts.sh
git commit -m "test: verrouille ensemble les quatre énoncés du domicile d'une règle"
```

---

## Rulings log

## Observed drift
