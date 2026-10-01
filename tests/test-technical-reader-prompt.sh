#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-technical-reader-prompt"

# The technical reader prompt is read by a subagent instead of the skill, so
# nothing else guards it. `test-cross-references.sh` proves the skill's citation
# of it resolves; these assertions are about what it says once opened.
PROMPT="$REPO_ROOT/skills/rereading-a-technical-design/references/reader-prompt.md"

if [ -f "$PROMPT" ]; then
    pass "the technical reader prompt exists"
else
    fail "the technical reader prompt exists"
    exit 1
fi

# The calling skill keeps no reader prompt of its own, which would drift.
if [ -e "$REPO_ROOT/skills/writing-a-batch/references/technical-reader-prompt.md" ]; then
    fail "the calling skill keeps no technical reader prompt of its own"
else
    pass "the calling skill keeps no technical reader prompt of its own"
fi

# Flattened so a phrase matches regardless of how the prose is wrapped.
FLAT="$(tr '\n' ' ' < "$PROMPT" | tr -s ' ')"

has() {
    local label="$1" needle="$2"
    case "$FLAT" in
        *"$needle"*) pass "$label" ;;
        *)           fail "$label" ;;
    esac
}

has "one reader carries one reading"        "One reader, one reading, one batch"
has "the reading comes from the skill"      "one of the readings that \`## The Readings\` of the skill states, pasted word for word from there"
has "the batch document is the object"      "**The document you are evaluating:**"
# The reader evaluates two sections, and a `none` gives it nothing there.
has "the design is the two sections"        "What you evaluate is its \`Technical design\` section and its \`Constraints\` section, which this prompt calls the design"
has "a none section gives nothing"          "A section that reads \`none\` gives you nothing to evaluate"
has "a none section is no finding"          "and its absence is not a finding"
has "the rest says what the batch promises" "The rest of the document says what the batch promises: read it for that"
# The applied specs and the code are what the design is read against, never
# what is evaluated.
has "the applied specs are handed over"     "**The specifications, with the batch's changes applied:**"
has "the specs are not evaluated"           "Report nothing about them: your findings are about the design"
has "the code is handed over"               "**The code as it stands today:**"
has "the code is not evaluated"             "Report nothing about the code itself: your findings are about the design"
# A later round's reader gets the state the round before read, and reports on the
# revision alone.
has "a first round's reader gets no previous state" "For the first round, leave out the paragraph on the state the previous round read"
has "a later round's reader gets the state last read" "**The state the previous round read:**"
has "a later round reports on the revision" "Report only what the revision between that state and the document above makes wrong: a sentence it added, moved or reworded, and a passage that leaned on a sentence it took out"
has "a later round leaves the unchanged alone" "Report nothing that stands unchanged since that state"
has "a reader loads no unnamed skill"       "Load no skill your reading does not name"
has "everything needed is in the prompt"    "Everything you need is in this prompt"
has "a finding quotes its passage"          "the passage it bears on, quoted with the section it"
has "an empty result is reported"           "Return \"nothing found\" when you found nothing"
has "a reader revises nothing"              "Do not revise the design, and do not modify the code"
has "a reader dispatches nothing"           "Do not dispatch subagents"
# A reader handed a working tree is tempted to run its test suite. What the suite
# says is the code's business; the reading is about the design.
has "a reader runs nothing"                 "Run nothing, neither a test, a build nor a script: you read files and search them"

# --- the prompt restates no reading ---
# The readings live in `## The Readings` of the skill. A copy pasted in here
# would pass every assertion above while drifting the day that section changes.
BAD=""
while IFS= read -r needle; do
    [ -n "$needle" ] || continue
    case "$FLAT" in
        *"$needle"*) BAD="$BAD '$needle'" ;;
    esac
done <<'NEEDLES'
deliver what the batch promises
stand on the code as it is
hold as an architecture
modules this design draws deep
How does this design fail
NEEDLES

if [ -z "$BAD" ]; then
    pass "the prompt restates no reading"
else
    fail "the prompt restates no reading (found:$BAD)"
fi

case "$FLAT" in
    *[Ff]"ive readings"*|*"of the five"*)
        fail "the prompt does not count the readings" ;;
    *)  pass "the prompt does not count the readings" ;;
esac

exit $((FAILURES > 0))
