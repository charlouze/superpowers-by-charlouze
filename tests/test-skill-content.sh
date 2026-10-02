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
# as a block quote — the readings of `rereading-a-spec` are — would
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
for s in adopting-a-module writing-a-batch writing-a-user-story closing-a-batch recording-a-decision; do
    require "$s" "states the language rule" "English skeleton"
done

# Every document-producing skill sends its writer to the concision rules.
for s in adopting-a-module writing-a-batch writing-a-user-story closing-a-batch recording-a-decision; do
    require "$s" "points at the concision rules" "follows \`Concision\` in \`supercharlouze:using-batches\`"
done

# --- using-batches: concision ---
require using-batches "concision covers every text the flow writes" "hold for every text this flow writes: its documents, its pull request bodies and its commit messages"
require using-batches "one exact thing, once"              "Every sentence says one exact thing, once, and stands on its own"
require using-batches "one rule per paragraph"             "Every paragraph carries one rule"
require using-batches "a rule states its reach"            "A rule says how far it holds, and an exception presents itself as one"
require using-batches "what, not how or why"               "A text says what it delivers or decides, without telling how it got there or why"
require using-batches "the requested reason is the exception" "Exception: the reason this flow explicitly asks for"
require using-batches "nothing set in relief"              "No sentence is set in relief"
require using-batches "the cut test"                       "would a reader who never saw the previous version lose anything if this sentence went?"
require using-batches "too little is as wrong as too much" "Too little is as wrong as too much"
require using-batches "a list does not announce its count" "A list does not announce how many items it holds"

# --- using-batches: conversation ---
require using-batches "conversation follows concision"     "What the agent says to the human follows \`Concision\`"
require using-batches "named by section and change"        "is named by the section it targets and what it changes there, never by its identifier alone"
require using-batches "the identifier may follow"          "The identifier may follow in parentheses"

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
require adopting-a-module "names the next step after the clear"  "name \`supercharlouze:writing-a-batch\` as the next step"
require adopting-a-module "hands over a self-contained prompt"   "the prompt names the adopted spec by path"
require adopting-a-module "arrives in a context of its own"      "in a context of its own"
require adopting-a-module "the design that follows starts fresh" "from the adopted spec, not from a conversation"
require adopting-a-module "a spilling rule is about the rule's reach" "the signal is the rule's reach"
require adopting-a-module "a spilling rule questions the breakdown" "the breakdown is what is in question"
require adopting-a-module "names the one late signal on a boundary" "One late signal exists, and only one"
require adopting-a-module "the register's gestures include removal"  "the commit that removes it says why"
require adopting-a-module "promoting a gap removes its entry"        "an adoption that promotes a gap into the spec"

# --- adopting-a-module: the reread before the pull request ---
require adopting-a-module "the spec goes to the shared reread"            "invoke \`supercharlouze:rereading-a-spec\` on the spec"
require adopting-a-module "a returned mechanism goes to the register"     "File each sentence it returns as a mechanism in the gaps register"
require adopting-a-module "a rule past the boundary stops the adoption"   "A rule it returns as reaching past this module's boundary stops the adoption"
require adopting-a-module "the reread is step 7"                         "### 7. Have the spec reread"
require adopting-a-module "the pull request opens at step 8"             "### 8. Open the adoption pull request"
require adopting-a-module "the rulings go to the pull request body"      "next to its rulings, at the step \`Open the adoption pull request\`"
require adopting-a-module "the red flag names the reread step"          "at the step \`Have the spec reread\`"
# The adoption reread counts neither its readings nor its readers, and names
# the steps it points at rather than giving their rank.
case "$(body_flat "$REPO_ROOT/skills/adopting-a-module/SKILL.md")" in
    *[Tt]"wo readings"*|*[Tt]"wo readers"*|*[Bb]"oth readers"*|*"(step 8)"*|*"readers of step 7"*)
        fail "adopting-a-module: the reread counts no reading and ranks no step" ;;
    *)  pass "adopting-a-module: the reread counts no reading and ranks no step" ;;
esac
require adopting-a-module "an intention comes from a document or the human" "An intention comes from a validated document or from your human partner"

# --- writing-a-batch (spec 4, 4.3, 5.2, 8.3) ---
require writing-a-batch "an unadopted module stops the design"   "the design stops"
# The preconditions are checked before any branch, and not counted: the count
# once said four over a list of three.
require writing-a-batch "preconditions come before any branch"   "Check them all **before creating any branch**"
require writing-a-batch "the human abandons or sets the design aside" "abandon the design or set it aside"
require writing-a-batch "the design resumes in a fresh context"   "resumes in a fresh context"
require writing-a-batch "NN accounts for open pull requests"      "open pull request"
require writing-a-batch "batch document carries no mutable state" "no mutable state"
require writing-a-batch "no story list in the batch document"     "list of stories"
require writing-a-batch "the story list counts pushed branches" "completed by the open pull requests and by the pushed \`story/*\` branches that carry no pull request yet"
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
require writing-a-batch "an amendment covers the design and the constraints" "An amendment changes the scope, the spec delta, the technical design, the constraints or the flag of an open batch"
require writing-a-batch "the entry point names the design and the constraints" "Changing the scope, the spec delta, the technical design, the constraints or the flag of an existing batch"
require writing-a-batch "a design or a constraint that must change is a dead end" "**A batch whose technical design or constraints must change**"
require writing-a-batch "an amendment branch follows no pattern"  "follows none of this plugin's branch patterns"
require writing-a-batch "a delta amendment is reviewed as an opening" "By exception, an amendment that changes the spec delta is reviewed as an opening"
require writing-a-batch "its blocks are applied with every pending block" "apply its new or changed blocks together with every block no merged story has declared yet"
require writing-a-batch "its applied copies go to the shared reread" "invoke \`supercharlouze:rereading-a-spec\` on each applied copy, with the path of the spec it applies to, as \`The Coherence Reread\` does"
require writing-a-batch "its whole document goes through the document reread" "After its rereads, an amendment that changes the spec delta puts the whole document through the batch-document reread"
require writing-a-batch "an amendment goes through the technical reread" "An amendment that changes the spec delta, the technical design or the constraints goes through the technical reread before its pull request opens, after the coherence reread when it runs one"
require writing-a-batch "its technical reread is the opening's" "Conduct it as \`The Technical Reread\` does"
require writing-a-batch "its technical reread reads the pending blocks applied" "on the amended document and on each spec with every block no merged story has declared yet applied"
require writing-a-batch "its technical reread builds the copies itself" "in a copy built as \`The Coherence Reread\` builds it"
require writing-a-batch "a behaviour taken back makes a delta amendment" "A behaviour it returns as taken back to the spec delta makes the amendment one that changes the spec delta"
require writing-a-batch "its body carries what an opening body carries" "the exact text of every new or changed block, and what the coherence reread found"
require writing-a-batch "an amendment releases what it drops" "An amendment that takes a gaps register entry out of \`Scope\` releases its reservation in the same pull request"
require writing-a-batch "the human rules on a constraint a story cannot hold" "**When a story stops on a constraint it cannot hold, your human partner rules on the constraint.**"
require writing-a-batch "an untenable constraint is amended" "If they rule it untenable, an amendment changes or removes the constraint and the story is abandoned"
require writing-a-batch "a story abandoned on a constraint leaves no branch behind" "delete its branch locally and on the remote, and remove its worktree, since a branch left on the remote reads as a live claim on its sections"
require writing-a-batch "a constraint that holds resumes the story" "Otherwise the story resumes and holds the constraint, and nothing is amended."
require writing-a-batch "the red flag keeps the ruling with the human" "Whether a constraint can be held is your human partner's ruling."
require writing-a-batch "an obvious design is still written" "An obvious design is still a design: write it."
require writing-a-batch "requalification offers a different batch" "**Rule the remaining work a different batch**"
require writing-a-batch "requalification releases what the batch drops" "3. **Release the reservations of the entries the batch no longer takes on.**"
require closing-a-batch "an amendment already released what it dropped" "An entry an amendment took out of \`Scope\` is not among them: that amendment released it."
require adopting-a-module "an amendment releases a reservation" "| Release | \`supercharlouze:writing-a-batch\`, in an amendment pull request |"
require writing-a-user-story "abandoning leaves the reservation to the amendment or closing" "the amendment that takes its entry out of \`Scope\` releases it, or \`supercharlouze:closing-a-batch\` does"
require writing-a-user-story "an abandonment leaves closing the reservation no amendment released" "unless an amendment took its entry out of \`Scope\` and released it"
require closing-a-batch "an amendment's release is the one exception" "except an amendment that takes a reserved entry out of \`Scope\` and releases it"
require writing-a-batch "a corrective story is abandoned once ruled" "1. **Leave the story as it stands until the choice below is ruled, then abandon it.**"
require writing-a-batch "an open pull request waits for the ruling" "A pull request already open stays open until then."
require writing-a-batch "a corrective story's remote branch is a live claim" "a branch left on the remote is read as a live claim on its sections by every sibling's concurrency scan"
# Both requalifications live in writing-a-batch; using-batches only routes to it.
require using-batches "the corrective and the technical conditions route to writing-a-batch" "When the corrective or the technical condition fires, you stop, and \`supercharlouze:writing-a-batch\` conducts the requalification"
require writing-a-batch "the patterns are all named"              "\`adopt/<module>\`, \`batch/NN-<slug>\`, \`batch/NN-<slug>-close\`, \`story/NN-us-N-<slug>\`, \`bounded/<slug>\`, \`chore/supercharlouze-init\`"
require writing-a-batch "a pattern name claims what it does not hold" "would claim what it does not hold"
require writing-a-batch "carries the requalification procedure"   "requalification"
require writing-a-batch "requalifies a technical story" \
    "## Requalifying a Technical Story"
