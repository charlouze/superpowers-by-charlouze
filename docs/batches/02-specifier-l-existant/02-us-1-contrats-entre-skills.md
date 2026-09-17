# 02-us-1 — Les contrats entre skills : Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Poser une garde structurelle derrière chacun des six contrats entre skills que la tranche de spec de cette story vient de rendre normatifs.

**Architecture:** La tranche de spec est **déjà livrée** — c'est le premier commit de cette branche, `2bdf5aa`. Il ne reste que les gardes. Elles sont de deux natures, et cette nature décide du fichier : une assertion qui porte sur **un** skill va dans `tests/test-skill-content.sh`, à côté de ses semblables ; une assertion qui porte sur **la même chaîne des deux côtés d'un couplage** va dans un fichier neuf, `tests/test-skill-contracts.sh`, parce qu'aucun fichier existant n'a cette responsabilité et qu'un couplage n'est un couplage que si les deux bouts l'écrivent pareil.

Ces gardes sont des **tests de caractérisation** : le comportement qu'elles décrivent existe déjà, puisque le défaut était dans la spec et non dans le code. Il n'y a donc pas de phase rouge par absence. La phase rouge se fait **par mutation** — casser volontairement l'entrée, constater que l'assertion tombe, revenir. Cette étape n'est pas une formalité : le registre de gaps déclare lui-même, dans sa section `Coverage`, qu'« un test qui passerait sans rien vérifier ne serait pas détecté par cet audit ». Une garde qu'on n'a pas vue échouer est exactement ce test-là.

**Tech Stack:** Bash, `set -euo pipefail`. `tests/run-all.sh` ramasse tout `tests/test-*.sh` automatiquement — un fichier neuf n'a rien à déclarer. Le corps d'un skill est comparé **aplati** (retours à la ligne remplacés par des espaces) pour qu'une phrase coupée par l'habillage soit tout de même trouvée.

**Spec:** docs/specs/supercharlouze.md

**Batch:** docs/batches/02-specifier-l-existant/README.md

**Sections:** The batch document, The user story document, Closing a batch

## Global Constraints

Contraintes du lot, recopiées mot pour mot depuis `docs/batches/02-specifier-l-existant/README.md` :

- **Ordre requis.** La tranche `Verification` est transcrite **en dernier**,
  après que toutes les autres tranches de ce lot ont été fusionnées sur `main`.
  Chacune des autres livre des gardes structurelles, donc chacune creuse l'écart
  entre la liste normative et ce que `tests/` vérifie réellement — l'écart même
  que cette tranche résorbe. Écrite plus tôt, sa liste serait périmée avant
  d'être fusionnée. Les autres tranches n'ont aucun ordre entre elles.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`,
  dans la même pull request qu'elle. Un contrat que rien ne vérifie redérivera
  comme il a dérivé.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**
- **Aucun renvoi numéroté.** Un renvoi nomme la section qu'il vise ; il ne la
  compte pas. Les sections de la spec vivante sont titrées et non numérotées,
  délibérément, et la garde livrée par le lot 01 le vérifie.
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit
  la spec, la constatation part sous `Observed drift` dans le document de story ;
  elle ne se règle pas par une correction discrète du code ni de la spec.
- **Deux décisions sont déjà tranchées par l'humain au gate d'ouverture** et ne
  se rediscutent pas en cours d'implémentation : la **lecture stricte** du nom
  de branche, et la **non-survie** de `docs/specs/` et `docs/batches/` à un
  clone. Les appliquer, ne pas les rouvrir.
- **Ne toucher à aucune entrée non réservée** du gaps register. Les trois
  entrées laissées disponibles ci-dessus appartiennent à d'autres lots.

**Gel du fichier de spec :**

> Entre le commit de transcription et l'ouverture de la pull request, aucune tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit changer s'arrête.

Le commit de transcription est `2bdf5aa` : il est déjà passé. `docs/specs/supercharlouze.md` est donc **gelé** pour toute la durée de ce plan. Aucune tâche ne l'ouvre en écriture.

**Règle d'autorité :**

> Quand le batch et la spec se contredisent, **la spec gagne — sans exception et sans délibération**. Implémente ce que dit la spec, inscris un `Ruling:`, et poursuis. **Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.**

**Note sur `tests/test-skill-content.sh` :** ce fichier porte des commentaires à renvoi numéroté (`(spec 6)`, `(spec 4, 4.3, 5.2, 8.3)`, etc.). Ce sont des entrées de la section *Violations* du gaps register, **non réservées par ce lot**. Ne pas les corriger, ne pas les recopier : les commentaires que tu ajoutes nomment leur section de spec au lieu de la compter.

---

### Task 1: Garder le contrat du document de lot

**Files:**
- Modify: `tests/test-skill-content.sh` — ajout dans le bloc `writing-a-batch`, après la ligne `require writing-a-batch "branch naming convention"                "batch/NN"`

**Interfaces:**
- Consumes: le helper `require <skill> <label> <needle>` déjà défini en tête du fichier ; il compare `<needle>` au corps **aplati** du `SKILL.md`.
- Produces: rien que les tâches suivantes consomment. Chaque tâche de ce plan est indépendante des autres.

- [ ] **Step 1: Ajouter les assertions**

Insérer ces lignes immédiatement après `require writing-a-batch "branch naming convention"                "batch/NN"` :

```bash

