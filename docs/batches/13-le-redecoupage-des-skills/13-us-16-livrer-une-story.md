# 13-us-16 — Livrer une story

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Renommer la skill `writing-a-user-story` en `delivering-a-story`, lui donner en ref l'attribution de `us-N` et lui faire porter en entier les overrides que `using-batches` ne fait plus que déclarer, sans changer le comportement que la branche d'en dessous porte.

**Architecture:** Le renommage est un commit à lui, avec la garde qui interdit l'ancien nom dans les skills, les commandes et le `README`. L'attribution de `us-N` devient `skills/delivering-a-story/references/allocating-us-n.md`, que l'étape 2 de la skill cite. `using-batches` garde en entier l'override des étapes 6 à 9 de `superpowers:brainstorming` et, pour chacun des trois autres, sa déclaration et la skill qui l'écrit en entier : `delivering-a-story`, qui renvoie au socle pour le texte des conditions d'arrêt.

**Tech Stack:** Markdown pour les skills, Bash pour les gardes de `tests/`.

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

### Freeze of the spec file

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

### Authority rule

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

### Stop condition of a technical story

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

### Stop condition on a constraint or an ADR

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

### ADRs

> The code this story writes holds these ADRs.

- `docs/adr/une-skill-par-moment-d-invocation.md`

### Decisions worth an ADR

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

### Rules of this repository

- Une skill est entièrement en anglais, et ne cite aucune section de `docs/specs/supercharlouze.md`.
- Une section qu'une skill nomme entre parenthèses est l'une des siennes.
- Les documents sous `docs/` qui citent l'ancien nom ne sont pas réécrits.
- Un `SKILL.md` garde des fins de ligne LF.
- Toute commande `git` qui écrit un commit ou parle au remote passe par `bash ~/.config/github-app/as-agent.sh git …`.
- Un commit se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et par aucune autre ligne d'attribution.
- Une correction d'un commit de cette branche est un `fixup!` de ce commit.
- L'outil Bash de ce poste mange les barres obliques inverses dans les heredocs et dans les `sed` en ligne : un fichier qui en contient s'écrit avec l'outil d'écriture ou d'édition de fichiers.
- La skill `supercharlouze:following-the-rules` n'existe pas dans la version installée du plugin : ne tente pas de l'invoquer, ce plan porte les règles qui valent ici.
- La suite se lance par `bash tests/run-all.sh`, dure environ trois minutes et demande un délai de cinq minutes.

## Review Focus

- Un nom de skill en dur dans un motif `case` d'une garde négative : resté à l'ancien nom, il passe à vide. Aucun fichier de `tests/` ne garde l'ancien nom hors de la garde qui le chasse (tâche 1, étape 5).
- Un fichier hors de `skills/`, `commands/` et `README.md` qui cite l'ancien nom : `CONTRIBUTING.md`, `scripts/`, `.claude-plugin/`. La tâche 1 les cherche (étape 5).
- Le titre et la phrase d'annonce de la skill, qui disent l'ancien nom en toutes lettres et que le remplacement du nom ne voit pas (tâche 1, étape 4).
- Une ref lue sans front matter : `allocating-us-n.md` n'en porte pas, et la garde du fetch lit le fichier entier (tâche 2).
- Une phrase gardée coupée autrement par un retour à la ligne : les gardes lisent le texte aplati, et la suite entière tourne à la fin de chaque tâche.

---

### Task 1: Renommer `writing-a-user-story` en `delivering-a-story`

**Files:**
- Rename: `skills/writing-a-user-story/` → `skills/delivering-a-story/`
- Modify: `skills/delivering-a-story/SKILL.md` (front matter, titre, annonce)
- Modify: tout fichier de `skills/`, `commands/`, `tests/` et `README.md` qui cite `writing-a-user-story`
- Test: `tests/test-cross-references.sh`

**Interfaces:**
- Produces: la skill `delivering-a-story`, déclarée `entry` dans `tests/skills.txt`, que les tâches 2 et 3 modifient.

