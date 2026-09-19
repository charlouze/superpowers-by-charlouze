# 03 — us-3 — Mise en conformité de la spec du plugin — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Aligner les skills, la commande d'init, le README et la garde de renvois sur la spec du plugin mise en conformité avec sa propre règle de contenu.

**Architecture:** La mise en conformité elle-même est la tranche de spec, **premier commit de cette branche** (`10fabf8`), décidée par l'humain. Elle réexprime la spec — chaque règle reste, sa justification sort, les exemples deviennent des gabarits à placeholders — et la restructure : la spec est celle d'une **extension de superpowers qui définit un flux de développement**. superpowers y entre par ses termes empruntés et par les quatre écarts du flux. L'outil qui exécute les agents, le packaging, le découpage en skills et la suite de tests en sortent, car ils relèvent de l'implémentation et du README. Les étapes sont rangées sous l'objet dont elles font avancer le cycle de vie (module, lot, story, flag), et chaque concept porte un seul terme. Cette story aligne ce qui, hors de la spec, en porte l'écho : la clause de structure et la phrase de gating dans `using-batches` (Tasks 1 et 2), les renvois vers des sections renommées ou retirées (Task 3), le README qui reprend ce que la spec a rendu à l'implémentation (Task 4), et l'exemple `gh` de la règle de contenu (Task 5). Les skills gardent leurs justifications : la règle de contenu porte sur le fichier de spec, pas sur elles.

