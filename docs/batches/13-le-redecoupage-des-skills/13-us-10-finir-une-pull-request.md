# L'extraction de la skill interne `finishing-a-pr` Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La skill interne `finishing-a-pr` porte le déroulé de la fin d'une revue, et les skills dont la pull request est revue l'invoquent à la place de leur copie.

**Architecture:** `finishing-a-pr` reçoit les conditions que l'annonce attend et l'étape suivante avec son document. Elle porte les gestes dans leur ordre, et renvoie à `The Git Model` de `following-the-rules` pour les règles et pour la forme du prompt. `adopting-a-module`, `writing-a-batch` pour l'ouverture et pour l'amendement, `closing-a-batch` et `writing-a-user-story` l'invoquent en lui passant ce qui varie. Les contrats `shared` qui tenaient les copies deviennent des gardes sur la skill, une garde par appelante et une garde négative.

**Tech Stack:** Markdown pour les skills, bash pour les gardes de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes

## Global Constraints

Avant de commencer, invoque `supercharlouze:following-the-rules` si la skill est disponible dans ta session.

Toute commande `git` qui écrit un commit ou parle au remote passe par `bash ~/.config/github-app/as-agent.sh git …`, y compris `rebase`, `commit --amend` et `cherry-pick`.

Un commit se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et par aucune autre ligne d'attribution.

Les fichiers s'écrivent avec l'outil d'écriture ou d'édition de fichiers, jamais par un heredoc, un `sed` ou un `perl` en ligne : l'outil Bash de ce poste mange les barres obliques inverses.

Un `SKILL.md` garde des fins de ligne LF.

Le poste n'a ni `python` ni `node`.

Les skills sont en anglais. Une skill ne cite aucune section de `docs/specs/supercharlouze.md`.

Chaque tâche montre l'étape rouge de ses gardes avant d'écrire le texte qu'elles tiennent.

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

When the batch and the spec contradict each other, the spec wins — without
exception and without deliberation. Implement what the spec says, record a
`Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
agent's.

### Concision

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

### A decision worth an ADR

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

## Review Focus

- Une appelante garde une phrase qui redit le déroulé : la garde négative de la tâche 2 la refuse.
- Une appelante aplatit ce qu'elle passait : chaque appelante a une garde sur sa condition et sur son étape suivante.
- `finishing-a-pr` nomme une skill qui l'invoque : une garde le refuse.
- Le socle `skills/following-the-rules/SKILL.md` change : aucune tâche ne le touche, et ses gardes restent telles quelles.
- Une garde d'un autre fichier de `tests/` tient encore une copie retirée : la suite entière tourne à la fin de chaque tâche.

---

## File Structure

- Create: `skills/finishing-a-pr/SKILL.md`, le déroulé de la fin d'une revue.
- Modify: `tests/skills.txt`, la déclaration de la skill.
- Modify: `tests/test-skill-content.sh`, les gardes de la skill et celles des appelantes.
- Modify: `tests/test-skill-contracts.sh`, les contrats `shared` remplacés.
- Modify: `tests/test-cross-references.sh`, la ligne du `README`.
- Modify: `README.md`, le tableau des skills.
- Modify: `skills/adopting-a-module/SKILL.md`, `skills/writing-a-batch/SKILL.md`, `skills/closing-a-batch/SKILL.md`, `skills/writing-a-user-story/SKILL.md`, qui invoquent la skill.

Ce que chaque appelante passe :

| Appelante | Conditions | Étape suivante | Document | Ce que le prompt dit de plus |
|---|---|---|---|---|
| `adopting-a-module` | aucune | `supercharlouze:writing-a-batch` | la spec adoptée, par son chemin, avec le gaps register à côté | rien |
| `writing-a-batch`, ouverture | aucune | `supercharlouze:writing-a-user-story` | le document de lot | choisir les blocs parmi ceux que le document porte encore |
| `writing-a-batch`, amendement | aucune | ce que le lot faisait quand il s'est arrêté, avec la skill qui le conduit | le document de lot amendé | rien |
| `closing-a-batch` | aucune | aucune | | |
| `writing-a-user-story` | aucun `Open ruling:` sans destination dans le `Rulings log` | la story suivante, par `supercharlouze:writing-a-user-story`, ou `supercharlouze:closing-a-batch` quand la story a pris les derniers blocs | le document de lot | pour la story suivante, choisir parmi les blocs qu'aucune story fusionnée n'a déclarés |

---

### Task 1: La skill `finishing-a-pr`

**Files:**
- Create: `skills/finishing-a-pr/SKILL.md`
- Modify: `tests/skills.txt`
- Modify: `tests/test-skill-content.sh`
- Modify: `tests/test-cross-references.sh`
- Modify: `README.md`

**Interfaces:**
- Consumes: `require`, `absent`, `skill_text`, `declared_skills` de `tests/lib.sh` ; la variable `entry_names` que `tests/test-skill-content.sh` définit avant la section de `writing-in-a-gaps-register`.
- Produces: la skill `supercharlouze:finishing-a-pr`, que la tâche 2 fait invoquer par la phrase ``invoke `supercharlouze:finishing-a-pr` and give it``.

- [ ] **Step 1: Déclare la skill et écris ses gardes**

Dans `tests/skills.txt`, ajoute cette ligne après `starting-a-branch internal` :

```
finishing-a-pr internal
```

Dans `tests/test-skill-content.sh`, ajoute cette section juste après la ligne `absent "starting-a-branch names no skill that invokes it" …` :

```bash

