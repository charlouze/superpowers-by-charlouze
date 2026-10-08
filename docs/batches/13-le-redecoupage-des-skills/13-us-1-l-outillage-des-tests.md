# L'outillage des tests Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La suite de tests lit la liste des skills et leur type dans un fichier de données, et porte les gardes génériques que les stories suivantes du lot complètent sans retoucher l'outillage.

**Architecture:** `tests/skills.txt` déclare chaque skill et son type. `tests/lib.sh`, que chaque fichier de test charge, lit cette liste et porte l'outil de lecture et les gardes de contenu, qui lisent aussi les `references/` d'une skill.

**Tech Stack:** bash, awk, sed, grep.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes

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

### The stop condition of a technical story

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

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

- Aucune tâche ne modifie un fichier de `skills/`. Une garde qui échoue sur l'état actuel d'une skill est rapportée, pas contournée.
- Toute commande `git` qui écrit un commit passe par `bash ~/.config/github-app/as-agent.sh git …`, y compris `commit --amend` et `rebase`. Sans ce préfixe, le commit porte la mauvaise identité.
- Un message de commit se termine par la ligne `Co-Authored-By: Charlouze <me@charlouze.com>` et par aucune autre ligne d'attribution.
- Le sujet d'un commit est en français, à la forme Conventional Commits, et ne porte qu'un sujet : `test:` pour un commit qui ne touche que `tests/`, `docs:` pour `CONTRIBUTING.md`.
- Aucune tâche ne pousse la branche.
- Un fichier écrit depuis ce plan l'est avec l'outil d'écriture de fichiers, pas par un heredoc du shell, qui mange les barres obliques inverses.
- Les scripts tournent sous bash 3.2 : pas de tableau associatif, pas de `mapfile`.
- La suite entière se lance par `bash tests/run-all.sh` et prend plus de deux minutes : une étape lance le fichier de test qu'elle nomme, et la suite entière seulement là où le plan le dit, avec un délai d'au moins cinq minutes.

## Review Focus

- `tests/skills.txt` extrait avec des fins de ligne CRLF : la liste se lit de la même façon. Tenu par `tests/test-lib.sh` (tâche 1).
- Une ligne mal formée de `tests/skills.txt`, que les lecteurs sauteraient en silence : la suite échoue. Tenu par `invalid_declarations` (tâche 1).
- Une skill sans répertoire `references/` : les gardes de contenu lisent son corps seul, sans erreur. Tenu par l'assertion `require fails on a phrase the skill does not state`, qui lit `beta` (tâche 3).
- Un fichier de `references/` qui porte des lignes `---` : il est lu en entier. Tenu par `tests/test-lib.sh` (tâche 3).
- Une citation de ref suivie d'un point final : le point n'entre pas dans le nom du fichier. Tenu par l'assertion `a reference citing the reference of another skill is reported` (tâche 5).

---

### Task 1: La liste déclarée des skills

**Files:**
- Create: `tests/skills.txt`
- Create: `tests/lib.sh`
- Create: `tests/test-lib.sh`
- Modify: `tests/test-suite-integrity.sh`
- Modify: `tests/test-skill-frontmatter.sh`
- Modify: `tests/test-cross-references.sh`

**Interfaces:**
- Consumes: rien.
- Produces: `tests/skills.txt`, une ligne `<nom> <type>` par skill, `<type>` valant `entry`, `internal` ou `foundation`. `tests/lib.sh`, chargé par `source "$(dirname "$0")/lib.sh"`, qui définit `REPO_ROOT`, `SKILLS_DIR`, `SKILLS_FILE`, `FAILURES`, `pass <label>`, `fail <label>`, `declared_skills [type]` (un nom par ligne), `skill_type <nom>`, `invalid_declarations` (une ligne invalide par ligne), `skill_front <nom>` (le front matter sans ses clôtures). `tests/test-lib.sh`, qui définit `is <label> <attendu> <obtenu>`, `has <label> <aiguille> <texte>`, `write_skill <nom> <front matter> <corps>` et `build_fixture`, et se termine par `exit $((FAILURES > 0))`.

- [ ] **Step 1: Write the failing test**

Crée `tests/test-lib.sh` avec ce contenu exact :

