# Le socle following-the-rules Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `following-the-rules` porte ce qui vaut en permanence, toute skill d'entrée l'invoque en commençant, et les règles du code gardé par un flag n'ont plus de reformulation partielle.

**Architecture:** Le socle reçoit de `using-batches` le modèle, le modèle git, l'autorité, la langue, la concision et la conversation, et de `writing-a-user-story` les règles d'exécution, la forme de la mention de flag et les règles du code gardé. `writing-a-user-story` garde les textes que `Global Constraints` recopie, qu'un contrat `shared` tient identiques à ceux du socle.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** Feature flags > Code under a feature flag, Story > The user story document
**Blocks:** none

Cette story n'est pas technique : son premier commit supprime l'entrée du gaps register qu'elle résorbe, et une story technique ne retire rien.

## Global Constraints

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

### The spec file is frozen

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

### The spec wins

When the batch and the spec contradict each other, the spec wins, without
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

### The stop condition on a constraint or an ADR

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

### ADRs

> The code this story writes holds these ADRs.

- `docs/adr/une-skill-par-moment-d-invocation.md`

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

### Ce dépôt

- Un texte déplacé d'une skill à une autre garde ses mots, hors les retouches que la tâche nomme. Aucune tâche n'ajoute une règle que `skills/` ne porte pas déjà.
- `skills/following-the-rules/SKILL.md` ne contient ni `supercharlouze:` ni `superpowers:`.
- Une skill est entièrement anglaise et ne cite aucune section de `docs/specs/supercharlouze.md`. Une section qu'une skill nomme entre parenthèses, comme (`The Model`), est un titre de cette même skill.
- Les fichiers de `skills/` et de `tests/` ont des fins de ligne LF.
- Les fichiers s'écrivent avec l'outil d'écriture ou d'édition de fichiers : l'outil Bash de ce poste mange les barres obliques inverses dans les heredocs et dans les `sed` ou `perl` en ligne. Ni `python` ni `node` ne sont disponibles.
- Une garde suit le texte qu'elle tient : quand un texte quitte une skill, chaque `require`, `shared` ou `absent` qui le tenait nomme la skill qui le porte désormais. Aucune garde n'est supprimée, sauf celle que la tâche nomme.
- `tests/lib.sh` fournit `declared_skills [type]`, `skill_front`, `skill_text` (résultat dans `$SKILL_TEXT`), `require <skill> <label> <needle>`, `shared <label> <needle> <skill>…`, `absent <label> <regex> <skill>…` et `absent_everywhere <label> <regex>`. Un needle se lit sur le texte aplati : une seule espace entre deux mots, pas de marqueur `>`.
- La suite se lance par `bash tests/run-all.sh` et prend environ deux minutes. Un seul fichier se lance par `bash tests/<fichier>.sh`.
- Toute commande `git` qui écrit un commit passe par `bash ~/.config/github-app/as-agent.sh git …`, y compris `commit --amend` et `rebase`. Sans ce préfixe, le commit porte la mauvaise identité.
- Un message de commit se termine par la ligne `Co-Authored-By: Charlouze <me@charlouze.com>` et par aucune autre ligne d'attribution.
- Le sujet d'un commit est en français, à la forme Conventional Commits, et ne porte qu'un sujet.
- Aucune tâche ne pousse la branche, ni ne modifie `docs/specs/` ou `docs/adr/`.

## Review Focus

- Un texte déplacé perd sa garde : après chaque tâche, le nombre de `[PASS]` de la suite ne descend pas sous celui d'avant la tâche, hors les gardes que la tâche dit de supprimer.
- Le socle nomme une skill dans un texte déplacé : la garde de la tâche 1 chasse `supercharlouze:` et `superpowers:` dans le socle.
- Un renvoi entre parenthèses vise une section partie ailleurs : `tests/test-cross-references.sh` échoue sur une section nommée entre parenthèses qui n'est pas un titre de la skill.
- Une skill d'entrée ajoutée plus tard n'invoque pas le socle : la garde de la tâche 4 parcourt `declared_skills entry`.
- Le socle est écrit avec des fins de ligne CRLF : la garde de forme de la tâche 1 cherche la ligne exacte `user-invocable: false`.

---

### Task 1: Le socle existe

**Files:**
- Create: `skills/following-the-rules/SKILL.md`
- Modify: `tests/skills.txt`, `tests/test-skill-frontmatter.sh`, `tests/test-skill-content.sh`, `README.md`

**Interfaces:**
- Consumes: `skills/using-batches/SKILL.md` tel que la branche le porte avant cette tâche, dont les numéros de ligne ci-dessous sont ceux-là.
- Produces: la skill `following-the-rules`, dont les titres sont `The Model`, `The Git Model`, `Authority and Conflict Rules`, `Language`, `Concision`, `How to apply them`, `Conversation`, `Execution Rules`, `Stop Conditions`, `Code Under a Feature Flag`, `Decisions Worth an ADR` et `Red Flags`. Après cette tâche, `using-batches` porte encore ses copies : la tâche 2 les retire.

- [ ] **Step 1: Write the failing tests**

Dans `tests/skills.txt`, ajoute en dernière ligne :

```
following-the-rules foundation
```

