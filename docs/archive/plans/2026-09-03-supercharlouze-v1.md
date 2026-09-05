# supercharlouze v1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Livrer la v1 du plugin Claude Code `supercharlouze` — cinq skills, une
commande `/supercharlouze:init`, son script, le packaging, et la suite de
contrôles structurels du §11 de la spec.

**Architecture:** Un plugin Claude Code sur le modèle de `superpowers` :
métadonnées dans `.claude-plugin/`, skills en markdown dans
`skills/<name>/SKILL.md`, commande en markdown dans `commands/`, mécanique
testable isolée dans `scripts/`, tests en bash pur dans `tests/`. Le bloc
`CLAUDE.md` a une **source canonique unique**
(`skills/using-batches/references/claude-md-block.md`) que le script d'init lit
et que les tests comparent — sans quoi le script et les skills divergeraient
silencieusement.

**Tech Stack:** Markdown, bash (Git Bash sous Windows), `node` pour valider du
JSON, `gh` pour interroger les pull requests.

**Spec:** `docs/superpowers/specs/2026-09-03-supercharlouze-design.md`

## Global Constraints

- Nom du plugin : `supercharlouze`. Namespace des skills : `supercharlouze:<name>`.
- Harness cible : Claude Code uniquement. Pas de support multi-harness (§13).
- **Le plugin est intégralement en anglais** — skills, commandes, README, bloc `CLAUDE.md`, messages, noms de fichiers, commentaires de scripts (§10).
- La règle de langue du §10 — ossature anglaise, prose dans la langue du projet — doit être énoncée **dans chaque skill qui fait produire un document** : `adopting-a-module`, `writing-a-batch`, `writing-a-user-story`, `closing-a-batch`.
- **Pas de dépendance à installer.** `node` et `gh` sont utilisés, et tous deux accompagnent déjà l'environnement Claude Code. Ne rien ajouter d'autre — pas de `jq`, pas de gestionnaire de paquets.
- Les cinq skills sont exactement : `using-batches`, `adopting-a-module`, `writing-a-batch`, `writing-a-user-story`, `closing-a-batch` (§7). N'en ajouter aucun.
- **Les quatre overrides du §8.3 doivent être nommés à la fois dans `using-batches` et dans le bloc `CLAUDE.md`** (§8.1, §11). C'est un contrôle testé.
- Vérification structurelle uniquement (§11). Ne pas écrire d'évaluation comportementale.
- Version initiale : `0.1.0`.

**Convention des étapes de test.** Une Step 2 (« verify it fails ») réussit dès
lors que les assertions nommées apparaissent en `[FAIL]` et que le fichier sort
`1` — **ne comptez pas les lignes**. Une Step 4 (« verify it passes ») réussit
quand le fichier ne produit **aucune ligne `[FAIL]`** et sort `0`. Les totaux
d'assertions changent à chaque ajout ; s'y fier ferait dérailler l'exécution pour
rien.

---

## File Structure

| Fichier | Responsabilité |
|---|---|
| `.claude-plugin/plugin.json` | Métadonnées du plugin |
| `.claude-plugin/marketplace.json` | Distribution depuis ce dépôt |
| `skills/using-batches/SKILL.md` | Routage, vocabulaire, autorité, modèle git, les quatre overrides |
| `skills/using-batches/references/claude-md-block.md` | Source canonique du bloc `CLAUDE.md` |
| `skills/adopting-a-module/SKILL.md` | Adoption d'un module → PR spec + gaps register |
| `skills/writing-a-batch/SKILL.md` | Ouverture, amendement, requalification → PR de batch |
| `skills/writing-a-user-story/SKILL.md` | Story, levée, démontage → PR de story |
| `skills/closing-a-batch/SKILL.md` | Clôture → PR de clôture |
| `commands/init.md` | Point d'entrée `/supercharlouze:init` |
| `scripts/init.sh` | Mécanique idempotente de l'init |
| `tests/run-all.sh` | Lance tous les `tests/test-*.sh`, sort non-zéro si un échoue |
| `tests/test-plugin-metadata.sh` | `plugin.json` / `marketplace.json` valides et cohérents |
| `tests/test-skill-frontmatter.sh` | Frontmatter et inventaire des skills |
| `tests/test-declared-overrides.sh` | Les quatre overrides présents des deux côtés |
| `tests/test-command.sh` | Format et contenu de `commands/init.md` |
| `tests/test-skill-content.sh` | Ce que le **corps** de chaque skill doit énoncer |
| `tests/test-init.sh` | Idempotence et sûreté de `scripts/init.sh` |
| `tests/test-cross-references.sh` | Chemins et skills cités existent |

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
  test échoue. Chaque test reste exécutable seul.
- Produces: la convention réutilisée par toutes les tâches suivantes : fonctions
  `pass`/`fail`, compteur `FAILURES`, sortie `exit $((FAILURES > 0))`.

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

for f in "$PLUGIN_JSON" "$MARKET_JSON"; do
    if [ -f "$f" ]; then
        pass "$(basename "$f") exists"
    else
        fail "$(basename "$f") exists"
    fi
done

# Read a field with node. The path goes through argv, never interpolated into
# the -e program: Git Bash hands node a /c/Users/... path, and node on Windows
# would resolve it as C:\c\Users\... and fail with ENOENT.
read_field() {
    node -e '
        const fs = require("fs");
        const o = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
        const path = process.argv[2].split(".");
        let v = o;
        for (const k of path) { v = v === undefined ? v : v[/^\d+$/.test(k) ? Number(k) : k]; }
        process.stdout.write(v === undefined ? "" : String(v));
    ' "$1" "$2" 2>/dev/null || true
}

