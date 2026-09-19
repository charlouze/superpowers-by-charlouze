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
# `tr -s ' '` squeezes runs of spaces to one, so a needle stays matchable when the
# prose it targets is re-wrapped: without it, a wrapped line whose continuation is
# indented flattens to several spaces where the needle has one, and the guard turns
# red on text that is correct. No needle in this suite contains two consecutive
# spaces, so squeezing changes nothing else.
body_flat() {
    awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$1" | tr '\n' ' ' | tr -s ' '
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
require adopting-a-module "asks for the human's breakdown first" "Their breakdown comes before any of yours"
require adopting-a-module "may think the breakdown through with them" "think it through with them"
require adopting-a-module "validated documents are normative"    "validated documents are normative"
require adopting-a-module "never rebuilds a spec from code"      "never reconstructed from the code"
require adopting-a-module "authority on intentions, not mechanisms"    "**intentions they state**, never on the **mechanisms they describe**"
require adopting-a-module "a read mechanism goes to the register"      "does not enter the spec: it becomes a gap naming its document"
require adopting-a-module "no reading through a mechanism"             "you do not read *through* a mechanism"
require adopting-a-module "the test is applied sentence by sentence"   "Every sentence you write passes the other-implementation test"
require adopting-a-module "the human delimits the module"        "You never delimit one yourself"
require adopting-a-module "records the inventory in the PR body" "Record the retained inventory in the **body of the adoption pull request**"
require adopting-a-module "the spec lists no sources"            "The spec itself lists no sources"
require adopting-a-module "the PR body lists every source"       "List every retained document by archive path"
require adopting-a-module "offers to promote the gaps"           "to promote the gaps into the spec"
require adopting-a-module "no mechanism is put up for promotion" "A gap that names a mechanism is not put to them"
require adopting-a-module "produces the gaps register"           "gaps register"
require adopting-a-module "the register declares its coverage"   "declares its own coverage"
require adopting-a-module "exclusivity is scoped, not dropped"   "Within that bound, only they create normative text"
# Step 4 points at the authority rule rather than restating it: a second full
# statement of the same rule, a few hundred lines from the first, is what drifts.
require adopting-a-module "step 4 points at the authority rule" "The authority rule of \`Source Authority\` above holds while you write"
require adopting-a-module "a gap entry names its source document"   "came from a document names that document"
require adopting-a-module "step 4 files the gap itself"            "goes straight into the gaps register"
require adopting-a-module "the register is created when needed"    "the first time you need it"
require adopting-a-module "the PR review is the gate"             "review of the adoption pull request"
require adopting-a-module "handles the no-document fallback"     "no validated document"
require adopting-a-module "the fallback enumerates at the boundary"   "observable at the module's boundary"
require adopting-a-module "the question is about the intention"       "about the intention, never about the mechanism"
require adopting-a-module "a mechanism is not put to validation"      "A mechanism is not submitted to human validation"
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
require writing-a-batch "the specs are the registry of flags"     "The specs are the registry of flags"
require writing-a-batch "a lifting is stated in the spec delta"   "state its lifting in the \`Spec delta\`"
require writing-a-batch "amendment pull request exists"           "amendment pull request"
require writing-a-batch "carries the requalification procedure"   "requalification"
require writing-a-batch "branch naming convention"                "batch/NN"

# --- writing-a-batch: the batch document contract (spec section "The batch document") ---
require writing-a-batch "template declares the Constraints section" "## Constraints"
require writing-a-batch "Constraints are copied verbatim to stories" "copies this section **verbatim** into"
require writing-a-batch "Constraints carry nothing normative"       "and nothing normative"

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
require writing-a-user-story "spec change states flag and default" "states the flag and its default"
require writing-a-user-story "one lifting story per module"       "one lifting story per guarded module"
require writing-a-user-story "teardown story exists"              "teardown story"

# --- writing-a-user-story: what Global Constraints carries (spec section "The user story document") ---
require writing-a-user-story "GC carries the batch Constraints"   "\`Constraints\` section copied verbatim"
require writing-a-user-story "GC carries the spec freeze"         "freeze of the spec file"
require writing-a-user-story "GC carries the authority rule"      "That rule is the third thing \`Global Constraints\` carries"
require writing-a-user-story "GC counts four things"              "carries four things"
require writing-a-user-story "the authority rule is stated in full" "the spec wins — without exception and without deliberation"
require writing-a-user-story "GC carries the fifth stop condition" "the fifth stop condition of Step 5, written out in full"
require writing-a-user-story "GC is the only channel to SDD subagents" "only channel to this skill's rules is this list"

# --- closing-a-batch (spec 4.1, 4.2, 5.4) ---
require closing-a-batch "one changelog line per batch"           "one line per batch"
require closing-a-batch "consolidates Observed drift"            "Observed drift"
# This duty sorts what the stories brought back; it must not read as a definition
# of either category. A fourth wording of "what a gap is" would sit outside the
# `shared` assertion that locks the other three, and drift with nothing to catch it.
require closing-a-batch "sorts story findings, defines nothing"  "whatever a story reported as"
require closing-a-batch "releases unconsumed reservations"       "unconsumed reservations"
require closing-a-batch "records undelivered intentions"         "announced but never delivered"
require closing-a-batch "refuses to close on an undeclared flag" "no declared scope"
require closing-a-batch "offers three exits"                     "three exits"
require closing-a-batch "sets status closed"                     "status: closed"
require closing-a-batch "closing PR is reviewed"                 "review of the closing pull request"
require closing-a-batch "branch naming convention"               "batch/NN"

# --- closing-a-batch: the three duty precisions (spec section "Closing a batch") ---
require closing-a-batch "the flag check is duty 1"               "### 1. Refuse to close on a flag"
require closing-a-batch "duty 1 checks before the writing duties" "it comes before any other duty writes anything"
require closing-a-batch "a refusal must cost nothing"            "makes a refusal free"
require closing-a-batch "duty 1 checks the flags it declared"   "Check every feature flag **this batch declared**"
require closing-a-batch "an earlier batch's flag goes to duty 5" "A flag declared by an earlier batch is not this duty's business"
require closing-a-batch "duty 5 is empty for a corrective batch" "A corrective batch has nothing to compare here"
require closing-a-batch "released entries are not re-filed"      "do not re-file the released entries as fresh gaps"

# --- using-batches: what a spec says (spec section "The spec document") ---
require using-batches "the test bears on the module boundary"   "bears on the module's boundary"
require using-batches "infrastructure states branches and PRs"  "states branch names and pull requests as rules"
require using-batches "no rewording a mechanism into a rule"    "You do not reword a mechanism into a rule"
require using-batches "lists the laundering signs"              "Four signs recognise it"
require using-batches "a business choice carries its number"    "A business choice carries its number"
require using-batches "vagueness is not prudence"               "Vagueness is not prudence"
require using-batches "a number says where it comes from"       "a decision, or a reading of the code"
require using-batches "structure follows the business"          "structure follows the business"
require using-batches "the ban is on the code's decomposition"   "reproduces the code's internal decomposition"
require using-batches "a boundary concept may gather rules"      "A section carrying a concept observable at the module's boundary"
require using-batches "a glossary is a rule, not a leak"        "Naming is not mechanising"
require using-batches "one normative level, no ranking"         "normative, at the same level"
require using-batches "a module redefines what it borrows"      "redefines what it borrows"
require using-batches "the rule covers the changelog cell"      "including the changelog's \`change\` cell"
require using-batches "the gaps register is out of scope"       "\`docs/specs/<module>.gaps.md\`, which is not a spec"
require using-batches "states the content rule itself"          "business rules and intentions; the mechanism stays in the code"
require using-batches "corollary: a rule outlives a mechanism"  "A rule does not move when a mechanism moves"
require using-batches "corollary: no legislating on quality"    "does not legislate on code quality"
require using-batches "carries the section it points at"        "## What a Spec Says"
require using-batches "the glossary points at that section"     "see \`What a Spec Says\` below"

# --- using-batches: the delta block (spec section "The model") ---
require using-batches "defines the delta block" "**Delta block** — the unit of a batch's spec delta: one targeted section and the exact text"
require using-batches "a block is transcribed word for word" "the exact text it must receive, transcribed word for word by a story"

exit $((FAILURES > 0))
