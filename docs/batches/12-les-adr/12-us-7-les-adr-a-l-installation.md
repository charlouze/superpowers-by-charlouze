# Les ADR à l'installation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** L'installation sur un projet soumet à l'humain les ADR que `docs/adr/` porte déjà, lui dit que le code à venir devra tenir ceux qu'il garde, et supprime ceux qu'il abandonne.

**Architecture:** `scripts/init.sh` liste, sous le titre `existing ADRs:`, les fichiers `.md` placés directement dans `docs/adr/`, sur le modèle de la liste des modules adoptés, et écrit `(none)` quand le répertoire est absent ou n'en porte aucun ; il ne crée pas `docs/adr/`. `commands/init.md` soumet chaque ADR listé à l'humain avant de commiter, et supprime ceux qu'il abandonne dans un commit à part qui dit pourquoi. `tests/test-init.sh` et `tests/test-command.sh` gagnent les gardes que la conception du lot nomme.

**Tech Stack:** Bash pour le script et les gardes, Markdown pour la commande.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/12-les-adr/README.md
**Sections:** Installing on a project
**Blocks:** D21

## Global Constraints

Contraintes du lot, recopiées mot pour mot :

> `D1`, `D2` et `D3` sont transcrits par la même story, avant tout autre bloc sauf
> `D14` et `D20`.
>
> `D4` à `D12` sont transcrits par la même story.
>
> `D13`, `D15` et `D16` sont transcrits par la même story.
>
> `D17`, `D18` et `D19` sont transcrits par la même story, après `D15`.
>
> La story qui transcrit `D2` livre la skill `recording-a-decision`.
>
> Toutes les stories emploient tels quels le répertoire `docs/adr/` et la skill
> `recording-a-decision`.

Gel du fichier de spec :

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

Règle d'autorité :

> When the batch and the spec contradict each other, the spec wins — without
> exception and without deliberation. Implement what the spec says, record a
> `Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
> agent's.

Règles de concision :

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

Condition d'arrêt sur une contrainte ou un ADR qui ne peut pas être tenu :

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

Conditions d'un ADR :

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

Règles du dépôt, qui valent pour chaque tâche :

- Une commande, un script et un test sont entièrement en anglais.
- Chaque norme que la commande énonce a sa garde dans `tests/`, écrite avant le texte et vue rouge.
- Chaque phrase de la commande change ce qu'un agent fait. Pas de réfutation d'une version disparue, pas de cas particulier que la règle générale couvre déjà, pas de gras qui hiérarchise, pas de tiret à la place d'une virgule, pas de liste qui annonce combien d'éléments elle tient.
- Un ADR est un fichier `.md` placé directement dans `docs/adr/`, et aucune autre définition n'est employée.
- Le script reste portable : il tourne sous Git Bash sous Windows et sous bash sur la CI Linux.
- Cette story ne livre que ce qui réalise `D21`. Seuls `scripts/init.sh`, `commands/init.md`, `tests/test-init.sh` et `tests/test-command.sh` sont touchés. La ligne de la table de routage de `skills/using-batches/SKILL.md` sur l'ADR n'est pas touchée.
- Le texte de la commande donné dans une tâche est écrit tel quel. Un implémenteur qui le juge faux le dit dans son rapport, et ne le réécrit pas.
- Tout commit passe par `bash ~/.config/github-app/as-agent.sh git -C <worktree> commit …` et se termine par la seule ligne d'attribution `Co-Authored-By: Charlouze <me@charlouze.com>`. Jamais de `Co-Authored-By: Claude …`, de `Claude-Session:` ni de « Generated with Claude Code ».
- Pendant une tâche, seuls les fichiers de test qu'elle touche sont lancés (`bash tests/<fichier>.sh`). La suite complète tourne à la fin de la story. Aucun lancement n'est laissé en arrière-plan.

## Review Focus

- Un nom d'ADR qui porte une espace : la liste le rend entier, sur une seule ligne. Gardé en tâche 1 par une fixture.
- Un répertoire nommé `*.md` dans `docs/adr/` : ce n'est pas un ADR, il n'est pas listé. Gardé en tâche 1 par une fixture.
- Un fichier `.md` placé dans un sous-répertoire de `docs/adr/` : ce n'est pas un ADR, il n'est pas listé. Gardé en tâche 1 par une fixture.
- Un projet sans `docs/adr/` : l'installation ne le crée pas, puisque rien ne dit que le projet en veut. Gardé en tâche 1.
- L'agent qui supprimerait un ADR dans le commit de l'installation, ou sans en dire la raison : la commande fixe un commit à part, dont le message dit pourquoi. Gardé en tâche 2.

---

### Task 1: Le script liste les ADR que le projet porte déjà

**Files:**
- Modify: `scripts/init.sh` (section `# --- Report ---`, à la fin du fichier)
- Test: `tests/test-init.sh`