# --- finishing-a-pr: the end of a review ---
require finishing-a-pr "says what the invoking skill passes" \
    "The skill that invokes it gives the conditions the announcement waits on, or none, and the next step, or none."
require finishing-a-pr "says what a next step comes with" \
    "A next step comes with the skill that conducts it and the document it starts from, and with what else its prompt must say when there is anything."
require finishing-a-pr "points at the rules of the foundation" \
    "The rules this skill applies are those of \`The Git Model\` in \`supercharlouze:following-the-rules\`"
require finishing-a-pr "pushes a correction as a fixup" \
    "**Push each correction the review asks for as a \`fixup!\` commit of the commit it corrects.**"
require finishing-a-pr "a fresh decision is a commit of its own" \
    "A correction that carries a fresh decision is a commit of its own: a review that changes the wording of a spec change is deciding something, not fixing a slip."
require finishing-a-pr "waits for the agreement in the conversation" \
    "**Wait for your human partner's agreement, given in the conversation.**"
require finishing-a-pr "checks the conditions it was given" \
    "**Check each condition you were given.**"
require finishing-a-pr "a condition that does not hold sends back to the review" \
    "When one does not hold, say which one, squash nothing and go back to the review"
require finishing-a-pr "squashes the fixups and pushes" \
    "**Squash the \`fixup!\` commits into the commits they correct, and push the rewritten branch.**"
require finishing-a-pr "announces the pull request ready" \
    "**Announce that the pull request is ready to be approved and merged.**"
# Corrections, the agreement, the conditions, the squash, then the announcement.
skill_text finishing-a-pr
case "$SKILL_TEXT" in
    *"**Push each correction"*"**Wait for your human partner's agreement"*"**Check each condition you were given.**"*"**Squash the "*"**Announce that the pull request is ready"*"When your human partner announces the merge"*)
        pass "finishing-a-pr: corrections, agreement, conditions, squash, announcement, then the merge" ;;
    *)  fail "finishing-a-pr: corrections, agreement, conditions, squash, announcement, then the merge" ;;
esac
require finishing-a-pr "acts on the merge announcement" \
    "When your human partner announces the merge"
require finishing-a-pr "asks for a clear context" "**Ask them to clear the context.**"
require finishing-a-pr "gives the prompt of the next step" \
    "**If you were given a next step, name it and give, in a block to copy and paste, the prompt that starts it in a fresh context.**"