for f in "$PLUGIN_JSON" "$MARKET_JSON"; do
    if [ -f "$f" ] && node -e 'JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"))' "$f" 2>/dev/null; then
        pass "$(basename "$f") is valid JSON"
    else
        fail "$(basename "$f") is valid JSON"
    fi
done

NAME="$(read_field "$PLUGIN_JSON" "name")"
if [ "$NAME" = "supercharlouze" ]; then
    pass "plugin name is supercharlouze"
else
    fail "plugin name is supercharlouze (got '$NAME')"
fi

PV="$(read_field "$PLUGIN_JSON" "version")"
MV="$(read_field "$MARKET_JSON" "plugins.0.version")"
if [ -n "$PV" ] && [ "$PV" = "$MV" ]; then
    pass "versions agree ($PV)"
else
    fail "versions agree (plugin '$PV', marketplace '$MV')"
fi

MN="$(read_field "$MARKET_JSON" "plugins.0.name")"
if [ "$MN" = "supercharlouze" ]; then
    pass "marketplace entry names the plugin"
else
    fail "marketplace entry names the plugin (got '$MN')"
fi

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-plugin-metadata.sh`
Expected: FAIL — `[FAIL] plugin.json exists` et les suivantes, sortie `1`.

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
    if ! bash "$t"; then
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
Expected: PASS — aucune ligne `[FAIL]`, puis `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add .claude-plugin tests
git commit -m "feat: plugin metadata and bash test harness"
```

---

### Task 2: Skill frontmatter contract

**Files:**
- Create: les cinq `skills/<name>/SKILL.md` (coquilles)
- Test: `tests/test-skill-frontmatter.sh`

**Interfaces:**
- Produces: le contrat que chaque `SKILL.md` respecte — frontmatter YAML avec
  `name` (identique au nom du répertoire) et `description` non vide.

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

Créer les cinq `SKILL.md` avec leur frontmatter, un titre, et le corps
`(Content added in later tasks.)`. Frontmatter exact :

```markdown
---
name: using-batches
description: Use when working in a project whose CLAUDE.md says specs and plans are overridden - routes design and execution through living module specs, batches and user stories instead of dated design docs
---

# Using Batches

(Content added in later tasks.)
```

Les quatre autres, mêmes structure et corps provisoire :

- `adopting-a-module` — `description: Use when a batch touches a functional module that has no living spec yet - builds the spec from human-validated documents and produces the gaps register`
- `writing-a-batch` — `description: Use when opening a batch of user stories, amending one, or requalifying a corrective batch - writes the batch document and opens the pull request whose review is the human gate`
- `writing-a-user-story` — `description: Use when writing the next user story of an open batch - transcribes the spec slice, then hands off to superpowers:writing-plans and subagent-driven-development`
- `closing-a-batch` — `description: Use when every user story of a batch is merged or abandoned - writes the changelog, consolidates observed drift, releases reservations, checks flags and closes the batch`

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-skill-frontmatter.sh`
Expected: PASS — aucune ligne `[FAIL]`, sortie `0`.

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
- Produces: le bloc canonique, lu par `scripts/init.sh` (Task 4) et jamais
  recopié ailleurs.

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

if [ -f "$BLOCK" ] && [ -f "$SKILL" ]; then
    pass "skill and canonical block both exist"
else
    fail "skill and canonical block both exist"
    exit 1
fi

# Flatten both files: a phrase must match regardless of how the prose is wrapped.
SKILL_FLAT="$(tr '\n' ' ' < "$SKILL")"
BLOCK_FLAT="$(tr '\n' ' ' < "$BLOCK")"

has() { case "$2" in *"$1"*) return 0 ;; *) return 1 ;; esac }

check_both() {
    local label="$1" needle="$2"
    if has "$needle" "$SKILL_FLAT"; then
        pass "using-batches names override: $label"
    else
        fail "using-batches names override: $label"
    fi
    if has "$needle" "$BLOCK_FLAT"; then
        pass "CLAUDE.md block names override: $label"
    else
        fail "CLAUDE.md block names override: $label"
    fi
}

check_both "brainstorming steps 6 to 9"    "superpowers:brainstorming"
check_both "SDD stop conditions"           "superpowers:subagent-driven-development"
check_both "imposed execution mode"        "execution mode"
check_both "finishing-a-development-branch" "superpowers:finishing-a-development-branch"

if has "before any design work" "$BLOCK_FLAT" && has "before executing any plan" "$BLOCK_FLAT"; then
    pass "block requires invocation before design and before execution"
else
    fail "block requires invocation before design and before execution"
fi

if has "steps 6 to 9" "$BLOCK_FLAT"; then
    pass "block scopes the brainstorming override to steps 6 to 9"
else
    fail "block scopes the brainstorming override to steps 6 to 9"
fi

if has "subagent-driven-development applies unchanged" "$BLOCK_FLAT"; then
    fail "block must not claim subagent-driven-development applies unchanged"
else
    pass "block does not claim subagent-driven-development applies unchanged"
fi

if has "fifth" "$SKILL_FLAT"; then
    pass "using-batches forbids an undeclared fifth override"
else
    fail "using-batches forbids an undeclared fifth override"
fi

# The git model lives here and nowhere else (spec 5.1).
for needle in "same pull request" "continuous" "feature flag" "drift"; do
    if has "$needle" "$SKILL_FLAT"; then
        pass "using-batches states: $needle"
    else
        fail "using-batches states: $needle"
    fi
