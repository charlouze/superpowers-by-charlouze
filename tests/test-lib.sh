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
