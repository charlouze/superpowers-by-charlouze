# 11-us-9 — L'installation

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Le plugin s'accorde avec la section `Installing on a project` réécrite, et le `CLAUDE.md` du dépôt dit comment écrire une skill.

**Architecture:** `commands/init.md` et les skills ne changent pas. `scripts/init.sh` déplace un répertoire vide au lieu de le supprimer. Les gardes de `tests/` couvrent ce que la section réécrite promet et ne prêtent plus à la spec les refus qu'elle a perdus. Les entrées du gaps register que la réécriture résout sont supprimées.

**Tech Stack:** bash, Markdown.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/11-la-concision/README.md
**Sections:** Installing on a project
**Blocks:** D26

## Global Constraints

1. `Constraints` du lot :

   - `D28` est transcrit au plus tard avec `D13`, avec `D18` et avec `D29`.
   - `D16` et `D25` sont transcrits au plus tard avec `D30`, et `D30` au plus tard avec
     `D9`.
   - `D9` est transcrit au plus tard avec `D7`, et `D7` au plus tard avec `D3` et avec
     `D26`.
   - `D17` est transcrit au plus tard avec `D6`.
   - `D6` et `D12` sont transcrits ensemble.

2. Gel du fichier de spec :

   > Between the first commit of the branch and the opening of the pull request, no
   > task modifies the spec file. A story that discovers the spec must change stops.

3. Autorité : quand le lot et la spec se contredisent, la spec gagne, sans exception
   ni délibération. Implémenter ce que dit la spec, consigner un `Ruling:`, et
   poursuivre. Seul l'humain corrige une spec en cours de lot.

4. Concision :

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

## Git rules

- Aucun `git stash`, sous aucune forme. Pour mettre du travail de côté, faire un commit temporaire.
- Tout `git commit`, `git push`, `git fetch` et toute commande `gh` passent par le wrapper : `bash ~/.config/github-app/as-agent.sh git commit ...`.
- Une commande git par appel shell, sans variable ni sous-shell autour.
- Sujet de commit en français, Conventional Commits. Le message se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et ne porte aucune autre ligne d'attribution.
- Toute correction d'un commit de cette branche se commite en `fixup! <sujet du commit corrigé>`.
- `CHANGELOG.md` ne se touche pas.
- La suite : `bash tests/run-all.sh`, qui finit par `all tests passed`. Elle dure plusieurs minutes.

## Review Focus

- Une collision d'archivage sous `specs/` et une autre sous `plans/` : chaque destination occupée est nommée, et rien ne bouge.
- Un document libre à côté d'une collision : il ne bouge pas non plus.
- Une skill qui cite une section de la spec entre parenthèses : la garde échoue.
- Une skill qui cite une de ses propres sections entre parenthèses : la garde passe.
- Une section `CLAUDE.md` insérée entre les marqueurs du bloc : `scripts/init.sh` l'écraserait.

---

### Task 1: Retirer du gaps register les entrées résolues

**Files:**
- Modify: `docs/specs/supercharlouze.gaps.md`

La section `Installing on a project` réécrite ne promet plus la préservation du mode du fichier, ni qu'un refus laisse le fichier intact, ni que rien dans le flux ne lit les répertoires créés. Chaque entrée part dans son propre commit.

- [ ] **Step 1: Supprimer la violation sur le mode du fichier**

Supprimer, sous `## Violations`, l'entrée qui commence par « **Installing on a project** — la spec énonce sans réserve que « le mode du fichier est préservé » », jusqu'à son `reserved by batch-11` et la ligne vide qui la suit.

```bash
git add docs/specs/supercharlouze.gaps.md
bash ~/.config/github-app/as-agent.sh git commit -m "docs: retire du gaps register la violation sur le mode de CLAUDE.md" -m "La section Installing on a project, réécrite par le bloc D26 du lot 11, ne promet plus que l'installation préserve le mode du fichier." -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

- [ ] **Step 2: Supprimer la violation sur le `touch` avant les contrôles de marqueurs**

Supprimer, sous `## Violations`, l'entrée qui commence par « **Installing on a project** — la spec énonce que les refus laissent le fichier **intact** », jusqu'à son `reserved by batch-11`. La section `## Violations` reste, vide.

