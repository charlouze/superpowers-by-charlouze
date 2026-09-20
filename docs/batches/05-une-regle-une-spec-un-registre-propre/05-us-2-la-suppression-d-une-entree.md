# La suppression d'une entrée — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Retirer le barré du vocabulaire du gaps register — une entrée réglée
est supprimée du fichier et le commit qui la supprime dit pourquoi —, dire
qu'une libération ne retire que l'annotation, imposer la lecture de l'histoire
du fichier avant d'y ajouter une entrée, et nettoyer le register du plugin de
ses vingt-quatre entrées barrées.

**Architecture:** Les blocs D3, D4, D5, D6 et D7 sont déjà transcrits dans la
spec : c'est le premier commit de cette branche. Le travail restant porte cette
norme dans les cinq skills qui écrivent dans un gaps register, chacune à son
propre moment — `adopting-a-module` crée le fichier et énonce la table des
gestes, `writing-a-user-story` et `using-batches` décrivent la story corrective,
`using-batches` décrit aussi le changement borné, `closing-a-batch` ajoute et
libère, `writing-a-batch` porte la moitié d'une phrase jumelle sur l'abandon —
puis verrouille chaque couplage par une assertion unique sur plusieurs fichiers.
Le fichier du plugin est nettoyé en dernier, quand la norme qui justifie le
ménage est déjà écrite partout.

**Tech Stack:** Markdown (skills, spec, gaps register, document de lot), bash
(`tests/*.sh`, assertions par `require` dans `test-skill-content.sh`, par
`shared` et `absent` dans `test-skill-contracts.sh`, sur le corps aplati des
SKILL.md).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/05-une-regle-une-spec-un-registre-propre/README.md
**Sections:** Module > The gaps register, Story > Delivering a story, Bounded change
**Blocks:** D3, D4, D5, D6, D7

## Global Constraints

Ces contraintes font implicitement partie des exigences de **chaque** tâche.

### Le gel du fichier de spec

> Entre le commit de transcription et l'ouverture de la pull request, aucune
> tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit
> changer s'arrête.

`docs/specs/supercharlouze.md` est **déjà écrit** — les cinq blocs y sont, en
premier commit. Aucune tâche de ce plan n'y touche. Le gel est levé à
l'ouverture de la pull request, pour que la revue puisse porter sur la
formulation de la modification de spec.

Le gaps register, `docs/specs/supercharlouze.gaps.md`, **n'est pas** le fichier
de spec et n'est pas gelé : la tâche 8 l'édite, et elle seule.

### La règle d'autorité

**Quand le document de lot et la spec se contredisent, la spec l'emporte — sans
exception et sans délibération.** Implémenter ce que dit la spec, consigner un
`Ruling:`, et continuer. **Corriger une spec en cours de lot est un acte humain,
jamais celui d'un agent.**

### Les contraintes du lot, mot pour mot

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
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit
  la spec, la constatation part sous `Observed drift` dans le document de story.
- **Le lot 04 est ouvert en parallèle**, et ses blocs restants visent d'autres
  sections que celles de ce lot. Une story de ce lot qui trouverait un passage
  cité déplacé par une story de 04 applique la règle ordinaire : elle ajuste le
  bloc à ce que porte `main`, sans en changer le sens, et le nomme dans sa pull
  request.
- **Une seule entrée du gaps register est résorbée** : *The gaps register* — « le
  registre n'a pas de vocabulaire pour retirée parce que fausse » —, réservée par
  ce lot et résorbée par D3. Le reste de ce que le lot fait au fichier est du
  ménage, énoncé plus haut : la suppression des entrées barrées et la
  reformulation de l'entrée *Concurrency detection*. Aucune autre entrée n'est
  résorbée, ni ajoutée.

### La langue

Ossature anglaise, prose dans la langue du projet. **Les skills, les commandes
et les tests du plugin sont intégralement anglais** — aucune phrase française
n'entre dans un `SKILL.md` ni dans un commentaire de `tests/`. Seuls les
documents que le plugin *produit* — celui-ci, le document de lot, la spec, le
gaps register — portent de la prose française.

### Ce que les tests attendent d'une aiguille

`body_flat` aplatit le corps du `SKILL.md` — front matter retiré, sauts de ligne
en espaces, suites d'espaces réduites à une. Une aiguille ne contient donc
**jamais deux espaces consécutifs**, et peut traverser un retour à la ligne de la
prose. Les aiguilles de ce plan sont données mot pour mot : les recopier
exactement, et écrire la prose autour.

---

### Task 1: la table des gestes de `adopting-a-module` dit la suppression

