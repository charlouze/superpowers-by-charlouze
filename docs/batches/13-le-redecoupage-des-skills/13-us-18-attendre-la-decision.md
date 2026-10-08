# Attendre la décision Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Une story technique arrêtée reste en l'état jusqu'à la décision de l'humain, et l'étape que demande la décision prise sur une story arrêtée se lance dans un contexte vide, par un prompt qui énonce cette décision.

**Architecture:** `handling-a-stopped-story` garde la story technique jusqu'à la décision, puis, la story abandonnée, demande de vider le contexte et donne le prompt des étapes que la décision demande. Le socle `following-the-rules` porte la forme de ce prompt avec celle du prompt donné après une fusion, sans nommer de skill. `amending-a-batch` transmet l'étape que nomme, après l'amendement, le prompt qui l'a lancé.

**Tech Stack:** Markdown pour les skills, Bash pour les gardes de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** Batch > Amending a batch, Authority and conflict rules
**Blocks:** D1, D4

## Global Constraints

Avant de commencer, lis `skills/following-the-rules/SKILL.md` dans ce worktree : il porte les règles d'exécution. Ne l'invoque pas comme skill, la version installée du plugin ne l'a pas.

### Les contraintes du lot

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

### Le gel du fichier de spec

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

### L'autorité

When the batch and the spec contradict each other, the spec wins — without
exception and without deliberation. Implement what the spec says, record a
`Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
agent's.

### La concision

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

### Une contrainte ou un ADR intenable

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

### Les ADR tenus

> The code this story writes holds these ADRs.

- `docs/adr/une-skill-par-moment-d-invocation.md`

### Une décision qui mérite un ADR

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

### Ce poste

- Toute commande `git` qui écrit un commit passe par le wrapper : `bash ~/.config/github-app/as-agent.sh git commit …`. Un commit se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et par aucune autre ligne d'attribution. Ne pousse pas : celui qui conduit le plan pousse.
- Écris et modifie les fichiers avec les outils d'écriture et d'édition de fichiers, jamais par `sed`, `perl` ou un heredoc : le shell de ce poste mange les barres obliques inverses.
- Les `SKILL.md` gardent des fins de ligne LF.
- Ni `python` ni `node`.
- Le texte d'une skill est anglais. Recopie mot pour mot les textes que le plan donne.
- Chaque tâche montre l'étape rouge : la garde échoue avant le texte, puis passe.
- `bash tests/test-skill-content.sh` et `bash tests/test-skill-contracts.sh` prennent chacun moins d'une minute ; `bash tests/run-all.sh` en prend trois.
- Une garde `require <skill> "<label>" "<needle>"` cherche `<needle>` littéralement dans la skill aplatie sur une ligne, espaces resserrés. Une garde `absent "<label>" "<regex>" <skills…>` échoue si l'expression régulière étendue est trouvée.

## Review Focus

- Une story technique arrêtée dont la pull request est déjà ouverte : rien ne la ferme avant la décision. La tâche 1 le tient par une garde négative sur toutes les skills.
- Une skill autre que `finishing-a-pr`, le socle et `handling-a-stopped-story` qui demanderait de vider le contexte : la garde négative de la tâche 3 la refuse.
- Le socle qui nommerait une skill : sa garde existante le refuse, et la tâche 2 n'en nomme aucune.
- Une étape du tableau sans document d'où repartir : la tâche 3 garde chaque ligne en entier.
- L'ancienne consigne de conduire les étapes dans la session : la tâche 3 la chasse par une garde négative.

---

### Task 1: La story technique arrêtée reste en l'état jusqu'à la décision

**Files:**
- Modify: `skills/handling-a-stopped-story/SKILL.md` (section `Requalifying a Technical Story`, étape 1 ; section `Red Flags`)
- Test: `tests/test-skill-content.sh` (bloc « handling-a-stopped-story: what follows a stop condition »), `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: rien.
- Produces: rien que les tâches suivantes lisent.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, remplace la ligne

```bash
require handling-a-stopped-story "a technical story's pull request is closed at the stop" "Close its pull request without merging it if one is already open; the branch and its worktree stay until the choice below is ruled."
```

par