```bash
#!/usr/bin/env bash
set -euo pipefail

# The helpers of lib.sh hold every other check file up, so they are checked on
# their own, against skills built for the purpose: a helper that reads nothing
# passes every guard written on top of it.
FX="$(mktemp -d)"
trap 'rm -rf "$FX"' EXIT

SKILLS_DIR="$FX/skills"
SKILLS_FILE="$FX/skills.txt"
source "$(dirname "$0")/lib.sh"

echo "test-lib"

is() {
    local label="$1" expected="$2" actual="$3"
    if [ "$actual" = "$expected" ]; then
        pass "$label"
    else
        fail "$label (got: $actual)"
    fi
}

has() {
    local label="$1" needle="$2" text="$3"
    case "$text" in
        *"$needle"*) pass "$label" ;;
        *)           fail "$label (got: $text)" ;;
    esac
}

write_skill() {
    local name="$1" front="$2" body="$3"
    mkdir -p "$SKILLS_DIR/$name"
    printf -- '---\nname: %s\n%s\n---\n\n%s\n' "$name" "$front" "$body" > "$SKILLS_DIR/$name/SKILL.md"
}

# Each section starts from the same skills, whatever the section before it
# rewrote.
build_fixture() {
    rm -rf "$SKILLS_DIR"
    printf '# a comment\n\nalpha entry\nbeta internal\ngamma foundation\n' > "$SKILLS_FILE"
    write_skill alpha "description: Use when alpha is needed" \
        "$(printf 'Alpha states its rule.\n\n> a quoted norm that wraps\n> over two lines')"
    write_skill beta "$(printf 'description: Use only when a skill tells you to invoke beta, never on a request\nuser-invocable: false')" \
        "Beta does one thing."
    write_skill gamma "description: Use when a skill or a plan asks for gamma" \
        "Gamma holds the retired wording."
    mkdir -p "$SKILLS_DIR/alpha/references"
    printf 'First line of the reference.\n\n---\n\nA template field kept\n  in the reference.\n' \
        > "$SKILLS_DIR/alpha/references/note.md"
}

# --- the declared skills ---
build_fixture
is "the declared skills are read without comments and blank lines" \
    "alpha beta gamma" "$(declared_skills | tr '\n' ' ' | sed 's/ $//')"
is "the declared skills are filtered by type" \
    "beta" "$(declared_skills internal | tr '\n' ' ' | sed 's/ $//')"
is "a skill's type is read from its declaration" "foundation" "$(skill_type gamma)"
is "a well-formed declaration has no invalid line" "" "$(invalid_declarations)"

GOOD_FILE="$SKILLS_FILE"
SKILLS_FILE="$FX/bad.txt"
printf 'alpha entry\ndelta other\nlonely\nalpha internal\n' > "$SKILLS_FILE"
is "an unknown type, a missing type and a name declared twice are invalid" \
    "delta other|lonely|alpha internal|" "$(invalid_declarations | tr '\n' '|')"
SKILLS_FILE="$FX/crlf.txt"
printf 'alpha entry\r\nbeta internal\r\n' > "$SKILLS_FILE"
is "a declaration checked out with CRLF line endings reads the same" \
    "beta" "$(declared_skills internal | tr '\n' ' ' | sed 's/ $//')"
SKILLS_FILE="$GOOD_FILE"

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-lib.sh`
Expected: FAIL, `lib.sh: No such file or directory`.

- [ ] **Step 3: Write the declaration and the library**

Crée `tests/skills.txt` avec ce contenu exact :

```
# One skill per line: its name, then its type.
# entry: triggered by a situation.
# internal: invoked only by another skill.
# foundation: invoked by a skill or by a plan.
using-batches entry
adopting-a-module entry
writing-a-batch entry
writing-a-user-story entry
closing-a-batch entry
rereading-a-spec internal
rereading-a-technical-design internal
recording-a-decision internal
```

Crée `tests/lib.sh` avec ce contenu exact :

```bash
# Sourced by the check files, never run: what they share.
# A caller may set SKILLS_DIR and SKILLS_FILE before sourcing, which is how
# test-lib.sh points these helpers at a fixture.

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$LIB_DIR/.." && pwd)"
SKILLS_DIR="${SKILLS_DIR:-$REPO_ROOT/skills}"
SKILLS_FILE="${SKILLS_FILE:-$LIB_DIR/skills.txt}"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

# --- the declared skills ---

# The names of the declared skills, one per line: all of them, or those of the
# type given.
declared_skills() {
    tr -d '\r' < "$SKILLS_FILE" \
        | awk -v type="${1:-}" '/^#/ || NF == 0 { next } type == "" || $2 == type { print $1 }'
}

# The type a skill is declared with.
skill_type() {
    tr -d '\r' < "$SKILLS_FILE" | awk -v name="$1" '!/^#/ && $1 == name { print $2; exit }'
}

# The lines of the declaration that declare nothing usable: a line that is not
# a name and a type, a type that is none of the three, a name declared twice.
invalid_declarations() {
    tr -d '\r' < "$SKILLS_FILE" | awk '
        /^#/ || NF == 0 { next }
        NF != 2 || $2 !~ /^(entry|internal|foundation)$/ || seen[$1]++ { print }'
}

# The front matter of a declared skill, without its fences.
skill_front() {
    awk 'NR>1 && /^---$/{exit} NR>1{print}' "$SKILLS_DIR/$1/SKILL.md" 2>/dev/null || true
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-lib.sh`
Expected: 6 lignes `[PASS]`, aucune `[FAIL]`.

- [ ] **Step 5: Let the integrity check know the library**

Dans `tests/test-suite-integrity.sh`, sous la ligne `    [ "$b" = "run-all.sh" ] && continue`, ajoute :

```bash
    [ "$b" = "lib.sh" ] && continue
```

Et remplace le commentaire qui précède la boucle, de `# run-all.sh collects` à `# like part of the suite.`, par :

