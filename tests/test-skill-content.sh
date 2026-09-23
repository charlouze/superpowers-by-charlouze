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
# The `sed` drops a leading blockquote marker for the same reason: a norm written
# as a block quote — the four readings of `## The Coherence Reread` are — would
# otherwise flatten with a stray `>` at every line break, and a needle spanning
# two of its lines could never match. No needle in this suite contains `>`.
body_flat() {
    awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$1" \
        | sed 's/^>[[:space:]]\{0,1\}//' | tr '\n' ' ' | tr -s ' '
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
require writing-a-batch "requalifies a technical story" \
    "## Requalifying a Technical Story"
require writing-a-batch "an observable change needs a block" \
    "it needs a block, and a block is acquired by an amendment that goes back through the opening review"
require writing-a-batch "the lost qualification takes the exemption with it" \
    "declares one by that same amendment"
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

# The `Spec delta` field is never blank — it carries blocks, or what stands in
# their place (spec section "The batch document"). A blank is an omission nobody
# can review, exactly as an omitted `Feature flag` would be; the three forms are
# what makes "no block" a statable decision rather than a silence.
require writing-a-batch "the delta field is never left blank"       "The \`Spec delta\` field is never left blank"
require writing-a-batch "the field's three forms are named"         "It carries the blocks; or, when the batch has none, the gaps register entries it reserves, or \`none\` and the reason"
require writing-a-batch "a corrective batch takes the second form"  "A corrective batch takes the second form by definition"
require writing-a-batch "the template forbids a blank delta"        "Never left blank: with no block, the gaps register entries this batch reserves, or \`none\` and the reason"
require writing-a-batch "the document reread checks the field"      "\`Spec delta\` filled"

# --- writing-a-batch: the opening review (spec section "Opening a batch") ---
require writing-a-batch "the opening review bears on the exact text" "It bears on the exact text of every block"
require writing-a-batch "the text is read in the batch document"     "block by block, in the batch document"
require writing-a-batch "the PR body puts the block text to the reviewer" "has to rule on: the exact text of every block"
require writing-a-batch "the reread checks quotes against main"          "every quoted passage matching \`main\`"
# With no block there is no block text to read, and the gate is the same gate
# (spec section "Opening a batch"). What it reads instead is what the field
# carries in their place, so a blockless batch passes the opening review rather
# than passing it by.
require writing-a-batch "a blockless delta still faces the gate" "the review bears on what stands in their place"
require writing-a-batch "what the gate reads in the blocks' place" "the reserved entries, or the reason for the \`none\`"
require writing-a-batch "the PR body carries it to the reviewer" "or, with no block, what stands in their place"

# --- writing-a-batch: the ordered opening, and the two rereads it places ---
# The distinction lives here and not under `## The Coherence Reread`, which speaks
# of the coherence reread and nothing else; the order is what a section title
# cannot carry. The last assertion is the reason the distinction is not cosmetic:
# merged, the batch-document reread is the one that disappears, and a corrective
# batch loses its only reread.
require writing-a-batch "the opening is stated in order"        "Opening a new batch runs these six steps, in this order"
# Step 3 names every field the opening writes (spec section "Opening a batch").
# `Constraints` was the one missing: a step that lists three fields out of four
# reads as exhaustive, and the field it leaves out is the one each story copies
# verbatim into its `Global Constraints`.
require writing-a-batch "step 3 names every field it writes"    "\`Scope\`, \`Spec delta\`, \`Constraints\`, \`Feature flag\`"
require writing-a-batch "the coherence reread is step 5"        "Put the whole spec delta through the coherence reread"
require writing-a-batch "the document reread is step 6"         "Reread the batch document, then open the pull request"
require writing-a-batch "the document reread is named where it runs" "**The batch-document reread**, step 6, comes after the coherence reread"
require writing-a-batch "two rereads, two objects"              "The two rereads are steps 5 and 6, and they have different objects"
require writing-a-batch "the document reread takes the whole document" "bears on the whole document"
require writing-a-batch "merging them strands a corrective batch" "which has no blocks, with no reread at all"

# --- writing-a-batch: the coherence reread (spec section "The coherence reread") ---
# The step exists, the applied state is built outside the repository, the rule it
# must not suspend to get there, what building it catches for free, the
# independence of the context, and the declaration that makes the whole thing
# observable. Drop any one and the section still reads whole while doing less.
require writing-a-batch "the delta goes through the coherence reread" "Before opening, the whole spec delta goes through the **coherence reread**"
# A delta with no block skips this reread (spec section "The coherence reread").
# Not a dispensation: this reread reads blocks against the spec they will change,
# so with no block it has nothing to read. The batch-document reread of step 6 is
# untouched, and it is what still bears on a blockless delta.
require writing-a-batch "a blockless delta skips this reread"    "A delta that carries no block skips this step"
require writing-a-batch "the skip is not a dispensation"         "it has nothing to read and no state to build"
require writing-a-batch "step 5 states the skip where it is ordered" "skipped when the delta carries no block"
require writing-a-batch "the applied state is built outside the repository" "**outside the repository**"
require writing-a-batch "no block reaches a spec before a story"      "no block is written into a spec before a story transcribes it"
require writing-a-batch "a stale block will not apply"                "A block whose quoted passage is no longer in \`main\` will not apply"
require writing-a-batch "the reread is conducted outside this context" "Conduct it outside the context that wrote the blocks"
require writing-a-batch "the pull request body declares the reread"   "The pull request body declares the reread"

# The reader roles. The second assertion is what keeps the count from being
# trimmed: alone, the first reads as a description of a typical reader rather
# than the rule the number of readers follows from.
require writing-a-batch "a reader takes one reading"            "A reader takes one reading, on one touched spec"
require writing-a-batch "the readers follow from the delta"     "one per reading, per touched spec"
require writing-a-batch "never two readings to one reader"      "never hand a reader two"
require writing-a-batch "the dispatch is composed from a template" "references/reader-prompt.md"
# The four readings, in English, in the shipped skill. Nothing else ships them:
# the living spec is this project's own, it is French prose, and a skill running
# on another project cannot reach it — a conductor sent there to fetch a reading
# would find nothing. Each is the text pasted into a reader's prompt, so each is
# guarded on the opening sentence a reader is handed, and the two that follow are
# what stop that text being paraphrased for a human reader of the skill instead.
require writing-a-batch "reading 1: what the change makes false" "What does this change make false elsewhere?"
require writing-a-batch "reading 2: what the change leaves out"  "What does this change leave out?"
require writing-a-batch "reading 3: what a spec must hold"       "Does this specification hold what a specification must hold?"
require writing-a-batch "reading 4: where this sits in the model" "Where does this sit in the model?"
require writing-a-batch "a reading is pasted word for word"      "pasted word for word into the slot the template leaves for it"
require writing-a-batch "a reading is written for a bare reader" "written for a reader that has nothing else"
# The model reading names its own skill, conditionally: a reader on a machine
# without it must still read. Guarded on the reading's text, not on prose about
# it, because the reading is what actually reaches that reader.
require writing-a-batch "the model reading names its skill"     "Use the \`domain-driven-design\` skill if it is available to you"
require writing-a-batch "the model reading survives its absence" "read without it if it is not"
require writing-a-batch "the skill is invoked only if present"  "its skill is invoked only if present"
# Both states, and which one is read. The second assertion is the one that holds:
# a reader handed a diff drifts into reviewing the change block by block, which is
# the batch-document reread, and the passage no block aims at is what goes unseen.
require writing-a-batch "a reader gets both states of the spec" "A reader gets both states, and reads the later one"
require writing-a-batch "the reading stays on the applied state" "The reading itself stays on the applied state, read whole"
require writing-a-batch "a reader is handed no blocks"          "which is also why it is handed no blocks"
# Waiting for every reader, then who revises between two rounds. Without the last
# two, the stop conditions turn on text nobody is said to revise, and the skill
# reads as forwarding raw findings while its conditions presuppose the opposite.
require writing-a-batch "every reader returns before anything goes up" "Every reader returns before anything goes up"
require writing-a-batch "no running report"                     "never a running report"
require writing-a-batch "findings are instructed, not forwarded" "You instruct the findings; you do not forward them"
require writing-a-batch "a round runs on the revised text"       "A round runs on the revised text"
# The four stop conditions: one assertion per condition, one more for the rider
# that decides condition 1's common case, one for the removal half of the same
# condition, and one for the framing sentence. Each condition turns its own
# assertion red when it goes, so the framing sentence is guarded for the other
# end — the prose cannot keep announcing four while the list below it is shorter.
require writing-a-batch "four things stop the rounds"           "Four things stop the rounds"
require writing-a-batch "only an unread state reopens a round"  "A fresh round only on a state the reread has not read"
require writing-a-batch "moving a sentence is an addition"      "moving a sentence is an addition"
require writing-a-batch "a removal reopens what leaned on it"   "a removal reopens what depended on it and nothing else"
require writing-a-batch "two stuck rounds close the wording"    "Two rounds stuck on the same clause close the question of its wording"
require writing-a-batch "a round of declined findings is one too many" "already examined and declined is one round too many"
require writing-a-batch "the reread does not replace the gate"  "prepares the gate, it does not replace it"

# --- writing-a-batch: ending the opening and amendment reviews ---
require writing-a-batch "ends the review as every gate does"      "never approves and never merges a pull request"
require writing-a-batch "pushes corrections as fixups"            "pushed as a \`fixup!\` commit"
require writing-a-batch "names the merge a clear moment"          "a moment to clear the context"
require writing-a-batch "opening hands over to the first story"   "names \`supercharlouze:writing-a-user-story\` as the next step"
require writing-a-batch "an amendment is a clear moment too"      "An amendment merges into the same clear moment"
require writing-a-batch "allocation reads main on the remote" "git ls-tree --name-only origin/main docs/batches/"

# --- writing-a-user-story (spec 3, 4.4, 5.1, 5.3) ---
require writing-a-user-story "branches from main as the remote carries it" "starts from \`main\` as the remote carries it"
require writing-a-user-story "concurrency via declared Sections"  "Sections:"
require writing-a-user-story "a declaration names its spec as well"  "\`Spec:\` names the spec"
require writing-a-user-story "a bounded change names both in its body" "names both in the body of its pull request"
require writing-a-user-story "git conflict is only a partial net" "partial safety net"
require writing-a-user-story "transcription is the first commit"  "first commit on the branch"
require writing-a-user-story "freeze travels in Global Constraints" "Global Constraints"
require writing-a-user-story "freeze ends when the PR opens"      "freeze is lifted when the pull request opens"
require writing-a-user-story "hands off to writing-plans"         "superpowers:writing-plans"
require writing-a-user-story "requires SDD"                       "superpowers:subagent-driven-development"
require writing-a-user-story "constrains finishing to the PR"     "Push and create a Pull Request"
require writing-a-user-story "records rulings before the merge"   "Rulings log"
require writing-a-user-story "records observed drift"             "Observed drift"
require writing-a-user-story "an open ruling has its own form"    "An open ruling is written \`Open ruling:\`"
require writing-a-user-story "an open ruling says what is left"   "ends with what is left to settle, then with the gaps register category"
require writing-a-user-story "answers review feedback"            "review feedback"
require writing-a-user-story "an open ruling needs a destination"  "A story does not merge leaving an open ruling without a destination"
require writing-a-user-story "the review is the last place to act" "do not announce the pull request ready while an open ruling without a destination stands"
require writing-a-user-story "story branch naming convention"     "story/NN"
require writing-a-user-story "spec change states flag and default" "states the flag and its default"
require writing-a-user-story "one lifting story per module"       "one lifting story per guarded module"
require writing-a-user-story "teardown story exists"              "teardown story"
require writing-a-user-story "a technical story declares itself" \
    "**A technical story carries \`Technical: yes\` in its header**"
require writing-a-user-story "a technical story touches no section" \
    "its \`Sections:\` is \`none\`"
require writing-a-user-story "no other story carries that field" \
    "No other story carries that field"
require writing-a-user-story "Blocks none covers the technical story" \
    "a corrective batch's story, a technical story, a teardown story"
require writing-a-user-story "the technical condition hands off to writing-a-batch" \
    "**abandon the story**, then hand the decision to \`supercharlouze:writing-a-batch\`"
require writing-a-user-story "a rule belongs to exactly one spec" "A rule belongs to exactly one spec."
require writing-a-user-story "no ruling houses a rule twice"      "no ruling puts a rule in two places"

# --- writing-a-user-story: what Global Constraints carries (spec section "The user story document") ---
require writing-a-user-story "GC carries the batch Constraints"   "\`Constraints\` section copied verbatim"
require writing-a-user-story "GC carries the spec freeze"         "freeze of the spec file"
require writing-a-user-story "GC carries the authority rule"      "That rule is the third thing \`Global Constraints\` carries"
require writing-a-user-story "the authority rule is stated in full" "the spec wins — without exception and without deliberation"
require writing-a-user-story "GC carries the corrective stop condition" "the stop condition proper to a corrective batch, written out in full"
require writing-a-user-story "GC carries the technical stop condition" "carries a sixth thing: the stop condition proper to a technical story"
require writing-a-user-story "GC lists a sixth item"              "6. **in a technical story only**, the stop condition proper to a technical story"
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
require writing-a-user-story "allocation reads main on the remote" "git ls-tree --name-only origin/main docs/batches/"

# --- closing-a-batch (spec 4.1, 4.2, 5.4) ---
require closing-a-batch "one changelog line per batch"           "one line per batch"
require closing-a-batch "consolidates Observed drift"            "Observed drift"
require closing-a-batch "reads both sections of a story"         "Two sections carry it"
require closing-a-batch "names the Rulings log as a source"      "The **Rulings log** holds its \`Open ruling:\` lines"
require closing-a-batch "consolidates the open rulings too"      "the ones classified as a violation or a gap are yours"
require closing-a-batch "releasing keeps the entry"  "removes the reservation annotation and leaves the entry"
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

# --- using-batches: preconditions for every pull request of this system ---
require using-batches "the directory it runs in does not matter"    "Where you are standing does not matter"

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

# --- using-batches: the technical story (spec section "The model") ---
require using-batches "defines the technical story" \
    "**Technical story** — a story that changes nothing observable at its module's boundary."
require using-batches "the qualification is declared" \
    "a declared qualification, caught by its stop condition if it turns out to be false"
require using-batches "a batch no longer promises behaviour" \
    "It groups several user stories, and targets one or more modules, hence one or more specs."
require using-batches "a technical story has a stop condition too" \
    "you discover that it changes something observable at the module's boundary, stop. The story is no longer technical."
require using-batches "a ruling replaces neither condition" \
    "A ruling replaces neither of them"

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
require using-batches "a bounded change adds and removes entries"  "add an entry and delete one"

# --- using-batches: guarded code rules (referencing writing-a-user-story) ---
require using-batches "guarded code has rules of its own" "Guarded code has rules of its own, and they travel into the plan"
require using-batches "the guarded-code rules are written in one place" "a second copy of a rule is exactly what drifts"

# `Refactor and infrastructure` named a family no `Spec delta` field could carry:
# a batch of that kind has no block, and nothing said what its field held. Nothing
# may name it again — an assertion on the new family alone would stay green beside
# a leftover copy of the old one.
for s in using-batches writing-a-batch; do
    case "$(body_flat "$REPO_ROOT/skills/$s/SKILL.md")" in
        *"Refactor and infrastructure"*) fail "$s: the old exemption family is gone" ;;
        *)                               pass "$s: the old exemption family is gone" ;;
    esac
done

# --- using-batches: the bounded change (spec `Bounded change`) ---
require using-batches "a bounded change may leave the spec silent" \
        "if and only if nothing observable at the module's boundary changes"
require using-batches "a silent bounded change writes no changelog line" \
        "the spec stays silent and no changelog line is written"
require using-batches "a bounded change names the spec it targets" \
        "the spec it targets and the sections it touches"
require using-batches "a bounded change touching no section declares none" \
        "when it touches none"
require using-batches "a changed declaration redoes the detection" \
        "redoes the detection"

exit $((FAILURES > 0))
