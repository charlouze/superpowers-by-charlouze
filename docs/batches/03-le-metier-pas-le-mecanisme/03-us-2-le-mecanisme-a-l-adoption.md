# 03 — us-2 — Le mécanisme à l'adoption — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Porter dans `supercharlouze:adopting-a-module` les deux conséquences propres à l'adoption — un document validé fait autorité sur ses intentions et non sur ses mécanismes, et le cas dégradé énumère à la frontière du module — et ouvrir au gaps register la source neuve que cela crée.

**Architecture:** La règle de contenu reste à **un seul endroit**, la section `What a Spec Says` de `skills/using-batches/SKILL.md` que la story précédente a écrite. Cette story ne la reformule pas : elle la **nomme** et en **reprend la question mot pour mot**, exactement comme `writing-a-user-story` et `closing-a-batch` le font déjà — ce que verrouille l'assertion `shared` unique de `tests/test-skill-contracts.sh`, à laquelle `adopting-a-module` est ajoutée. Ce qu'elle ajoute en propre est ce que la règle générale ne pouvait pas dire : l'adoption est le seul moment où une spec s'écrit contre des documents validés, donc le seul endroit où un mécanisme peut entrer par un document plutôt que par le code. La définition élargie d'un gap est écrite là où le registre est créé — `adopting-a-module`, seule skill qui le crée — et les deux autres endroits qui la glosent pour router (`using-batches`, `writing-a-batch`) la reprennent au mot près sous une seconde assertion `shared`.

