# supercharlouze v1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Livrer la v1 du plugin Claude Code `supercharlouze` — cinq skills, une
commande `/supercharlouze:init`, son script, le packaging, et la suite de
contrôles structurels du §11 de la spec.

**Architecture:** Un plugin Claude Code sans dépendance, sur le modèle de
`superpowers` : métadonnées dans `.claude-plugin/`, skills en markdown dans
`skills/<name>/SKILL.md`, commande en markdown dans `commands/`, mécanique
testable isolée dans `scripts/`, tests en bash pur dans `tests/`. Le bloc
`CLAUDE.md` a une **source canonique unique** (`skills/using-batches/references/claude-md-block.md`)
que le script d'init lit et que les tests comparent — sans quoi le script et les
skills divergeraient silencieusement.

**Tech Stack:** Markdown, bash (Git Bash sur Windows), `gh` CLI pour les
interrogations de pull requests. Aucune dépendance à installer.

**Spec:** `docs/superpowers/specs/2026-09-03-supercharlouze-design.md`

## Global Constraints

- Nom du plugin : `supercharlouze`. Namespace des skills : `supercharlouze:<name>`.
- Harness cible : Claude Code uniquement. Ne pas ajouter de support multi-harness (§13).
- **Le plugin est intégralement en anglais** — skills, commandes, README, bloc `CLAUDE.md`, messages, noms de fichiers, commentaires de scripts (§10).
- Les documents que le plugin fait produire dans un projet suivent la règle « ossature anglaise, prose dans la langue du projet » (§10). Cette règle doit être énoncée dans les skills concernés.
- Zéro dépendance. Les tests sont des scripts bash autonomes, sur le modèle de `superpowers/tests/hooks/test-session-start.sh`.
- Les cinq skills sont exactement : `using-batches`, `adopting-a-module`, `writing-a-batch`, `writing-a-user-story`, `closing-a-batch` (§7). N'en ajouter aucun.
- **Les quatre overrides du §8.3 doivent être nommés à la fois dans `using-batches` et dans le bloc `CLAUDE.md`** (§8.1, §11). C'est un contrôle testé.
- Vérification structurelle uniquement (§11). Ne pas écrire d'évaluation comportementale.
- Version initiale : `0.1.0`.

---

## File Structure

| Fichier | Responsabilité |
|---|---|
| `.claude-plugin/plugin.json` | Métadonnées du plugin |
| `.claude-plugin/marketplace.json` | Distribution depuis ce dépôt |
| `skills/using-batches/SKILL.md` | Routage, vocabulaire, autorité, les quatre overrides |
| `skills/using-batches/references/claude-md-block.md` | Source canonique du bloc `CLAUDE.md` |
| `skills/adopting-a-module/SKILL.md` | Adoption d'un module → PR spec + gaps register |
| `skills/writing-a-batch/SKILL.md` | Ouverture d'un batch → PR de batch |
| `skills/writing-a-user-story/SKILL.md` | Écriture d'une story → PR story |
| `skills/closing-a-batch/SKILL.md` | Clôture d'un batch → PR de clôture |
| `commands/init.md` | Point d'entrée `/supercharlouze:init` |
| `scripts/init.sh` | Mécanique idempotente de l'init (dossiers, archivage, bloc `CLAUDE.md`) |
| `tests/run-all.sh` | Lance tous les tests, sort non-zéro si un échoue |
| `tests/test-plugin-metadata.sh` | `plugin.json` / `marketplace.json` valides et cohérents |
| `tests/test-skill-frontmatter.sh` | Frontmatter de chaque `SKILL.md` |
| `tests/test-declared-overrides.sh` | Les quatre overrides présents des deux côtés |
| `tests/test-cross-references.sh` | Chemins et skills cités existent |
| `tests/test-init.sh` | Idempotence et comportement de `scripts/init.sh` |

Le découpage sépare **ce qui est mécanique et testable** (`scripts/`) de **ce qui
est prescriptif** (`skills/`). C'est ce qui rend le §11 réalisable : sans script,
l'idempotence du bloc `CLAUDE.md` ne serait vérifiable que par observation.

---

### Task 1: Plugin metadata and test harness

**Files:**
- Create: `.claude-plugin/plugin.json`
- Create: `.claude-plugin/marketplace.json`
- Create: `tests/run-all.sh`
- Test: `tests/test-plugin-metadata.sh`

**Interfaces:**
- Produces: `tests/run-all.sh` — exécute tout `tests/test-*.sh`, sort `1` si un
  test échoue. Chaque test est autonome et exécutable seul.
- Produces: la convention de test réutilisée par toutes les tâches suivantes :
  fonctions `pass`/`fail`, compteur `FAILURES`, sortie `exit $((FAILURES > 0))`.

- [ ] **Step 1: Write the failing test**

Créer `tests/test-plugin-metadata.sh` :

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-plugin-metadata"

PLUGIN_JSON="$REPO_ROOT/.claude-plugin/plugin.json"
MARKET_JSON="$REPO_ROOT/.claude-plugin/marketplace.json"

if [ -f "$PLUGIN_JSON" ]; then
    pass "plugin.json exists"
else
    fail "plugin.json exists"
fi

if [ -f "$MARKET_JSON" ]; then
    pass "marketplace.json exists"
else
    fail "marketplace.json exists"
fi

# Valid JSON, without depending on jq.
for f in "$PLUGIN_JSON" "$MARKET_JSON"; do
    if [ -f "$f" ] && node -e "JSON.parse(require('fs').readFileSync('$f','utf8'))" 2>/dev/null; then
        pass "$(basename "$f") is valid JSON"
    else
        fail "$(basename "$f") is valid JSON"
    fi
done

read_field() {
    node -e "const o=JSON.parse(require('fs').readFileSync('$1','utf8'));const v=$2;process.stdout.write(v===undefined?'':String(v))" 2>/dev/null
}

NAME="$(read_field "$PLUGIN_JSON" "o.name")"
if [ "$NAME" = "supercharlouze" ]; then
    pass "plugin name is supercharlouze"
else
    fail "plugin name is supercharlouze (got '$NAME')"
fi

PV="$(read_field "$PLUGIN_JSON" "o.version")"
MV="$(read_field "$MARKET_JSON" "o.plugins[0].version")"
if [ -n "$PV" ] && [ "$PV" = "$MV" ]; then
    pass "versions agree ($PV)"
