# 11-us-4 — Le module Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Les skills suivent `Module`, `Module > Module adoption` et `Module > The gaps register` réécrits par D7, D8 et D10.

**Architecture:** L'adoption gagne une relecture de sa spec hors du contexte qui l'a écrite, avec ses lectures et son propre gabarit de lecteur. Les skills qui écrivent au gaps register disent que, dans un lot, seule la pull request de clôture y ajoute des entrées, et qu'un constat supprimé ne se réinscrit que si l'entrée dit ce qui a changé. Le format du register, que la spec ne porte plus, reste dans les skills.

**Tech Stack:** Markdown, garde-fous bash (`tests/*.sh`, lancés par `bash tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/11-la-concision/README.md
**Sections:** Module, Module > Module adoption, Module > The gaps register
**Blocks:** D7, D8, D10

## Global Constraints

Contraintes du lot, recopiées mot pour mot :

- `D28` est transcrit au plus tard avec `D13`, avec `D18` et avec `D29`.
- `D16` et `D25` sont transcrits au plus tard avec `D30`, et `D30` au plus tard avec
  `D9`.
- `D9` est transcrit au plus tard avec `D7`, et `D7` au plus tard avec `D3` et avec
  `D26`.
- `D17` est transcrit au plus tard avec `D6`.
- `D6` et `D12` sont transcrits ensemble.

Gel du fichier de spec :

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

Règle d'autorité : quand le lot et la spec se contredisent, la spec gagne, sans exception ni délibération. Implémenter ce que dit la spec, consigner un `Ruling:`, et poursuivre. Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.

Règles d'écriture du plugin :

- Les skills, leurs `references/`, les commandes, les scripts et les tests sont intégralement en anglais.
- Aucune skill ne cite une section de `docs/specs/supercharlouze.md`. Contrôle : `grep -rnoE '\(\`[A-Z][A-Za-z ]+\`\)' skills/*/SKILL.md` ne gagne aucun résultat (ceux d'aujourd'hui sont tous dans `writing-a-batch`, et renvoient à ses propres sections).
- Tout texte écrit suit `## Concision` de `skills/using-batches/SKILL.md` : une règle par paragraphe, aucune mise en relief, rien qui aille de soi, aucun récit de la façon d'y arriver.
- Un garde-fou se modifie avant le texte qu'il garde, et échoue avant de passer.
- Messages de commit : sujet en français, Conventional Commits, type `feat:`, terminés par `Co-Authored-By: Charlouze <me@charlouze.com>` et aucune autre ligne d'attribution. Tout commit passe par `bash ~/.config/github-app/as-agent.sh git commit ...`.

## Review Focus

- Une lecture de l'adoption abrégée ou paraphrasée dans la skill : le lecteur ne reçoit que ce texte, il doit se suffire.
- Un gabarit de lecteur qui recopie une lecture : il dériverait de la skill au premier amendement.
- Un renvoi `step 7` resté sur l'ancienne ouverture de pull request après la renumérotation.
- Un garde-fou `shared` existant cassé par une réécriture : `Read the file's history before adding an entry`, `the commit that removes it says why`, `What qualifies an entry lives in the entry`, `An entry designates no other entry`, `one list item, never a paragraph of running prose`.
- Une skill qui laisse encore entendre qu'une story, l'ouverture ou un amendement ajoute une entrée au gaps register.

---

### Task 1: L'adoption fait relire sa spec

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md`
- Create: `skills/adopting-a-module/references/reader-prompt.md`
- Test: `tests/test-skill-content.sh`, `tests/test-reader-prompt.sh`

**Interfaces:**
- Produces: la section `### 7. Have the spec reread` et le gabarit `skills/adopting-a-module/references/reader-prompt.md`, dont le créneau de lecture renvoie à l'étape `Have the spec reread` de la skill.

- [ ] **Step 1: Écrire les garde-fous**

Dans `tests/test-skill-content.sh`, après la ligne `require adopting-a-module "promoting a gap removes its entry" ...`, ajouter :

```bash
# --- adopting-a-module: the reread before the pull request ---
require adopting-a-module "the spec is reread outside the writing context" "have the whole spec reread outside the context that wrote it"
require adopting-a-module "a reader takes one reading"                   "A reader takes one reading, on the whole spec"
require adopting-a-module "the rule reading opens as a reader gets it"   "**Does this specification hold what a specification must hold?**"
require adopting-a-module "the concision reading opens as a reader gets it" "**Is this specification precise and concise?**"
require adopting-a-module "a reading is written for a bare reader"       "written for a reader that has nothing else"
require adopting-a-module "the dispatch is composed from its template"   "skills/adopting-a-module/references/reader-prompt.md"
require adopting-a-module "the reread is step 7"                         "### 7. Have the spec reread"
require adopting-a-module "the pull request opens at step 8"             "### 8. Open the adoption pull request"
require adopting-a-module "the rulings go to the pull request body"      "next to its rulings, at the step \`Open the adoption pull request\`"
require adopting-a-module "the red flag names the reread step"          "Dispatch the readers of the step \`Have the spec reread\`"
# The adoption reread counts neither its readings nor its readers, and names
# the steps it points at rather than giving their rank.
case "$(body_flat "$REPO_ROOT/skills/adopting-a-module/SKILL.md")" in
    *[Tt]"wo readings"*|*[Tt]"wo readers"*|*[Bb]"oth readers"*|*"(step 8)"*|*"readers of step 7"*)
        fail "adopting-a-module: the reread counts no reading and ranks no step" ;;
    *)  pass "adopting-a-module: the reread counts no reading and ranks no step" ;;
esac
require adopting-a-module "an intention comes from a document or the human" "An intention comes from a validated document or from your human partner"
```

Dans `tests/test-reader-prompt.sh`, remplacer le commentaire d'en-tête (« The reader prompt is the only artifact of this plugin that a subagent reads instead of the skill, so nothing else guards it. ») par « The reader prompts are the only artifacts of this plugin that a subagent reads instead of the skill, so nothing else guards them. », puis insérer juste avant la dernière ligne `exit $((FAILURES > 0))` :

```bash
# --- the adoption reader prompt ---
# Same contract as the coherence reread's prompt, on one state: an adoption
# reader reads a spec that has no earlier version to diff against.
APROMPT="$REPO_ROOT/skills/adopting-a-module/references/reader-prompt.md"
AFLAT=""
if [ -f "$APROMPT" ]; then
    pass "the adoption reader prompt exists"
    AFLAT="$(tr '\n' ' ' < "$APROMPT" | tr -s ' ')"
else
    fail "the adoption reader prompt exists"
fi

ahas() {
    local label="$1" needle="$2"
    case "$AFLAT" in
        *"$needle"*) pass "adoption: $label" ;;
        *)           fail "adoption: $label" ;;
    esac
}

ahas "one reader carries one reading"     "One reader, one reading, the whole spec"
ahas "the reading comes from the skill"   "one of the readings that the step \`Have the spec reread\` of the skill states, pasted word for word from there"
ahas "the spec is the object"             "The document you are evaluating"
ahas "a reader loads no skill"            "Load no skill"
ahas "everything needed is in the prompt" "Everything you need is in this prompt"
ahas "a finding quotes its passage"       "the passage it bears on, quoted with the section it sits in"
ahas "an empty result is reported"        "Return \"nothing found\" when you found nothing"
ahas "a reader does not revise"           "Do not revise the specification"
ahas "a reader dispatches nothing"        "Do not dispatch subagents"

ABAD=""
for needle in "what a specification must hold" "precise and concise"; do
    case "$AFLAT" in
        *"$needle"*) ABAD="$ABAD '$needle'" ;;
    esac
done
if [ -z "$ABAD" ]; then
    pass "adoption: the prompt restates no reading"
else
    fail "adoption: the prompt restates no reading (found:$ABAD)"
fi

case "$AFLAT" in
    *"one of the two"*|*"neither of them"*|*"step 7"*)
        fail "adoption: the prompt neither counts the readings nor ranks the step" ;;
    *)  pass "adoption: the prompt neither counts the readings nor ranks the step" ;;
esac
```

- [ ] **Step 2: Vérifier que les garde-fous échouent**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-reader-prompt.sh | grep FAIL`
Expected: les nouveaux `require` d'`adopting-a-module` et les assertions `adoption:` échouent ; aucun autre échec.

- [ ] **Step 3: Écrire le gabarit de lecteur**

Créer `skills/adopting-a-module/references/reader-prompt.md` :

```markdown
# Adoption Reread — Reader Prompt

One reader, one reading, the whole spec. Fill every `<…>` slot before
dispatching: a slot left as written is a reader with nothing to read.

The reading is one of the readings that the step `Have the spec reread` of the
skill states, pasted word for word from there. This file restates none of them:
a second copy here would drift from that step.

---

You are reading one specification, written from validated documents and not
yet reviewed. You did not write it, and you are not being asked to improve it.

**The document you are evaluating:** `<path to the spec>`

Read it whole. Everything you report is about this document.

**Your reading, and only yours:**

<the one reading, word for word from the step `Have the spec reread` of the skill>

Load no skill. Everything you need is in this prompt.

**Return, for each finding:** the passage it bears on, quoted with the section it
sits in; what is wrong with that passage under your reading; and how sure you
are. Return "nothing found" when you found nothing: an empty report and a reader
that failed look the same to whoever reads it.

Do not revise the specification: naming what is wrong is your job, deciding what
replaces it is not. Do not dispatch subagents.
```

- [ ] **Step 4: Insérer la relecture dans la skill**

Dans `skills/adopting-a-module/SKILL.md`, renommer `### 7. Open the adoption pull request` en `### 8. Open the adoption pull request`, et insérer avant elle :

```markdown
### 7. Have the spec reread

Before the pull request opens, have the whole spec reread outside the context that
wrote it, by dispatching readers as subagents. This context wrote every sentence
from its own reading of the sources, and rereading them it finds its own
intentions again.

A reader takes one reading, on the whole spec, and the readers are dispatched
together.

Each reading is the text a reader's prompt carries, pasted word for word into the
slot the template leaves for it. It is written for a reader that has nothing else:
never abbreviate it, and never hand a reader two.

> **Does this specification hold what a specification must hold?** Every
> sentence states a business rule or an intention, and passes the
> other-implementation test: a developer who implemented the same intention
> differently would read that sentence as true of their code. A sentence that
> describes a mechanism does not pass it. A business decision that carries a
> number states its value. The specification carries no date, no status and no
> work-in-progress marker, except a feature flag's gating sentence. A rule lives
> in the section of the behaviour it constrains, never in a section named after
> the code's internal parts. A rule that would constrain behaviour observable at
> the boundary of more than one module is a finding. A term borrowed from another
> module's specification is redefined here, reduced to what this one uses, and
> names that specification. Everything is normative at the same level: no
> recommendation, no best practice. Report the sentences that fail, and what each
> breaks.

> **Is this specification precise and concise?** Read every sentence. Each says
> one exact thing, once, and stands on its own. Every paragraph carries one rule.
> A rule says how far it holds, and an exception presents itself as one. A text
> says what it delivers or decides, without telling how it got there or why. No
> sentence is set in relief. A sentence whose removal would cost a reader nothing
> fails; so does a vague word where a concrete rule belongs. Report the sentences
> that fail, and what each breaks.

Compose each dispatch from `skills/adopting-a-module/references/reader-prompt.md`.

Wait for every reader, then work every finding through before anything goes to
your human partner.

A sentence that describes a mechanism leaves the spec for the gaps register,
naming the document it came from.

A rule that reaches past this module's boundary stops the adoption: the breakdown
goes back to your human partner.

Any other finding is fixed in the spec without changing what the sentence rules,
or put to your human partner when fixing it would.

A revision that adds or moves a sentence goes back to the reader whose reading it
concerns.

The reread prepares the adoption gate, it does not replace it.
```

Dans la même skill, remplacer `next to its rulings (step 7)` par ``next to its rulings, at the step `Open the adoption pull request` ``, et `in the **body of the adoption pull request** (step 7)` par ``in the **body of the adoption pull request**, at the step `Open the adoption pull request` ``.

Dans `## Red Flags`, ajouter la ligne :

```markdown
| "I wrote the spec, I can reread it myself" | This context rereads its own intentions. Dispatch the readers of the step `Have the spec reread`. |
```

- [ ] **Step 5: Dire d'où vient une intention**

Dans `## Source Authority`, le paragraphe qui commence par `**And you do not read *through* a mechanism` se termine par « …whether you read that mechanism in the code or in a validated document. ». Ajouter à la suite, dans le même paragraphe : « An intention comes from a validated document or from your human partner. » Le renvoi à la règle de contenu de `supercharlouze:using-batches` reste : cette skill porte toujours la règle, et `test-skill-contracts.sh` exige qu'elle ne vive qu'à un endroit.

- [ ] **Step 6: Vérifier**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

Run: `grep -rnoE '\(\`[A-Z][A-Za-z ]+\`\)' skills/*/SKILL.md`
Expected: les mêmes résultats qu'avant, tous dans `writing-a-batch`.

- [ ] **Step 7: Commit**

```bash
git add skills/adopting-a-module tests/test-skill-content.sh tests/test-reader-prompt.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: l'adoption fait relire sa spec hors du contexte qui l'a écrite" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: Seule la clôture ajoute au gaps register dans un lot

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md`, `skills/using-batches/SKILL.md`, `skills/writing-a-user-story/SKILL.md`, `skills/adopting-a-module/SKILL.md`
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la skill `adopting-a-module` telle que Task 1 la laisse (étapes renumérotées).
- Produces: des phrases écrites à l'identique dans plusieurs skills, gardées par `shared` :
  - `Within a batch, only the closing pull request adds entries to the gaps register`
  - `A finding already deleted from the register is re-entered only if the entry says what has changed since`
  - `An entry is one list item, added at the end of its category`

- [ ] **Step 1: Écrire les garde-fous**

Dans `tests/test-skill-contracts.sh`, juste avant le bloc `# The specs carry no changelog any more.`, ajouter :

```bash
# Within a batch, one pull request adds to a gaps register: the closing one.
# Every skill on the batch path says so in the same words.
shared "only the closing pull request adds entries within a batch" \
    "Within a batch, only the closing pull request adds entries to the gaps register" \
    closing-a-batch using-batches writing-a-user-story

# A finding the register already let go comes back only with what changed.
# The writers that add an entry say so alike.
shared "a deleted finding is re-entered only with what changed" \
    "A finding already deleted from the register is re-entered only if the entry says what has changed since" \
    closing-a-batch using-batches

# The spec no longer carries the register's format; the writers that append
# to it keep it.
shared "the writers that append keep the entry format" \
    "An entry is one list item, added at the end of its category" \
    closing-a-batch using-batches

# The former wording left the batch's adding writer unnamed, and placed an
# entry at the end of a section.
absent "no skill leaves the batch's adding writer unnamed" \
    "one writer per batch|single writer per batch|at the end of a section" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# The gesture table of the adoption lists every writer, the closing that adds
# included.
shared "the adoption's gesture table names the closing that adds" \
    "| Add | \`supercharlouze:closing-a-batch\`, in the batch's closing pull request |" \
    adopting-a-module
```

- [ ] **Step 2: Vérifier que les garde-fous échouent**

Run: `bash tests/test-skill-contracts.sh | grep FAIL`
Expected: les nouvelles assertions échouent ; aucun autre échec.

- [ ] **Step 3: `closing-a-batch`**

Dans `### 2. Consolidate what the story documents left`, remplacer le paragraphe qui commence par « Stories deliberately do not write into the register. » par :

```markdown
Within a batch, only the closing pull request adds entries to the gaps register. Every addition contends with every other on the same module, which is why a batch adds through one pull request.

An entry is one list item, added at the end of its category.
```

Remplacer le paragraphe qui commence par « **Read the file's history before adding an entry** » par :

```markdown
A finding already deleted from the register is re-entered only if the entry says what has changed since.

Read the file's history before adding an entry (`git log -p docs/specs/<module>.gaps.md`). An entry that left this file left for a reason, written in the commit that removed it: resolved, promoted, moot, false, or set aside by your human partner.
```

- [ ] **Step 4: `using-batches`**

Dans `## What Is Kept, What Is Rerouted`, remplacer tout le point `(d)` par :

```markdown
- **(d) It writes to a gaps register directly.** Belonging to no batch, it may both add an entry and delete one in `docs/specs/<module>.gaps.md`, from its own pull request, contending only with another bounded change.

  An entry is one list item, added at the end of its category. When it deletes one, the commit that removes it says why.

  A finding already deleted from the register is re-entered only if the entry says what has changed since. Read the file's history before adding an entry (`git log -p docs/specs/<module>.gaps.md`): what was set aside was set aside for a reason, written in the commit that removed it.

  What qualifies an entry lives in the entry: no prose qualifies a *group* of them, and what an entry's neighbours have in common is repeated in each of them.

  An entry designates no other entry: a settled entry leaves the file whole, and takes with it anything that pointed at it.

  Within a batch, only the closing pull request adds entries to the gaps register: stories record their findings in their own document, and `supercharlouze:closing-a-batch` consolidates them.
```

- [ ] **Step 5: `writing-a-user-story`**

Dans `## Step 6 — Record Before the Merge`, remplacer le paragraphe qui commence par « Do **not** add those observations to the gaps register yourself. » par :

```markdown
Do not add those observations to the gaps register yourself. Within a batch, only the closing pull request adds entries to the gaps register, and `supercharlouze:closing-a-batch` consolidates them there.
```

Dans `## Red Flags`, remplacer la cellule de droite de la ligne « "This drift is small, I'll just add it to the gaps register" » par « Within a batch, only the closing pull request adds entries. Record it under Observed drift. »

- [ ] **Step 6: `adopting-a-module`**

Dans le tableau des gestes de `### 5. Audit the code against the spec`, insérer après la ligne `| Release | ...` :

```markdown
| Add | `supercharlouze:closing-a-batch`, in the batch's closing pull request | appends it at the end of its category; within a batch, no other pull request adds one |
```

- [ ] **Step 7: Vérifier**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

Run: `grep -rnoE '\(\`[A-Z][A-Za-z ]+\`\)' skills/*/SKILL.md`
Expected: les mêmes résultats qu'avant.

- [ ] **Step 8: Commit**

```bash
git add skills tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: seule la clôture ajoute des entrées au gaps register dans un lot" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

Ruling: l'adoption a son propre gabarit de lecteur, `skills/adopting-a-module/references/reader-prompt.md`, au lieu de celui de la relecture de cohérence — son lecteur lit une spec sans version antérieure, alors que l'autre gabarit lui donne deux états à comparer — si c'est faux, deux gabarits presque semblables dérivent l'un de l'autre.

Tranché à la revue : l'humain a retenu une skill commune, `rereading-a-spec`, qui relit une spec neuve comme une spec modifiée avec un seul gabarit de lecteur. L'adoption et la relecture de cohérence l'invoquent, et la spec ne change pas.

Ruling: la lecture « tient-elle ce qu'une spec doit tenir » de l'adoption reprend aussi les tempéraments de `The spec document` (règle qui en contraint plusieurs, glossaire, aparté), et le gabarit transmet la convention d'aparté du projet — avec le seul critère strict, le lecteur signalerait des phrases justes, que la relecture ferait ensuite corriger — si c'est faux, une lecture plus longue qu'un lecteur fait moins à fond.

Ruling: `adopting-a-module` garde son renvoi à la règle de contenu de `supercharlouze:using-batches` et y ajoute qu'une intention vient d'un document validé ou de l'humain — la skill renvoyée porte toujours la règle, et un test exige qu'elle ne vive qu'à cet endroit — si c'est faux, un renvoi que D8 voulait retirer reste dans les skills.

Ruling: les skills gardent ce que D8 et D10 retirent de la spec sans le contredire (la spec ne liste pas ses sources, d'où viennent les gaps d'un contexte à l'autre, les raisons de supprimer une entrée) — le lot déclare qu'aucun autre comportement ne change, et ces détails sont de la méthode — si c'est faux, les skills portent une règle que la spec ne dit plus.

## Observed drift

- Gap — `Module > Module adoption` : la relecture pose aussi à une spec neuve la question « Where does this sit in the model? », que l'étape 7 ne cite pas.