Dans `tests/test-skill-frontmatter.sh`, juste avant la ligne `actual="$(ls "$SKILLS_DIR" | sort | tr '\n' ' ')"`, ajoute :

```bash
# The foundation is invoked by a skill or by a plan, never from the slash menu.
# Its description asks for that call, and it stays invocable by the model:
# whoever executes a task of a plan invokes it without a skill telling it to.
FOUNDATIONS="$(declared_skills foundation | tr '\n' ' ')"
if [ "$FOUNDATIONS" = "following-the-rules " ]; then
    pass "following-the-rules is the one declared foundation"
else
    fail "following-the-rules is the one declared foundation (got: $FOUNDATIONS)"
fi

front="$(skill_front following-the-rules)"
if printf '%s\n' "$front" | grep -qx 'user-invocable: false'; then
    pass "following-the-rules is hidden from the slash menu"
else
    fail "following-the-rules is hidden from the slash menu"
fi

desc="$(printf '%s\n' "$front" | sed -n 's/^description:[[:space:]]*//p' | head -1)"
case "$desc" in
    "Use when a skill or a plan tells you to invoke following-the-rules"*)
        pass "following-the-rules asks to be invoked when a skill or a plan says so" ;;
    *)  fail "following-the-rules asks to be invoked when a skill or a plan says so" ;;
esac

case "$front" in
    *"disable-model-invocation"*) fail "following-the-rules stays invocable by the model" ;;
    *)                            pass "following-the-rules stays invocable by the model" ;;
esac
```

À la fin de `tests/test-skill-content.sh`, juste avant sa dernière ligne `exit $((FAILURES > 0))`, ajoute :

```bash
# --- following-the-rules, the foundation ---

# The foundation is loaded by whoever executes a task of a plan, who loads no
# other skill: a skill it named would be a text that reader never opens.
absent "the foundation names no skill" "supercharlouze:|superpowers:" following-the-rules

# Each execution rule has a name a story's Global Constraints can cite.
for rule in "spec freeze" "spec authority" "concision" "corrective stop condition" \
    "code under a feature flag" "technical stop condition" \
    "untenable constraint or ADR" "held ADRs" "decision worth an ADR"; do
    require following-the-rules "names the execution rule: $rule" "| \`$rule\` |"
done

# The rules for code under a flag are written in full in the foundation.
require following-the-rules "guarded code holds up in the three states of the flag" \
    "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off:"
require following-the-rules "the two states work on the same data" \
    "The two states work on the same data: what one produces, the other reads and uses, with no error and no data loss."
require following-the-rules "the flag off gives back the behaviour from before the batch" \
    "With the flag off, the user finds the behaviour from before the batch."
require following-the-rules "the pull request tests each state and their coexistence" \
    "The story's pull request tests the flag-on behaviour, the flag-off behaviour, and their coexistence."
require following-the-rules "lifting only removes" \
    "Lifting the flag comes down to deleting the branching and the behaviour from before the batch, without writing anything new."

# The foundation fixes the forms of the gating sentence.
require following-the-rules "the gating sentence with a lifting condition" \
    "🔒 \`billing.recurring\`, off by default — lifted when the \`facturation\` module is fully delivered"
require following-the-rules "what varies in a gating sentence" \
    "The flag's name, its default and its lifting condition vary; the rest of each form is fixed."

# The foundation fixes the form of a prompt that starts a step in a fresh context.
require following-the-rules "a next-step prompt stands on its own" \
    "it names the skill to invoke and the document to start from, and never refers back to the conversation"

# A decision that meets the conditions of an ADR is reported, never written.
require following-the-rules "a decision worth an ADR is reported as an open ruling" \
    "say so in your report: it is recorded as an \`Open ruling:\`, which asks your human partner whether they want it as an ADR. Write nothing in \`docs/adr/\`."
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `bash tests/test-skill-frontmatter.sh; bash tests/test-skill-content.sh | grep FAIL`
Expected: `[FAIL] following-the-rules/SKILL.md exists` et un `[FAIL]` pour chaque garde ajoutée, sauf « the foundation names no skill », qui échoue avec `no such skill`.

- [ ] **Step 3: Write the head of the skill**

Crée `skills/following-the-rules/SKILL.md` avec l'outil d'écriture de fichiers, fins de ligne LF, avec exactement ce contenu :

```markdown
---
name: following-the-rules
description: Use when a skill or a plan tells you to invoke following-the-rules - carries what holds at every moment of the flow, from the model and the git model to the rules whoever executes or reviews a task of a plan follows
user-invocable: false
---

# Following the Rules

These rules hold at every moment of the flow. Read them once per session, before the skill or the plan that sent you here.

```

Le fichier se termine par une ligne vide après ce paragraphe.

- [ ] **Step 4: Append the sections that come from using-batches**

Run:

```bash
awk 'NR>=26 && NR<=91 || NR>=150 && NR<=230 || NR>=339 && NR<=389' skills/using-batches/SKILL.md >> skills/following-the-rules/SKILL.md
grep -n '^#' skills/following-the-rules/SKILL.md
```

Expected: les titres `# Following the Rules`, `## The Model`, `## The Git Model`, `## Authority and Conflict Rules`, `## Language`, `## Concision`, `### How to apply them`, `## Conversation`, dans cet ordre, et aucun autre. Si un autre titre apparaît, `using-batches` a changé : arrête-toi et rapporte-le.