require finishing-a-pr "the prompt names the skill and the document" \
    "The prompt names the skill to invoke and the document to start from, by its path, says what else you were given for it, and never refers back to this conversation."
require finishing-a-pr "no next step, no prompt" "Without a next step, give no prompt."
require finishing-a-pr "red flag: amending instead of a fixup" \
    "| \"The correction is tiny, I'll amend the commit and force-push\" | A force-push mid-review replaces the commits your human partner has comments on. Push a \`fixup!\`. |"
require finishing-a-pr "red flag: a GitHub approval is not the agreement" \
    "| \"They approved on GitHub, that is their agreement\" | The agreement is given in the conversation. Ask for it there before you squash. |"
require finishing-a-pr "red flag: a condition settled after the merge" \
    "| \"They agreed, the condition can be settled after the merge\" | After the merge the branch is gone and nothing settles it. Go back to the review. |"
require finishing-a-pr "red flag: merging oneself" \
    "| \"They agreed, I can merge it myself\" | Approving and merging are your human partner's acts. Announce the pull request ready and wait. |"
require finishing-a-pr "red flag: the prompt given at the ready announcement" \
    "| \"The pull request is ready, I'll give the next prompt now\" | The review may go on and bury it, or change the document it names. Give it when the merge is announced. |"
require finishing-a-pr "says when to go back to the step that invoked it" \
    "Once you have answered the merge announcement, go on with the step that invoked this skill."
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them.
absent "finishing-a-pr names no skill that invokes it" "${entry_names%|}|Step [0-9]" finishing-a-pr
```

Dans `tests/test-cross-references.sh`, ajoute ce bloc juste après le bloc qui se termine par `fail "the README row of starting-a-branch rules out direct use" ;;` et son `esac` :

```bash

# The README row of finishing-a-pr, like the other internal skills', says it is
# not for direct use and names none of the skills that invoke it.
FROW="$(grep -F '`supercharlouze:finishing-a-pr`' "$REPO_ROOT/README.md" || true)"
case "$FROW" in
    *"adopting-a-module"*|*"writing-a-batch"*|*"writing-a-user-story"*|*"closing-a-batch"*|*"invoked by"*)
        fail "the README row of finishing-a-pr names no caller" ;;
    *)  pass "the README row of finishing-a-pr names no caller" ;;
esac
case "$FROW" in
    *"Never directly"*) pass "the README row of finishing-a-pr rules out direct use" ;;
    *)                  fail "the README row of finishing-a-pr rules out direct use" ;;