`adopting-a-module` est la seule skill qui *crée* un gaps register, et sa table
des gestes est l'endroit où le plugin énonce qui agit sur une entrée et comment.
Elle fait encore du barré un geste, et ignore que l'adoption elle-même en retire
une quand elle promeut un gap. D3 change les deux.

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md` — table des gestes (autour de la
  ligne 242), gabarit du register (autour de la ligne 269), étape
  `### 6. Offer to promote the gaps`, table `Red Flags`
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Produces: la phrase commune `the commit that removes it says why`, que les
  tâches 2, 4 et 5 reprennent **mot pour mot** dans trois autres skills, et que
  la tâche 5 verrouille par un `shared` sur les quatre fichiers. Ne pas la
  reformuler ici.

- [ ] **Step 1: Write the failing assertions**

Dans `tests/test-skill-content.sh`, dans le bloc `--- adopting-a-module ---`,
ajouter :

```bash
require adopting-a-module "the register's gestures include removal"  "the commit that removes it says why"
require adopting-a-module "promoting a gap removes its entry"        "an adoption that promotes a gap into the spec"
```

- [ ] **Step 2: Run the suite to verify they fail**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL on `adopting-a-module: the register's gestures include removal`
et sur `adopting-a-module: promoting a gap removes its entry`.

- [ ] **Step 3: Rewrite the gesture table**

Remplacer les quatre lignes de la table par cinq, et le paragraphe qui la suit.
Le texte actuel est :

```markdown
| Gesture | Who | What it does to the entry |
|---|---|---|
| Reserve | `supercharlouze:writing-a-batch`, in the batch's opening pull request | appends `reserved by batch-NN` to it |
| Strike | `supercharlouze:writing-a-user-story`, as the first commit of the story that resolves it | strikes it through, atomically with the code |
| Release | `supercharlouze:closing-a-batch`, at closing | removes a `reserved by batch-NN` the batch never consumed |
| Add or strike | a bounded change, from its own pull request | belonging to no batch, it writes an entry or strikes one directly, contending only with another bounded change |

A register written as flowing paragraphs satisfies every other word of this step
and breaks every one of them: there is no item to annotate, none to strike, no
list for a bounded change to append one to — what it adds is more prose, which
the next writer cannot point at either — and nothing a corrective batch can draw
a scope from. Write entries so those gestures are mechanical.
```

Le remplacer par :

```markdown
| Gesture | Who | What it does to the entry |
|---|---|---|
| Reserve | `supercharlouze:writing-a-batch`, in the batch's opening pull request | appends `reserved by batch-NN` to it |
| Remove | `supercharlouze:writing-a-user-story`, as the first commit of the story that resolves it | deletes it from the file, atomically with the code, and the commit that removes it says why |
| Remove | you, at the step `Offer to promote the gaps`, when your human partner promotes one | deletes it from the file, in the same pull request that writes the rule it became |
| Release | `supercharlouze:closing-a-batch`, at closing | removes a `reserved by batch-NN` the batch never consumed, and leaves the entry |
| Add or remove | a bounded change, from its own pull request | belonging to no batch, it writes an entry or deletes one directly, contending only with another bounded change |

A register written as flowing paragraphs satisfies every other word of this step
and breaks every one of them: there is no item to annotate, none to remove
cleanly, no list for a bounded change to append one to — what it adds is more
prose, which the next writer cannot point at either — and nothing a corrective
batch can draw a scope from. Write entries so those gestures are mechanical.

**Nothing stays behind in this file once an entry is settled.** The register
carries what is still open, and what an entry was — and why it left — is read in
the history of the file (`git log -p docs/specs/<module>.gaps.md`).
```

- [ ] **Step 4: Fix the register template**

Le gabarit montre encore une entrée barrée. Remplacer, sous `## Violations` :

```markdown
- ~~**<spec section>** — <one a story has already resolved.>~~
```

par :

```markdown
- **<spec section>** — <a third one, still open like every entry here: a story
  that resolves an entry deletes it.>
```

- [ ] **Step 5: Make step 6 name what promotion does to the entry**

Dans `### 6. Offer to promote the gaps`, remplacer la phrase :

```markdown
What they validate goes into the spec, under the section that behaviour
constrains, and leaves the register; everything else stays there.
```

par :

```markdown
What they validate goes into the spec, under the section that behaviour
constrains, and **its entry is deleted from the register** — this is an adoption
that promotes a gap into the spec, and the commit that removes it says why.
Everything else stays there.
```

Attention à la casse et à la ponctuation : `an adoption that promotes a gap into
the spec` et `the commit that removes it says why` sont les deux aiguilles.

- [ ] **Step 6: Fix the Red Flags line**

Remplacer :

```markdown
| "Prose reads better than a list in the gaps register" | Then nothing can reserve, strike or release an entry, and the three downstream gestures break. |
```

