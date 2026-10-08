# Rereading a Batch Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extraire dans la skill interne `rereading-a-batch` la conduite des relectures d'un lot, que `writing-a-batch` porte aujourd'hui pour l'ouverture et pour l'amendement.

**Architecture:** `rereading-a-batch` reçoit de la skill qui l'invoque le document de lot, les blocs à appliquer, les relectures dues et le chemin des ADR que la pull request écrit ou réécrit. Elle invoque `applying-a-spec-delta`, puis conduit les relectures dans l'ordre cohérence, technique, document, et porte en ref la consigne du lecteur du document. `writing-a-batch` l'invoque à l'ouverture et dans un amendement, et garde ce qui dit quelles relectures sont dues.

**Tech Stack:** Markdown pour les skills, Bash pour la suite de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes

## Global Constraints

### Constraints of the batch

Les skills portent les noms que `Technical design` leur donne.

`using-batches` garde son nom, que le bloc d'instructions des projets installés
cite.

La story qui renomme une skill redonne, avec le nouveau nom, le prompt en attente
qui nomme l'ancien.

Une skill interne porte `user-invocable: false` et une description de la forme
« Use only when a skill tells you to invoke <nom>, never on … ».

Une skill interne nomme les skills qu'elle invoque, jamais celles qui
l'invoquent.

Un texte de plus d'une ou deux phrases que plusieurs skills partagent vit dans une
skill interne, jamais dans une ref.

Une story fusionnée laisse chaque référence `supercharlouze:<nom>` résolue et la
suite de tests verte.

Jusqu'à la story qui transcrit D6, D7 et D8, `Global Constraints` recopie ses
textes, et les contrats `shared` qui les tiennent identiques suivent ces textes
dans les skills qui les portent.

Chaque skill extraite l'est par une story à elle.

Les stories se livrent une à la fois, dans cet ordre, libre entre les skills d'un
même rang que « puis » ne sépare pas :

1. l'outillage des tests ;
2. `following-the-rules` ;
3. `writing-in-a-spec`, `writing-in-a-gaps-register`, `detecting-concurrency`,
   `abandoning-a-story`, `applying-a-spec-delta` et `running-reread-rounds` ;
4. `starting-a-branch`, puis `finishing-a-pr` ;
5. `writing-a-batch-document`, puis `rereading-a-batch` ;
6. `amending-a-batch`, dont la story renomme `writing-a-batch` en
   `opening-a-batch` ;
7. `handling-a-stopped-story`, `making-a-bounded-change`, puis le renommage de
   `writing-a-user-story` en `delivering-a-story`.

La story qui résorbe la violation sur `The gaps register` suit l'extraction de
`amending-a-batch`.

La story qui extrait `following-the-rules` résorbe le gap sur `Code under a
feature flag` et `The user story document`.

D1 et D4 sont transcrits par une même story, qui suit l'extraction de
`handling-a-stopped-story`.

D2 et D3 sont transcrits par une même story, qui suit l'extraction de
`making-a-bounded-change`.

D6, D7 et D8 sont transcrits par une même story, qui suit le renommage en
`delivering-a-story`.

La story qui transcrit D5 suit ce renommage.

### The freeze of the spec file

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

### The authority rule

When the batch and the spec contradict each other, the spec wins, without
exception and without deliberation. Implement what the spec says, record a
`Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
agent's.

### The concision rules

> These rules hold for every document, pull request body and commit message
> this story writes.
>
> Every sentence says one exact thing, once, and stands on its own.
>
> Every paragraph carries one rule.
>
> A rule says how far it holds, and an exception presents itself as one.
>
> A text says what it delivers or decides, without telling how it got there or
> why. Exception: a reason that is explicitly asked for, such as the why of a
> ruling.
>
> No sentence is set in relief: no bold that ranks one sentence above its
> neighbours.

### The stop condition of a technical story

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

### The stop condition on a constraint or an ADR

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

### The ADRs

> The code this story writes holds these ADRs.

- `docs/adr/une-skill-par-moment-d-invocation.md`

### The conditions of an ADR

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

### How this repository is worked

- Tout fichier s'écrit avec l'outil d'écriture ou d'édition de fichiers, jamais par un heredoc, un `sed` ou un `perl` en ligne : l'outil Bash de ce poste mange les barres obliques inverses.
- Un `SKILL.md` et une ref gardent des fins de ligne LF.
- Toute commande `git` qui écrit un commit ou parle au remote passe par `bash ~/.config/github-app/as-agent.sh git …`, `commit --amend` et `rebase` compris.
- Un commit se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et par aucune autre ligne d'attribution.
- La suite entière se lance par `bash tests/run-all.sh`, avec un délai de cinq minutes.
- Une skill de `skills/` est en anglais, et ne cite aucune section de `docs/specs/supercharlouze.md`.
- Une garde s'écrit avant le texte qu'elle tient : chaque tâche montre son étape rouge dans son rapport.

## Review Focus

- Un amendement qui ne devait que la relecture technique et dont l'humain reprend un bloc au spec delta : la relecture de cohérence et celle du document deviennent dues, et l'appelante l'apprend par ce que la skill rend.
- Un lot sans bloc : aucune copie n'est demandée, la relecture de cohérence ne tourne pas, les deux autres tournent.
- Un bloc que `applying-a-spec-delta` rend comme non appliqué : aucune relecture ne démarre tant qu'il en reste un.
- Le lecteur du document ne charge aucune skill : sa consigne ne nomme aucune skill du plugin et se suffit.
- `writing-a-batch` ne garde aucune phrase qui conduit une relecture, et aucune parenthèse vers une section disparue.

Chacun de ces points a sa garde dans la tâche qui écrit le texte.

---

## File Structure

- Create: `skills/rereading-a-batch/SKILL.md` : la conduite des relectures d'un lot.
- Create: `skills/rereading-a-batch/references/document-reader-prompt.md` : la consigne du sous-agent qui relit le document de lot.
- Modify: `skills/writing-a-batch/SKILL.md` : invoque la skill, garde les relectures dues.
- Modify: `tests/skills.txt` : déclare la skill.
- Modify: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`, `tests/test-cross-references.sh` : les gardes.
- Modify: `README.md` : la ligne de la skill.

