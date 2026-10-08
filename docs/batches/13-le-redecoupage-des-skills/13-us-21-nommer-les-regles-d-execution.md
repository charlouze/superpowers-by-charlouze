# Nommer les règles d'exécution Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Le plan d'une story nomme les règles d'exécution qui valent pour elle, et celui qui exécute ou relit une tâche les lit dans `following-the-rules`.

**Architecture:** `following-the-rules` garde le texte de chaque règle d'exécution et dit, dans la table de `Execution Rules`, pour quelle story chacune vaut. `delivering-a-story` écrit `Global Constraints` depuis un gabarit porté en ref, qui cite ces noms, demande d'invoquer `following-the-rules` et donne le chemin des ADR ou `none`. Les copies des règles que `delivering-a-story` portait disparaissent avec les contrats `shared` qui les tenaient identiques.

**Tech Stack:** Markdown pour les skills, Bash pour les gardes de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** Story > The user story document, Story > Execution rules, The model
**Blocks:** D6, D7, D8

## Global Constraints

Les contraintes du lot, recopiées mot pour mot :

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

D2 et D3 sont transcrits par une même story, qui suit le renommage en
`delivering-a-story`.

D6, D7 et D8 sont transcrits par une même story, qui suit le renommage en
`delivering-a-story`.

La story qui transcrit D5 suit ce renommage.

Le gel du fichier de spec :

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

La règle d'autorité :

> When the batch and the spec contradict each other, the spec wins — without
> exception and without deliberation. Implement what the spec says, record a
> `Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
> agent's.

Les règles de concision :

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

La condition d'arrêt sur une contrainte ou un ADR :

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

> The code this story writes holds these ADRs.

- `docs/adr/une-skill-par-moment-d-invocation.md`

Les conditions d'un ADR :

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

Ce qui vaut pour chaque tâche de ce plan :

- N'invoque pas `supercharlouze:following-the-rules` : la version installée du plugin ne la porte pas, et l'appel rend « Unknown skill ». Les règles à suivre sont écrites ci-dessus.
- Une skill est entièrement anglaise et ne cite aucune section de `docs/specs/supercharlouze.md`.
- `following-the-rules` ne nomme aucune skill, ni du plugin ni de superpowers.
- Les `SKILL.md` gardent des fins de ligne LF.
- Écris les fichiers avec l'outil d'écriture ou d'édition de fichiers : l'outil Bash de ce poste mange les barres obliques inverses dans les heredocs et dans `sed`.
- Toute commande `git` qui écrit un commit passe par `bash ~/.config/github-app/as-agent.sh git …`. Un commit se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et par aucune autre ligne d'attribution.
- Une commande de test se lance seule, sans autre commande à la suite, avec un délai de dix minutes : `tests/test-skill-content.sh` et `tests/test-skill-contracts.sh` prennent chacun plusieurs minutes.
- Ne pousse pas la branche : qui conduit l'exécution le fait.

## Review Focus

- Un plan qui cite un nom que la table de `following-the-rules` ne donne pas : la garde de l'égalité des deux listes de noms échoue (tâche 2).
- Un plan dont `main` ne porte aucun ADR : le gabarit fait écrire `none` (tâche 2).
- Un sous-agent qui ne lit que `Global Constraints` : le gabarit lui demande d'invoquer `following-the-rules` et lui dit où lire chaque règle nommée (tâche 2).
- Une copie d'une règle qui reviendrait dans `delivering-a-story` ou dans son gabarit : une garde négative la refuse (tâche 2).
- Une règle d'exécution dont la condition changerait dans la table : une garde tient chaque ligne entière (tâche 1).

---

### Task 1: Le socle dit qui suit les règles d'exécution et pour quelle story chacune vaut

**Files:**
- Modify: `skills/following-the-rules/SKILL.md` (section `Authority and Conflict Rules`, paragraphe du gel ; section `Execution Rules`, phrase d'introduction)
- Test: `tests/test-skill-content.sh` (bloc « Each execution rule has a name », vers la fin du fichier)

**Interfaces:**
- Consumes: rien.
- Produces: la table de `## Execution Rules`, dont chaque ligne a la forme `` | `<name>` | <holds for> | `<section>` | `` ; la tâche 2 lit la première colonne.

- [ ] **Step 1: Write the failing test**

Dans `tests/test-skill-content.sh`, remplace ce bloc :

```bash
# Each execution rule has a name a story's Global Constraints can cite.
for rule in "spec freeze" "spec authority" "concision" "corrective stop condition" \
    "code under a feature flag" "technical stop condition" \
    "untenable constraint or ADR" "held ADRs" "decision worth an ADR"; do
    require following-the-rules "names the execution rule: $rule" "| \`$rule\` |"
done
```

par celui-ci :

