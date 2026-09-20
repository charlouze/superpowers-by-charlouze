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
require adopting-a-module "ends the review as every gate does"   "never approves and never merges a pull request"
require adopting-a-module "pushes corrections as fixups"         "pushed as a \`fixup!\` commit"
require adopting-a-module "names the merge a clear moment"       "a moment to clear the context"
require adopting-a-module "names the next step after the clear"  "names \`supercharlouze:writing-a-batch\` as the next step"
require adopting-a-module "hands over a self-contained prompt"   "the prompt names the adopted spec by path"
require adopting-a-module "arrives in a context of its own"      "in a context of its own"
require adopting-a-module "the design that follows starts fresh" "from the adopted spec, not from a conversation"
require adopting-a-module "a spilling rule is about the rule's reach" "the signal is the rule's reach"
require adopting-a-module "a spilling rule questions the breakdown" "the breakdown is what is in question"
require adopting-a-module "names the one late signal on a boundary" "One late signal exists, and only one"
require adopting-a-module "the register's gestures include removal"  "the commit that removes it says why"
require adopting-a-module "promoting a gap removes its entry"        "an adoption that promotes a gap into the spec"

# --- writing-a-batch (spec 4, 4.3, 5.2, 8.3) ---
require writing-a-batch "an unadopted module stops the design"   "the design stops"
require writing-a-batch "the human abandons or sets the design aside" "abandon the design or set it aside"
require writing-a-batch "the design resumes in a fresh context"   "resumes in a fresh context"
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

require writing-a-batch "the delta is exact text, in blocks"        "written here as **exact text, in blocks**"
require writing-a-batch "a block carries a unique D<n>"             "Each one carries an identifier \`D<n>\`, unique within the batch"
require writing-a-batch "a block quotes what it replaces"           "quotes the current passage, then the text that replaces it"
require writing-a-batch "no block is attached to a story"           "No block is attached to a story"
require writing-a-batch "two changes to a section are two blocks"   "carries two blocks, and \`Constraints\` states their order"
require writing-a-batch "a lifting is a block removing the sentence" "as a block that removes its gating sentence"
require writing-a-batch "the batch document faces several specs" "the one document that faces several specs at once"
require writing-a-batch "twin blocks are not a delta"        "two blocks writing the same rule into two specs"
# Closing finds an undelivered block from the `Blocks:` declarations, not from what
# reached the specs (spec section "Closing a batch"). The two coincide on the nominal
# path and part exactly where a block was fitted to a `main` that had moved: it was
# transcribed and it was declared, but its text no longer matches the delta.
require writing-a-batch "undelivered means nobody declared it"      "the delta announced and no story declared"

# --- writing-a-batch: the opening review (spec section "Opening a batch") ---
require writing-a-batch "the opening review bears on the exact text" "It bears on the exact text of every block"
require writing-a-batch "the text is read in the batch document"     "block by block, in the batch document"
require writing-a-batch "the PR body puts the block text to the reviewer" "has to rule on: the exact text of every block"
require writing-a-batch "the reread checks quotes against main"          "every quoted passage matching \`main\`"

# --- writing-a-batch: ending the opening and amendment reviews ---
require writing-a-batch "ends the review as every gate does"      "never approves and never merges a pull request"
require writing-a-batch "pushes corrections as fixups"            "pushed as a \`fixup!\` commit"
require writing-a-batch "names the merge a clear moment"          "a moment to clear the context"
require writing-a-batch "opening hands over to the first story"   "names \`supercharlouze:writing-a-user-story\` as the next step"
require writing-a-batch "an amendment is a clear moment too"      "An amendment merges into the same clear moment"

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
require writing-a-user-story "a rule belongs to exactly one spec" "A rule belongs to exactly one spec."
require writing-a-user-story "no ruling houses a rule twice"      "no ruling puts a rule in two places"

# --- writing-a-user-story: what Global Constraints carries (spec section "The user story document") ---
require writing-a-user-story "GC carries the batch Constraints"   "\`Constraints\` section copied verbatim"
require writing-a-user-story "GC carries the spec freeze"         "freeze of the spec file"
require writing-a-user-story "GC carries the authority rule"      "That rule is the third thing \`Global Constraints\` carries"
require writing-a-user-story "the authority rule is stated in full" "the spec wins — without exception and without deliberation"
require writing-a-user-story "GC counts five things"              "carries five things"
require writing-a-user-story "GC carries the fifth stop condition" "the fifth stop condition of Step 5, written out in full"
require writing-a-user-story "GC carries the guarded-code rules"  "carries a fifth thing: the rules for code under a flag"
require writing-a-user-story "the owning batch does not decide"   "whether the flag was declared by this story's batch or by another one"
require writing-a-user-story "GC is the only channel to SDD subagents" "only channel to this skill's rules is this list"

# --- writing-a-user-story: the rules a guarded story copies into Global
# Constraints (spec section "Code under a feature flag") ---
# These needles target text inside a Markdown blockquote, where the file's
# re-wrapping guarantee does not hold: `body_flat` turns newlines into spaces
# but leaves the `> ` prefixes, so a needle spanning a line break there can
# never match. Each needle below must stay within one physical line of the
# block, and re-wrapping that block means revisiting them.
require writing-a-user-story "the flag mechanism is the project's" "Whatever way the project switches its flags"
require writing-a-user-story "both states coexist on the same data" "work side by side on the same data"
require writing-a-user-story "switching off loses nothing"        "with no error and no data loss"
require writing-a-user-story "flag off restores the former behaviour" "With the flag off, the user finds the behaviour"
require writing-a-user-story "both states and their coexistence are tested" "the flag-on behaviour, of the flag-off behaviour, and of their coexistence"
require writing-a-user-story "lifting only removes"               "without writing anything new"