- [ ] **Step 1: Écrire la garde qui échoue**

Dans `tests/test-cross-references.sh`, juste avant la dernière ligne `exit $((FAILURES > 0))`, ajouter :

```bash
# 10. `writing-a-user-story` was renamed `delivering-a-story`. The former name
#     survives in no skill, in no command and not in the README.
FORMER_STORY="$(grep -rn 'writing-a-user-story' "$REPO_ROOT/skills" "$REPO_ROOT/commands" "$REPO_ROOT/README.md" 2>/dev/null | wc -l | tr -d ' ' || true)"
if [ "$FORMER_STORY" = "0" ]; then
    pass "no skill, no command and not the README names writing-a-user-story"
else
    fail "no skill, no command and not the README names writing-a-user-story ($FORMER_STORY found)"
fi

```

- [ ] **Step 2: Vérifier qu'elle échoue**

Run: `bash tests/test-cross-references.sh | grep "names writing-a-user-story"`
Expected: `[FAIL] no skill, no command and not the README names writing-a-user-story (N found)` avec N supérieur à 0.

- [ ] **Step 3: Renommer le répertoire et remplacer le nom**

```bash
git mv skills/writing-a-user-story skills/delivering-a-story
grep -rl 'writing-a-user-story' skills commands tests README.md | xargs sed -i 's/writing-a-user-story/delivering-a-story/g'
```

Le `sed` réécrit aussi la garde de l'étape 1. Avec l'outil d'édition, remettre `writing-a-user-story` aux quatre endroits de ce bloc de `tests/test-cross-references.sh` où il désigne l'ancien nom : la première occurrence du commentaire, le motif du `grep`, et les deux libellés `pass` et `fail`. Le bloc doit se lire exactement comme à l'étape 1.

- [ ] **Step 4: Mettre à jour le titre et l'annonce**

Dans `skills/delivering-a-story/SKILL.md` :

- la ligne `# Writing a User Story` devient `# Delivering a Story` ;
- les deux lignes

```
**Announce at start:** "I'm using the writing-a-user-story skill to write this
story."
```

deviennent, après le `sed` qui a déjà changé le nom,

```
**Announce at start:** "I'm using the delivering-a-story skill to deliver this
story."
```

La ligne `description:` du front matter ne change pas.

- [ ] **Step 5: Chercher ce que le remplacement n'a pas vu**

Run: `grep -rn 'writing-a-user-story' . --exclude-dir=.git --exclude-dir=docs`
Expected: les seules lignes sont celles de la garde 10 de `tests/test-cross-references.sh`.

Run: `grep -rn 'Writing a User Story' skills commands tests README.md CONTRIBUTING.md`
Expected: aucune ligne.

Si un fichier hors de `docs/` cite encore l'ancien nom, le mettre à jour.

- [ ] **Step 6: Lancer la suite entière**

Run: `bash tests/run-all.sh` (délai de cinq minutes)
Expected: aucune ligne `[FAIL]`, et la garde `no skill, no command and not the README names writing-a-user-story` passe.

- [ ] **Step 7: Commit**

```bash
git add -A skills commands tests README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: writing-a-user-story devient delivering-a-story

Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: Faire de l'attribution de `us-N` une ref

**Files:**
- Create: `skills/delivering-a-story/references/allocating-us-n.md`
- Modify: `skills/delivering-a-story/SKILL.md` (section `Step 2 — Allocate us-N and Create the Branch`)
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la skill `delivering-a-story` de la tâche 1.
- Produces: la ref `skills/delivering-a-story/references/allocating-us-n.md`.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-contracts.sh`, remplacer le bloc

```bash
case "$(body_flat "$REPO_ROOT/skills/delivering-a-story/SKILL.md")" in
    *"git fetch origin git ls-tree --name-only origin/main docs/batches/NN-<slug>/"*)
        pass "delivering-a-story: allocation fetches before it reads the remote" ;;
    *)  fail "delivering-a-story: allocation fetches before it reads the remote" ;;
esac
```