else
    fail "versions agree (plugin '$PV', marketplace '$MV')"
fi

MN="$(read_field "$MARKET_JSON" "o.plugins[0].name")"
if [ "$MN" = "supercharlouze" ]; then
    pass "marketplace entry names the plugin"
else
    fail "marketplace entry names the plugin (got '$MN')"
fi

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-plugin-metadata.sh`
Expected: FAIL — `[FAIL] plugin.json exists`, puis les autres, sortie `1`.

- [ ] **Step 3: Write minimal implementation**

`.claude-plugin/plugin.json` :

```json
{
  "name": "supercharlouze",
  "description": "Overrides how superpowers organizes specs and plans: one living spec per module, batches of user stories, corrective batches",
  "version": "0.1.0",
  "author": { "name": "Charlouze" },
  "homepage": "https://github.com/charlouze/superpowers-by-charlouze",
  "repository": "https://github.com/charlouze/superpowers-by-charlouze",
  "keywords": ["superpowers", "specs", "plans", "batches", "user-stories"]
}
```

`.claude-plugin/marketplace.json` :

```json
{
  "name": "supercharlouze",
  "description": "Marketplace for the supercharlouze plugin",
  "owner": { "name": "Charlouze" },
  "plugins": [
    {
      "name": "supercharlouze",
      "description": "Overrides how superpowers organizes specs and plans: one living spec per module, batches of user stories, corrective batches",
      "version": "0.1.0",
      "source": "./",
      "author": { "name": "Charlouze" }
    }
  ]
}
```

`tests/run-all.sh` :

```bash
#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FAILED=0

for t in "$SCRIPT_DIR"/test-*.sh; do
    [ -f "$t" ] || continue
    if bash "$t"; then
        :
    else
        FAILED=$((FAILED + 1))
    fi
done

if [ "$FAILED" -gt 0 ]; then
    echo "$FAILED test file(s) failed"
    exit 1
fi

echo "all tests passed"
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-plugin-metadata.sh && bash tests/run-all.sh`
Expected: PASS — tous `[PASS]`, puis `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add .claude-plugin tests
git commit -m "feat: plugin metadata and bash test harness"
```

---

### Task 2: Skill frontmatter contract

**Files:**
- Create: `skills/using-batches/SKILL.md`
- Test: `tests/test-skill-frontmatter.sh`

**Interfaces:**
- Produces: le contrat que chaque `SKILL.md` respecte — frontmatter YAML avec
  `name` (identique au nom du répertoire) et `description` non vide.
- Consumes: la convention de test de la Task 1.

Cette tâche crée `using-batches` avec sa **structure** ; son contenu normatif
(overrides, autorité) est ajouté en Task 3 et Task 4, chacun sous son propre test.

- [ ] **Step 1: Write the failing test**

Créer `tests/test-skill-frontmatter.sh` :

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-skill-frontmatter"

EXPECTED_SKILLS="using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch"

for skill in $EXPECTED_SKILLS; do
    f="$REPO_ROOT/skills/$skill/SKILL.md"
    if [ ! -f "$f" ]; then
        fail "$skill/SKILL.md exists"
        continue
    fi
    pass "$skill/SKILL.md exists"

    if [ "$(head -1 "$f")" = "---" ]; then
        pass "$skill frontmatter opens on line 1"
    else
        fail "$skill frontmatter opens on line 1"
    fi

    front="$(awk 'NR>1 && /^---$/{exit} NR>1{print}' "$f")"

    name="$(printf '%s\n' "$front" | sed -n 's/^name:[[:space:]]*//p' | head -1)"
    if [ "$name" = "$skill" ]; then
        pass "$skill name matches directory"
    else
        fail "$skill name matches directory (got '$name')"
    fi

    desc="$(printf '%s\n' "$front" | sed -n 's/^description:[[:space:]]*//p' | head -1)"
    if [ -n "$desc" ]; then
        pass "$skill has a description"
    else
        fail "$skill has a description"
    fi
done

# No skill beyond the five the spec allows (§7).
if [ -d "$REPO_ROOT/skills" ]; then
    actual="$(ls "$REPO_ROOT/skills" | sort | tr '\n' ' ')"
    expected="$(printf '%s\n' $EXPECTED_SKILLS | sort | tr '\n' ' ')"
    if [ "$actual" = "$expected" ]; then
        pass "skills directory holds exactly the five declared skills"
    else
        fail "skills directory holds exactly the five declared skills (got: $actual)"
    fi
fi

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-frontmatter.sh`
Expected: FAIL — `[FAIL] using-batches/SKILL.md exists` et les quatre autres.

- [ ] **Step 3: Write minimal implementation**

Créer les cinq `SKILL.md` avec leur frontmatter et un titre. Le corps de chacun
est rempli par les tâches 3 à 9 ; ici on ne pose que la coquille conforme.

`skills/using-batches/SKILL.md` :

```markdown
---
name: using-batches
description: Use when working in a project whose CLAUDE.md says specs and plans are overridden - routes design and execution through living module specs, batches and user stories instead of dated design docs
---

# Using Batches

(Content added in later tasks.)
```

Créer de même, avec le corps `(Content added in later tasks.)` :