# --- writing-a-user-story: Lifting and Teardown Stories ---
require writing-a-user-story "an observation period is two stories" "the first moves the declared default of the gating sentence from \`off\` to \`on\`"
require writing-a-user-story "declared default is not the effective state" "The declared default and the effective state are two different things"
require writing-a-user-story "only a story changes the declared default" "Only a story changes the declared default"

# --- writing-a-user-story: the story's blocks (spec sections "Story",
# "The user story document", "Delivering a story") ---
require writing-a-user-story "each story chooses its own blocks"  "chooses, as it is written, the blocks of the spec delta it transcribes"
require writing-a-user-story "a block is never shared"            "a block is never shared between two stories"
require writing-a-user-story "the header carries four extra fields" "extend the standard header with four fields"
require writing-a-user-story "the header template declares Blocks"  "**Blocks:** D3, D7"
require writing-a-user-story "Blocks is what closing reads"         "reads to find the blocks nobody delivered"
require writing-a-user-story "Blocks is none when none is taken"    "\`none\` for a story that transcribes none"
require writing-a-user-story "three properties are load-bearing"    "Three properties are load-bearing"
require writing-a-user-story "transcription is word for word"       "exactly as the opening review read it"
require writing-a-user-story "a divergence is named in the PR"      "Every divergence from a block is named in the body of the pull request"
require writing-a-user-story "a divergence has two legitimate causes" "only two legitimate causes"
require writing-a-user-story "a doubtful block stops the story"     "Do not transcribe a text you believe is wrong"
require writing-a-user-story "no divergence amends the batch document" "Neither case amends the batch document"
require writing-a-user-story "ends the review as every gate does"   "never approves and never merges a pull request"
require writing-a-user-story "pushes corrections as fixups"         "pushed as a \`fixup!\` commit"
require writing-a-user-story "names the merge a clear moment"       "a moment to clear the context"
require writing-a-user-story "hands over to the next story"         "names the next story as the next step"

# --- closing-a-batch (spec 4.1, 4.2, 5.4) ---
require closing-a-batch "one changelog line per batch"           "one line per batch"
require closing-a-batch "consolidates Observed drift"            "Observed drift"
# This duty sorts what the stories brought back; it must not read as a definition
# of either category. A fourth wording of "what a gap is" would sit outside the
# `shared` assertion that locks the other three, and drift with nothing to catch it.
require closing-a-batch "sorts story findings, defines nothing"  "whatever a story reported as"
require closing-a-batch "releases unconsumed reservations"       "unconsumed reservations"
require closing-a-batch "records undelivered blocks"             "announced but never delivered"
require closing-a-batch "duty 5 reads the Blocks declarations"   "Read the \`Blocks:\` field of every story document in the batch directory"
require closing-a-batch "a block nobody declared is undelivered" "no collected declaration names is a block announced but never delivered"
require closing-a-batch "the directory holds the merged stories" "holds exactly the batch's merged stories"
require closing-a-batch "reads the declarations, not the specs"  "Read the declarations, not the specs"
require closing-a-batch "refuses to close on an undeclared flag" "no declared scope"
require closing-a-batch "offers three exits"                     "three exits"
require closing-a-batch "sets status closed"                     "status: closed"
require closing-a-batch "closing PR is reviewed"                 "review of the closing pull request"
require closing-a-batch "branch naming convention"               "batch/NN"
require closing-a-batch "ends the review as every gate does"  "never approves and never merges a pull request"
require closing-a-batch "pushes corrections as fixups"        "pushed as a \`fixup!\` commit"
require closing-a-batch "names the merge a clear moment"      "is a moment to clear the context"
# Closing clears like every gate; what it lacks is a next step, so it alone hands
# over no prompt. Two assertions because they are two claims: a skill that dropped
# the second would send an agent inventing a step the model does not have. This is
# the only place either claim is stated — the spec and `using-batches` carry the
# general rule ("where a next step exists…"), which already implies the negative.
require closing-a-batch "has no next step to name"            "no next step to name"
require closing-a-batch "therefore hands over no prompt"      "hands over no prompt"

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
require using-batches "a rule belongs to exactly one spec"  "A rule belongs to exactly one spec."
require using-batches "a shared rule signals the breakdown" "it is a module breakdown asking to be revisited"
require using-batches "a rule outside the specs binds nobody"  "sits beyond everything that makes a spec binding"

# --- using-batches: the delta block (spec section "The model") ---
require using-batches "defines the delta block" "**Delta block** — the unit of a batch's spec delta: one targeted section and the exact text"
require using-batches "a block is transcribed word for word" "the exact text it must receive, transcribed word for word by a story"

# --- using-batches: the shape of a review's end ---
require using-batches "forbids the agent approving or merging" "never approves and never merges a pull request"
require using-batches "pushes corrections as fixups"           "pushed as a \`fixup!\` commit"
require using-batches "the agreement is given in conversation" "The human gives their agreement in the conversation"
require using-batches "names the merge a clear moment"      "a moment to clear the context"
require using-batches "the rule covers every gate"          "Merging any review is a moment to clear the context"
require using-batches "the handover is conditional"         "Where a next step exists"
require using-batches "the handover prompt stands alone"    "That prompt stands on its own"
require using-batches "an unadopted module stops the design"     "the design stops"
require using-batches "Override 1 stays bounded to steps 6 to 9" "still covers steps 6 to 9 and nothing else"

# --- using-batches: guarded code rules (referencing writing-a-user-story) ---
require using-batches "guarded code has rules of its own" "Guarded code has rules of its own, and they travel into the plan"
require using-batches "the guarded-code rules are written in one place" "a second copy of a rule is exactly what drifts"

exit $((FAILURES > 0))