```bash
git add docs/specs/supercharlouze.gaps.md
bash ~/.config/github-app/as-agent.sh git commit -m "docs: retire du gaps register la violation sur le touch avant les marqueurs" -m "La section Installing on a project, réécrite par le bloc D26 du lot 11, ne promet plus aucun refus sur les marqueurs, ni qu'un refus laisse le fichier intact." -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

- [ ] **Step 3: Supprimer le gap sur la lecture des répertoires créés**

Supprimer, sous `## Gaps`, l'entrée qui commence par « **Installing on a project** — le second membre de la phrase sur les répertoires », jusqu'à son `reserved by batch-11` et la ligne vide qui la suit.

```bash
git add docs/specs/supercharlouze.gaps.md
bash ~/.config/github-app/as-agent.sh git commit -m "docs: retire du gaps register le gap sur la lecture des répertoires créés" -m "La section Installing on a project, réécrite par le bloc D26 du lot 11, ne dit plus que rien dans le flux ne lit ces répertoires avant qu'un document y soit écrit." -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

- [ ] **Step 4: Vérifier la garde du gaps register**

Run: `bash tests/test-gaps-register.sh`
Expected: aucun `[FAIL]`.

### Task 2: Garder l'énumération de toutes les destinations occupées

**Files:**
- Modify: `tests/test-init.sh` (nouveau cas avant la ligne finale `exit $((FAILURES > 0))`)

Selon la section réécrite, l'installation énumère toutes les destinations occupées et s'arrête avant tout déplacement. `scripts/init.sh` le fait déjà ; le cas de collision existant n'en essaie qu'une. Cette tâche ajoute la garde, sans toucher au script.

- [ ] **Step 1: Écrire la garde**

Insérer avant `exit $((FAILURES > 0))` :

```bash
# --- Case 20: every occupied destination is named before anything moves ---
P19="$TEST_ROOT/collisions"
mkdir -p "$P19/docs/superpowers/specs" "$P19/docs/superpowers/plans" \
         "$P19/docs/archive/specs" "$P19/docs/archive/plans"
printf 'INCOMING\n' > "$P19/docs/superpowers/specs/a.md"
printf 'INCOMING\n' > "$P19/docs/superpowers/plans/b.md"
printf 'FREE\n' > "$P19/docs/superpowers/specs/c.md"
printf 'EXISTING\n' > "$P19/docs/archive/specs/a.md"
printf 'EXISTING\n' > "$P19/docs/archive/plans/b.md"
ERR19="$TEST_ROOT/collisions.err"
if bash "$INIT" "$P19" >/dev/null 2>"$ERR19"; then
    fail "collisions: init exits non-zero"
else
    pass "collisions: init exits non-zero"
fi
if grep -qF "docs/archive/specs/a.md" "$ERR19" && grep -qF "docs/archive/plans/b.md" "$ERR19"; then
    pass "collisions: every occupied destination is named"
else
    fail "collisions: every occupied destination is named"
fi
if [ -f "$P19/docs/superpowers/specs/c.md" ] && [ ! -e "$P19/docs/archive/specs/c.md" ]; then
    pass "collisions: nothing moves, not even a free document"
else
    fail "collisions: nothing moves, not even a free document"
fi
```

- [ ] **Step 2: Vérifier que la garde mord**

Dans `scripts/init.sh`, commenter temporairement la ligne `collect_collisions plans`, lancer `bash tests/test-init.sh` : `collisions: every occupied destination is named` doit échouer. Rétablir la ligne ; `git diff scripts/init.sh` doit être vide.

- [ ] **Step 3: Lancer la garde**

Run: `bash tests/test-init.sh`
Expected: aucun `[FAIL]`, et les nouveaux `[PASS]` préfixés `collisions:`.

- [ ] **Step 4: Commit**

```bash
git add tests/test-init.sh
bash ~/.config/github-app/as-agent.sh git commit -m "test: l'installation nomme toutes les destinations occupées" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 3: Ne plus prêter à la spec les refus qu'elle a perdus