```bash
# run-all.sh collects `tests/test-*.sh` by glob. A check file under any other
# name is never executed, and nothing reports it — it simply sits there looking
# like part of the suite. lib.sh is no check file: the check files source it.
```

- [ ] **Step 6: Make test-skill-frontmatter.sh read the declaration**

Dans `tests/test-skill-frontmatter.sh` :

1. Remplace les lignes qui vont de `SCRIPT_DIR=` à la définition de `fail()` incluse par la seule ligne `source "$(dirname "$0")/lib.sh"`.
2. Remplace la ligne `EXPECTED_SKILLS="…"` par :

```bash
# The declaration every check file reads is itself well formed: a line a helper
# skips declares a skill no guard walks.
INVALID="$(invalid_declarations | tr '\n' '|')"
if [ -z "$INVALID" ]; then
    pass "every declaration names a skill and one of the three types"
else
    fail "every declaration names a skill and one of the three types (invalid: $INVALID)"
fi
```

3. Remplace `for skill in $EXPECTED_SKILLS; do` par `for skill in $(declared_skills); do`, et dans cette boucle `f="$REPO_ROOT/skills/$skill/SKILL.md"` par `f="$SKILLS_DIR/$skill/SKILL.md"` et `front="$(awk … "$f")"` par `front="$(skill_front "$skill")"`.
4. Remplace `for r in rereading-a-spec rereading-a-technical-design recording-a-decision; do` par `for r in $(declared_skills internal); do`, et dans cette boucle la ligne `RFRONT="$(awk …)"` par `RFRONT="$(skill_front "$r")"`.
5. Remplace le bloc final `if [ -d "$REPO_ROOT/skills" ]; then … fi` par :

```bash
actual="$(ls "$SKILLS_DIR" | sort | tr '\n' ' ')"
expected="$(declared_skills | sort | tr '\n' ' ')"
if [ "$actual" = "$expected" ]; then
    pass "skills directory holds exactly the declared skills"
else
    fail "skills directory holds exactly the declared skills (got: $actual)"
fi
```

Run: `bash tests/test-skill-frontmatter.sh`
Expected: 43 lignes `[PASS]`, aucune `[FAIL]`.

- [ ] **Step 7: Check the directory guard bites**

Run: `mkdir skills/undeclared && bash tests/test-skill-frontmatter.sh | grep FAIL; rmdir skills/undeclared`
Expected: `[FAIL] skills directory holds exactly the declared skills (got: … undeclared …)`.

- [ ] **Step 8: Make test-cross-references.sh read the declaration**

Dans `tests/test-cross-references.sh` :

1. Remplace les lignes qui vont de `SCRIPT_DIR=` à la définition de `fail()` incluse par la seule ligne `source "$(dirname "$0")/lib.sh"`.
2. Supprime la ligne `KNOWN_SKILLS="…"`.
3. Remplace `for s in $KNOWN_SKILLS; do` par `for s in $(declared_skills); do`.

Run: `bash tests/test-cross-references.sh`
Expected: 35 lignes `[PASS]`, aucune `[FAIL]`.

Run: `grep -rn 'EXPECTED_SKILLS\|KNOWN_SKILLS' tests/`
Expected: aucune ligne.

- [ ] **Step 9: Run the whole suite**

Run: `bash tests/run-all.sh | tail -3`
Expected: `all tests passed`.

- [ ] **Step 10: Commit**

```bash
git add tests/skills.txt tests/lib.sh tests/test-lib.sh tests/test-suite-integrity.sh tests/test-skill-frontmatter.sh tests/test-cross-references.sh
bash ~/.config/github-app/as-agent.sh git commit -m "test: la suite lit les skills déclarées dans un fichier de données

Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: La forme d'une skill interne

**Files:**
- Modify: `tests/lib.sh`
- Modify: `tests/test-lib.sh`
- Modify: `tests/test-skill-frontmatter.sh`

**Interfaces:**
- Consumes: de la tâche 1, `declared_skills`, `skill_type`, `skill_front`, et dans `tests/test-lib.sh` `is`, `write_skill`, `build_fixture`.
- Produces: `internal_form_offenders`, qui écrit un constat par ligne, de la forme `<skill> <ce qui manque>`, et rien quand tout tient.

- [ ] **Step 1: Write the failing test**

Dans `tests/test-lib.sh`, insère avant la dernière ligne `exit $((FAILURES > 0))` :

```bash
# --- the form of an internal skill ---
build_fixture
is "a well-formed internal skill breaks nothing" "" "$(internal_form_offenders)"

write_skill beta "description: Use only when a skill tells you to invoke beta, never on a request" \
    "Beta does one thing."
is "an internal skill left in the slash menu is reported" \
    "beta is not hidden from the slash menu" "$(internal_form_offenders)"

write_skill beta "$(printf 'description: Use when beta is needed\nuser-invocable: false')" \
    "Beta does one thing."
is "an internal skill that does not ask for an explicit call is reported" \
    "beta does not ask for an explicit call" "$(internal_form_offenders)"