- `skills/adopting-a-module/SKILL.md` — `description: Use when a batch touches a functional module that has no living spec yet - builds the spec from human-validated documents and produces the gaps register`
- `skills/writing-a-batch/SKILL.md` — `description: Use when opening a batch of user stories, or requalifying a corrective batch - writes the batch document and opens the pull request whose review is the human gate`
- `skills/writing-a-user-story/SKILL.md` — `description: Use when writing the next user story of an open batch - transcribes the spec slice, then hands off to superpowers:writing-plans and subagent-driven-development`
- `skills/closing-a-batch/SKILL.md` — `description: Use when every user story of a batch is merged or abandoned - writes the changelog, consolidates observed drift, releases reservations and closes the batch`

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-skill-frontmatter.sh`
Expected: PASS — 21 lignes `[PASS]`.

- [ ] **Step 5: Commit**

```bash
git add skills tests/test-skill-frontmatter.sh
git commit -m "feat: five skill shells with a tested frontmatter contract"
```

---

### Task 3: The canonical CLAUDE.md block and the four declared overrides

**Files:**
- Create: `skills/using-batches/references/claude-md-block.md`
- Modify: `skills/using-batches/SKILL.md`
- Test: `tests/test-declared-overrides.sh`

**Interfaces:**
- Produces: `skills/using-batches/references/claude-md-block.md` — **source
  canonique** du bloc inséré dans les projets. Lu par `scripts/init.sh` (Task 4),
  jamais recopié ailleurs.
- Produces: la liste des quatre identifiants d'override utilisés par les tests :
  `brainstorming`, `subagent-driven-development`, `execution mode`,
  `finishing-a-development-branch`.

- [ ] **Step 1: Write the failing test**

Créer `tests/test-declared-overrides.sh` :

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-declared-overrides"

SKILL="$REPO_ROOT/skills/using-batches/SKILL.md"
BLOCK="$REPO_ROOT/skills/using-batches/references/claude-md-block.md"

if [ -f "$BLOCK" ]; then
    pass "canonical CLAUDE.md block exists"
else
    fail "canonical CLAUDE.md block exists"
    exit 1
fi

# Spec 8.3: four overrides, named in BOTH using-batches and the CLAUDE.md block.
check_both() {
    local label="$1" pattern="$2"
    if grep -qi -- "$pattern" "$SKILL"; then
        pass "using-batches names override: $label"
    else
        fail "using-batches names override: $label"
    fi
    if grep -qi -- "$pattern" "$BLOCK"; then
        pass "CLAUDE.md block names override: $label"
    else
        fail "CLAUDE.md block names override: $label"
    fi
}

check_both "brainstorming terminal state" "brainstorming"
check_both "SDD stop conditions"          "subagent-driven-development"
check_both "imposed execution mode"       "execution mode"
check_both "finishing-a-development-branch" "finishing-a-development-branch"

# The block must tell the agent to invoke the skill before design AND before execution (8.1).
if grep -qi "before any design work" "$BLOCK" && grep -qi "before executing any plan" "$BLOCK"; then
    pass "block requires invocation before design and before execution"
else
    fail "block requires invocation before design and before execution"
fi

# The block must not claim SDD is unchanged (8.1).
if grep -qi "subagent-driven-development.*applies unchanged" "$BLOCK"; then
    fail "block must not claim subagent-driven-development applies unchanged"
else
    pass "block does not claim subagent-driven-development applies unchanged"
fi

# using-batches must state that a fifth undeclared override is forbidden (8.3).
if grep -qi "fifth" "$SKILL"; then
    pass "using-batches forbids an undeclared fifth override"
else
    fail "using-batches forbids an undeclared fifth override"
fi

# using-batches carries the git model, which nothing else states (5.1).
if grep -qi "same pull request" "$SKILL"; then
    pass "using-batches states that spec slice and code ship together"
else
    fail "using-batches states that spec slice and code ship together"
fi

if grep -qi "gate" "$SKILL" && grep -qi "review" "$SKILL"; then
    pass "using-batches states that human gates are pull request reviews"
else
    fail "using-batches states that human gates are pull request reviews"
fi

if grep -qi "drift" "$SKILL"; then
    pass "using-batches states the drift rule"
else
    fail "using-batches states the drift rule"
fi

# Continuous deployment is the premise that makes feature flags necessary (2, 5.1).
if grep -qi "continuous" "$SKILL" && grep -qi "feature flag" "$SKILL"; then
    pass "using-batches ties continuous deployment to feature flags"
else
    fail "using-batches ties continuous deployment to feature flags"
fi

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-declared-overrides.sh`
Expected: FAIL — `[FAIL] canonical CLAUDE.md block exists`, sortie `1`.

- [ ] **Step 3: Write minimal implementation**

Créer `skills/using-batches/references/claude-md-block.md` avec **exactement** le
bloc du §8.1 de la spec, encadré des marqueurs que `scripts/init.sh` utilisera
pour son idempotence :

```markdown
<!-- supercharlouze:begin -->
## Specs and plans

This project overrides how superpowers organizes specs and plans. Invoke
`supercharlouze:using-batches` before any design work, and again before
executing any plan. It relocates specs and plans, reroutes the architectural
terminal state of superpowers:brainstorming, extends the stop conditions of
superpowers:subagent-driven-development, requires subagent-driven-development as
the execution mode, and constrains superpowers:finishing-a-development-branch to
the pull request option. It declares each of these overrides explicitly; where it
declares none, superpowers applies unchanged.
<!-- supercharlouze:end -->
```

Puis remplacer le corps de `skills/using-batches/SKILL.md` par le contenu
normatif, en le tirant des sections **§2 (vocabulaire), §3 (autorité, gel,
concurrence), §8.2 (ce qui est conservé et rerouté), §8.3 (les quatre overrides
avec leur justification), §10 (langue)** de la spec. Le document doit contenir,
au minimum, ces sections :

```markdown
## The Model
## The Git Model
## Authority and Conflict Rules
## What Is Kept, What Is Rerouted
## Declared Overrides
### Override 1 — architectural terminal state
### Override 2 — fifth stop condition (corrective batches)
### Override 3 — imposed execution mode
### Override 4 — finishing-a-development-branch is constrained to the pull request
## Language
## Red Flags
```

Exigences de contenu, vérifiées par le test :

- Les quatre overrides sont nommés avec leur justification recopiée du §8.3.
- Une phrase interdit explicitement **un cinquième override non déclaré**.
- Le bloc `CLAUDE.md` n'est **pas** recopié dans le SKILL.md : le skill renvoie à
  `skills/using-batches/references/claude-md-block.md`.
- `## The Git Model` porte le §5.1 : une story = une branche = une pull request
  portant **la tranche de spec et le code dans la même pull request** ; les
  gates humains sont des **revues** de pull request (table des trois gates) ; la
  règle de dérive du §4.1 énoncée sans exception ; les deux contraintes du
  projet — `main` protégée et **déployée en continu** — et le fait que la seconde
  est la raison d'être des **feature flags** (§2), avec le rejet motivé de la
  branche de lot et de `develop`. C'est le seul skill qui porte ce modèle — les
  autres l'appliquent sans le réexpliquer.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-declared-overrides.sh`
Expected: PASS — 15 lignes `[PASS]`.

- [ ] **Step 5: Commit**

```bash
git add skills/using-batches tests/test-declared-overrides.sh
git commit -m "feat: using-batches declares all four overrides, canonical CLAUDE.md block"
```

---

### Task 4: The init script

**Files:**
- Create: `scripts/init.sh`
- Test: `tests/test-init.sh`