```bash
# Each execution rule has a name a story's Global Constraints can cite, says
# which story it holds for and names the section it is written under.
require following-the-rules "execution rule: spec freeze" \
    "| \`spec freeze\` | every story | \`Authority and Conflict Rules\` |"
require following-the-rules "execution rule: spec authority" \
    "| \`spec authority\` | every story | \`Authority and Conflict Rules\` |"
require following-the-rules "execution rule: concision" \
    "| \`concision\` | every story | \`Concision\` |"
require following-the-rules "execution rule: corrective stop condition" \
    "| \`corrective stop condition\` | a story of a corrective batch | \`Stop Conditions\` |"
require following-the-rules "execution rule: code under a feature flag" \
    "| \`code under a feature flag\` | a story that writes code guarded by a flag, whichever batch declares the flag | \`Code Under a Feature Flag\` |"
require following-the-rules "execution rule: technical stop condition" \
    "| \`technical stop condition\` | a technical story | \`Stop Conditions\` |"
require following-the-rules "execution rule: untenable constraint or ADR" \
    "| \`untenable constraint or ADR\` | a story whose batch declares constraints, or whose branch starts from a \`main\` that carries an ADR | \`Stop Conditions\` |"
require following-the-rules "execution rule: held ADRs" \
    "| \`held ADRs\` | a story whose branch starts from a \`main\` that carries an ADR | \`The Model\` |"
require following-the-rules "execution rule: decision worth an ADR" \
    "| \`decision worth an ADR\` | every story | \`Decisions Worth an ADR\` |"

# Whoever executes or reviews a task reads the rules in the foundation: a plan
# names them and copies none.
require following-the-rules "who follows the execution rules" \
    "Whoever executes or reviews a task of a story's plan follows the execution rules."
require following-the-rules "a plan names the execution rules and copies none" \
    "The plan's \`Global Constraints\` names those that hold for the story, and copies none."
require following-the-rules "a task starts by reading the rules its plan names" \
    "**Before you start a task, read each rule \`Global Constraints\` names, under the section this table gives for it:**"
require following-the-rules "the freeze lifts when the pull request opens" \
    "Once the pull request is open the freeze lifts"
require following-the-rules "why the freeze is an execution rule" \
    "The spec file travels in the same branch as the code, so a task can edit it, which is why the freeze is an execution rule."
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-content.sh > /tmp/us21-t1-red.txt 2>&1; grep -c PASS /tmp/us21-t1-red.txt; grep FAIL /tmp/us21-t1-red.txt`

Expected: quatre `[FAIL]` exactement, « who follows the execution rules », « a plan names the execution rules and copies none », « a task starts by reading the rules its plan names » et « why the freeze is an execution rule ». Les neuf gardes « execution rule: … » et « the freeze lifts when the pull request opens » passent : la table et cette phrase sont déjà justes, et ces gardes les tiennent.

- [ ] **Step 3: Write minimal implementation**

Dans `skills/following-the-rules/SKILL.md`, à la fin du paragraphe qui commence par `**The spec file is frozen, with a start and an end.**`, remplace la phrase :

```markdown
The rule is copied into the `Global Constraints` of every plan, so it sits under the eyes of every implementer and every reviewer.
```

par :

```markdown
The spec file travels in the same branch as the code, so a task can edit it, which is why the freeze is an execution rule.
```

Sous le titre `## Execution Rules`, remplace la ligne :

```markdown
A story's `Global Constraints` carries the execution rules that hold for that story. Each has a name:
```

par ces deux paragraphes :

```markdown
Whoever executes or reviews a task of a story's plan follows the execution rules. The plan's `Global Constraints` names those that hold for the story, and copies none.

**Before you start a task, read each rule `Global Constraints` names, under the section this table gives for it:**
```

Ne touche ni à la table ni au reste du fichier.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-skill-content.sh > /tmp/us21-t1-green.txt 2>&1; grep -c PASS /tmp/us21-t1-green.txt; grep -c FAIL /tmp/us21-t1-green.txt`

Expected: aucun `[FAIL]`.

- [ ] **Step 5: Commit**

```bash
git add skills/following-the-rules/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: le socle dit qui suit les règles d'exécution" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: `Global Constraints` nomme les règles d'exécution depuis un gabarit

