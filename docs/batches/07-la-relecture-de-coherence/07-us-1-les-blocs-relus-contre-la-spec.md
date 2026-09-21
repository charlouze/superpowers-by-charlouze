# Les blocs relus contre la spec — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Faire lire le spec delta d'un lot contre la totalité de chaque spec
qu'il touche, sur l'état que ses blocs produiront, avant que sa pull request
d'ouverture s'ouvre — au lieu d'une pratique qui ne tient qu'au fait que
quelqu'un pense à la demander.

**Architecture:** Les blocs D1 et D2 sont déjà transcrits dans la spec : c'est le
premier commit de cette branche. D1 crée la sous-section `The coherence reread`
dans `Batch`, D2 range la relecture en étape 5 de `Opening a batch`, avant
l'ouverture de la pull request. Le travail restant est du mécanisme, et il vit
dans `writing-a-batch`, qui reçoit la conduite : une section neuve
`## The Coherence Reread`, placée entre `## Flags Declared by Earlier Batches` et
`## Opening the Pull Request` — l'ordre que la spec impose aux étapes 5 et 6. Les
quatre tâches qui suivent la remplissent, chacune à un point d'ancrage nommé,
dans l'ordre où le lecteur les rencontrera. Chaque norme ajoutée repart avec une
garde dans `tests/test-skill-content.sh`, et la citation de la section de spec
avec une garde dans `tests/test-cross-references.sh`.