# --- writing-a-batch: the batch document contract (spec section "The batch document") ---
require writing-a-batch "template declares the Constraints section" "## Constraints"
require writing-a-batch "template declares the Live flags section"  "## Live flags"
require writing-a-batch "Constraints are copied verbatim to stories" "copies this section **verbatim** into"
require writing-a-batch "Constraints carry nothing normative"       "nothing normative"
require writing-a-batch "live-flag ruling is a fixed string"        "fixed strings, not paraphrases"
require writing-a-batch "Live flags is a snapshot for this gate"    "snapshot, taken for this gate"
```

- [ ] **Step 2: Lancer le test — il doit PASSER**

Run: `bash tests/test-skill-content.sh`
Expected: les six nouvelles lignes en `[PASS]`, aucune `[FAIL]`. C'est un test de caractérisation : `writing-a-batch` porte déjà ces phrases, la spec ne les portait pas.

- [ ] **Step 3: Prouver que la garde mord — phase rouge par mutation**

```bash
sed -i 's/^## Live flags$/## Live feature flags/' skills/writing-a-batch/SKILL.md
bash tests/test-skill-content.sh
```

Expected: `[FAIL] writing-a-batch: template declares the Live flags section`.

Si le test passe encore, l'assertion ne vérifie rien — corrige l'aiguille avant d'aller plus loin.

- [ ] **Step 4: Revenir et re-vérifier**

```bash
git checkout -- skills/writing-a-batch/SKILL.md
bash tests/test-skill-content.sh
```

Expected: tout en `[PASS]`.

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-content.sh
git commit -m "test: garder le contrat du document de lot"
```

---

### Task 2: Garder les quatre éléments de Global Constraints

**Files:**
- Modify: `tests/test-skill-content.sh` — ajout dans le bloc `writing-a-user-story`, après la ligne `require writing-a-user-story "teardown story exists"           "teardown story"`

**Interfaces:**
- Consumes: le helper `require` déjà défini en tête du fichier.
- Produces: rien.

- [ ] **Step 1: Ajouter les assertions**

Insérer ces lignes immédiatement après `require writing-a-user-story "teardown story exists"           "teardown story"` :

```bash

# --- writing-a-user-story: what Global Constraints carries (spec section "The user story document") ---
require writing-a-user-story "GC carries the batch Constraints"   "\`Constraints\` section copied verbatim"
require writing-a-user-story "GC carries the spec freeze"         "freeze of the spec file"
require writing-a-user-story "GC carries the authority rule"      "Put that rule in \`Global Constraints\` too"
require writing-a-user-story "GC carries the fifth stop condition" "carries a third thing: the fifth stop condition"
require writing-a-user-story "GC is the only channel to SDD subagents" "only channel to this skill's rules is this list"
```