write_skill beta "$(printf 'description: Use only when a skill tells you to invoke beta, never on a request\nuser-invocable: false\ndisable-model-invocation: true')" \
    "Beta does one thing."
is "an internal skill the skills cannot invoke is reported" \
    "beta is not invocable by the skills" "$(internal_form_offenders)"

write_skill beta "$(printf 'description: Use only when a skill tells you to invoke beta, never on a request\nuser-invocable: false')" \
    "Beta does one thing."
write_skill alpha "description: Use only when a skill tells you to invoke alpha, never on a request" \
    "Alpha states its rule."
is "another skill carrying the description of an internal skill is reported" \
    "alpha carries the description of an internal skill" "$(internal_form_offenders)"

```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-lib.sh`
Expected: FAIL, `internal_form_offenders: command not found`.

- [ ] **Step 3: Write the guard**

Ajoute à la fin de `tests/lib.sh` :

```bash

# --- the form of an internal skill ---

# What breaks the form of an internal skill, one finding per line. A skill
# declared internal is hidden from the slash menu, its description asks for an
# explicit call, and it stays invocable by the skills: `disable-model-invocation`
# would stop the calling skills from invoking it too. No other skill carries
# that description.
internal_form_offenders() {
    local s front desc
    for s in $(declared_skills); do
        front="$(skill_front "$s")"
        desc="$(printf '%s\n' "$front" | sed -n 's/^description:[[:space:]]*//p' | head -1)"
        if [ "$(skill_type "$s")" = "internal" ]; then
            case "$front" in
                *"user-invocable: false"*) ;;
                *) echo "$s is not hidden from the slash menu" ;;
            esac
            case "$desc" in
                "Use only when a skill tells you to invoke $s, never on "*) ;;
                *) echo "$s does not ask for an explicit call" ;;
            esac
            case "$front" in
                *"disable-model-invocation"*) echo "$s is not invocable by the skills" ;;
            esac
        else
            case "$desc" in
                *"Use only when a skill tells you to invoke"*)
                    echo "$s carries the description of an internal skill" ;;
            esac
        fi
    done
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-lib.sh`
Expected: 11 lignes `[PASS]`, aucune `[FAIL]`.

- [ ] **Step 5: Use the guard on the shipped skills**

Dans `tests/test-skill-frontmatter.sh`, remplace le commentaire `# The internal skills are building blocks…` et toute la boucle `for r in $(declared_skills internal); do … done` qui le suit par :

```bash
# An internal skill is a building block: only a skill invokes it. It keeps its
# frontmatter, since a skill without one still loads and takes its first line as
# its description.
OFFENDERS="$(internal_form_offenders | tr '\n' '|')"
if [ -z "$OFFENDERS" ]; then
    pass "every skill declared internal has the form of one, and no other skill has"
else
    fail "every skill declared internal has the form of one, and no other skill has ($OFFENDERS)"
fi
```

Run: `bash tests/test-skill-frontmatter.sh`
Expected: 35 lignes `[PASS]`, aucune `[FAIL]`.

- [ ] **Step 6: Commit**

```bash
git add tests/lib.sh tests/test-lib.sh tests/test-skill-frontmatter.sh
bash ~/.config/github-app/as-agent.sh git commit -m "test: une garde générique tient la forme de toute skill déclarée interne

Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 3: Les gardes de contenu lisent les references

**Files:**
- Modify: `tests/lib.sh`
- Modify: `tests/test-lib.sh`
- Modify: `tests/test-skill-content.sh`
- Modify: `tests/test-skill-contracts.sh`
- Modify: `tests/test-reader-prompt.sh`

**Interfaces:**
- Consumes: de la tâche 1, `SKILLS_DIR`, `pass`, `fail`, et dans `tests/test-lib.sh` `is`, `has`, `build_fixture`.
- Produces: `body_flat <fichier>` (écrit le fichier aplati : un `SKILL.md` sans son front matter, un fichier de `references/` en entier), `skill_text <skill>` (laisse dans la variable `SKILL_TEXT` le corps aplati de la skill suivi de chacune de ses refs), `require <skill> <label> <aiguille>`, `shared <label> <aiguille> <skill>…`, `absent <label> <regex> <skill>…`. Les trois gardes gardent la signature et les libellés qu'elles ont aujourd'hui dans `tests/test-skill-content.sh` et `tests/test-skill-contracts.sh`.

- [ ] **Step 1: Write the failing test**

Dans `tests/test-lib.sh`, insère avant la dernière ligne `exit $((FAILURES > 0))` :

```bash
# --- the reading tool ---
build_fixture
is "a reference is read whole, its --- lines included" \
    "First line of the reference. --- A template field kept in the reference. " \
    "$(body_flat "$SKILLS_DIR/alpha/references/note.md")"
is "a skill is read after its front matter, block quotes flattened" \
    " Alpha states its rule. a quoted norm that wraps over two lines " \
    "$(body_flat "$SKILLS_DIR/alpha/SKILL.md")"