**Files:**
- Create: `skills/delivering-a-story/references/global-constraints.md`
- Modify: `skills/delivering-a-story/SKILL.md` (`Step 3`, `Step 4 — Write the Plan`, `Red Flags`)
- Modify: `skills/handling-a-stopped-story/SKILL.md` (`Requalifying a Technical Story`, le `Trigger`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la table de `## Execution Rules` de `skills/following-the-rules/SKILL.md`, dont chaque ligne commence par `` | `<name>` | ``.
- Produces: dans le gabarit, une ligne qui commence par `**Execution rules:**` et porte chaque nom entre accents graves.

- [ ] **Step 1: Write the failing tests**

Applique aux deux fichiers de tests le diff ci-dessous, à la main avec l'outil d'édition, tel quel. Il retire les gardes qui tenaient les copies, remplace chaque contrat `shared` sur `following-the-rules delivering-a-story` qui tenait une copie par un `require` sur `following-the-rules`, et ajoute les gardes du gabarit.

````diff
diff --git a/tests/test-skill-content.sh b/tests/test-skill-content.sh
index 4075b0c..d06f72c 100644
--- a/tests/test-skill-content.sh
+++ b/tests/test-skill-content.sh
@@ -597,8 +597,6 @@ require opening-a-batch "allocation reads main on the remote" "git ls-tree --nam
 # --- delivering-a-story (spec 3, 4.4, 5.1, 5.3) ---
 require delivering-a-story "concurrency via declared Sections"  "Sections:"
 require delivering-a-story "transcription is the first commit"  "first commit on the branch"
-require delivering-a-story "freeze travels in Global Constraints" "Global Constraints"
-require delivering-a-story "freeze ends when the PR opens"      "freeze is lifted when the pull request opens"
 require delivering-a-story "hands off to writing-plans"         "superpowers:writing-plans"
 require delivering-a-story "requires SDD"                       "superpowers:subagent-driven-development"
 require delivering-a-story "constrains finishing to the PR"     "Push and create a Pull Request"
@@ -641,50 +639,69 @@ require delivering-a-story "a fired stop condition routes to handling-a-stopped-
 require delivering-a-story "a rule belongs to exactly one spec" "A rule belongs to exactly one spec."
 require delivering-a-story "no ruling houses a rule twice"      "no ruling puts a rule in two places"
 
-# --- delivering-a-story: what Global Constraints carries (spec section "The user story document") ---
+# --- delivering-a-story: what Global Constraints carries ---
 require delivering-a-story "GC carries the batch Constraints"   "\`Constraints\` section copied verbatim"
-require delivering-a-story "GC carries the spec freeze"         "freeze of the spec file"
-require delivering-a-story "GC carries the authority rule"      "That rule is the authority rule \`Global Constraints\` carries"
-require delivering-a-story "the authority rule is stated in full" "the spec wins — without exception and without deliberation"
-require delivering-a-story "GC carries the corrective stop condition" "the stop condition proper to a corrective batch, written out in full"
-require delivering-a-story "GC lists the concision rules"       "- the concision rules;"
-require delivering-a-story "GC carries the concision rules"     "In every story, \`Global Constraints\` carries the concision rules, written out in full"
-require delivering-a-story "the concision block names what it covers" "These rules hold for every document, pull request body and commit message this story writes"
-require delivering-a-story "GC carries the guarded-code rules"  "carries the rules for code under a flag, written out in full"
-require delivering-a-story "GC carries the technical stop condition" "carries the stop condition proper to a technical story, written out in full"
-require delivering-a-story "GC lists the technical stop condition" "- **in a technical story only**, the stop condition proper to a technical story"
-require delivering-a-story "GC lists the stop condition on a constraint or an ADR" \
-    "- **only if the batch declares constraints or \`docs/adr/\` carries an ADR**, the stop condition on a constraint or an ADR that cannot be held"
-require delivering-a-story "GC carries the stop condition on a constraint or an ADR" \
-    "**In a story whose batch declares constraints, or whose \`docs/adr/\` carries an ADR, \`Global Constraints\` carries the stop condition on a constraint or an ADR that cannot be held, written out in full.**"
+require delivering-a-story "GC is written from its template" \
+    "is written from \`skills/delivering-a-story/references/global-constraints.md\`"
+require delivering-a-story "GC names the rules that hold and gives the ADR paths" \
+    "the name of each execution rule that holds for this story, and the path of each ADR this story's code holds, or \`none\`"
+require delivering-a-story "GC copies no execution rule" \
+    "**It names the execution rules and copies none.**"
+require delivering-a-story "a rule copied into a plan drifts" \
+    "a rule copied into a plan drifts from the one written there"
+require delivering-a-story "the technical stop condition is named in GC" \
+    "what catches a false one is the \`technical stop condition\`, which \`Global Constraints\` names"
+# The mirror: no text of an execution rule survives in the story skill or in its
+# template, where it would drift from the foundation with nothing to hold it.
+absent "the story skill copies no execution rule" \
+    "written out in full|Copy (the block below|it) verbatim|undoing it is expensive|Every paragraph carries one rule|no task modifies the spec file|holds up when the flag is on" \
+    delivering-a-story
+
+# The template of `Global Constraints` is pasted into a plan, where whoever
+# executes or reviews a task reads it with nothing else in hand.
+GC_TEMPLATE="$SKILLS_DIR/delivering-a-story/references/global-constraints.md"
+GC_FLAT=""
+if [ -f "$GC_TEMPLATE" ]; then
+    pass "the Global Constraints template exists"
+    GC_FLAT="$(body_flat "$GC_TEMPLATE")"
+else
+    fail "the Global Constraints template exists"
+fi
+gc_has() {
+    case "$GC_FLAT" in
+        *"$2"*) pass "the Global Constraints template: $1" ;;
+        *)      fail "the Global Constraints template: $1" ;;
+    esac
+}
+gc_has "asks to invoke the foundation" \
+    "Before you execute or review a task of this plan, invoke \`supercharlouze:following-the-rules\`."
+gc_has "says where the named rules are read" \
+    "Its \`Execution Rules\` section says where each rule named here is written: read them there, and follow them."
+gc_has "carries the batch's constraints word for word" \
+    "<the \`Constraints\` section of the batch document, word for word>"
+gc_has "labels the ADR paths" \
+    "**ADRs the code of this story holds:** \`docs/adr/<slug>.md\`"
+gc_has "the ADR paths are none when there is no ADR" \
+    "write \`none\` when it carries none"
+gc_has "keeps the names of the rules that hold, and no other" \
+    "Keep on the \`Execution rules:\` line the name of each rule that holds for this story, and delete the others."
+gc_has "takes from the foundation which story a rule holds for" \
+    "\`Execution Rules\` in \`supercharlouze:following-the-rules\` says which story each rule holds for."
+gc_has "is changed only where its steps fill it" \
+    "change nothing in it but what the steps below fill"
+
 require delivering-a-story "a batch declares constraints when they are not none" \
     "A batch declares constraints when its \`Constraints\` section is not \`none\`."
 require delivering-a-story "docs/adr carries an ADR when a .md file sits in it" \
     "\`docs/adr/\` carries an ADR when a \`.md\` file is placed directly in it, in this story's worktree."
