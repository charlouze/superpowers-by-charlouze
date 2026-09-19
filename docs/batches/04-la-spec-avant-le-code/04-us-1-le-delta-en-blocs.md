# 04 — us-1 — Le spec delta en blocs — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Porter dans les skills ce que les blocs D1, D3 et D4 viennent d'écrire dans la spec : le spec delta d'un lot est du texte exact, rangé en blocs, et la revue d'ouverture porte sur ce texte.

**Architecture:** La définition du bloc entre dans `The Model` de `skills/using-batches/SKILL.md`, le glossaire que toute skill a déjà lu. La forme du bloc et la revue d'ouverture vivent dans `skills/writing-a-batch/SKILL.md`, la seule skill qui écrit un document de lot. Les skills qui parlent encore du delta comme d'une « intention » — `closing-a-batch`, `writing-a-user-story` — changent de vocabulaire et rien d'autre : la façon dont la clôture compare les blocs annoncés aux blocs livrés, par le champ `Blocks:`, appartient à D5 et D7, que cette story ne prend pas. Chaque norme repart avec sa garde dans `tests/`, écrite rouge avant le texte qui la fait passer.

**Tech Stack:** Markdown (skills), bash (`tests/*.sh`, exécutées par `tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/04-la-spec-avant-le-code/README.md
**Sections:** The model, Batch > The batch document, Batch > Opening a batch
**Blocks:** D1, D3, D4

## Global Constraints

Le gel du fichier de spec, la règle d'autorité, puis la section `Constraints` du lot copiée verbatim. Tout cela fait implicitement partie des exigences de chaque tâche.

**Gel du fichier de spec.** Entre le commit de transcription et l'ouverture de la pull request, aucune tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit changer s'arrête. `docs/specs/supercharlouze.md` a reçu D1, D3 et D4 dans le commit `91b1ac3`, premier commit de cette branche : il n'y a plus rien à y écrire dans cette story.

**Autorité.** Quand le lot et la spec se contredisent, **la spec gagne — sans exception et sans délibération.** Implémente ce que dit la spec, inscris un `Ruling:`, et continue. **Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.**

**Commits.** Chaque commit passe par le wrapper d'identité de l'agent — `bash ~/.config/github-app/as-agent.sh git commit …` — suit Conventional Commits, et se termine par la ligne `Co-Authored-By: Charlouze <me@charlouze.com>`, sans aucune autre ligne d'attribution.

Constraints du lot, copiées verbatim :

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

## File Structure

| Fichier | Responsabilité dans cette story |
|---|---|
| `skills/using-batches/SKILL.md` | `The Model` gagne la définition du **Delta block** (D1). |
| `skills/writing-a-batch/SKILL.md` | Le gabarit et la prose du `Spec delta` passent en blocs de texte exact (D3) ; la relecture avant ouverture et la revue d'ouverture portent sur le texte de chaque bloc (D4). |
| `skills/closing-a-batch/SKILL.md` | Vocabulaire seulement : ce que le lot a annoncé, ce sont des blocs, plus des intentions (D3). |
| `skills/writing-a-user-story/SKILL.md` | Vocabulaire seulement, même raison, dans `Step 7 — Answer the Review`. |
| `tests/test-skill-content.sh` | Gardes positives : la définition du bloc, sa forme, la revue d'ouverture sur le texte exact. |
| `tests/test-skill-contracts.sh` | Garde négative : plus aucune skill ne parle du delta comme d'une intention. |

Les skills sont en anglais d'un bout à l'autre : le plugin n'a pas de prose métier, seulement de l'ossature. Les textes à insérer ci-dessous sont donc en anglais.

---

### Task 1: Le bloc entre dans le glossaire

**Files:**
- Modify: `skills/using-batches/SKILL.md` (section `## The Model`, après l'entrée **Corrective batch**)
- Test: `tests/test-skill-content.sh` (section `# --- using-batches: what a spec says …`)

**Interfaces:**
- Consumes: rien.
- Produces: le terme **Delta block**, que les tâches 2 et 3 emploient sous la forme « block ».

- [ ] **Step 1: Écrire la garde, rouge**

Dans `tests/test-skill-content.sh`, juste avant la ligne `exit $((FAILURES > 0))`, ajouter :

```bash

# --- using-batches: the delta block (spec section "The model") ---
require using-batches "defines the delta block" "**Delta block** — the unit of a batch's spec delta"
require using-batches "a block is transcribed word for word" "the exact text it must receive, transcribed word for word by a story"
```

- [ ] **Step 2: Vérifier qu'elle échoue**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: deux lignes `[FAIL] using-batches: defines the delta block` et `[FAIL] using-batches: a block is transcribed word for word`, et rien d'autre.

- [ ] **Step 3: Écrire la définition**

Dans `skills/using-batches/SKILL.md`, section `## The Model`, insérer après le paragraphe qui commence par `**Corrective batch** — a batch whose spec delta is empty.` (une ligne vide avant, une après) :

```markdown
**Delta block** — the unit of a batch's spec delta: one targeted section and the exact text it must receive, transcribed word for word by a story.
```

- [ ] **Step 4: Vérifier qu'elle passe**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: aucune sortie.

- [ ] **Step 5: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: le glossaire définit le bloc du spec delta

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 2: Le document de lot écrit son delta en blocs, et l'ouverture le fait relire

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` — le gabarit de `## The Batch Document`, le paragraphe qui commence par `This pull request does **no writing into the specs**.`, le deuxième paragraphe de `## Flags Declared by Earlier Batches`, `## Opening the Pull Request`, la table `## Red Flags`
- Test: `tests/test-skill-content.sh` (section `# --- writing-a-batch: the batch document contract …`)

**Interfaces:**
- Consumes: le terme « block » de la tâche 1.
- Produces: la phrase `catches any block the delta announced and no story transcribed`, que la garde négative de la tâche 3 laisse passer ; l'identifiant `D<n>`.

- [ ] **Step 1: Écrire les gardes, rouges**

Dans `tests/test-skill-content.sh`, à la fin de la section `# --- writing-a-batch: the batch document contract (spec section "The batch document") ---` (après la ligne `require writing-a-batch "Constraints carry nothing normative" …`), ajouter :

```bash
require writing-a-batch "the delta is exact text, in blocks"        "written here as **exact text, in blocks**"
require writing-a-batch "a block carries a unique D<n>"             "Each one carries an identifier \`D<n>\`, unique within the batch"
require writing-a-batch "a block quotes what it replaces"           "quotes the current passage, then the text that replaces it"
require writing-a-batch "no block is attached to a story"           "No block is attached to a story"
require writing-a-batch "two changes to a section are two blocks"   "carries two blocks, and \`Constraints\` states their order"
require writing-a-batch "a lifting is a block removing the sentence" "as a block that removes its gating sentence"

# --- writing-a-batch: the opening review (spec section "Opening a batch") ---
require writing-a-batch "the opening review bears on the exact text" "It bears on the exact text of every block"
require writing-a-batch "the text is read in the batch document"     "block by block, in the batch document"
```

- [ ] **Step 2: Vérifier qu'elles échouent**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: huit lignes `[FAIL] writing-a-batch: …`, exactement celles ajoutées, et rien d'autre.

- [ ] **Step 3: Le gabarit**

Dans le bloc de code du gabarit de `## The Batch Document`, remplacer :

```markdown
<The behaviour added to each spec, stated as intention, per module — including
the lifting of any flag an earlier batch declared and this batch takes on.>
```

par :

```markdown
<The exact text this batch writes into the specs, in blocks. Per block: its
`D<n>` identifier, the spec and the section it targets, then the current passage
and the text that replaces it, the passage it removes, or the text it inserts and
where. Including the removal of the gating sentence of any flag an earlier batch
declared and this batch takes on.>
```

- [ ] **Step 4: La prose du delta**

Remplacer le paragraphe :

```markdown
This pull request does **no writing into the specs**. The delta is stated
here as intention only; it is transcribed story by story, each in the pull request of
that story (`supercharlouze:writing-a-user-story`). Transcribing the whole delta
now would put behaviour into the spec that no code delivers — drift by
definition, and the reviewers of a story would then report as missing what is
merely not built yet.
```

par :

```markdown
This pull request does **no writing into the specs**. The delta is
written here as **exact text, in blocks**, and no block is transcribed at
opening: each one is transcribed, word for word, by a story, in that story's own
pull request (`supercharlouze:writing-a-user-story`). Transcribing the whole delta
now would put behaviour into the spec that no code delivers — drift by
definition, and the reviewers of a story would then report as missing what is
merely not built yet.

**A block is the unit of the delta.** Each one carries an identifier `D<n>`,
unique within the batch, and names the spec and the section it targets. To modify
a passage, it quotes the current passage, then the text that replaces it; to
remove one, it quotes it; to add text, it gives that text and where it goes.
Quote the passage as `main` carries it now: the story transcribes against it.

**No block is attached to a story.** The story chooses, as it is written, the
blocks it transcribes; the batch document names no story and carries no list of
them. A section that changes twice in the course of the batch carries two blocks,
and `Constraints` states their order.
```

- [ ] **Step 5: La levée d'un flag hérité**

Dans `## Flags Declared by Earlier Batches`, remplacer :

```markdown
its lifting in the `Spec delta`**, like any other intention. Lifting a flag
removes its gating sentence: it is a change of spec like any other, delivered by
a lifting story (`supercharlouze:writing-a-user-story`), and
`supercharlouze:closing-a-batch` catches it undelivered the way it catches any
intention the delta announced and no story transcribed.
```

par :

```markdown
its lifting in the `Spec delta`**, as a block that removes its gating sentence.
Lifting a flag is a change of spec like any other, delivered by a lifting story
(`supercharlouze:writing-a-user-story`), and `supercharlouze:closing-a-batch`
catches it undelivered the way it catches any block the delta announced and no
story transcribed.
```

(La ligne précédente, `work satisfies one's lifting condition, and your human partner agrees, **state`, ne change pas.)

- [ ] **Step 6: La relecture et la revue d'ouverture**

Dans `## Opening the Pull Request`, remplacer :

```markdown
scope stated with its "why now", spec delta per module, `Constraints` stated or
`none`, `Feature flag` filled, reservations made for every gaps register entry
this batch takes on — corrective or ordinary — and the lifting of any earlier
flag this batch takes on stated in the delta.

Then open the pull request from `batch/NN-<slug>`. Its body states what the
reviewer has to rule on: the flag decision, the scope, and any flag lifting the
delta announces.

**The review of the batch pull request is the human gate.** Until it merges, no
story is written and no spec is touched. It replaces the tail of the
```

par :

```markdown
scope stated with its "why now", spec delta in blocks — each with its `D<n>`,
the spec and section it targets, and its exact text, every quoted passage
matching `main` —, `Constraints` stated or `none`, and stating the order of any
section that carries two blocks, `Feature flag` filled, reservations made for
every gaps register entry this batch takes on — corrective or ordinary — and the
lifting of any earlier flag this batch takes on stated as a block.

Then open the pull request from `batch/NN-<slug>`. Its body states what the
reviewer has to rule on: the exact text of every block, the flag decision, the
scope, and any flag lifting the delta announces.

**The review of the batch pull request is the human gate.** Until it merges, no
story is written and no spec is touched. It bears on the exact text of every
block: this is where the human reads what the specs will say, before any code is
written on it — block by block, in the batch document, and not later as a diff of
the spec. It replaces the tail of the
```

- [ ] **Step 7: Le red flag**

Dans la table `## Red Flags`, ajouter après la ligne qui commence par `| "I'll transcribe the spec delta now, while it's fresh"` :

```markdown
| "The delta only needs to say what changes — the story will find the words" | The delta is the exact text. The opening review is where the human reads what the specs will say; wording left to a story reaches them only once code is built on it. |
```

- [ ] **Step 8: Vérifier qu'elles passent**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: aucune sortie.

- [ ] **Step 9: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: le document de lot écrit son spec delta en blocs de texte exact

La relecture avant ouverture et la revue d'ouverture portent sur le
texte de chaque bloc.

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 3: Plus aucune skill ne parle du delta comme d'une intention

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md` — `## Overview`, `## Preconditions`, le paragraphe `**A flag declared by an earlier batch is not this duty's business.**`, `### 5. Record intentions announced but never delivered`, `## Red Flags`
- Modify: `skills/writing-a-user-story/SKILL.md` — `## Step 7 — Answer the Review`
- Test: `tests/test-skill-contracts.sh`, `tests/test-skill-content.sh` (libellé seulement)

**Interfaces:**
- Consumes: le terme « block » (tâche 1) ; le texte de `writing-a-batch` posé par la tâche 2, qui ne doit plus porter aucune des formes chassées.
- Produces: rien.

Cette tâche change le **vocabulaire** et rien d'autre. La clôture compare toujours, comme aujourd'hui, ce que le delta a annoncé à ce qui a atteint les specs ; le champ `Blocks:` et la comparaison qu'il permet appartiennent à D5 et D7. N'écris ni `Blocks:` ni aucune nouvelle règle de comparaison.

- [ ] **Step 1: Écrire la garde négative, rouge**

Dans `tests/test-skill-contracts.sh`, juste avant la ligne `exit $((FAILURES > 0))`, ajouter :

```bash

# The spec delta is exact text, in blocks (spec section "The batch document"). A
# skill that still calls what a batch announced an "intention" contradicts it.
# The regex hunts only the delta's former name: the content rule's own
# "business rules and intentions", and "the same intention" in the
# other-implementation test, are true sentences and must stay green.
absent "no skill calls the spec delta an intention" \
    "stated as intention|as intention only|like any other intention|an intention like any other|intentions? (the (batch|delta) )?announced|announced intention|announced no intention|an intention not delivered|carries the intention" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module
```

- [ ] **Step 2: Vérifier qu'elle échoue**

Run: `bash tests/test-skill-contracts.sh | grep FAIL`
Expected: exactement `[FAIL] no skill calls the spec delta an intention (present in: writing-a-user-story closing-a-batch)`. Si `writing-a-batch` y figure, la tâche 2 a laissé une forme : corrige-la avant d'aller plus loin. Si `using-batches` ou `adopting-a-module` y figurent, la regex attrape une phrase légitime : arrête-toi et signale-le.

- [ ] **Step 3: `closing-a-batch`**

Dans `skills/closing-a-batch/SKILL.md`, sept remplacements, chacun à l'identique :

1. `## Overview` — `and the intention the batch announced in its spec delta.` → `and the blocks the batch announced in its spec delta.`
2. `## Preconditions` — `the batch document carries the intention you are about to check against what actually shipped.` → `the batch document carries the blocks you are about to check against what actually shipped.`
3. Paragraphe `**A flag declared by an earlier batch is not this duty's business.**` — `removing that flag's gating sentence is an intention like any other: duty 5 catches it undelivered, not this one.` → `removing that flag's gating sentence is a block like any other: duty 5 catches it undelivered, not this one.`
4. Titre — `### 5. Record intentions announced but never delivered` → `### 5. Record blocks announced but never delivered`
5. Duty 5, paragraphe `**A corrective batch has nothing to compare here**` — `so it announced no intention a spec could fall short of.` → `so it announced no block a spec could fall short of.`
6. `## Red Flags` — `Not on main: its reservation and the batch's announced intention are still there.` → `Not on main: its reservation and the blocks the batch announced are still there.`
7. `## Red Flags` — `an announced lifting that did not happen is an intention not delivered.` → `an announced lifting that did not happen is a block not delivered.`

- [ ] **Step 4: `writing-a-user-story`**

Dans `skills/writing-a-user-story/SKILL.md`, `## Step 7 — Answer the Review`, remplacer :

```markdown
reservation posted by the batch's opening pull request, and the intention the
batch announced and never delivered. Both belong to
```

par :

```markdown
reservation posted by the batch's opening pull request, and the blocks the
batch announced and no story delivered. Both belong to
```

- [ ] **Step 5: Le libellé de la garde de duty 5**

Dans `tests/test-skill-content.sh`, remplacer le libellé seulement :

```bash
require closing-a-batch "records undelivered intentions"         "announced but never delivered"
```

par :

```bash
require closing-a-batch "records undelivered blocks"             "announced but never delivered"
```

- [ ] **Step 6: Vérifier que tout passe**

Run: `bash tests/run-all.sh 2>&1 | grep -v "\[PASS\]"`
Expected: les noms des fichiers de test, puis `all tests passed`, sans aucune ligne `[FAIL]`.

- [ ] **Step 7: Commit**

```bash
git add skills/closing-a-batch/SKILL.md skills/writing-a-user-story/SKILL.md tests/test-skill-contracts.sh tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: ce qu'un lot annonce, ce sont des blocs, plus des intentions

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

## Rulings log

## Observed drift