**Interfaces:**
- Consumes: rien.
- Produces: la sortie du script porte une ligne `existing ADRs:`, suivie soit de la ligne `  (none)`, soit d'une ligne `  - docs/adr/<file>.md` par ADR, triées. La tâche 2 nomme ce titre dans la commande.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-init.sh`, insérer avant la dernière ligne, `exit $((FAILURES > 0))` :

```bash
# --- Case 22: the report lists the ADRs docs/adr/ already carries ---
# An ADR is a .md file placed directly in docs/adr/: another file, a directory
# named *.md, or a .md file deeper down is not one.
adr_list() { awk '/^existing ADRs:/ { f = 1; next } f && /^  / { print; next } f { exit }' "$1"; }
P21="$TEST_ROOT/adrs"
mkdir -p "$P21/docs/adr/drafts" "$P21/docs/adr/folder.md"
printf '# A\n' > "$P21/docs/adr/a-decision.md"
printf '# B\n' > "$P21/docs/adr/b decision.md"
printf 'notes\n' > "$P21/docs/adr/notes.txt"
printf '# C\n' > "$P21/docs/adr/drafts/c-decision.md"
REPORT21="$TEST_ROOT/report21.txt"
bash "$INIT" "$P21" > "$REPORT21"
EXPECTED21="$(printf '  - docs/adr/a-decision.md\n  - docs/adr/b decision.md')"
if [ "$(adr_list "$REPORT21")" = "$EXPECTED21" ]; then
    pass "report: the ADRs listed are the .md files placed directly in docs/adr/"
else
    fail "report: the ADRs listed are the .md files placed directly in docs/adr/"
fi

# --- Case 23: a project without docs/adr/ has no ADR, and gets no docs/adr/ ---
# Case 14 ran the script on P1, which has no docs/adr/.
if [ "$(adr_list "$REPORT")" = "  (none)" ]; then
    pass "report: no docs/adr/ lists the ADRs as none"
else
    fail "report: no docs/adr/ lists the ADRs as none"
fi
if [ ! -e "$P1/docs/adr" ]; then
    pass "init does not create docs/adr/"
else
    fail "init does not create docs/adr/"
fi

# --- Case 24: an empty docs/adr/ has no ADR ---
P22="$TEST_ROOT/adr-empty"
mkdir -p "$P22/docs/adr"
REPORT22="$TEST_ROOT/report22.txt"
bash "$INIT" "$P22" > "$REPORT22"
if [ "$(adr_list "$REPORT22")" = "  (none)" ]; then
    pass "report: an empty docs/adr/ lists the ADRs as none"
else
    fail "report: an empty docs/adr/ lists the ADRs as none"
fi
```

- [ ] **Step 2: Voir les gardes rouges**

Run: `bash tests/test-init.sh | grep FAIL`
Expected: exactement ces trois lignes :

```
  [FAIL] report: the ADRs listed are the .md files placed directly in docs/adr/
  [FAIL] report: no docs/adr/ lists the ADRs as none
  [FAIL] report: an empty docs/adr/ lists the ADRs as none
```

La garde `init does not create docs/adr/` est déjà verte : elle tient ce que le script ne doit pas se mettre à faire.

- [ ] **Step 3: Le script**

Dans `scripts/init.sh`, ajouter à la fin du fichier, après la boucle des modules adoptés :

```bash

# An ADR is a .md file placed directly in docs/adr/. The directory is read only
# when it exists: installing never creates it.
ADRS=""
if [ -d "$PROJECT/docs/adr" ]; then
    ADRS="$(find "$PROJECT/docs/adr" -maxdepth 1 -type f -name '*.md' -print | sort)"
fi
echo "existing ADRs:"
if [ -z "$ADRS" ]; then
    echo "  (none)"
else
    printf '%s\n' "$ADRS" | while IFS= read -r adr; do
        echo "  - docs/adr/$(basename "$adr")"
    done
fi
```

- [ ] **Step 4: Voir les gardes vertes**

Run: `bash tests/test-init.sh | grep -c FAIL`
Expected: `0`.

- [ ] **Step 5: Commiter**