esac
```

- [ ] **Step 2: Lance les gardes et constate le rouge**

Run: `bash tests/test-skill-content.sh | grep -c "FAIL.*finishing-a-pr"` puis `bash tests/test-cross-references.sh | grep "finishing-a-pr"` puis `bash tests/test-skill-frontmatter.sh | grep FAIL`

Expected: toutes les gardes `require` de `finishing-a-pr` échouent, la garde `absent` échoue par « no such skill », la ligne « rules out direct use » du `README` échoue, et `test-skill-frontmatter.sh` échoue sur la skill déclarée sans répertoire.

- [ ] **Step 3: Écris la skill**

Crée `skills/finishing-a-pr/SKILL.md` avec exactement ce contenu :

````markdown
---
name: finishing-a-pr
description: Use only when a skill tells you to invoke finishing-a-pr, never on a request to finish or merge a pull request - conducts the end of a pull request's review, from its corrections to the squash and the announcement that it is ready, then asks for a clear context when the merge is announced and gives the prompt of the next step
user-invocable: false
---

# Finishing a PR

## Overview

This skill conducts the end of a pull request's review, then answers the
announcement of its merge.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the finishing-a-pr skill to end this review."

The skill that invokes it gives the conditions the announcement waits on, or
none, and the next step, or none.

A next step comes with the skill that conducts it and the document it starts
from, and with what else its prompt must say when there is anything.

The rules this skill applies are those of `The Git Model` in
`supercharlouze:following-the-rules`: this skill carries the gestures, in their
order.

Once you have answered the merge announcement, go on with the step that invoked
this skill.

## The Review

1. **Push each correction the review asks for as a `fixup!` commit of the commit
   it corrects.** A correction that carries a fresh decision is a commit of its
   own: a review that changes the wording of a spec change is deciding
   something, not fixing a slip.
2. **Wait for your human partner's agreement, given in the conversation.**
3. **Check each condition you were given.** When one does not hold, say which
   one, squash nothing and go back to the review: it goes on until the
   condition holds and your human partner agrees again.
4. **Squash the `fixup!` commits into the commits they correct, and push the
   rewritten branch.**
5. **Announce that the pull request is ready to be approved and merged.**

## The Merge

When your human partner announces the merge:

1. **Ask them to clear the context.**
2. **If you were given a next step, name it and give, in a block to copy and
   paste, the prompt that starts it in a fresh context.** The prompt names the
   skill to invoke and the document to start from, by its path, says what else
   you were given for it, and never refers back to this conversation.

Without a next step, give no prompt.

## Red Flags

| Thought | Reality |
|---------|---------|
| "The correction is tiny, I'll amend the commit and force-push" | A force-push mid-review replaces the commits your human partner has comments on. Push a `fixup!`. |
| "They approved on GitHub, that is their agreement" | The agreement is given in the conversation. Ask for it there before you squash. |
| "They agreed, the condition can be settled after the merge" | After the merge the branch is gone and nothing settles it. Go back to the review. |
| "They agreed, I can merge it myself" | Approving and merging are your human partner's acts. Announce the pull request ready and wait. |
| "The pull request is ready, I'll give the next prompt now" | The review may go on and bury it, or change the document it names. Give it when the merge is announced. |
````

Dans `README.md`, ajoute cette ligne au tableau des skills, après la ligne de `supercharlouze:starting-a-branch` :

```markdown
| `supercharlouze:finishing-a-pr` | Never directly — a building block the other skills invoke to end a pull request's review: its corrections, the squash, the announcement that it is ready, then the clear context its merge calls for |
```

- [ ] **Step 4: Lance la suite entière et constate le vert**

Run: `bash tests/run-all.sh > "$TMPDIR/us10-t1.txt" 2>&1; tail -1 "$TMPDIR/us10-t1.txt"; grep FAIL "$TMPDIR/us10-t1.txt"`

La suite prend environ trois minutes : lance-la en arrière-plan ou avec un délai d'au moins cinq minutes.

Expected: `all tests passed`, aucune ligne `FAIL`.

Si une garde négative d'un autre fichier échoue sur le texte de la skill, arrête-toi et rapporte la garde et la phrase, sans retoucher ni l'une ni l'autre.

- [ ] **Step 5: Commit**

```bash
git add skills/finishing-a-pr tests/skills.txt tests/test-skill-content.sh tests/test-cross-references.sh README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la skill interne finishing-a-pr porte la fin d'une revue" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

---

### Task 2: Les appelantes invoquent `finishing-a-pr`

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md`
- Modify: `skills/writing-a-batch/SKILL.md`
- Modify: `skills/closing-a-batch/SKILL.md`
- Modify: `skills/writing-a-user-story/SKILL.md`
- Modify: `tests/test-skill-content.sh`
- Modify: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la skill `supercharlouze:finishing-a-pr` de la tâche 1 ; `require`, `absent`, `declared_skills` de `tests/lib.sh`.
- Produces: rien qu'une autre tâche utilise.

Ne touche pas à `skills/following-the-rules/SKILL.md` ni aux gardes `require following-the-rules …`.

- [ ] **Step 1: Remplace les gardes des copies par celles des invocations**

Dans `tests/test-skill-content.sh` :

Remplace ces cinq lignes de `adopting-a-module` :

```bash
require adopting-a-module "ends the review as every gate does"   "never approves and never merges a pull request"
require adopting-a-module "pushes corrections as fixups"         "pushed as a \`fixup!\` commit"
require adopting-a-module "names the merge a clear moment"       "a moment to clear the context"
require adopting-a-module "names the next step after the clear"  "name \`supercharlouze:writing-a-batch\` as the next step"
require adopting-a-module "hands over a self-contained prompt"   "the prompt names the adopted spec by path"
```

par :

```bash
require adopting-a-module "ends its review with no condition and the first batch as next step" \
    "**To end the review, invoke \`supercharlouze:finishing-a-pr\` and give it no condition, and this next step: \`supercharlouze:writing-a-batch\`, which starts from the adopted spec, named by path with the gaps register beside it.**"