done

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-declared-overrides.sh`
Expected: FAIL — `[FAIL] skill and canonical block both exist`, sortie `1`.

- [ ] **Step 3: Write minimal implementation**

Créer `skills/using-batches/references/claude-md-block.md` avec **exactement** ce
contenu — une phrase par ligne, ce qui garde chaque phrase greppable :

```markdown
<!-- supercharlouze:begin -->
## Specs and plans

This project overrides how superpowers organizes specs and plans.
Invoke `supercharlouze:using-batches` before any design work, and again before executing any plan.
It relocates specs and plans, replaces steps 6 to 9 of the architectural checklist of superpowers:brainstorming, extends the stop conditions of superpowers:subagent-driven-development, requires subagent-driven-development as the execution mode, and constrains superpowers:finishing-a-development-branch to the pull request option.
It declares each of these overrides explicitly; where it declares none, superpowers applies unchanged.
<!-- supercharlouze:end -->
```

Puis écrire le corps de `skills/using-batches/SKILL.md` à partir des sections
**§2, §3, §5.1, §8.2, §8.3 et §10** de la spec, avec ces sections :

```markdown
## The Model
## The Git Model
## Authority and Conflict Rules
## What Is Kept, What Is Rerouted
## Declared Overrides
### Override 1 — steps 6 to 9 of the architectural checklist
### Override 2 — fifth stop condition (corrective batches)
### Override 3 — imposed execution mode
### Override 4 — finishing-a-development-branch is constrained to the pull request
## Language
## Red Flags
```

Exigences de contenu :

- **`## The Model`** : module, spec, section, batch, user story, corrective
  batch, feature flag — avec le flag **par couple (lot, module)** et le critère
  d'exemption sous forme de question (§2).
- **`## The Git Model`** : `main` protégée **et déployée en continu** ; une story
  = une branche = une pull request portant la tranche de spec **et** le code ;
  les gates humains sont des revues de pull request (reprendre la table du §5.1) ;
  la règle de dérive du §4.1 sans exception ; le rejet motivé de la branche de
  lot et de `develop`.
- **`## Declared Overrides`** : les quatre, avec leur justification recopiée du
  §8.3, et la phrase interdisant **un cinquième non déclaré**. L'Override 1
  couvre les **étapes 6 à 9**, pas le seul état terminal — écrire pourquoi
  (sinon un design doc daté continue d'être écrit).
- Le bloc `CLAUDE.md` n'est **pas** recopié ici : renvoyer à
  `skills/using-batches/references/claude-md-block.md`.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-declared-overrides.sh`
Expected: PASS — aucune ligne `[FAIL]`, sortie `0`.

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
- Produces: `bash scripts/init.sh <project-dir>` — idempotent. Crée
  l'arborescence, archive les documents superpowers, insère ou met à jour le bloc
  entre `<!-- supercharlouze:begin -->` et `<!-- supercharlouze:end -->`.
  **Refuse d'écrire** si le marqueur d'ouverture est présent sans celui de
  fermeture. N'adopte rien, ne devine aucun module.

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
count() { grep -c "$1" "$2" 2>/dev/null || true; }

echo "test-init"

if [ -f "$INIT" ]; then
    pass "scripts/init.sh exists"
else
    fail "scripts/init.sh exists"
    exit 1
fi

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
if [ "$(count "supercharlouze:begin" "$P1/CLAUDE.md")" = "1" ]; then
    pass "idempotent: block appears exactly once after two runs"
else
    fail "idempotent: block appears exactly once after two runs"
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

# --- Case 4: a stale block is replaced in place, surrounding content survives ---
P3="$TEST_ROOT/stale"
mkdir -p "$P3"
printf '# P\n\nBEFORE\n\n<!-- supercharlouze:begin -->\nOLD\n<!-- supercharlouze:end -->\n\nAFTER\n' > "$P3/CLAUDE.md"
bash "$INIT" "$P3" >/dev/null
if ! grep -q "OLD" "$P3/CLAUDE.md" \
   && grep -q "BEFORE" "$P3/CLAUDE.md" \
   && grep -q "AFTER" "$P3/CLAUDE.md" \
   && [ "$(count "supercharlouze:begin" "$P3/CLAUDE.md")" = "1" ]; then
    pass "stale: block replaced, content before and after preserved"
else
    fail "stale: block replaced, content before and after preserved"
fi

# --- Case 5: unbalanced markers must abort, not eat the file ---
P4="$TEST_ROOT/unbalanced"
mkdir -p "$P4"
printf '# P\n\n<!-- supercharlouze:begin -->\nHALF\n\nUSER CONTENT THAT MUST SURVIVE\n' > "$P4/CLAUDE.md"
BEFORE="$(cat "$P4/CLAUDE.md")"
if bash "$INIT" "$P4" >/dev/null 2>&1; then
    fail "unbalanced: init exits non-zero"
else
    pass "unbalanced: init exits non-zero"
fi
if [ "$(cat "$P4/CLAUDE.md")" = "$BEFORE" ]; then
    pass "unbalanced: CLAUDE.md left untouched"
else
    fail "unbalanced: CLAUDE.md left untouched"
fi

# --- Case 6: superpowers documents are archived ---
P5="$TEST_ROOT/migrate"
mkdir -p "$P5/docs/superpowers/specs" "$P5/docs/superpowers/plans"
touch "$P5/docs/superpowers/specs/2025-01-01-thing-design.md"
touch "$P5/docs/superpowers/plans/2025-01-02-thing.md"
bash "$INIT" "$P5" >/dev/null
if [ -f "$P5/docs/archive/specs/2025-01-01-thing-design.md" ] \
   && [ -f "$P5/docs/archive/plans/2025-01-02-thing.md" ]; then
    pass "migrate: superpowers docs moved under docs/archive"
else
    fail "migrate: superpowers docs moved under docs/archive"
fi

# --- Case 7: the inserted block matches the canonical source byte for byte ---
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
# CLAUDE.md block from its canonical source. Adopts nothing, guesses nothing.
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

HAS_BEGIN=0
HAS_END=0
grep -q "supercharlouze:begin" "$CLAUDE_MD" && HAS_BEGIN=1
grep -q "supercharlouze:end" "$CLAUDE_MD" && HAS_END=1

if [ "$HAS_BEGIN" -ne "$HAS_END" ]; then
    echo "error: $CLAUDE_MD has an unbalanced supercharlouze marker pair." >&2
    echo "Refusing to rewrite it — repair the markers by hand, then run again." >&2
    exit 1
fi

if [ "$HAS_BEGIN" -eq 1 ]; then
    # Replace the block in place, preserving everything around it.
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
find "$PROJECT/docs/specs" -maxdepth 1 -name '*.md' ! -name '*.gaps.md' -print 2>/dev/null |
    while IFS= read -r spec; do
        echo "  - $(basename "$spec" .md)"
    done

echo "archived documents not listed in any spec Sources section:"
find "$PROJECT/docs/archive" -type f -name '*.md' -print 2>/dev/null |
    while IFS= read -r doc; do
        rel="${doc#"$PROJECT"/}"
        if ! grep -rqF "$rel" "$PROJECT/docs/specs" 2>/dev/null; then
            echo "  - $rel"
        fi
    done
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-init.sh`
Expected: PASS — aucune ligne `[FAIL]`, sortie `0`.

- [ ] **Step 5: Commit**

```bash
git add scripts/init.sh tests/test-init.sh
git commit -m "feat: idempotent init script, refuses to rewrite unbalanced markers"
```

---

### Task 5: The /supercharlouze:init command

**Files:**
- Create: `commands/init.md`
- Test: `tests/test-command.sh`

**Interfaces:**
- Consumes: `scripts/init.sh` (Task 4).
- Produces: la commande `/supercharlouze:init`, au format du plugin
  `devcontainer` : frontmatter `description` + `argument-hint`, corps qui délègue.

- [ ] **Step 1: Write the failing test**

Créer `tests/test-command.sh` :

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

if [ -f "$CMD" ]; then
    pass "commands/init.md exists"
else
    fail "commands/init.md exists"
    exit 1
fi

if [ "$(head -1 "$CMD")" = "---" ]; then
    pass "command frontmatter opens on line 1"
else
    fail "command frontmatter opens on line 1"
fi

front="$(awk 'NR>1 && /^---$/{exit} NR>1{print}' "$CMD")"
body="$(awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$CMD")"