### Task 1: La skill `rereading-a-batch` et sa ref

**Files:**
- Create: `skills/rereading-a-batch/SKILL.md`
- Create: `skills/rereading-a-batch/references/document-reader-prompt.md`
- Modify: `tests/skills.txt`
- Modify: `tests/test-skill-content.sh`
- Modify: `tests/test-skill-contracts.sh`
- Modify: `tests/test-cross-references.sh`
- Modify: `README.md`

**Interfaces:**
- Consumes: `require`, `shared`, `absent`, `body_flat`, `declared_skills`, `pass`, `fail`, `SKILLS_DIR` de `tests/lib.sh` ; la variable `entry_names` que `tests/test-skill-content.sh` définit avant le point d'insertion.
- Produces: la skill `supercharlouze:rereading-a-batch`, ses sections `The Applied Copies`, `The Coherence Reread`, `The Technical Reread`, `The Batch-Document Reread`, `What It Returns`, et la ref `skills/rereading-a-batch/references/document-reader-prompt.md`. La tâche 2 fait invoquer la skill par `writing-a-batch`.

- [ ] **Step 1: Écrire les gardes de la skill**

Dans `tests/test-skill-content.sh`, juste après la ligne `absent "writing-a-batch-document names no skill that invokes it" "$document_callers|Step [0-9]" writing-a-batch-document`, insérer :