**Interfaces:**
- Consumes: `skills/using-batches/references/claude-md-block.md` (Task 3).
- Produces: `scripts/init.sh <project-dir>` — idempotent. Crée l'arborescence,
  archive les documents superpowers, insère ou met à jour le bloc `CLAUDE.md`
  entre `<!-- supercharlouze:begin -->` et `<!-- supercharlouze:end -->`.
  Sortie `0` en succès. N'adopte rien, ne devine aucun module.

- [ ] **Step 1: Write the failing test**

Créer `tests/test-init.sh` :

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INIT="$REPO_ROOT/scripts/init.sh"
BLOCK="$REPO_ROOT/skills/using-batches/references/claude-md-block.md"
FAILURES=0
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-init"

if [ ! -x "$INIT" ] && [ ! -f "$INIT" ]; then
    fail "scripts/init.sh exists"
    exit 1
fi
pass "scripts/init.sh exists"

# --- Case 1: project with no CLAUDE.md ---
P1="$TEST_ROOT/fresh"
mkdir -p "$P1"
bash "$INIT" "$P1" >/dev/null

for d in docs/specs docs/batches docs/archive; do
    if [ -d "$P1/$d" ]; then pass "fresh: $d created"; else fail "fresh: $d created"; fi
done

if [ -f "$P1/CLAUDE.md" ] && grep -q "supercharlouze:using-batches" "$P1/CLAUDE.md"; then
    pass "fresh: CLAUDE.md created with the block"
else
    fail "fresh: CLAUDE.md created with the block"
fi

# --- Case 2: idempotence ---
bash "$INIT" "$P1" >/dev/null
COUNT="$(grep -c "supercharlouze:begin" "$P1/CLAUDE.md")"
if [ "$COUNT" = "1" ]; then
    pass "idempotent: block appears exactly once after two runs"
else
    fail "idempotent: block appears exactly once after two runs (got $COUNT)"
fi

# --- Case 3: existing CLAUDE.md is preserved ---
P2="$TEST_ROOT/existing"
mkdir -p "$P2"
printf '# My project\n\nSome house rules.\n' > "$P2/CLAUDE.md"
bash "$INIT" "$P2" >/dev/null
if grep -q "Some house rules." "$P2/CLAUDE.md" && grep -q "supercharlouze:using-batches" "$P2/CLAUDE.md"; then
    pass "existing: prior content preserved and block appended"
else
    fail "existing: prior content preserved and block appended"
fi

# --- Case 4: a stale block is replaced, not duplicated ---
P3="$TEST_ROOT/stale"
mkdir -p "$P3"
printf '# P\n\n<!-- supercharlouze:begin -->\nOLD CONTENT\n<!-- supercharlouze:end -->\n' > "$P3/CLAUDE.md"
bash "$INIT" "$P3" >/dev/null
if ! grep -q "OLD CONTENT" "$P3/CLAUDE.md" \
   && [ "$(grep -c "supercharlouze:begin" "$P3/CLAUDE.md")" = "1" ] \
   && grep -q "supercharlouze:using-batches" "$P3/CLAUDE.md"; then
    pass "stale: old block replaced in place"
else
    fail "stale: old block replaced in place"
fi

# --- Case 5: superpowers documents are archived ---
P4="$TEST_ROOT/migrate"
mkdir -p "$P4/docs/superpowers/specs" "$P4/docs/superpowers/plans"
touch "$P4/docs/superpowers/specs/2025-01-01-thing-design.md"
touch "$P4/docs/superpowers/plans/2025-01-02-thing.md"
bash "$INIT" "$P4" >/dev/null
if [ -f "$P4/docs/archive/specs/2025-01-01-thing-design.md" ] \
   && [ -f "$P4/docs/archive/plans/2025-01-02-thing.md" ]; then
    pass "migrate: superpowers docs moved under docs/archive"
else
    fail "migrate: superpowers docs moved under docs/archive"
fi

# --- Case 6: the inserted block matches the canonical source ---
CANON="$(cat "$BLOCK")"
INSERTED="$(sed -n '/supercharlouze:begin/,/supercharlouze:end/p' "$P1/CLAUDE.md")"
if [ "$CANON" = "$INSERTED" ]; then
    pass "inserted block is byte-identical to the canonical source"
else
    fail "inserted block is byte-identical to the canonical source"
fi

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-init.sh`
Expected: FAIL — `[FAIL] scripts/init.sh exists`, sortie `1`.

- [ ] **Step 3: Write minimal implementation**

Créer `scripts/init.sh` :

```bash
#!/usr/bin/env bash
# Idempotent project setup for the supercharlouze plugin.
# Creates the document tree, archives superpowers documents, and installs the
# CLAUDE.md block from its canonical source. Adopts nothing.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BLOCK_FILE="$PLUGIN_ROOT/skills/using-batches/references/claude-md-block.md"

PROJECT="${1:-.}"
PROJECT="$(cd "$PROJECT" && pwd)"

if [ ! -f "$BLOCK_FILE" ]; then
    echo "error: canonical CLAUDE.md block not found at $BLOCK_FILE" >&2
    exit 1
fi

mkdir -p "$PROJECT/docs/specs" "$PROJECT/docs/batches" "$PROJECT/docs/archive"

archive_dir() {
    local from="$PROJECT/docs/superpowers/$1"
    local to="$PROJECT/docs/archive/$1"
    [ -d "$from" ] || return 0
    mkdir -p "$to"
    find "$from" -maxdepth 1 -type f -exec mv -f {} "$to"/ \;
    rmdir "$from" 2>/dev/null || true
}

archive_dir specs
archive_dir plans
rmdir "$PROJECT/docs/superpowers" 2>/dev/null || true

CLAUDE_MD="$PROJECT/CLAUDE.md"
touch "$CLAUDE_MD"

if grep -q "supercharlouze:begin" "$CLAUDE_MD"; then
    # Replace the existing block in place, preserving everything around it.
    awk -v block="$BLOCK_FILE" '
        /supercharlouze:begin/ { while ((getline line < block) > 0) print line; skip=1; next }
        /supercharlouze:end/   { skip=0; next }
        !skip { print }
    ' "$CLAUDE_MD" > "$CLAUDE_MD.tmp"
    mv "$CLAUDE_MD.tmp" "$CLAUDE_MD"