require adopting-a-module "says why the clear matters after an adoption" \
    "the adoption conversation carried every mechanism you read while auditing the code, which is exactly what must not leak into the batch that follows"
```

Remplace ces lignes de `writing-a-batch` :

```bash
require writing-a-batch "ends the review as every gate does"      "never approves and never merges a pull request"
require writing-a-batch "pushes corrections as fixups"            "pushed as a \`fixup!\` commit"
require writing-a-batch "names the merge a clear moment"          "a moment to clear the context"
```

par :

```bash
require writing-a-batch "an opening ends its review with no condition and the first story as next step" \
    "**To end the review, invoke \`supercharlouze:finishing-a-pr\` and give it no condition, and this next step: \`supercharlouze:writing-a-user-story\`, which starts from the batch document, with a prompt that says to choose the blocks from those the document still carries.**"
```

et ces deux lignes de `writing-a-batch` :

```bash
require writing-a-batch "opening hands over to the first story"   "name \`supercharlouze:writing-a-user-story\` as the next step"
require writing-a-batch "an amendment is a clear moment too"      "An amendment merges into the same clear moment"
```

par :

```bash
require writing-a-batch "an amendment ends its review with no condition and hands back to the batch" \
    "**To end the review of an amendment, invoke \`supercharlouze:finishing-a-pr\` and give it no condition, and this next step: whatever the batch was doing when it stopped, with the skill that conducts it, starting from the amended batch document.**"
```

La garde `"the merged document carries the design too"` reste telle quelle.

Remplace cette ligne de `writing-a-user-story` :

```bash
require writing-a-user-story "the review is the last place to act" "do not announce the pull request ready while an open ruling without a destination stands"
```

par :

```bash
require writing-a-user-story "the review is the last place to act" \
    "Your human partner has the rulings in front of them here, and nowhere later."
require writing-a-user-story "ends its review on the condition of its open rulings" \
    "**To end the review, invoke \`supercharlouze:finishing-a-pr\` and give it this condition: no \`Open ruling:\` without a destination stands in the \`Rulings log\`.**"
```

et ces quatre lignes de `writing-a-user-story` :

```bash
require writing-a-user-story "ends the review as every gate does"   "never approves and never merges a pull request"
require writing-a-user-story "pushes corrections as fixups"         "pushed as a \`fixup!\` commit"
require writing-a-user-story "names the merge a clear moment"       "a moment to clear the context"
require writing-a-user-story "hands over to the next story"         "name the next story as the next step"
```

par :

```bash
require writing-a-user-story "hands over to the next story" \
    "Give it this next step: the next story, conducted by \`supercharlouze:writing-a-user-story\` from the batch document, with a prompt that says to choose from the blocks no merged story has declared."
require writing-a-user-story "hands over to the closing after the last blocks" \
    "If this story took the batch's last undelivered blocks, give it \`supercharlouze:closing-a-batch\` instead, from the same document."