-require delivering-a-story "working around a constraint or an ADR breaks what the implementer cannot see" \
-    "A constraint is a decision another story of the batch relies on, and an ADR is a decision your human partner took for all the code to come, so an implementer who works around either breaks something they cannot see."
 require delivering-a-story "step 5 names both triggers of the condition" \
     "In a story whose batch declares constraints or whose \`docs/adr/\` carries an ADR: if, while conducting it, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner."
 require delivering-a-story "step 5 sets aside the constraint the spec contradicts" \
     "A constraint the spec contradicts is not this case, since the spec wins."
 require delivering-a-story "the worktree carries the ADRs the code holds" \
     "the worktree carries the ADRs \`main\` carried when the branch started, which are the ones this story's code holds."
-require delivering-a-story "an implementer leaves the ADR to the review" \
-    "Only your human partner decides an ADR, so an implementer who takes such a decision reports it and leaves the file to the review."
-require delivering-a-story "GC lists the ADRs the code holds" \
-    "- **only if \`docs/adr/\` carries an ADR**, the paths of the ADRs this story's code holds;"
-require delivering-a-story "GC lists the conditions of an ADR" \
-    "- the conditions of an ADR, with the obligation to record as an \`Open ruling:\` the decision that meets them."
-require delivering-a-story "GC carries the paths of the ADRs" \
-    "**When \`docs/adr/\` carries an ADR, \`Global Constraints\` lists the path of each one, under the sentence below.**"
-require delivering-a-story "the sentence the paths sit under" \
-    "The code this story writes holds these ADRs."
 require delivering-a-story "an ADR left out of the list binds nobody" \
     "An implementer reads only this list, so an ADR whose path is missing from it binds nobody."
-require delivering-a-story "GC carries the conditions of an ADR" \
-    "**In every story, \`Global Constraints\` carries the conditions of an ADR, written out in full, with the obligation to record the decision that meets them.**"
-require delivering-a-story "a task records the decision as an open ruling" \
-    "When you take a technical decision that meets them, say so in your report: it is recorded as an \`Open ruling:\`, which asks your human partner whether they want it as an ADR. Write nothing in \`docs/adr/\`."
 require delivering-a-story "no task writes in docs/adr" \
     "No task writes in \`docs/adr/\`. The ADR a decision of this story deserves is written at the review (Step 7), once your human partner wants it."
 require delivering-a-story "step 6 records the decision that meets the conditions" \
@@ -705,16 +722,9 @@ require delivering-a-story "red flag: no task writes the ADR" \
     "| \"This decision deserves an ADR, I'll write it with the code\" | No task writes in \`docs/adr/\`. Record an \`Open ruling:\`, and write the ADR at the review if your human partner wants it. |"
 require delivering-a-story "red flag: a ruling replaces no stop condition" \
     "| \"This constraint, or this ADR, cannot be held, I'll work around it and record a ruling\" | A ruling replaces no stop condition. Another story of the batch relies on that constraint, and your human partner decided that ADR: stop and put it to them. |"