# --- the content guards ---
has "require finds a phrase in the skill's body" "[PASS]" \
    "$(require alpha "body" "a quoted norm that wraps over two lines")"
has "require finds a phrase in a reference of the skill" "[PASS]" \
    "$(require alpha "reference" "A template field kept in the reference.")"
has "require fails on a phrase the skill does not state" "[FAIL]" \
    "$(require beta "reference of another skill" "A template field kept in the reference.")"
has "shared names the skill that misses the phrase" "(missing in: beta)" \
    "$(shared "coupling" "Alpha states its rule." alpha beta)"
has "absent finds a claim in a reference of the skill" "(present in: alpha)" \
    "$(absent "claim" "template field kept in the ref[a-z]+" alpha beta)"
has "absent passes when no listed skill carries the claim" "[PASS]" \
    "$(absent "claim" "retired wording" alpha beta)"
has "absent fails on a skill that does not exist" "(no such skill: delta)" \
    "$(absent "claim" "retired wording" alpha delta)"

```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-lib.sh`
Expected: FAIL, `body_flat: command not found`.

- [ ] **Step 3: Write the reading tool and the content guards**

Ajoute à la fin de `tests/lib.sh` :

```bash

# --- the reading tool ---

# A file flattened, so a phrase matches regardless of wrapping. A SKILL.md is
# read after the closing --- of its front matter. A file of `references/` has no
# front matter and is read whole, the --- lines it carries included.
# `tr -s ' '` squeezes runs of spaces to one, so a needle stays matchable when the
# prose it targets is re-wrapped: without it, a wrapped line whose continuation is
# indented flattens to several spaces where the needle has one, and the guard turns
# red on text that is correct. No needle in this suite contains two consecutive
# spaces, so squeezing changes nothing else.
# The `sed` drops a leading blockquote marker for the same reason: a norm written
# as a block quote would otherwise flatten with a stray `>` at every line break,
# and a needle spanning two of its lines could never match. No needle in this
# suite contains `>`.
body_flat() {
    case "$1" in
        */references/*) cat "$1" ;;
        *)              awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$1" ;;
    esac | sed 's/^>[[:space:]]\{0,1\}//' | tr '\n' ' ' | tr -s ' '
}

# What a content guard reads of a skill: its body, then each file of its
# `references/`. Empty when the skill does not exist.
# Read once per skill and kept: flattening forks, and a guard over every skill
# would flatten each of them again. `skill_text` leaves the text in SKILL_TEXT
# rather than printing it, since a command substitution would lose what it kept.
skill_text() {
    local var="SKILL_TEXT_${1//[^A-Za-z0-9]/_}" d="$SKILLS_DIR/$1" r
    if [ -z "${!var+x}" ]; then
        SKILL_TEXT=""
        if [ -f "$d/SKILL.md" ]; then
            SKILL_TEXT="$(body_flat "$d/SKILL.md"
                for r in "$d"/references/*; do
                    if [ -f "$r" ]; then body_flat "$r"; fi
                done)"
        fi
        printf -v "$var" '%s' "$SKILL_TEXT"
    fi
    SKILL_TEXT="${!var}"
}

# --- the content guards ---

# A skill states a phrase.
require() {
    local skill="$1" label="$2" needle="$3"
    skill_text "$skill"
    case "$SKILL_TEXT" in
        *"$needle"*) pass "$skill: $label" ;;
        *)           fail "$skill: $label" ;;
    esac
}

# A coupling between two skills only holds if both ends spell it identically.
# One assertion over several skills, never one per skill: two separate assertions
# would both stay green while one end drifted away from the other.
shared() {
    local label="$1" needle="$2"
    shift 2
    local missing="" s
    for s in "$@"; do
        skill_text "$s"
        case "$SKILL_TEXT" in
            *"$needle"*) ;;
            *) missing="$missing $s" ;;
        esac
    done
    if [ -z "$missing" ]; then
        pass "$label"
    else
        fail "$label (missing in:$missing)"
    fi
}

# The mirror of `shared`: a claim that must survive nowhere. Used for a sentence
# a spec change removed, which is otherwise guarded by nothing — the positive
# assertions would stay green on a skill that carried both the new phrasing and
# the old, contradicting one.
#
# Matches an extended regular expression, not a literal substring: the claim
# hunted may be a denial ("nothing depends on the branch name") while the
# doctrine is written in the same words, affirmatively ("Number allocation
# depends on the branch name"). A literal match cannot tell the two apart and
# would turn red on the true sentence, inviting the writer to delete it.
#
# Fails explicitly, naming the skill, when a listed skill does not exist: an
# empty body never matches, and a silent pass there would mean the assertion
# inspected nothing.
absent() {
    local label="$1" needle="$2"
    shift 2
    local found="" s
    for s in "$@"; do
        if [ ! -f "$SKILLS_DIR/$s/SKILL.md" ]; then
            fail "$label (no such skill: $s)"
            return
        fi
        skill_text "$s"
        if grep -Eq "$needle" <<<"$SKILL_TEXT"; then
            found="$found $s"
        fi
    done
    if [ -z "$found" ]; then
        pass "$label"
    else
        fail "$label (present in:$found)"
    fi
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-lib.sh`
Expected: 20 lignes `[PASS]`, aucune `[FAIL]`.