for field in description argument-hint; do
    if printf '%s\n' "$front" | grep -q "^$field:"; then
        pass "command has $field"
    else
        fail "command has $field"
    fi
done

BODY_FLAT="$(printf '%s\n' "$body" | tr '\n' ' ')"
has() { case "$2" in *"$1"*) return 0 ;; *) return 1 ;; esac }

for needle in "scripts/init.sh" "supercharlouze:using-batches" "chore/supercharlouze-init"; do
    if has "$needle" "$BODY_FLAT"; then
        pass "command body mentions $needle"
    else
        fail "command body mentions $needle"
    fi
done

# Spec 9: init adopts nothing and proposes no module breakdown.
if has "Do not adopt" "$BODY_FLAT" && has "module breakdown" "$BODY_FLAT"; then
    pass "command forbids adopting and proposing a breakdown"
else
    fail "command forbids adopting and proposing a breakdown"
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

Set up this project for supercharlouze. Target: $ARGUMENTS — if empty, the
current directory.

Everything in this system ships through a pull request, and this command is no
exception (spec section 9).

1. From the main checkout, on an up-to-date integration branch, create the
   branch `chore/supercharlouze-init`.
2. Run `bash ${CLAUDE_PLUGIN_ROOT}/scripts/init.sh <target>`. It is idempotent:
   it creates `docs/specs/`, `docs/batches/` and `docs/archive/`, moves any
   `docs/superpowers/specs` and `docs/superpowers/plans` under `docs/archive/`,
   and installs or refreshes the CLAUDE.md block. Running it twice changes
   nothing the second time. If it refuses because the CLAUDE.md markers are
   unbalanced, stop and tell your human partner — do not repair the file
   yourself.
3. Commit, push, and open the pull request.
4. Report the script's output as a state of play: which modules are adopted, and
   which archived documents no spec claims as a source.

**Do not adopt anything.** Adoption is a deliberate, per-module decision made by
your human partner, and it runs through `supercharlouze:adopting-a-module`.

**Do not propose a module breakdown.** Module boundaries belong to your human
partner, and a suggestion reads as a decision.

Then read `supercharlouze:using-batches` so the rest of the session follows the
overridden workflow.
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-command.sh`
Expected: PASS — aucune ligne `[FAIL]`, sortie `0`.

- [ ] **Step 5: Commit**

```bash
git add commands tests/test-command.sh
git commit -m "feat: /supercharlouze:init command, delivered as a pull request"
```

---

### Task 6: adopting-a-module

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md`
- Test: `tests/test-skill-content.sh` *(créé ici, étendu par les Tasks 7-9)*