par :

```markdown
| "Prose reads better than a list in the gaps register" | Then nothing can reserve, remove or release an entry, and the three downstream gestures break. |
```

- [ ] **Step 7: Run the suite**

Run: `bash tests/run-all.sh`
Expected: toutes les assertions passent, dont les deux nouvelles.

- [ ] **Step 8: Commit**

```bash
git add skills/adopting-a-module/SKILL.md tests/test-skill-content.sh
git commit -F- <<'EOF'
feat: le register ne garde pas ce qui est réglé, et l'adoption en retire aussi

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 2: la story corrective supprime son entrée

D5 change le premier commit d'une story corrective : il supprime l'entrée au
lieu de la barrer. Deux skills décrivent ce commit — `writing-a-user-story` qui
le prescrit et `using-batches` qui l'explique comme l'unique exception de forme
au « la modification de spec est le premier commit ». Les deux disent
aujourd'hui la même chose dans des mots différents ; les aligner mot pour mot est
ce qui rend le verrou possible.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` — paragraphe `**Corrective
  story.**` de l'étape `Step 3 — Commit the Spec Change First`
- Modify: `skills/using-batches/SKILL.md` — paragraphe `**The spec change is the
  first commit of every story branch**`
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: `the commit that removes it says why`, la phrase commune produite par
  la tâche 1. La reprendre **mot pour mot** dans `writing-a-user-story`.
- Produces: la phrase commune `deletes the gaps register entry it resolves`,
  portée par les deux fichiers de cette tâche.

- [ ] **Step 1: Write the failing assertion**

Dans `tests/test-skill-contracts.sh`, ajouter à la suite des assertions
existantes :

```bash
# A corrective story's first commit is described in two places — the skill that
# prescribes it and the one that explains why it is the single exception of form
# to "the spec change ships first". One assertion over both: two `require` calls
# would each stay green while one end drifted back to striking the entry.
shared "a corrective story's first commit deletes its entry" \
    "deletes the gaps register entry it resolves" \
    writing-a-user-story using-batches
```

- [ ] **Step 2: Run the suite to verify it fails**

Run: `bash tests/test-skill-contracts.sh`
Expected: FAIL avec
`a corrective story's first commit deletes its entry (missing in: writing-a-user-story using-batches)`.

- [ ] **Step 3: Rewrite the paragraph in `writing-a-user-story`**

Remplacer :

```markdown
**Corrective story.** The delta being empty, this first commit does not touch
the spec. It strikes the gaps register entry the story resolves, in
`docs/specs/<module>.gaps.md`. That plays the same role: fixing the scope in
the branch's history before any code exists. Striking an entry is local to a
line already written, so two stories striking different entries do not collide.
```

par :

```markdown
**Corrective story.** The delta being empty, this first commit does not touch
the spec. It deletes the gaps register entry it resolves from
`docs/specs/<module>.gaps.md`, and the commit that removes it says why. That
plays the same role: fixing the scope in the branch's history before any code
exists. Removing an entry takes out lines nobody else is writing, so two stories
removing different entries do not collide — and what the entry said, and why it
went, stay readable in the history of the file.
```

- [ ] **Step 4: Rewrite the sentence in `using-batches`**

Dans le paragraphe `**The spec change is the first commit of every story
branch**`, remplacer :

```markdown
its spec delta is empty, so its first commit strikes the gaps register entry it resolves instead, which fixes its scope in the branch's history exactly the same way.
```

par :

```markdown
its spec delta is empty, so its first commit deletes the gaps register entry it resolves instead, which fixes its scope in the branch's history exactly the same way.
```

- [ ] **Step 5: Retire the stale content assertion**

`tests/test-skill-content.sh` porte encore, autour de la ligne 141 :

```bash
require writing-a-user-story "corrective story strikes an entry"  "strikes the gaps register entry the story resolves"
```

La supprimer : le `shared` de l'étape 1 couvre la même règle sur les deux
fichiers, ce que cette assertion seule ne faisait pas.

- [ ] **Step 6: Run the suite**

Run: `bash tests/run-all.sh`
Expected: toutes les assertions passent.

- [ ] **Step 7: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md skills/using-batches/SKILL.md tests/test-skill-contracts.sh tests/test-skill-content.sh
git commit -F- <<'EOF'
feat: une story corrective supprime l'entrée qu'elle résorbe

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 3: le changement borné ajoute une entrée comme il en supprime une

D6 est la même substitution sur le quatrième écrivain du register, celui qui n'a
pas de skill à lui : le changement borné. `using-batches` est la seule skill qui
le décrit.