par

```bash
# A story keeps its allocation in a reference too, read at that step.
case "$(body_flat "$REPO_ROOT/skills/delivering-a-story/references/allocating-us-n.md" 2>/dev/null || true)" in
    *"git fetch origin git ls-tree --name-only origin/main docs/batches/NN-<slug>/"*)
        pass "delivering-a-story: allocation fetches before it reads the remote" ;;
    *)  fail "delivering-a-story: allocation fetches before it reads the remote" ;;
esac
case "$(body_flat "$REPO_ROOT/skills/delivering-a-story/SKILL.md")" in
    *"git ls-tree"*|*"smallest integer"*)
        fail "delivering-a-story: the allocation is written in its reference alone" ;;
    *)  pass "delivering-a-story: the allocation is written in its reference alone" ;;
esac
require delivering-a-story "the story allocates us-N from its reference" \
    "Allocate \`us-N\` as \`skills/delivering-a-story/references/allocating-us-n.md\` says"
```

- [ ] **Step 2: Vérifier qu'elles échouent**

Run: `bash tests/test-skill-contracts.sh | grep -E "delivering-a-story: (allocation fetches|the allocation is written|the story allocates)"`
Expected: trois lignes `[FAIL]`.

- [ ] **Step 3: Créer la ref**

Créer `skills/delivering-a-story/references/allocating-us-n.md` avec exactement ce contenu :

````markdown
# Allocating us-N

`us-N` is the smallest integer **not used in the batch directory on `main`**,
**not claimed by an open pull request**, *and* **not claimed by a pushed
`story/*` branch that carries no pull request yet**:

```bash
git fetch origin
git ls-tree --name-only origin/main docs/batches/NN-<slug>/
gh pr list --state open --limit 100 --json number,headRefName
git ls-remote --heads origin 'story/*'
```

Each is necessary. The remote ones are the sources the concurrency scan reads,
one idea applied twice and not a coincidence. The listing of `main` is the one
that scan never reads, because concurrency is a question about work
in flight and allocation is also a question about work already landed. An
artifact only reaches `main` when its pull request merges, so that listing
knows nothing about what is in flight; and a story's pull request opens only
at the very end of Step 5, so from its first commit until then a branch holds
its number without ever appearing in
`gh pr list`. The branch name carries the number — `story/NN-us-N-<slug>` — so
the remote listing answers on its own, with nothing to fetch and no file to
read. Going by that listing alone gives the same number to two stories written
while a third is in review; adding only the pull requests still gives it to two
stories written while a third is being implemented, and that window is the
longer of the two.
````

- [ ] **Step 4: Réduire l'étape 2 de la skill à son renvoi**

Dans `skills/delivering-a-story/SKILL.md`, sous le titre `## Step 2 — Allocate us-N and Create the Branch`, supprimer tout ce qui va de la ligne ``` `us-N` is the smallest integer **not used in the batch directory on `main`**, ``` jusqu'à la ligne `longer of the two.` comprise, bloc de commandes compris, et écrire à la place :