```bash

# --- rereading-a-batch: the rereads of a batch ---
require rereading-a-batch "says what the invoking skill passes" \
    "The skill that invokes it gives: - the batch document; - the blocks to apply; - the rereads due; - the path of each ADR the pull request writes or rewrites."
require rereading-a-batch "the rereads run in order" \
    "Run the rereads due, in this order: the coherence reread, the technical reread, the batch-document reread."
require rereading-a-batch "each reread has its own object" "**Each reread has its own object.**"
require rereading-a-batch "the coherence reread's object is stated" \
    "The coherence reread bears on the blocks and on the state they produce, read whole."
require rereading-a-batch "the technical reread's object is stated" \
    "The technical reread bears on the technical design and the constraints, on the blocks read against the ADRs, and on the ADRs the pull request writes or rewrites."
require rereading-a-batch "the document reread names every field" \
    "The batch-document reread bears on the whole document: \`Scope\`, \`Spec delta\`, \`Technical design\`, \`Constraints\`, \`Feature flag\`."
# Merged into another reread, the batch-document reread disappears wherever
# that one does not run.
require rereading-a-batch "merging them strands a batch without blocks" \
    "leaving a batch that has no blocks without a reread of its document"
require rereading-a-batch "says when to go back to the step that invoked it" \
    "Once the last reread has returned, return what \`What It Returns\` lists, and go on with the step that invoked this skill."
# The applied copies come from `applying-a-spec-delta`, before the first reread
# and again once a reread has touched a block.
require rereading-a-batch "the blocks are applied before the first reread" \
    "Before the first reread, invoke \`supercharlouze:applying-a-spec-delta\` and give it the batch document and the blocks you were given."
require rereading-a-batch "no block, nothing to apply" \
    "Given no block, skip the invocation: each spec is read as it stands."
require rereading-a-batch "the blocks are applied again once a reread touched one" \
    "**Invoke it again each time a reread has changed or added a block**, and give it the blocks as they now read."
require rereading-a-batch "a block that does not apply holds the rereads" \
    "**A block it returns as not applied is a delta gone stale.** Start no reread while one is left."
require rereading-a-batch "a stale block is brought back to its text" \
    "Bring its unchanged and removed lines back to the text it failed to match, and invoke the skill again."
require rereading-a-batch "a block whose added lines no longer fit goes to the human" \
    "When the lines it adds no longer fit that text, put the block to your human partner first."
# The coherence reread.
require rereading-a-batch "the coherence reread reads the applied state" \
    "The coherence reread reads each touched spec whole, on the state its blocks produce."
require rereading-a-batch "no block skips the coherence reread" "**Given no block, skip it.**"
require rereading-a-batch "the skip is not a dispensation" "so with no block it has nothing to read"
require rereading-a-batch "a blockless batch still owes the rereads that follow" \
    "Such a batch still owes the rereads that follow."
require rereading-a-batch "each applied copy goes to the shared reread" \
    "invoke \`supercharlouze:rereading-a-spec\` on each applied copy, with the path of the spec it applies to"
require rereading-a-batch "revisions go back into the blocks" \
    "Carry every revision it returns back into the blocks: into the block whose text it changes, or into a new block when it changes a passage no block targets."
require rereading-a-batch "revised blocks are applied again" \
    "Then have the blocks applied again (\`The Applied Copies\`)."
require rereading-a-batch "a boundary rule stops the rereads" \
    "A rule it returns as reaching past its module's boundary stops the rereads: put the breakdown to your human partner."
# The technical reread.
require rereading-a-batch "the technical reread waits for the coherence reread" \
    "**Start it only once the coherence reread has closed its rounds.** Run side by side, each reread revises what the other is reading"
require rereading-a-batch "the reread is handed the batch document and its specs" \
    "Invoke \`supercharlouze:rereading-a-technical-design\` with the batch document and each spec the batch touches"
require rereading-a-batch "a spec no block targets goes as it is" \
    "its applied copy, or the spec itself when no block targets it"
require rereading-a-batch "the invocation hands the specs, the ADRs and their paths" \
    "Hand it also \`docs/specs/\`, \`docs/adr/\` and the path of each ADR the pull request writes or rewrites."
require rereading-a-batch "a corrected ADR is handed to the reread" \
    "An ADR whose text you corrected on a finding counts among those it rewrites."
require rereading-a-batch "revisions go back into the design" \
    "Carry every revision it returns back into \`Technical design\` and \`Constraints\`"
require rereading-a-batch "the technical reread changes no spec delta" \
    "The technical reread never changes \`Spec delta\`, and sends nothing back through the coherence reread."
require rereading-a-batch "what is taken back sends the batch back to the coherence reread" \
    "**A behaviour or a block it returns as taken back to the spec delta sends the batch back to the coherence reread.**"
require rereading-a-batch "the block taken back is the one the human rules" \
    "Write the block your human partner rules, or correct the block as they correct it, and have the blocks applied again (\`The Applied Copies\`)."
require rereading-a-batch "what is taken back makes the other rereads due" \
    "The coherence reread and the batch-document reread are due from then on, whatever you were given: run the coherence reread, then the technical reread again."
require rereading-a-batch "the technical reread changes no ADR" "It changes no ADR either."
require rereading-a-batch "an ADR corrected on a finding goes back through the reread" \
    "When your human partner has an ADR corrected on a finding it returns, invoke \`supercharlouze:recording-a-decision\` and hand it the applied copies if the correction changes the ADR's decision, and correct the text yourself if it does not. When they abandon the ADR, delete it. After a correction or a deletion, invoke the technical reread again."
# The batch-document reread.
require rereading-a-batch "the document reread comes last" \
    "The batch-document reread comes after the technical reread and bears on the whole document."
require rereading-a-batch "the document reread is conducted outside this context" \
    "Conduct it outside the context that wrote the document, by dispatching a subagent"
require rereading-a-batch "the dispatch is composed from the reader prompt" \
    "Compose the dispatch from \`skills/rereading-a-batch/references/document-reader-prompt.md\`"
require rereading-a-batch "the document is revised on the report" "Revise the document on what it reports."
require rereading-a-batch "says what it returns" \
    "Return: - the batch document, revised; - what each reread you ran found, or that it found nothing, written for a pull request body, and for a technical reread that had nothing to reread, that instead; - each behaviour and each block your human partner took back to the spec delta."
require rereading-a-batch "red flag: rereading one's own blocks" \
    "| \"I wrote these blocks, I can reread them myself\" |"
require rereading-a-batch "red flag: both rereads together" \
    "| \"The rereads read different things, I'll run them together\" | Each revises what the other is reading."
require rereading-a-batch "red flag: rereading one's own design" \
    "Invoke \`supercharlouze:rereading-a-technical-design\`. |"
require rereading-a-batch "red flag: a corrected ADR is reread" \
    "| \"I only corrected the ADR's wording, no need to reread again\" | The corrected text is one no reader has read. Invoke the technical reread again. |"
require rereading-a-batch "red flag: copies left as they were" \
    "| \"The reread only reworded a block, the copies I have are close enough\" |"
require rereading-a-batch "red flag: starting without a block" \
    "| \"One block does not apply, the rereads can start on the others\" |"
require rereading-a-batch "red flag: a block taken back skips the coherence reread" \
    "| \"Only the technical reread was due, the block taken back can skip the coherence reread\" |"
require rereading-a-batch "red flag: checking the document oneself" \
    "| \"I know what each field must hold, I'll check the document myself\" |"
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them.
absent "rereading-a-batch names no skill that invokes it" "${entry_names%|}|Step [0-9]" rereading-a-batch

# --- rereading-a-batch: the prompt of the batch-document reader ---
# A subagent reads this prompt and nothing else: it loads no skill of the
# plugin, so the prompt stands on its own and names none.
DOC_PROMPT="$SKILLS_DIR/rereading-a-batch/references/document-reader-prompt.md"
DOC_FLAT=""
if [ -f "$DOC_PROMPT" ]; then
    pass "the document reader prompt exists"
    DOC_FLAT="$(body_flat "$DOC_PROMPT")"
else
    fail "the document reader prompt exists"
fi
doc_has() {
    case "$DOC_FLAT" in
        *"$2"*) pass "document reader prompt: $1" ;;
        *)      fail "document reader prompt: $1" ;;
    esac
}
doc_has "one reader, one document"           "One reader, one batch document"
doc_has "an unfilled slot reads nothing"     "a slot left as written is a reader with nothing to read"
doc_has "the reader did not write it"        "You did not write it, and you are not being asked to improve it"
doc_has "the batch document is handed over"  "**The batch document:**"
doc_has "the specifications are handed over" "**The specifications:**"
doc_has "a gaps register is no specification" "A gaps register is not a specification"
doc_has "Scope states what the batch delivers" "**\`Scope\`** states what the batch delivers"
doc_has "every entry taken on is named and reserved" \
    "It names every gaps register entry the batch takes on, and each of those entries is reserved for this batch in its gaps register"
doc_has "the delta is filled" \
    "**\`Spec delta\`** is filled: it carries blocks, or \`none\` followed by the reason"
doc_has "the design is filled" \
    "**\`Technical design\`** is filled: it carries the design the stories are planned from, or \`none\` followed by the reason"
doc_has "Constraints are bounded" \
    "**\`Constraints\`** carries only migration and compatibility constraints, the technical decisions the rest of the technical design relies on, and the required order of the stories and of the blocks, or reads \`none\`"
doc_has "the flag field is filled"           "**\`Feature flag\`** is filled"
doc_has "a lifting is a block"               "\`Spec delta\` carries a block that removes that sentence"
doc_has "a finding names its field"          "the field it bears on, the passage quoted, and what is wrong with it"
doc_has "an empty result is reported"        "Return \"nothing found\" when you found nothing"
doc_has "the reader loads no skill"          "Load no skill: everything you need is in this prompt"
doc_has "the reader revises nothing"         "Do not revise the document, and modify no file"
doc_has "the reader dispatches nothing"      "Do not dispatch subagents"
doc_has "the reader runs nothing"            "Run nothing: you read files and search them"
DOC_NAMED=""
for s in $(declared_skills); do
    case "$DOC_FLAT" in
        *"$s"*) DOC_NAMED="$DOC_NAMED $s" ;;
    esac
done
case "$DOC_FLAT" in
    *"supercharlouze:"*|*"superpowers:"*) DOC_NAMED="$DOC_NAMED a-prefixed-skill" ;;
esac
if [ -z "$DOC_NAMED" ]; then
    pass "the document reader prompt names no skill"
else
    fail "the document reader prompt names no skill (named:$DOC_NAMED)"
fi
```