**Files:**
- Modify: `skills/using-batches/SKILL.md` — puce `**(d) It writes to a gaps
  register directly.**` de la section sur le changement borné
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: `the commit that removes it says why`, la phrase commune produite par
  la tâche 1. La reprendre **mot pour mot** : la tâche 5 pose un `shared` qui
  l'exige de ce fichier aussi.
- Produces: la puce `(d)` réécrite, que la tâche 4 complète. Appliquer les deux
  dans l'ordre du plan.

- [ ] **Step 1: Write the failing assertion**

Dans `tests/test-skill-content.sh`, dans le bloc `--- using-batches ---`,
ajouter :

```bash
require using-batches "a bounded change adds and removes entries"  "add an entry and delete one"
```

- [ ] **Step 2: Run the suite to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur `using-batches: a bounded change adds and removes entries`.

- [ ] **Step 3: Rewrite the bullet**

Remplacer :

```markdown
- **(d) It writes to a gaps register directly.** Belonging to no batch, it may both add an entry and strike one in `docs/specs/<module>.gaps.md`, from its own pull request, contending only with another bounded change. The batch path is stricter — stories only record what they observe, and only `supercharlouze:closing-a-batch` consolidates it — because that contention is per batch, not per pull request.
```

par :

```markdown
- **(d) It writes to a gaps register directly.** Belonging to no batch, it may both add an entry and delete one in `docs/specs/<module>.gaps.md`, from its own pull request, contending only with another bounded change. When it deletes one, the commit that removes it says why. The batch path is stricter — stories only record what they observe, and only `supercharlouze:closing-a-batch` consolidates it — because that contention is per batch, not per pull request.
```

- [ ] **Step 4: Run the suite**

Run: `bash tests/run-all.sh`
Expected: toutes les assertions passent.

- [ ] **Step 5: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-skill-content.sh
git commit -F- <<'EOF'
feat: un changement borné supprime une entrée au lieu de la barrer

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 4: on lit l'histoire du fichier avant d'y ajouter une entrée

D7 est le corollaire de la suppression : si le register ne garde plus trace de ce
qu'il a écarté, ce qui a été écarté ne se lit plus que dans l'histoire du
fichier — et celui qui ajoute doit l'avoir lue, sous peine de rouvrir une
décision que personne n'a revue. Deux écrivains ajoutent : la clôture d'un lot et
le changement borné.

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md` — devoir de consolidation des dérives
  constatées (`### 3.` dans la liste des devoirs)
- Modify: `skills/using-batches/SKILL.md` — puce `**(d) It writes to a gaps
  register directly.**`, réécrite à la tâche 3
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la puce `(d)` de `using-batches` telle que la tâche 3 l'a laissée. Si
  elle ne porte pas encore `add an entry and delete one`, la tâche 3 n'a pas été
  appliquée : s'arrêter et le dire.
- Produces: la phrase commune `Read the file's history before adding an entry`,
  portée par les deux fichiers de cette tâche.

- [ ] **Step 1: Write the failing assertion**

Dans `tests/test-skill-contracts.sh`, ajouter :

```bash
# Removal leaves no trace in the register, so what a module already rejected is
# readable only in the file's history. Both writers that add an entry — a
# batch's closing and a bounded change — owe that read. One assertion over both,
# because a rule only one of them carries is a rule the other writer never sees.
shared "both writers read the file's history before adding" \
    "Read the file's history before adding an entry" \
    closing-a-batch using-batches
```

- [ ] **Step 2: Run the suite to verify it fails**

Run: `bash tests/test-skill-contracts.sh`
Expected: FAIL avec
`both writers read the file's history before adding (missing in: closing-a-batch using-batches)`.

- [ ] **Step 3: Add the rule to `closing-a-batch`**

Dans le devoir de consolidation, après le paragraphe qui commence par
`"Out of scope for this batch" is never a reason to drop an observation.`,
ajouter :

```markdown
**Read the file's history before adding an entry** (`git log -p docs/specs/<module>.gaps.md`). An entry that once left this file left for a reason, and that reason is in the commit that removed it — resolved, promoted, moot, false, or set aside by your human partner. Re-filing an observation that was already set aside, without saying what has changed since, reopens a decision nobody has reviewed.
```

- [ ] **Step 4: Add the rule to `using-batches`**

Dans la puce `(d)` réécrite à la tâche 3, insérer la même exigence après la
phrase `When it deletes one, the commit that removes it says why.` :

```markdown
Read the file's history before adding an entry (`git log -p docs/specs/<module>.gaps.md`): what was set aside was set aside for a reason, written in the commit that removed it.
```

La puce entière se lit alors :