```bash
require handling-a-stopped-story "a technical story stays as it stands until the ruling" "1. **Leave the story as it stands until your human partner has ruled whether the observable change is wanted, then abandon it.** A pull request already open stays open until then. Once it is ruled, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch."
```

et la ligne

```bash
require handling-a-stopped-story "red flag: requalification does not start by closing" "| \"Requalification starts by closing the story's pull request\" | Override 2 fires mid-SDD, usually before any pull request exists. Close it only if it is already open. |"
```

par

```bash
require handling-a-stopped-story "red flag: requalification does not start by closing" "| \"Requalification starts by closing the story's pull request\" | The story stays as it stands until your human partner has ruled. A pull request already open is closed with the story, once it is abandoned. |"
```

Dans `tests/test-skill-contracts.sh`, juste après la garde `absent "no skill closes a corrective story's pull request at the stop" …` (trois lignes, la dernière liste des skills), ajoute :

```bash

# A technical story is abandoned once its ruling is given: no skill has its pull
# request closed at the stop either.
absent_everywhere "no skill closes a technical story's pull request at the stop" \
    "Close its pull request without merging it if one is already open|Close it only if it is already open|[*][*]Abandon the story[.][*][*]"
```

- [ ] **Step 2: Vérifier le rouge**

Run: `bash tests/test-skill-content.sh | grep FAIL ; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: trois échecs, « a technical story stays as it stands until the ruling », « red flag: requalification does not start by closing » et « no skill closes a technical story's pull request at the stop (present in: handling-a-stopped-story) ».

- [ ] **Step 3: Écrire le texte**

Dans `skills/handling-a-stopped-story/SKILL.md`, remplace

```markdown
1. **Abandon the story.** Close its pull request without merging it if one is
   already open; the branch and its worktree stay until the choice below is
   ruled. Once it is ruled, invoke `supercharlouze:abandoning-a-story` and give
   it the story's branch.
```

par

```markdown
1. **Leave the story as it stands until your human partner has ruled whether
   the observable change is wanted, then abandon it.** A pull request already
   open stays open until then. Once it is ruled, invoke
   `supercharlouze:abandoning-a-story` and give it the story's branch.
```

et la ligne du tableau `Red Flags`

```markdown
| "Requalification starts by closing the story's pull request" | Override 2 fires mid-SDD, usually before any pull request exists. Close it only if it is already open. |
```

par

```markdown
| "Requalification starts by closing the story's pull request" | The story stays as it stands until your human partner has ruled. A pull request already open is closed with the story, once it is abandoned. |
```

- [ ] **Step 4: Vérifier le vert**

Run: `bash tests/test-skill-content.sh | grep -c FAIL ; bash tests/test-skill-contracts.sh | grep -c FAIL`
Expected: `0` et `0`.

- [ ] **Step 5: Commit**

```bash
git add skills/handling-a-stopped-story/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: une story technique arrêtée reste en l'état jusqu'à la décision de l'humain" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: Le socle tient le prompt donné après l'abandon d'une story arrêtée