- [ ] **Step 5: Make test-skill-content.sh use them**

Dans `tests/test-skill-content.sh`, remplace tout ce qui va de la ligne `SCRIPT_DIR=` à l'accolade fermante de la fonction `require` incluse par :

```bash
source "$(dirname "$0")/lib.sh"

echo "test-skill-content"
```

Le fichier ne définit plus `pass`, `fail`, `body_flat` ni `require`, et n'affiche son nom qu'une fois.

Run: `bash tests/test-skill-content.sh | grep -c PASS; bash tests/test-skill-content.sh | grep FAIL`
Expected: `658`, puis aucune ligne.

- [ ] **Step 6: Make test-skill-contracts.sh use them**

Dans `tests/test-skill-contracts.sh`, remplace tout ce qui va de la ligne `SCRIPT_DIR=` à l'accolade fermante de la fonction `absent` incluse par :

```bash
source "$(dirname "$0")/lib.sh"

echo "test-skill-contracts"
```

Le fichier ne définit plus `pass`, `fail`, `body_flat`, `shared` ni `absent`, et n'affiche son nom qu'une fois.

Dans le même fichier, remplace la ligne de commentaire `# frontmatter and references included, which \`body_flat\` would skip.` par `# frontmatter included, which the content guards skip.`

Run: `bash tests/test-skill-contracts.sh | grep -c PASS; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: `133`, puis aucune ligne.

Si une assertion `absent` échoue parce qu'un fichier de `references/` porte la formule chassée, ne modifie ni la skill ni l'assertion : arrête-toi et rapporte l'assertion et le fichier.

- [ ] **Step 7: Point the stale comment at the library**

Dans `tests/test-reader-prompt.sh`, remplace `for the same reason as in test-skill-content.sh.` par `for the same reason as in lib.sh.`

Run: `grep -rn 'body_flat()\|^require()\|^shared()\|^absent()' tests/`
Expected: quatre lignes, toutes dans `tests/lib.sh`.

- [ ] **Step 8: Commit**

```bash
git add tests/lib.sh tests/test-lib.sh tests/test-skill-content.sh tests/test-skill-contracts.sh tests/test-reader-prompt.sh
bash ~/.config/github-app/as-agent.sh git commit -m "test: les gardes de contenu lisent les references d'une skill

Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 4: Les gardes négatives sur toutes les skills

**Files:**
- Modify: `tests/lib.sh`
- Modify: `tests/test-lib.sh`
- Modify: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: de la tâche 1, `declared_skills` ; de la tâche 3, `absent <label> <regex> <skill>…`, et dans `tests/test-lib.sh` `has`.
- Produces: `absent_everywhere <label> <regex>`, qui applique `absent` à toutes les skills déclarées.

- [ ] **Step 1: Write the failing test**

Dans `tests/test-lib.sh`, insère à la fin de la section `# --- the content guards ---`, après l'assertion `absent fails on a skill that does not exist` :

```bash
has "absent_everywhere reaches every declared skill" "(present in: gamma)" \
    "$(absent_everywhere "claim" "retired wording")"
has "absent_everywhere passes when no declared skill carries the claim" "[PASS]" \
    "$(absent_everywhere "claim" "a claim nobody makes")"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-lib.sh`
Expected: FAIL, `absent_everywhere: command not found`.

- [ ] **Step 3: Write the guard**

Dans `tests/lib.sh`, ajoute après l'accolade fermante de la fonction `absent` :

```bash

# `absent` over every declared skill. A negative guard that holds for all the
# skills uses it, so a skill declared later is covered without touching the
# guard.
absent_everywhere() {
    local label="$1" needle="$2"
    # shellcheck disable=SC2046
    absent "$label" "$needle" $(declared_skills)
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-lib.sh`
Expected: 22 lignes `[PASS]`, aucune `[FAIL]`.

- [ ] **Step 5: Convert the guards that name every skill**

Dans `tests/test-skill-contracts.sh`, une assertion `absent` se convertit quand sa liste de skills est exactement l'un de ces deux ensembles, dans n'importe quel ordre :

- `using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module recording-a-decision`
- les mêmes six, plus `rereading-a-spec rereading-a-technical-design`

Convertir, c'est remplacer `absent` par `absent_everywhere`, supprimer la ligne de la liste, et retirer le ` \` qui terminait la ligne de la regex. Le libellé, la regex et le commentaire ne changent pas. Par exemple :

```bash
absent "no skill keeps a Live flags section or its rulings" \
    "Live flags|carried by this batch|inherited by a ruling" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module recording-a-decision
```

devient

```bash
absent_everywhere "no skill keeps a Live flags section or its rulings" \
    "Live flags|carried by this batch|inherited by a ruling"
```

Les 33 assertions concernées portent ces libellés :