```markdown
- **(d) It writes to a gaps register directly.** Belonging to no batch, it may both add an entry and delete one in `docs/specs/<module>.gaps.md`, from its own pull request, contending only with another bounded change. When it deletes one, the commit that removes it says why. Read the file's history before adding an entry (`git log -p docs/specs/<module>.gaps.md`): what was set aside was set aside for a reason, written in the commit that removed it. The batch path is stricter — stories only record what they observe, and only `supercharlouze:closing-a-batch` consolidates it — because that contention is per batch, not per pull request.
```

- [ ] **Step 5: Run the suite**

Run: `bash tests/run-all.sh`
Expected: toutes les assertions passent.

- [ ] **Step 6: Commit**

```bash
git add skills/closing-a-batch/SKILL.md skills/using-batches/SKILL.md tests/test-skill-contracts.sh
git commit -F- <<'EOF'
feat: on n'ajoute pas une entrée sans savoir ce qui a déjà été écarté

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 5: libérer une réservation ne supprime pas l'entrée

D4 rend explicite ce que la libération fait et ne fait pas : l'annotation part,
l'entrée reste. Et il retire à la clôture le critère qu'elle utilisait pour
reconnaître une réservation consommée — « jamais barrée » —, qui n'a plus de
référent : une entrée consommée n'est plus dans le fichier du tout.

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md` — devoir de libération des
  réservations non consommées (`### 4.` dans la liste des devoirs)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: `the commit that removes it says why`, la phrase commune produite par
  la tâche 1 et reprise par la tâche 2 ; cette tâche est la quatrième et dernière
  skill à la porter, et c'est elle qui pose le `shared` sur les quatre.
- Produces: le `shared` à quatre fichiers. Toute tâche ultérieure qui reformule
  cette phrase dans l'une des quatre skills le fait rougir.

- [ ] **Step 1: Write the failing assertions**

Dans `tests/test-skill-content.sh`, dans le bloc `--- closing-a-batch ---`,
ajouter :

```bash
require closing-a-batch "releasing keeps the entry"  "removes the reservation annotation and leaves the entry"
```

Dans `tests/test-skill-contracts.sh`, ajouter :

```bash
# Four skills write to a gaps register, and all four owe the same duty when they
# take an entry out of it: say why in the commit, because the file keeps nothing
# once the entry is gone. One assertion over the four — four `require` calls
# would each stay green while one writer quietly dropped the duty.
shared "every writer that removes an entry says why" \
    "the commit that removes it says why" \
    adopting-a-module writing-a-user-story closing-a-batch using-batches
```

- [ ] **Step 2: Run the suite to verify they fail**

Run: `bash tests/run-all.sh`
Expected: FAIL sur `closing-a-batch: releasing keeps the entry`, et FAIL sur
`every writer that removes an entry says why (missing in: closing-a-batch)` —
`adopting-a-module`, `writing-a-user-story` et `using-batches` portent déjà la
phrase depuis les tâches 1, 2 et 3 ; `closing-a-batch` est le dernier des quatre.

- [ ] **Step 3: Rewrite the release duty in `closing-a-batch`**

Remplacer :

```markdown
For every gaps register entry this batch reserved at opening (`reserved by batch-NN`) that was never struck through, remove the reservation annotation. Those are the **unconsumed reservations** — a story abandoned, a scope revised mid-flight. Entries a story did strike stay struck: that gesture was atomic with the code that resolved them.
```

par :

```markdown
For every gaps register entry this batch reserved at opening (`reserved by batch-NN`) that is still in the file, release it. Releasing removes the reservation annotation and leaves the entry: the gap is still open, it is simply no longer claimed. Those are the **unconsumed reservations** — a story abandoned, a scope revised mid-flight. An entry a story did resolve is not there to release: the story deleted it from the file, atomically with the code that resolved it, and the commit that removes it says why.
```

Le critère a changé et c'est le point de la tâche : l'ancien texte reconnaissait
une réservation consommée à ce qu'elle était barrée, et rien n'est plus barré.
Une réservation consommée n'est plus dans le fichier du tout, donc le critère
devient la présence de l'entrée.

- [ ] **Step 4: Run the suite**

Run: `bash tests/run-all.sh`
Expected: toutes les assertions passent, dont les deux nouvelles.

- [ ] **Step 5: Commit**

```bash
git add skills/closing-a-batch/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
git commit -F- <<'EOF'
feat: libérer une réservation retire l'annotation, pas l'entrée

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 6: la phrase jumelle sur ce qui meurt avec la branche

Une phrase vit en double, dans `writing-a-batch` et dans `writing-a-user-story` :
ce qui n'a pas atteint `main` quand une story est abandonnée — la modification de
spec, ou l'entrée du gaps register — voyage avec le code et meurt avec la
branche. Les deux exemplaires disent « struck », et rien ne les tient ensemble.
Le lot exige qu'ils restent identiques : cette tâche les corrige tous les deux et
pose le verrou.

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` — paragraphe de l'Override 2 sur
  l'abandon d'une story