require writing-a-batch "an observable change needs a block" \
    "it needs a block, and a block is acquired by an amendment that goes back through the opening review"
require writing-a-batch "the amendment declares the flag the block requires" \
    "The same amendment declares the flag the block requires, if it requires one."
require writing-a-batch "the exemption question is asked again" \
    "Ask the exemption criterion again of the batch with its new block"
require writing-a-user-story "the human rules the block and its flag" \
    "a block for the observable change, and the flag that block requires, if it requires one"
require writing-a-batch "branch naming convention"                "batch/NN"

# --- writing-a-batch: the batch document contract (spec section "The batch document") ---
require writing-a-batch "template declares the Constraints section" "## Constraints"
require writing-a-batch "Constraints are copied verbatim to stories" "copies this section **verbatim** into"
require writing-a-batch "Constraints carry nothing normative"       "Nothing normative goes in \`Constraints\`"
require writing-a-batch "Constraints keep shared decisions from being reinvented" \
    "and its own version of a decision the rest of the design relies on"

require writing-a-batch "the delta is exact text, in blocks"        "written here as **exact text, in blocks**"
require writing-a-batch "a block carries a unique D<n>"             "Each one carries an identifier \`D<n>\`, unique within the batch"
require writing-a-batch "a block shows its change in its paragraph" "A block shows what it changes in the paragraph that contains it"
require writing-a-batch "the paragraph is given as a diff"           "Give the paragraph in a \`diff\` fence"
require writing-a-batch "the paragraph is taken from main"           "take the paragraph from \`main\` as it stands"
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

# The `Spec delta` field is never blank: it carries blocks, or `none` and the
# reason (spec section "The batch document"). A blank is an omission nobody
# can review, exactly as an omitted `Feature flag` would be; the `none` and
# its reason make "no block" a statable decision rather than a silence.
require writing-a-batch "the delta field is never left blank"       "The \`Spec delta\` field is never left blank"
require writing-a-batch "the field carries blocks or none"          "It carries the blocks, or \`none\` and the reason"
require writing-a-batch "a corrective batch lists its entries in Scope" "Its \`Spec delta\` reads \`none\` with that reason, and its \`Scope\` lists the *Violations* entries it takes on"
require writing-a-batch "the template forbids a blank delta"        "Never left blank: with no block, \`none\` and the reason"
require writing-a-batch "the template's Scope names the entries"    "<What this batch delivers, including every gaps register entry it takes on.>"
require writing-a-batch "the template's Constraints are bounded"    "<Only the migration and compatibility constraints, the technical decisions the rest of the technical design relies on, and the required order of the stories and of the blocks."
# A technical decision is a constraint only when the rest of the technical design
# relies on it (spec section "The batch document"); every other one is design.
require writing-a-batch "a decision is a constraint only if the design relies on it" \
    "A technical decision goes in \`Constraints\` only if the rest of the technical design relies on it"
require writing-a-batch "every other decision is design" \
    "Every other technical decision goes in \`Technical design\`, where a story may depart from it."
require writing-a-batch "the document reread checks the widened Constraints" \
    "\`Constraints\` carrying only migration and compatibility constraints, the technical decisions the rest of the technical design relies on, and the required order of stories and blocks, or \`none\`"
require writing-a-batch "the PR body puts the constraints to the reviewer" \
    "the technical design, or the reason for its \`none\`; the constraints; the flag decision;"
require writing-a-batch "the document reread checks the field"      "\`Spec delta\` filled"
# The batch document carries the technical design of its stories (spec section
# "The batch document"): between the delta and the constraints, never blank.
require writing-a-batch "the template places the design after the delta" \
    "with no block, \`none\` and the reason.> ## Technical design <The design your human partner approved during the brainstorming"
require writing-a-batch "the template places the design before the constraints" \
    "with no design, \`none\` and the reason.> ## Constraints"
require writing-a-batch "the design field is never left blank" \
    "Never left blank: with no design, \`none\` and the reason"
require writing-a-batch "the design comes from the brainstorming" \
    "\`Technical design\` carries the design your human partner approved during \`superpowers:brainstorming\`"
require writing-a-batch "a story may depart from the design" \
    "a story may depart from it by recording a \`Technical design ruling:\`"
require writing-a-batch "an observable behaviour is a block, not design" \
    "What a user or a neighbouring module would observe goes in a block, never in \`Technical design\`."
require writing-a-batch "the document reread checks the design field" \
    "\`Technical design\` filled, with the design or with \`none\` and the reason"
require writing-a-batch "the PR body puts the design to the reviewer" \
    "the technical design, or the reason for its \`none\`;"

# --- writing-a-batch: the opening review (spec section "Opening a batch") ---
require writing-a-batch "the opening review bears on the exact text" "It bears on the exact text of every block"
require writing-a-batch "the text is read in the batch document"     "block by block, in the batch document"
require writing-a-batch "the PR body puts the block text to the reviewer" "has to rule on: the exact text of every block"
# With no block there is no block text to read, and the gate is the same gate
# (spec section "Opening a batch"). What it reads instead is the reason for
# the `none` and the entries `Scope` takes on, so a blockless batch passes
# the opening review rather than passing it by.
require writing-a-batch "a blockless delta still faces the gate" "the review bears on what stands in their place"
require writing-a-batch "what the gate reads in the blocks' place" "the reason for the \`none\`, and the entries \`Scope\` takes on"
require writing-a-batch "the PR body carries it to the reviewer" "the exact text of every block, or the reason for the \`none\`"

# --- writing-a-batch: the ordered opening, and the rereads it places ---
# The distinction lives here and not under `## The Coherence Reread`, which speaks
# of the coherence reread and nothing else; the order is what a section title
# cannot carry. The last assertion is the reason the distinction is not cosmetic:
# merged, the batch-document reread is the one that disappears, and a corrective
# batch loses the reread of its document.
require writing-a-batch "the opening is stated in order"        "Opening a new batch runs these steps, in this order"
# Step 3 names every field the opening writes (spec section "Opening a batch").
# `Constraints` was the one missing: a step that lists three fields out of four
# reads as exhaustive, and the field it leaves out is the one each story copies
# verbatim into its `Global Constraints`.
require writing-a-batch "step 3 names every field it writes"    "3. **Write the batch document**: \`Scope\`, \`Spec delta\`, \`Technical design\`, \`Constraints\`, \`Feature flag\`"
require writing-a-batch "the document reread names every field" "The batch-document reread bears on the whole document: \`Scope\`, \`Spec delta\`, \`Technical design\`, \`Constraints\`, \`Feature flag\`."
require writing-a-batch "the coherence reread is step 5"        "Put the whole spec delta through the coherence reread"
require writing-a-batch "the technical reread is step 6"        "6. **Put the technical design and the constraints through the technical reread** — skipped when the batch has neither (\`The Technical Reread\`)."
require writing-a-batch "the document reread is step 7"         "7. **Reread the whole batch document**"
require writing-a-batch "the pull request is step 8"            "8. **Open the pull request** from \`batch/NN-<slug>\`"
require writing-a-batch "the document reread is named where it runs" "**The batch-document reread**, step 7, comes after the technical reread"
require writing-a-batch "each reread has its own object"        "The rereads are steps 5, 6 and 7, and each has its own object"
require writing-a-batch "the technical reread's object is stated" "The technical reread bears on the technical design and the constraints, against the specs with the blocks applied and against the code on \`main\`."
require writing-a-batch "the document reread takes the whole document" "bears on the whole document"
# The context that wrote the document rereads its own intentions, exactly as it
# would the blocks, so the batch-document reread leaves it too.
require writing-a-batch "the document reread is conducted outside this context" "Conduct it outside the context that wrote the document, by dispatching a subagent"
require writing-a-batch "merging them strands a corrective batch" "leaving a corrective batch, which has no blocks, without a reread of its document"