-require delivering-a-story "the owning batch does not decide"   "whether the flag was declared by this story's batch or by another one"
-require delivering-a-story "GC is the only channel to SDD subagents" "only channel to this skill's rules is this list"
-
-# --- delivering-a-story: the rules a guarded story copies into Global
-# Constraints (spec section "Code under a feature flag") ---
-require delivering-a-story "guarded code holds up in every situation" "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off:"
-require delivering-a-story "both states work on the same data" "The two states work on the same data: what one produces, the other reads and uses, with no error and no data loss."
-require delivering-a-story "flag off restores the former behaviour" "With the flag off, the user finds the behaviour from before the batch."
-require delivering-a-story "both states and their coexistence are tested" "The story's pull request tests the flag-on behaviour, the flag-off behaviour, and their coexistence."
-require delivering-a-story "lifting only removes"               "Lifting the flag comes down to deleting the branching and the behaviour from before the batch, without writing anything new."
+require delivering-a-story "red flag: the owning batch does not decide" \
+    "| \"This story writes guarded code, but the flag is another batch's\" | \`Global Constraints\` names \`code under a feature flag\` all the same. What decides is that this story writes guarded code, not which batch owns the flag. |"
+
 require following-the-rules "the foundation states the rules for code under a flag" "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off:"
 
 # --- delivering-a-story: Lifting and Teardown Stories ---
@@ -1461,7 +1471,7 @@ require following-the-rules "a corrective batch's delta carries no block" \
 # records" and "Bounded change") ---
 require following-the-rules "defines the ADR" \
         "**ADR** — the document that records a technical decision of the project and its reason: a \`.md\` file placed directly in \`docs/adr/\`, at \`docs/adr/<slug>.md\`."
-# The reference text of the conditions. Word for word: another skill copies it.
+# The reference text of the conditions.
 require following-the-rules "the conditions of an ADR, word for word" \
         "A technical decision is recorded as an ADR only if it meets these conditions: - undoing it is expensive; - it surprises whoever does not know its context; - it settles between real alternatives."
 require following-the-rules "the human decides every ADR" \
@@ -1584,6 +1594,10 @@ require following-the-rules "the freeze lifts when the pull request opens" \
     "Once the pull request is open the freeze lifts"
 require following-the-rules "why the freeze is an execution rule" \
     "The spec file travels in the same branch as the code, so a task can edit it, which is why the freeze is an execution rule."
+require handling-a-stopped-story "the technical stop condition is named in the plan" \
+    "states it, and the \`Global Constraints\` of every technical story names it"
+absent_everywhere "no skill says an execution rule is copied into Global Constraints" \
+    "copied into the \`Global Constraints\`|copies it into the \`Global Constraints\`|go into \`Global Constraints\`"
 
 # The rules for code under a flag are written in full in the foundation.
 require following-the-rules "guarded code holds up in the three states of the flag" \
diff --git a/tests/test-skill-contracts.sh b/tests/test-skill-contracts.sh
index 28bd514..eba02a0 100644
--- a/tests/test-skill-contracts.sh
+++ b/tests/test-skill-contracts.sh
@@ -195,29 +195,39 @@ require closing-a-batch "the release invokes the gesture" \
 require closing-a-batch "an undelivered block joins the register through the gesture" \
     "invoke \`supercharlouze:writing-in-a-gaps-register\` and add it under **Gaps**"
 
