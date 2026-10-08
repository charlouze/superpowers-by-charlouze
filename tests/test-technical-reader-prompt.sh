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
if [ -e "$REPO_ROOT/skills/opening-a-batch/references/technical-reader-prompt.md" ]; then
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
# A slot with nothing to put in it says so: left as written, it reads as a path.
has "an empty slot says so"                 "In a slot with nothing to put in it, such as the ADRs to reread when the pull request writes none, write \`none\`"
has "the batch document is handed over"     "**The batch document:**"
# The reading names what the reader evaluates; the frame defines the names.
has "the reading names what is evaluated"   "Your reading, below, names what you evaluate"
has "the design is the two sections"        "Where it names the design, that is the document's \`Technical design\` section and its \`Constraints\` section"
has "the blocks are the spec delta's changes" "Where it names the blocks, those are the changes its \`Spec delta\` section writes into the specifications"
has "a none section gives nothing"          "A section that reads \`none\` gives you nothing to evaluate"
has "a none section is no finding"          "and its absence is not a finding"
has "the rest says what the batch promises" "The rest of the document says what the batch promises: read it for that"
has "the ADRs to reread are handed over"    "**The ADRs to reread:**"
has "the ADRs to reread are those listed"   "Where your reading names the ADRs to reread, these are the ones"
# What the reading does not name is what it is read against, never evaluated.
has "the applied specs are handed over"     "**The specifications, with the batch's changes applied:**"
has "the other specs are handed over"       "**The other specifications:**"
has "a listed spec is read at its listed path" "Read there only the specifications not listed above: a specification listed above carries the same file name, and is read at the path given there"
has "a gaps register is no specification"   "A file whose name ends in \`.gaps.md\` is not a specification"
has "the reader did not write what it reads" "You are reading part of one batch of work. You did not write what you read, and you are not being asked to improve it"
has "the ADRs to reread slot"                "<path to each ADR the pull request writes or rewrites>"
has "the other specs slot"                   "<the directory of the project's specifications, for those the batch does not touch>"
has "the ADR directory slot"                 "<the directory of the project's ADRs, as the pull request leaves it>"
has "the ADR directory is handed over"      "**The ADR directory:**"
has "the code is handed over"               "**The code as it stands today:**"
has "only what the reading names is evaluated" "Report only on what your reading names. Everything else is what you read it against: report nothing about it"
# A later round's reader gets the state the round before read, and reports on the
# revision alone.
has "a first round's reader gets no previous state" "For the first round, leave out the paragraph on the state the previous round read"
has "a later round's reader gets the state last read" "**The state the previous round read:**"
has "a later round reports on the revision" "Report only what the revision between that state and the batch document above makes wrong: a sentence it added, moved or reworded, and a passage that leaned on a sentence it took out"
has "a later round leaves the unchanged alone" "Report nothing that stands unchanged since that state"
has "a reader loads no unnamed skill"       "Load no skill your reading does not name"
has "everything needed is in the prompt"    "Everything you need is in this prompt"
has "a finding quotes its passage"          "the passage it bears on, quoted with the file and the section it"
has "an empty result is reported"           "Return \"nothing found\" when you found nothing"
has "a reader revises nothing"              "Do not revise what you read, and do not modify the code"
has "a reader dispatches nothing"           "Do not dispatch subagents"
# A reader handed a working tree is tempted to run its test suite. What the suite
# says is the code's business; the reading is about what it names.
has "a reader runs nothing"                 "Run nothing, neither a test, a build nor a script: you read files and search them"

# The frame no longer says the design is all a reader evaluates: a reading may
# name the blocks or the ADRs to reread.
case "$FLAT" in
    *"your findings are about the design"*|*"The document you are evaluating"*|*"Do not revise the design"*|*"You are reading the technical design and the constraints"*)
        fail "the frame is not bound to the design" ;;
    *)  pass "the frame is not bound to the design" ;;
esac

# The prompt names no skill of the plugin.
case "$FLAT" in
    *"supercharlouze:"*|*"using-batches"*|*"adopting-a-module"*|*"opening-a-batch"*|*"amending-a-batch"*|*"handling-a-stopped-story"*|*"making-a-bounded-change"*|*"writing-a-user-story"*|*"closing-a-batch"*|*"rereading-a-spec"*|*"recording-a-decision"*|*"running-reread-rounds"*)
        fail "the prompt names no skill of the plugin" ;;
    *)  pass "the prompt names no skill of the plugin" ;;
esac

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
blocks and the design hold the ADRs
stand with the specifications and the other ADRs
NEEDLES

if [ -z "$BAD" ]; then
    pass "the prompt restates no reading"
else
    fail "the prompt restates no reading (found:$BAD)"
fi

case "$FLAT" in
    *[Ff]"ive readings"*|*"of the five"*|*[Ss]"even readings"*|*"of the seven"*)
        fail "the prompt does not count the readings" ;;
    *)  pass "the prompt does not count the readings" ;;
esac

exit $((FAILURES > 0))