```

Remplace ces lignes de `closing-a-batch`, commentaire compris :

```bash
require closing-a-batch "ends the review as every gate does"  "never approves and never merges a pull request"
require closing-a-batch "pushes corrections as fixups"        "pushed as a \`fixup!\` commit"
require closing-a-batch "names the merge a clear moment"      "is a moment to clear the context"
# Closing clears like every gate; what it lacks is a next step, so it alone hands
# over no prompt. Two assertions because they are two claims: a skill that dropped
# the second would send an agent inventing a step the model does not have. This is
# the only place either claim is stated — the spec and `following-the-rules` carry the
# general rule ("where a next step exists…"), which already implies the negative.
require closing-a-batch "has no next step to name"            "no next step to name"
require closing-a-batch "therefore hands over no prompt"      "hands over no prompt"
```

par :

```bash
# Closing has no next step, and says so when it ends its review: a skill that
# dropped it would send an agent inventing a step the model does not have.
require closing-a-batch "ends its review with no condition and no next step" \
    "**To end the review, invoke \`supercharlouze:finishing-a-pr\` and give it no condition and no next step.**"
require closing-a-batch "what follows a closed batch is chosen elsewhere" \
    "What comes after a closed batch is chosen outside this model."
```

Dans `tests/test-skill-contracts.sh`, remplace les quatre contrats `shared` de la fin d'une revue et leurs commentaires, depuis la ligne `# The end of a review is one norm with five ends.` jusqu'à la liste de skills du contrat `"every review-ending skill acts on the merge announcement"` comprise, par :

```bash
# The end of a review is conducted in one place, `finishing-a-pr`. A skill whose
# pull request is reviewed invokes it, and passes its conditions and its next
# step.
for s in adopting-a-module writing-a-batch writing-a-user-story closing-a-batch; do
    require "$s" "ends its review by invoking finishing-a-pr" \
        "nvoke \`supercharlouze:finishing-a-pr\` and give it"
done
# How a review ends is spelled there and nowhere else, apart from the rules the
# foundation keeps. Walks the declared skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the end of a review" \
    "pushed as a .fixup!. commit|squash the fixups|[Ss]quash the .fixup!. commits|announce the pull request ready|ready to be approved and merged|never approves and never merges|agreement in the conversation|block to copy and paste|clear the context|announces the merge|prompt stands on its own|refers back to (this|the) conversation" \
    $(declared_skills | grep -vx -e finishing-a-pr -e following-the-rules)
```

La garde `absent_everywhere "no skill hands over the next step at the ready announcement" …` qui suit, et son commentaire, restent tels quels. Son commentaire commence par `# The next step is named, and its prompt given` : garde-le au-dessus d'elle.

- [ ] **Step 2: Lance les gardes et constate le rouge**

Run: `bash tests/test-skill-content.sh | grep FAIL` puis `bash tests/test-skill-contracts.sh | grep FAIL`

Expected: les dix gardes d'appelante neuves échouent dans le premier fichier ; dans le second, « ends its review by invoking finishing-a-pr » échoue pour les quatre skills et « no other skill restates the end of a review » échoue en nommant `adopting-a-module`, `writing-a-batch`, `writing-a-user-story` et `closing-a-batch`.

- [ ] **Step 3: Réécris `adopting-a-module`**

Dans `skills/adopting-a-module/SKILL.md`, remplace les trois paragraphes qui vont de `**Ending the review.** The agent never approves` à `and never refers back to this conversation.` par :

```markdown
**To end the review, invoke `supercharlouze:finishing-a-pr` and give it no
condition, and this next step: `supercharlouze:writing-a-batch`, which starts
from the adopted spec, named by path with the gaps register beside it.**

The clear that follows the merge matters here: the adoption conversation carried
every mechanism you read while auditing the code, which is exactly what must not
leak into the batch that follows.
```

Le paragraphe `That next step is a **start, not a return**. …` qui suit reste tel quel.

- [ ] **Step 4: Réécris `writing-a-batch`**

Dans `skills/writing-a-batch/SKILL.md`, section `Opening the Pull Request`, remplace les trois paragraphes qui vont de `**Ending the review.** The agent never approves` à `and it never refers back to this conversation.` par :

```markdown
**To end the review, invoke `supercharlouze:finishing-a-pr` and give it no
condition, and this next step: `supercharlouze:writing-a-user-story`, which
starts from the batch document, with a prompt that says to choose the blocks
from those the document still carries.**

The clear that follows the merge matters here: the batch document carries the
exact text of every block and the technical design, which is what the design
conversation was for — and that conversation also carries every option you
discarded on the way, which the first story must not inherit.
```