-# The corrective batch's stop condition is copied "in full" into a story's
-# Global Constraints. `following-the-rules` states it and `delivering-a-story` has it
-# copied; a copy that adds or drops a sentence is no longer the condition the
-# spec names. One assertion over both ends.
-shared "the corrective stop condition is copied exactly as stated" \
-    "you discover that it is the **spec** that is wrong and the code that is right, stop. The batch is no longer corrective and must be requalified." \
-    following-the-rules delivering-a-story
-
-# The technical story's stop condition travels the same way: `following-the-rules`
-# states it and `delivering-a-story` has it copied into a story's Global
-# Constraints. Same argument as above — a copy that adds or drops a sentence is no
-# longer the condition the spec names. One assertion over both ends.
-shared "the technical stop condition is copied exactly as stated" \
-    "If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical." \
-    following-the-rules delivering-a-story
+# A story's Global Constraints names the execution rules and copies none: the
+# foundation is the one place each is written, and whoever executes or reviews a
+# task reads it there. The template of Global Constraints lets a plan cite every
+# name the foundation gives, and no other: a name the foundation does not give
+# sends its reader to a rule that is written nowhere, and a name the template
+# leaves out is a rule no plan can ask for.
+foundation_rule_names() {
+    awk '/^## Execution Rules$/ { f = 1; next }
+         f && /^#/ { exit }
+         f && /^\| `/ { split($0, cell, "`"); print cell[2] }' \
+        "$SKILLS_DIR/following-the-rules/SKILL.md" | sort
+}
+template_rule_names() {
+    { grep -m1 '^\*\*Execution rules:\*\*' \
+        "$SKILLS_DIR/delivering-a-story/references/global-constraints.md" 2>/dev/null || true; } \
+        | { grep -oE '`[^`]+`' || true; } | tr -d '`' | sort
+}
+FOUNDATION_RULES="$(foundation_rule_names)"
+TEMPLATE_RULES="$(template_rule_names)"
+if [ -n "$FOUNDATION_RULES" ] && [ "$FOUNDATION_RULES" = "$TEMPLATE_RULES" ]; then
+    pass "the Global Constraints template cites every execution rule the foundation names, and no other"
+else
+    fail "the Global Constraints template cites every execution rule the foundation names, and no other"
+fi
 
-# The stop condition on a constraint or an ADR that cannot be held travels the
-# same way, with the sentence that bounds it: an implementer who meets a
-# constraint the spec contradicts must find, in the same copy, that this is not
-# the case.
-shared "the stop condition on a constraint or an ADR is copied exactly as stated" \
-    "If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner. A constraint the spec contradicts does not fall under this condition: the spec wins." \
-    following-the-rules delivering-a-story
+# The stop conditions the flow adds are written in the foundation, each with the
+# sentence that bounds it.
+require following-the-rules "states the corrective stop condition" \
+    "you discover that it is the **spec** that is wrong and the code that is right, stop. The batch is no longer corrective and must be requalified."
+require following-the-rules "states the technical stop condition" \
+    "If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical."
+require following-the-rules "states the stop condition on a constraint or an ADR" \
+    "If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner. A constraint the spec contradicts does not fall under this condition: the spec wins."
 
 # The condition no longer bears on a constraint alone, nor fires only in a batch
 # that declares constraints: the former wording must survive nowhere, or a story
@@ -226,33 +236,21 @@ absent "the stop condition is no longer bounded to a constraint" \
     "a constraint of its batch cannot be held|constraint condition|whose batch declares constraints only" \
     using-batches following-the-rules delivering-a-story
 
-# The conditions of an ADR are copied into every story's Global Constraints.
-# `following-the-rules` states them and `delivering-a-story` has them copied: a
-# condition spelled differently in the copy is no longer the threshold the
-# human agreed to.
-shared "the conditions of an ADR are copied exactly as stated" \
-    "A technical decision is recorded as an ADR only if it meets these conditions: - undoing it is expensive; - it surprises whoever does not know its context; - it settles between real alternatives." \
-    following-the-rules delivering-a-story
-
 # An unrecorded departure is answered by the delivery review, not by what
 # closing does with the design: the former red flag must survive nowhere.
 absent "an unrecorded departure no longer leaves the design false" \
     "describing a mechanism nobody built" \
     delivering-a-story
 
-# The concision rules are copied into every story's Global Constraints.
-# `following-the-rules` states them and `delivering-a-story` has them copied; a rule
-# spelled differently in the copy is no longer the rule the implementers obey.
-# Only each rule's first sentence is pinned: the copy adapts the exception and
-# the gloss on relief for an implementer who reads nothing else.
+# The concision rules are written in the foundation, where whoever executes or
+# reviews a task reads them.
 for rule in \
     "Every sentence says one exact thing, once, and stands on its own." \
     "Every paragraph carries one rule." \
     "A rule says how far it holds, and an exception presents itself as one." \
     "A text says what it delivers or decides, without telling how it got there or why." \
     "No sentence is set in relief"; do
-    shared "the concision rule is copied as stated: $rule" "$rule" \
-        following-the-rules delivering-a-story
+    require following-the-rules "states the concision rule: $rule" "$rule"
 done
 
 # The mirror: an item of Global Constraints is named, never counted or numbered.
@@ -610,13 +608,10 @@ shared "the pairing is stated by the negation" \
 absent_everywhere "no skill pairs spec change and code unconditionally" \
     "ship together or not at all|\*both\* the spec change|the spec change and the code together"
 