- [ ] **Step 5: Retouch the moved text**

Avec l'outil d'édition, dans `skills/following-the-rules/SKILL.md` :

1. Dans le paragraphe `**Spec**`, supprime ` — see `What a Spec Says` below`. La phrase devient : `…and it carries **business rules and intentions; the mechanism stays in the code**. It carries no date…`.

2. Dans le paragraphe `**The flag is a specified object, not an implementation detail.**`, remplace

   ```
   The spec section concerned states its name and its default, as a gating sentence in one of the forms `supercharlouze:writing-a-user-story` fixes — `` 🔒 `billing.recurring`, off by default ``. Without that declaration,
   ```

   par le texte ci-dessous, la suite du paragraphe, à partir de `Without that declaration,`, devenant un paragraphe à elle après la dernière ligne :

   ````
   The spec section concerned states its name and its default, as a gating sentence in one of these forms, which adds its lifting condition when the declared scope reaches beyond the batch:

   ```markdown
   🔒 `billing.recurring`, off by default
   🔒 `billing.recurring`, off by default — lifted when the `facturation` module is fully delivered
   ```

   The flag's name, its default and its lifting condition vary; the rest of each form is fixed.

   Without that declaration,
   ````

3. Supprime en entier le paragraphe qui commence par `**Guarded code has rules of its own, and they travel into the plan.**`, avec la ligne vide qui le suit.

4. Dans le paragraphe `**Every conflict is recorded for the human.**`, remplace `` `superpowers:subagent-driven-development` keeps a ledger `` par `the execution of a plan by subagents keeps a ledger`.

5. Dans `## Language`, remplace `` The English skeleton that `superpowers:writing-plans` imposes on a story `` par `The English skeleton a plan imposes on a story`.

- [ ] **Step 6: Append the execution rules and the red flags**

Ajoute à la fin de `skills/following-the-rules/SKILL.md`, après une ligne vide, exactement ce texte. Les lignes de `Red Flags` marquées « copie » se recopient mot pour mot de la table `Red Flags` de `skills/using-batches/SKILL.md`, où chacune se retrouve par sa première cellule.

```markdown
## Execution Rules

A story's `Global Constraints` carries the execution rules that hold for that story. Each has a name:

| Name | Holds for | Written under |
|---|---|---|
| `spec freeze` | every story | `Authority and Conflict Rules` |
| `spec authority` | every story | `Authority and Conflict Rules` |
| `concision` | every story | `Concision` |
| `corrective stop condition` | a story of a corrective batch | `Stop Conditions` |
| `code under a feature flag` | a story that writes code guarded by a flag, whichever batch declares the flag | `Code Under a Feature Flag` |
| `technical stop condition` | a technical story | `Stop Conditions` |
| `untenable constraint or ADR` | a story whose batch declares constraints, or whose branch starts from a `main` that carries an ADR | `Stop Conditions` |
| `held ADRs` | a story whose branch starts from a `main` that carries an ADR | `The Model` |
| `decision worth an ADR` | every story | `Decisions Worth an ADR` |

### Stop Conditions

These conditions stop the execution of a plan, on top of those the execution by subagents states.

For corrective batches only:

> If, while bringing code into conformance with a spec, you discover that it is the **spec** that is wrong and the code that is right, stop. The batch is no longer corrective and must be requalified.

For a technical story only:

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

For a story only if its batch declares constraints or `main` carries an ADR when its branch starts:

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.

A constraint the spec contradicts does not fall under this condition: the spec wins.

A ruling replaces none of them. A ruling is a decision an agent takes on its human partner's behalf, and none of these is an agent's to take: the corrective condition would correct a spec, the technical condition would keep a qualification the story has just lost, and the condition on a constraint or an ADR would break a decision another story of the batch relies on, or one your human partner took for all the code to come. Recording one and carrying on is exactly the failure these conditions exist to prevent.

### Code Under a Feature Flag

> Code guarded by a feature flag holds up when the flag is on for some users
> only, on for everyone, and off:
>
> - The two states work on the same data: what one produces, the other reads
>   and uses, with no error and no data loss.
> - With the flag off, the user finds the behaviour from before the batch.
> - The story's pull request tests the flag-on behaviour, the flag-off
>   behaviour, and their coexistence.
> - Lifting the flag comes down to deleting the branching and the behaviour
>   from before the batch, without writing anything new.

### Decisions Worth an ADR

When you take a technical decision that meets the conditions of an ADR (`The Model`), say so in your report: it is recorded as an `Open ruling:`, which asks your human partner whether they want it as an ADR. Write nothing in `docs/adr/`.

## Red Flags

| Thought | Reality |
|---------|---------|
```

Sous l'en-tête de la table, dans cet ordre, les lignes dont la première cellule est :

1. `"The spec is wrong here, I'll fix it and move on"` — copie ;
2. `"The batch is newer than the spec, so the batch wins"` — copie ;
3. `"Git will conflict if two stories touch the same section"` — copie ;
4. la ligne ci-dessous, écrite telle quelle :

   ```markdown
   | "The flag is just an `if`, the guarded code can do as it likes" | Guarded code holds up when the flag is on for some users, on for everyone, and off, under the rules of `Code Under a Feature Flag`. |
   ```