# --- writing-a-batch: the coherence reread (spec section "The coherence reread") ---
# The step exists, the applied state is built outside the repository, the rule it
# must not suspend to get there, what building it catches for free, the
# independence of the context, and the declaration that makes the whole thing
# observable. Drop any one and the section still reads whole while doing less.
require writing-a-batch "the delta goes through the coherence reread" "Before opening, the whole spec delta goes through the **coherence reread**"
# A delta with no block skips this reread (spec section "The coherence reread").
# Not a dispensation: this reread reads blocks against the spec they will change,
# so with no block it has nothing to read. The batch-document reread of step 7 is
# untouched, and it is what still bears on a blockless delta.
require writing-a-batch "a blockless delta skips this reread"    "A delta that carries no block skips this step"
require writing-a-batch "the skip is not a dispensation"         "it has nothing to read and no state to build"
require writing-a-batch "step 5 states the skip where it is ordered" "skipped when the delta carries no block"
require writing-a-batch "the applied state is built outside the repository" "**outside the repository**"
require writing-a-batch "no block reaches a spec before a story"      "no block is written into a spec before a story transcribes it"
# Building the applied copy checks every block, so that check belongs to the
# coherence reread; the batch-document reread bears on the fields.
require writing-a-batch "building the copy checks every block"     "Building that copy checks every block: it carries its \`D<n>\`, it names the spec and section it targets"
require writing-a-batch "a block matches main or the block before it" "its unchanged and removed lines match \`main\`, or the text the block ordered before it leaves"
require writing-a-batch "a stale block will not apply"                "A block that fails this check does not apply"
# The readers, their readings and the rounds live in `supercharlouze:rereading-a-spec`.
# The coherence reread hands over each applied copy, and carries back what the
# reread returns. What a reader gets is the reread's business, not this skill's.
require writing-a-batch "each applied copy goes to the shared reread" "invoke \`supercharlouze:rereading-a-spec\` on each applied copy, with the path of the spec it applies to"
require writing-a-batch "revisions go back into the blocks"        "Carry every revision it returns back into the blocks"
require writing-a-batch "a boundary rule stops the opening"        "A rule it returns as reaching past its module's boundary stops the opening"
require writing-a-batch "the pull request body says what the reread found" "The pull request body says what the reread found, or that it found nothing"

# --- writing-a-batch: the technical reread (spec section "The technical reread") ---
# The step exists, what it skips, what it hands the shared reread, where its
# revisions go, and the declaration that makes it observable.
require writing-a-batch "the design goes through the technical reread" "the technical design and the constraints go through the **technical reread**"
require writing-a-batch "a batch with neither skips it"         "A batch whose \`Technical design\` and \`Constraints\` both read \`none\` skips this step"
require writing-a-batch "the batch goes to the technical reread" "Invoke \`supercharlouze:rereading-a-technical-design\` with the batch document and each spec the batch touches"
require writing-a-batch "a spec no block targets goes as it is" "the applied copy the coherence reread built, or the spec itself when no block targets it"
require writing-a-batch "revisions go back into the design"     "Carry every revision it returns back into \`Technical design\` and \`Constraints\`"
# The technical reread reads the delta and never writes into it: a block is a
# design decision, and it goes back through the opening from the delta on.
require writing-a-batch "the technical reread changes no spec delta" "The technical reread never changes \`Spec delta\`, and sends nothing back through the coherence reread."
require writing-a-batch "a behaviour taken back restarts the delta" "A behaviour it returns as taken back to the spec delta sends the opening back to step 5, with the block your human partner rules."
# The two rereads never run side by side.
require writing-a-batch "the technical reread waits for the coherence reread" "**Start it only once the coherence reread has closed its rounds.** Run side by side, each reread revises what the other is reading"
require writing-a-batch "red flag: both rereads together"         "| \"The rereads read different things, I'll run them together\" | Each revises what the other is reading."
require writing-a-batch "the pull request body says what it found" "The body of the pull request that runs it, opening or amendment, says what it found, or that it found nothing"
require writing-a-batch "the red flag sends the design to the reread" "Invoke \`supercharlouze:rereading-a-technical-design\`. |"

# --- rereading-a-spec (spec sections "Module adoption" and "The coherence reread") ---
# Outside the context that wrote the text, whichever state the spec is in.
require rereading-a-spec "the reread runs outside the writing context" "outside the context that wrote it, by readers dispatched as subagents"
# It is a building block: it knows none of the skills that invoke it, and its
# input and its output say everything they need.
require rereading-a-spec "it is invoked by a skill"                    "It is invoked by another skill, never on a request of your human partner"
require rereading-a-spec "input: the spec and its path"                "the spec to read, and the path it has or will have under \`docs/specs/\`"
require rereading-a-spec "the state is read from main"                 "The spec is new when \`main\` carries no file at that path, and changed otherwise"
require rereading-a-spec "output: the spec revised"                    "the spec, revised: every finding worked through, and every ruling of your human partner applied"
require rereading-a-spec "output: mechanisms come back as gaps"        "the sentences taken out because they describe a mechanism, each with the section it came from"
require rereading-a-spec "output: boundary rules come back unrevised"  "the rules left as they are because they would constrain behaviour observable at the boundary of more than one module"
require rereading-a-spec "output: what the reread found"               "what the reread found, or that it found nothing"
# How a finding is worked through lives here, not in whoever invoked the reread.
require rereading-a-spec "a mechanism leaves the spec"                 "A sentence that describes a mechanism leaves the spec"
require rereading-a-spec "a boundary rule is not revised"              "the module breakdown is your human partner's decision, not a wording"
require rereading-a-spec "any other finding is fixed or put up"        "Any other finding is fixed without changing what its sentence rules, or put to your human partner when fixing it would"

# The reader roles. The second assertion is what keeps the count from being
# trimmed: alone, the first reads as a description of a typical reader rather
# than the rule the number of readers follows from.
require rereading-a-spec "a reader takes one reading"            "A reader takes one reading, on one spec"
require rereading-a-spec "the readers follow from the state"     "one per reading that applies to its state, per spec"
require rereading-a-spec "never two readings to one reader"      "never hand a reader two"
require rereading-a-spec "the dispatch is composed from a template" "skills/rereading-a-spec/references/reader-prompt.md"
# A reader runs on the conductor's model, named in the dispatch: a harness may
# give subagents a lighter default, and a lighter reader misses findings.
require rereading-a-spec "a reader gets where the other specs live" "the directory where the project's other specifications live"
require rereading-a-spec "a reader runs on the conductor's model" "Dispatch every reader on the model you run on, and name that model in the dispatch"
# Which readings a state gets: a new spec keeps the questions the adoption asked.
require rereading-a-spec "a changed spec gets every reading"     "A changed spec gets every reading"
# A new spec gets the readings that bear on a specification rather than on a
# change, the model reading among them, and they are named one by one.
require rereading-a-spec "a new spec gets the rule, concision and model readings" "A new spec gets *Does this specification hold what a specification must hold?*, *Is this specification precise and concise?* and *Where does this sit in the model?*"
# The readings, in English, in the shipped skill. Nothing else ships them:
# the living spec is this project's own, it is French prose, and a skill running
# on another project cannot reach it — a conductor sent there to fetch a reading
# would find nothing. Each is the text pasted into a reader's prompt, so each is
# guarded on the opening sentence a reader is handed, and the two that follow are
# what stop that text being paraphrased for a human reader of the skill instead.
require rereading-a-spec "reading: what the change makes false" "**What does this change make false elsewhere?**"
require rereading-a-spec "reading: what the change leaves out"  "**What does this change leave out?**"
require rereading-a-spec "reading: what a spec must hold"       "**Does this specification hold what a specification must hold?**"
require rereading-a-spec "reading: precise and concise"         "**Is this specification precise and concise?**"
require rereading-a-spec "reading: where this sits in the model" "**Where does this sit in the model?**"
require rereading-a-spec "the concision reading carries its rules" "Every paragraph carries one rule"
require rereading-a-spec "the concision reading reads what is under review" "every sentence of a new specification, every sentence the change brings to a changed one"
# The rule reading carries the tempering clauses of the spec document, so a reader
# does not report a correct sentence.
require rereading-a-spec "a rule may name the section it rules"  "A rule that constrains several behaviours lives in a section named after what it rules"
require rereading-a-spec "a glossary entry can state a rule"     "A glossary that binds a domain concept, and only a domain concept, to the name the code and the interface carry states a rule"
require rereading-a-spec "a declared aside is not normative"     "A passage marked by the project's declared aside convention is not normative"
require rereading-a-spec "the rule reading's last own sentence"  "names that specification"
require rereading-a-spec "the concision reading's last own sentence" "so does a vague word where a concrete rule belongs"
# No sentence counts the readings: a count says nothing the list does not, and
# goes false the day a reading is added or removed.
case "$(body_flat "$REPO_ROOT/skills/rereading-a-spec/SKILL.md" 2>/dev/null || true)" in
    *[Tt]"wo readings"*|*[Tt]"hree readings"*|*[Ff]"our readings"*|*[Ff]"ive readings"*|*[Ss]"ix readings"*|*[Tt]"wo readers"*|*[Bb]"oth readers"*|*[Ff]"our things"*|*"different motions"*|*"answers none of the first"*)
        fail "rereading-a-spec: no sentence counts the readings" ;;
    *)  pass "rereading-a-spec: no sentence counts the readings" ;;
