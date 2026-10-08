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
PROMPT="$REPO_ROOT/skills/rereading-a-spec/references/reader-prompt.md"

if [ -f "$PROMPT" ]; then
    pass "the reader prompt exists"
else
    fail "the reader prompt exists"
    exit 1
fi

# One template for every spec reread: the skills that have a spec reread keep
# no reader prompt of their own, which would drift from the shared one.
STRAY=""
for old in writing-a-batch adopting-a-module; do
    if [ -e "$REPO_ROOT/skills/$old/references/reader-prompt.md" ]; then
        STRAY="$STRAY $old"
    fi
done
if [ -z "$STRAY" ]; then
    pass "no calling skill keeps a reader prompt of its own"
else
    fail "no calling skill keeps a reader prompt of its own (found in:$STRAY)"
fi

# Flattened so a phrase matches regardless of how the prose is wrapped, and with
# runs of spaces squeezed for the same reason as in lib.sh.
FLAT="$(tr '\n' ' ' < "$PROMPT" | tr -s ' ')"

has() {
    local label="$1" needle="$2"
    case "$FLAT" in
        *"$needle"*) pass "$label" ;;
        *)           fail "$label" ;;
    esac
}

has "one reader carries one reading"        "One reader, one reading, one spec"
has "the reading comes from the skill"      "one of the readings that \`## The Readings\` of the skill states, pasted word for word from there"
# A new spec has no earlier state, so its reader gets no paragraph about one.
has "a new spec's reader gets no earlier state" "For a new spec, leave out the paragraph on the earlier state"
# Which of the two states the finding is about. Both assertions: the applied copy
# is named as the object, and the earlier state is fenced off from being reviewed
# as a diff — a reader handed two files drifts to the diff without the second.
has "the evaluated document is the object"  "**The document you are evaluating:**"
has "the reader gets the spec as it stands" "The same specification as it stands today"
has "the earlier state locates the change"  "for locating what changed"
has "the change is not reviewed as a diff"  "Do not review the change as a diff"
# The reader is the one holding both states, so it is the one that can tell a
# defect the change brings from one that was already there.
has "a defect already there is reported apart" "A defect this earlier state already carries, and that the change neither brings nor worsens, is reported apart, under \`Already there\`"
# A later round's reader gets the state the round before read, and reports on the
# revision alone. Without the fence it reads the whole document as a first round
# would, and returns what the round before already returned.
has "a first round's reader gets no previous state" "For the first round, leave out the paragraph on the state the previous round read"
has "a later round's reader gets the state last read" "**The state the previous round read:**"
has "a later round reports on the revision" "Report only what the revision between that state and the document above makes wrong: a sentence it added, moved or reworded, and a passage that leaned on a sentence it took out"
has "a later round leaves the unchanged alone" "Report nothing that stands unchanged since that state"
has "the aside convention is handed over"   "The project's aside convention"
# The other specs let a reader check a borrowed term or a rule that spills over
# a boundary; they are consulted, never evaluated.
has "the other specs are handed over"       "**The project's other specifications:**"
has "the other specs are for reference"     "Consult them when your reading bears on another module. Report nothing about them"
# One generic rule rather than a list of things not to read: a reader that loads
# no skill its reading does not name cannot reach the other readings, and
# cannot pull in anything else either.
has "a reader loads no unnamed skill"       "Load no skill your reading does not name"
has "everything needed is in the prompt"    "Everything you need is in this prompt"
has "a finding quotes its passage"          "the passage it bears on, quoted with the section it"
has "an empty result is reported"           "Return \"nothing found\" when you found nothing"
has "a reader does not revise"              "Do not revise the specification"
has "a reader dispatches nothing"           "Do not dispatch subagents"
has "a reader runs nothing"                 "Run nothing, neither a test, a build nor a script: you read files and search them"

# --- the prompt restates no reading, and hands over no blocks ---
# The readings live in `## The Readings` of the skill, which is where a
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
precise and concise
the blocks, verbatim
NEEDLES

if [ -z "$BAD" ]; then
    pass "the prompt restates no reading and hands over no blocks"
else
    fail "the prompt restates no reading and hands over no blocks (found:$BAD)"
fi

case "$FLAT" in
    *"one of the two"*|*"neither of them"*|*"step 7"*)
        fail "the prompt neither counts the readings nor ranks a step" ;;
    *)  pass "the prompt neither counts the readings nor ranks a step" ;;
esac

exit $((FAILURES > 0))