5. `"The flag is on for everyone, so it is lifted"` — copie ;
6. `"I'm already in the previous story's worktree, I'll start the next one here"` — copie ;
7. `"This sentence is safer in, even if it repeats the rule above"` — copie ;
8. ``"The human has the batch document, `D12` is enough"`` — copie ;
9. `"This decision is technical, no need to bring it to my human partner"` — copie.

Le paragraphe `A ruling replaces none of them.` et les trois conditions se recopient mot pour mot de `### Override 2` de `skills/using-batches/SKILL.md` : compare-les après écriture.

- [ ] **Step 7: Add the README row**

Dans `README.md`, table de `## Skills`, ajoute après la ligne de `supercharlouze:using-batches` :

```markdown
| `supercharlouze:following-the-rules` | Never directly — the rules that hold at every moment of the flow, which the other skills and a story's plan invoke |
```

- [ ] **Step 8: Run the suite**

Run: `bash tests/run-all.sh > /tmp/us2-t1.txt 2>&1; tail -1 /tmp/us2-t1.txt; grep -c PASS /tmp/us2-t1.txt; grep FAIL /tmp/us2-t1.txt`
Expected: `all tests passed`, au moins 1080 `[PASS]`, aucun `[FAIL]`. Une garde `absent_everywhere` qui échoue sur `following-the-rules` désigne une formule chassée que le texte déplacé portait : rapporte-la, ne la contourne pas.

Vérifie aussi : `grep -c $'\r' skills/following-the-rules/SKILL.md` rend `0`.

- [ ] **Step 9: Commit**

```bash
git add skills/following-the-rules tests/skills.txt tests/test-skill-frontmatter.sh tests/test-skill-content.sh README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: le socle following-the-rules porte ce qui vaut en permanence" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: using-batches renvoie au socle

**Files:**
- Modify: `skills/using-batches/SKILL.md`, `README.md`, `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`, `tests/test-declared-overrides.sh`, `tests/test-cross-references.sh`

**Interfaces:**
- Consumes: `skills/following-the-rules/SKILL.md` de la tâche 1, et ses titres.
- Produces: `using-batches` réduite à son introduction, sa table de routage, `What a Spec Says`, `What Is Kept, What Is Rerouted`, `Declared Overrides` et `Red Flags`.

- [ ] **Step 1: Record the baseline**

Run: `bash tests/run-all.sh > /tmp/us2-t2-before.txt 2>&1; grep -c PASS /tmp/us2-t2-before.txt`
Note le nombre : c'est le plancher de l'étape 6.

- [ ] **Step 2: Remove the moved sections from using-batches**

Dans `skills/using-batches/SKILL.md`, supprime en entier, titre compris, les sections `## The Model`, `## The Git Model`, `## Authority and Conflict Rules`, `## Language`, `## Concision` (avec `### How to apply them`) et `## Conversation`. Chacune va de son titre à la ligne qui précède le titre `##` suivant.

Vérifie : `grep -n '^#' skills/using-batches/SKILL.md` rend `# Using Batches`, `## What a Spec Says`, `## What Is Kept, What Is Rerouted`, `## Declared Overrides`, les quatre `### Override`, `## Red Flags`.

- [ ] **Step 3: Remove the moved red flags**

Dans la table `## Red Flags` de `skills/using-batches/SKILL.md`, supprime les lignes dont la première cellule est :

- `"The spec is wrong here, I'll fix it and move on"`
- `"The batch is newer than the spec, so the batch wins"`
- `"Git will conflict if two stories touch the same section"`
- ``"The flag is just an `if`, the guarded code can do as it likes"``
- `"The flag is on for everyone, so it is lifted"`
- `"I'm already in the previous story's worktree, I'll start the next one here"`
- `"This sentence is safer in, even if it repeats the rule above"`
- ``"The human has the batch document, `D12` is enough"``
- `"This decision is technical, no need to bring it to my human partner"`

- [ ] **Step 4: Point using-batches at the foundation**

Dans `skills/using-batches/SKILL.md` :

1. Après le paragraphe `**Announce at start:** "I'm using the using-batches skill to route this work."`, ajoute ce paragraphe, entre deux lignes vides :

   ```markdown
   **Start by invoking `supercharlouze:following-the-rules`, unless this session already has.** It carries the model, the git model and the authority rules everything below relies on.
   ```

2. Dans `## What a Spec Says`, remplace `` under the conditions `The Model` states `` par `` under the conditions `supercharlouze:following-the-rules` states ``.

3. Dans `## What Is Kept, What Is Rerouted`, remplace les deux occurrences de `` that meets the conditions of an ADR (`The Model`) `` par `` that meets the conditions of an ADR `supercharlouze:following-the-rules` states ``.