esac
require rereading-a-spec "a reading is pasted word for word"      "pasted word for word into the slot the template leaves for it"
require rereading-a-spec "a reading is written for a bare reader" "written for a reader that has nothing else"
# The model reading names its own skill, conditionally: a reader on a machine
# without it must still read. Guarded on the reading's text, not on prose about
# it, because the reading is what actually reaches that reader.
require rereading-a-spec "the model reading names its skill"     "Use the \`domain-driven-design\` skill if it is available to you"
require rereading-a-spec "the model reading survives its absence" "read without it if it is not"
require rereading-a-spec "the skill is invoked only if present"  "its skill is invoked only if present"
# A reading done without its skill is a weaker reading: the reader says so, and
# the human hears it, since installing the skill is theirs to do.
require rereading-a-spec "the model reader reports a missing skill" "read without it if it is not, and say so at the top of your report"
require rereading-a-spec "the human hears of a missing skill"    "tell your human partner that \`domain-driven-design\` is not available, so they can install it"
require rereading-a-spec "the model reading comes last"          "The model reading comes last"
# The order itself: no other reading's opening sentence follows the model reading.
# Read on the readings alone, the quoted lines that open on a bold question: the
# prose that names the readings a new spec gets cites them in its own order.
READINGS="$(grep -E '^> \*\*' "$REPO_ROOT/skills/rereading-a-spec/SKILL.md" 2>/dev/null | tr '\n' ' ' || true)"
case "$READINGS" in
    *"Where does this sit in the model?"*"make false elsewhere?"*|\
    *"Where does this sit in the model?"*"leave out?"*|\
    *"Where does this sit in the model?"*"hold what a specification must hold?"*|\
    *"Where does this sit in the model?"*"precise and concise?"*)
        fail "rereading-a-spec: the model reading is the last one" ;;
    *)  pass "rereading-a-spec: the model reading is the last one" ;;
esac
# Both states, and which one is read. The second assertion is the one that holds:
# a reader handed a diff drifts into reviewing the change piece by piece, and the
# passage no change aims at is what goes unseen.
require rereading-a-spec "a reader of a changed spec gets both states" "A reader of a changed spec gets both states, and reads the later one"
require rereading-a-spec "the reading stays on the applied state" "The reading itself stays on the applied state, read whole"
# Waiting for every reader, then who revises between two rounds. Without the last
# two, the stop conditions turn on text nobody is said to revise, and the skill
# reads as forwarding raw findings while its conditions presuppose the opposite.
require rereading-a-spec "every reader returns before anything goes up" "Every reader returns before anything goes up"
require rereading-a-spec "no running report"                     "never a running report"
require rereading-a-spec "findings are instructed, not forwarded" "You instruct the findings; you do not forward them"
# A defect the change did not write is returned and left alone. Fixed in the
# reread, it widens what the human reviews; left to every round, it comes back
# with each of them.
require rereading-a-spec "a defect already on main is not fixed"  "A defect the spec already carries on \`main\` is not fixed: the change did not write that passage, and fixing it widens what your human partner reviews"
require rereading-a-spec "a defect already on main opens no round" "It goes once into what the reread found, and opens no round"
require rereading-a-spec "red flag: an old passage"               "| \"The reader is right about this old passage, I'll fix it too\" | The change did not write it."
require rereading-a-spec "a round runs on the revised text"       "A round runs on the revised text"
# The stop conditions themselves are spelled alike in both rereads, and guarded
# once over both in test-skill-contracts.sh. Here: that they exist, the red flags
# that answer the excuses, and the one condition whose wording is this skill's.
require rereading-a-spec "the rounds have stop conditions"        "These stop the rounds"
require rereading-a-spec "red flag: one more round"               "| \"One more round, the wording can still improve\" | The third round is the last you open."
require rereading-a-spec "red flag: a section rewritten whole"    "| \"This section reads better rewritten whole\" | A rewritten section is unread, and sends every reading out again."
require rereading-a-spec "red flag: a reworded clause"            "| \"I reworded the clause, so this finding is a new one\" | A finding is its problem, not its words."
require rereading-a-spec "the reread does not replace the review"  "prepares the review of the pull request that carries the spec, it does not replace it"

# --- rereading-a-technical-design (spec section "The technical reread") ---
# Outside the context that wrote the design and the constraints.
require rereading-a-technical-design "the reread runs outside the writing context" "outside the context that wrote them, by readers dispatched as subagents"
require rereading-a-technical-design "it is invoked by a skill"          "It is invoked by another skill, never on a request of your human partner"
# Its input and its output say everything a caller needs, as for the spec reread.
require rereading-a-technical-design "input: the batch and its applied specs" "The input is the batch document, and each spec the batch touches with the batch's blocks applied"
require rereading-a-technical-design "the readers read main's code"     "The readers read the code as \`main\` carries it"
require rereading-a-technical-design "output: the design revised"        "the technical design and the constraints, revised: every finding worked through, and every ruling of your human partner applied"
require rereading-a-technical-design "output: the behaviours taken back to the delta" "the behaviours your human partner took back to the spec delta, which ended the reread"
require rereading-a-technical-design "the reread writes no block" "It leaves the design, or your human partner takes the batch back to its spec delta and the reread ends: this reread writes no block."
require rereading-a-technical-design "red flag: writing the block" "| \"The design needs this rule, I'll write the block\" | This reread writes no block."
require rereading-a-technical-design "output: what the reread found"     "what the reread found, or that it found nothing, written for a pull request body"
# One reader per reading, dispatched from a template.
require rereading-a-technical-design "a reader takes one reading"        "A reader takes one reading"
require rereading-a-technical-design "never two readings to one reader"  "never hand a reader two"
require rereading-a-technical-design "the dispatch is composed from a template" "skills/rereading-a-technical-design/references/reader-prompt.md"
require rereading-a-technical-design "every batch gets every reading"    "Every batch gets every reading"
require rereading-a-technical-design "a reading is pasted word for word" "pasted word for word into the slot the template leaves for it"
require rereading-a-technical-design "a reading is written for a bare reader" "written for a reader that has nothing else"
# The readings the batch document names: coverage, anchoring in the code,
# architecture, module design, robustness.
require rereading-a-technical-design "reading: coverage"       "**Does the design deliver what the batch promises?**"
require rereading-a-technical-design "reading: the code"       "**Does the design stand on the code as it is?**"
require rereading-a-technical-design "reading: architecture"   "**Does the design hold as an architecture?**"
require rereading-a-technical-design "reading: module design"  "**Are the modules this design draws deep?**"
require rereading-a-technical-design "reading: robustness"     "**How does this design fail?**"
require rereading-a-technical-design "coverage reports undescribed behaviour" "a behaviour the design would make observable to a user or a neighbouring module that no specification describes"
require rereading-a-technical-design "the code reading checks the constraints" "and a constraint the code already breaks"
require rereading-a-technical-design "robustness reports a constraint nobody can hold" "a constraint that a story could not hold"
# The skills the readers use are recommended, never required.
require rereading-a-technical-design "architecture names its skill"      "Use the \`clean-architecture\` skill if it is available to you"
require rereading-a-technical-design "module design names its skill"     "Use the \`software-design-philosophy\` skill if it is available to you"
require rereading-a-technical-design "a reader says it read without"     "read without it if it is not, and say so at the top of your report"
require rereading-a-technical-design "the skills are invoked only if present" "invoke their skill only if present"
require rereading-a-technical-design "the human hears of a missing skill" "tell your human partner that the skill is not available, so they can install it"
case "$(body_flat "$REPO_ROOT/skills/rereading-a-technical-design/SKILL.md" 2>/dev/null || true)" in
    *[Ff]"ive readings"*|*[Ff]"ive readers"*|*"of the five"*)
        fail "rereading-a-technical-design: no sentence counts the readings" ;;
    *)  pass "rereading-a-technical-design: no sentence counts the readings" ;;