else
    if [ -s "$CLAUDE_MD" ]; then printf '\n' >> "$CLAUDE_MD"; fi
    cat "$BLOCK_FILE" >> "$CLAUDE_MD"
fi

echo "supercharlouze: document tree ready under $PROJECT/docs"
echo "adopted modules:"
find "$PROJECT/docs/specs" -maxdepth 1 -name '*.md' ! -name '*.gaps.md' -exec basename {} .md \; 2>/dev/null | sed 's/^/  - /'
echo "archived documents not listed in any spec Sources section:"
for doc in $(find "$PROJECT/docs/archive" -type f -name '*.md' 2>/dev/null); do
    rel="${doc#"$PROJECT"/}"
    if ! grep -rqF "$rel" "$PROJECT/docs/specs" 2>/dev/null; then
        echo "  - $rel"
    fi
done
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-init.sh`
Expected: PASS — 10 lignes `[PASS]`.

- [ ] **Step 5: Commit**

```bash
git add scripts/init.sh tests/test-init.sh
git commit -m "feat: idempotent init script driven by the canonical CLAUDE.md block"
```

---

### Task 5: The /supercharlouze:init command

**Files:**
- Create: `commands/init.md`
- Test: `tests/test-command.sh`

**Interfaces:**
- Consumes: `scripts/init.sh` (Task 4).
- Produces: la commande `/supercharlouze:init`, sur le format du plugin
  `devcontainer` : frontmatter `description` + `argument-hint`, corps qui
  délègue.

- [ ] **Step 1: Write the failing test**

Ajouter ce test autonome `tests/test-command.sh` :

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-command"

CMD="$REPO_ROOT/commands/init.md"

if [ -f "$CMD" ]; then pass "commands/init.md exists"; else fail "commands/init.md exists"; exit 1; fi

if [ "$(head -1 "$CMD")" = "---" ]; then
    pass "command frontmatter opens on line 1"
else
    fail "command frontmatter opens on line 1"
fi

front="$(awk 'NR>1 && /^---$/{exit} NR>1{print}' "$CMD")"

if printf '%s\n' "$front" | grep -q "^description:"; then
    pass "command has a description"
else
    fail "command has a description"
fi

if printf '%s\n' "$front" | grep -q "^argument-hint:"; then
    pass "command has an argument-hint"
else
    fail "command has an argument-hint"
fi

if grep -q "scripts/init.sh" "$CMD"; then
    pass "command invokes scripts/init.sh"
else
    fail "command invokes scripts/init.sh"
fi

# The command must not re-describe the state of play rules; it delegates (spec 9).
if grep -q "supercharlouze:using-batches" "$CMD"; then
    pass "command points at the routing skill"
else
    fail "command points at the routing skill"
fi

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-command.sh`
Expected: FAIL — `[FAIL] commands/init.md exists`, sortie `1`.

- [ ] **Step 3: Write minimal implementation**

Créer `commands/init.md` :

```markdown
---
description: Set up or migrate this project to the supercharlouze specs-and-plans layout
argument-hint: "[project path — defaults to the current directory]"
---

Run `bash ${CLAUDE_PLUGIN_ROOT}/scripts/init.sh $ARGUMENTS` — if the argument is
empty, the current directory.

The script is idempotent: it creates `docs/specs/`, `docs/batches/` and
`docs/archive/`, moves any `docs/superpowers/specs` and `docs/superpowers/plans`
under `docs/archive/`, and installs or refreshes the CLAUDE.md block. Running it
twice changes nothing the second time.

Then report its output to your human partner as a state of play: which modules
are adopted, and which archived documents no spec claims as a source.

**Do not adopt anything.** Adoption is a deliberate, per-module decision made by
your human partner, and it runs through `supercharlouze:adopting-a-module`. Do
not propose a module breakdown either — a suggestion reads as a decision, and
module boundaries belong to your human partner.

Then read `supercharlouze:using-batches` so the rest of the session follows the
overridden workflow.
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-command.sh`
Expected: PASS — 6 lignes `[PASS]`.

- [ ] **Step 5: Commit**

```bash
git add commands tests/test-command.sh
git commit -m "feat: /supercharlouze:init command delegating to the init script"
```

---

### Task 6: adopting-a-module

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md`
- Test: `tests/test-skill-content.sh` *(créé ici, étendu par les tâches 7-9)*

**Interfaces:**
- Produces: le skill d'adoption. Il produit une **pull request** portant la spec
  et le gaps register ; sa revue est le gate humain (§5.1, §6.5).

- [ ] **Step 1: Write the failing test**

Créer `tests/test-skill-content.sh` :

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-skill-content"

require() {
    local skill="$1" label="$2" pattern="$3"
    local f="$REPO_ROOT/skills/$skill/SKILL.md"
    if grep -qi -- "$pattern" "$f" 2>/dev/null; then
        pass "$skill: $label"
    else
        fail "$skill: $label"
    fi
}

# --- adopting-a-module (spec 6) ---
require adopting-a-module "source authority order is stated"        "validated document"
require adopting-a-module "refuses to rebuild a spec from code"     "never.*from the code\|not.*reconstruct\|reconstruct"
require adopting-a-module "human delimits the module"              "delimit"
require adopting-a-module "records Sources in the spec"            "Sources"
require adopting-a-module "produces the gaps register"             "gaps register\|gaps.md"
require adopting-a-module "gaps register declares its coverage"    "coverage"
require adopting-a-module "review of the PR is the gate"           "pull request"
require adopting-a-module "handles the no-document fallback"       "no validated document\|degraded"

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — les 8 assertions `adopting-a-module` échouent (le corps est
encore `(Content added in later tasks.)`).

- [ ] **Step 3: Write minimal implementation**

Remplacer le corps de `skills/adopting-a-module/SKILL.md` par le contenu du **§6
de la spec**, en anglais, avec ces sections :

```markdown
## Overview
## Source Authority
## Steps
### 1. Delimit the module
### 2. Inventory the validated documents
### 3. Write the spec from those documents only
### 4. Audit the code against the spec
### 5. Open the adoption pull request
## Degraded Case: A Module With No Validated Documents
## Red Flags
```

Le contenu doit énoncer, mot pour mot depuis le §6 : l'ordre d'autorité
(documents validés normatifs, code comblant les silences, humain arbitre) ; le
refus explicite de reconstruire la spec depuis le code, avec sa raison ; la
délimitation réservée à l'humain ; l'inventaire présenté avant toute écriture et
enregistré dans la section `Sources` de la spec ; le gaps register avec ses deux
sections `Violations` / `Gaps` et sa **couverture déclarée** ; et le fait que la
revue de la pull request d'adoption *est* la revue humaine obligatoire.

La table `Red Flags` doit contenir au minimum :

| Thought | Reality |
|---------|---------|
| "The code is the real truth, I'll spec what it does" | That canonizes drift and destroys the premise of corrective batches. |
| "I can infer the module boundaries from the directory layout" | Boundaries belong to your human partner. A wrong one contaminates everything downstream. |
| "This old design doc is close enough to validated" | Ask. The spec's quality is capped by the inventory. |
| "The audit found nothing, so the register is empty" | An empty register must say whether nothing was found or nothing was examined. |

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: PASS — 8 lignes `[PASS]`.

- [ ] **Step 5: Commit**

```bash
git add skills/adopting-a-module tests/test-skill-content.sh
git commit -m "feat: adopting-a-module skill"
```

---

### Task 7: writing-a-batch

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md`
- Modify: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: `require()` de la Task 6.
- Produces: le skill d'ouverture. Attribue `NN` (§4), écrit le document de batch
  (§4.3), ouvre la PR dont la revue est le gate (§5.2), et porte la procédure de
  requalification (§8.3).