```markdown
Allocate `us-N` as `skills/delivering-a-story/references/allocating-us-n.md`
says: it fetches, then reads `main`, the open pull requests and the pushed
`story/*` branches.
```

Le paragraphe suivant, `Branch name, enforced by this plugin and not by superpowers:`, reste tel quel, séparé du nouveau par une ligne vide.

- [ ] **Step 5: Lancer la suite entière**

Run: `bash tests/run-all.sh` (délai de cinq minutes)
Expected: aucune ligne `[FAIL]`.

- [ ] **Step 6: Commit**

```bash
git add skills/delivering-a-story tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "refactor: l'attribution de us-N devient une ref de delivering-a-story

Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 3: Écrire en entier dans `delivering-a-story` les overrides que `using-batches` déclare

**Files:**
- Modify: `skills/delivering-a-story/SKILL.md` (section `Step 5 — Execute`)
- Modify: `skills/using-batches/SKILL.md` (sections `Declared Overrides` et `Red Flags`)
- Test: `tests/test-declared-overrides.sh`, `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la skill `delivering-a-story` de la tâche 1.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-declared-overrides.sh`, juste après le bloc

```bash
check_verb "finishing is constrained to the pull request option" \
    "this plugin constrains the choice to" \
    "constrains superpowers:finishing-a-development-branch to the pull request option"
```

ajouter :

```bash

# using-batches writes in full the override on steps 6 to 9 alone. For each of
# the others it declares the override and names the skill that writes it in
# full: delivering-a-story.
STORY_FLAT="$(tr '\n' ' ' < "$REPO_ROOT/skills/delivering-a-story/SKILL.md" | tr -s ' ')"
POINTERS="$(grep -o "\`supercharlouze:delivering-a-story\` writes this override in full\." "$SKILL" | wc -l | tr -d ' ' || true)"
if [ "$POINTERS" = "3" ]; then
    pass "using-batches says where each of the three other overrides is written in full"
else
    fail "using-batches says where each of the three other overrides is written in full ($POINTERS found)"
fi
for needle in \
    "this plugin requires \`superpowers:subagent-driven-development\`" \
    "repatriating the rulings depends on SDD's ledger" \
    "those arbitrations are the only record of where the spec was ambiguous" \
    "the choice is constrained to **\"Push and create a Pull Request\"**" \
    "**\"Merge back locally\" is actively destructive.**" \
    "**\"Keep the branch as-is\" is not destructive**" \
    "**Deliberately not an override:** SDD's terminal state." \
    "know nothing of the stories beside it"; do
    if has "$needle" "$STORY_FLAT"; then
        pass "delivering-a-story writes the override in full: $needle"
    else
        fail "delivering-a-story writes the override in full: $needle"
    fi
done
for needle in \
    "Justification, stated exactly" \
    "actively destructive" \
    "keeps none" \
    "know nothing of the stories beside it" \
    "SDD's terminal state"; do
    if has "$needle" "$SKILL_FLAT"; then
        fail "using-batches no longer writes in full: $needle"
    else
        pass "using-batches no longer writes in full: $needle"
    fi
done
```

Dans `tests/test-skill-content.sh`, dans la garde

```bash
require using-batches "the justification covers the ADR" \
    "and an ADR is a decision your human partner took, so only they judge it untenable."
```

remplacer `using-batches` par `delivering-a-story`.

Dans `tests/test-skill-contracts.sh`, juste avant la dernière ligne `exit $((FAILURES > 0))`, ajouter :

```bash
# The red flags of the story path live in delivering-a-story: using-batches
# routes, and keeps none of them.
absent "using-batches keeps no red flag of the story path" \
    "local merge is quicker|transcribe the whole spec delta now" \
    using-batches

```

- [ ] **Step 2: Vérifier qu'elles échouent**

Run: `bash tests/test-declared-overrides.sh | grep FAIL; bash tests/test-skill-content.sh | grep "the justification covers the ADR"; bash tests/test-skill-contracts.sh | grep "red flag of the story path"`
Expected: en `[FAIL]`, la garde des trois renvois, les gardes `delivering-a-story writes the override in full` sur `those arbitrations…`, `**Deliberately not an override:**…` et `know nothing of the stories beside it`, les cinq gardes `using-batches no longer writes in full`, `delivering-a-story: the justification covers the ADR` et `using-batches keeps no red flag of the story path`.

- [ ] **Step 3: Compléter `Step 5 — Execute` de `delivering-a-story`**

Dans `skills/delivering-a-story/SKILL.md`, trois modifications.

Première : dans le paragraphe `**Override 3 — the execution mode is imposed.**`, la fin

```
depends on SDD's ledger; `superpowers:executing-plans` keeps none, and the
trace of every arbitration made on your human partner's behalf would be lost.
```

devient

```
depends on SDD's ledger; `superpowers:executing-plans` keeps none, and the
trace of every arbitration made on your human partner's behalf would be lost —
and those arbitrations are the only record of where the spec was ambiguous.
```

Deuxième : après le paragraphe

```
So this override removes one choice that cannot succeed, and one that leads
nowhere.
```

ajouter, séparé par une ligne vide :

```
**Deliberately not an override:** SDD's terminal state. Nothing is interposed
between SDD and `superpowers:finishing-a-development-branch` — what is
constrained is what the latter offers, which is Override 4 and nothing else.
```

Troisième : remplacer tout ce qui va de la ligne `**Override 2 — the stop conditions the flow adds.** SDD states that four things` jusqu'à la ligne `contradicts is not this case, since the spec wins.` comprise par :

```
**Override 2 — the stop conditions the flow adds.** SDD states that four things
stop you and only these. This plugin adds its own. **When one of them fires,
stop: `supercharlouze:handling-a-stopped-story` conducts what follows.**

In a corrective batch: if, while bringing code into conformity with the spec, you
discover that the **spec** is wrong and the code is right, stop. The batch is no
longer corrective and must be requalified.

In a technical story, whatever its batch: if, while conducting it, you discover
that it changes something observable at the module's boundary, stop. The story is
no longer technical.

In a story whose batch declares constraints or whose `docs/adr/` carries an ADR:
if, while conducting it, you discover that a constraint of its batch or an ADR
cannot be held, stop and put it to your human partner. A constraint the spec
contradicts is not this case, since the spec wins.

Justification: the four native conditions assume a valid authority exists,
assume the story is the story it says it is, and know nothing of the stories
beside it. A corrective batch puts the authority in question; a technical story
puts its own qualification in question — "purely technical" is otherwise the
door through which behaviour enters with no gate behind it, since a story that
transcribes no block passes no opening review; a constraint is what the other
stories of its batch rely on, so a story that cannot hold one cannot settle it
alone; and an ADR is a decision your human partner took, so only they judge it
untenable.
```

Le paragraphe `It is named as an override for the same reason as the other three: …` qui suit reste tel quel.

- [ ] **Step 4: Réduire les overrides 2, 3 et 4 de `using-batches` à leur déclaration**

Dans `skills/using-batches/SKILL.md`, quatre modifications.

Première : dans le premier paragraphe de `## Declared Overrides`, la fin de phrase

```
so each one is **named as an override**, here and in the CLAUDE.md block, with its justification.
```

devient

```
so each one is **named as an override**, here and in the CLAUDE.md block, and written in full, with its justification, here or in the skill this section names.
```

Deuxième : remplacer tout ce qui va du titre `### Override 2 — the stop conditions the flow adds` jusqu'à la ligne qui précède `## Red Flags` par :

```
### Override 2 — the stop conditions the flow adds

`superpowers:subagent-driven-development` states *"Four things stop you, and only these"*. This plugin adds the stop conditions `supercharlouze:following-the-rules` writes in full: one for corrective batches only, one for a technical story only, and one for a story only if its batch declares constraints or `main` carries an ADR when its branch starts. `supercharlouze:delivering-a-story` writes this override in full.

When one of them fires, you stop, and `supercharlouze:handling-a-stopped-story` conducts what follows.

### Override 3 — imposed execution mode

`superpowers:writing-plans` ends by offering the human a choice between subagent-driven-development and executing-plans. This plugin imposes SDD as the execution mode, and does not present the choice. `supercharlouze:delivering-a-story` writes this override in full.

### Override 4 — finishing-a-development-branch is constrained to the pull request

`superpowers:finishing-a-development-branch` presents three options — merge locally, open a pull request, keep the branch — and waits for a human choice. On the story path this plugin constrains the choice to **"Push and create a Pull Request"**. `supercharlouze:delivering-a-story` writes this override in full.

**Deliberately not an override:** the reuse of an existing worktree by `superpowers:using-git-worktrees`, which is the documented behaviour of its Step 0.

```

Troisième : dans le tableau de `## Red Flags`, supprimer la ligne qui commence par `| "I'll transcribe the whole spec delta now, it's more efficient" |`.

Quatrième : dans le même tableau, supprimer la ligne qui commence par `| "A local merge is quicker than opening a pull request" |`.

- [ ] **Step 5: Lancer la suite entière**

Run: `bash tests/run-all.sh` (délai de cinq minutes)
Expected: aucune ligne `[FAIL]`.

- [ ] **Step 6: Commit**

```bash
git add skills/delivering-a-story/SKILL.md skills/using-batches/SKILL.md tests
bash ~/.config/github-app/as-agent.sh git commit -m "refactor: delivering-a-story écrit en entier les overrides que using-batches déclare

Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: le commit du renommage est typé `feat:` — le nom d'une skill d'entrée est ce qu'un utilisateur du plugin voit changer, et une story qui touche `skills/` sans `feat:` ne publie rien — une ligne de changelog à retyper avant la fusion si un renommage doit rester muet, comme celui de `opening-a-batch`.
- Ruling: la description de la skill et sa ligne du `README` gardent « writing the next story of an open batch » — un renommage reprend le comportement que la branche d'en dessous porte — la skill s'appelle `delivering-a-story` et se décrit encore par l'écriture.
- Ruling: le plan retirait deux phrases de l'override des conditions d'arrêt de `delivering-a-story` (« An agent may not correct a spec. » et « Only your human partner may rule what follows: … »), que la justification déplacée semblait redire ; une garde tient la seconde, et les deux sont restées — un déplacement reprend le texte que la branche d'en dessous porte — la tâche 3 du plan montre un texte que la skill livrée ne porte pas, et ces deux phrases côtoient la justification qui les paraphrase.
- Ruling: la phrase de `using-batches` sur l'option « Keep the branch as-is », « It is ruled out for that reason, not because it breaks anything. », n'a pas suivi l'override — `delivering-a-story` dit déjà « It is simply out of the flow » — une nuance de formulation perdue.
- Ruling: les red flags de `using-batches` sur le spec delta transcrit d'un coup et sur la fusion locale sont supprimés, pas déplacés — `delivering-a-story` portait déjà les deux — la formulation de `using-batches` est perdue.
- Ruling: les red flags de `using-batches` sur le champ `Feature flag` vide et sur le flag qui survit à son lot restent où ils sont — ils ne tiennent ni au renommage, ni à la ref, ni aux overrides, et aucune autre skill ne les porte — `using-batches` garde deux red flags qui ne tiennent pas au routage.
- Technical design ruling: l'override des conditions d'arrêt est écrit en entier dans `delivering-a-story`, justification comprise, alors que `Technical design` ne lui donne que ceux du mode d'exécution et de la sortie par pull request — `using-batches` ne garde qu'une ligne par override, le socle ne peut pas nommer la skill de superpowers dont la règle est étendue, et `delivering-a-story` déclarait déjà cet override à l'étape où il mord — la justification vit dans une skill que `Technical design` ne désigne pas pour elle.
- Technical design ruling: sous l'override des conditions d'arrêt, `using-batches` garde, après la ligne qui le déclare, la phrase qui mène à `handling-a-stopped-story` — c'est du routage, et une garde la tient — l'override y tient en deux lignes au lieu d'une.
- Technical design ruling: `using-batches` garde la phrase qui dit que la réutilisation d'un espace de travail par `superpowers:using-git-worktrees` n'est pas un override ; l'état terminal de SDD, qui partageait son paragraphe, a suivi l'override de la sortie par pull request dans `delivering-a-story` — la phrase tient au compte des overrides, que `using-batches` déclare, et à aucune étape d'une story — `using-batches` porte une phrase que `Technical design` n'énumère pas.

## Observed drift