esac
# Findings are instructed, and what changes a decision goes to the human, who
# approved the design.
require rereading-a-technical-design "findings are instructed, not forwarded" "You instruct the findings; you do not forward them"
require rereading-a-technical-design "a fix keeps what the design decides" "Fix each one on the technical design or the constraints without changing what they decide, or put it to your human partner when fixing it would"
require rereading-a-technical-design "an undescribed behaviour always goes up" "A behaviour the design would make observable that no specification describes is always put to your human partner"
require rereading-a-technical-design "a round runs on the revised text"  "A round runs on the revised text"
require rereading-a-technical-design "the rounds have stop conditions"   "These stop the rounds"
require rereading-a-technical-design "red flag: one more round"          "| \"One more round, the design can still improve\" | The third round is the last you open."
require rereading-a-technical-design "red flag: a section rewritten whole" "| \"This section reads better rewritten whole\" | A rewritten section is unread, and sends every reading out again."
require rereading-a-technical-design "red flag: a reworded clause"       "| \"I reworded the clause, so this finding is a new one\" | A finding is its problem, not its words."
require rereading-a-technical-design "the reread does not replace the review" "prepares the review of the pull request that carries the design, it does not replace it"

# --- recording-a-decision ---
# A building block: it writes the ADR its human partner decided, and decides
# nothing itself.
require recording-a-decision "it is invoked by a skill" "It is invoked by another skill, never on a request of your human partner"
require recording-a-decision "an ADR is a file directly in docs/adr" "a \`.md\` file placed directly in \`docs/adr/\`"
require recording-a-decision "the human has decided before it runs" "Your human partner has decided it before this skill runs: without their decision, write nothing."
require recording-a-decision "a deletion does not come through it" "Deleting an ADR, and correcting its text without changing its decision, do not come through this skill"
require recording-a-decision "a correction that changes the decision is a rewrite" "A correction that changes the decision is a rewrite, and does."
require recording-a-decision "input: the decision and its reason" "the decision and its reason;"
require recording-a-decision "input: the ADR to rewrite" "the path of the ADR to rewrite, when there is one;"
require recording-a-decision "input: the spec copies handed over" "copies of specs to read in place of the files under \`docs/specs/\`, when the skill that invokes this one hands some"
require recording-a-decision "output: the path or the ruling" "Return the path of the file written, or what your human partner ruled when nothing is written"
require recording-a-decision "it works on the current branch" "Follow these steps on the branch you are working on"
require recording-a-decision "step 1 reads the ADRs and the specs" "1. Read every ADR in \`docs/adr/\` and every spec in \`docs/specs/\`"
require recording-a-decision "a handed copy replaces its spec" "Where you were handed a copy of a spec, read the copy"
require recording-a-decision "step 2 stops on a contradiction or a boundary rule" "2. When the decision contradicts a spec or another ADR, or is observable at a module's boundary, say so to your human partner and write nothing until they have ruled"
require recording-a-decision "step 3 writes from the template" "3. Write the file from \`skills/recording-a-decision/references/adr-template.md\`, creating \`docs/adr/\` if it does not exist"
require recording-a-decision "a rewrite happens in place" "A rewrite replaces the text at the path you were given"
require recording-a-decision "it does not commit" "Do not commit: the skill that invoked this one does."
require recording-a-decision "a rewrite's commit says why" "The commit that rewrites an ADR says why"
require recording-a-decision "red flag: wording around a contradiction" "| \"The decision contradicts a spec, I'll word the ADR so it fits\" | A reworded contradiction is still one. Say so to your human partner, and write nothing until they have ruled. |"
require recording-a-decision "red flag: a status line" "| \"Every ADR has a date and a status, I'll add them\" | An ADR of this flow carries neither. The file states what holds now. |"
require recording-a-decision "red flag: superseding" "| \"The old decision is worth keeping, I'll mark it superseded\" | Rewrite in place. Git history keeps the old text, and the commit says why it changed. |"
require recording-a-decision "red flag: committing" "| \"The file is written, I'll commit it\" | The skill that invoked this one commits. |"
require recording-a-decision "step 2 gives its reason" "An ADR contradicts neither a spec nor another ADR, and what is observable at a module's boundary is a rule of that module's spec, which only your human partner changes."
require recording-a-decision "the section titles are skeleton" "The section titles \`Considered options\` and \`Consequences\` are skeleton."
require recording-a-decision "a new ADR goes to its slug" "A new ADR goes to \`docs/adr/<slug>.md\`"
require recording-a-decision "the title, the sentences and the slug are prose" "The title, the sentences and the file's slug are prose"
require recording-a-decision "red flag: a decision observable at the boundary" "| \"This decision shows at the module's boundary, but an ADR is quicker than a spec change\" | What is observable at a module's boundary is a rule of its spec. Say so to your human partner. |"

# The template carries neither a date nor a status, in any spelling.
ADR_TEMPLATE="$REPO_ROOT/skills/recording-a-decision/references/adr-template.md"
if [ ! -f "$ADR_TEMPLATE" ]; then
    fail "recording-a-decision: the template carries no date and no status (no template)"
elif grep -qiE 'date|status|statut' "$ADR_TEMPLATE"; then
    fail "recording-a-decision: the template carries no date and no status"
else
    pass "recording-a-decision: the template carries no date and no status"
fi
for needle in "## Considered options" "## Consequences" "One to three sentences that state the decision and its reason" "Optional. The alternatives this decision settles between" "Optional. What the decision rules out or makes harder"; do
    if [ -f "$ADR_TEMPLATE" ] && grep -qF "$needle" "$ADR_TEMPLATE"; then
        pass "recording-a-decision: the template carries: $needle"
    else
        fail "recording-a-decision: the template carries: $needle"
    fi
done

# --- writing-a-batch: ending the opening and amendment reviews ---
require writing-a-batch "ends the review as every gate does"      "never approves and never merges a pull request"
require writing-a-batch "pushes corrections as fixups"            "pushed as a \`fixup!\` commit"
require writing-a-batch "names the merge a clear moment"          "a moment to clear the context"
require writing-a-batch "the merged document carries the design too" \
    "the exact text of every block and the technical design, which is what the design conversation was for"
require writing-a-batch "opening hands over to the first story"   "name \`supercharlouze:writing-a-user-story\` as the next step"
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
# The plan starts from the batch's technical design, and every departure is a
# technical design ruling (spec section "Delivering a story").
require writing-a-user-story "the plan starts from the technical design" \
    "**The plan starts from the batch's \`Technical design\`**, and its \`Architecture:\` line derives from it."
require writing-a-user-story "an ADR wins over the design, then main's code" \
    "Exceptions: where an ADR contradicts the design, the plan follows the ADR; elsewhere, where the code on \`main\` has departed from the design, as an earlier story of the batch may have, the plan starts from the code."
require writing-a-user-story "the plan reads docs/adr in the story's worktree" \
    "Read every ADR in \`docs/adr/\`, in this story's worktree, before writing the plan"
require writing-a-user-story "no design, nothing to start from" \
    "A batch whose \`Technical design\` is \`none\` gives the plan nothing to start from."
# Every departure, the plan's as well as the execution's, is recorded at Step 6.
require writing-a-user-story "step 6 records every departure from the design" \
    "Write as a \`Technical design ruling:\`, with the three parts of a \`Ruling:\`, every departure from the batch's \`Technical design\` that the plan or the execution took, except where the plan follows an ADR or the code on \`main\`."
require writing-a-user-story "answers review feedback"            "review feedback"
require writing-a-user-story "an open ruling needs a destination"  "A story does not merge leaving an open ruling without a destination"
require writing-a-user-story "the review is the last place to act" "do not announce the pull request ready while an open ruling without a destination stands"
require writing-a-user-story "story branch naming convention"     "story/NN"
require writing-a-user-story "spec change states flag and default" "states the flag and its default"
require writing-a-user-story "the gating sentence follows the story's module" "If the batch declares a feature flag for this story's module"
require writing-a-user-story "one lifting story per module"       "one lifting story per guarded module"
require writing-a-user-story "teardown story exists"              "teardown story"
require writing-a-user-story "a technical story declares itself" \
    "**A technical story carries \`Technical: yes\` in its header**"
require writing-a-user-story "a technical story touches no section" \
    "its \`Sections:\` is \`none\`"
require writing-a-user-story "no other story carries that field" \
    "No other story carries that field"
require writing-a-user-story "the technical condition hands off to writing-a-batch" \
    "**the story is abandoned**, and the decision goes to \`supercharlouze:writing-a-batch\`"