- [ ] **Step 1: Write the failing test**

Ajouter à `tests/test-skill-content.sh`, avant la ligne `exit` :

```bash
# --- writing-a-batch (spec 4, 4.3, 5.2, 8.3) ---
require writing-a-batch "NN accounts for open pull requests"      "gh pr list\|open pull request"
require writing-a-batch "batch document has no mutable state"     "no mutable state\|does not.*mutable"
require writing-a-batch "no story list in the batch document"     "story list\|list of stories"
require writing-a-batch "writes no spec at opening"               "no.*spec.*at this stage\|does not write.*spec"
require writing-a-batch "PR review is the human gate"             "gate"
require writing-a-batch "corrective batch reserves register entries" "reserved by batch"
require writing-a-batch "carries the requalification procedure"   "requalif"
require writing-a-batch "branch naming convention"                "batch/NN"
require writing-a-batch "batch document declares a feature flag"  "Feature flag"
require writing-a-batch "flag field is never left empty"          "never.*empty\|mandatory\|none"
require writing-a-batch "states the exemption criterion"          "incomplete"
require writing-a-batch "flag declares its scope"                 "scope"
require writing-a-batch "surfaces live flags on touched sections" "gating"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — les 13 nouvelles assertions échouent, les 8 de la Task 6 passent.

- [ ] **Step 3: Write minimal implementation**

Remplacer le corps de `skills/writing-a-batch/SKILL.md` par le contenu des **§4,
§4.3, §5.2 et §8.3 (procédure de requalification)**, avec ces sections :

```markdown
## Overview
## Preconditions
## Allocating NN
## The Batch Document
## Opening the Pull Request
## Requalifying a Corrective Batch
## Red Flags
```

Points obligatoires : `NN` = plus petit entier libre **sur `main` et parmi les
pull requests ouvertes**, avec la raison (un artefact n'atteint `main` qu'à la
fusion) ; branche `batch/NN-<slug>` ; le document de batch porte `Scope`,
`Spec delta`, `Feature flag` **et aucun état mutable**, ni liste de stories ni
cases à cocher, avec la raison (contention de fusion, et `gh pr list` dit mieux) ;
aucune écriture dans les specs à l'ouverture ; la revue de la PR *est* le gate ;
pour un batch correctif, réservation des entrées du registre en
`reserved by batch-NN` ; et la procédure de requalification du §8.3.

Le champ `Feature flag` (§2, §4.3) est **obligatoire et jamais vide** : soit un
nom, un défaut et une **portée**, soit `none` avec la raison. Le skill énonce le
critère d'exemption sous forme de question — *une story de ce lot, fusionnée
seule, laisserait-elle un utilisateur devant quelque chose d'incomplet ?* — et
ses trois familles de réponse « non » : refactor et infrastructure (aucun
changement de comportement, donc chaque PR est déployable), lot correctif (il
rétablit un comportement déjà promis, le retarder serait l'inverse de son objet),
lot à story unique. Reprendre les trois exemples de champ du §4.3 tels quels.

**Portée du flag** : le lot par défaut. Une portée qui le dépasse — un module
construit sur plusieurs lots et ouvert seulement une fois complet — **doit nommer
sa condition de levée**, faute de quoi un flag voulu et un flag oublié sont
indiscernables.

**Faire remonter les flags vivants** (§5.2) : si une phrase de gating couvre déjà
une section que ce lot va toucher, la signaler dans le document de batch avec sa
condition de levée, pour que l'humain tranche au gate si ce lot la satisfait et
porte donc la story de levée.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: PASS — 21 lignes `[PASS]`.

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-batch tests/test-skill-content.sh
git commit -m "feat: writing-a-batch skill"
```

---

### Task 8: writing-a-user-story

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md`
- Modify: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: `require()` de la Task 6.
- Produces: le skill le plus chargé du plugin — préconditions git, détection de
  concurrence, transcription, handoff vers `superpowers:writing-plans` puis
  `subagent-driven-development`, Override 4, rapatriement des rulings, réponse à
  la revue (§4.4, §5.1, §5.3).

- [ ] **Step 1: Write the failing test**

Ajouter à `tests/test-skill-content.sh`, avant la ligne `exit` :

```bash
# --- writing-a-user-story (spec 3, 4.4, 5.1, 5.3) ---
require writing-a-user-story "checks it is in the main checkout"   "main checkout\|GIT_COMMON"
require writing-a-user-story "refreshes main before starting"      "fetch\|pull\|refresh"
require writing-a-user-story "concurrency via declared Sections"   "Sections:"
require writing-a-user-story "git conflict is only a partial net"  "partial"
require writing-a-user-story "transcription is the first commit"   "first commit"
require writing-a-user-story "spec freeze is carried in Global Constraints" "Global Constraints"
require writing-a-user-story "spec freeze has an end bound"        "until the pull request\|freeze.*lifted\|lifted"
require writing-a-user-story "corrective story strikes a register entry" "corrective"
require writing-a-user-story "hands off to superpowers:writing-plans" "writing-plans"
require writing-a-user-story "requires subagent-driven-development"  "subagent-driven-development"
require writing-a-user-story "constrains finishing to the PR option" "finishing-a-development-branch"
require writing-a-user-story "records rulings before the merge"    "Rulings"
require writing-a-user-story "records observed drift in the story" "Observed drift"
require writing-a-user-story "answers review feedback on the branch" "review"
require writing-a-user-story "story branch naming convention"      "story/NN"
require writing-a-user-story "slice states the flag and its default" "feature flag\|flag"
require writing-a-user-story "describes the flag-lifting story"    "lift"
require writing-a-user-story "extended-scope flag is lifted later" "beyond this batch\|extended"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — les 18 nouvelles assertions échouent, les 21 précédentes passent.