-# The freeze is copied verbatim into the Global Constraints of every plan, so the
-# skill that states the norm and the skill that copies it must spell it identically.
-# Two separate assertions would each stay green while the copied wording drifted
-# from the stated one, and the implementers only ever read the copy.
-shared "the freeze is spelled alike wherever it is stated" \
-    "Between the first commit of the branch and the opening of the pull request, no task modifies the spec file" \
-    following-the-rules delivering-a-story
+# The freeze is written in the foundation, where whoever executes or reviews a
+# task reads it.
+require following-the-rules "states the freeze of the spec file" \
+    "Between the first commit of the branch and the opening of the pull request, no task modifies the spec file"
 
 # The mirror. A skill carrying both anchors would leave the positive assertion
 # green while still handing implementers the old one. The needle is the bare term:
@@ -1021,17 +1016,11 @@ absent "the adoption does not copy the conditions of an ADR" \
     "undoing it is expensive|settles between real alternatives" \
     adopting-a-module
 
-# The rules for code under a flag are written in full in the foundation, and
-# `delivering-a-story` has them copied into a story's Global Constraints. A
-# copy that adds or drops a rule is no longer what the foundation states. One
-# assertion over both ends.
-shared "the rules for code under a flag are copied exactly as stated" \
-    "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off: - The two states work on the same data: what one produces, the other reads and uses, with no error and no data loss. - With the flag off, the user finds the behaviour from before the batch. - The story's pull request tests the flag-on behaviour, the flag-off behaviour, and their coexistence. - Lifting the flag comes down to deleting the branching and the behaviour from before the batch, without writing anything new." \
-    following-the-rules delivering-a-story
+# The rules for code under a flag are written in full in the foundation, as one
+# block.
+require following-the-rules "states the rules for code under a flag as one block" \
+    "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off: - The two states work on the same data: what one produces, the other reads and uses, with no error and no data loss. - With the flag off, the user finds the behaviour from before the batch. - The story's pull request tests the flag-on behaviour, the flag-off behaviour, and their coexistence. - Lifting the flag comes down to deleting the branching and the behaviour from before the batch, without writing anything new."
 
-# The story skill says where each text it has copied is stated.
-require delivering-a-story "copies the rules for code under a flag as the foundation states them" \
-    "Copy the block below verbatim, exactly as \`supercharlouze:following-the-rules\` states it"
 require delivering-a-story "takes the form of the gating sentence from the foundation" \
     "in the form \`supercharlouze:following-the-rules\` fixes"
 absent "the story skill no longer claims to be where the rules for code under a flag are written" \
@@ -1055,12 +1044,6 @@ done
 absent_everywhere "no skill points at using-batches for a rule the foundation carries" \
     "\`Concision\` in \`supercharlouze:using-batches\`|\`The Model\` of \`supercharlouze:using-batches\`"
 
-# The obligation to report a decision that meets the conditions of an ADR is
-# stated in the foundation and copied into a story's Global Constraints.
-shared "the open ruling obligation is copied exactly as stated" \
-    "it is recorded as an \`Open ruling:\`, which asks your human partner whether they want it as an ADR. Write nothing in \`docs/adr/\`." \
-    following-the-rules delivering-a-story
-
 # The prompt of the batch-document reader is pasted into the dispatch of a
 # subagent that loads no skill, so it copies what it needs from the skills that
 # state it. One assertion over both ends, so a copy does not drift.
````

- [ ] **Step 2: Run tests to verify they fail**

Run, l'une après l'autre, chacune seule :

`bash tests/test-skill-contracts.sh > /tmp/us21-t2-red-contracts.txt 2>&1; grep FAIL /tmp/us21-t2-red-contracts.txt`

`bash tests/test-skill-content.sh > /tmp/us21-t2-red-content.txt 2>&1; grep FAIL /tmp/us21-t2-red-content.txt`

Expected, dans `test-skill-contracts.sh`, un seul `[FAIL]` : « the Global Constraints template cites every execution rule the foundation names, and no other ».

Expected, dans `test-skill-content.sh`, ces `[FAIL]` et aucun autre :

- « GC is written from its template » ;
- « GC names the rules that hold and gives the ADR paths » ;
- « GC copies no execution rule » ;
- « a rule copied into a plan drifts » ;
- « the technical stop condition is named in GC » ;
- « the story skill copies no execution rule (present in: delivering-a-story) » ;
- « the Global Constraints template exists », et les huit gardes « the Global Constraints template: … » ;
- « red flag: the owning batch does not decide » ;
- « the technical stop condition is named in the plan » ;
- « no skill says an execution rule is copied into Global Constraints », présent dans `delivering-a-story` et `handling-a-stopped-story`.

Si un autre `[FAIL]` apparaît, arrête-toi et rapporte-le.

- [ ] **Step 3: Create the template**

Crée `skills/delivering-a-story/references/global-constraints.md` avec exactement ce contenu. La ligne `**Execution rules:**` tient sur une seule ligne, et la phrase « Before you execute… » commence à la ligne suivante, sans ligne vide entre les deux.