- Modify: `skills/writing-a-user-story/SKILL.md` — même paragraphe, section
  `Step 5 — Execute`
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: rien des tâches précédentes.
- Produces: la phrase commune
  `the spec change, or the deleted gaps-register entry, travels with the code and dies with the branch`.

- [ ] **Step 1: Write the failing assertion**

Dans `tests/test-skill-contracts.sh`, ajouter :

```bash
# The same sentence about what an abandoned story leaves behind is written in
# two skills, and it names the gesture the register now uses. One assertion over
# both: separate ones would let the two accounts of an abandonment drift apart,
# and an agent reading either would believe it had the whole picture.
shared "both accounts of an abandonment name the same residue" \
    "the spec change, or the deleted gaps-register entry, travels with the code and dies with the branch" \
    writing-a-batch writing-a-user-story
```

- [ ] **Step 2: Run the suite to verify it fails**

Run: `bash tests/test-skill-contracts.sh`
Expected: FAIL avec
`both accounts of an abandonment name the same residue (missing in: writing-a-batch writing-a-user-story)`.

- [ ] **Step 3: Fix the `writing-a-batch` copy**

Remplacer, dans le paragraphe de l'Override 2 :

```markdown
   Therefore: **close the story's pull request without merging it if one is
   already open.** Nothing has to be revoked either way, because nothing reached
   `main`: the spec change, or the struck gaps-register entry, travels with the
   code and dies with the branch.
```

par :

```markdown
   Therefore: **close the story's pull request without merging it if one is
   already open.** Nothing has to be revoked either way, because nothing reached
   `main`: the spec change, or the deleted gaps-register entry, travels with the
   code and dies with the branch.
```

- [ ] **Step 4: Fix the `writing-a-user-story` copy**

Remplacer :

```markdown
Nothing on `main` changes either way — the spec change, or the struck
gaps-register entry, travels with the code and dies with the branch.
```

par :

```markdown
Nothing on `main` changes either way — the spec change, or the deleted
gaps-register entry, travels with the code and dies with the branch.
```

- [ ] **Step 5: Run the suite**

Run: `bash tests/run-all.sh`
Expected: toutes les assertions passent.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-batch/SKILL.md skills/writing-a-user-story/SKILL.md tests/test-skill-contracts.sh
git commit -F- <<'EOF'
feat: les deux récits d'un abandon nomment le même résidu

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 7: le barré ne peut plus revenir

Les six tâches précédentes posent chacune une assertion positive sur ce que les
skills doivent dire. Aucune n'empêche une skill de porter **en plus** l'ancienne
consigne : un fichier qui dirait à la fois « supprime l'entrée » et « barre
l'entrée » les laisserait toutes vertes. C'est le rôle d'un `absent`, le miroir
du `shared` que `test-skill-contracts.sh` porte déjà.

**La garde est un jeton nu, `[Ss]truck|[Ss]trik`, et non un motif qui essaie de
viser le register.** Un motif de ce genre a été essayé et rate exactement la
ligne qui compte : la ligne de table `| Strike | ... | strikes it through |` ne
contient « entry » ni « gaps register » à portée, parce que le mot qui les porte
est l'en-tête de colonne, hors de portée de toute fenêtre raisonnable. Un jeton
nu n'a pas de trou, au prix d'une condition : le mot ne doit plus servir à rien
d'autre dans ces cinq fichiers. Il y sert encore une fois, pour un geste
différent sur une liste différente — une source écartée de l'inventaire d'une
adoption —, et l'étape 1 lui donne son propre verbe.

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md` — phrase sur l'inventaire des
  sources, autour de la ligne 123
- Modify: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: l'état des cinq skills après les tâches 1 à 6. Si l'une d'elles n'a
  pas été appliquée, cette assertion rougit en nommant le fichier fautif — ce
  qui est le comportement voulu, pas un échec de cette tâche.

- [ ] **Step 1: Give the source inventory its own verb**

Dans `skills/adopting-a-module/SKILL.md`, remplacer :

```markdown
They can add a source you missed and strike one that was never validated. The
```

par :

```markdown
They can add a source you missed and drop one that was never validated. The
```

Le geste ne change pas ; seul le mot change, pour qu'il cesse d'être l'homonyme
de celui que ce lot retire du register.

- [ ] **Step 2: Write the assertion**

Ajouter à `tests/test-skill-contracts.sh` :

```bash
# The mirror of the positive assertions above: a skill that carried both the new
# wording and the old would leave every one of them green while still telling an
# agent to strike a register entry. The needle is the bare token, because a
# pattern aimed at the register misses the one line that matters most — a table
# row naming the gesture, whose "entry" is the column header, out of reach of any
# sane window. A bare token has no holes as long as the word means nothing else
# in these five files, which is why the source inventory says "drop" instead.
absent "no skill strikes a gaps register entry" \
    "[Ss]truck|[Ss]trik" \
    adopting-a-module using-batches writing-a-batch writing-a-user-story closing-a-batch