4. Dans `### Override 2 — the stop conditions the flow adds`, remplace tout ce qui va de `` `superpowers:subagent-driven-development` states *"Four things stop you, and only these"*. `` jusqu'à la fin du paragraphe `A ruling replaces none of them. … exactly the failure these conditions exist to prevent.` par ce seul paragraphe :

   ```markdown
   `superpowers:subagent-driven-development` states *"Four things stop you, and only these"*. This plugin adds the stop conditions `supercharlouze:following-the-rules` writes in full: one for corrective batches only, one for a technical story only, and one for a story only if its batch declares constraints or `main` carries an ADR when its branch starts.
   ```

   Le paragraphe `Justification: the four native conditions assume…` et ceux qui le suivent restent.

5. Cherche ce qui renvoie encore à une section partie : `grep -n -E '\(`(The Model|The Git Model|Authority and Conflict Rules|Language|Concision|Conversation)`\)|`(The Model|The Git Model|Authority and Conflict Rules|Concision|Conversation)` (above|below)' skills/using-batches/SKILL.md`. Chaque occurrence devient un renvoi de la forme `` `<Section>` in `supercharlouze:following-the-rules` ``. Rapporte chacune.

- [ ] **Step 5: Make every guard follow its text**

Run: `bash tests/run-all.sh 2>&1 | grep FAIL`

Pour chaque `[FAIL]` :

- Une garde `require using-batches …` dont le needle se lit maintenant dans le socle devient `require following-the-rules …`, needle inchangé.
- Une garde `shared … using-batches <autres>` dont le needle se lit maintenant dans le socle remplace `using-batches` par `following-the-rules` dans sa liste.
- Un needle qui citait `` `superpowers:subagent-driven-development` keeps a ledger ``, `` `superpowers:writing-plans` imposes ``, `` one of the forms `supercharlouze:writing-a-user-story` fixes `` ou le paragraphe `Guarded code has rules of its own` suit la retouche de la tâche 1 : il prend le texte que le socle porte. La garde du paragraphe `Guarded code has rules of its own` et celle de la ligne de `Red Flags` sur le flag qui n'est qu'un `if` sont remplacées par cette garde, qui les rend sans objet :

  ```bash
  # The rules for code under a flag are written in full in the foundation, and
  # no other skill restates them in part: a partial gloss drifts from its text
  # with nothing to signal it.
  absent_everywhere "no skill glosses the rules for code under a flag" \
      "both states working on the same data|both states work on the same data|a lifting that only removes|lifting only removes"
  ```

  Si cette garde échoue sur une autre skill que `using-batches`, rapporte la phrase, ne la retouche pas.

- Dans `tests/test-declared-overrides.sh` : le needle `This plugin adds the conditions below. For corrective batches only:` devient `` This plugin adds the stop conditions \`supercharlouze:following-the-rules\` writes in full ``. Le contrôle `using-batches introduces the stop condition on a constraint or an ADR` et la boucle `The git model lives here` lisent `skills/following-the-rules/SKILL.md` : ajoute `FOUNDATION_FLAT="$(tr '\n' ' ' < "$REPO_ROOT/skills/following-the-rules/SKILL.md")"`, lis-y ces needles, et écris `following-the-rules` dans leurs libellés et leurs commentaires.
- Dans `tests/test-cross-references.sh`, une garde qui lit `$UB` et dont le needle est parti au socle lit le socle de la même façon.
- Chaque garde `absent` dont la liste nomme `using-batches` nomme aussi `following-the-rules`.
- Le commentaire d'une garde retouchée nomme la skill qui porte désormais le texte.

Aucune garde ne disparaît, hors les deux que la garde ci-dessus remplace. Une garde qui échoue et dont le needle n'est ni dans `using-batches` ni dans le socle désigne un texte perdu : restaure-le dans le socle depuis `git show HEAD:skills/using-batches/SKILL.md`, et rapporte-le.

- [ ] **Step 6: Update the README row and run the suite**

Dans `README.md`, la ligne de `supercharlouze:using-batches` devient :

```markdown
| `supercharlouze:using-batches` | Entry point — routing, what a spec says, declared overrides |
```

Run: `bash tests/run-all.sh > /tmp/us2-t2.txt 2>&1; tail -1 /tmp/us2-t2.txt; grep -c PASS /tmp/us2-t2.txt; grep FAIL /tmp/us2-t2.txt`
Expected: `all tests passed`, un nombre de `[PASS]` au moins égal au plancher de l'étape 1 moins un.

Run: `grep -n -c 'supercharlouze:\|superpowers:' skills/following-the-rules/SKILL.md`
Expected: `0`.

- [ ] **Step 7: Commit**

```bash
git add skills/using-batches README.md tests
bash ~/.config/github-app/as-agent.sh git commit -m "feat: using-batches renvoie au socle pour ce qui vaut en permanence" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 3: writing-a-user-story recopie les textes du socle

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md`, `tests/test-skill-contracts.sh`, `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: les sections `Stop Conditions`, `Code Under a Feature Flag`, `The Model` et `Decisions Worth an ADR` de `skills/following-the-rules/SKILL.md`.
- Produces: `writing-a-user-story` garde chaque bloc que `Global Constraints` recopie, et dit que le socle l'énonce.

- [ ] **Step 1: Write the failing tests**

Dans `tests/test-skill-contracts.sh`, juste avant sa dernière ligne `exit $((FAILURES > 0))`, ajoute :

