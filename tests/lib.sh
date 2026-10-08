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