**Interfaces:**
- Produces: `require()` — **ne grepe que le corps du skill**, après le second
  `---`. Greper le fichier entier laisserait la `description` du frontmatter
  satisfaire les assertions, et une coquille vide passerait tous les contrôles.

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

# Body only: everything after the closing --- of the frontmatter, flattened so a
# phrase matches regardless of wrapping.
body_flat() {
    awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$1" | tr '\n' ' '
}

require() {
    local skill="$1" label="$2" needle="$3"
    local f="$REPO_ROOT/skills/$skill/SKILL.md"
    local b=""
    [ -f "$f" ] && b="$(body_flat "$f")"
    case "$b" in
        *"$needle"*) pass "$skill: $label" ;;
        *)           fail "$skill: $label" ;;
    esac
}

# Every document-producing skill states the language rule (Global Constraints, spec 10).
for s in adopting-a-module writing-a-batch writing-a-user-story closing-a-batch; do
    require "$s" "states the language rule" "English skeleton"
done

# --- adopting-a-module (spec 6) ---
require adopting-a-module "validated documents are normative"    "validated documents are normative"
require adopting-a-module "never rebuilds a spec from code"      "never reconstructed from the code"
require adopting-a-module "the human delimits the module"        "delimit"
require adopting-a-module "records Sources in the spec"          "Sources"
require adopting-a-module "produces the gaps register"           "gaps register"
require adopting-a-module "the register declares its coverage"   "declares its own coverage"
require adopting-a-module "the PR review is the gate"            "review of the adoption pull request"
require adopting-a-module "handles the no-document fallback"     "no validated document"
require adopting-a-module "branch naming convention"             "adopt/"

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — les quatre assertions `states the language rule` et les neuf
assertions `adopting-a-module` sortent en `[FAIL]`, sortie `1`.

- [ ] **Step 3: Write minimal implementation**

Écrire le corps de `skills/adopting-a-module/SKILL.md` d'après le **§6**, avec
ces sections :

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
## Language
## Red Flags
```

Le contenu doit énoncer : l'ordre d'autorité — la phrase **« validated documents
are normative »** telle quelle, le code comblant les silences, l'humain arbitre ;
que la spec est **« never reconstructed from the code »**, avec sa raison ; la
délimitation réservée à l'humain ; l'inventaire présenté avant toute écriture et
enregistré dans la section `Sources` de la spec ; le gaps register avec ses
sections `Violations` / `Gaps` et le fait qu'il **« declares its own coverage »** ;
la branche `adopt/<module>` ; et que la **« review of the adoption pull request »**
*est* la revue humaine obligatoire.

`## Language` énonce la règle du §10 en une phrase contenant **« English
skeleton »** : ossature anglaise — titres, champs, en-têtes de tableaux —, prose
dans la langue du projet.

`## Red Flags`, au minimum :

| Thought | Reality |
|---------|---------|
| "The code is the real truth, I'll spec what it does" | That canonizes drift and destroys the premise of corrective batches. |
| "I can infer the module boundaries from the directory layout" | Boundaries belong to your human partner. A wrong one contaminates everything downstream. |
| "This old design doc is close enough to validated" | Ask. The spec's quality is capped by the inventory. |
| "The audit found nothing, so the register is empty" | An empty register must say whether nothing was found or nothing was examined. |

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: aucune ligne `[FAIL]` pour `adopting-a-module` ni pour sa règle de
langue. Les trois autres skills restent en `[FAIL]` sur la règle de langue
jusqu'aux Tasks 7 à 9 — le fichier sort donc encore `1`, c'est attendu.

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

- [ ] **Step 1: Write the failing test**

Ajouter à `tests/test-skill-content.sh`, avant la ligne `exit` :