```bash
# The rules for code under a flag are written in full in the foundation, and
# `writing-a-user-story` has them copied into a story's Global Constraints. A
# copy that adds or drops a rule is no longer what the foundation states. One
# assertion over both ends.
shared "the rules for code under a flag are copied exactly as stated" \
    "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off: - The two states work on the same data: what one produces, the other reads and uses, with no error and no data loss. - With the flag off, the user finds the behaviour from before the batch. - The story's pull request tests the flag-on behaviour, the flag-off behaviour, and their coexistence. - Lifting the flag comes down to deleting the branching and the behaviour from before the batch, without writing anything new." \
    following-the-rules writing-a-user-story

# The story skill says where each text it has copied is stated.
require writing-a-user-story "copies the rules for code under a flag as the foundation states them" \
    "Copy the block below verbatim, exactly as \`supercharlouze:following-the-rules\` states it"
require writing-a-user-story "takes the form of the gating sentence from the foundation" \
    "in the form \`supercharlouze:following-the-rules\` fixes"
absent "the story skill no longer claims to be where the rules for code under a flag are written" \
    "the only place those rules are written out" \
    writing-a-user-story

# No copied text is said to be stated by using-batches any more.
absent "no copied text is attributed to using-batches" \
    "exactly as \`supercharlouze:using-batches\` states it|those \`supercharlouze:using-batches\` states" \
    writing-a-user-story
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `bash tests/test-skill-contracts.sh | grep FAIL`
Expected: les deux `require` et les deux `absent` ajoutés échouent ; le `shared` passe.

- [ ] **Step 3: Rewrite the attributions in writing-a-user-story**

Dans `skills/writing-a-user-story/SKILL.md` :

1. Dans `## Step 3 — Commit the Spec Change First`, remplace tout ce qui va de `If the batch declares a feature flag for this story's module, the transcribed spec` jusqu'à la phrase `The flag's name, its default and its lifting condition vary; the rest of each form is fixed.` comprise, bloc de code compris, par :

   ```markdown
   If the batch declares a feature flag for this story's module, the transcribed spec
   change states the flag and its default in a gating sentence, in the form
   `supercharlouze:following-the-rules` fixes.
   ```

2. Les trois occurrences de `` exactly as `supercharlouze:using-batches` states it `` deviennent `` exactly as `supercharlouze:following-the-rules` states it ``.

3. `` Its conditions are those `supercharlouze:using-batches` states: `` devient `` Its conditions are those `supercharlouze:following-the-rules` states: `` (la phrase est coupée sur deux lignes dans le fichier).

4. Dans le paragraphe `**In a story that writes code guarded by a feature flag, …**`, la phrase `Copy the block below verbatim:` devient `` Copy the block below verbatim, exactly as `supercharlouze:following-the-rules` states it: ``.

5. Le paragraphe qui suit le bloc des règles du code gardé, qui commence par `This block is the only place those rules are written out, and copying it is what`, devient :

   ```markdown
   Copying this block is what puts those rules in front of the implementer — a norm
   nobody reads while writing the code bites on nothing. They travel the way the
   freeze does, through the only channel SDD's subagents read.
   ```

6. Dans `## Language`, `` Every text this skill writes follows `Concision` in `supercharlouze:using-batches`. `` devient `` Every text this skill writes follows `Concision` in `supercharlouze:following-the-rules`. ``

- [ ] **Step 4: Make every guard follow its text**

Run: `bash tests/run-all.sh 2>&1 | grep FAIL`

- La garde `shared "the gating sentence is spelled in its fixed form"` perd `writing-a-user-story` de sa liste et devient `require following-the-rules "the gating sentence is spelled in its fixed form" "🔒 \`billing.recurring\`, off by default"` ; son commentaire dit que le socle fixe les formes et que la skill de story y renvoie.
- Toute autre garde qui échoue sur un texte que cette tâche a retiré de `writing-a-user-story` et que le socle porte nomme `following-the-rules` à la place de `writing-a-user-story`, needle inchangé.
- Toute garde dont le needle cite `` `Concision` in `supercharlouze:using-batches` `` pour `writing-a-user-story` prend le nouveau renvoi.

- [ ] **Step 5: Run the suite**

Run: `bash tests/run-all.sh > /tmp/us2-t3.txt 2>&1; tail -1 /tmp/us2-t3.txt; grep -c PASS /tmp/us2-t3.txt; grep FAIL /tmp/us2-t3.txt`
Expected: `all tests passed`, aucun `[FAIL]`.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-user-story tests
bash ~/.config/github-app/as-agent.sh git commit -m "feat: writing-a-user-story recopie les textes que le socle énonce" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 4: Toute skill d'entrée invoque le socle

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md`, `skills/writing-a-batch/SKILL.md`, `skills/writing-a-user-story/SKILL.md`, `skills/closing-a-batch/SKILL.md`, `skills/recording-a-decision/SKILL.md`, `tests/test-skill-contracts.sh`, et les fichiers de `tests/` dont une garde cite un renvoi retouché

**Interfaces:**
- Consumes: la phrase d'invocation que la tâche 2 a écrite dans `using-batches` : `` **Start by invoking `supercharlouze:following-the-rules`, unless this session already has.** ``
- Produces: la même phrase dans chaque skill déclarée `entry`.

- [ ] **Step 1: Write the failing test**

Dans `tests/test-skill-contracts.sh`, juste avant sa dernière ligne `exit $((FAILURES > 0))`, ajoute :

```bash
# What holds at every moment lives in the foundation, and an agent reads only
# the skill it invoked: every entry skill starts by invoking it. Walks the
# declared list, so an entry skill declared later is covered.
for s in $(declared_skills entry); do
    require "$s" "starts by invoking the foundation" \
        "**Start by invoking \`supercharlouze:following-the-rules\`, unless this session already has.**"