**Tech Stack:** Markdown (`skills/*/SKILL.md`, `docs/specs/*.md`), bash
(`tests/*.sh`, exécutés par `tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/07-la-relecture-de-coherence/README.md
**Sections:** Batch, Batch > The coherence reread, Batch > Opening a batch
**Blocks:** D1, D2

## Global Constraints

Les contraintes du lot, recopiées verbatim :

- **Ordre requis.** D1 est transcrit **au plus tard dans la même story** que D2,
  qui le nomme.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`, dans
  la même pull request qu'elle.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**

Le gel du fichier de spec :

> Between the transcription commit and the opening of the pull request, no task
> modifies the spec file. A story that discovers the spec must change stops.

La règle d'autorité : **quand le document de lot et la spec se contredisent, la
spec l'emporte — sans exception et sans délibération.** Implémenter ce que dit la
spec, consigner un `Ruling:`, et continuer. **Corriger une spec en cours de lot
est un acte humain, jamais celui d'un agent.**

---

### Task 1: La relecture de cohérence entre dans la conduite d'une ouverture

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (nouvelle section entre
  `## Flags Declared by Earlier Batches` et `## Opening the Pull Request` ;
  une ligne dans la table `## Red Flags`)
- Test: `tests/test-skill-content.sh`, `tests/test-cross-references.sh`

**Interfaces:**
- Consumes: la sous-section `### The coherence reread` de
  `docs/specs/supercharlouze.md`, déjà transcrite par le premier commit de la
  branche — elle porte les trois questions, que la skill cite sans les redire.
- Produces: la section `## The Coherence Reread` de `skills/writing-a-batch/SKILL.md`,
  que les tâches 2 à 5 remplissent à des points d'ancrage nommés : le paragraphe
  qui commence par `Give each reader`, et le paragraphe qui commence par
  `**The pull request body declares the reread**`.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh`, après le bloc
`# --- writing-a-batch: the opening review (spec section "Opening a batch") ---`
et avant `# --- writing-a-batch: ending the opening and amendment reviews ---` :

```bash
# --- writing-a-batch: the coherence reread (spec section "The coherence reread") ---
# Five assertions: the step exists, the applied state is built outside the
# repository, the rule it must not suspend to get there, the independence of the
# context, and the declaration that makes the whole thing observable. Drop any
# one and the section still reads whole while doing less.
require writing-a-batch "the delta goes through the coherence reread" "Before opening, the whole spec delta goes through the **coherence reread**"
require writing-a-batch "the applied state is built outside the repository" "**outside the repository**"
require writing-a-batch "no block reaches a spec before a story"      "no block is written into a spec before a story transcribes it"
require writing-a-batch "the reread is conducted outside this context" "Conduct it outside the context that wrote the blocks"
require writing-a-batch "the pull request body declares the reread"   "The pull request body declares the reread"
```

Dans `tests/test-cross-references.sh`, assertion 6, étendre la liste des
sections citées :

```bash
for h in "Installing on a project" "The spec document" "Authority and conflict rules" "The coherence reread"; do
```

- [ ] **Step 2: Lancer les gardes et vérifier qu'elles échouent**

Run: `bash tests/test-skill-content.sh` puis `bash tests/test-cross-references.sh`
Expected: cinq `[FAIL] writing-a-batch: ...` pour le premier fichier ; le second
passe déjà, la section de spec existant depuis le premier commit de la branche —
c'est le cas attendu d'une garde de résolution, qui interdit qu'on retire la
section sous la citation.

- [ ] **Step 3: Écrire la section dans la skill**

Dans `skills/writing-a-batch/SKILL.md`, insérer avant
`## Opening the Pull Request` :

```markdown
## The Coherence Reread

Before opening, the whole spec delta goes through the **coherence reread**
(`The coherence reread`). Build the state its blocks produce — a copy of each
touched spec with its blocks applied — **outside the repository**, in a scratch
directory: no block is written into a spec before a story transcribes it, and
that rule is not suspended to make a reread convenient.

**Conduct it outside the context that wrote the blocks**, by dispatching readers
as subagents. This context argued every block into existence; asked to reread
them, it rereads its own intentions — and the passage no block aims at, which is
what this reread exists to find, is precisely what it cannot see.

Give each reader the applied copy, the blocks as the batch document carries them,
and the three questions of `The coherence reread`.

**The pull request body declares the reread**: that it was conducted outside this
context, and what it found — or that it found nothing. A reread nobody can see
from the pull request is a practice again, not a rule.
```

Puis, dans la table `## Red Flags`, ajouter une ligne :

```markdown
| "I wrote these blocks, I can reread them myself" | The context that argued them into existence rereads its intentions, not its text. Dispatch readers outside it. |
```

- [ ] **Step 4: Lancer toute la suite et vérifier qu'elle est verte**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh tests/test-cross-references.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: writing-a-batch conduit la relecture de cohérence avant d'ouvrir

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 2: La lecture du modèle, avec domain-driven-design quand la skill est là

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (section `## The Coherence Reread`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la section `## The Coherence Reread` créée par la tâche 1, et son
  paragraphe d'ancrage commençant par `Give each reader`.
- Produces: le paragraphe commençant par `**One reader reads the model**`, que la
  tâche 3 suit.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh`, à la fin du bloc
`# --- writing-a-batch: the coherence reread ... ---` créé par la tâche 1 :

```bash
# The model reading. The third assertion is the one that matters on a machine
# where the skill is absent: without it, the reread reads as depending on a skill
# this plugin only recommends.
require writing-a-batch "one reader reads the model"            "One reader reads the model"
require writing-a-batch "the model is read with domain-driven-design" "with \`domain-driven-design\` when that skill is available"
require writing-a-batch "the invocation is conditional"         "The invocation is conditional"
```

- [ ] **Step 2: Lancer les gardes et vérifier qu'elles échouent**

Run: `bash tests/test-skill-content.sh`
Expected: trois `[FAIL] writing-a-batch: ...`

- [ ] **Step 3: Écrire le paragraphe**

Dans `skills/writing-a-batch/SKILL.md`, section `## The Coherence Reread`, juste
après le paragraphe `Give each reader the applied copy, ...` :

```markdown
**One reader reads the model**, with `domain-driven-design` when that skill is
available: ubiquitous language, boundaries, where a concept belongs in the model.
It answers none of the three questions and feeds all three. **The invocation is
conditional** — this plugin recommends that skill and depends on it nowhere, so
its absence costs a reader, never the reread.
```

- [ ] **Step 4: Lancer toute la suite et vérifier qu'elle est verte**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: la relecture lit le modèle avec domain-driven-design quand la skill est là

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 3: Tous les lecteurs rendent avant que rien ne remonte

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (section `## The Coherence Reread`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: le paragraphe `**One reader reads the model**` produit par la
  tâche 2, qui sert d'ancrage.
- Produces: le paragraphe commençant par
  `**Every reader returns before anything goes up**`, que la tâche 5 suit.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh`, à la suite des gardes de la tâche 2 :

```bash
# Waiting for every reader. Both assertions are needed: a skill that said to
# gather the findings and reported them as they arrived would satisfy the first
# alone.
require writing-a-batch "every reader returns before anything goes up" "Every reader returns before anything goes up"
require writing-a-batch "no running report"                     "never a running report"
```

- [ ] **Step 2: Lancer les gardes et vérifier qu'elles échouent**

Run: `bash tests/test-skill-content.sh`
Expected: deux `[FAIL] writing-a-batch: ...`

- [ ] **Step 3: Écrire le paragraphe**

Dans `skills/writing-a-batch/SKILL.md`, section `## The Coherence Reread`, juste
après le paragraphe `**One reader reads the model**, ...` :

```markdown
**Every reader returns before anything goes up.** Wait for all of them, gather
their findings, then put them to your human partner — never a running report. A
partial report gets findings ruled on that the next reader displaces, and asks
for the same ruling twice.
```

- [ ] **Step 4: Lancer toute la suite et vérifier qu'elle est verte**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: la relecture attend tous ses lecteurs avant de remonter

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 4: Les deux relectures d'une ouverture ne portent pas sur le même objet

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (section `## The Coherence Reread`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: le premier paragraphe de `## The Coherence Reread`, celui qui
  commence par `Before opening, the whole spec delta`, et la relecture qui ouvre
  déjà `## Opening the Pull Request` — « Before opening, reread the batch
  document against the specs with fresh eyes ».
- Produces: le paragraphe `**Two rereads, two objects.**`, deuxième de la
  section.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh`, à la suite des gardes de la tâche 3 :

```bash
# The two rereads. The third assertion carries the reason the distinction is not
# cosmetic: merged, the pre-opening reread is the one that disappears, and a
# corrective batch loses its only reread.
require writing-a-batch "two rereads, two objects"              "Two rereads, two objects"
require writing-a-batch "the pre-opening reread takes the whole document" "bears on the whole batch document"
require writing-a-batch "merging them strands a corrective batch" "which has no blocks, with no reread at all"
```

- [ ] **Step 2: Lancer les gardes et vérifier qu'elles échouent**

Run: `bash tests/test-skill-content.sh`
Expected: trois `[FAIL] writing-a-batch: ...`

- [ ] **Step 3: Écrire le paragraphe**

Dans `skills/writing-a-batch/SKILL.md`, section `## The Coherence Reread`, juste
après le premier paragraphe (`Before opening, the whole spec delta ...`) :

```markdown
**Two rereads, two objects.** The reread that opens `Opening the Pull Request`
bears on the whole batch document — scope, `Constraints`, the flag field, every
quoted passage. This one bears on the blocks alone and on the state they
produce. Merge them and the first is the one that disappears, leaving a
corrective batch, which has no blocks, with no reread at all.
```

- [ ] **Step 4: Lancer toute la suite et vérifier qu'elle est verte**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: les deux relectures d'une ouverture ne portent pas sur le même objet

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

### Task 5: Quatre conditions arrêtent les tours de relecture

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (section `## The Coherence Reread` ;
  une ligne dans la table `## Red Flags`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: le paragraphe `**Every reader returns before anything goes up.**`
  produit par la tâche 3, qui sert d'ancrage, et le paragraphe
  `**The pull request body declares the reread**`, qui reste le dernier de la
  section.
- Produces: rien que les tâches suivantes consomment — c'est la dernière.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh`, à la suite des gardes de la tâche 4 :

```bash
# The four stop conditions, one assertion each plus the count. The count is what
# catches a condition silently dropped: the four remaining assertions would stay
# green on a list of three that still called itself complete.
require writing-a-batch "four things stop the rounds"           "Four things stop the rounds"
require writing-a-batch "only unread text reopens a round"      "A fresh round only on text the reread has not read"
require writing-a-batch "moving a sentence is an addition"      "moving a sentence is an addition"
require writing-a-batch "two stuck rounds close the wording"    "Two rounds stuck on the same clause close the question of its wording"
require writing-a-batch "a round of declined findings is one too many" "already examined and declined is one round too many"
require writing-a-batch "the reread does not replace the gate"  "prepares the gate, it does not replace it"
```

- [ ] **Step 2: Lancer les gardes et vérifier qu'elles échouent**

Run: `bash tests/test-skill-content.sh`
Expected: six `[FAIL] writing-a-batch: ...`

- [ ] **Step 3: Écrire le paragraphe**

Dans `skills/writing-a-batch/SKILL.md`, section `## The Coherence Reread`, juste
après le paragraphe `**Every reader returns before anything goes up.** ...` et
avant `**The pull request body declares the reread**` :

```markdown
**Four things stop the rounds**, and without them they chain indefinitely.

1. **A fresh round only on text the reread has not read.** A revision that takes
   something out reopens nothing; one that adds a sentence does — and **moving a
   sentence is an addition**, its reach changing with its place.
2. **Two rounds stuck on the same clause close the question of its wording.**
   Take the clause out, or put it to your human partner.
3. **A round returning only findings already examined and declined is one round
   too many.** What is left is a disagreement of judgment, and judgment is
   settled at the gate.
4. **The reread prepares the gate, it does not replace it.**
```

Puis, dans la table `## Red Flags`, ajouter une ligne :

```markdown
| "One more round, the wording can still improve" | Four conditions close the rounds. Two rounds on the same clause end the question of its wording: take it out or put it to your human partner. |
```

- [ ] **Step 4: Lancer toute la suite et vérifier qu'elle est verte**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: quatre conditions arrêtent les tours de relecture

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

## Rulings log

- **La relecture de cohérence reste là où l'ordre des étapes de la spec la met**,
  avant la relecture du document de lot qui ouvre `## Opening the Pull Request`,
  plutôt que d'intervertir les deux. La revue finale a relevé que la relecture du
  document contrôle notamment que chaque passage cité correspond à `main`, et que
  la relecture de cohérence construit donc son état appliqué à partir de blocs
  dont les citations n'ont pas encore été contrôlées. La spec n'ordonne ni l'une
  par rapport à l'autre, et déplacer la relecture existante modifierait un
  passage qu'aucun bloc de ce lot ne touche. **Ce que ça coûte si c'est faux :**
  une relecture conduite sur un état construit depuis un bloc dont la citation ne
  correspond plus à `main` ; la citation périmée ressort à la relecture du
  document un instant plus tard, donc le coût est une relecture perdue, jamais
  une spec fausse.
- **La clause « and that rule is not suspended to make a reread convenient »
  reste.** Elle ferme la seule rationalisation que cette étape neuve crée — « ce
  n'est qu'une copie de travail, juste cette fois » —, ce que le test de
  concision demande d'une phrase. **Ce que ça coûte si c'est faux :** une phrase
  de prose qu'une lecture plus stricte couperait.

## Observed drift