# A corrective story is abandoned once the requalification is ruled, not when it
# stops: an open pull request stays open until then.
require writing-a-user-story "a corrective story is abandoned once ruled" \
    "In a corrective batch, the story is abandoned once the requalification is ruled: a pull request already open is closed without merging then, not when you stop."
require writing-a-user-story "a rule belongs to exactly one spec" "A rule belongs to exactly one spec."
require writing-a-user-story "no ruling houses a rule twice"      "no ruling puts a rule in two places"

# --- writing-a-user-story: what Global Constraints carries (spec section "The user story document") ---
require writing-a-user-story "GC carries the batch Constraints"   "\`Constraints\` section copied verbatim"
require writing-a-user-story "GC carries the spec freeze"         "freeze of the spec file"
require writing-a-user-story "GC carries the authority rule"      "That rule is the authority rule \`Global Constraints\` carries"
require writing-a-user-story "the authority rule is stated in full" "the spec wins — without exception and without deliberation"
require writing-a-user-story "GC carries the corrective stop condition" "the stop condition proper to a corrective batch, written out in full"
require writing-a-user-story "GC lists the concision rules"       "- the concision rules;"
require writing-a-user-story "GC carries the concision rules"     "In every story, \`Global Constraints\` carries the concision rules, written out in full"
require writing-a-user-story "the concision block names what it covers" "These rules hold for every document, pull request body and commit message this story writes"
require writing-a-user-story "GC carries the guarded-code rules"  "carries the rules for code under a flag, written out in full"
require writing-a-user-story "GC carries the technical stop condition" "carries the stop condition proper to a technical story, written out in full"
require writing-a-user-story "GC lists the technical stop condition" "- **in a technical story only**, the stop condition proper to a technical story"
require writing-a-user-story "GC lists the stop condition on a constraint or an ADR" \
    "- **only if the batch declares constraints or \`docs/adr/\` carries an ADR**, the stop condition on a constraint or an ADR that cannot be held"
require writing-a-user-story "GC carries the stop condition on a constraint or an ADR" \
    "**In a story whose batch declares constraints, or whose \`docs/adr/\` carries an ADR, \`Global Constraints\` carries the stop condition on a constraint or an ADR that cannot be held, written out in full.**"
require writing-a-user-story "a batch declares constraints when they are not none" \
    "A batch declares constraints when its \`Constraints\` section is not \`none\`."
require writing-a-user-story "docs/adr carries an ADR when a .md file sits in it" \
    "\`docs/adr/\` carries an ADR when a \`.md\` file is placed directly in it, in this story's worktree."
require writing-a-user-story "working around a constraint or an ADR breaks what the implementer cannot see" \
    "A constraint is a decision another story of the batch relies on, and an ADR is a decision your human partner took for all the code to come, so an implementer who works around either breaks something they cannot see."
require writing-a-user-story "the condition leaves the branch as it is" \
    "your human partner rules on the constraint or the ADR, and until then the branch and the worktree stay as they are."
require writing-a-user-story "step 5 names both triggers of the condition" \
    "In a story whose batch declares constraints or whose \`docs/adr/\` carries an ADR: if, while conducting it, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner."
require writing-a-user-story "step 5 sets aside the constraint the spec contradicts" \
    "A constraint the spec contradicts is not this case, since the spec wins."
require writing-a-user-story "the worktree carries the ADRs the code holds" \
    "the worktree carries the ADRs \`main\` carried when the branch started, which are the ones this story's code holds."
require writing-a-user-story "an implementer leaves the ADR to the review" \
    "Only your human partner decides an ADR, so an implementer who takes such a decision reports it and leaves the file to the review."
require writing-a-user-story "GC lists the ADRs the code holds" \
    "- **only if \`docs/adr/\` carries an ADR**, the paths of the ADRs this story's code holds;"
require writing-a-user-story "GC lists the conditions of an ADR" \
    "- the conditions of an ADR, with the obligation to record as an \`Open ruling:\` the decision that meets them."
require writing-a-user-story "GC carries the paths of the ADRs" \
    "**When \`docs/adr/\` carries an ADR, \`Global Constraints\` lists the path of each one, under the sentence below.**"
require writing-a-user-story "the sentence the paths sit under" \
    "The code this story writes holds these ADRs."
require writing-a-user-story "an ADR left out of the list binds nobody" \
    "An implementer reads only this list, so an ADR whose path is missing from it binds nobody."
require writing-a-user-story "GC carries the conditions of an ADR" \
    "**In every story, \`Global Constraints\` carries the conditions of an ADR, written out in full, with the obligation to record the decision that meets them.**"
require writing-a-user-story "a task records the decision as an open ruling" \
    "When you take a technical decision that meets them, say so in your report: it is recorded as an \`Open ruling:\`, which asks your human partner whether they want it as an ADR. Write nothing in \`docs/adr/\`."
require writing-a-user-story "no task writes in docs/adr" \
    "No task writes in \`docs/adr/\`. The ADR a decision of this story deserves is written at the review (Step 7), once your human partner wants it."
require writing-a-user-story "step 6 records the decision that meets the conditions" \
    "Write as an \`Open ruling:\` every technical decision the plan or the execution took that meets the conditions of an ADR, its line ending with whether your human partner wants it as an ADR."
require writing-a-user-story "the review settles the ADR" \
    "If they want the ADR, invoke \`supercharlouze:recording-a-decision\` and commit the file it writes in a commit of its own."
require writing-a-user-story "the human settles the open ruling on an ADR" \
    "**Your human partner settles an open ruling on a decision that meets the conditions of an ADR.**"
require writing-a-user-story "nothing written is recorded" \
    "If nothing is written, record in the \`Rulings log\` what they ruled."
require writing-a-user-story "a later correction of the ADR is a fixup" \
    "A correction of the ADR's text asked for afterwards, which does not change its decision, is a \`fixup!\` of that commit."
require writing-a-user-story "red flag: a departure left out surprises the review" \
    "| \"My plan departs only slightly from the design, no ruling needed\" | Every departure is a \`Technical design ruling:\`. One left out reaches the delivery review as a surprise. |"
require writing-a-user-story "red flag: the plan follows the ADR, then main's code" \
    "| \"\`main\`'s code contradicts the design, so the design wins\" | The design only guides. Where an ADR contradicts it, the plan follows the ADR; elsewhere, where \`main\`'s code departed from it, the plan starts from the code. |"
require writing-a-user-story "red flag: no task writes the ADR" \
    "| \"This decision deserves an ADR, I'll write it with the code\" | No task writes in \`docs/adr/\`. Record an \`Open ruling:\`, and write the ADR at the review if your human partner wants it. |"
require writing-a-user-story "an untenable ADR abandons the story" \
    "If they rule an ADR untenable, the story is abandoned and a bounded change rewrites or deletes the ADR."
require writing-a-user-story "what holds resumes the story" \
    "Otherwise resume the story and hold the constraint or the ADR."
require writing-a-user-story "red flag: a ruling replaces no stop condition" \
    "| \"This constraint, or this ADR, cannot be held, I'll work around it and record a ruling\" | A ruling replaces no stop condition. Another story of the batch relies on that constraint, and your human partner decided that ADR: stop and put it to them. |"
require writing-a-user-story "the owning batch does not decide"   "whether the flag was declared by this story's batch or by another one"
require writing-a-user-story "GC is the only channel to SDD subagents" "only channel to this skill's rules is this list"

# --- writing-a-user-story: the rules a guarded story copies into Global
# Constraints (spec section "Code under a feature flag") ---
require writing-a-user-story "guarded code holds up in every situation" "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off:"
require writing-a-user-story "both states work on the same data" "The two states work on the same data: what one produces, the other reads and uses, with no error and no data loss."
require writing-a-user-story "flag off restores the former behaviour" "With the flag off, the user finds the behaviour from before the batch."
require writing-a-user-story "both states and their coexistence are tested" "The story's pull request tests the flag-on behaviour, the flag-off behaviour, and their coexistence."
require writing-a-user-story "lifting only removes"               "Lifting the flag comes down to deleting the branching and the behaviour from before the batch, without writing anything new."
require using-batches "the guarded-code summary follows the rules" "both states working on the same data, the behaviour from before the batch with the flag off, each state and their coexistence tested, and a lifting that only removes"
require using-batches "the guarded-code red flag follows the rules" "both states work on the same data, the flag off gives back the behaviour from before the batch, the pull request tests each state and their coexistence, and lifting only removes"

# --- writing-a-user-story: Lifting and Teardown Stories ---
require writing-a-user-story "an observation period is two stories" "the first moves the declared default of the gating sentence from \`off\` to \`on\`"
require writing-a-user-story "declared default is not the effective state" "The declared default and the effective state are two different things"
require writing-a-user-story "only a story changes the declared default" "Only a story changes the declared default"