```bash
# --- writing-a-batch (spec 4, 4.3, 5.2, 8.3) ---
require writing-a-batch "adopted spec is a blocking precondition" "blocking precondition"
require writing-a-batch "NN accounts for open pull requests"      "open pull request"
require writing-a-batch "batch document carries no mutable state" "no mutable state"
require writing-a-batch "no story list in the batch document"     "list of stories"
require writing-a-batch "writes no spec at opening"               "no writing into the specs"
require writing-a-batch "PR review is the human gate"             "review of the batch pull request"
require writing-a-batch "corrective batch reserves entries"       "reserved by batch"
require writing-a-batch "declares the Feature flag field"         "Feature flag"
require writing-a-batch "flag field is never left empty"          "never left empty"
require writing-a-batch "flag is per batch and module"            "per (batch, module)"
require writing-a-batch "extended scope names its lifting condition" "lifting condition"
require writing-a-batch "surfaces live flags per module"          "every gating sentence in the specs of the modules"
require writing-a-batch "amendment pull request exists"           "amendment pull request"
require writing-a-batch "carries the requalification procedure"   "requalification"
require writing-a-batch "branch naming convention"                "batch/NN"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — les quinze assertions `writing-a-batch` sortent en `[FAIL]`.

- [ ] **Step 3: Write minimal implementation**

Écrire le corps de `skills/writing-a-batch/SKILL.md` d'après les **§4, §4.3, §5.2
et §8.3**, avec ces sections :

```markdown
## Overview
## Preconditions
## Allocating NN
## The Batch Document
## The Feature Flag Field
## Surfacing Live Flags
## Opening the Pull Request
## Amending a Batch
## Requalifying a Corrective Batch
## Language
## Red Flags
```

Points obligatoires :

- **Preconditions** : chaque module touché a une spec adoptée, sinon l'adoption
  est un **« blocking precondition »** (§5.2) ; checkout principal, branche
  d'intégration rafraîchie (§5.1).
- **Allocating NN** : plus petit entier libre sur `main` **et** parmi les
  **« open pull request »**, avec la raison — un artefact n'atteint `main` qu'à
  la fusion. Branche `batch/NN-<slug>`.
- **The Batch Document** : `README.md`, front matter `status: open | closed`,
  sections `Scope`, `Spec delta`, `Feature flag`. Il porte **« no mutable
  state »** : ni **« list of stories »** ni cases à cocher, avec la raison
  (contention de fusion, et `gh pr list` dit mieux). **« no writing into the
  specs »** à l'ouverture.
- **The Feature Flag Field** : obligatoire, **« never left empty »**. Un flag
  **« per (batch, module) »**. Le critère d'exemption sous forme de question, et
  ses trois familles de réponse « non ». Une portée dépassant le lot doit nommer
  sa **« lifting condition »**. Reprendre les trois exemples de champ du §4.3.
- **Surfacing Live Flags** : lister **« every gating sentence in the specs of the
  modules »** que le lot touche — pas seulement les sections visées — avec sa
  condition, pour que l'humain tranche au gate si ce lot lève.
- **Opening the Pull Request** : la **« review of the batch pull request »** est
  le gate.
- **Amending a Batch** : une **« amendment pull request »** révisée comme les
  autres, pour le lot exempté qui découvre qu'il fallait un flag, ou dont on
  réduit le périmètre (§4.3).
- **Requalifying a Corrective Batch** : la procédure du §8.3, contenant le mot
  **« requalification »**.
- **Language** : la phrase **« English skeleton »** (voir Task 6).

`## Red Flags`, au minimum :

| Thought | Reality |
|---------|---------|
| "No flag needed, this batch is small" | Small is not the criterion. Would one story, merged alone, leave a user facing something incomplete? |
| "I'll take the next free number from the directory" | A batch in an open pull request has not reached main yet. Ask gh too. |
| "I'll add the story list to the batch document, it's clearer" | Every story would then conflict on that file, for information the directory already holds. |
| "There's a flag on this module but my batch doesn't touch that section" | Surface it anyway. That is how an extended-scope flag gets lifted instead of forgotten. |

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: aucune ligne `[FAIL]` pour `writing-a-batch`.

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

- [ ] **Step 1: Write the failing test**

Ajouter à `tests/test-skill-content.sh`, avant la ligne `exit` :

```bash
# --- writing-a-user-story (spec 3, 4.4, 5.1, 5.3) ---
require writing-a-user-story "checks it is in the main checkout"  "main checkout"
require writing-a-user-story "refreshes the integration branch"   "up to date with the remote"
require writing-a-user-story "concurrency via declared Sections"  "Sections:"
require writing-a-user-story "git conflict is only a partial net" "partial safety net"
require writing-a-user-story "transcription is the first commit"  "first commit on the branch"
require writing-a-user-story "freeze travels in Global Constraints" "Global Constraints"
require writing-a-user-story "freeze ends when the PR opens"      "freeze is lifted when the pull request opens"
require writing-a-user-story "corrective story strikes an entry"  "corrective"
require writing-a-user-story "hands off to writing-plans"         "superpowers:writing-plans"
require writing-a-user-story "requires SDD"                       "superpowers:subagent-driven-development"
require writing-a-user-story "constrains finishing to the PR"     "Push and create a Pull Request"
require writing-a-user-story "records rulings before the merge"   "Rulings log"
require writing-a-user-story "records observed drift"             "Observed drift"
require writing-a-user-story "answers review feedback"            "review feedback"
require writing-a-user-story "story branch naming convention"     "story/NN"
require writing-a-user-story "slice states the flag and default"  "states the flag and its default"
require writing-a-user-story "one lifting story per module"       "one lifting story per guarded module"
require writing-a-user-story "teardown story exists"              "teardown story"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — les dix-huit assertions `writing-a-user-story` sortent en `[FAIL]`.

- [ ] **Step 3: Write minimal implementation**

Écrire le corps de `skills/writing-a-user-story/SKILL.md` d'après les **§3, §4.4,
§5.1 et §5.3**, avec ces sections :

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
## Lifting and Teardown Stories
## Language
## Red Flags
```

Points obligatoires :

- **Preconditions** : être dans le **« main checkout »** (`GIT_DIR == GIT_COMMON`),
  sur la branche d'intégration **« up to date with the remote »**. Donner la
  raison : `finishing-a-development-branch` préserve le worktree sur le chemin
  PR, et `using-git-worktrees` sauterait alors la création, posant le code de
  cette story sur la branche de la précédente.
- **Detect Concurrency** : lire le champ **`Sections:`** des documents de story
  des pull requests ouvertes sur la même spec, s'arrêter si l'intersection n'est
  pas vide. Dire que le conflit de fusion git n'est qu'un **« partial safety
  net »** — il conflicte sur des lignes, pas sur des sections.
- **Commit the Spec Slice First** : la tranche est le **« first commit on the
  branch »**, avant le plan, avec la raison du §4.4 — rendre la norme antérieure
  et opposable au code. Si le lot déclare un flag, la tranche **« states the flag
  and its default »**, et sa condition de levée si la portée est étendue. Cas
  **« corrective »** : delta vide, le premier commit barre l'entrée du gaps
  register.