Section `Amending a Batch`, remplace le paragraphe qui va de `**An amendment merges into the same clear moment as an opening**` à `give a prompt that names the amended batch document by path.` par :

```markdown
**To end the review of an amendment, invoke `supercharlouze:finishing-a-pr` and
give it no condition, and this next step: whatever the batch was doing when it
stopped, with the skill that conducts it, starting from the amended batch
document.**
```

- [ ] **Step 5: Réécris `closing-a-batch`**

Dans `skills/closing-a-batch/SKILL.md`, section `Set status: closed`, remplace les deux paragraphes `**Ending the review.** …` et `**Merging a closing review is a moment to clear the context.** …` par ce seul paragraphe, sur une ligne comme le reste du fichier :

```markdown
**To end the review, invoke `supercharlouze:finishing-a-pr` and give it no condition and no next step.** What comes after a closed batch is chosen outside this model.
```

- [ ] **Step 6: Réécris `writing-a-user-story`**

Dans `skills/writing-a-user-story/SKILL.md`, section `Step 7 — Answer the Review`, remplace la phrase :

```markdown
ruling was never taken up, it can no longer take it up. So do not announce the
pull request ready while an open ruling without a destination stands — your human
partner has the rulings in front of them here, and nowhere later.
```

par :

```markdown
ruling was never taken up, it can no longer take it up. Your human partner has
the rulings in front of them here, and nowhere later.
```

Puis remplace les trois paragraphes qui vont de `**Ending the review.** The agent never approves` à `` `Step 6 — Record Before the Merge` was for. `` par :

```markdown
**To end the review, invoke `supercharlouze:finishing-a-pr` and give it this
condition: no `Open ruling:` without a destination stands in the `Rulings log`.**

Give it this next step: the next story, conducted by
`supercharlouze:writing-a-user-story` from the batch document, with a prompt
that says to choose from the blocks no merged story has declared.

If this story took the batch's last undelivered blocks, give it
`supercharlouze:closing-a-batch` instead, from the same document.

The clear that follows the merge matters here: the conversation carries a plan,
an SDD ledger and every file the implementers touched, while `main` now carries
this story's code, and its spec change if it had one, which is all the next
story needs. Everything perishable is already in the story document — that is
what `Step 6 — Record Before the Merge` was for.
```

Le paragraphe `A correction of the ADR's text asked for afterwards, …` au-dessus et le paragraphe `**To abandon a story, invoke …` au-dessous restent tels quels.

- [ ] **Step 7: Cherche ce qui redit encore la fin d'une revue**

Run: `grep -nE "fixup|squash|ready to be|clear the context|copy and paste|announces the merge|never approves" skills/*/SKILL.md skills/*/references/* commands/*`

Expected: des lignes dans `skills/finishing-a-pr/SKILL.md` et `skills/following-the-rules/SKILL.md`, et dans `skills/writing-a-user-story/SKILL.md` la seule ligne ``decision, is a `fixup!` of that commit.``

Une autre ligne est une copie restante : rapporte-la sans la retoucher.

- [ ] **Step 8: Lance la suite entière et constate le vert**

Run: `bash tests/run-all.sh > "$TMPDIR/us10-t2.txt" 2>&1; tail -1 "$TMPDIR/us10-t2.txt"; grep FAIL "$TMPDIR/us10-t2.txt"`

La suite prend environ trois minutes : lance-la en arrière-plan ou avec un délai d'au moins cinq minutes.

Expected: `all tests passed`, aucune ligne `FAIL`.

- [ ] **Step 9: Commit**