done

# A rule the foundation carries is pointed at there, never at using-batches.
absent_everywhere "no skill points at using-batches for a rule the foundation carries" \
    "\`Concision\` in \`supercharlouze:using-batches\`|\`The Model\` of \`supercharlouze:using-batches\`"
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test-skill-contracts.sh | grep FAIL`
Expected: `starts by invoking the foundation` échoue pour `adopting-a-module`, `writing-a-batch`, `writing-a-user-story` et `closing-a-batch`, passe pour `using-batches` ; la garde `absent_everywhere` échoue.

- [ ] **Step 3: Add the invocation to each entry skill**

Dans chacune de `skills/adopting-a-module/SKILL.md`, `skills/writing-a-batch/SKILL.md`, `skills/writing-a-user-story/SKILL.md` et `skills/closing-a-batch/SKILL.md`, ajoute ce paragraphe, entre deux lignes vides, juste après le paragraphe `**Announce at start:** …` (qui peut tenir sur deux lignes) :

```markdown
**Start by invoking `supercharlouze:following-the-rules`, unless this session already has.**
```

Une skill sans paragraphe `**Announce at start:**` le reçoit après le premier paragraphe qui suit son titre `#`.

- [ ] **Step 4: Point the other skills at the foundation**

1. Dans `skills/adopting-a-module/SKILL.md`, `skills/writing-a-batch/SKILL.md`, `skills/closing-a-batch/SKILL.md` et `skills/recording-a-decision/SKILL.md`, `` Every text this skill writes follows `Concision` in `supercharlouze:using-batches`. `` devient `` Every text this skill writes follows `Concision` in `supercharlouze:following-the-rules`. ``

2. Dans `skills/adopting-a-module/SKILL.md`, `` that meets the conditions of an ADR, which `The Model` of `supercharlouze:using-batches` states. `` (coupé sur deux lignes) devient `` that meets the conditions of an ADR, which `supercharlouze:following-the-rules` states. ``

3. Dans `skills/writing-a-batch/SKILL.md`, section `## Requalifying a Technical Story`, `` `supercharlouze:using-batches` states it and `supercharlouze:writing-a-user-story` copies it `` devient `` `supercharlouze:following-the-rules` states it and `supercharlouze:writing-a-user-story` copies it `` (coupé sur deux lignes).

4. Run: `grep -rn -B1 -A1 'supercharlouze:using-batches' skills/adopting-a-module skills/writing-a-batch skills/writing-a-user-story skills/closing-a-batch skills/recording-a-decision skills/rereading-a-spec skills/rereading-a-technical-design`. Un renvoi qui reste vise ce que `using-batches` porte encore : la règle de contenu d'une spec (`What a Spec Says`), le changement borné, un override. Tout autre renvoi, qui vise le modèle, le modèle git, l'autorité, la langue, la concision, la conversation ou une condition d'arrêt, nomme `supercharlouze:following-the-rules`. Rapporte chaque renvoi retouché et chaque renvoi laissé.

- [ ] **Step 5: Make every guard follow its text, then run the suite**

Run: `bash tests/run-all.sh > /tmp/us2-t4.txt 2>&1; tail -1 /tmp/us2-t4.txt; grep -c PASS /tmp/us2-t4.txt; grep FAIL /tmp/us2-t4.txt`

Une garde qui échoue parce que son needle cite un renvoi retouché prend le nouveau renvoi. Relance jusqu'à `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills tests
bash ~/.config/github-app/as-agent.sh git commit -m "feat: toute skill d'entrée commence par invoquer le socle" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 5: CONTRIBUTING dit ce que la suite ne teste pas du socle

**Files:**
- Modify: `CONTRIBUTING.md`

**Interfaces:**
- Consumes: rien.
- Produces: rien qu'une autre tâche lise.

- [ ] **Step 1: Add the sentence**

Dans `CONTRIBUTING.md`, liste de ce que la suite ne teste pas, la dernière puce

```markdown
- whether an agent that invokes an internal skill comes back to the next step
  of the skill that invoked it.
```

devient

```markdown
- whether an agent that invokes an internal skill comes back to the next step
  of the skill that invoked it;
- whether a subagent that executes or reviews a task of a plan loads
  `supercharlouze:following-the-rules`.
```

Dans le paragraphe qui décrit `tests/skills.txt`, rien ne change.

- [ ] **Step 2: Run the suite**

Run: `bash tests/run-all.sh > /tmp/us2-t5.txt 2>&1; tail -1 /tmp/us2-t5.txt`
Expected: `all tests passed`.

- [ ] **Step 3: Commit**