**Files:**
- Modify: `skills/following-the-rules/SKILL.md` (section `The Git Model`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: rien.
- Produces: la forme du prompt, sous `The Git Model`, que la tâche 3 cite par `` `The Git Model` in `supercharlouze:following-the-rules` ``.

Le socle ne nomme aucune skill, ni du plugin ni de superpowers : une garde existante échoue sur un nom de skill.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, remplace la ligne

```bash
require following-the-rules "the handover prompt stands alone"    "That prompt stands on its own"
```

par

```bash
require following-the-rules "an abandonment after a stop is a clear moment too" "**Abandoning a story after a stop condition is a moment to clear the context too, when the ruling asks for a next step.**"
require following-the-rules "the prompt given after an abandonment states the ruling" "The agent asks its human partner to clear the context, names that step and gives its prompt the same way, and that prompt states the ruling: the story's branch is gone, and no document carries what was ruled yet."
require following-the-rules "each handover prompt stands alone"   "**Each of these prompts stands on its own:** it names the skill to invoke and the document to start from, and never refers back to the conversation."
```

Dans `tests/test-skill-contracts.sh`, dans la garde `absent "no other skill restates the end of a review"`, remplace dans l'expression `prompt stands on its own` par `prompts? stands on its own`.

- [ ] **Step 2: Vérifier le rouge**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: trois échecs, les trois gardes ajoutées.

- [ ] **Step 3: Écrire le texte**

Dans `skills/following-the-rules/SKILL.md`, remplace

```markdown
The agent cannot clear its own context. So when your human partner announces the
merge, the agent asks them to clear the context. Where a next step exists, it names
that step and gives, in a block to copy and paste, the prompt that starts it in a
fresh context. **That prompt stands on its own:** it names the skill to invoke and
the document to start from, and never refers back to the conversation.
```

par

```markdown
The agent cannot clear its own context. So when your human partner announces the
merge, the agent asks them to clear the context. Where a next step exists, it names
that step and gives, in a block to copy and paste, the prompt that starts it in a
fresh context.

**Abandoning a story after a stop condition is a moment to clear the context
too, when the ruling asks for a next step.** The agent asks its human partner to
clear the context, names that step and gives its prompt the same way, and that
prompt states the ruling: the story's branch is gone, and no document carries
what was ruled yet.

**Each of these prompts stands on its own:** it names the skill to invoke and
the document to start from, and never refers back to the conversation.
```

- [ ] **Step 4: Vérifier le vert**

Run: `bash tests/test-skill-content.sh | grep -c FAIL ; bash tests/test-skill-contracts.sh | grep -c FAIL`
Expected: `0` et `0`.

- [ ] **Step 5: Commit**

```bash
git add skills/following-the-rules/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: le socle tient le prompt donné après l'abandon d'une story arrêtée" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 3: La suite d'une décision se lance dans un contexte vide

**Files:**
- Modify: `skills/handling-a-stopped-story/SKILL.md` (section `What the Ruling Asks For` ; section `Red Flags`)
- Test: `tests/test-skill-content.sh` (bloc « handling-a-stopped-story: what follows a stop condition »), `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la section `The Git Model` du socle, que la tâche 2 a complétée.
- Produces: le prompt qui énonce la décision et les étapes, que la tâche 4 nomme « the prompt that started the amendment ».

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-skill-content.sh`, remplace les quatorze lignes qui vont de

```bash
require handling-a-stopped-story "the next steps are taken in order, each with its skill" \
```

à

```bash
    "| An ADR is untenable | A bounded change, under \`supercharlouze:making-a-bounded-change\`, rewrites or deletes it. |"
```

comprises, par

```bash
require handling-a-stopped-story "the next steps start in a fresh context" \
    "A ruling that abandons the story may ask for next steps. They start in a fresh context: this conversation carries a stopped execution, and each step is conducted from a document."
require handling-a-stopped-story "asks for a clear context once the story is abandoned" \
    "Once the story is abandoned: 1. **Ask your human partner to clear the context.**"
require handling-a-stopped-story "the prompt takes its form from the foundation" \
    "2. **Give the prompt that starts the next steps**, in the form \`The Git Model\` in \`supercharlouze:following-the-rules\` fixes."
require handling-a-stopped-story "the prompt states the ruling, then each step with its skill and its document" \
    "It states the ruling, then the steps of its row below, in their order, each with the skill to invoke and the document it starts from, by its path."
require handling-a-stopped-story "the ruling is stated with the story and what it revealed" \
    "State the ruling as your human partner gave it, and name the story and what it revealed. Not: \"Carry on with the requalification.\" Good: \"Technical story \`07-us-4-renommer-les-echeances\` was abandoned: it changes how a prorated amount is rounded, and that change is wanted.\""
require handling-a-stopped-story "a corrected spec comes with a reduced scope" \
    "| The spec is corrected, and the batch stays corrective on a reduced scope | The corrected spec ships through its own pull request, from the spec. Then \`supercharlouze:amending-a-batch\` reduces the \`Scope\`, from the batch document. |"
require handling-a-stopped-story "a rewritten batch goes to an amendment" \
    "| The corrective batch is rewritten as an ordinary batch | \`supercharlouze:amending-a-batch\` rewrites it, from the batch document. |"
require handling-a-stopped-story "a different batch closes this one first" \
    "| The remaining work is a different batch | \`supercharlouze:closing-a-batch\` closes this batch, from the batch document. Then \`supercharlouze:opening-a-batch\` opens the fresh one, from the gaps register whose entries this batch released. |"
require handling-a-stopped-story "a wanted change goes to an amendment, then to an ordinary story" \
    "| The observable change of a technical story is wanted | \`supercharlouze:amending-a-batch\` adds its block, from the batch document. Once that pull request merges, \`supercharlouze:delivering-a-story\` rewrites the work as an ordinary story of the amended batch, from the amended batch document. |"
require handling-a-stopped-story "an untenable constraint goes to an amendment" \
    "| A constraint is untenable | \`supercharlouze:amending-a-batch\` changes or removes it, from the batch document. |"
require handling-a-stopped-story "an untenable ADR goes to a bounded change" \
    "| An ADR is untenable | A bounded change, under \`supercharlouze:making-a-bounded-change\`, rewrites or deletes it, from the ADR. |"
require handling-a-stopped-story "red flag: the next step does not run in this conversation" \
    "| \"The ruling is fresh in this conversation, I'll run the amendment here\" | This conversation carries a stopped execution, which can contradict the document the next step starts from. Ask your human partner to clear the context, and give the prompt. |"
```

Dans `tests/test-skill-contracts.sh`, remplace la garde

```bash
absent "no other skill restates the end of a review" \
    "pushed as a .fixup!. commit|[Ss]quash the fixups|[Ss]quash the .fixup!. commits|[Aa]nnounce (that )?the pull request (is )?ready|ready to be approved and merged|[Nn]ever approves? (and|or) (never )?merges?|agreement in the conversation|block to copy and paste|[Cc]lear the context|announces the merge|prompts? stands on its own|refers back to (this|the) conversation" \
    $(declared_skills | grep -vx -e finishing-a-pr -e following-the-rules)
```

par

```bash
absent "no other skill restates the end of a review" \
    "pushed as a .fixup!. commit|[Ss]quash the fixups|[Ss]quash the .fixup!. commits|[Aa]nnounce (that )?the pull request (is )?ready|ready to be approved and merged|[Nn]ever approves? (and|or) (never )?merges?|agreement in the conversation|block to copy and paste|announces the merge|prompts? stands on its own|refers back to (this|the) conversation" \
    $(declared_skills | grep -vx -e finishing-a-pr -e following-the-rules)
# The abandonment of a stopped story is the other moment that asks for a clear
# context: the skill that conducts it makes the request, and takes the form of
# the prompt from the foundation.
# shellcheck disable=SC2046
absent "no other skill asks for a clear context" \
    "[Cc]lear the context" \
    $(declared_skills | grep -vx -e finishing-a-pr -e following-the-rules -e handling-a-stopped-story)
absent "the steps a ruling asks for are not conducted in the session that took it" \
    "Take them in the order their row gives" \
    handling-a-stopped-story
```

- [ ] **Step 2: Vérifier le rouge**

Run: `bash tests/test-skill-content.sh | grep FAIL ; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: douze échecs dans le premier fichier, les douze gardes écrites, et un dans le second, « the steps a ruling asks for are not conducted in the session that took it (present in: handling-a-stopped-story) ».

- [ ] **Step 3: Écrire le texte**

Dans `skills/handling-a-stopped-story/SKILL.md`, remplace toute la section `What the Ruling Asks For`, de son titre à la dernière ligne de son tableau, par :

```markdown
## What the Ruling Asks For

A ruling that abandons the story may ask for next steps. They start in a fresh
context: this conversation carries a stopped execution, and each step is
conducted from a document.

Once the story is abandoned:

1. **Ask your human partner to clear the context.**
2. **Give the prompt that starts the next steps**, in the form `The Git Model`
   in `supercharlouze:following-the-rules` fixes. It states the ruling, then
   the steps of its row below, in their order, each with the skill to invoke
   and the document it starts from, by its path.

State the ruling as your human partner gave it, and name the story and what it
revealed. Not: "Carry on with the requalification." Good: "Technical story
`07-us-4-renommer-les-echeances` was abandoned: it changes how a prorated amount
is rounded, and that change is wanted."

| Ruling | Next steps, in their order |
|---|---|
| The spec is corrected, and the batch stays corrective on a reduced scope | The corrected spec ships through its own pull request, from the spec. Then `supercharlouze:amending-a-batch` reduces the `Scope`, from the batch document. |
| The corrective batch is rewritten as an ordinary batch | `supercharlouze:amending-a-batch` rewrites it, from the batch document. |
| The remaining work is a different batch | `supercharlouze:closing-a-batch` closes this batch, from the batch document. Then `supercharlouze:opening-a-batch` opens the fresh one, from the gaps register whose entries this batch released. |
| The observable change of a technical story is wanted | `supercharlouze:amending-a-batch` adds its block, from the batch document. Once that pull request merges, `supercharlouze:delivering-a-story` rewrites the work as an ordinary story of the amended batch, from the amended batch document. |
| A constraint is untenable | `supercharlouze:amending-a-batch` changes or removes it, from the batch document. |
| An ADR is untenable | A bounded change, under `supercharlouze:making-a-bounded-change`, rewrites or deletes it, from the ADR. |
```

Ajoute à la fin du tableau `Red Flags` de la même skill la ligne :

```markdown
| "The ruling is fresh in this conversation, I'll run the amendment here" | This conversation carries a stopped execution, which can contradict the document the next step starts from. Ask your human partner to clear the context, and give the prompt. |
```

- [ ] **Step 4: Vérifier le vert**

Run: `bash tests/test-skill-content.sh | grep -c FAIL ; bash tests/test-skill-contracts.sh | grep -c FAIL ; bash tests/test-cross-references.sh | grep -c FAIL`
Expected: `0`, `0` et `0`.

- [ ] **Step 5: Commit**

```bash
git add skills/handling-a-stopped-story/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la suite d'une décision prise sur une story arrêtée se lance dans un contexte vide" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 4: L'amendement transmet l'étape que son prompt nomme après lui

**Files:**
- Modify: `skills/amending-a-batch/SKILL.md` (section `The Pull Request`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: le prompt de la tâche 3, qui énonce une décision et des étapes dans leur ordre.
- Produces: rien.

`amending-a-batch` ne porte aucune de ces chaînes, qu'une garde lui refuse : `abandoning-a-story`, `Put the choice to the human`, `Requalifying`, `requalifying`, `rules on the constraint`.

- [ ] **Step 1: Écrire la garde**

Dans `tests/test-skill-content.sh`, juste après la garde `require amending-a-batch "an amendment ends its review with no condition and hands back to the batch" …` (deux lignes), ajoute :

```bash
require amending-a-batch "an amendment a ruling started hands on the step that follows it" \
    "When the prompt that started the amendment states a ruling and names a step after the amendment, give that step instead, with its skill and its document, and have its prompt state the ruling."
```

- [ ] **Step 2: Vérifier le rouge**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: un échec, « an amendment a ruling started hands on the step that follows it ».

- [ ] **Step 3: Écrire le texte**

Dans `skills/amending-a-batch/SKILL.md`, section `The Pull Request`, après le paragraphe

```markdown
**To end the review of an amendment, invoke `supercharlouze:finishing-a-pr` and
give it no condition, and this next step: whatever the batch was doing when it
stopped, with the skill that conducts it, starting from the amended batch
document.**
```

ajoute, séparé par une ligne vide :

```markdown
When the prompt that started the amendment states a ruling and names a step
after the amendment, give that step instead, with its skill and its document,
and have its prompt state the ruling.
```

- [ ] **Step 4: Vérifier le vert**

Run: `bash tests/run-all.sh | tail -5`
Expected: la suite entière passe, sans aucun `FAIL`.

- [ ] **Step 5: Commit**

```bash
git add skills/amending-a-batch/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: un amendement transmet l'étape que son prompt nomme après lui" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: le premier commit supprime du gaps register le gap sur `Amending a batch`, avec la transcription — le bloc sur l'abandon d'une story technique est ce qui règle l'entrée, et une entrée réglée part dans la pull request qui la règle — si l'entrée devait survivre jusqu'à la clôture, elle est à réinscrire.
- Ruling: la garde qui réserve à `finishing-a-pr` et au socle la demande de vider le contexte s'ouvre à `handling-a-stopped-story`, pour cette demande seule ; la forme du prompt lui reste interdite, et elle renvoie au socle pour elle — la demande est un geste que la skill conduit à son propre moment, alors que la forme est une règle écrite une fois — une autre skill qui devrait demander un contexte vide rouvre la garde.
- Ruling: la forme du prompt reste sous `The Git Model` du socle, alors que le bloc vise `Authority and conflict rules` — le socle y porte déjà la fin d'une revue et le prompt donné après une fusion — un lecteur qui cherche la règle sous le titre de la spec ne l'y trouve pas.
- Ruling: le socle dit « After a review, the prompt waits for the merge announcement » — la phrase d'avant, écrite pour un seul prompt, se lisait comme retenant aussi celui que suit un abandon — aucun.
- Ruling: la demande de vider le contexte vaut seulement quand la décision demande une suite — le bloc ne lance une étape que si la décision en demande une — après une décision sans suite, l'humain ne reçoit ni demande ni prompt.
- Ruling: la première étape de la ligne « The spec is corrected… » revient à l'humain, et le prompt la nomme comme sienne — aucune skill ne conduit encore la correction d'une spec sans code, et seul un humain corrige une spec — la story qui transcrit les blocs sur la spec corrigée et sur `Bounded change` réécrit cette ligne.
- Ruling: la libération des réservations qu'un lot requalifié ne prend plus en charge n'est plus une étape numérotée de `Requalifying a Corrective Batch`, mais un paragraphe qui dit quelles étapes de la suite la font — ces étapes se conduisent dans un autre contexte — la garde de l'ancienne étape a changé de texte.
- Ruling: l'ouverture du lot neuf repart du gaps register dont le lot clos a libéré les entrées — ni la spec ni la conception technique ne disent de quel document cette étape repart, et le travail restant d'un lot correctif est fait de ces entrées — un prompt qui nomme ce document pour un lot neuf conçu autrement envoie lire le mauvais fichier.
- Technical design ruling: `amending-a-batch` et `closing-a-batch` passent à `finishing-a-pr`, comme étape suivante, celle que le prompt qui les a lancés nomme après eux, et font redire la décision par son prompt — la fusion de leur pull request vide le contexte une seconde fois, et la décision n'est écrite dans aucun document — la conception technique donne à `closing-a-batch` son rôle d'avant, sans étape suivante.
- Ruling: l'étape qui suit une pull request que l'humain ou un changement borné porte n'est transmise par aucune skill — le changement borné ne conduit pas la fin de sa revue, et l'humain garde le premier prompt, qui nomme toutes les étapes — après une telle fusion, l'humain relance lui-même l'étape suivante.
- Ruling: dans `delivering-a-story`, le paragraphe de la story technique de `Step 5` et le paragraphe « To abandon a story… » restent tels quels — aucun ne fait abandonner une story ni fermer sa pull request avant la décision — aucun.
- Ruling: dans les deux procédures de requalification, l'abandon reste l'étape 1 et le choix soumis à l'humain l'étape 2 — l'étape 1 dit d'attendre la décision, et l'ordre vient de l'extraction — un agent pressé lit l'abandon avant le choix.
- Ruling: la garde négative contre la fermeture d'une pull request dès l'arrêt refuse aussi `**Abandon the story.**` dans toute skill — c'était l'ouverture de l'étape retirée — une phrase en gras identique, écrite plus tard à bon droit, la fait échouer.
- Ruling: le plan ci-dessus garde le texte planifié ; le texte livré s'en écarte par ce que les relectures ont fait corriger, que les arbitrages ci-dessus nomment — le plan dit ce qui a été demandé aux exécutants — qui compare le plan aux skills y trouve ces écarts.

## Observed drift

- `Delivering a story`, étape 3 : la spec ne fait retirer l'entrée du gaps register qu'une story résorbe qu'à une story qui ne transcrit aucun bloc. Une story dont le bloc règle une entrée la retire aussi dans son premier commit, ce qu'aucune règle ne décrit.