- **Write the Plan** : `superpowers:writing-plans`, avec les contraintes du lot
  et le gel du fichier de spec dans **`Global Constraints`**. Le gel a une borne :
  **« freeze is lifted when the pull request opens »**.
- **Execute** : `superpowers:subagent-driven-development` (Override 3), puis
  `finishing-a-development-branch` contraint à **« Push and create a Pull
  Request »** (Override 4), avec sa justification exacte — le merge local ne
  pousse jamais, il fusionne en local puis supprime worktree et branche.
- **Record Before the Merge** : `Rulings log` depuis le message final de SDD,
  `Observed drift` pour les dérives hors périmètre ; dire que ces informations
  sont périssables.
- **Answer the Review** : **« review feedback »** appliqué sur la branche, gel
  levé.
- **Lifting and Teardown Stories** : **« one lifting story per guarded module »** ;
  elle appartient au lot qui satisfait la condition de levée, tranché au gate
  d'ouverture ; et la **« teardown story »** qui retire du code gardé quand un lot
  est renoncé (§5.4).
- **Language** : la phrase **« English skeleton »**.
- Branche **`story/NN-us-N-<slug>`**.

`## Red Flags`, au minimum :

| Thought | Reality |
|---------|---------|
| "I'll write the whole batch delta now, it's more efficient" | Reviewers would flag the next stories' behaviour as missing. One slice per story. |
| "The spec is wrong, I'll fix it while I'm here" | Only your human partner corrects a spec. Stop and say so. |
| "No merge conflict, so no one else is on this section" | Git conflicts on lines, not sections. Check the open pull requests. |
| "I'm already in a worktree, that's fine" | Then this story's code lands on the previous story's branch. Return to the main checkout. |
| "Merging locally is quicker" | It never pushes. It merges into local main, deletes the worktree and the branch, and takes the unrecorded rulings with it. |

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: aucune ligne `[FAIL]` pour `writing-a-user-story`.

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

- [ ] **Step 1: Write the failing test**

Ajouter à `tests/test-skill-content.sh`, avant la ligne `exit` :

```bash
# --- closing-a-batch (spec 4.1, 4.2, 5.4) ---
require closing-a-batch "one changelog line per batch"           "one line per batch"
require closing-a-batch "consolidates Observed drift"            "Observed drift"
require closing-a-batch "releases unconsumed reservations"       "unconsumed reservations"
require closing-a-batch "records undelivered intentions"         "announced but never delivered"
require closing-a-batch "refuses to close on an undeclared flag" "no declared scope"
require closing-a-batch "offers three exits"                     "three exits"
require closing-a-batch "sets status closed"                     "status: closed"
require closing-a-batch "closing PR is reviewed"                 "review of the closing pull request"
require closing-a-batch "branch naming convention"               "batch/NN"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — les neuf assertions `closing-a-batch` sortent en `[FAIL]`.

- [ ] **Step 3: Write minimal implementation**

Écrire le corps de `skills/closing-a-batch/SKILL.md` d'après le **§5.4**, avec
ces sections :

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
## Language
## Red Flags
```

Points obligatoires : branche `batch/NN-<slug>-close` ; **« one line per batch »**
et par spec touchée, avec la raison (le faire écrire par chaque story ferait
conflicter toutes les stories d'un module en vol) ; consolidation des sections
**`Observed drift`** des stories dans le gaps register ; libération des
**« unconsumed reservations »**, avec la raison — la réservation vit sur `main`,
fermer la PR d'une story ne l'emporte pas ; constat des intentions
**« announced but never delivered »**, inscrites au registre comme *gaps*, avec la
raison (sinon l'abandon d'une story est invisible) ; refus de clore sur un flag
**« no declared scope »**, et les **« three exits »** du §5.4 — story de levée,
amendement déclarant une portée étendue, ou story de démontage ; `status: closed` ;
la **« review of the closing pull request »** comme les autres ; et la phrase
**« English skeleton »**.

`## Red Flags`, au minimum :

| Thought | Reality |
|---------|---------|
| "A story was abandoned, nothing to do — closing its PR undid it all" | Not on main: its reservation and the batch's announced intention are still there. |
| "The changelog is already up to date, each story added its line" | Stories do not write the changelog. One line per batch, here. |
| "Observed drift is out of scope for this batch" | That is exactly why it goes to the register instead of being forgotten. |
| "A flag is still live, so I cannot close — dead end" | Three exits: lift it, declare an extended scope by amendment, or tear the guarded code down. |

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-skill-content.sh`
Expected: PASS — aucune ligne `[FAIL]`, sortie `0`. Les quatre règles de langue
passent maintenant que les quatre skills producteurs sont écrits.

- [ ] **Step 5: Commit**

```bash
git add skills/closing-a-batch tests/test-skill-content.sh
git commit -m "feat: closing-a-batch skill"
```

---

### Task 10: Bounded path, cross-references and README

**Files:**
- Modify: `skills/using-batches/SKILL.md` (section `What Is Kept, What Is Rerouted`)
- Create: `tests/test-cross-references.sh`
- Modify: `README.md`

**Interfaces:**
- Consumes: tout ce que les Tasks 1 à 9 produisent.
- Produces: le dernier contrôle du §11 — les chemins et skills cités existent.

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
#    begin/end are the CLAUDE.md block markers, not skill references.
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
done < <(grep -rhoE 'supercharlouze:[a-z-]+' "$REPO_ROOT/skills" "$REPO_ROOT/commands" 2>/dev/null \
         | sed 's/^supercharlouze://' | grep -vxE 'begin|end' | sort -u || true)

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
done < <(grep -rhoE '`(skills|scripts|commands|tests|\.claude-plugin)/[A-Za-z0-9._/-]+`' \
         "$REPO_ROOT/skills" "$REPO_ROOT/commands" 2>/dev/null | tr -d '`' | sort -u || true)

if [ "$BAD" = "0" ]; then
    pass "every repo-relative path referenced in skills exists"
else
    fail "every repo-relative path referenced in skills exists ($BAD missing)"
fi

# 3. The canonical block lives in exactly one file (spec 8.1).
COPIES="$(grep -rl "supercharlouze:begin" "$REPO_ROOT/skills" "$REPO_ROOT/commands" 2>/dev/null | wc -l | tr -d ' ')"
if [ "$COPIES" = "1" ]; then
    pass "the CLAUDE.md block exists in exactly one file"
else
    fail "the CLAUDE.md block exists in exactly one file (found $COPIES)"
fi

# 4. The bounded path is spelled out (spec 8.2) — it has no skill of its own.
UB="$(awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$REPO_ROOT/skills/using-batches/SKILL.md" | tr '\n' ' ')"
has() { case "$2" in *"$1"*) return 0 ;; *) return 1 ;; esac }
for needle in "out-of-batch" "never leaves the spec silent" "fix/" "no feature flag"; do
    if has "$needle" "$UB"; then
        pass "bounded path states: $needle"
    else
        fail "bounded path states: $needle"
    fi