```bash
bash ~/.config/github-app/as-agent.sh git -C <worktree> add scripts/init.sh tests/test-init.sh
bash ~/.config/github-app/as-agent.sh git -C <worktree> commit -m "feat: l'installation fait trancher l'humain sur les ADR qu'un projet porte déjà" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: La commande soumet les ADR listés à l'humain

**Files:**
- Modify: `commands/init.md` (étapes numérotées)
- Test: `tests/test-command.sh`

**Interfaces:**
- Consumes: le titre `existing ADRs:` que `scripts/init.sh` écrit (tâche 1).
- Produces: rien qu'une autre tâche consomme.

- [ ] **Step 1: Écrire les gardes**

Dans `tests/test-command.sh`, remplacer :

```bash
BODY_FLAT="$(printf '%s\n' "$body" | tr '\n' ' ')"
```

par :

```bash
BODY_FLAT="$(printf '%s\n' "$body" | tr '\n' ' ' | tr -s ' ')"
```

Puis insérer avant la dernière ligne, `exit $((FAILURES > 0))` :

```bash
# The command puts to the human each ADR the script lists, under the heading
# the script prints, before committing; it tells them the code to come holds
# the ADRs they keep, and deletes the abandoned ones in a commit of its own
# that says why.
if has '`existing ADRs:`' "$BODY_FLAT" \
   && grep -qxF 'echo "existing ADRs:"' "$REPO_ROOT/scripts/init.sh"; then
    pass "command names the ADR heading the script prints"
else
    fail "command names the ADR heading the script prints"
fi

case "$BODY_FLAT" in
    *'Before committing, put each ADR the script lists under `existing ADRs:` to your human partner.'*"Commit what the script changed."*)
        pass "command puts the listed ADRs to the human before committing" ;;
    *)  fail "command puts the listed ADRs to the human before committing" ;;
esac

if has "Tell them that the code written from now on must hold every ADR they keep, and ask whether they keep it or abandon it, and why when they abandon it." "$BODY_FLAT"; then
    pass "command tells the human the code to come holds the ADRs they keep"
else
    fail "command tells the human the code to come holds the ADRs they keep"
fi

if has "An ADR they want rewritten is kept here, and a bounded change rewrites it." "$BODY_FLAT"; then
    pass "command leaves a rewrite to a bounded change"
else
    fail "command leaves a rewrite to a bounded change"
fi

if has "Then delete the ADRs your human partner abandoned, in a commit of its own whose message says why each one is abandoned." "$BODY_FLAT"; then
    pass "command deletes the abandoned ADRs in a commit of its own that says why"
else
    fail "command deletes the abandoned ADRs in a commit of its own that says why"
fi

if has "which modules are adopted, and which ADRs your human partner kept." "$BODY_FLAT"; then
    pass "command reports the ADRs kept"
else
    fail "command reports the ADRs kept"
fi
```

La garde sur le titre lit la ligne `echo "existing ADRs:"` de `scripts/init.sh` : elle échoue si la commande et le script cessent de nommer le même titre.

- [ ] **Step 2: Voir les gardes rouges**

Run: `bash tests/test-command.sh | grep FAIL`
Expected: exactement ces six lignes :

```
  [FAIL] command names the ADR heading the script prints
  [FAIL] command puts the listed ADRs to the human before committing
  [FAIL] command tells the human the code to come holds the ADRs they keep
  [FAIL] command leaves a rewrite to a bounded change
  [FAIL] command deletes the abandoned ADRs in a commit of its own that says why
  [FAIL] command reports the ADRs kept
```

- [ ] **Step 3: La commande**

Dans `commands/init.md`, remplacer les étapes 2 à 4 :

```markdown
2. Run `bash ${CLAUDE_PLUGIN_ROOT}/scripts/init.sh <target>`. It is idempotent:
   it creates `docs/specs/`, `docs/batches/` and `docs/archive/`, moves any
   `docs/superpowers/specs` and `docs/superpowers/plans` under `docs/archive/`,
   and installs or refreshes the CLAUDE.md block. Running it twice changes
   nothing the second time. If it refuses because the CLAUDE.md markers are
   unbalanced, stop and tell your human partner — do not repair the file
   yourself.
3. Commit, push, and open the pull request.
4. Report the script's output as a state of play: which modules are adopted.
```

par :

```markdown
2. Run `bash ${CLAUDE_PLUGIN_ROOT}/scripts/init.sh <target>`. It is idempotent:
   it creates `docs/specs/`, `docs/batches/` and `docs/archive/`, moves any
   `docs/superpowers/specs` and `docs/superpowers/plans` under `docs/archive/`,
   installs or refreshes the CLAUDE.md block, and lists the adopted modules and
   the ADRs `docs/adr/` already carries. Running it twice changes nothing the
   second time. If it refuses because the CLAUDE.md markers are unbalanced, stop
   and tell your human partner — do not repair the file yourself.