Les deux aiguilles `freeze of the spec file` et `carries a third thing: the fifth stop condition` sont **coupées par un retour à la ligne** dans le fichier source. Elles ne se trouvent qu'au `grep` sur le corps aplati, ce que `require` fait déjà — ne les raccourcis pas pour « les faire marcher ».

- [ ] **Step 2: Lancer le test — il doit PASSER**

Run: `bash tests/test-skill-content.sh`
Expected: les cinq nouvelles lignes en `[PASS]`.

- [ ] **Step 3: Prouver que la garde mord — phase rouge par mutation**

```bash
sed -i 's/freeze of the spec file/gel du fichier de spec/' skills/writing-a-user-story/SKILL.md
bash tests/test-skill-content.sh
```

Expected: `[FAIL] writing-a-user-story: GC carries the spec freeze`.

- [ ] **Step 4: Revenir et re-vérifier**

```bash
git checkout -- skills/writing-a-user-story/SKILL.md
bash tests/test-skill-content.sh
```

Expected: tout en `[PASS]`.

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-content.sh
git commit -m "test: garder les quatre éléments de Global Constraints"
```

---

### Task 3: Garder les trois précisions des devoirs de clôture

**Files:**
- Modify: `tests/test-skill-content.sh` — ajout dans le bloc `closing-a-batch`, après la ligne `require closing-a-batch "branch naming convention"               "batch/NN"`

**Interfaces:**
- Consumes: le helper `require` déjà défini en tête du fichier.
- Produces: rien.

- [ ] **Step 1: Ajouter les assertions**

Insérer ces lignes immédiatement après `require closing-a-batch "branch naming convention"               "batch/NN"` :

```bash

# --- closing-a-batch: the three duty precisions (spec section "Closing a batch") ---
require closing-a-batch "duty 5 checks before the writing duties" "before duties 1 to 4"
require closing-a-batch "a refusal must cost nothing"            "makes a refusal free"
require closing-a-batch "covers flags inherited by a ruling"     "inherited by a ruling at the opening gate"
require closing-a-batch "the ruling replaces the declaration"    "the ruling replaces the declaration as the test"
require closing-a-batch "duty 4 is empty for a corrective batch" "A corrective batch has nothing to compare here"
require closing-a-batch "released entries are not re-filed"      "do not re-file the released entries as fresh gaps"
```

- [ ] **Step 2: Lancer le test — il doit PASSER**

Run: `bash tests/test-skill-content.sh`
Expected: les six nouvelles lignes en `[PASS]`.

- [ ] **Step 3: Prouver que la garde mord — phase rouge par mutation**

```bash
sed -i 's/before duties 1 to 4/after duties 1 to 4/g' skills/closing-a-batch/SKILL.md
bash tests/test-skill-content.sh
```

Expected: `[FAIL] closing-a-batch: duty 5 checks before the writing duties`.

- [ ] **Step 4: Revenir et re-vérifier**

```bash
git checkout -- skills/closing-a-batch/SKILL.md
bash tests/test-skill-content.sh
```

Expected: tout en `[PASS]`.

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-content.sh
git commit -m "test: garder les trois précisions des devoirs de clôture"
```

---

### Task 4: Garder le couplage par chaîne littérale entre deux skills

**Files:**
- Create: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: rien des tâches précédentes. `tests/run-all.sh` ramasse `tests/test-*.sh` par glob, donc le fichier neuf est exécuté sans être déclaré nulle part.
- Produces: rien.

**Pourquoi un fichier neuf.** `test-skill-content.sh` répond « ce skill dit-il X ». La question ici est différente : « ces deux skills écrivent-ils X **de la même façon** ». Une aiguille dupliquée dans deux `require` séparés ne répondrait pas — on pourrait en modifier une et laisser l'autre, et les deux assertions resteraient vertes chacune de son côté, alors que le couplage serait rompu. Il faut une assertion **unique** portant sur les deux fichiers.