done

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-cross-references.sh`
Expected: FAIL — les quatre assertions `bounded path states` sortent en `[FAIL]`,
la section `What Is Kept, What Is Rerouted` n'ayant pas encore ce contenu.

- [ ] **Step 3: Write minimal implementation**

Compléter la section `## What Is Kept, What Is Rerouted` de
`skills/using-batches/SKILL.md` d'après le **§8.2**. Elle doit énoncer :

- **Spike** — inchangé, aucun artefact.
- **Bounded** — sa pull request **« never leaves the spec silent »**, qu'elle
  altère un comportement décrit ou en ajoute un que nulle spec ne décrit, avec
  une ligne de changelog **« out-of-batch »** ; elle subit la même détection de
  concurrence que les stories et déclare ses sections dans le corps de sa pull
  request ; elle porte **« no feature flag »**, étant complète dans sa propre
  pull request ; branche **`fix/<slug>`**.
- **Architectural** — étapes 6 à 9 remplacées par
  `supercharlouze:writing-a-batch`, étapes 1 à 5 conservées intactes.

Corriger toute référence cassée que le test signale. Puis remplacer la section
`## Status` du `README.md` par le contenu ci-dessous. **Attention** : il contient
des blocs de code, donc il est donné ici entre clôtures à quatre backticks ;
n'en recopiez que l'intérieur.

````markdown
## Status

v0.1.0 — the five skills, the `/supercharlouze:init` command and the structural
test suite are in place.

## Install

```bash
/plugin marketplace add charlouze/superpowers-by-charlouze
/plugin install supercharlouze@supercharlouze
```

Then, in each project you want to move over, run `/supercharlouze:init`. It opens
a pull request; nothing is adopted until you decide, module by module.

## Skills

| Skill | Use it when |
|---|---|
| `supercharlouze:using-batches` | Entry point — routing, authority rules, declared overrides |
| `supercharlouze:adopting-a-module` | A module has no living spec yet |
| `supercharlouze:writing-a-batch` | Opening, amending or requalifying a batch |
| `supercharlouze:writing-a-user-story` | Writing the next story of an open batch |
| `supercharlouze:closing-a-batch` | Every story is merged or abandoned |

## Tests

```bash
bash tests/run-all.sh
```

Structural checks only — see section 11 of the design document for what is
deliberately not tested.
````

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/run-all.sh`
Expected: PASS — aucune ligne `[FAIL]` dans aucun fichier, puis
`all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills/using-batches tests/test-cross-references.sh README.md
git commit -m "feat: bounded path, cross-reference integrity, README for v0.1.0"
```

---

## Notes for the executor

**Ce plan construit le plugin avec superpowers nu** — phase 1 du §12 de la spec.
Ne pas essayer d'utiliser `supercharlouze:writing-a-batch` pour construire
`supercharlouze` : il n'existe pas encore. La phase 2, qui lance
`/supercharlouze:init` sur ce dépôt même, vient après cette livraison et n'est
pas dans ce plan.

**Le contenu des skills se lit dans la spec.** Les Tasks 3 et 6 à 10 nomment les
sections de la spec dont chaque skill est la traduction opérationnelle, et les
tests fixent les phrases qui doivent y figurer. La spec voyage avec ce plan —
c'est le champ `Spec:` de l'en-tête — et **elle fait autorité en cas de désaccord
avec ce plan**.

**Les assertions de `test-skill-content.sh` cherchent des phrases exactes.** Ce
n'est pas de la rigidité gratuite : une assertion trop lâche passe sur un
document vide et ne teste rien. Si une phrase imposée sonne mal dans le contexte
que vous écrivez, changez la phrase **et** l'assertion dans le même commit, et
dites-le dans le message de commit.

**Tout est en anglais dans le plugin livré**, y compris les tables `Red Flags` et
les messages de `scripts/init.sh` (§10). Les seuls documents français de ce dépôt
sont la spec et ce plan, qui sont de la prose de spécification.
