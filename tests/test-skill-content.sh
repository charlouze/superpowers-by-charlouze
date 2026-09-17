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
require adopting-a-module "the human delimits the module"        "You never delimit one yourself"
require adopting-a-module "records Sources in the spec"          "recorded in the \`Sources\` section of the spec"
require adopting-a-module "produces the gaps register"           "gaps register"
require adopting-a-module "the register declares its coverage"   "declares its own coverage"
require adopting-a-module "the PR review is the gate"             "review of the adoption pull request"
require adopting-a-module "handles the no-document fallback"     "no validated document"
require adopting-a-module "branch naming convention"             "adopt/"

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

# --- writing-a-batch: the batch document contract (spec section "The batch document") ---
require writing-a-batch "template declares the Constraints section" "## Constraints"
require writing-a-batch "template declares the Live flags section"  "## Live flags"
require writing-a-batch "Constraints are copied verbatim to stories" "copies this section **verbatim** into"
require writing-a-batch "Constraints carry nothing normative"       "and nothing normative"
require writing-a-batch "live-flag ruling is a fixed string"        "fixed strings, not paraphrases"
require writing-a-batch "Live flags is a snapshot for this gate"    "snapshot, taken for this gate"

# --- writing-a-user-story (spec 3, 4.4, 5.1, 5.3) ---
require writing-a-user-story "checks it is in the main checkout"  "main checkout"
require writing-a-user-story "refreshes main from the remote"     "up to date with the remote"
require writing-a-user-story "concurrency via declared Sections"  "Sections:"
require writing-a-user-story "git conflict is only a partial net" "partial safety net"
require writing-a-user-story "transcription is the first commit"  "first commit on the branch"
require writing-a-user-story "freeze travels in Global Constraints" "Global Constraints"
require writing-a-user-story "freeze ends when the PR opens"      "freeze is lifted when the pull request opens"
require writing-a-user-story "corrective story strikes an entry"  "strikes the gaps register entry the story resolves"
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

# --- writing-a-user-story: what Global Constraints carries (spec section "The user story document") ---
require writing-a-user-story "GC carries the batch Constraints"   "\`Constraints\` section copied verbatim"
require writing-a-user-story "GC carries the spec freeze"         "freeze of the spec file"
require writing-a-user-story "GC carries the authority rule"      "Put that rule in \`Global Constraints\` too"
require writing-a-user-story "the authority rule is stated in full" "the spec wins — without exception and without deliberation"
require writing-a-user-story "GC carries the fifth stop condition" "the fifth stop condition of Step 5, written out in full"
require writing-a-user-story "GC is the only channel to SDD subagents" "only channel to this skill's rules is this list"

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

# --- closing-a-batch: the three duty precisions (spec section "Closing a batch") ---
require closing-a-batch "duty 5 checks before the writing duties" "before duties 1 to 4"
require closing-a-batch "a refusal must cost nothing"            "makes a refusal free"
require closing-a-batch "covers flags inherited by a ruling"     "inherited by a ruling at the opening gate"
require closing-a-batch "the ruling replaces the declaration"    "the ruling replaces the declaration as the test"
require closing-a-batch "duty 4 is empty for a corrective batch" "A corrective batch has nothing to compare here"
require closing-a-batch "released entries are not re-filed"      "do not re-file the released entries as fresh gaps"

# --- using-batches: what a spec says (spec section "The spec document") ---
require using-batches "the test bears on the module boundary"   "bears on the module's boundary"
require using-batches "no rewording a mechanism into a rule"    "You do not reword a mechanism into a rule"
require using-batches "lists the laundering signs"              "Four signs recognise it"
require using-batches "a business choice carries its number"    "A business choice carries its number"
require using-batches "vagueness is not prudence"               "Vagueness is not prudence"
require using-batches "a number says where it comes from"       "a decision, or a reading of the code"
require using-batches "structure follows the business"          "structure follows the business"
require using-batches "a glossary is a rule, not a leak"        "Naming is not mechanising"
require using-batches "one normative level, no ranking"         "normative, at the same level"
require using-batches "a module redefines what it borrows"      "redefines what it borrows"
require using-batches "the rule covers the changelog cell"      "including the changelog's \`change\` cell"
require using-batches "the gaps register is out of scope"       "which is not a spec"

exit $((FAILURES > 0))