- [ ] **Step 3: Write minimal implementation**

Remplacer le corps de `skills/writing-a-user-story/SKILL.md` par le contenu des
**§3, §4.4, §5.1 et §5.3**, avec ces sections :

```markdown
## Overview
## Preconditions
## Step 1 — Detect Concurrency
## Step 2 — Allocate us-N and Create the Branch
## Step 3 — Commit the Spec Slice First
## Step 4 — Write the Plan
## Step 5 — Execute
## Step 6 — Record Before the Merge
## Step 7 — Answer the Review
## Red Flags
```

Points obligatoires :

- Préconditions : être dans le checkout principal (`GIT_DIR == GIT_COMMON`), sur
  `main` rafraîchie — avec la raison : `finishing-a-development-branch` préserve
  le worktree sur le chemin PR, et `using-git-worktrees` sauterait alors la
  création.
- Détection de concurrence : lire le champ `Sections:` des documents de story des
  pull requests ouvertes touchant la même spec, s'arrêter si l'intersection n'est
  pas vide. Dire que le conflit de fusion git n'est qu'un filet **partiel**, avec
  la raison (git conflicte sur des lignes, pas sur des sections).
- Le header de story : `Spec:`, `Batch:`, `Sections:`.
- La tranche de spec est le **premier commit** de la branche, avant le plan, avec
  la raison du §4.4 condition 2 : rendre la norme antérieure et opposable au code.
- Si le batch déclare un feature flag, la tranche transcrite **énonce le flag et
  son défaut** (§4.1), et le code de la story est gardé par lui.
- **La story de levée** (§5.3) retire le branchement dans le code et la phrase de
  gating dans la spec. C'est une story et non un devoir de clôture parce qu'elle
  porte du code, donc mérite revue et tests. Dire aussi qu'on peut la couper en
  deux — activer, puis retirer — si une période d'observation est souhaitée.
- **À qui appartient la story de levée** : au batch courant si le flag est à
  portée de batch ; au batch qui satisfait la condition de levée si la portée est
  étendue (`beyond this batch`), souvent le dernier batch d'un module en
  construction. Le skill ne le devine pas : c'est le gate d'ouverture qui l'a
  tranché (§5.2).
- Cas correctif : delta vide, le premier commit barre l'entrée du gaps register.
- `Global Constraints` porte les contraintes du batch **et** le gel du fichier de
  spec, avec sa **borne** : levé à l'ouverture de la pull request.
- Exécution : `superpowers:writing-plans` puis
  `superpowers:subagent-driven-development` (Override 3), et
  `finishing-a-development-branch` contraint à « Push and create a Pull Request »
  (Override 4), avec sa justification — le merge local détruit worktree et
  branche avant d'échouer contre la protection.
- Avant fusion : rulings du message final de SDD dans le `Rulings log`, dérives
  hors périmètre sous `Observed drift`. Dire que ces informations sont
  périssables.
- Réponse à la revue sur la branche, gel levé.

Table `Red Flags` minimale :

| Thought | Reality |
|---------|---------|
| "I'll write the whole batch delta now, it's more efficient" | Reviewers would flag the next stories' behaviour as missing. One slice per story. |
| "The spec is wrong, I'll fix it while I'm here" | Only your human partner corrects a spec. Stop and say so. |
| "No merge conflict, so no one else is on this section" | Git conflicts on lines, not sections. Check the open pull requests. |
| "I'm already in a worktree, that's fine" | Then the next story's code lands on the previous story's branch. Return to the main checkout. |
| "Merging locally is quicker" | main is protected. It deletes the worktree, then fails at push, and takes the unrecorded rulings with it. |

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: PASS — 39 lignes `[PASS]`.

- [ ] **Step 5: Commit**

```bash
git add skills/writing-a-user-story tests/test-skill-content.sh
git commit -m "feat: writing-a-user-story skill"
```

---

### Task 9: closing-a-batch

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md`
- Modify: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: `require()` de la Task 6.
- Produces: le skill de clôture, qui porte les six devoirs du §5.4 — dont quatre
  n'ont aucun autre porteur dans le système.

- [ ] **Step 1: Write the failing test**

Ajouter à `tests/test-skill-content.sh`, avant la ligne `exit` :

```bash
# --- closing-a-batch (spec 4.1, 4.2, 5.4) ---
require closing-a-batch "writes one changelog line per batch"     "one line per batch\|per batch"
require closing-a-batch "consolidates Observed drift"             "Observed drift"
require closing-a-batch "releases unconsumed reservations"        "releas"
require closing-a-batch "records undelivered intentions"          "undelivered\|never delivered\|not delivered"
require closing-a-batch "sets status closed"                      "status: closed"
require closing-a-batch "closing PR is reviewed like any other"   "review"
require closing-a-batch "branch naming convention"                "batch/NN"
require closing-a-batch "refuses to close on an undeclared flag"  "flag"
require closing-a-batch "accepts a declared extended-scope flag" "beyond this batch\|extended"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — les 9 nouvelles assertions échouent, les 39 précédentes passent.

- [ ] **Step 3: Write minimal implementation**

Remplacer le corps de `skills/closing-a-batch/SKILL.md` par le contenu du **§5.4**,
avec ces sections :

```markdown
## Overview
## Preconditions
## The Six Duties
### 1. Write the changelog line
### 2. Consolidate observed drift
### 3. Release unconsumed reservations
### 4. Record intentions announced but never delivered
### 5. Refuse to close on a flag that survives without a declared scope
### 6. Set status: closed
## Red Flags
```