- [ ] **Step 1: Écrire le fichier**

```bash
cat > tests/test-skill-contracts.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-skill-contracts"

# Body only: everything after the closing --- of the frontmatter, flattened so a
# phrase matches regardless of wrapping.
body_flat() {
    awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$1" | tr '\n' ' '
}

# A coupling between two skills only holds if both ends spell it identically.
# One assertion over several files, never one per file: two separate assertions
# would both stay green while one end drifted away from the other.
shared() {
    local label="$1" needle="$2"
    shift 2
    local missing=""
    local s f b
    for s in "$@"; do
        f="$REPO_ROOT/skills/$s/SKILL.md"
        b=""
        [ -f "$f" ] && b="$(body_flat "$f")"
        case "$b" in
            *"$needle"*) ;;
            *) missing="$missing $s" ;;
        esac
    done
    if [ -z "$missing" ]; then
        pass "$label"
    else
        fail "$label (missing in:$missing)"
    fi
}

# The human's ruling on a live flag reaches the closing check through these two
# fixed strings and nothing else: writing-a-batch writes them into the batch
# document, closing-a-batch matches the first word for word. A paraphrase on
# either end reads as an unruled flag rather than a flag ruled away, and the
# batch closes over a lifting story nobody wrote.
shared "live-flag ruling: carried by this batch" \
    "carried by this batch — lifting story owed" \
    writing-a-batch closing-a-batch

shared "live-flag ruling: not this batch" \
    "not this batch — <reason>" \
    writing-a-batch closing-a-batch

# The section that carries those rulings is named on both ends.
shared "the Live flags section is named on both ends" \
    "Live flags" \
    writing-a-batch closing-a-batch

exit $((FAILURES > 0))
EOF
```

- [ ] **Step 2: Lancer le test — il doit PASSER**

Run: `bash tests/test-skill-contracts.sh`
Expected:

```
test-skill-contracts
  [PASS] live-flag ruling: carried by this batch
  [PASS] live-flag ruling: not this batch
  [PASS] the Live flags section is named on both ends
```

- [ ] **Step 3: Prouver que la garde mord, côté `closing-a-batch`**

```bash
sed -i 's/carried by this batch — lifting story owed/carried by this batch - lifting story owed/g' skills/closing-a-batch/SKILL.md
bash tests/test-skill-contracts.sh
```

Expected: `[FAIL] live-flag ruling: carried by this batch (missing in: closing-a-batch)`.

La mutation ne change qu'un caractère — le tiret cadratin devient un tiret court. C'est exactement le genre de reformulation qu'une relecture bien intentionnée produirait, et c'est celui que la spec déclare fatal.

- [ ] **Step 4: Prouver que la garde mord aussi côté `writing-a-batch`**

```bash
git checkout -- skills/closing-a-batch/SKILL.md
sed -i 's/carried by this batch — lifting story owed/carried by this lot — lifting story owed/g' skills/writing-a-batch/SKILL.md
bash tests/test-skill-contracts.sh
```

Expected: `[FAIL] live-flag ruling: carried by this batch (missing in: writing-a-batch)`.

Les deux côtés, pas un seul : c'est toute la raison d'être de l'assertion unique.

- [ ] **Step 5: Revenir et vérifier la suite complète**

```bash
git checkout -- skills/writing-a-batch/SKILL.md
bash tests/run-all.sh
```

Expected: `all tests passed`, et `test-skill-contracts` apparaît dans la sortie.

- [ ] **Step 6: Commit**

```bash
git add tests/test-skill-contracts.sh
git commit -m "test: garder le couplage par chaîne littérale entre writing-a-batch et closing-a-batch"
```

---

## Rulings log

Trois décisions prises pendant l'exécution, recopiées du ledger SDD. Aucune ne porte sur le contenu livré : toutes trois portent sur la conduite de l'exécution.