3. Before committing, put each ADR the script lists under `existing ADRs:` to
   your human partner. Tell them that the code written from now on must hold
   every ADR they keep, and ask whether they keep it or abandon it, and why when
   they abandon it. An ADR they want rewritten is kept here, and a bounded change
   rewrites it.
4. Commit what the script changed. Then delete the ADRs your human partner
   abandoned, in a commit of its own whose message says why each one is
   abandoned.
5. Push, and open the pull request.
6. Report the script's output as a state of play: which modules are adopted,
   and which ADRs your human partner kept.
```

- [ ] **Step 4: Voir les gardes vertes**

Run: `bash tests/test-command.sh | grep -c FAIL; bash tests/test-cross-references.sh | grep -c FAIL; bash tests/test-init.sh | grep -c FAIL`
Expected: `0` trois fois.

- [ ] **Step 5: Commiter**

Le commit est un `fixup!` du commit de la tâche 1 : la story ne livre qu'un seul `feat:`, et le conducteur fond ce commit dans celui de la tâche 1 avant d'ouvrir la pull request.

```bash
bash ~/.config/github-app/as-agent.sh git -C <worktree> add commands/init.md tests/test-command.sh
bash ~/.config/github-app/as-agent.sh git -C <worktree> commit -m "fixup! feat: l'installation fait trancher l'humain sur les ADR qu'un projet porte déjà" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: les tâches 1 et 2 sont confiées à un seul implémenteur, en un envoi, et relues ensemble — les deux transcrivent un code donné en entier, sur quatre fichiers sans recouvrement — si c'est faux, un défaut d'une tâche est relu avec l'autre.
- Technical design ruling: la commande garde dans la pull request d'installation l'ADR que l'humain veut réécrire, et cette pull request n'en réécrit aucun, ce que la conception ne dit pas — la spec ne fait que soumettre les ADR et supprimer ceux que l'humain abandonne, et sans cette phrase l'agent réécrit l'ADR dans la pull request d'installation — si c'est faux, la phrase et sa garde sont à retirer.
- Technical design ruling: le compte rendu final de la commande nomme les ADR que l'humain a gardés, à côté des modules adoptés, ce que la conception ne demande pas — l'humain qui a tranché ADR par ADR retrouve l'état qu'il laisse dans ce compte rendu — si c'est faux, une fin de phrase et sa garde sont à retirer.
- Ruling: le tiret de l'étape 2 de `commands/init.md`, que cette story réenveloppe, devient une virgule ; les trois autres tirets du fichier, hors du diff, restent — la règle « pas de tiret à la place d'une virgule » des règles du dépôt de ce plan vaut pour le texte que la story écrit — si c'est faux, trois tirets restent à remplacer.
- Ruling: le texte livré s'écarte du texte que ce plan donne, après la relecture de la branche, en ces points de `commands/init.md` : « Keep an ADR they want rewritten: this pull request rewrites none. » remplace la phrase qui envoyait la réécriture à un changement borné, l'étape 3 demande en une phrase à part, pour chaque ADR, si l'humain le garde ou l'abandonne, et l'étape 6 dit « Report the state of play » au lieu de la sortie du script ; le commentaire d'en-tête de `scripts/init.sh` nomme ses deux listes, et celui du bloc des ADR dit « listed » au lieu de « read » ; les gardes de `tests/test-command.sh` suivent — chaque point résorbe un constat de relecture, et le plan n'est pas réécrit après son exécution — si c'est faux, le plan se lit comme ce qui a été livré alors qu'il ne l'est plus sur ces points.
- Ruling: la ligne de la table de routage de `using-batches` qui mène au changement borné l'humain qui veut un ADR écrit, réécrit ou supprimé borne ce cas par cinq moments, « outside the adoption of a module, the opening of a batch, its amendment, the delivery review of a story and the installation » ; l'humain l'a tranché à la revue de cette story, qui corrige la ligne et sa garde dans `tests/test-skill-content.sh`, pour elle-même et pour les arbitrages que les stories `12-us-2-tenir-un-adr` et `12-us-4-les-adr-a-l-amendement` avaient ouverts sur la même ligne — l'adoption d'un module écrit l'ADR que l'humain veut, une story en écrit un à sa revue de livraison et l'installation supprime celui qu'il abandonne, sans changement borné — si c'est faux, un agent traite dans l'adoption, la revue de livraison ou l'installation un ADR qui demandait un changement borné.

## Observed drift