```bash
git add skills tests
bash ~/.config/github-app/as-agent.sh git commit -m "refactor: les skills dont la pull request est revue invoquent finishing-a-pr" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: la story est technique alors que quatre skills invoquent désormais une skill là où elles portaient le texte — la spec ne dit pas quelle skill porte une règle, et l'utilisateur a rendu cet arbitrage sur la story de `writing-in-a-spec` — si c'est faux, la story aurait dû s'arrêter sur sa condition d'arrêt.
- Ruling: le changement borné n'invoque pas `finishing-a-pr` — `using-batches` ne porte aucune copie de la fin d'une revue, et la spec ne compte pas la pull request d'un changement borné parmi ses revues — si c'est faux, la fin de la revue d'un changement borné n'est conduite par aucune skill jusqu'à la story de `making-a-bounded-change`.
- Ruling: le socle `following-the-rules` n'est pas touché, et garde sa phrase sur le squash et l'annonce — le lot lui laisse les règles, et cette phrase y tient en une règle — si c'est faux, l'ordre accord, squash, annonce reste écrit à deux endroits.
- Ruling: la garde négative « no other skill restates the end of a review » écarte `following-the-rules` en plus de `finishing-a-pr` — le socle porte les règles que la skill applique — si c'est faux, une copie du déroulé qui entrerait dans le socle ne serait pas vue.
- Ruling: la vérification des conditions vient après l'accord et avant le squash, la skill demande de dire laquelle ne tient pas, et l'accord est redonné après le retour à la revue — c'est l'ordre que `Technical design` donne, là où la skill de story disait seulement de ne pas annoncer la pull request prête — si c'est faux, un accord donné avant le retour à la revue vaudrait encore.
- Ruling: l'exemple « a review that changes the wording of a spec change is deciding something, not fixing a slip », que seule la skill de story portait, vaut dans la skill pour toutes les appelantes — il dit ce qu'est une décision nouvelle, et l'adoption comme l'ouverture écrivent du texte de spec — si c'est faux, une appelante sans texte de spec lit un exemple qui ne la concerne pas.
- Ruling: chaque appelante garde en une phrase la raison pour laquelle le contexte se vide après sa fusion, et la moitié de celle de l'adoption disparaît (« an inventory, rulings and a boundary argument that the merged documents now carry better ») — la raison gardée est celle qui aide à trancher — si c'est faux, un agent ne sait plus que les documents fusionnés portent l'inventaire et les rulings de l'adoption.
- Ruling: la raison que l'ouverture donnait au `fixup!` (« the block texts are what the human is reading, and a force-push mid-review replaces the very lines their comments hang on ») disparaît de `writing-a-batch` — le socle et le `Red Flags` de la skill la portent — si c'est faux, l'ouverture ne dit plus pourquoi la règle pèse sur les textes des blocs.
- Ruling: la skill porte « Once you have answered the merge announcement, go on with the step that invoked this skill », qu'aucune copie ne portait — c'est la forme des skills internes du lot — si c'est faux, la phrase est du bruit.
- Ruling: les phrases d'ouverture de la skill, ses titres `The Review` et `The Merge` et le gras de chacun de ses gestes restent sans garde propre — les autres skills internes ont cette forme, et la garde d'ordre tient les gestes — si c'est faux, une réécriture peut les perdre sans que la suite le voie.
- Ruling: la garde négative ne voit pas « Never approve » sans « merge » à sa suite — la relecture de la vague de correction l'a relevé hors de ses constats — si c'est faux, une redite ainsi tournée passe.
- Technical design ruling: une appelante passe, en plus de la skill et du document de l'étape suivante, ce que le prompt doit dire d'autre — `Technical design` ne nomme que l'étape et son document, alors que l'ouverture et la story faisaient dire au prompt parmi quels blocs choisir — si c'est faux, le prompt de la story suivante ne dit plus de choisir ses blocs.
- Technical design ruling: l'amendement passe « whatever the batch was doing when it stopped, with the skill that conducts it » — son étape suivante n'est connue qu'à l'exécution, et la skill attend une skill à nommer — si c'est faux, l'agent nomme une skill que l'amendement ne lui donnait pas à choisir.

## Observed drift