**Tech Stack:** Markdown (skills, commande, README), bash (`tests/*.sh`, exécutées par `tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/03-le-metier-pas-le-mecanisme/README.md
**Sections:** toutes les sections de la spec sauf `Sources` et `Changelog` — la restructuration les touche toutes, y compris celles qu'elle retire (`Plugin identity and distribution`, `Git model`, `Running a batch`, `Skills`, `Routing and precedence`, `What is kept, what is rerouted`, `Declared overrides`, `The init command`, `Verification`) et celles qu'elle crée (`Built on superpowers`, `Departures from superpowers`, `Module`, `Batch`, `Story`, `Amending a batch`, `Delivering a story`, `Abandoning a story`, `Bounded change`, `Installing on a project`)

## Global Constraints

Le gel du fichier de spec, la règle d'autorité, puis la section `Constraints` du lot copiée verbatim. Tout cela fait implicitement partie des exigences de chaque tâche.

**Gel du fichier de spec.** Entre le commit de transcription et l'ouverture de la pull request, aucune tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit changer s'arrête. `docs/specs/supercharlouze.md` a reçu sa tranche dans le commit `10fabf8`, premier commit de cette branche, décidé par l'humain : il n'y a plus rien à y écrire dans cette story.

**Autorité.** Quand le lot et la spec se contredisent, **la spec gagne — sans exception et sans délibération.** Implémente ce que dit la spec, inscris un `Ruling:`, et continue. **Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.**

Constraints du lot, copiées verbatim :

- **Ordre requis, et il est total.** La tranche `The spec document` est transcrite
  **en premier** et fusionnée avant que la suivante commence : la tranche
  `Module adoption` cite la règle que la première pose, et l'écrire contre un texte
  non fusionné produirait deux formulations concurrentes de la même règle. La **mise
  en conformité de `docs/specs/supercharlouze.md`** vient **en dernier**, après que
  les deux tranches normatives sont sur `main` : elle applique la règle, elle ne
  peut donc pas précéder son énoncé, et elle toucherait sinon des sections que les
  deux autres sont en train d'écrire.
- **La spec de ce plugin doit survivre à la règle qu'elle énonce.**
  `docs/specs/supercharlouze.md` est pleine de noms de branches, d'appels `gh` et de
  mécanique git — légitimement, parce qu'ils sont observables à la frontière de ce
  module et qu'un autre implémenteur les lirait comme vrais du sien. Toute
  formulation qui rendrait cette spec illégale est une mauvaise formulation, et il
  faut la reprendre plutôt que l'excepter. C'est le meilleur test disponible de la
  règle, et il est gratuit.
- **La mise en conformité est à sens constant.** Elle réexprime, elle ne décide
  jamais. Une phrase qui sort de la spec parce qu'elle décrit un mécanisme ne
  change pas ce que le plugin doit faire ; si la reprise d'une section changeait la
  norme, c'est que ce n'est plus une mise en conformité mais une décision, et une
  décision sur une spec est **un acte humain**. La tranche s'arrête et la pose.
- **Elle n'invente aucune intention.** Là où la spec porte un mécanisme dont aucun
  document validé ni aucune section voisine ne donne la règle qu'il servait, la
  tranche **ne la déduit pas** : ce serait le blanchiment que ce lot interdit,
  commis par le lot lui-même. Elle laisse la phrase en place et **consigne le
  constat sous `Observed drift`** dans son document de story, d'où
  `supercharlouze:closing-a-batch` le consolidera. Aucune écriture directe dans le
  gaps register : ce lot n'y touche pas.
- **Cette tranche est commanditée par l'humain au gate d'ouverture**, et c'est ce
  qui la distingue d'un agent qui corrigerait une spec de sa propre initiative. La
  commande porte sur la **forme** du document, jamais sur ce qu'il exige ; la revue
  de sa pull request est le gate qui le vérifie.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`, dans la
  même pull request qu'elle.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**
- **Aucun renvoi numéroté.** Un renvoi nomme la section qu'il vise ; il ne la compte
  pas.
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit la
  spec, la constatation part sous `Observed drift` dans le document de story.
- **Sept décisions sont tranchées au gate d'ouverture** et ne se rediscutent pas en
  cours d'implémentation : le critère est le **test de l'autre implémentation** et
  non une liste de mots interdits ; un mécanisme lu dans un document validé **part
  au registre** plutôt que d'être lu à travers pour en déduire une intention ; **un
  choix métier porte son chiffre**, la règle n'autorisant jamais le flou ; **nommer
  n'est pas mécaniser**, donc un glossaire métier reste ; **tout ce qu'une spec
  contient est normatif au même niveau**, le plugin ne prescrivant aucun balisage
  d'aparté ; **un module redéfinit ce qu'il emprunte** plutôt que de renvoyer à la
  spec voisine ; et le gaps register est **hors du périmètre** de la règle.
- **La place d'une règle transverse est hors périmètre.** Une règle qui vaut pour
  tous les modules ne vit dans aucun, et ce plugin ne dit nulle part où elle vit —
  un module, une spec, et rien d'autre. Trancher demande de décider si le système
  gagne une spec transverse ou s'il reconnaît `CLAUDE.md` comme son domicile, ce qui
  touche `Document layout` et l'adoption. C'est un lot à part entière, pas une
  clause à glisser ici.
- **La contestation de la section `Sources` est hors périmètre.** Elle est réelle,
  elle vise ce plugin, et elle demande de décider si une spec vivante a encore
  besoin de déclarer ce qui l'a nourrie — avec l'état des lieux de `init` qui en
  dépend. Aucune story de ce lot n'y touche, ni pour la défendre ni pour la retirer.
- **Aucune dépendance à `domain-driven-design`.** La règle s'énonce de façon
  autonome, et elle doit tenir pour un agent qui n'a jamais chargé cette skill.
  Faire de `domain-driven-design` un prérequis du plugin, au même rang que
  superpowers, est une question ouverte et délibérément hors de ce lot — mais
  l'exemple ci-dessus l'a rendue plus sérieuse, puisque c'est son invocation qui a
  produit la seule version acceptable des trois. Trancher cette question demande de
  peser une dépendance externe que le plugin ne contrôle pas ; c'est une décision
  humaine, elle ne se prend pas au détour d'une story.
- **Ne toucher à aucune entrée du gaps register.** Ce lot n'en réserve aucune ;
  toutes appartiennent à d'autres lots.

**Langue.** Squelette anglais, prose dans la langue du projet — et **le plugin lui-même est intégralement en anglais** : skills, README, messages. Tout texte ajouté sous `skills/` et `tests/` est donc en anglais. Le fichier de spec et ce document de story sont en français.

**Ne pas reformuler la règle de contenu ailleurs.** Elle vit dans `## What a Spec Says` de `skills/using-batches/SKILL.md`. La Task 1 remplace **un seul paragraphe** de cette section ; tout le reste de la section est hors périmètre.

**Hors périmètre de cette story**, et à ne toucher sous aucun prétexte : `docs/specs/supercharlouze.md` (gelée, sa tranche est commitée), `docs/specs/supercharlouze.gaps.md` (ce lot n'y touche pas), les justifications que portent les skills (la règle de contenu vise le fichier de spec, pas les skills), et les exemples de `skills/writing-a-batch/SKILL.md` (ils suivent déjà les gabarits de la spec).

---

## File Structure

| Fichier | Responsabilité dans cette story |
|---|---|
| `skills/using-batches/SKILL.md` | **Modifier.** Le paragraphe `**The spec's structure follows the business.**` de `## What a Spec Says` (Task 1), l'exemple de phrase de gating du paragraphe `**The flag is a specified object, not an implementation detail.**` de `## The Model` (Task 2), et l'exemple `gh` de la règle de contenu (Task 5). |
| `tests/test-skill-content.sh` | **Modifier.** Les assertions sur la clause resserrée (Task 1) et sur l'exemple de la règle de contenu (Task 5). |
| `tests/test-skill-contracts.sh` | **Modifier.** L'assertion `shared` qui verrouille la forme de la phrase de gating sur les deux skills qui la citent (Task 2). |
| `tests/test-cross-references.sh` | **Modifier.** La liste des sections que cite un artefact livré, et leur recherche aux deux niveaux de titre (Task 3). |
| `commands/init.md` | **Modifier.** Son renvoi vers la section d'installation (Task 3). |
| `README.md` | **Modifier.** Ce que la spec a rendu à l'implémentation : le harnais, `gh`, les sous-modules, ce que la suite ne teste pas (Task 4). |

---

### Task 1: La clause de structure, resserrée

**Files:**
- Modify: `skills/using-batches/SKILL.md` (`## What a Spec Says`, paragraphe `**The spec's structure follows the business.**`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la clause resserrée de `The spec document`, dans `docs/specs/supercharlouze.md` (commit `10fabf8`) : *« Est proscrite la section qui reproduit la décomposition interne du code — « les ports », « les adapters », « ce qui écrit où » — ou qui range les règles par leur nature plutôt que par ce qu'elles contraignent — « les invariants », « les contraintes ». Une section qui porte un concept observable à la frontière du module — une convention de nommage, une règle d'autorité — suit le métier, même quand ce concept vaut pour plusieurs comportements. »*
- Produces: rien qu'une tâche ultérieure consomme.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh`, juste après la ligne `require using-batches "structure follows the business"          "structure follows the business"`, ajouter :

```bash
require using-batches "the ban is on the code's decomposition"   "reproduces the code's internal decomposition"
require using-batches "a boundary concept may gather rules"      "A section carrying a concept observable at the module's boundary"
```

`body_flat` aplatit le corps du fichier ; `using-batches` écrit chaque paragraphe sur une seule ligne, donc ces aiguilles ne rencontrent aucun repli.

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — deux lignes `[FAIL] using-batches: …`, code de sortie non nul.

- [ ] **Step 3: Tighten the clause**

Dans `skills/using-batches/SKILL.md`, remplacer le paragraphe entier :

```markdown
**The spec's structure follows the business.** A rule lives where the behaviour it constrains lives, not gathered into a section that groups rules by nature. A section called "the invariants", "the ports" or "what writes where" has the shape of the code's layers, and that shape alone betrays the origin of the text even when every sentence, taken on its own, would pass the test. It is the shape-of-the-code sign, stated constructively.
```

par :

```markdown
**The spec's structure follows the business.** A rule lives where the behaviour it constrains lives. What is banned is a section that reproduces the code's internal decomposition — "the ports", "the adapters", "what writes where" — or that files rules by their nature rather than by what they constrain — "the invariants", "the constraints". That shape alone betrays the origin of the text even when every sentence, taken on its own, would pass the test; it is the shape-of-the-code sign, stated constructively. A section carrying a concept observable at the module's boundary — a naming convention, an authority rule — follows the business, even when that concept holds for several behaviours. Without that last sentence the clause would outlaw this plugin's own spec, whose `Branch naming` and `Authority and conflict rules` gather rules several workflows share.
```

Ce fichier écrit un paragraphe sur une seule ligne, sans repli : respecter cette forme.

- [ ] **Step 4: Run the guards to verify they pass**

Run: `bash tests/test-skill-content.sh`
Expected: PASS, code de sortie 0.

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-skill-content.sh
git commit -m "feat: resserre la clause de structure à la décomposition interne du code"
```

---

### Task 2: La phrase de gating, sous une seule forme

**Files:**
- Modify: `skills/using-batches/SKILL.md` (`## The Model`, paragraphe `**The flag is a specified object, not an implementation detail.**`)
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: le gabarit de `The spec document`, dans `docs/specs/supercharlouze.md` (commit `10fabf8`) : `` 🔒 `<flag>`, <on|off> by default ``, suivi de `— lifted when <condition de levée>` quand la portée dépasse le lot. `skills/writing-a-user-story/SKILL.md` le suit déjà (`` 🔒 `billing.recurring`, off by default — lifted when … ``).
- Produces: rien qu'une tâche ultérieure consomme.

- [ ] **Step 1: Write the failing guard**

Dans `tests/test-skill-contracts.sh`, juste après l'assertion `shared "whoever writes into a spec spells the other-implementation test identically" …` et ses lignes de continuation, ajouter :

```bash
# The gating sentence has one form, fixed by the spec's template. `using-batches`
# names it and `writing-a-user-story` shows it; `writing-a-batch` and
# `closing-a-batch` recognise it in a spec. Two spellings of the same sentence is
# how a live flag stops being found. One assertion over the two skills that write
# it out.
shared "the gating sentence is spelled in the spec's one form" \
    "🔒 \`billing.recurring\`, off by default" \
    using-batches writing-a-user-story
```

- [ ] **Step 2: Run the guard to verify it fails**

Run: `bash tests/test-skill-contracts.sh`
Expected: FAIL — `[FAIL] the gating sentence is spelled in the spec's one form (missing in: using-batches)`.

- [ ] **Step 3: Align the example**

Dans `skills/using-batches/SKILL.md`, paragraphe `**The flag is a specified object, not an implementation detail.**`, remplacer :

```markdown
The spec section concerned states its name and its default — *"behind the `billing.recurring` flag, off by default"*.
```

par :

```markdown
The spec section concerned states its name and its default, as a gating sentence of the one form the spec fixes — `` 🔒 `billing.recurring`, off by default ``.
```

Le reste du paragraphe ne change pas.

- [ ] **Step 4: Run the guard to verify it passes**

Run: `bash tests/test-skill-contracts.sh`
Expected: PASS, code de sortie 0.

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-skill-contracts.sh
git commit -m "feat: écrit la phrase de gating sous la forme unique que fixe la spec"
```

---

### Task 3: Les renvois suivent les sections renommées

**Files:**
- Modify: `tests/test-cross-references.sh` (assertion 6, la boucle `for h in …`)
- Modify: `commands/init.md` (le paragraphe `Everything in this system ships through a pull request`)

**Interfaces:**
- Consumes: la spec restructurée (commit `10fabf8`). `The init command` y devient `### Installing on a project` ; `Verification` est retirée ; `The spec document` descend au niveau `###` ; `## Authority and conflict rules` et `## Branch naming` gardent leur titre. Les skills citent `Authority and conflict rules` et `Branch naming`, `commands/init.md` cite `The init command`, et le README cite `Verification` (réglé par la Task 4).
- Produces: une garde qui accepte les titres `##` et `###`, et que la Task 4 laisse verte en retirant le renvoi du README.

- [ ] **Step 1: Observe the guard failing**

Run: `bash tests/test-cross-references.sh`
Expected: FAIL — trois lignes `[FAIL] the living spec has a section named: …`, pour `Verification`, `The init command` et `The spec document`. La restructuration a retiré, renommé ou descendu ces trois sections.

- [ ] **Step 2: Point the guard at the sections artefacts actually cite**

Dans `tests/test-cross-references.sh`, remplacer la boucle de l'assertion 6 :

```bash
for h in "Verification" "The init command" "The spec document"; do
    if grep -qxF "## $h" "$REPO_ROOT/docs/specs/supercharlouze.md"; then
```

par :

```bash
for h in "Installing on a project" "The spec document" "Authority and conflict rules" "Branch naming"; do
    if grep -qxE "#{2,3} $h" "$REPO_ROOT/docs/specs/supercharlouze.md"; then
```

Et, dans le commentaire de tête de l'assertion 6, ajouter après la ligne `#    break the reference silently — the same defect, one indirection later.` :

```bash
#    The spec nests steps under the object they advance, so a cited section may
#    sit at `##` or `###`; both count.
```

La liste nomme exactement les sections que citent les artefacts livrés : `commands/init.md` (après le Step 3), et les skills pour les trois autres.

- [ ] **Step 3: Fix the init command's reference**

Dans `commands/init.md`, remplacer :

```markdown
exception — see `The init command` in
```

par :

```markdown
exception — see `Installing on a project` in
```

- [ ] **Step 4: Run the guard and the whole suite**

Run: `bash tests/test-cross-references.sh && bash tests/run-all.sh`
Expected: PASS, code de sortie 0 ; et `grep -rn "The init command" commands skills` ne renvoie rien. Le README cite encore `Verification` : c'est la Task 4 qui le retire, et aucune garde ne lit ce renvoi-là.

- [ ] **Step 5: Commit**

```bash
git add tests/test-cross-references.sh commands/init.md
git commit -m "fix: aligne les renvois sur les sections de la spec restructurée"
```

---

### Task 4: Le README reprend ce que la spec a rendu à l'implémentation

**Files:**
- Modify: `README.md` (sections `## Tests` et `## Requirements`)

**Interfaces:**
- Consumes: la spec restructurée (commit `10fabf8`), qui ne dit plus rien du harnais, de `gh`, des sous-modules git ni de la suite de tests.
- Produces: rien qu'une tâche ultérieure consomme.

Pas de garde neuve : cette tâche n'ajoute aucune norme à la spec, elle documente l'implémentation. La garde de l'assertion 5 de `tests/test-cross-references.sh` lit déjà le README.

- [ ] **Step 1: Replace the pointer to the retired section**

Dans `README.md`, remplacer :

```markdown
Structural checks only — see the `Verification` section of
`docs/specs/supercharlouze.md` for what is deliberately not tested.
```

par :

```markdown
Structural checks only. What they deliberately do not test:

- whether the `CLAUDE.md` block actually wins precedence over superpowers in a
  live session;
- whether subagent-driven implementers honour the freeze of the spec file;
- whether `finishing-a-development-branch` is kept to the pull-request option
  on a story.
```

- [ ] **Step 2: Say what the implementation requires**

Dans `README.md`, remplacer la section :

```markdown
## Requirements

- Claude Code
- superpowers installed
```

par :

```markdown
## Requirements

- Claude Code — the only supported harness
- superpowers installed
- `gh`, installed and authenticated — number allocation and concurrency
  detection query it; without it they fall back to a partial net and no longer
  prevent anything

Projects organised as git submodules are not supported.
```

- [ ] **Step 3: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 4: Commit**

```bash
git add README.md
git commit -m "docs: le README reprend le harnais, gh et les limites que la spec a rendus à l'implémentation"
```

---

### Task 5: L'exemple de la règle de contenu ne nomme plus un outil

**Files:**
- Modify: `skills/using-batches/SKILL.md` (`## What a Spec Says`, paragraphe qui commence par `The test bears on the module's boundary`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la spec restructurée, section `The spec document` : *« Un module dont le domaine est l'infrastructure — un pipeline de déploiement, ou ce plugin-ci — énonce des noms de branches et des pull requests comme règles, dès lors qu'ils sont observables à sa frontière. »*
- Produces: rien qu'une tâche ultérieure consomme.

- [ ] **Step 1: Write the failing guard**

Dans `tests/test-skill-content.sh`, juste après la ligne `require using-batches "the test bears on the module boundary"   "bears on the module's boundary"`, ajouter :

```bash
require using-batches "infrastructure states branches and PRs"  "states branch names and pull requests as rules"
```

- [ ] **Step 2: Run the guard to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — `[FAIL] using-batches: infrastructure states branches and PRs`.

- [ ] **Step 3: Replace the tool by what the boundary shows**

Dans `skills/using-batches/SKILL.md`, remplacer le fragment :

```markdown
states branch names and `gh` calls as rules
```

par :

```markdown
states branch names and pull requests as rules
```

Le reste du paragraphe ne change pas ; il est écrit sur une seule ligne.

- [ ] **Step 4: Run the guard to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: PASS, code de sortie 0.

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-skill-content.sh
git commit -m "feat: l'exemple de la règle de contenu nomme les pull requests, pas l'outil"
```

---

## Rulings log

## Observed drift