```

- [ ] **Step 3: Run the suite to confirm it passes on the converted skills**

Run: `bash tests/test-skill-contracts.sh`
Expected: PASS sur `no skill strikes a gaps register entry`. S'il rougit, lire
les skills nommées : une des tâches 1 à 6 a laissé une occurrence derrière elle,
et c'est elle qu'il faut corriger, pas la garde.

- [ ] **Step 4: Prove the assertion actually catches a regression**

Une assertion négative qui passe du premier coup n'a rien démontré. La faire
rougir avec la forme qu'un motif plus étroit laissait passer — la ligne de
table —, puis revenir en arrière :

```bash
printf '\n| Strike | a story | strikes it through, atomically with the code |\n' >> skills/adopting-a-module/SKILL.md
bash tests/test-skill-contracts.sh
```

Expected: FAIL avec
`no skill strikes a gaps register entry (present in: adopting-a-module)`.

```bash
git checkout -- skills/adopting-a-module/SKILL.md
bash tests/test-skill-contracts.sh
```

Attention : ce `git checkout --` annule **aussi** l'étape 1, qui n'est pas encore
commitée. La refaire avant de continuer, puis vérifier :

Run: `grep -c "drop one that was never validated" skills/adopting-a-module/SKILL.md`
Expected: `1`

Run: `bash tests/test-skill-contracts.sh`
Expected: PASS.

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add tests/test-skill-contracts.sh skills/adopting-a-module/SKILL.md
git commit -F- <<'EOF'
test: aucune skill ne peut reprendre le barré par-dessus la suppression

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 8: le gaps register du plugin ne porte plus que ce qui est ouvert

La norme est écrite partout : le fichier du plugin doit s'y conformer. Il porte
vingt-quatre entrées barrées, dont plusieurs traînent en commentaire la raison de
leur sortie. L'une des entrées **vivantes** constate qu'une entrée a un jour été
barrée parce qu'elle était fausse, geste que la spec ne décrivait pas : c'est
elle, *The gaps register*, que le lot résorbe. Le reste est du ménage.

**Les comptes de cette tâche ont été repris après la fusion de la story
`04-us-5`**, qui a barré une entrée de plus — *Batch / Closing a batch*, et c'est
elle qui portait `reserved by batch-04`. Conséquence : **aucune annotation de
réservation ne survit au ménage.** Ce n'est pas une exception à la règle
« les réservations d'entrées non barrées restent », c'est cette règle appliquée à
un fichier où il n'en reste aucune : une entrée barrée est une réservation
*consommée*, et sous la norme que ce lot écrit une réservation consommée est une
entrée qui n'est plus là. La clôture du lot 04 ne trouvera donc rien à libérer,
ce qui est exact.

**Files:**
- Modify: `docs/specs/supercharlouze.gaps.md`

**Interfaces:**
- Consumes: la norme écrite aux tâches 1 à 6. Aucune dépendance de code.
- Produces: rien. C'est la dernière tâche du plan.

- [ ] **Step 1: Inventory what goes and what stays**

Run:

```bash
grep -n '^- ' docs/specs/supercharlouze.gaps.md
grep -n 'reserved by batch' docs/specs/supercharlouze.gaps.md
```

Attendu avant modification : trente-sept lignes commençant par `- `, dont cinq
sont les puces de la section `Coverage` et trente-deux sont des entrées.
Vingt-quatre entrées portent `~~`, huit n'en portent pas.

**Ce qui part :**
- les vingt-quatre entrées barrées, **avec** leur commentaire de sortie et
  **avec** leur annotation `reserved by batch-NN` lorsqu'elles en portent une —
  `batch-01`, `batch-02` et `batch-04`. Une entrée barrée est une réservation
  consommée, et la réservation part avec son entrée ;
- l'entrée vivante **The gaps register** — « le registre n'a pas de vocabulaire
  pour retirée parce que fausse » —, `reserved by batch-05`, que ce lot résorbe.

**Ce qui reste :**
- les sept autres entrées vivantes, telles quelles : deux sous `## Violations`,
  cinq sous `## Gaps` ;
- la section `Coverage` entière ;
- le paragraphe de prose qui introduit les entrées consolidées par la clôture du
  lot 02, sous `## Gaps`.

**Aucune annotation `reserved by batch-NN` ne subsiste**, et c'est correct : les
quatre qui existaient portaient toutes sur une entrée barrée ou sur l'entrée que
ce lot résorbe.