Dans `tests/test-skill-contracts.sh`, juste avant la dernière ligne `exit $((FAILURES > 0))`, insérer :

```bash
# The prompt of the batch-document reader is pasted into the dispatch of a
# subagent that loads no skill, so it copies what it needs from the skills that
# state it. One assertion over both ends, so a copy does not drift.
shared "the document reader is told the bound of Constraints as the document skill states it" \
    "migration and compatibility constraints, the technical decisions the rest of the technical design relies on, and the required order of the stories and of the blocks" \
    writing-a-batch-document rereading-a-batch
shared "the document reader is told the reservation annotation as the register skill states it" \
    "\`reserved by batch-NN\`" \
    writing-in-a-gaps-register rereading-a-batch
shared "the document reader is told the gating sentence as the foundation states it" \
    "🔒 \`billing.recurring\`, off by default" \
    following-the-rules rereading-a-batch

```

Dans `tests/test-cross-references.sh`, juste après le bloc qui teste la ligne de `writing-a-batch-document` (il se termine par un `esac` suivi d'une ligne vide, avant le commentaire `# The rereads use three skills when they are installed`), insérer :

```bash
# The README row of rereading-a-batch, like the other internal skills', says it
# is not for direct use and names none of the skills that invoke it.
BROW="$(grep -F '`supercharlouze:rereading-a-batch`' "$REPO_ROOT/README.md" || true)"
case "$BROW" in
    *"writing-a-batch"*|*"invoked by"*)
        fail "the README row of rereading-a-batch names no caller" ;;
    *)  pass "the README row of rereading-a-batch names no caller" ;;
esac
case "$BROW" in
    *"Never directly"*) pass "the README row of rereading-a-batch rules out direct use" ;;
    *)                  fail "the README row of rereading-a-batch rules out direct use" ;;
esac

```

- [ ] **Step 2: Lancer les gardes, les voir rouges**

Run: `bash tests/test-skill-content.sh | grep -c 'FAIL'` puis `bash tests/test-skill-contracts.sh | grep 'FAIL'` puis `bash tests/test-cross-references.sh | grep 'FAIL'`
Expected: les gardes `rereading-a-batch: …` et `document reader prompt: …` échouent, les trois `shared` échouent avec `missing in: rereading-a-batch`, et `the README row of rereading-a-batch rules out direct use` échoue. Aucune garde d'une autre skill n'échoue.

- [ ] **Step 3: Déclarer la skill**

Dans `tests/skills.txt`, insérer la ligne `rereading-a-batch internal` après la ligne `writing-a-batch-document internal`.

- [ ] **Step 4: Écrire la skill**

Créer `skills/rereading-a-batch/SKILL.md` avec exactement ce contenu :

```markdown
---
name: rereading-a-batch
description: Use only when a skill tells you to invoke rereading-a-batch, never on a request to reread a batch - conducts the rereads a batch owes before its pull request opens, coherence, technical then batch document, and returns the document revised with what each reread found
user-invocable: false
---

# Rereading a Batch

## Overview

This skill conducts the rereads a batch goes through before the pull request
that opens or amends it: the coherence reread, the technical reread and the
batch-document reread.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the rereading-a-batch skill to have this batch reread."

The skill that invokes it gives:

- the batch document;
- the blocks to apply;
- the rereads due;
- the path of each ADR the pull request writes or rewrites.

Run the rereads due, in this order: the coherence reread, the technical reread,
the batch-document reread.

**Each reread has its own object.** The coherence reread bears on the blocks and
on the state they produce, read whole. The technical reread bears on the
technical design and the constraints, on the blocks read against the ADRs, and
on the ADRs the pull request writes or rewrites. The batch-document reread bears
on the whole document: `Scope`, `Spec delta`, `Technical design`, `Constraints`,
`Feature flag`. Merge the batch-document reread into another and it disappears
wherever that one does not run, leaving a batch that has no blocks without a
reread of its document.

Once the last reread has returned, return what `What It Returns` lists, and go
on with the step that invoked this skill.

## The Applied Copies

The coherence reread and the technical reread read each spec with the blocks
applied.

Before the first reread, invoke `supercharlouze:applying-a-spec-delta` and give
it the batch document and the blocks you were given. Given no block, skip the
invocation: each spec is read as it stands.

**Invoke it again each time a reread has changed or added a block**, and give it
the blocks as they now read. The next reread reads the state those blocks
produce, and a block nothing applied was never checked.

**A block it returns as not applied is a delta gone stale.** Start no reread
while one is left. Bring its unchanged and removed lines back to the text it
failed to match, and invoke the skill again. When the lines it adds no longer
fit that text, put the block to your human partner first.

## The Coherence Reread

The coherence reread reads each touched spec whole, on the state its blocks
produce.

**Given no block, skip it.** That is not a dispensation granted to a smaller
batch: this reread reads blocks against the spec they will change, so with no
block it has nothing to read. Such a batch still owes the rereads that follow.

Otherwise invoke `supercharlouze:rereading-a-spec` on each applied copy, with
the path of the spec it applies to.

Carry every revision it returns back into the blocks: into the block whose text
it changes, or into a new block when it changes a passage no block targets.
Then have the blocks applied again (`The Applied Copies`).

A rule it returns as reaching past its module's boundary stops the rereads: put
the breakdown to your human partner.

## The Technical Reread

**Start it only once the coherence reread has closed its rounds.** Run side by
side, each reread revises what the other is reading, and neither reads a state
that holds.

Invoke `supercharlouze:rereading-a-technical-design` with the batch document and
each spec the batch touches: its applied copy, or the spec itself when no block
targets it. Hand it also `docs/specs/`, `docs/adr/` and the path of each ADR the
pull request writes or rewrites. An ADR whose text you corrected on a finding
counts among those it rewrites.

Carry every revision it returns back into `Technical design` and `Constraints`.

The technical reread never changes `Spec delta`, and sends nothing back through
the coherence reread.

**A behaviour or a block it returns as taken back to the spec delta sends the
batch back to the coherence reread.** Write the block your human partner rules,
or correct the block as they correct it, and have the blocks applied again
(`The Applied Copies`). The coherence reread and the batch-document reread are
due from then on, whatever you were given: run the coherence reread, then the
technical reread again.

It changes no ADR either. When your human partner has an ADR corrected on a
finding it returns, invoke `supercharlouze:recording-a-decision` and hand it the
applied copies if the correction changes the ADR's decision, and correct the
text yourself if it does not. When they abandon the ADR, delete it. After a
correction or a deletion, invoke the technical reread again.

## The Batch-Document Reread

The batch-document reread comes after the technical reread and bears on the
whole document.

Conduct it outside the context that wrote the document, by dispatching a
subagent: the context that wrote a document rereads its intentions, not its
text.

Compose the dispatch from
`skills/rereading-a-batch/references/document-reader-prompt.md`, which carries
what the reader checks in each field and what it must return.

Revise the document on what it reports.

## What It Returns

Return:

- the batch document, revised;
- what each reread you ran found, or that it found nothing, written for a pull
  request body, and for a technical reread that had nothing to reread, that
  instead;
- each behaviour and each block your human partner took back to the spec delta.

## Red Flags

| Thought | Reality |
|---------|---------|
| "I wrote these blocks, I can reread them myself" | The context that argued them into existence rereads its intentions, not its text. Invoke `supercharlouze:rereading-a-spec`. |
| "The rereads read different things, I'll run them together" | Each revises what the other is reading. Start the technical reread once the coherence reread has closed its rounds. |
| "I wrote this design, I can reread it myself" | The context that argued it into existence rereads its intentions, not its text. Invoke `supercharlouze:rereading-a-technical-design`. |
| "I only corrected the ADR's wording, no need to reread again" | The corrected text is one no reader has read. Invoke the technical reread again. |
| "The reread only reworded a block, the copies I have are close enough" | The next reread would read a state no block produces, and nothing has checked the reworded block. Have the blocks applied again. |
| "One block does not apply, the rereads can start on the others" | A reread reads the state all the blocks produce. Start none while a block is left unapplied. |
| "Only the technical reread was due, the block taken back can skip the coherence reread" | No reader has read that block against its spec. The coherence reread is due from then on, and the batch-document reread with it. |
| "I know what each field must hold, I'll check the document myself" | The context that wrote the document rereads its intentions. Dispatch the reader. |
```

- [ ] **Step 5: Écrire la consigne du lecteur du document**

Créer `skills/rereading-a-batch/references/document-reader-prompt.md` avec exactement ce contenu :

```markdown
# Batch-Document Reread — Reader Prompt

One reader, one batch document. Fill every `<…>` slot before dispatching: a slot
left as written is a reader with nothing to read.

---

You are rereading one batch document. You did not write it, and you are not
being asked to improve it.

A batch is a group of user stories that changes one or more of the project's
specifications. A human reviews its document before any story is written, so a
field left blank, or one that holds something else than what its name says,
reaches that review as a hole.

**The batch document:** `<path to the batch document>`

**The specifications:** `<the directory of the project's specifications>`

Each module has a specification there, `<module>.md`, and may have a gaps
register beside it, `<module>.gaps.md`. A gaps register is not a specification:
it lists, entry by entry, what no specification describes and where the code
contradicts one. An entry a batch takes on ends with `reserved by batch-NN`,
`NN` being the number of that batch.

Read the batch document whole, then check each point below against it and
against the specifications:

- **`Scope`** states what the batch delivers. It names every gaps register entry
  the batch takes on, and each of those entries is reserved for this batch in
  its gaps register, whether the batch carries blocks or not.
- **`Spec delta`** is filled: it carries blocks, or `none` followed by the
  reason. A block is one change to one specification: it carries an identifier
  `D<n>`, and names the specification and the section it targets.
- **`Technical design`** is filled: it carries the design the stories are
  planned from, or `none` followed by the reason.
- **`Constraints`** carries only migration and compatibility constraints, the
  technical decisions the rest of the technical design relies on, and the
  required order of the stories and of the blocks, or reads `none`.
- **`Feature flag`** is filled: it declares each flag of the batch, or reads
  `none` followed by the reason.
- **The lifting of an earlier flag is a block.** A specification declares a flag
  by a gating sentence, such as 🔒 `billing.recurring`, off by default. When the
  document says the batch lifts a flag an earlier batch declared, `Spec delta`
  carries a block that removes that sentence.

Whether the lines of a block match the specification it targets is not yours to
check: that check is made elsewhere.

**Return, for each finding:** the field it bears on, the passage quoted, and
what is wrong with it. Return "nothing found" when you found nothing: an empty
report and a reader that failed look the same to whoever reads it.

Load no skill: everything you need is in this prompt. Do not revise the
document, and modify no file: naming what is wrong is your job, deciding what
replaces it is not. Do not dispatch subagents. Run nothing: you read files and
search them.
```

- [ ] **Step 6: Ajouter la ligne du `README`**

Dans `README.md`, après la ligne du tableau `| \`supercharlouze:writing-a-batch-document\` | … |`, ajouter :

```markdown
| `supercharlouze:rereading-a-batch` | Never directly — a building block the other skills invoke to conduct the rereads a batch owes before its pull request opens: coherence, technical, then batch document |
```

- [ ] **Step 7: Lancer la suite entière, la voir verte**

Run: `bash tests/run-all.sh` (délai de cinq minutes)
Expected: aucune ligne `[FAIL]`. Si une garde négative d'une autre skill refuse une formule de la skill ou de la ref, reformuler la phrase sans changer ce qu'elle demande, ajuster la garde de l'étape 1 qui la tient, et le dire dans le rapport.

- [ ] **Step 8: Commit**

```bash
git add skills/rereading-a-batch tests README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la skill interne rereading-a-batch conduit les relectures d'un lot" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: `writing-a-batch` invoque la skill

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md`
- Modify: `tests/test-skill-content.sh`
- Modify: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la skill `supercharlouze:rereading-a-batch` de la tâche 1, qui reçoit le document de lot, les blocs à appliquer, les relectures dues et le chemin de chaque ADR que la pull request écrit ou réécrit, et qui rend le document révisé, ce que chaque relecture a trouvé, et chaque comportement ou bloc repris au spec delta.
- Produces: rien qu'une tâche ultérieure consomme.

- [ ] **Step 1: Remplacer les gardes de `writing-a-batch` dans `tests/test-skill-content.sh`**

Supprimer chaque `require writing-a-batch` dont le libellé (deuxième argument) est dans cette liste, avec les lignes de commentaire qui ne parlent que de lui. Le texte que ces gardes tenaient vit désormais dans `rereading-a-batch`, où la tâche 1 le garde.

```text
its blocks are applied with every pending block
its applied copies go to the shared reread
its whole document goes through the document reread
an amendment goes through the technical reread
its technical reread is the opening's
its technical reread reads the pending blocks applied
its technical reread has the pending blocks applied
what is taken back sends the amendment through both rereads
the document reread checks the widened Constraints
the document reread checks the field
the document reread checks the design field
the document reread names every field
the coherence reread is step 5
the technical reread is step 6
the document reread is step 7
the pull request is step 8
the document reread is named where it runs
each reread has its own object
the technical reread's object is stated
the document reread takes the whole document
the document reread is conducted outside this context
merging them strands a corrective batch
the delta goes through the coherence reread
a blockless delta skips this reread
the skip is not a dispensation
a blockless batch still owes the rereads that follow
step 5 states the skip where it is ordered
the coherence reread has every block applied
each applied copy goes to the shared reread
revisions go back into the blocks
a boundary rule stops the opening
the pull request body says what the reread found
the batch goes through the technical reread
the technical reread is invoked for every batch
the invocation hands the specs, the ADRs and their paths
a block taken back restarts the delta
the technical reread changes no ADR
an ADR corrected on a finding goes back through the reread
a corrected ADR is handed to the reread
the reread is handed the batch document and its specs
a spec no block targets goes as it is
revisions go back into the design
the technical reread changes no spec delta
a behaviour taken back restarts the delta
the technical reread waits for the coherence reread
red flag: both rereads together
the pull request body says what it found
the pull request body says when there was nothing to reread
the red flag sends the design to the reread
red flag: skipping the technical reread
red flag: a corrected ADR is reread
```

Les titres de commentaire `# --- writing-a-batch: the coherence reread (…) ---` et `# --- writing-a-batch: the technical reread (…) ---` disparaissent avec leurs gardes. Garder le titre `# --- writing-a-batch: the ordered opening, and the rereads it places ---` et remplacer le commentaire qui le suit par celui du bloc ci-dessous.

Juste après la ligne `require writing-a-batch "step 3 ends on the ADRs" …`, insérer :

```bash
# The opening places the rereads and says which are due; `rereading-a-batch`
# conducts them.
require writing-a-batch "the rereads are step 5" \
    "5. **Have the batch reread**: the coherence reread, the technical reread and the batch-document reread (\`The Rereads\`)."
require writing-a-batch "the pull request is step 6" \
    "6. **Open the pull request** from \`batch/NN-<slug>\`"
require writing-a-batch "the opening has its rereads conducted by the shared skill" \
    "Invoke \`supercharlouze:rereading-a-batch\` and give it the batch document, every block of its spec delta, those rereads as the rereads due, and the path of each ADR this pull request writes or rewrites."
require writing-a-batch "an opening owes every reread" \
    "**An opening owes every reread, whatever the batch carries.** A reread that has nothing to read says so itself."
require writing-a-batch "the pull request body says what each reread found" \
    "The body of the pull request, opening or amendment, says what each reread found, or that it found nothing."
require writing-a-batch "the pull request body says when there was nothing to reread" \
    "When the technical reread returned that it had nothing to reread, the body says that instead."
require writing-a-batch "a reread is visible from the pull request" \
    "A reread nobody can see from the pull request is a practice again, not a rule."
require writing-a-batch "red flag: skipping the technical reread" \
    "| \"The batch has no design and no constraints, I'll skip the technical reread\" | An opening owes every reread. The technical reread says itself when it has nothing to reread, and it rereads the ADRs this pull request writes. |"
```

Juste après la ligne `require writing-a-batch "a delta amendment is reviewed as an opening" …`, insérer :

```bash
# An amendment says which rereads it owes by what it changes, and passes them.
require writing-a-batch "an amendment owes the technical reread" \
    "An amendment that changes the spec delta, the technical design or the constraints, or that writes or rewrites an ADR, owes the technical reread."
require writing-a-batch "a delta amendment owes the other rereads as well" \
    "One that changes the spec delta owes the coherence reread and the batch-document reread as well."
require writing-a-batch "an amendment has its rereads conducted by the shared skill" \
    "invoke \`supercharlouze:rereading-a-batch\` and give it the amended document, its new or changed blocks together with every block no merged story has declared yet, the rereads it owes, and the path of each ADR it writes or rewrites"
```

Les gardes `a behaviour or a block taken back makes a delta amendment` et `its body carries what an opening body carries` restent telles quelles.

- [ ] **Step 2: Mettre à jour les contrats dans `tests/test-skill-contracts.sh`**

1. Remplacer la garde `require writing-a-batch "invokes applying-a-spec-delta with the batch document and the blocks" …` (deux lignes) par :

```bash
for s in writing-a-batch rereading-a-batch; do
    require "$s" "invokes applying-a-spec-delta with the batch document and the blocks" \
        "nvoke \`supercharlouze:applying-a-spec-delta\` and give it the"
done
```

2. Dans la garde `absent "the batch-document reread leaves the blocks to the coherence reread"`, remplacer la liste `writing-a-batch` par `writing-a-batch rereading-a-batch`.

3. Dans le contrat `shared "the skills that have a spec reread invoke the shared reread"`, remplacer la liste `adopting-a-module writing-a-batch` par `adopting-a-module rereading-a-batch`.

4. Dans les gardes `absent "no calling skill carries readings of its own"` et `absent "no calling skill says what a reader gets"`, remplacer la liste `adopting-a-module writing-a-batch` par `adopting-a-module writing-a-batch rereading-a-batch`.

5. Dans les gardes `absent "the batch skill carries no technical reading of its own"`, `absent "the opening no longer skips the technical reread"` et `absent "the opening counts no rereads"`, remplacer la liste `writing-a-batch` par `writing-a-batch rereading-a-batch`.

6. Juste après le bloc `absent "no other skill restates how the applied copies are built" …`, insérer :

```bash

# The rereads of a batch are conducted in one place, `rereading-a-batch`. A
# skill whose pull request owes them invokes it, and passes the batch document,
# the blocks to apply, the rereads due and the ADRs the pull request writes or
# rewrites.
require writing-a-batch "invokes rereading-a-batch to have a batch reread" \
    "nvoke \`supercharlouze:rereading-a-batch\` and give it"
# How they are conducted is spelled there and nowhere else. Walks the declared
# skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates how a batch is reread" \
    "Carry every revision it returns back into|coherence reread has closed its rounds|on each applied copy|outside the context that wrote the document|back to the coherence reread|changed or added a block|returns as not applied" \
    $(declared_skills | grep -vx rereading-a-batch)
# The batch skill reaches the two rereads through that skill only.
absent "the batch skill invokes neither reread itself" \
    "supercharlouze:rereading-a-spec|supercharlouze:rereading-a-technical-design" \
    writing-a-batch
```

- [ ] **Step 3: Lancer les gardes, les voir rouges**

Run: `bash tests/test-skill-content.sh | grep 'FAIL'` puis `bash tests/test-skill-contracts.sh | grep 'FAIL'`
Expected: les gardes neuves de `writing-a-batch` échouent, `no other skill restates how a batch is reread` échoue avec `present in: writing-a-batch`, `the batch skill invokes neither reread itself` échoue. Aucune garde de `rereading-a-batch` n'échoue.

- [ ] **Step 4: Réécrire `skills/writing-a-batch/SKILL.md`**

a. Dans `## Opening, in Order`, remplacer les étapes 5 à 8 et le paragraphe `**The rereads are steps 5, 6 and 7, and each has its own object.** …` (jusqu'à `without a reread of its document.`) par :

```markdown
5. **Have the batch reread**: the coherence reread, the technical reread and the
   batch-document reread (`The Rereads`).
6. **Open the pull request** from `batch/NN-<slug>` (`Opening the Pull Request`).
```

b. Remplacer les sections `## The Coherence Reread` et `## The Technical Reread`, en entier, par cette seule section :

```markdown
## The Rereads

Before the pull request opens, the batch goes through the coherence reread, the
technical reread and the batch-document reread.

Invoke `supercharlouze:rereading-a-batch` and give it the batch document, every
block of its spec delta, those rereads as the rereads due, and the path of each
ADR this pull request writes or rewrites.

**An opening owes every reread, whatever the batch carries.** A reread that has
nothing to read says so itself.

The body of the pull request, opening or amendment, says what each reread found,
or that it found nothing. When the technical reread returned that it had nothing
to reread, the body says that instead. A reread nobody can see from the pull
request is a practice again, not a rule.
```

c. Dans `## Opening the Pull Request`, supprimer le premier paragraphe, de `**The batch-document reread**, step 7, comes after the technical reread` à `Revise the document on what it reports.`, et faire commencer le paragraphe suivant par `Open the pull request from \`batch/NN-<slug>\`.` à la place de `Then open the pull request from \`batch/NN-<slug>\`.`. Plus bas dans la même section, remplacer `the self-review becomes the batch-document reread above` par `the self-review becomes the batch-document reread`.

d. Dans `## Amending a Batch`, remplacer les trois paragraphes qui vont de `By exception, an amendment that changes the spec delta is reviewed as an opening.` à `puts the whole document through the batch-document reread.` par :

```markdown
By exception, an amendment that changes the spec delta is reviewed as an
opening. Its body states the exact text of every new or changed block, and what
the coherence reread found.

An amendment that changes the spec delta, the technical design or the
constraints, or that writes or rewrites an ADR, owes the technical reread. One
that changes the spec delta owes the coherence reread and the batch-document
reread as well.

Before the pull request of an amendment that owes a reread opens, invoke
`supercharlouze:rereading-a-batch` and give it the amended document, its new or
changed blocks together with every block no merged story has declared yet, the
rereads it owes, and the path of each ADR it writes or rewrites.

A behaviour or a block it returns as taken back to the spec delta makes the
amendment one that changes the spec delta.
```

e. Dans `## Red Flags`, supprimer les quatre lignes dont la première cellule est `"I wrote these blocks, I can reread them myself"`, `"The rereads read different things, I'll run them together"`, `"I wrote this design, I can reread it myself"` et `"I only corrected the ADR's wording, no need to reread again"`, et remplacer la ligne `"The batch has no design and no constraints, I'll skip the technical reread"` par :

```markdown
| "The batch has no design and no constraints, I'll skip the technical reread" | An opening owes every reread. The technical reread says itself when it has nothing to reread, and it rereads the ADRs this pull request writes. |
```

f. Vérifier qu'il ne reste dans le fichier ni `The Coherence Reread`, ni `The Technical Reread`, ni `step 5`, `step 6`, `step 7`, ni `supercharlouze:rereading-a-spec`, ni `supercharlouze:rereading-a-technical-design` : `grep -nE 'The Coherence Reread|The Technical Reread|step [5-8]|rereading-a-spec|rereading-a-technical-design' skills/writing-a-batch/SKILL.md` ne rend rien.

- [ ] **Step 5: Lancer la suite entière, la voir verte**

Run: `bash tests/run-all.sh` (délai de cinq minutes)
Expected: aucune ligne `[FAIL]`. Une garde de `writing-a-batch` qui échoue encore et dont le texte a suivi la relecture dans `rereading-a-batch` se déplace sur cette skill ou disparaît si la tâche 1 la tient déjà ; le dire dans le rapport.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-batch tests
bash ~/.config/github-app/as-agent.sh git commit -m "feat: writing-a-batch fait conduire ses relectures par rereading-a-batch" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

## Observed drift