**Files:**
- Modify: `tests/test-init.sh:290`
- Modify: `tests/test-command.sh:50`

La section réécrite ne nomme plus aucune forme de marqueur cassé, et le refus de proposer un découpage vit désormais dans `Module`. Des commentaires de garde disent encore que la spec les porte. Les assertions ne changent pas : le script et la commande gardent leur comportement.

- [ ] **Step 1: Corriger le commentaire du cas du marqueur de fermeture sans ouverture, dans `tests/test-init.sh`**

Remplacer :

```bash
# The fourth broken-marker form the spec names, and the only one no fixture
```

par :

```bash
# Of the broken-marker forms the script refuses, the only one no fixture
```

- [ ] **Step 2: Corriger le commentaire de `tests/test-command.sh`**

Remplacer :

```bash
# Spec 9: init adopts nothing and proposes no module breakdown.
```

par :

```bash
# The command adopts nothing and proposes no module breakdown.
```

- [ ] **Step 3: Vérifier**

Run: `grep -n "the spec names\|Spec 9" tests/test-init.sh tests/test-command.sh`
Expected: aucune sortie.

Run: `bash tests/test-init.sh && bash tests/test-command.sh`
Expected: aucun `[FAIL]`.

- [ ] **Step 4: Commit**

```bash
git add tests/test-init.sh tests/test-command.sh
bash ~/.config/github-app/as-agent.sh git commit -m "test: les gardes de l'installation ne prêtent plus ses refus à la spec" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 4: Garder qu'aucune skill ne cite une section de la spec

**Files:**
- Modify: `tests/test-cross-references.sh` (nouvelle assertion avant la ligne finale `exit $((FAILURES > 0))`)

**Interfaces:**
- Produces: l'assertion `a skill cites no section of the living spec`, que la section `Writing a skill` du `CLAUDE.md` nomme.

Une section citée entre parenthèses et entre backticks dans une skill est une section de cette skill. Aujourd'hui, `grep -rnoE '\(`[A-Z][A-Za-z ]+`\)' skills/*/SKILL.md` ne rend que des lignes de `writing-a-batch`, qui citent ses propres sections.

- [ ] **Step 1: Écrire la garde**

Insérer avant `exit $((FAILURES > 0))` :

```bash
# 7. A skill cites no section of the living spec. A section a skill names in
#    parentheses is a heading of that skill: the spec is French, and it is not
#    among what the plugin ships.
BAD=0
for f in "$REPO_ROOT"/skills/*/SKILL.md; do
    while IFS= read -r title; do
        [ -n "$title" ] || continue
        if ! grep -qxE "#{1,4} $title" "$f"; then
            echo "    $(basename "$(dirname "$f")"): ($title) is no section of this skill"
            BAD=$((BAD + 1))
        fi
    done < <(grep -oE '\(`[A-Z][A-Za-z ]+`\)' "$f" | sed 's/^(`//; s/`)$//' | sort -u || true)
done
if [ "$BAD" = "0" ]; then
    pass "a skill cites no section of the living spec"
else
    fail "a skill cites no section of the living spec ($BAD found)"
fi
```

- [ ] **Step 2: Vérifier que la garde mord**

Ajouter temporairement la ligne `See (`Installing on a project`).` à la fin de `skills/closing-a-batch/SKILL.md`, lancer `bash tests/test-cross-references.sh` : l'assertion échoue et nomme `closing-a-batch: (Installing on a project)`. Retirer la ligne ; `git diff skills/` doit être vide.

- [ ] **Step 3: Lancer la garde**

Run: `bash tests/test-cross-references.sh`
Expected: aucun `[FAIL]`, dont `[PASS] a skill cites no section of the living spec`.

- [ ] **Step 4: Commit**

```bash
git add tests/test-cross-references.sh
bash ~/.config/github-app/as-agent.sh git commit -m "test: aucune skill ne cite une section de la spec" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 5: Dire dans `CLAUDE.md` comment écrire une skill

**Files:**
- Modify: `CLAUDE.md` (après la ligne `<!-- supercharlouze:end -->`)