# --- writing-a-user-story: the story's blocks (spec sections "Story",
# "The user story document", "Delivering a story") ---
require writing-a-user-story "a story knows its batch's stories"   "each knowing the stories of its batch already written"
require writing-a-user-story "each story chooses its own blocks"  "chooses, as it is written, the blocks of the spec delta it transcribes"
require writing-a-user-story "a block is never shared"            "a block is never shared between two stories"
require writing-a-user-story "the header carries extra fields"     "extend the standard header with the fields below"
require writing-a-user-story "the header template declares Blocks"  "**Blocks:** D3, D7"
# A section title is skeleton, so the example header names English sections.
require writing-a-user-story "the header example names English sections" "**Sections:** Subscription > Renewal, Subscription > Proration"
require writing-a-user-story "Blocks is what closing reads"         "reads to find the blocks nobody delivered"
require writing-a-user-story "Blocks is none when none is taken"    "\`none\` for a story that transcribes none"
require writing-a-user-story "three properties are load-bearing"    "Three properties are load-bearing"
require writing-a-user-story "transcription is word for word"       "exactly as the opening review read it"
require writing-a-user-story "a diff block yields its paragraph"    "is transcribed as the paragraph it produces"
require writing-a-user-story "main moved under a block's paragraph" "the paragraph a block changes no longer reads in \`main\` as the block shows it"
require writing-a-user-story "a divergence is named in the PR"      "Every divergence from a block is named in the body of the pull request"
require writing-a-user-story "main moved: fit the block"            "When \`main\` moved under a block, fit the block to what \`main\` now carries"
require writing-a-user-story "a problematic block goes to the human" "When the block's text is a problem, stop and put it to your human partner before transcribing it"
require writing-a-user-story "a doubtful block stops the story"     "Do not transcribe a text you believe is wrong"
require writing-a-user-story "no divergence amends the batch document" "Neither case amends the batch document"
require writing-a-user-story "ends the review as every gate does"   "never approves and never merges a pull request"
require writing-a-user-story "pushes corrections as fixups"         "pushed as a \`fixup!\` commit"
require writing-a-user-story "names the merge a clear moment"       "a moment to clear the context"
require writing-a-user-story "hands over to the next story"         "name the next story as the next step"
require writing-a-user-story "allocation reads main on the remote" "git ls-tree --name-only origin/main docs/batches/"

# --- writing-a-user-story: what the spec leaves to the skill (sections
# "The user story document", "Delivering a story", "Abandoning a story") ---
# The spec states the rules; these details are the method, and the skill is the
# only place that still carries them.
require writing-a-user-story "the NN- prefix keeps basenames unique" "The \`NN-\` prefix keeps basenames unique across batches"
require writing-a-user-story "Spec: is the binding authority"       "\`Spec:\` is the field \`subagent-driven-development\` already reads as the binding authority"
require writing-a-user-story "sections are declared, not derived"   "Sections are declared, not derived"
require writing-a-user-story "never the batch's whole delta"        "and never the batch's whole delta"
require writing-a-user-story "an open batch has its opening merged" "Its opening pull request is merged and its document says \`status: open\`"
require writing-a-user-story "the plan goes into the first commit's document" "Step 4 then writes the plan into that document rather than creating it"
require writing-a-user-story "the plan is pushed immediately"       "and push it immediately"
require writing-a-user-story "the records are pushed"               "Commit both on the branch and push, so they merge with it"
require writing-a-user-story "the merge delivers the story"         "The story is delivered when its pull request is merged"
require writing-a-user-story "abandoning removes the worktree too"  "remove its worktree and delete its branch, locally and on the remote"

# --- closing-a-batch (spec 4.1, 4.2, 5.4) ---
require closing-a-batch "the preconditions read the design and its rulings" \
    "the technical design rulings the rewrite starts from"
require closing-a-batch "every duty lands in one pull request"  "Every duty lands in one pull request"
require closing-a-batch "the flag check precedes the writers"  "it comes before the duties that write"
require closing-a-batch "consolidates Observed drift"            "Observed drift"
require closing-a-batch "reads both sections of a story"         "Two sections carry it"
require closing-a-batch "names the Rulings log as a source"      "The **Rulings log** holds its \`Open ruling:\` lines"
require closing-a-batch "consolidates the open rulings too"      "the ones classified as a violation or a gap are yours"
require closing-a-batch "the Rulings log feeds the rewrite too" \
    "its \`Technical design ruling:\` lines are what *Rewrite the technical design* starts from"
require closing-a-batch "releasing keeps the entry"  "removes the reservation annotation and leaves the entry"
# This duty sorts what the stories brought back; it must not read as a definition
# of either category. A fourth wording of "what a gap is" would sit outside the
# `shared` assertion that locks the other three, and drift with nothing to catch it.
require closing-a-batch "sorts story findings, defines nothing"  "whatever a story reported as"
require closing-a-batch "releases unconsumed reservations"       "unconsumed reservations"
require closing-a-batch "records undelivered blocks"             "announced but never delivered"
require closing-a-batch "the withdrawal reads the Blocks declarations" "Read the \`Blocks:\` field of every story document in the batch directory"
require closing-a-batch "a block nobody declared is undelivered" "no collected declaration names is a block announced but never delivered"
require closing-a-batch "the duty withdraws undelivered blocks"  "### Withdraw the blocks no story delivered"
require closing-a-batch "a withdrawn block leaves the batch document" "Remove it from the batch document, its \`Spec delta\` entry and any constraint that names it"
require closing-a-batch "the human decides whether each joins the register" "Ask your human partner whether it joins the gaps register"
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

# --- closing-a-batch: the duty precisions (spec section "Closing a batch") ---
require closing-a-batch "the flag check is a duty"               "### Refuse to close on a flag"
require closing-a-batch "the flag check precedes the writing duties" "it comes before any other duty writes anything"
require closing-a-batch "a refusal must cost nothing"            "makes a refusal free"
require closing-a-batch "the flag check covers the flags it declared" "Check every feature flag **this batch declared**"
require closing-a-batch "an earlier batch's flag goes to the withdrawal" "A flag declared by an earlier batch is not this duty's business"
require closing-a-batch "the withdrawal is empty for a corrective batch" "A corrective batch has nothing to compare here"
# The duties are neither counted nor numbered: a duty is named by its title, and
# their order is the order of their headings. A number went false in every
# reference the day a duty was added or removed.
case "$(body_flat "$REPO_ROOT/skills/closing-a-batch/SKILL.md")" in
    *"### "[0-9]". "*|*[Dd]"uty "[0-9]*|*[Tt]"wo duties"*|*[Tt]"hree duties"*|*[Ff]"our duties"*|*[Ff]"ive duties"*|*[Ss]"ix duties"*)
        fail "closing-a-batch: no duty is counted or numbered" ;;
    *)  pass "closing-a-batch: no duty is counted or numbered" ;;
esac
case "$(body_flat "$REPO_ROOT/skills/closing-a-batch/SKILL.md")" in
    *"### Refuse to close on a flag"*"### Consolidate what the story documents left"*"### Release unconsumed reservations"*"### Withdraw the blocks no story delivered"*"### Rewrite the technical design"*"### Set status: closed"*)
        pass "closing-a-batch: the duties keep their order" ;;
    *)  fail "closing-a-batch: the duties keep their order" ;;
esac
require closing-a-batch "released entries are not re-filed"      "do not re-file the released entries as fresh gaps"
# Closing rewrites the technical design into the mechanism delivered (spec
# section "Closing a batch"), from the stories' departures and the code.
require closing-a-batch "the design is rewritten into what was delivered" \
    "When the batch document's \`Technical design\` is not \`none\`, rewrite it to describe the mechanism the batch delivered."
require closing-a-batch "the rewrite starts from the stories' departures" \
    "Start from the \`Technical design ruling:\` lines in the \`Rulings log\` of every merged story, and check them against the code on \`main\`."
require closing-a-batch "the rewrite drops what served withdrawn blocks" \
    "Drop what served only the blocks you just withdrew."
require closing-a-batch "the code is the authority after closing" \
    "The rewritten text is true at closing. After closing, the code is the authority"
require closing-a-batch "the overview names the rewrite" \
    "*Rewrite the technical design* brings its design in line with what was delivered"

# --- using-batches: preconditions for every pull request of this system ---
require using-batches "the directory it runs in does not matter"    "Where you are standing does not matter"
require using-batches "a batch carries only what a spec cannot" "Besides its spec delta, a batch carries only what a spec cannot carry: its scope, its flags, its constraints and its technical design."
require using-batches "defines the technical design" \
        "**Technical design** — the mechanism a batch plans for its stories, each of which may depart from it."
