#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-gaps-register"

# The two assertions below read the gaps register file itself, not a skill: a
# norm on an entry's shape that is only guarded in the skills' prose leaves the
# file free to violate it, and that is exactly what happened. Only the entry
# categories are read — `## Coverage` is prose by construction, and is not
# concerned.
#
# What these guards do NOT catch: a cross-reference written some other way
# than the listed turns of phrase, and group prose folded into a list item.
# They catch the form the defect took, which is the most a textual guard can
# promise here.

# The lines of the `## Violations` and `## Gaps` sections, categories
# included, up to the next level-2 heading or the end of the file.
entry_lines() {
    awk '
        /^## / { inside = ($0 == "## Violations" || $0 == "## Gaps"); next }
        inside { print }
    ' "$1"
}

# --- 1: nothing but an entry under a category ---
# An entry is a list item. A non-empty line that starts with neither `- ` nor
# an indentation is running prose: either a paragraph that qualifies a group
# of entries, or an entry written as prose. Both are forbidden by the same
# rule.
BAD=""
for f in "$REPO_ROOT"/docs/specs/*.gaps.md; do
    [ -f "$f" ] || continue
    while IFS= read -r line; do
        [ -n "${line// /}" ] || continue
        case "$line" in
            "- "*|"  "*) ;;
            *) BAD="$BAD $(basename "$f"): ${line:0:40}" ;;
        esac
    done < <(entry_lines "$f")
done
if [ -z "$BAD" ]; then
    pass "a gaps register category carries entries and nothing else"
else
    fail "a gaps register category carries entries and nothing else ($BAD)"
fi

# --- 2: no entry designates another ---
# A settled entry leaves the file and takes with it whatever pointed at it.
# The turns of phrase below are the ones by which an entry-to-entry
# cross-reference is written: the position words (above/below, previous/next
# entry), plus the bare words for "the entry" and "entries", however they are
# used — not only when they point at a named entry. An entry that refers to
# itself, or that quotes the spec's own sentence "Les entrées s'ajoutent et se
# suppriment une par une", turns this guard red without containing any
# cross-reference at all.
BAD=""
for f in "$REPO_ROOT"/docs/specs/*.gaps.md; do
    [ -f "$f" ] || continue
    hits="$(entry_lines "$f" | grep -icE "ci-dessus|ci-dessous|l'entrée|les entrées|entrée précédente|entrée suivante" || true)"
    [ "$hits" = "0" ] || BAD="$BAD $(basename "$f"):$hits"
done
if [ -z "$BAD" ]; then
    pass "no gaps register entry designates another"
else
    fail "no gaps register entry designates another ($BAD)"
fi

exit $((FAILURES > 0))
