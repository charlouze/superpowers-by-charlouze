#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-skill-contracts"

# Body only: everything after the closing --- of the frontmatter, flattened so a
# phrase matches regardless of wrapping.
body_flat() {
    awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$1" | tr '\n' ' '
}

# A coupling between two skills only holds if both ends spell it identically.
# One assertion over several files, never one per file: two separate assertions
# would both stay green while one end drifted away from the other.
shared() {
    local label="$1" needle="$2"
    shift 2
    local missing=""
    local s f b
    for s in "$@"; do
        f="$REPO_ROOT/skills/$s/SKILL.md"
        b=""
        [ -f "$f" ] && b="$(body_flat "$f")"
        case "$b" in
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

# The human's ruling on a live flag reaches the closing check through these two
# fixed strings and nothing else: writing-a-batch writes them into the batch
# document, closing-a-batch matches the first word for word. A paraphrase on
# either end reads as an unruled flag rather than a flag ruled away, and the
# batch closes over a lifting story nobody wrote.
shared "live-flag ruling: carried by this batch" \
    "carried by this batch — lifting story owed" \
    writing-a-batch closing-a-batch

shared "live-flag ruling: not this batch" \
    "not this batch — <reason>" \
    writing-a-batch closing-a-batch

# The section that carries those rulings is named on both ends.
shared "the Live flags section is named on both ends" \
    "Live flags" \
    writing-a-batch closing-a-batch


# `Number allocation` and the concurrency scan both recognise a branch by its
# name, and both on exactly the window where no pull request exists yet. So a
# skill that creates a branch owes more than "some named branch exists": it
# restores the conventional name. The loose reading leaves a branch that is
# invisible to both scans, holding neither its number nor its sections.
shared "every branch-creating skill restores the conventional name" \
    "restore the conventional name before going on" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

shared "and each says a named branch is not enough" \
    "named branch is not enough" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

exit $((FAILURES > 0))
