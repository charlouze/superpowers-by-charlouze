# La clôture amende le document de lot — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Borner sur la clôture la phrase qui dit que le document de lot ne porte
aucun état mutable, et faire dire à la skill qui le modifie qu'elle est cette
exception — pour que la spec cesse de nier ce que sa propre section
`Closing a batch` décrit.

**Architecture:** Le bloc D2 est déjà transcrit dans la section `Batch` de la
spec, et l'entrée *Batch / Closing a batch* du gaps register est barrée dans le
même commit : c'est le premier commit de cette branche. Le travail restant est
petit, et c'est normal — cette entrée disait « le code a raison », et
`writing-a-batch` porte déjà la règle **avec** son exception. Ce qui manque est
l'autre bout : `closing-a-batch` amende le document de lot et bascule son front
matter sans jamais dire qu'elle est le seul moment qui y touche. La story écrit
cette phrase, dans les mots exacts que `writing-a-batch` emploie déjà, puis
verrouille les deux bouts par une assertion unique, et interdit séparément le
retour de la dénégation sans borne que D2 vient de retirer.

**Tech Stack:** Markdown (skills, spec, document de lot), bash (`tests/*.sh`,
exécutés par `tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/04-la-spec-avant-le-code/README.md
**Sections:** Batch
**Blocks:** D2

## Global Constraints

Contraintes du lot 04, recopiées telles quelles :

- **Ordre requis.** D1 et D3, qui définissent le bloc et sa forme, sont transcrits
  **au plus tard dans la même story** que D7 et D8, qui font transcrire des blocs
  par une story : le champ `Blocks:` désigne des identifiants que seul le document
  de lot définit. Les autres blocs n'imposent aucun ordre.
- **Ce lot applique déjà ce qu'il introduit.** Ses stories déclarent `Blocks:`,
  transcrivent leurs blocs mot pour mot et nomment tout écart dans leur pull
  request, même là où les skills publiées ne le demandent pas encore. Leurs revues
  suivent D9 dès la première.
- **Chaque story met à jour les skills qui appliquent ses blocs**, dans la même
  pull request que sa transcription : `writing-a-batch`, `writing-a-user-story`,
  `closing-a-batch`, `using-batches` et `adopting-a-module` selon les blocs qu'elle
  prend. Une skill qui continuerait de parler de « spec delta comme intention »
  après la fusion de D3 est une dérive.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`, dans la
  même pull request qu'elle.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**
- **Aucun renvoi numéroté.** Un renvoi nomme la section qu'il vise ; il ne la compte
  pas.
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit la
  spec, la constatation part sous `Observed drift` dans le document de story.
- **Cinq décisions sont tranchées au gate d'ouverture** et ne se rediscutent pas
  en cours d'implémentation : **une adoption ne partage jamais le contexte de la
  conception d'un lot**, et une conception qui découvre un module non adopté
  s'arrête plutôt que d'enchaîner ; le spec delta est découpé **par section, jamais par
  story**, et le document de lot ne porte aucune liste de stories ; le texte est lu
  **dans le document de lot**, bloc par bloc, et non comme un diff de la spec ;
  l'accord de fin de revue se donne **dans la conversation**, l'approbation et la
  fusion restant des gestes humains sur GitHub ; il n'y a **pas de pause après le
  plan** — c'est le texte de la spec que l'humain revoit en amont, pas le
  découpage du travail.
- **Hors périmètre** : l'exécution de stories en parallèle, les pull requests
  empilées et le lancement de plusieurs stories sans intervention, l'endroit où
  noter une idée qui émerge hors du lot en cours, et l'identité GitHub propre à
  l'agent — qui relève de la configuration de chaque dépôt, pas du plugin.
- **Une seule entrée du gaps register est touchée** : *Batch / Closing a batch*,
  réservée par ce lot et résorbée par D2. Aucune autre.

Contraintes propres à toute story :

- **Gel du fichier de spec.** Entre le commit de transcription et l'ouverture de
  la pull request, aucune tâche ne modifie le fichier de spec. Une story qui
  découvre que la spec doit changer s'arrête.
- **Autorité.** Quand le lot et la spec se contredisent, c'est la spec qui gagne,
  sans exception et sans délibération. Implémente ce que dit la spec, consigne un
  `Ruling:`, et continue. Corriger une spec en cours de lot est un geste humain,
  jamais celui d'un agent.

---

### Task 1: `closing-a-batch` se nomme comme la borne

`writing-a-batch` énonce déjà la règle avec son exception — « nothing in the
normal course of the batch modifies it **until closing** » — et désigne
`supercharlouze:closing-a-batch` comme ce qui amende le document et bascule son
front matter. La skill désignée, elle, exécute ces deux écritures sans jamais
dire qu'elle est le seul moment qui touche au document. C'est le bout manquant du
couplage, et c'est ce qui rend la borne vérifiable.

La phrase va dans l'`## Overview`, juste après le paragraphe qui dit que la
clôture est le seul moment où le résidu laissé sur `main` est collecté : c'est là
qu'un lecteur apprend ce qu'est une clôture, et la borne appartient à cette
définition, pas à l'un des devoirs qui l'appliquent.

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md:10` (insérer un paragraphe après)
- Test: `tests/test-skill-contracts.sh:240` (insérer avant la ligne `exit`)

**Interfaces:**
- Consumes: rien (première tâche).
- Produces: la chaîne littérale
  `nothing in the normal course of the batch modifies it **until closing**`,
  désormais présente dans `writing-a-batch` **et** `closing-a-batch`. La Task 2
  s'appuie sur le fait que, dans ces deux fichiers, les deux caractères qui
  suivent `batch modifies it` sont une espace puis une étoile.

- [ ] **Step 1: Écrire la garde qui échoue**

Insérer dans `tests/test-skill-contracts.sh`, juste avant la ligne
`exit $((FAILURES > 0))` :

```bash
# The batch document's immutability has a bound, and the bound is this closure
# (spec section `Batch`). `writing-a-batch` states the rule and names closing as
# the exception; `closing-a-batch` is the end that performs it — it amends the
# document and flips its front matter. One assertion over both files: two
# `require` calls would each stay green while one end reworded the bound away
# from the other, which is the whole failure this locks out.
shared "the batch document's immutability is bounded at closing, spelled alike" \
    "nothing in the normal course of the batch modifies it **until closing**" \
    writing-a-batch closing-a-batch
```

- [ ] **Step 2: Lancer la garde et vérifier qu'elle échoue**

Run: `bash tests/test-skill-contracts.sh`

Expected: FAIL — `[FAIL] the batch document's immutability is bounded at closing, spelled alike (missing in: closing-a-batch)`.

La garde doit nommer `closing-a-batch` et **seulement** elle. Si elle nomme aussi
`writing-a-batch`, c'est que la chaîne recherchée ne correspond pas au texte déjà
en place : corriger la chaîne, pas le texte.

- [ ] **Step 3: Écrire la phrase dans `closing-a-batch`**

Dans `skills/closing-a-batch/SKILL.md`, insérer ce paragraphe entre le premier
paragraphe de l'`## Overview` (« A batch closes when… ») et celui qui commence
par « Abandoning a story is almost free » :

```markdown
It is also the only moment that touches the batch document itself. The batch document carries no mutable state: it is written once, by the opening pull request, and nothing in the normal course of the batch modifies it **until closing** — *Record blocks announced but never delivered* amends it so it no longer promises what it did not deliver, and *Set status: closed* flips its front matter. This closure is that exception and the only one: anything else that would edit the document goes through an amendment pull request of its own, which `supercharlouze:writing-a-batch` owns.
```

Les deux devoirs sont désignés **par le titre de leur section**, jamais par leur
numéro : c'est la contrainte « Aucun renvoi numéroté » des `Global Constraints`.

- [ ] **Step 4: Lancer la suite entière et vérifier qu'elle passe**

Run: `bash tests/run-all.sh`

Expected: `all tests passed`, et la ligne
`[PASS] the batch document's immutability is bounded at closing, spelled alike`.

La suite entière et pas seulement le fichier touché : `test-cross-references.sh`
et `test-suite-integrity.sh` lisent eux aussi les skills, et un paragraphe ajouté
peut les faire rougir.

- [ ] **Step 5: Commit**

```bash
git add skills/closing-a-batch/SKILL.md tests/test-skill-contracts.sh
git commit -F - <<'EOF'
docs: la clôture dit qu'elle est la borne du document de lot

`writing-a-batch` désignait déjà la clôture comme l'exception à
l'immuabilité du document de lot ; `closing-a-batch` l'exécutait sans le
dire. Les deux bouts épellent désormais la borne dans les mêmes mots, et
une assertion unique les tient ensemble.

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 2: la dénégation sans borne ne survit nulle part

La garde de la Task 1 est positive : elle reste verte sur un fichier qui
porterait **à la fois** la phrase bornée et, ailleurs, l'ancienne dénégation sans
borne — « rien dans le déroulement normal ne le modifie », point final. Or c'est
exactement cette dénégation que D2 vient de retirer de la spec, et c'est elle qui
avait produit l'entrée du gaps register. Elle a donc besoin de sa propre
interdiction, sur le modèle des `absent` que cette suite utilise déjà pour une
phrase qu'un changement de spec a supprimée.

**Files:**
- Modify: `tests/test-skill-contracts.sh` (insérer avant la ligne `exit`, après
  la garde de la Task 1)

**Interfaces:**
- Consumes: de la Task 1, le fait que `writing-a-batch` et `closing-a-batch`
  écrivent tous deux `batch modifies it **until closing**` — une espace puis une
  étoile après `it`.
- Produces: rien pour une tâche suivante (dernière tâche).

- [ ] **Step 1: Écrire la garde**

Insérer dans `tests/test-skill-contracts.sh`, juste après la garde `shared`
ajoutée par la Task 1 :

```bash
# The spec used to deny the bound outright — the batch document carries no
# mutable state and *nothing* in the normal course modifies it, full stop — while
# its own `Closing a batch` section described the closure amending it. Block D2
# retired the denial; no skill may restate it. The `shared` assertion above
# cannot catch that: it stays green on a file carrying the bounded sentence and
# an unbounded one beside it, and the two would contradict each other with the
# suite green.
#
# The regex hunts the denial left *unbounded*, never the true sentence. After
# `batch modifies it` the bounded form has a space then a star, so neither
# alternative reaches it: `( [^*])` needs a space followed by anything but a
# star, `([^ ])` needs anything but a space. Every terminated form is caught —
# "modifies it.", "modifies it, ever" — as is an unbolded "modifies it until
# closing", which is a drift from the one spelling the assertion above fixes.
absent "no skill denies that the batch document changes at closing" \
    "batch modifies it( [^*]|[^ ])" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Lancer la garde et vérifier qu'elle passe**

Run: `bash tests/test-skill-contracts.sh`

Expected: `[PASS] no skill denies that the batch document changes at closing`.

Elle passe du premier coup, et c'est attendu : aucune skill ne porte la
dénégation. Une garde verte d'emblée n'a encore rien prouvé — le Step 3 lui
demande de rougir.

- [ ] **Step 3: Prouver que la garde mord**

Ajouter temporairement, à la fin de `skills/closing-a-batch/SKILL.md`, une ligne
portant la dénégation sans borne :

```markdown
Nothing in the normal course of the batch modifies it.
```

Run: `bash tests/test-skill-contracts.sh`

Expected: FAIL — `[FAIL] no skill denies that the batch document changes at closing (present in: closing-a-batch)`.

Puis retirer la ligne et relancer : `[PASS]`. Vérifier que le fichier est bien
revenu à son état d'après-Task 1 — `git diff skills/closing-a-batch/SKILL.md`
doit être vide.

Si la garde ne rougit pas, elle ne vérifie rien : corriger l'expression
rationnelle avant d'aller plus loin.

- [ ] **Step 4: Lancer la suite entière et vérifier qu'elle passe**

Run: `bash tests/run-all.sh`

Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add tests/test-skill-contracts.sh
git commit -F - <<'EOF'
test: interdire la dénégation sans borne retirée par D2

L'assertion positive de la borne reste verte sur un fichier qui
porterait aussi l'ancienne dénégation. Elle a donc sa propre
interdiction, écrite pour rester verte sur la phrase bornée.

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

## Rulings log

## Observed drift