- **Ruling:** les tâches 1 à 3 partent en **un seul dispatch** au lieu de trois — **pourquoi :** même fichier, même forme (un bloc de lignes `require` suivi d'une preuve par mutation), et la règle de groupement de `subagent-driven-development` couvre exactement ce cas ; trois sièges de revue quasi identiques sur un seul fichier n'achètent rien, et le reviewer voit le même diff dans les deux cas — **coût si c'est faux :** un seul gate de revue au lieu de trois, donc un défaut confiné à l'un des trois blocs reçoit une attention moins isolée.

- **Ruling:** l'ambiguïté d'ancrage trouvée au scan pre-flight est levée **dans le dispatch** plutôt que corrigée dans le plan — **pourquoi :** `tests/test-skill-content.sh` contient deux lignes `require <skill> "branch naming convention" … "batch/NN"` qui ne diffèrent que par le nom du skill, mais le plan cite déjà chaque ancre en entier, nom du skill compris ; le texte est donc correct et le risque est un `grep` trop large, que nommer le bloc et sa ligne dans le dispatch supprime sans toucher un plan que le reviewer va lire — **coût si c'est faux :** une insertion atterrit dans le mauvais bloc, la preuve par mutation passe quand même, et la garde se retrouve sous le mauvais intertitre où elle trompera un lecteur ultérieur.

- **Ruling:** implémenteurs et reviewers de tâche tournent sur un modèle de milieu de gamme, pas le moins cher — **pourquoi :** le plan porte le code complet, ce qui plaiderait pour le tier le moins cher, mais chaque preuve dépend d'un `sed` qui doit matcher un tiret cadratin et d'un `git checkout --` qui doit revenir proprement sous git-bash Windows ; un tour raté là coûte plus que le tier n'économise. La revue finale de branche tourne sur le modèle le plus capable, conformément à la sélection de modèle — **coût si c'est faux :** quelques centimes de dépense évitable.

## Observed drift

Un écart constaté **hors du périmètre de cette story**, trouvé en éditant la section voisine et laissé tel quel conformément à la contrainte du lot « ne rien aligner en silence ». Il n'est couvert par aucune entrée existante de `docs/specs/supercharlouze.gaps.md` ; `closing-a-batch` le consolidera au registre.

- **`The batch document` — la spec affirme sans réserve que le document de lot ne porte aucun état mutable, et sa propre section `Closing a batch` la contredit.** La phrase est : « Le document de batch ne porte aucun état mutable, et rien dans le déroulement normal ne le modifie. » Or `closing-a-batch` modifie bel et bien ce document, deux fois, et la spec le dit ailleurs elle-même : le devoir 4 amende le texte du lot « pour ne plus promettre ce qu'il n'a pas livré », et le devoir 6 bascule son front matter en `status: closed`. Le skill énonce d'ailleurs la règle **avec** l'exception que la spec nie — « nothing in the normal course of the batch modifies it **until closing** ».

  C'est donc le code qui a raison et la spec qui est incomplète. La résorption est une phrase dans `The batch document` reconnaissant la clôture comme la borne de l'immutabilité — mais c'est une décision humaine, et cette story ne l'a pas prise.

  **Circonstance aggravante, marginale :** la tranche livrée par cette story ajoute à cette même phrase une réserve pour `Live flags`, qui est correcte en elle-même. Elle a pour effet de faire lire la clause de tête comme si `Live flags` était la seule exception digne d'être nommée, alors qu'il en existe une seconde, plus ancienne et non énoncée.

  **Ce que ça coûte si personne ne le ramasse :** un lot ultérieur réécrit `writing-a-batch` depuis la seule spec — ce que la spec est faite pour permettre, puisqu'elle est l'autorité contraignante de toute revue — supprime la clause « until closing » comme non étayée, et les devoirs 4 et 6 de `closing-a-batch` deviennent un comportement que la spec interdit. C'est exactement le mode de panne que la section `Scope` de ce lot invoque comme sa raison d'être.