`````markdown
# Global Constraints

Write the `Global Constraints` section of the plan from this template. Whoever
executes or reviews a task reads it with nothing else in hand: change nothing in
it but what the steps below fill.

```markdown
## Global Constraints

**Constraints of the batch**, which every task of this plan holds:

<the `Constraints` section of the batch document, word for word>

**Execution rules:** `spec freeze`, `spec authority`, `concision`, `corrective stop condition`, `code under a feature flag`, `technical stop condition`, `untenable constraint or ADR`, `held ADRs`, `decision worth an ADR`
Before you execute or review a task of this plan, invoke
`supercharlouze:following-the-rules`. Its `Execution Rules` section says where
each rule named here is written: read them there, and follow them.

**ADRs the code of this story holds:** `docs/adr/<slug>.md`, `docs/adr/<slug>.md`
```

1. Copy the `Constraints` section of the batch document under the first label,
   verbatim.
2. Keep on the `Execution rules:` line the name of each rule that holds for
   this story, and delete the others. `Execution Rules` in
   `supercharlouze:following-the-rules` says which story each rule holds for.
   A batch declares constraints when its `Constraints` section is not `none`.
   `docs/adr/` carries an ADR when a `.md` file is placed directly in it, in
   this story's worktree.
3. Under the last label, list the path of every ADR `docs/adr/` carries in this
   story's worktree, and write `none` when it carries none. An implementer
   reads only this list, so an ADR whose path is missing from it binds nobody.
`````

- [ ] **Step 4: Rewrite `Step 4 — Write the Plan` of `delivering-a-story`**

Dans `skills/delivering-a-story/SKILL.md`, supprime tout ce qui va de la ligne qui commence par `` `Global Constraints` — which `superpowers:writing-plans` defines as implicitly `` jusqu'à la ligne vide qui précède `**Commit the story document — header, the two empty sections and`. Ce passage porte la liste de ce que `Global Constraints` porte, puis la copie de chaque règle avec ses commentaires ; son dernier paragraphe est « Only your human partner decides an ADR, so an implementer who takes such a decision reports it and leaves the file to the review. » Le paragraphe `**Commit the story document — …` reste, intact.

Mets à sa place exactement ceci, suivi d'une ligne vide :

```markdown
`Global Constraints` — which `superpowers:writing-plans` defines as implicitly
part of every task's requirements — is written from
`skills/delivering-a-story/references/global-constraints.md`. It carries the
batch's `Constraints` section copied verbatim, the name of each execution rule
that holds for this story, and the path of each ADR this story's code holds, or
`none`.

**It names the execution rules and copies none.** Whoever executes or reviews a
task reads them in `supercharlouze:following-the-rules`, which
`Global Constraints` tells them to invoke; a rule copied into a plan drifts from
the one written there.
```

Le paragraphe « `Sections:` names every section the tasks of the plan will touch. One the detection was not run for goes through it before the story document is committed (Step 1). », plus haut dans la même étape, ne change pas.

- [ ] **Step 5: Fix the three sentences of `delivering-a-story` that pointed at the copies**

Dans `Step 3 — Commit the Spec Change First`, remplace `the freeze of Step 4 gets` par `the freeze of the spec file gets`.

Dans `Step 4 — Write the Plan`, remplace :

```markdown
what catches a false one is the stop condition, in `Global Constraints` below,
and it fires during the implementation rather than here.
```

par :

```markdown
what catches a false one is the `technical stop condition`, which
`Global Constraints` names, and it fires during the implementation rather than
here.
```

Dans `Red Flags`, sur la ligne « This story writes guarded code, but the flag is another batch's », remplace ``The rules for code under a flag go into `Global Constraints` all the same.`` par `` `Global Constraints` names `code under a feature flag` all the same.``

- [ ] **Step 6: Fix the trigger of `handling-a-stopped-story`**

Dans `skills/handling-a-stopped-story/SKILL.md`, section `Requalifying a Technical Story`, remplace :

```markdown
states it and `supercharlouze:delivering-a-story` copies it into the
`Global Constraints` of every technical story: a story that discovers it changes
```

par :

```markdown
states it, and the `Global Constraints` of every technical story names it: a story that discovers it changes
```

- [ ] **Step 7: Run the whole suite**

Run, seule : `bash tests/run-all.sh > /tmp/us21-t2-green.txt 2>&1; grep -c PASS /tmp/us21-t2-green.txt; grep -c FAIL /tmp/us21-t2-green.txt; tail -1 /tmp/us21-t2-green.txt`

Expected: aucun `[FAIL]`, et la dernière ligne dit `all tests passed`.

- [ ] **Step 8: Commit**

```bash
git add skills/delivering-a-story skills/handling-a-stopped-story/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "feat: Global Constraints nomme les règles d'exécution sans les recopier" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

## Observed drift