- [ ] **Step 2: Delete the struck entries**

Une entrée court de sa ligne `- ` jusqu'à la ligne qui précède la prochaine
ligne commençant par `- `, `#`, ou une ligne de prose non indentée. Supprimer
chaque entrée dont la première ligne commence par `- ~~`, entièrement —
commentaire de sortie et annotation de réservation compris — ainsi que la ligne
vide qui la suivait.

Ne supprimer **que** des entrées. Les titres `## Coverage`, `## Violations`,
`## Gaps` restent, et le paragraphe de prose sous `## Gaps` — celui qui commence
par `**Les entrées qui suivent ont été consolidées par la clôture du lot 02**` —
reste.

Vérifier après coup qu'aucune ligne n'a été emportée par erreur :

```bash
grep -c '^- ~~' docs/specs/supercharlouze.gaps.md   # attendu : 0
grep -n '^## ' docs/specs/supercharlouze.gaps.md    # attendu : les trois titres
grep -n 'consolidées par la clôture du lot 02' docs/specs/supercharlouze.gaps.md
```

- [ ] **Step 3: Delete the entry this batch resolves**

Supprimer l'entrée qui commence par :

```markdown
- **The gaps register** — le registre n'a pas de vocabulaire pour « retirée parce
```

jusqu'à sa dernière ligne, `reserved by batch-05` comprise.

- [ ] **Step 4: Reformulate the live *Concurrency detection* entry**

Cette entrée cite le geste que le lot supprime. La réécrire **sur ce seul
point**, sans toucher à son fond. Remplacer :

```markdown
  par construction : il barre une entrée du gaps register. Une story corrective
```

par :

```markdown
  par construction : il supprime une entrée du gaps register. Une story corrective
```

Vérifier qu'aucune autre phrase de l'entrée n'a bougé :
`git diff docs/specs/supercharlouze.gaps.md` ne doit montrer, pour cette entrée,
qu'une ligne remplacée.

- [ ] **Step 5: Verify the result**

Run:

```bash
grep -c '~~' docs/specs/supercharlouze.gaps.md
```

Expected: `0`.

Run:

```bash
grep -c 'reserved by batch' docs/specs/supercharlouze.gaps.md
```

Expected: `0` — les quatre réservations portaient sur une entrée barrée ou sur
l'entrée que ce lot résorbe.

Run:

```bash
grep -c '^- ' docs/specs/supercharlouze.gaps.md
```

Expected: `12` — cinq puces de `Coverage` et sept entrées vivantes.

Run:

```bash
grep -n '^## ' docs/specs/supercharlouze.gaps.md
```

Expected: `## Coverage`, `## Violations`, `## Gaps`, les trois présents.

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Read the file once, end to end**

Lire le fichier entier. Deux choses à vérifier à l'œil, qu'aucun `grep` ne dira :

1. Aucune entrée survivante ne renvoie à une entrée supprimée par une formule du
   genre « complète l'entrée ci-dessus ».
2. Le paragraphe de prose sous `## Gaps` — « Les entrées qui suivent ont été
   consolidées par la clôture du lot 02 » — dit encore quelque chose de vrai des
   entrées qui le suivent, et sa phrase finale « Les deux constats qu'un
   changement de code seul peut résoudre sont sous *Violations* » compte toujours
   juste : `## Violations` doit porter exactement deux entrées.

Si l'un des deux ne tient plus, **ne pas réécrire le paragraphe** : le lot
interdit de toucher au fichier au-delà du ménage énoncé. Consigner le constat
pour le Rulings log et continuer.

- [ ] **Step 7: Commit**

Le commit dit ce qu'il retire et pourquoi — c'est exactement ce que la spec
transcrite en premier commit exige de lui.

```bash
git add docs/specs/supercharlouze.gaps.md
git commit -F- <<'EOF'
docs: le gaps register ne porte plus que ce qui reste à régler

Suppression des vingt-quatre entrées barrées : elles étaient réglées, et ce que
leur commentaire portait — résorbée, sans objet, fausse — se lit désormais dans
l'histoire du fichier. Leurs annotations `reserved by batch-01`,
`reserved by batch-02` et `reserved by batch-04` partent avec elles : une entrée
barrée est une réservation consommée.

Suppression de l'entrée `The gaps register` : résorbée par ce lot, qui remplace
le barré par la suppression et fait dire au commit pourquoi l'entrée part.

Reformulation de l'entrée vivante `Concurrency detection` sur le seul point où
elle citait le barré ; son fond ne change pas.

Il reste sept entrées, toutes ouvertes, et aucune réservation.

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

## Rulings log

## Observed drift