require using-batches "the spec binds, the design guides" \
        "the spec binds a story, the technical design only guides it"
require using-batches "defines the technical design ruling" \
        "**Technical design ruling** — a ruling by which a story departs from its batch's technical design."

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
require using-batches "a ruling replaces no stop condition" \
    "A ruling replaces none of them"
require using-batches "a story stops on a constraint or an ADR it cannot hold" \
    "If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner."
require using-batches "a contradicted constraint is not this case" \
    "A constraint the spec contradicts does not fall under this condition: the spec wins."
require using-batches "a ruling would break a decision of the batch or of the human" \
    "and the condition on a constraint or an ADR would break a decision another story of the batch relies on, or one your human partner took for all the code to come."
require using-batches "the justification covers the ADR" \
    "and an ADR is a decision your human partner took, so only they judge it untenable."
require using-batches "the human rules on the constraint or the ADR" \
    "When the condition on a constraint or an ADR fires, your human partner rules on the constraint or the ADR."
require using-batches "an untenable constraint goes to an amendment" \
    "If they rule a constraint untenable, the story is abandoned and \`supercharlouze:writing-a-batch\` amends the constraint, under \`Amending a Batch\`."
require using-batches "an untenable ADR goes to a bounded change" \
    "If they rule an ADR untenable, the story is abandoned and a bounded change rewrites or deletes the ADR."
require using-batches "what holds resumes the story" \
    "Otherwise the story resumes and holds the constraint or the ADR."
require writing-a-user-story "an untenable constraint abandons the story" \
    "If they rule a constraint untenable, the story is abandoned and \`supercharlouze:writing-a-batch\` amends the constraint."

# --- using-batches: the shape of a review's end ---
require using-batches "the amendment gate covers the design and the constraints" "the decision to change its scope, its spec delta, its technical design, its constraints or its flag"
require using-batches "routing names the design and the constraints" "A batch must change its scope, its spec delta, its technical design, its constraints or its flag"
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
require using-batches "the prompt waits for the merge"      "The prompt waits for the merge announcement, not for the announcement that the pull request is ready"

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
require using-batches "a silent bounded change leaves the spec untouched" \
        "the spec stays silent. That silence is not a tolerance"
require using-batches "a bounded change names the spec it targets" \
        "the spec it targets and the sections it touches"
require using-batches "a bounded change touching no section declares none" \
        "when it touches none"
require using-batches "a changed declaration redoes the detection" \
        "redoes the detection"

require writing-a-user-story "the story skill fixes the forms of the gating sentence" \
        "states the flag and its default in a gating sentence, which adds its lifting condition when the declared scope reaches beyond the batch: \`\`\`markdown 🔒 \`billing.recurring\`, off by default 🔒 \`billing.recurring\`, off by default — lifted when"
require writing-a-user-story "the gating sentence names its variable parts" \
        "The flag's name, its default and its lifting condition vary; the rest of each form is fixed."
require using-batches "the form of the gating sentence comes from the story skill" \
        "in one of the forms \`supercharlouze:writing-a-user-story\` fixes"

require using-batches "a corrective batch's delta carries no block" \
        "**Corrective batch** — a batch that brings existing code back into conformance with a spec that is already true. Its spec delta carries no block."

# --- using-batches: the ADR (spec sections "The model", "Architecture decision
# records" and "Bounded change") ---
require using-batches "defines the ADR" \
        "**ADR** — the document that records a technical decision of the project and its reason: a \`.md\` file placed directly in \`docs/adr/\`, at \`docs/adr/<slug>.md\`."
# The reference text of the conditions. Word for word: another skill copies it.
require using-batches "the conditions of an ADR, word for word" \
        "A technical decision is recorded as an ADR only if it meets these conditions: - undoing it is expensive; - it surprises whoever does not know its context; - it settles between real alternatives."
require using-batches "the human decides every ADR" \
        "**Your human partner decides every ADR.** An agent neither writes, rewrites nor deletes one unless they have decided it."
require using-batches "what is observable is a spec rule, never an ADR" \
        "What is observable at a module's boundary is a rule of that module's spec, never an ADR."
require using-batches "an ADR contradicts no spec and no other ADR" \
        "An ADR contradicts no spec and no other ADR."
require using-batches "a replaced decision is rewritten in place" \
        "An ADR whose decision is replaced is rewritten in place, and one whose decision is abandoned is deleted."
require using-batches "the commit that rewrites or deletes an ADR says why" \
        "**The commit that rewrites or deletes an ADR says why.**"
require using-batches "routing sends an ADR to a bounded change" \
        "| Your human partner wants an ADR written, rewritten or deleted | A bounded change, under \`What Is Kept, What Is Rerouted\` below |"
require using-batches "a decision with nothing observable has the ADR for outlet" \
        "Exception: a sentence that states a technical decision has an ADR for outlet, under the conditions \`The Model\` states."
require using-batches "a decision housed outside the specs goes to an ADR" \
        "A technical decision that no module boundary makes observable is not a rule: its outlet is an ADR."
require using-batches "the scope paragraph names both outlets" \
        "that is where what the test ejects goes, except a technical decision, which has an ADR for outlet"
require using-batches "the red flag names the ADR as the outlet" \
        "A technical decision with nothing observable at a module's boundary is no rule at all: its outlet is an ADR. |"
require using-batches "a bounded change writes, rewrites and deletes ADRs" \
        "**(e) It may write, rewrite and delete ADRs, and may carry nothing but ADRs.**"
require using-batches "a bounded change invokes recording-a-decision" \
        "Invoke \`supercharlouze:recording-a-decision\` to write or rewrite one. Delete yourself the one your human partner abandons, and correct yourself, on their decision, a text whose decision does not change."
require using-batches "the code holds the ADRs main carries" \
        "The code of a story or of a bounded change holds the ADRs \`main\` carries when its branch starts."
require using-batches "no ADR binds the code already on main" \
        "No ADR binds the code already on \`main\`."
require using-batches "the delivery gate carries the ADRs the review asks for" \
        "| Story delivery | the pull request carrying a story's code, its spec change if it has one, and the ADRs the review asks for |"
require using-batches "the bounded ceremony has an exception" \
        "**Bounded** — ceremony unchanged, except for the reading of \`docs/adr/\` stated below, with these rules:"
require using-batches "the design steps have the same exception" \
        "are **kept intact**, except for the reading of \`docs/adr/\` stated below"
require using-batches "the design reads docs/adr before proposing an approach" \
        "On the bounded path and on the architectural path, read every ADR in \`docs/adr/\` before proposing an approach"
require using-batches "the design puts to the human the decision that meets the conditions" \
        "put to your human partner each technical decision the design takes that meets the conditions of an ADR (\`The Model\`)"
require using-batches "a bounded change holds the ADRs" \
        "**(f) It holds the ADRs \`main\` carries when its branch starts.**"
require using-batches "a bounded change rereads docs/adr once its branch exists" \
        "Once \`bounded/<slug>\` is created, reread \`docs/adr/\` and hold what you find there"
require using-batches "a bounded change puts to the human the ADR it cannot hold" \
        "When you cannot hold an ADR, put it to your human partner: if they rule it untenable, rewrite or delete it under rule (e); otherwise hold it."
require using-batches "a bounded change puts to the human the decision that meets the conditions" \
        "**(g) It puts to your human partner the technical decision it takes that meets the conditions of an ADR (\`The Model\`).**"
require using-batches "a bounded change writes the ADR the human wants" \
        "If they want it as an ADR, write it under rule (e)."
require using-batches "red flag: a decision is put to the human" \
        "| \"This decision is technical, no need to bring it to my human partner\" | If it meets the conditions of an ADR, put it to them: only they decide an ADR. |"
require using-batches "an approach that breaks an ADR is not taken" \
        "An approach that breaks an ADR is one the code may not take, and only your human partner decides an ADR."
require using-batches "a bounded change's decision along the way is put to the human too" \
        "That holds for a decision taken along the way as for one taken at design."
require using-batches "the design read may be stale" \
        "the design read it where you stood, and the branch starts from \`main\` as the remote carries it"

# --- using-batches: the glossary terms of the review (spec section "The model") ---
require using-batches "defines the pull request" \
        "**Pull request** — a change proposed for \`main\`, which the human reviews before it reaches \`main\`."
require using-batches "defines the gate" \
        "**Gate** — the human's review of a pull request, whose merge moves a module, a batch or a story forward."
require using-batches "defines the reread" \
        "**Reread** — an agent's check of a piece of work. A reread is not a gate."

require writing-a-user-story "the cases of Blocks: none are examples" \
        "\`none\` for a story that transcribes none, such as a corrective batch's story, a technical story or a teardown story."

exit $((FAILURES > 0))