```bash
git add CONTRIBUTING.md
bash ~/.config/github-app/as-agent.sh git commit -m "docs: CONTRIBUTING dit que la suite ne teste pas le chargement du socle" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

Technical design ruling: cette story d'extraction n'est pas technique, et déclare les sections que désigne l'entrée du gaps register qu'elle supprime — une story technique ne retire rien, et les `Constraints` du lot lui font résorber cette entrée — une story sans la condition d'arrêt d'une story technique, alors que la conception technique dit techniques les stories d'extraction.

Ruling: `using-batches` ne garde des conditions d'arrêt que leur déclaration comme override, sa justification et ce qui suit leur déclenchement ; leurs textes et le paragraphe « A ruling replaces none of them » vivent dans le socle — ce sont des règles d'exécution, et une extraction réécrit la skill qui portait une copie — un agent qui lit l'override sans avoir chargé le socle n'a plus le texte des conditions.

Ruling: neuf lignes de `Red Flags` de `using-batches` suivent au socle les règles qu'elles défendent, celles sur l'autorité de la spec, la concurrence, le flag, le point de départ d'une branche, la concision, la conversation et l'ADR — une excuse se réfute dans la skill qui porte la règle — une ligne rangée du mauvais côté, que personne ne lit au bon moment.

Ruling: les règles d'exécution portent les noms `spec freeze`, `spec authority`, `concision`, `corrective stop condition`, `code under a feature flag`, `technical stop condition`, `untenable constraint or ADR`, `held ADRs` et `decision worth an ADR`, dans une table qui renvoie chacune à la section du socle qui l'écrit — la conception technique demande un nom par règle sans le fixer, et une règle déjà écrite dans le socle ne s'y recopie pas — la story qui transcrit le bloc sur `Global Constraints` renomme ce qu'elle juge mal nommé.

Ruling: `writing-a-user-story` garde chaque bloc que `Global Constraints` recopie, règles du code gardé comprises, et dit que le socle l'énonce ; seule la forme de la mention de flag y devient un renvoi — les `Constraints` du lot gardent ces copies jusqu'à la story qui transcrit le bloc sur `Global Constraints`, et la mention de flag n'en fait pas partie — deux exemplaires de chaque bloc, que des contrats `shared` tiennent identiques.

Ruling: la résorption de l'entrée du gaps register retire les deux reformulations partielles des règles du code gardé que `using-batches` portait, et une garde les interdit dans toute skill ; la règle du registre des flags, que `writing-a-batch` et `closing-a-batch` énoncent, reste en l'état — elle n'est pas une règle du code gardé, et ces deux skills ont leur story — une formulation de plus à rapprocher du socle par ces stories.

Ruling: la garde « the guarded-code rules are written in one place » est supprimée avec les deux que le plan nommait — son needle tenait une phrase du paragraphe retiré, et la garde négative sur les gloses la remplace — une copie complète qui réapparaîtrait sous d'autres mots ne serait pas attrapée.

Ruling: la garde « the glossary points at that section » devient « the glossary states the content property », et une garde s'ajoute sur la ligne de `Red Flags` du flag qui n'est qu'un `if` — le renvoi que la première tenait nommait une section restée dans `using-batches`, que le socle ne peut pas nommer — plus rien ne tient un renvoi de la définition de la spec vers ce qu'une spec contient.

Ruling: les tâches 3, 4 et 5 du plan sont parties chez un seul exécutant et ont été relues en une fois, un commit par tâche — trois petites retouches de même nature sur des fichiers voisins — une relecture par tâche moins fine.

Ruling: la relecture finale de la branche a tourné sur le modèle et l'effort que l'utilisateur a fixés pour tous les sous-agents du lot, pas sur le modèle le plus capable que demande l'exécution par sous-agents — décision de l'utilisateur — une relecture finale moins profonde.

Ruling: la garde « the foundation names no skill » chasse aussi le nom nu de chaque skill déclarée et de sept skills de superpowers, au-delà des deux préfixes que la conception technique nomme — constat de la relecture finale : le socle ne nomme aucune skill, préfixée ou non — un mot courant comme « brainstorming » écrit dans le socle fait échouer la garde.

Ruling: un contrat `shared` tient identique, entre le socle et `writing-a-user-story`, l'obligation de signaler une décision qui réunit les conditions d'un ADR — constat de la relecture finale : les deux textes l'énonçaient sans garde — aucun.

Ruling: `CONTRIBUTING.md` dit dès cette story que la suite ne teste pas qu'un sous-agent charge le socle, alors que rien ne le lui demande avant la story qui transcrit le bloc sur `Global Constraints` — la conception technique place cette phrase ici — une phrase en avance sur le comportement jusqu'à cette story.

Ruling: deux constats mineurs de la relecture finale restent en l'état : aucune garde ne tient la colonne « Holds for » de la table des règles d'exécution, et la ligne de `Red Flags` sur le flag qui n'est qu'un `if` ne dit plus que ces règles vont dans `Global Constraints` — la story qui écrit le gabarit de `Global Constraints` tient cette colonne, et la table du socle dit déjà où vont ces règles — une colonne qui dérive de `writing-a-user-story` d'ici là.

## Observed drift

- `docs/specs/supercharlouze.gaps.md`, `Coverage` : la liste des fichiers audités nomme « les cinq `skills/*/SKILL.md` », alors que le module en porte neuf.