**Interfaces:**
- Consumes: l'assertion `a skill cites no section of the living spec` de `tests/test-cross-references.sh`.

La section vit hors des marqueurs : `scripts/init.sh` réécrit tout ce qui se trouve entre eux. Elle est en anglais, comme `CONTRIBUTING.md`, et renvoie à `CONTRIBUTING.md` sans en répéter le contenu.

- [ ] **Step 1: Ajouter la section**

Ajouter à la fin de `CLAUDE.md`, après une ligne vide :

````markdown

## Writing a skill

How a change reaches `main`, how it is tested and how it is released is in `CONTRIBUTING.md`.

A skill is the plugin's code. It is entirely English, and it never cites a section of `docs/specs/supercharlouze.md`, which is French and is not among what the plugin ships: what an agent needs is stated in the skill itself. A section a skill names in parentheses is one of its own, and `tests/test-cross-references.sh` checks it with this search:

```bash
grep -rnoE '\(`[A-Z][A-Za-z ]+`\)' skills/*/SKILL.md
```

The spec states the rules. A skill carries the method, the reasons that help decide, and examples, the bad one before the good one.

A text meant to be pasted into a subagent's prompt is written for that subagent, who has nothing else: it stands on its own.

A rule is written in full in one place and pointed at everywhere else, because a second copy drifts.

Every norm a skill states is held by a guard in `tests/`, written before the text.

The `Concision` rules of `skills/using-batches/SKILL.md` apply to a skill's own prose.
````

- [ ] **Step 2: Vérifier**

Run: `bash scripts/init.sh .` puis `git diff CLAUDE.md`
Expected: le diff ne montre que la section ajoutée ; le script n'a rien changé au bloc ni à la section. Si `git status` montre d'autres fichiers créés ou modifiés par le script, les remettre dans leur état commité.

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 3: Commit**

```bash
git add CLAUDE.md
bash ~/.config/github-app/as-agent.sh git commit -m "docs: le CLAUDE.md du dépôt dit comment écrire une skill" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

- Ruling: les règles de la section `Writing a skill` du `CLAUDE.md` que les skills ne tiennent pas encore, une garde pour chaque norme qu'une skill énonce et une règle écrite en entier à un seul endroit, restent telles que l'humain les a dictées, sans arbitrage ouvert — l'humain a retiré l'arbitrage à la revue de livraison — si c'est faux, le `CLAUDE.md` énonce des règles que les skills ne tiennent pas encore.
- Ruling: la section `Writing a skill` du `CLAUDE.md` donne à une skill des règles de concision qui lui sont propres, au lieu des règles de `Concision` écrites pour les documents du flux ; ces règles sont une proposition de l'agent, qu'aucune garde ne tient encore — l'humain l'a décidé à la revue de livraison et a laissé l'agent proposer les règles — si c'est faux, une skill suit des règles que l'humain n'a pas choisies.
- Ruling: l'entrée du gaps register sur ce qui subsiste sous `docs/superpowers` est résolue dans cette story : `scripts/init.sh` recrée sous `docs/archive/` un répertoire vide au lieu de le supprimer, et l'entrée est retirée — l'humain l'a demandé à la revue de livraison, et la section réécrite déplace `specs/` et `plans/` entiers — si c'est faux, la story change un comportement du script que son lot n'annonçait pas.
- Ruling: la raison « because a second copy drifts » reste dans la règle de l'endroit unique — l'humain l'a dictée — si c'est faux, le `CLAUDE.md` porte une raison de trop.
- Ruling: la garde ne lit que la forme (`Titre`) dans les `SKILL.md`, et son libellé dit ce qu'elle vérifie plutôt que de l'étendre aux `references/` — c'est la forme du contrôle que l'humain a donné — si c'est faux, une citation de la spec dans `references/*.md` ou sous une autre forme passe.
- Ruling: `commands/init.md` garde son renvoi à `Installing on a project` — la règle du `CLAUDE.md` vise les skills, et le lot ne change pas la commande — si c'est faux, la commande renvoie un agent vers un texte français.

## Observed drift