**Tech Stack:** Markdown (skills, spec), bash (`tests/*.sh`, exécutées par `tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/03-le-metier-pas-le-mecanisme/README.md
**Sections:** Module adoption, The gaps register

## Global Constraints

Le gel du fichier de spec, la règle d'autorité, puis la section `Constraints` du lot copiée verbatim. Tout cela fait implicitement partie des exigences de chaque tâche.

**Gel du fichier de spec.** Entre le commit de transcription et l'ouverture de la pull request, aucune tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit changer s'arrête. `docs/specs/supercharlouze.md` a reçu sa tranche dans le **premier commit de cette branche** : il n'y a plus rien à y écrire dans cette story.

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

**Ne pas reformuler la règle de contenu.** Elle vit dans `## What a Spec Says` de `skills/using-batches/SKILL.md`. Toute tâche qui a besoin d'elle la **nomme** et reprend **mot pour mot** la question du test : *would another developer, having implemented the same intention differently, read this sentence as true of their code?* Une seconde formulation de la même règle est exactement ce qui dérive, et c'est ce que l'assertion `shared` de `tests/test-skill-contracts.sh` interdit.

**Hors périmètre de cette story**, et à ne toucher sous aucun prétexte : `docs/specs/supercharlouze.md` (gelée, sa tranche est déjà commitée), `docs/specs/supercharlouze.gaps.md` (ce lot n'y touche pas), la section `## What a Spec Says` de `skills/using-batches/SKILL.md` (elle est fusionnée, la citer suffit), la mise en conformité de la spec du plugin (tranche 3 du lot), et la table `Changelog` de la spec (écrite par `closing-a-batch`, une ligne par lot).

---

## File Structure

| Fichier | Responsabilité dans cette story |
|---|---|
| `skills/adopting-a-module/SKILL.md` | **Modifier.** Porte les trois ajouts : l'autorité resserrée d'un document validé et l'interdiction de lire à travers un mécanisme (`## Source Authority`, step 4), le cas dégradé borné à la frontière (`## Degraded Case`), et la définition élargie d'un gap avec sa source nommée (step 5). |
| `skills/using-batches/SKILL.md` | **Modifier.** Une seule ligne : la case du tableau de routage qui définit un *Gap*. |
| `skills/writing-a-batch/SKILL.md` | **Modifier.** Une seule phrase : la glose qui dit ce qui alimente un lot ordinaire. |
| `tests/test-skill-content.sh` | **Modifier.** Les assertions par clause sur `adopting-a-module`. |
| `tests/test-skill-contracts.sh` | **Modifier.** `adopting-a-module` rejoint l'assertion `shared` du test de l'autre implémentation ; une seconde `shared` verrouille la définition élargie d'un gap sur ses trois porteurs. |

---

### Task 1: Un document validé fait autorité sur ses intentions, pas sur ses mécanismes

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md` (`## Source Authority` ; `### 4. Write the spec from those documents only` ; `## Red Flags`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la section `## What a Spec Says` de `skills/using-batches/SKILL.md`, et sa question `Would another developer, having implemented the same intention differently, read this sentence as true of their code?` — déjà sur `main`.
- Produces: rien qu'une tâche ultérieure consomme. La Task 3 modifie une autre partie du même fichier (`### 5. Audit the code against the spec`).

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh`, dans le bloc `# --- adopting-a-module (spec 6) ---`, juste après la ligne `require adopting-a-module "never rebuilds a spec from code" …`, ajouter :

```bash
require adopting-a-module "authority on intentions, not mechanisms"    "**intentions they state**, never on the **mechanisms they describe**"
require adopting-a-module "a read mechanism goes to the register"      "does not enter the spec: it goes to the gaps register"
require adopting-a-module "no reading through a mechanism"             "you do not read *through* a mechanism"
require adopting-a-module "the test is applied sentence by sentence"   "Every sentence you write passes the other-implementation test"
```

Ces aiguilles sont sensibles au repli des lignes : `body_flat` remplace chaque
saut de ligne par **un** espace, donc une ligne repliée et ré-indentée produit
plusieurs espaces consécutifs. Chacune ci-dessus tient sur une seule ligne du
texte cible, et les remplacements des Steps 3 à 5 sont repliés exprès pour que ce
soit vrai. Ne pas réindenter ces paragraphes sans revérifier les aiguilles.

Dans `tests/test-skill-contracts.sh`, l'assertion `shared` du test de l'autre implémentation couvre trois fichiers ; l'adoption est le quatrième écrivain dans un fichier de spec — elle le **crée**. Remplacer son commentaire et son appel par :

```bash
# The content rule lives in one place, `using-batches`. A skill that writes into a
# spec file names it and reuses its question verbatim rather than restating it —
# a second formulation of the same rule is exactly what drifts. One assertion over
# the four files: separate ones would all stay green while one end reworded.
# `adopting-a-module` is in the list because it does not merely write into a spec,
# it creates one: every sentence of a spec's first version passes through it.
shared "whoever writes into a spec spells the other-implementation test identically" \
    "read this sentence as true of their code" \
    using-batches writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh`
Expected: FAIL des deux — quatre lignes `[FAIL] adopting-a-module: …` dans la première, et `[FAIL] whoever writes into a spec spells the other-implementation test identically (missing in: adopting-a-module)` dans la seconde.

- [ ] **Step 3: Tighten the source authority**

Dans `skills/adopting-a-module/SKILL.md`, section `## Source Authority`, remplacer le rang 1 :

```markdown
1. **The validated documents.** Here, validated documents are normative,
   and only they create normative text.
```

par :

```markdown
1. **The validated documents.** Here, validated documents are normative on the
   **intentions they state**, never on the **mechanisms they describe** — and a
   design document is full of the latter. A mechanism read in a validated
   document does not enter the spec: it goes to the gaps register, naming the
   document it came from, and only your human partner can promote it from there.
   Nothing is lost, everything is addressable, and the promotion stays a human
   act — the machinery rank 2 already uses for silences. Within that bound, only
   they create normative text.
```

Ce fichier replie sa prose autour de 80 colonnes : respecter cette forme. Le repli
ci-dessus est celui que les aiguilles du Step 1 attendent — `validated documents
are normative` et la paire `intentions`/`mécanismes` tiennent chacune sur une
seule ligne, et `does not enter the spec: it goes to the gaps register` aussi.

- [ ] **Step 4: Forbid reading through a mechanism**

Dans le même fichier, insérer un paragraphe entre celui qui commence par `The pressure to break this rule is highest` et le titre `## Steps` :

```markdown
**And you do not read *through* a mechanism to deduce the intention it served.**
That is the content rule of `supercharlouze:using-batches` — a spec carries
business rules and intentions, the mechanism stays in the code — and adoption is
where breaking it is most tempting: a validated document describes a mechanism,
the intention behind it looks one paraphrase away, and it is not. Ask the test of
every sentence you are about to write: *would another developer, having
implemented the same intention differently, read this sentence as true of their
code?* What a document states as an intention is normative and goes in; what it
states as a mechanism goes to the register. Deducing an intention from a
mechanism is the same reconstruction whether you read that mechanism in the code
or in a validated document, and it yields the same rule nobody outside the module
can check.
```

- [ ] **Step 5: Apply the test where the spec is written**

Dans le même fichier, section `### 4. Write the spec from those documents only`, insérer une puce **avant** la puce `- **Nothing enters the spec that no validated document supports.**` :

```markdown
- **Every sentence you write passes the other-implementation test**, and what it
  ejects goes to the gaps register naming the document it came from. A validated
  document is authority over the intentions it states, not over the mechanisms it
  describes, so a mechanism it prescribes is no more admissible here than one you
  read in the code.
```

- [ ] **Step 6: Add the red flags**

Dans le même fichier, table `## Red Flags`, insérer deux lignes juste après la ligne `| "The code is the real truth, I'll spec what it does" | … |` :

```markdown
| "The document prescribes this mechanism, so it is normative" | A validated document is authority over the intentions it states, not the mechanisms it describes. The mechanism goes to the register, naming its source. |
| "The intention behind this mechanism is obvious, I'll write it down" | Deducing an intention from a mechanism is reconstruction from the code by another road. It comes from a document or from your partner, or it goes to the register. |
```

- [ ] **Step 7: Run the guards to verify they pass**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh`
Expected: PASS des deux, code de sortie 0 chacun.

- [ ] **Step 8: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 9: Commit**

```bash
git add skills/adopting-a-module/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
git commit -m "feat: un document validé fait autorité sur ses intentions, pas sur ses mécanismes"
```

---

### Task 2: Le cas dégradé énumère à la frontière du module

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md` (`## Degraded Case: A Module With No Validated Documents` ; `## Red Flags`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: rien de la Task 1 — les deux touchent des sections différentes du même fichier.
- Produces: rien qu'une tâche ultérieure consomme.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-content.sh`, juste après la ligne `require adopting-a-module "handles the no-document fallback" …`, ajouter :

```bash
require adopting-a-module "the fallback enumerates at the boundary"   "observable at the module's boundary"
require adopting-a-module "the question is about the intention"       "about the intention, never about the mechanism"
require adopting-a-module "a mechanism is not put to validation"      "A mechanism is not submitted to human validation"
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — trois lignes `[FAIL] adopting-a-module: …`, code de sortie non nul.

- [ ] **Step 3: Bound the enumeration**

Dans `skills/adopting-a-module/SKILL.md`, section `## Degraded Case: A Module With No Validated Documents`, remplacer :

```markdown
1. Enumerate the behaviours you find in the code, grouped as candidate sections.
2. Ask your human partner, section by section: *is this intended?*
3. What they validate becomes the spec. Everything else goes to **Gaps**.

Each answer is a human validation, and human validation is the only thing that can
create normative text where no document exists. So ask section by section: a wall
of questions gets one blanket "yes" back, and a blanket yes is reconstruction from
the code with extra steps.
```

par :

```markdown
1. Enumerate the behaviours **observable at the module's boundary**, grouped as
   candidate sections.
2. Ask your human partner, section by section: *is this intended?* — a question
   about the intention, never about the mechanism.
3. What they validate becomes the spec. Everything else goes to **Gaps**.

The boundary is what bounds the enumeration, and it is load-bearing: an agent
reading code sees infrastructure first, so an unbounded enumeration puts data
stores, triggers and adapter layers to your partner one at a time. **A mechanism
is not submitted to human validation** — validating it would not make it a rule,
only an approved drift, and approved drift is worse than drift because nothing
downstream can tell it apart from a decision. Enumerate what a user or a
neighbouring module could observe, and nothing else.

Each answer is a human validation, and human validation is the only thing that can
create normative text where no document exists. So ask section by section: a wall
of questions gets one blanket "yes" back, and a blanket yes is reconstruction from
the code with extra steps.
```

- [ ] **Step 4: Add the red flag**

Dans le même fichier, table `## Red Flags`, remplacer la ligne :

```markdown
| "No documents exist, so I'll draft from the code and have them confirm" | A draft to confirm is a blanket yes waiting to happen. Section by section, one question at a time. |
```

par ces deux lignes :

```markdown
| "No documents exist, so I'll draft from the code and have them confirm" | A draft to confirm is a blanket yes waiting to happen. Section by section, one question at a time. |
| "They said yes to it, so this mechanism is now a rule" | A mechanism is not submitted to validation. Enumerate what is observable at the boundary; a validated mechanism is approved drift. |
```

- [ ] **Step 5: Run the guards to verify they pass**

Run: `bash tests/test-skill-content.sh`
Expected: PASS — les trois assertions vertes, code de sortie 0.

- [ ] **Step 6: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 7: Commit**

```bash
git add skills/adopting-a-module/SKILL.md tests/test-skill-content.sh
git commit -m "feat: le cas dégradé de l'adoption énumère à la frontière du module"
```

---

### Task 3: Le gaps register accueille le mécanisme prescrit

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md` (`### 5. Audit the code against the spec`)
- Modify: `skills/using-batches/SKILL.md` (la ligne *Gaps* du tableau `**Route by situation:**`)
- Modify: `skills/writing-a-batch/SKILL.md` (le paragraphe `**The two sections of the register do not feed the same kind of batch.**`)
- Test: `tests/test-skill-contracts.sh`, `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: rien des Tasks 1 et 2 — elles touchent d'autres sections de `adopting-a-module`.
- Produces: rien qu'une tâche ultérieure consomme.

- [ ] **Step 1: Write the failing guards**

Dans `tests/test-skill-contracts.sh`, juste après l'assertion `shared "whoever writes into a spec spells the other-implementation test identically" …` (celle que la Task 1 a portée à quatre fichiers), ajouter :

```bash
# A gap has gained a second source: a mechanism a validated document prescribes
# and no spec carries. Three skills state that definition — the one that creates
# the register, and the two that gloss it to route. One assertion over the three:
# a definition that broadens on one end only is how a whole source of gaps stops
# being recognised as one.
shared "the broadened gap definition is spelled identically" \
    "or a validated document prescribes a mechanism" \
    adopting-a-module using-batches writing-a-batch
```

Dans `tests/test-skill-content.sh`, dans le bloc `# --- adopting-a-module (spec 6) ---`, juste après la ligne `require adopting-a-module "the register declares its coverage" …`, ajouter :

```bash
require adopting-a-module "a gap entry names its source document"   "names that document"
require adopting-a-module "the prescribed-and-absent case is named" "prescribed and **absent from the code**"
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-contracts.sh; bash tests/test-skill-content.sh`
Expected: FAIL des deux — `[FAIL] the broadened gap definition is spelled identically (missing in: adopting-a-module using-batches writing-a-batch)` dans la première, deux lignes `[FAIL] adopting-a-module: …` dans la seconde.

- [ ] **Step 3: Broaden the definition where the register is created**

Dans `skills/adopting-a-module/SKILL.md`, section `### 5. Audit the code against the spec`, remplacer la puce :

```markdown
- **Gaps** — the code does things no spec describes. Feeds an ordinary batch that
  finally specifies them.
```

par :

```markdown
- **Gaps** — the code does things no spec describes,
  or a validated document prescribes a mechanism no spec carries. Feeds an
  ordinary batch that finally specifies them.
```

Le repli est volontaire : l'aiguille `shared` du Step 1 doit tenir sur une seule
ligne, et `body_flat` transformerait un repli après `validated document` en
plusieurs espaces consécutifs.

- [ ] **Step 4: Make an entry name its source**

Dans le même fichier et la même section, insérer juste après la ligne `Each entry designates a section of the spec.` :

```markdown
**An entry that came from a validated document names that document.** The plain
case — the document prescribes, the code executes — already fitted the first half
of the definition without forcing. The one that did not is the mechanism
prescribed and **absent from the code**: it contradicts no spec, so it is no
violation, and no code carries it, so the first half never saw it. It had nowhere
to go. Naming its source is what lets your human partner promote it knowing what
they are promoting, instead of re-reading the whole document.
```

Puis, dans le bloc `**The shape of the register:**` du même fichier, ajouter une seconde puce sous `## Gaps`, après celle qui existe :

```markdown
- **<spec section, or the section that should exist>** — <a mechanism
  `docs/archive/specs/<validated document>.md` prescribes and no spec carries.>
```

- [ ] **Step 5: Carry the definition to the two skills that gloss it**

Dans `skills/using-batches/SKILL.md`, tableau `**Route by situation:**`, remplacer la ligne :

```markdown
| A module's gaps register holds unreserved **Gaps** — the code does things no spec describes | `supercharlouze:writing-a-batch`, as an ordinary batch that finally specifies them |
```

par :

```markdown
| A module's gaps register holds unreserved **Gaps** — the code does things no spec describes, or a validated document prescribes a mechanism no spec carries | `supercharlouze:writing-a-batch`, as an ordinary batch that finally specifies them |
```

Dans `skills/writing-a-batch/SKILL.md`, paragraphe `**The two sections of the register do not feed the same kind of batch.**`, remplacer :

```markdown
*Gaps* — the code does things no spec describes — feed an **ordinary** batch
that finally specifies them, and such a batch has a real spec delta *and*
reservations.
```

par :

```markdown
*Gaps* — the code does things no spec describes, or a validated document
prescribes a mechanism no spec carries — feed an **ordinary** batch
that finally specifies them, and such a batch has a real spec delta *and*
reservations.
```

Ce fichier replie sa prose autour de 76 colonnes : respecter cette forme.

- [ ] **Step 6: Run the guards to verify they pass**

Run: `bash tests/test-skill-contracts.sh; bash tests/test-skill-content.sh`
Expected: PASS des deux, code de sortie 0 chacun.

- [ ] **Step 7: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 8: Commit**

```bash
git add skills/adopting-a-module/SKILL.md skills/using-batches/SKILL.md skills/writing-a-batch/SKILL.md tests/test-skill-contracts.sh tests/test-skill-content.sh
git commit -m "feat: ouvre le gaps register au mécanisme prescrit par un document validé"
```

---

## Rulings log

**Ruling: trois constats mineurs de la revue finale sont corrigés sans être soumis.** `body_flat` gagne `tr -s ' '` dans les deux fichiers de test, l'aiguille faible `names that document` est renforcée, et le renvoi de la spec vers sa section `The spec document` rejoint la garde de renvois. Les trois protègent des gardes que cette story ajoute, et une garde qui rougit sur de la prose correcte apprend au rédacteur suivant à réécrire de la prose correcte pour plaire à un test. — Coût si c'est faux : trois changements cantonnés à `tests/`, visibles au diff et annulables en un commit.

**Ruling: la ligne de `Red Flags` qui glose la règle d'autorité reste telle quelle.** Reformuler en forme ramassée une règle déjà énoncée est le **genre** de cette table, dans les cinq skills du plugin ; la condamner condamnerait la convention entière. — Coût si c'est faux : le rang 1 est révisé un jour et cette ligne continue silencieusement de dire l'ancienne chose.

**Le gate de livraison a tranché en deux temps** — une discussion, puis une revue en ligne de neuf commentaires dont les fils portent les réponses. Ce que la branche livre :

- **Un gap est « un comportement ou une exigence réels qu'aucune spec ne décrit ».** La catégorie ne dépend pas du contexte, ses sources oui : une adoption les trouve dans l'audit du code et dans ce que l'écriture éjecte des documents validés, une story dans le code qu'elle traverse. Les sources avaient d'abord été écrites **dans** la définition, puis cette définition gardée identique dans quatre fichiers — d'où « document validé » qui fuyait jusqu'à `using-batches`, à qui ce mot ne dit rien. Les gloses de routage sont muettes sur les sources, sous une garde qui le vérifie.
- **Le registre est écrit dès le step 4.** La première formulation — mettre de côté au step 4, verser au step 5 — a été livrée puis rejetée en revue : c'est un mécanisme, et une spec n'en porte pas. La spec ne dit plus **quand** le registre est écrit ; la skill, elle, a le droit de le dire.
- **`closing-a-batch` ne définit plus un gap.** Sa définition étroite, puis le paragraphe qui expliquait pourquoi elle différait, ont disparu ensemble : avec une catégorie sans sources, elle ne diffère plus.
- **Cinq paragraphes de la tranche portaient une justification et non la règle.** Ils disent la règle. Dans une spec, tout est normatif au même niveau — un paragraphe non opposable n'y a donc pas sa place, même raccourci.
- **L'exclusivité que portait « Ils font la vérité » revient dans la spec**, bornée à sa nouvelle portée, et **la puce du step 4 renvoie à `Source Authority`** au lieu de la redire.

**Deux constats de la revue ont été discutés plutôt qu'appliqués tels quels**, et la correction retenue est plus étroite que celle demandée : le paragraphe *On ne lit pas « à travers » un mécanisme* ne décrivait pas une implémentation — ce qui a le droit d'entrer dans une spec est normatif à la frontière de ce module — donc seule sa justification est partie, pas la règle ; et le dialogue du cas dégradé reste pour la même raison, seule sa justification nommant des magasins de données et des couches d'adapters est partie.

## Observed drift

Aucune divergence entre la spec et le code constatée hors du périmètre de cette story. Ce que les revues ont remonté portait sur la norme elle-même et sur la façon de l'écrire, jamais sur du code qui contredirait une spec. Tout est tranché et livré.
