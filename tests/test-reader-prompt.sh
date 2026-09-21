#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-reader-prompt"

# The reader prompt is the only artifact of this plugin that a subagent reads
# instead of the skill, so nothing else guards it. `test-cross-references.sh`
# proves the skill's citation of it resolves; these assertions are about what it
# says once opened.
PROMPT="$REPO_ROOT/skills/writing-a-batch/references/reader-prompt.md"

if [ -f "$PROMPT" ]; then
    pass "the reader prompt exists"
else
    fail "the reader prompt exists"
    exit 1
fi

# Flattened so a phrase matches regardless of how the prose is wrapped, and with
# runs of spaces squeezed for the same reason as in test-skill-content.sh.
FLAT="$(tr '\n' ' ' < "$PROMPT" | tr -s ' ')"

has() {
    local label="$1" needle="$2"
    case "$FLAT" in
        *"$needle"*) pass "$label" ;;
        *)           fail "$label" ;;
    esac
}

has "one reader carries one reading"        "One reader, one reading, one touched spec"
has "the reading comes from the skill"      "one of the four that \`## The Coherence Reread\` states, pasted **word for word** from there"
# Which of the two states the finding is about. Both assertions: the applied copy
# is named as the object, and the earlier state is fenced off from being reviewed
# as a diff — a reader handed two files drifts to the diff without the second.
has "the applied copy is the object"        "**The document you are evaluating**"
has "the reader gets the spec as it stands" "The same specification as it stands today"
has "the earlier state locates the change"  "for locating what changed"
has "the change is not reviewed as a diff"  "Do not review the change as a diff"
# One generic rule rather than a list of things not to read: a reader that loads
# no skill its reading does not name cannot reach the other three readings, and
# cannot pull in anything else either.
has "a reader loads no unnamed skill"       "Load no skill your reading does not name"
has "everything needed is in the prompt"    "Everything you need is in this prompt"
has "a finding quotes its passage"          "the passage it bears on, quoted with the section it"
has "an empty result is reported"           "Return \"nothing found\" when you found nothing"
has "a reader does not revise"              "Do not revise the specification"
has "a reader dispatches nothing"           "Do not dispatch subagents"

# --- the prompt restates no reading, and hands over no blocks ---
# The readings live in `## The Coherence Reread` of the skill, which is where a
# conductor reads them and where test-skill-content.sh guards them. A second copy
# pasted in here would pass every assertion above while drifting the day that
# section is amended, and the word-for-word slot would then be decoration. The
# blocks are the other way round: the reader gets both states, so a block list
# adds nothing and invites the block-by-block reading the prompt forbids above.
BAD=""
while IFS= read -r needle; do
    [ -n "$needle" ] || continue
    case "$FLAT" in
        *"$needle"*) BAD="$BAD '$needle'" ;;
    esac
done <<'NEEDLES'
make false elsewhere
does this change leave out
what a specification must hold
Where does this sit in the model
the blocks, verbatim
NEEDLES

if [ -z "$BAD" ]; then
    pass "the prompt restates no reading and hands over no blocks"
else
    fail "the prompt restates no reading and hands over no blocks (found:$BAD)"
fi

exit $((FAILURES > 0))