Points obligatoires : branche `batch/NN-<slug>-close` ; une **seule** ligne de
changelog par batch et par spec touchée, avec la raison (le faire écrire par
chaque story ferait conflicter toutes les stories d'un module en vol) ;
consolidation des sections `Observed drift` des stories dans le gaps register ;
libération des réservations non consommées, avec la raison (la réservation vit
sur `main`, fermer la PR d'une story ne l'emporte pas) ; constat des intentions
annoncées et non livrées, inscrites au registre comme *gaps*, avec la raison
(sans ça l'abandon d'une story est invisible : ni dérive, ni gap, juste une
promesse oubliée) ; `status: closed` ; et la revue de cette PR comme les autres.

Table `Red Flags` minimale :

| Thought | Reality |
|---------|---------|
| "A story was abandoned, nothing to do — closing the PR undid it all" | Not on main: its reservation and the batch's announced intention are still there. |
| "The changelog is already up to date, each story added its line" | Stories do not write the changelog. One line per batch, here. |
| "Observed drift is out of scope for this batch" | That is exactly why it goes to the register instead of being forgotten. |

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: PASS — 48 lignes `[PASS]`.

- [ ] **Step 5: Commit**

```bash
git add skills/closing-a-batch tests/test-skill-content.sh
git commit -m "feat: closing-a-batch skill"
```

---

### Task 10: Cross-reference integrity and README

**Files:**
- Create: `tests/test-cross-references.sh`
- Modify: `README.md`

**Interfaces:**
- Consumes: tous les fichiers produits par les tâches 1 à 9.
- Produces: le dernier contrôle du §11 — « les chemins cités d'un skill à l'autre
  existent » — et un README qui décrit le plugin livré.

- [ ] **Step 1: Write the failing test**

Créer `tests/test-cross-references.sh` :

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-cross-references"

KNOWN_SKILLS="using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch"

# 1. Every supercharlouze:<skill> reference names a skill that exists.
BAD=0
while read -r ref; do
    [ -n "$ref" ] || continue
    found=0
    for s in $KNOWN_SKILLS; do
        [ "$ref" = "$s" ] && found=1
    done
    if [ "$found" = "0" ]; then
        echo "    unknown skill reference: supercharlouze:$ref"
        BAD=$((BAD + 1))
    fi
done < <(grep -rhoE 'supercharlouze:[a-z-]+' "$REPO_ROOT/skills" "$REPO_ROOT/commands" 2>/dev/null | sed 's/^supercharlouze://' | sort -u)

if [ "$BAD" = "0" ]; then
    pass "every supercharlouze:<skill> reference resolves"
else
    fail "every supercharlouze:<skill> reference resolves ($BAD unknown)"
fi

# 2. Every repo-relative path in backticks exists.
BAD=0
while read -r p; do
    [ -n "$p" ] || continue
    if [ ! -e "$REPO_ROOT/$p" ]; then
        echo "    missing path: $p"
        BAD=$((BAD + 1))
    fi
done < <(grep -rhoE '`(skills|scripts|commands|tests|\.claude-plugin)/[A-Za-z0-9._/-]+`' "$REPO_ROOT/skills" "$REPO_ROOT/commands" 2>/dev/null | tr -d '`' | sort -u)

if [ "$BAD" = "0" ]; then
    pass "every repo-relative path referenced in skills exists"
else
    fail "every repo-relative path referenced in skills exists ($BAD missing)"
fi

# 3. The canonical block is referenced, never duplicated (spec 8.1).
COPIES="$(grep -rl "supercharlouze:begin" "$REPO_ROOT/skills" "$REPO_ROOT/commands" 2>/dev/null | wc -l | tr -d ' ')"
if [ "$COPIES" = "1" ]; then
    pass "the CLAUDE.md block exists in exactly one file"
else
    fail "the CLAUDE.md block exists in exactly one file (found $COPIES)"
fi

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-cross-references.sh`
Expected: FAIL si un skill cite un chemin inexistant ou duplique le bloc. Si tout
est déjà propre, la sortie est PASS — dans ce cas, vérifier que le test détecte
bien un problème en ajoutant temporairement une ligne `` `skills/nope/SKILL.md` ``
dans un skill, relancer (doit échouer), puis retirer la ligne.

- [ ] **Step 3: Write minimal implementation**

Corriger toute référence cassée signalée par le test. Puis remplacer la section
`## Status` du `README.md` par :

```markdown
## Status

v0.1.0 — the five skills, the `/supercharlouze:init` command and the structural
test suite are in place.

## Install

```bash
/plugin marketplace add charlouze/superpowers-by-charlouze
/plugin install supercharlouze@supercharlouze
```

Then, in each project you want to move over:

```
/supercharlouze:init
```

## Skills

| Skill | Use it when |
|---|---|
| `supercharlouze:using-batches` | Entry point — routing, authority rules, declared overrides |
| `supercharlouze:adopting-a-module` | A module has no living spec yet |
| `supercharlouze:writing-a-batch` | Opening a batch of user stories |
| `supercharlouze:writing-a-user-story` | Writing the next story of an open batch |
| `supercharlouze:closing-a-batch` | Every story is merged or abandoned |

## Tests

```bash
bash tests/run-all.sh
```

Structural checks only — see §11 of the design document for what is deliberately
not tested.
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/run-all.sh`
Expected: PASS — chaque fichier de test affiche ses `[PASS]`, puis
`all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add tests/test-cross-references.sh README.md
git commit -m "feat: cross-reference integrity test, README for v0.1.0"
```

---

## Notes for the executor

**Ce plan construit le plugin avec superpowers nu** — c'est la phase 1 du §12 de
la spec. Ne pas essayer d'utiliser `supercharlouze:writing-a-batch` pour
construire `supercharlouze` : il n'existe pas encore. La phase 2, qui lance
`/supercharlouze:init` sur ce dépôt même, vient après cette livraison et n'est
pas dans ce plan.

**Le contenu des skills se lit dans la spec.** Les tâches 3 et 6 à 9 nomment les
sections de la spec dont chaque skill est la traduction opérationnelle, et les
tests fixent ce qui doit y figurer. La spec voyage avec ce plan — c'est le champ
`Spec:` de l'en-tête, et elle fait autorité en cas de désaccord avec ce plan.

**Tout est en anglais dans le plugin livré**, y compris les tables `Red Flags` et
les messages de `scripts/init.sh` (§10). Les seules parties françaises de ce
dépôt sont les documents de conception, qui sont de la prose de spécification.