```
no skill keeps a Live flags section or its rulings
no skill denies that the branch name matters
no skill calls the spec delta an intention
no skill finds undelivered blocks by reading or diffing the specs
no skill hands over the next step at the ready announcement
no skill carries the retired blocking-precondition wording
no skill denies that the batch document changes at closing
no skill scopes the blockless first commit to a corrective story
no skill strikes a gaps register entry
no skill calls an entry addressable
no skill pairs spec change and code unconditionally
no skill anchors the freeze on a transcription commit
no skill counts what an abandonment leaves on main
no skill says a bounded change never leaves the spec silent
no skill says a bounded change declares only its sections
no skill files an undelivered block as a gap on its own
no skill names the former bounded branch
no skill asks a batch why it happens now
no skill files reserved entries under the spec delta
no skill has a block quote a passage
no skill rereads with fresh eyes
no skill bounds an amendment to scope and flag
no skill bounds an amendment to scope, spec delta and flag
no skill requires continuous deployment
no skill leaves the batch's adding writer unnamed
no skill folds the document reread into opening the pull request
no skill merely revises reservations
no skill makes a lost technical exemption declare a flag
no skill says the spec fixes the gating sentence's form
no skill says a corrective batch's spec delta is empty
no skill calls a divergence between spec and code drift
no skill narrows drift to a contradiction
no skill states the plugin's own language
```

Toute autre assertion `absent` garde sa liste : elle vise des skills choisies.

Run: `grep -c '^absent_everywhere' tests/test-skill-contracts.sh`
Expected: `33`.

Run: `bash tests/test-skill-contracts.sh | grep -c PASS; bash tests/test-skill-contracts.sh | grep FAIL`
Expected: `133`, puis aucune ligne.

Si une assertion convertie échoue sur une skill que sa liste ne nommait pas, ne modifie ni la skill ni la regex : arrête-toi et rapporte l'assertion et la skill.

- [ ] **Step 6: Commit**

```bash
git add tests/lib.sh tests/test-lib.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -m "test: une garde négative qui vaut pour toutes les skills parcourt la liste déclarée

Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 5: Une ref n'est citée que par sa skill

**Files:**
- Modify: `tests/lib.sh`
- Modify: `tests/test-lib.sh`
- Modify: `tests/test-cross-references.sh`

**Interfaces:**
- Consumes: de la tâche 1, `SKILLS_DIR`, `pass`, `fail`, et dans `tests/test-lib.sh` `is`, `write_skill`, `build_fixture`.
- Produces: `foreign_ref_citations`, qui écrit une ligne `<skill>/<fichier> cites <autre skill>/references/<ref>` par citation d'une ref par une skill qui ne la porte pas, et rien quand il n'y en a aucune.

- [ ] **Step 1: Write the failing test**

Dans `tests/test-lib.sh`, insère avant la dernière ligne `exit $((FAILURES > 0))` :

```bash
# --- a reference is cited only by the skill that holds it ---
build_fixture
write_skill alpha "description: Use when alpha is needed" \
    "Compose it from \`skills/alpha/references/note.md\`."
is "a skill citing its own reference breaks nothing" "" "$(foreign_ref_citations)"

write_skill gamma "description: Use when a skill or a plan asks for gamma" \
    "Read \`skills/alpha/references/note.md\` first."
is "a skill citing the reference of another skill is reported" \
    "gamma/SKILL.md cites alpha/references/note.md" "$(foreign_ref_citations)"

write_skill gamma "description: Use when a skill or a plan asks for gamma" \
    "Gamma holds the retired wording."
mkdir -p "$SKILLS_DIR/gamma/references"
printf 'See skills/alpha/references/note.md.\n' > "$SKILLS_DIR/gamma/references/own.md"
is "a reference citing the reference of another skill is reported" \
    "gamma/references/own.md cites alpha/references/note.md" "$(foreign_ref_citations)"

```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-lib.sh`
Expected: FAIL, `foreign_ref_citations: command not found`.

- [ ] **Step 3: Write the guard**

Ajoute à la fin de `tests/lib.sh` :

```bash

# --- the references ---

# The citations of a reference by a skill that does not hold it, one per line.
# A reference belongs to one skill: a text several skills need lives in an
# internal skill they invoke.
foreign_ref_citations() {
    local d s f hit
    for d in "$SKILLS_DIR"/*/; do
        s="$(basename "$d")"
        while IFS= read -r f; do
            while IFS= read -r hit; do
                [ -n "$hit" ] || continue
                if [ "${hit%%/references/*}" != "$s" ]; then
                    echo "${f#"$SKILLS_DIR"/} cites $hit"
                fi
            done < <(grep -oE '[a-z0-9-]+/references/[A-Za-z0-9._-]*[A-Za-z0-9]' "$f" | sort -u || true)
        done < <(find "${d%/}" -type f | sort)
    done
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-lib.sh`
Expected: 25 lignes `[PASS]`, aucune `[FAIL]`.

- [ ] **Step 5: Use the guard on the shipped skills**

Dans `tests/test-cross-references.sh`, insère avant la dernière ligne `exit $((FAILURES > 0))` :

```bash
# 8. A reference is cited only by the skill that holds it. A text several
#    skills need lives in an internal skill they invoke: a reference sits in
#    the directory of one skill, and another skill citing it depends on a file
#    it does not own.
FOREIGN="$(foreign_ref_citations | tr '\n' '|')"
if [ -z "$FOREIGN" ]; then
    pass "a reference is cited only by the skill that holds it"
else
    fail "a reference is cited only by the skill that holds it ($FOREIGN)"
fi

```

Run: `bash tests/test-cross-references.sh`
Expected: 36 lignes `[PASS]`, aucune `[FAIL]`.

Si la garde échoue sur une skill livrée, ne modifie pas la skill : arrête-toi et rapporte la citation.

- [ ] **Step 6: Commit**

```bash
git add tests/lib.sh tests/test-lib.sh tests/test-cross-references.sh
bash ~/.config/github-app/as-agent.sh git commit -m "test: une ref n'est citée que par la skill qui la porte

Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 6: CONTRIBUTING décrit l'outillage

**Files:**
- Modify: `CONTRIBUTING.md`

**Interfaces:**
- Consumes: les chemins `tests/skills.txt`, `tests/lib.sh` et `tests/test-lib.sh` des tâches précédentes.
- Produces: rien.

- [ ] **Step 1: Say where a skill is declared**

Dans `CONTRIBUTING.md`, section `## Tests`, insère après le paragraphe qui se termine par `none of them silently asserts nothing.` :

```markdown
`tests/skills.txt` declares every skill with its type: `entry`, `internal` or
`foundation`. The suite fails on a skill directory that is not declared there,
and a guard that holds for every skill walks that list. `tests/lib.sh` holds
what the check files share, and `tests/test-lib.sh` checks it.
```

- [ ] **Step 2: Add what the suite does not test**

Dans la même section, remplace `all three need a live agent` par `each needs a live agent`.

Remplace les deux lignes

```markdown
- whether `finishing-a-development-branch` is really kept to the pull-request
  option on a story.
```

par

```markdown
- whether `finishing-a-development-branch` is really kept to the pull-request
  option on a story;
- whether an agent that invokes an internal skill comes back to the next step
  of the skill that invoked it.
```

- [ ] **Step 3: Run the whole suite**

Run: `bash tests/run-all.sh > /tmp/13-us-1-run.txt 2>&1; tail -1 /tmp/13-us-1-run.txt; grep -c PASS /tmp/13-us-1-run.txt; grep -c FAIL /tmp/13-us-1-run.txt`
Expected: `all tests passed`, `1057`, `0`.

- [ ] **Step 4: Commit**

```bash
git add CONTRIBUTING.md
bash ~/.config/github-app/as-agent.sh git commit -m "docs: CONTRIBUTING décrit l'outillage des tests

Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

Ruling: trois constats mineurs de la relecture finale sont corrigés avant la pull request, sans qu'elle l'exige : la garde sur les refs ne retient que les chemins qui nomment une skill, `user-invocable: false` se cherche comme une ligne entière, et deux commentaires de l'outil de lecture disent ce qu'il retire et ce qu'il garde — les stories suivantes du lot bâtissent leurs gardes sur ces fonctions et auraient dû les retoucher — une vague de corrections et sa relecture, si elle n'était pas nécessaire.

Ruling: les autres constats mineurs restent en l'état : la garde sur la forme d'une skill interne rend ses constats sur une seule ligne `[FAIL]`, une ref citée dans un sous-répertoire de `references/` est rapportée avec un chemin coupé, deux noms de skill qui ne diffèrent que par un caractère non alphanumérique partageraient leur texte gardé, `skill_front` n'a pas d'assertion à elle, et les fichiers de test lisent `$REPO_ROOT/skills` plutôt que `$SKILLS_DIR` — aucun ne change ce qu'une garde attrape — un message d'échec moins précis.

Ruling: la relecture finale de la branche a tourné sur le modèle et l'effort que l'utilisateur a fixés pour tous les sous-agents du lot, pas sur le modèle le plus capable que demande l'exécution par sous-agents — décision de l'utilisateur — une relecture finale moins profonde.

Technical design ruling: `CONTRIBUTING.md` ajoute à ce que la suite ne teste pas le retour d'un agent à la skill qui a invoqué une skill interne, et laisse à la story qui livre `following-the-rules` le chargement du socle par un sous-agent — le socle n'existe pas encore, et `CONTRIBUTING.md` décrirait une skill que le dépôt ne porte pas — la story de `following-the-rules` doit ajouter cette phrase, sans quoi `CONTRIBUTING.md` reste en deçà de ce que la conception demande.

Ruling: une garde négative vaut pour toutes les skills quand sa liste nommait toutes les skills, ou toutes sauf les deux relectures ; les autres gardes `absent` gardent leur liste, même quand leur libellé dit « no skill » — leur liste dit sur quelles skills la formule est chassée, et l'étendre changerait ce qu'elles tiennent — une formule retirée qui survivrait dans une skill que sa garde ne nomme pas.

## Observed drift
