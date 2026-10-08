#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib.sh"

echo "test-skill-content"

# Every document-producing skill states the language rule (Global Constraints, spec 10).
for s in adopting-a-module writing-a-batch writing-a-user-story closing-a-batch recording-a-decision; do
    require "$s" "states the language rule" "English skeleton"
done

# Every document-producing skill sends its writer to the concision rules.
for s in adopting-a-module writing-a-batch writing-a-user-story closing-a-batch recording-a-decision; do
    require "$s" "points at the concision rules" "follows \`Concision\` in \`supercharlouze:following-the-rules\`"
done

# --- following-the-rules: concision ---
require following-the-rules "concision covers every text the flow writes" "hold for every text this flow writes: its documents, its pull request bodies and its commit messages"
require following-the-rules "one exact thing, once"              "Every sentence says one exact thing, once, and stands on its own"
require following-the-rules "one rule per paragraph"             "Every paragraph carries one rule"
require following-the-rules "a rule states its reach"            "A rule says how far it holds, and an exception presents itself as one"
require following-the-rules "what, not how or why"               "A text says what it delivers or decides, without telling how it got there or why"
require following-the-rules "the requested reason is the exception" "Exception: the reason this flow explicitly asks for"
require following-the-rules "nothing set in relief"              "No sentence is set in relief"
require following-the-rules "the cut test"                       "would a reader who never saw the previous version lose anything if this sentence went?"
require following-the-rules "too little is as wrong as too much" "Too little is as wrong as too much"
require following-the-rules "a list does not announce its count" "A list does not announce how many items it holds"

# --- following-the-rules: conversation ---
require following-the-rules "conversation follows concision"     "What the agent says to the human follows \`Concision\`"
require following-the-rules "named by section and change"        "is named by the section it targets and what it changes there, never by its identifier alone"
require following-the-rules "the identifier may follow"          "The identifier may follow in parentheses"

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
require adopting-a-module "exclusivity is scoped, not dropped"   "Within that bound, only they create normative text"
# Step 4 points at the authority rule rather than restating it: a second full
# statement of the same rule, a few hundred lines from the first, is what drifts.
require adopting-a-module "step 4 points at the authority rule" "The authority rule of \`Source Authority\` above holds while you write"
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
require adopting-a-module "promoting a gap removes its entry"        "an adoption that promotes a gap into the spec"

# --- adopting-a-module: the technical decision that meets the conditions of an
# ADR (spec section "Module adoption") ---
require adopting-a-module "step 4 puts such a decision to the human" \
        "- Exception: put to your human partner a technical decision the test ejects that meets the conditions of an ADR, which \`supercharlouze:following-the-rules\` states."
require adopting-a-module "the adoption has the ADR written" \
        "If they want it as an ADR, invoke \`supercharlouze:recording-a-decision\`, and the ADR travels in the adoption pull request. Otherwise it becomes a gap."
require adopting-a-module "the reread's mechanisms follow the same exception" \
        "Exception: a technical decision among them that meets the conditions of an ADR is handled as the step \`Write the spec from those documents only\` says."
require adopting-a-module "the overview names the ADRs the pull request carries" \
        "It produces one pull request carrying the spec at \`docs/specs/<module>.md\`, the gaps register at \`docs/specs/<module>.gaps.md\`, the ADRs it writes, and no code."
require adopting-a-module "the ADRs are committed with the two documents" \
        "Commit the spec, the gaps register and the ADRs you wrote on it"
require adopting-a-module "the pull request carries the ADRs" \
        "The pull request carries the spec, the gaps register and the ADRs you wrote, and no code."

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
require writing-a-batch "its blocks are applied with every pending block" "invoke \`supercharlouze:applying-a-spec-delta\` and give it the amended document and its new or changed blocks together with every block no merged story has declared yet"
require writing-a-batch "its applied copies go to the shared reread" "then invoke \`supercharlouze:rereading-a-spec\` on each applied copy, with the path of the spec it applies to, as \`The Coherence Reread\` does"
require writing-a-batch "its whole document goes through the document reread" "After its rereads, an amendment that changes the spec delta puts the whole document through the batch-document reread"
require writing-a-batch "an amendment goes through the technical reread" "An amendment that changes the spec delta, the technical design or the constraints, or that writes or rewrites an ADR, goes through the technical reread before its pull request opens, after the coherence reread when it runs one"
require writing-a-batch "its technical reread is the opening's" "Conduct it as \`The Technical Reread\` does"
require writing-a-batch "its technical reread reads the pending blocks applied" "on the amended document and on each spec with every block no merged story has declared yet applied"
require writing-a-batch "its technical reread has the pending blocks applied" "invoke \`supercharlouze:applying-a-spec-delta\` and give it the amended document and those blocks"
require writing-a-batch "a behaviour or a block taken back makes a delta amendment" "A behaviour or a block it returns as taken back to the spec delta makes the amendment one that changes the spec delta"
require writing-a-batch "its body carries what an opening body carries" "the exact text of every new or changed block, and what the coherence reread found"
require writing-a-batch "an amendment writes, rewrites or deletes ADRs" "An amendment's pull request may also write, rewrite or delete the ADRs your human partner decided with the amendment."
require writing-a-batch "its ADRs are written as the opening's" "Do it as \`The ADRs\` does, once the document is amended."
require writing-a-batch "its ADRs meet the pending blocks of the amended document" "Where that section gives \`supercharlouze:applying-a-spec-delta\` every block of the spec delta, give it every block of the amended document that no merged story has declared yet."
require writing-a-batch "its body states the ADRs" "The pull request body states each ADR it writes, rewrites or deletes."
require writing-a-batch "a change of ADRs alone is a bounded change" "A change that touches nothing but ADRs is not an amendment: it goes through a bounded change, under \`supercharlouze:using-batches\`."
require writing-a-batch "what is taken back sends the amendment through both rereads" "makes the amendment one that changes the spec delta: it goes through the coherence reread, then through the technical reread again."
require writing-a-batch "red flag: an amendment for an ADR alone" "| \"My human partner wants this ADR rewritten, I'll amend the batch for it\" | An amendment changes the batch document. A change that touches nothing but ADRs goes through a bounded change. |"
require writing-a-batch "red flag: an amendment's ADR is reread" "| \"This amendment only changes the scope, the ADR it writes needs no reread\" | An amendment that writes or rewrites an ADR goes through the technical reread, whatever else it changes. |"
require writing-a-batch "an amendment releases what it drops" "An amendment that takes a gaps register entry out of \`Scope\` releases its reservation in the same pull request"
require writing-a-batch "the human rules on a constraint a story cannot hold" "**When a story stops on a constraint it cannot hold, your human partner rules on the constraint.**"
require writing-a-batch "an untenable constraint is amended" "If they rule it untenable, an amendment changes or removes the constraint and the story is abandoned"
require writing-a-batch "a story abandoned on a constraint goes through abandoning-a-story" "the story is abandoned: invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch"
require writing-a-batch "a constraint that holds resumes the story" "Otherwise the story resumes and holds the constraint, and nothing is amended."
require writing-a-batch "the red flag keeps the ruling with the human" "Whether a constraint can be held is your human partner's ruling."
require writing-a-batch "an obvious design is still written" "An obvious design is still a design: write it."
require writing-a-batch "requalification offers a different batch" "**Rule the remaining work a different batch**"
require writing-a-batch "requalification releases what the batch drops" "3. **Release the reservations of the entries the batch no longer takes on.**"
require closing-a-batch "an amendment already released what it dropped" "An entry an amendment took out of \`Scope\` is not among them: that amendment released it."
require writing-a-user-story "abandoning leaves the reservation to the amendment or closing" "the amendment that takes its entry out of \`Scope\` releases it, or \`supercharlouze:closing-a-batch\` does"
require writing-a-user-story "an abandonment leaves closing the reservation no amendment released" "unless an amendment took its entry out of \`Scope\` and released it"
require closing-a-batch "an amendment's release is the one exception" "except an amendment that takes a reserved entry out of \`Scope\` and releases it"
require writing-a-batch "a corrective story is abandoned once ruled" "1. **Leave the story as it stands until the choice below is ruled, then abandon it.**"
require writing-a-batch "an open pull request waits for the ruling" "A pull request already open stays open until then."
require writing-a-batch "a corrective story goes through abandoning-a-story once ruled" "Once the choice is ruled, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch"
require writing-a-batch "a technical story's pull request is closed at the stop" "Close its pull request without merging it if one is already open; the branch and its worktree stay until the choice below is ruled."
require writing-a-batch "a technical story goes through abandoning-a-story once ruled" "Once it is ruled, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch"
require writing-a-batch "red flag: requalification does not start by closing" "| \"Requalification starts by closing the story's pull request\" | Override 2 fires mid-SDD, usually before any pull request exists. Close it only if it is already open. |"
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
# A batch's constraints bind only its stories (spec section "The batch document"):
# neither another batch nor the code that comes after the batch has to hold them.
require writing-a-batch "a batch's constraints bind only its stories" \
    "A batch's constraints bind only its stories."
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
require writing-a-batch "step 3 ends on the ADRs"               "then write, rewrite or delete the ADRs your human partner decided (\`The ADRs\`)"
require writing-a-batch "the technical reread is step 6"        "6. **Put the batch through the technical reread** (\`The Technical Reread\`)."
require writing-a-batch "the document reread is step 7"         "7. **Reread the whole batch document**"
require writing-a-batch "the pull request is step 8"            "8. **Open the pull request** from \`batch/NN-<slug>\`"
require writing-a-batch "the document reread is named where it runs" "**The batch-document reread**, step 7, comes after the technical reread"
require writing-a-batch "each reread has its own object"        "The rereads are steps 5, 6 and 7, and each has its own object"
require writing-a-batch "the technical reread's object is stated" "The technical reread bears on the technical design and the constraints, on the blocks read against the ADRs, and on the ADRs this pull request writes or rewrites."
require writing-a-batch "the document reread takes the whole document" "bears on the whole document"
# The context that wrote the document rereads its own intentions, exactly as it
# would the blocks, so the batch-document reread leaves it too.
require writing-a-batch "the document reread is conducted outside this context" "Conduct it outside the context that wrote the document, by dispatching a subagent"
require writing-a-batch "merging them strands a corrective batch" "leaving a corrective batch, which has no blocks, without a reread of its document"

# --- writing-a-batch: the coherence reread (spec section "The coherence reread") ---
# The step exists, the applied state comes from `applying-a-spec-delta`, and the
# declaration makes the whole thing observable. Drop any one and the section
# still reads whole while doing less.
require writing-a-batch "the delta goes through the coherence reread" "Before opening, the whole spec delta goes through the **coherence reread**"
# A delta with no block skips this reread (spec section "The coherence reread").
# Not a dispensation: this reread reads blocks against the spec they will change,
# so with no block it has nothing to read. The batch-document reread of step 7 is
# untouched, and it is what still bears on a blockless delta.
require writing-a-batch "a blockless delta skips this reread"    "A delta that carries no block skips this step"
require writing-a-batch "the skip is not a dispensation"         "it has nothing to read and no state to build"
require writing-a-batch "a blockless batch still owes the rereads that follow" "Such a batch still owes step 6, and step 7, the batch-document reread, which bears on whatever stands in the blocks' place."
require writing-a-batch "step 5 states the skip where it is ordered" "skipped when the delta carries no block"
require writing-a-batch "the coherence reread has every block applied" "Invoke \`supercharlouze:applying-a-spec-delta\` and give it the batch document and every block of its spec delta. Then invoke \`supercharlouze:rereading-a-spec\` on each applied copy"
# The readers, their readings and the rounds live in `supercharlouze:rereading-a-spec`.
# The coherence reread hands over each applied copy, and carries back what the
# reread returns. What a reader gets is the reread's business, not this skill's.
require writing-a-batch "each applied copy goes to the shared reread" "invoke \`supercharlouze:rereading-a-spec\` on each applied copy, with the path of the spec it applies to"
require writing-a-batch "revisions go back into the blocks"        "Carry every revision it returns back into the blocks"
require writing-a-batch "a boundary rule stops the opening"        "A rule it returns as reaching past its module's boundary stops the opening"
require writing-a-batch "the pull request body says what the reread found" "The pull request body says what the reread found, or that it found nothing"

# --- writing-a-batch: the technical reread (spec section "The technical reread") ---
# The step exists for every batch, what it hands the shared reread, where its
# revisions go, and the declaration that makes it observable.
require writing-a-batch "the batch goes through the technical reread" "After the coherence reread, the batch goes through the **technical reread**"
require writing-a-batch "the technical reread is invoked for every batch" "**Invoke it for every batch.** It returns that it has nothing to reread when that is so"
require writing-a-batch "the invocation hands the specs, the ADRs and their paths" "Hand it also \`docs/specs/\`, \`docs/adr/\` and the path of each ADR this pull request writes or rewrites."
require writing-a-batch "a block taken back restarts the delta" "A block it returns as taken back to the spec delta does the same, with the block as your human partner corrects it."
require writing-a-batch "the technical reread changes no ADR" "It changes no ADR either."
require writing-a-batch "an ADR corrected on a finding goes back through the reread" "When your human partner has an ADR corrected on a finding it returns, invoke \`supercharlouze:recording-a-decision\` as \`The ADRs\` does if the correction changes the ADR's decision, and correct the text yourself if it does not. When they abandon the ADR, delete it. After a correction or a deletion, invoke the technical reread again."
require writing-a-batch "a corrected ADR is handed to the reread" "An ADR whose text you corrected on a finding counts among those it rewrites."
require writing-a-batch "the reread is handed the batch document and its specs" "Invoke \`supercharlouze:rereading-a-technical-design\` with the batch document and each spec the batch touches"
require writing-a-batch "a spec no block targets goes as it is" "the applied copy the coherence reread read, or the spec itself when no block targets it"
require writing-a-batch "revisions go back into the design"     "Carry every revision it returns back into \`Technical design\` and \`Constraints\`"
# The technical reread reads the delta and never writes into it: a block is a
# design decision, and it goes back through the opening from the delta on.
require writing-a-batch "the technical reread changes no spec delta" "The technical reread never changes \`Spec delta\`, and sends nothing back through the coherence reread."
require writing-a-batch "a behaviour taken back restarts the delta" "A behaviour it returns as taken back to the spec delta sends the opening back to step 5, with the block your human partner rules."
# The two rereads never run side by side.
require writing-a-batch "the technical reread waits for the coherence reread" "**Start it only once the coherence reread has closed its rounds.** Run side by side, each reread revises what the other is reading"
require writing-a-batch "red flag: both rereads together"         "| \"The rereads read different things, I'll run them together\" | Each revises what the other is reading."
require writing-a-batch "the pull request body says what it found" "The body of the pull request that runs it, opening or amendment, says what it found, or that it found nothing"
require writing-a-batch "the pull request body says when there was nothing to reread" "When it returned that it had nothing to reread, the body says that instead."
require writing-a-batch "the red flag sends the design to the reread" "Invoke \`supercharlouze:rereading-a-technical-design\`. |"

# --- writing-a-batch: the ADRs of an opening (spec section "Opening a batch") ---
require writing-a-batch "the ADRs change in the opening pull request" "Write, rewrite or delete in this pull request, with the batch document, the ADRs your human partner decided during the brainstorming."
require writing-a-batch "the blocks are applied before an ADR is written" "Before writing or rewriting one, invoke \`supercharlouze:applying-a-spec-delta\` and give it the batch document and every block of its spec delta: it returns the copies of the specs, blocks applied."
require writing-a-batch "an ADR is confronted with the specs as the batch leaves them" "An ADR is confronted with the specs as the batch leaves them, and no block is in a spec yet."
require writing-a-batch "an ADR is written by the shared skill" "Invoke \`supercharlouze:recording-a-decision\` for each ADR to write or to rewrite, and hand it those copies."
require writing-a-batch "an abandoned ADR is deleted" "Delete yourself each ADR your human partner abandoned, in a commit that says why."
require writing-a-batch "the PR body puts the ADRs to the reviewer" "any flag lifting the delta announces; and each ADR this pull request writes, rewrites or deletes."
require writing-a-batch "red flag: skipping the technical reread" "| \"The batch has no design and no constraints, I'll skip the technical reread\" | Invoke it for every batch. It says itself when it has nothing to reread, and it rereads the ADRs this pull request writes. |"
require writing-a-batch "red flag: writing the ADR by hand" "| \"My human partner decided this ADR, I'll write the file myself\" | Invoke \`supercharlouze:recording-a-decision\`. It confronts the decision with the specs, blocks applied, and with the other ADRs. |"
require writing-a-batch "red flag: a corrected ADR is reread" "| \"I only corrected the ADR's wording, no need to reread again\" | The corrected text is one no reader has read. Invoke the technical reread again. |"
require writing-a-batch "red flag: an ADR nobody decided" "| \"This design decision deserves an ADR, I'll write it with the batch\" | Only your human partner decides an ADR. Put the decision to them, and write it once they want it. |"

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
# The rounds live in `running-reread-rounds`, guarded in its block below. Here:
# what this reread passes to it.
require rereading-a-spec "the rounds revise the spec" "give it the spec as the text the rounds revise, and what becomes of each finding:"
require rereading-a-spec "a mechanism leaves the spec, as a finding" "- A sentence that describes a mechanism leaves the spec, and goes to the output."
# A defect the change did not write is returned and left alone. Fixed in the
# reread, it widens what the human reviews; left to every round, it comes back
# with each of them.
require rereading-a-spec "a defect already on main is not fixed"  "A defect the spec already carries on \`main\` is not fixed: the change did not write that passage, and fixing it widens what your human partner reviews"
require rereading-a-spec "a defect already on main opens no round" "It goes once into what the reread found, and opens no round"
require rereading-a-spec "red flag: an old passage"               "| \"The reader is right about this old passage, I'll fix it too\" | The change did not write it."

# --- rereading-a-technical-design (spec section "The technical reread") ---
# Outside the context that wrote the design and the constraints.
require rereading-a-technical-design "the reread runs outside the writing context" "outside the context that wrote them, by readers dispatched as subagents"
require rereading-a-technical-design "it is invoked by a skill"          "It is invoked by another skill, never on a request of your human partner"
# Its input and its output say everything a caller needs, as for the spec reread.
require rereading-a-technical-design "the reread also bears on the blocks and the ADRs" "The reread also reads the batch's blocks and its design against the ADRs, and rereads each ADR that the pull request opening or amending the batch writes or rewrites."
require rereading-a-technical-design "input: the batch, its applied specs, the other specs and the ADRs" "The input is: - the batch document; - each spec the batch touches, with the batch's blocks applied; - \`docs/specs/\`, for the specs the batch does not touch; - \`docs/adr/\`, as the pull request that opens or amends the batch leaves it; - the path of each ADR that pull request writes or rewrites."
require rereading-a-technical-design "the readers read main's code"     "The readers read the code as \`main\` carries it"
require rereading-a-technical-design "output: the design revised"        "the technical design and the constraints, revised: every finding worked through, and every ruling of your human partner applied"
require rereading-a-technical-design "output: the behaviours and the blocks taken back to the delta" "the behaviours and the blocks your human partner took back to the spec delta, which ended the reread"
require rereading-a-technical-design "output: the findings on an ADR" "the findings on an ADR, each with what your human partner ruled on it;"
require rereading-a-technical-design "output: nothing to reread" "When no reading is dispatched (\`The Readings\`), return \"nothing to reread\"."
require rereading-a-technical-design "the reread writes no block" "It leaves the design, or your human partner takes the batch back to its spec delta and the reread ends: this reread writes no block."
require rereading-a-technical-design "red flag: writing the block" "| \"The design needs this rule, I'll write the block\" | This reread writes no block."
require rereading-a-technical-design "output: what the reread found"     "what the reread found, or that it found nothing, written for a pull request body"
# One reader per reading, dispatched from a template.
require rereading-a-technical-design "a reader takes one reading"        "A reader takes one reading"
require rereading-a-technical-design "the motions cover the ADRs" "a judgement of structure, a reasoning about failures or a confrontation with the ADRs, and one reader holding several does the cheapest of them and returns"
require rereading-a-technical-design "never two readings to one reader"  "never hand a reader two"
require rereading-a-technical-design "the dispatch is composed from a template" "skills/rereading-a-technical-design/references/reader-prompt.md"
require rereading-a-technical-design "a reading is dispatched when its object exists" "Dispatch a reading when its object exists."
require rereading-a-technical-design "the object of the design readings" "The object of these readings is the design: the batch document's \`Technical design\` and \`Constraints\`. It exists unless both read \`none\`."
require rereading-a-technical-design "the object of the reading against the ADRs" "The object of this reading is the batch's blocks and its design. It exists when a \`.md\` file is placed directly in \`docs/adr/\`, and the batch has a block or a design."
require rereading-a-technical-design "the object of the reading of the ADRs" "The object of this reading is each ADR the pull request writes or rewrites. It exists when the input names one."
require rereading-a-technical-design "a reading is pasted word for word" "pasted word for word into the slot the template leaves for it"
require rereading-a-technical-design "a reading is written for a bare reader" "written for a reader that has nothing else"
# The readings: coverage, anchoring in the code, architecture, module design,
# robustness, the ADRs held, the ADRs reread.
require rereading-a-technical-design "reading: coverage"       "**Does the design deliver what the batch promises?**"
require rereading-a-technical-design "reading: the code"       "**Does the design stand on the code as it is?**"
require rereading-a-technical-design "reading: architecture"   "**Does the design hold as an architecture?**"
require rereading-a-technical-design "reading: module design"  "**Are the modules this design draws deep?**"
require rereading-a-technical-design "reading: robustness"     "**How does this design fail?**"
require rereading-a-technical-design "reading: the ADRs held"  "**Do the blocks and the design hold the ADRs?**"
require rereading-a-technical-design "reading: the ADRs reread" "**Does each ADR to reread stand with the specifications and the other ADRs?**"
require rereading-a-technical-design "the held reading reports a block and a part of the design" "Report a block that writes into a specification a rule an ADR contradicts, and a part of the design that an ADR rules out or that would make the code break one."
require rereading-a-technical-design "the reread reading reports a contradiction and an observable rule" "Report an ADR that contradicts a specification, an ADR that contradicts another ADR, and an ADR that states what a user or a neighbouring module would observe"
require rereading-a-technical-design "the held reading reads every ADR" "it is a \`.md\` file placed directly in the ADR directory. Read every one."
require rereading-a-technical-design "the reread reading reads against the applied specs and the other ADRs" "Read each ADR to reread against every specification, the batch's changes applied, and against every other \`.md\` file placed directly in the ADR directory."
require rereading-a-technical-design "an observable rule is no decision for an ADR" "that is a rule of a specification, never a decision an ADR records."
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
    *[Ff]"ive readings"*|*[Ff]"ive readers"*|*"of the five"*|*[Ss]"ix readings"*|*[Ss]"even readings"*|*[Ss]"even readers"*|*"of the seven"*|*[Tt]"wo new readings"*)
        fail "rereading-a-technical-design: no sentence counts the readings" ;;
    *)  pass "rereading-a-technical-design: no sentence counts the readings" ;;
esac
# The rounds live in `running-reread-rounds`, guarded in its block below. Here:
# what this reread passes to it. What changes a decision goes to the human, who
# approved the design.
require rereading-a-technical-design "the rounds revise the design and the constraints" "- the technical design and the constraints, as the text the rounds revise;"
require rereading-a-technical-design "the reading of the ADRs goes out once" "- the reading of the ADRs to reread, as a reading that goes out in the first round only: no revision touches what it reads;"
require rereading-a-technical-design "it says what becomes of each finding" "- what becomes of each finding, stated below."
require rereading-a-technical-design "an undescribed behaviour always goes up" "A behaviour the design would make observable that no specification describes is always put to your human partner"
require rereading-a-technical-design "a finding on a block goes to the human" "A finding on a block is not fixed: put it to your human partner, who leaves the block as it is, takes the batch back to its spec delta, which ends the reread, or has the ADR changed. This reread revises no block."
require rereading-a-technical-design "a finding on an ADR goes to the human" "A finding on an ADR is not fixed either: put it to your human partner, and return it with what they ruled. Return the same way a finding on a block or on the design that they settle by having an ADR changed. This reread revises no ADR."
require rereading-a-technical-design "a fix keeps what the design decides" "Any other finding is fixed on the technical design or the constraints without changing what they decide, or put to your human partner when fixing it would: they approved what the design decides."
require rereading-a-technical-design "red flag: fixing an ADR" "| \"The reader is right about this ADR, I'll fix its wording\" | This reread revises no ADR. Put the finding to your human partner, and return it with what they ruled. |"
require rereading-a-technical-design "red flag: adjusting a block" "| \"This block contradicts an ADR, I'll adjust the block\" | This reread revises no block. Put the finding to your human partner. |"
require rereading-a-technical-design "red flag: no design, nothing to reread" "| \"The batch has no design, so there is nothing to reread\" | A reading is dispatched when its object exists. An ADR the pull request writes is reread whatever the batch carries. |"

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
require recording-a-decision "it does not commit" "Do not commit. The commit that rewrites an ADR says why, since the file keeps nothing of the decision it replaced."
require recording-a-decision "a rewrite's commit says why" "The commit that rewrites an ADR says why"
require recording-a-decision "red flag: wording around a contradiction" "| \"The decision contradicts a spec, I'll word the ADR so it fits\" | A reworded contradiction is still one. Say so to your human partner, and write nothing until they have ruled. |"
require recording-a-decision "red flag: a status line" "| \"Every ADR has a date and a status, I'll add them\" | An ADR of this flow carries neither. The file states what holds now. |"
require recording-a-decision "red flag: superseding" "| \"The old decision is worth keeping, I'll mark it superseded\" | Rewrite in place. Git history keeps the old text, and the commit says why it changed. |"
require recording-a-decision "red flag: committing" "| \"The file is written, I'll commit it\" | Do not commit. |"
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
require writing-a-user-story "concurrency via declared Sections"  "Sections:"
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
require following-the-rules "the foundation states the rules for code under a flag" "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off:"

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
require writing-a-user-story "never the batch's whole delta"        "and never the batch's whole delta"
require writing-a-user-story "an open batch has its opening merged" "Its opening pull request is merged and its document says \`status: open\`"
require writing-a-user-story "the plan goes into the first commit's document" "Step 4 then writes the plan into that document rather than creating it"
require writing-a-user-story "the plan is pushed immediately"       "and push it immediately"
require writing-a-user-story "the records are pushed"               "Commit both on the branch and push, so they merge with it"
require writing-a-user-story "the merge delivers the story"         "The story is delivered when its pull request is merged"
require writing-a-user-story "abandoning goes through abandoning-a-story" "**To abandon a story, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch.**"
require writing-a-user-story "a requalified story goes through abandoning-a-story once ruled" "Once the requalification is ruled, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch."

# --- closing-a-batch (spec 4.1, 4.2, 5.4) ---
require closing-a-batch "the preconditions read what closing consolidates" \
    "The story documents carry what you are about to consolidate: the drift they observed and the open rulings their \`Rulings log\` leaves."
require closing-a-batch "every duty lands in one pull request"  "Every duty lands in one pull request"
require closing-a-batch "the flag check precedes the writers"  "it comes before the duties that write"
require closing-a-batch "consolidates Observed drift"            "Observed drift"
require closing-a-batch "reads both sections of a story"         "Two sections carry it"
require closing-a-batch "names the Rulings log as a source"      "The **Rulings log** holds its \`Open ruling:\` lines"
require closing-a-batch "consolidates the open rulings too"      "the ones classified as a violation or a gap are yours"
require closing-a-batch "red flag: the Rulings log's open rulings are closing's" \
    "| \"The Rulings log is the delivery review's business, not mine\" | Its open rulings classified as a violation or a gap are yours to consolidate. The review settled the rest. |"
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
# the only place either claim is stated — the spec and `following-the-rules` carry the
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
    *"### Refuse to close on a flag"*"### Consolidate what the story documents left"*"### Release unconsumed reservations"*"### Withdraw the blocks no story delivered"*"### Set status: closed"*)
        pass "closing-a-batch: the duties keep their order" ;;
    *)  fail "closing-a-batch: the duties keep their order" ;;
esac
require closing-a-batch "released entries are not re-filed"      "do not re-file the released entries as fresh gaps"
# Closing no longer rewrites the technical design (spec section "Closing a
# batch"): nothing in closing-a-batch, its description included, says it does,
# nor reads the `Technical design ruling:` lines that served only that rewrite.
# The whole file is read, front matter included, because `require` and `absent`
# read only the body.
CLOSING_FILE="$REPO_ROOT/skills/closing-a-batch/SKILL.md"
if [ ! -f "$CLOSING_FILE" ] || tr '\n' ' ' < "$CLOSING_FILE" | tr -s ' ' \
    | grep -Eq "[Rr]ewrit[a-z]* (the|its) (batch's )?technical design|technical design you are about to rewrite|the rewrite starts from|mechanism the batch delivered|Technical design ruling"; then
    fail "closing-a-batch: no longer rewrites the technical design"
else
    pass "closing-a-batch: no longer rewrites the technical design"
fi

# --- following-the-rules: preconditions for every pull request of this system ---
require following-the-rules "the directory it runs in does not matter"    "Where you are standing does not matter"
require following-the-rules "a batch carries only what a spec cannot" "Besides its spec delta, a batch carries only what a spec cannot carry: its scope, its flags, its constraints and its technical design."
require following-the-rules "defines the technical design" \
        "**Technical design** — the mechanism a batch plans for its stories, each of which may depart from it."
require following-the-rules "the spec binds, the design guides" \
        "the spec binds a story, the technical design only guides it"
require following-the-rules "defines the technical design ruling" \
        "**Technical design ruling** — a ruling by which a story departs from its batch's technical design."

# --- writing-in-a-spec: what a spec says (spec section "The spec document") ---
require writing-in-a-spec "the test bears on the module boundary"   "bears on the module's boundary"
require writing-in-a-spec "infrastructure states branches and PRs"  "states branch names and pull requests as rules"
require writing-in-a-spec "no rewording a mechanism into a rule"    "You do not reword a mechanism into a rule"
require writing-in-a-spec "lists the laundering signs"              "Four signs recognise it"
require writing-in-a-spec "a business choice carries its number"    "A business choice carries its number"
require writing-in-a-spec "vagueness is not prudence"               "Vagueness is not prudence"
require writing-in-a-spec "a number says where it comes from"       "a decision, or a reading of the code"
require writing-in-a-spec "structure follows the business"          "structure follows the business"
require writing-in-a-spec "the ban is on the code's decomposition"   "reproduces the code's internal decomposition"
require writing-in-a-spec "a boundary concept may gather rules"      "A section carrying a concept observable at the module's boundary"
require writing-in-a-spec "a glossary is a rule, not a leak"        "Naming is not mechanising"
require writing-in-a-spec "one normative level, no ranking"         "normative, at the same level"
require writing-in-a-spec "a module redefines what it borrows"      "redefines what it borrows"
require writing-in-a-spec "the gaps register is out of scope"       "\`docs/specs/<module>.gaps.md\`, which is not a spec"
require writing-in-a-spec "states the content rule itself"          "business rules and intentions; the mechanism stays in the code"
require writing-in-a-spec "corollary: a rule outlives a mechanism"  "A rule does not move when a mechanism moves"
require writing-in-a-spec "corollary: no legislating on quality"    "does not legislate on code quality"
require writing-in-a-spec "carries the section it points at"        "## What a Spec Says"
require following-the-rules "the glossary states the content property" "it carries **business rules and intentions; the mechanism stays in the code**"
require writing-in-a-spec "a rule belongs to exactly one spec"  "A rule belongs to exactly one spec."
require writing-in-a-spec "a shared rule signals the breakdown" "it is a module breakdown asking to be revisited"
require writing-in-a-spec "a rule outside the specs binds nobody"  "sits beyond everything that makes a spec binding"
require writing-in-a-spec "red flag: rewording a mechanism into a rule" \
    "| \"The delta names a mechanism — I'll reword it into a business rule\" | That is the laundering this rule exists to stop"
require writing-in-a-spec "red flag: a number nobody can answer for" \
    "| \"I can't say where this number came from, I'll write 'a few minutes'\" | Vagueness is not prudence"
require writing-in-a-spec "says when to go back to the step that invoked it" \
    "Once the text is written, go on with the step that invoked this skill."
absent "using-batches no longer carries what a spec contains" \
    "## What a Spec Says|The other-implementation test|Four signs recognise it|Naming is not mechanising" \
    using-batches
require using-batches "a bounded change invokes writing-in-a-spec before writing in a spec" \
    "When it updates a spec, invoke \`supercharlouze:writing-in-a-spec\` before writing in it"

# An internal skill names the skills it invokes, never those that invoke it.
# Walks the declared entry skills, so one declared later is covered.
entry_names="$(declared_skills entry | tr '\n' '|')"
absent "writing-in-a-spec names no skill that invokes it" "${entry_names%|}" writing-in-a-spec

# --- writing-in-a-gaps-register: the register, an entry, the gestures (spec
# section "The gaps register") ---
require writing-in-a-gaps-register "carries the shape of the register"      "# <module> — Gaps register"
require writing-in-a-gaps-register "the categories are kept apart"          "kept apart because they are not treated the same way"
require writing-in-a-gaps-register "the register declares its coverage"     "declares its own coverage"
require writing-in-a-gaps-register "nothing stays once an entry is settled" "Nothing stays behind in this file once an entry is settled"
require writing-in-a-gaps-register "an entry designates a section"          "Each entry designates a section of the spec"
require writing-in-a-gaps-register "a gap entry names its source document"  "came from a document names that document"
require writing-in-a-gaps-register "the entry's shape is still stated without the word" \
    "one list item, never a paragraph of running prose"
require writing-in-a-gaps-register "carries the gestures"                   "## The Gestures"
require writing-in-a-gaps-register "an added entry goes to the end of its category" \
    "An entry is one list item, added at the end of its category"
require writing-in-a-gaps-register "a removal travels with what settles it" \
    "Delete the entry from the file, whole, in the same pull request as what settles it"
require writing-in-a-gaps-register "a reservation annotates the entry"      "Append \`reserved by batch-NN\` to the entry"
require writing-in-a-gaps-register "two batches never reserve the same entry" "two batches never reserve the same entry"
require writing-in-a-gaps-register "releasing keeps the entry"              "removes the reservation annotation and leaves the entry"
require writing-in-a-gaps-register "red flag: prose instead of a list" \
    "| \"Prose reads better than a list in the gaps register\" | Then nothing can reserve, remove or release an entry"
require writing-in-a-gaps-register "red flag: an empty register says why it is empty" \
    "| \"The audit found nothing, so the register is empty\" | An empty register must say whether nothing was found or nothing was examined. |"
require writing-in-a-gaps-register "says what the invoking skill passes" \
    "The skill that invokes it says which gesture to make"
require writing-in-a-gaps-register "says when to go back to the step that invoked it" \
    "Once the register is written, go on with the step that invoked this skill."
case "$(body_flat "$REPO_ROOT/skills/writing-in-a-gaps-register/SKILL.md")" in
    *"# <module> — Gaps register"*"## Coverage"*"## Violations"*"## Gaps"*)
        pass "writing-in-a-gaps-register: the register keeps its coverage and its categories" ;;
    *)  fail "writing-in-a-gaps-register: the register keeps its coverage and its categories" ;;
esac

# An internal skill names the skills it invokes, never those that invoke it.
# Walks the declared entry skills, so one declared later is covered.
absent "writing-in-a-gaps-register names no skill that invokes it" "${entry_names%|}" writing-in-a-gaps-register

# --- detecting-concurrency: the scan (spec section "Concurrency detection") ---
require detecting-concurrency "says what the invoking skill passes" \
    "The skill that invokes it gives the spec the work targets, the sections it will touch and, when the work already has one, its branch."
require detecting-concurrency "fetches first" "git fetch origin"
require detecting-concurrency "leaves the work's own branch out" \
    "When the work has a branch, leave that branch and its pull request out of everything below."
require detecting-concurrency "the concurrency filter is the branch name" "filter is the branch name"
require detecting-concurrency "a declaration names its spec as well" "\`Spec:\` names the spec"
require detecting-concurrency "a bounded change names both in its body" "names both in the body of its pull request"
require detecting-concurrency "a branch with no declaration yet is read by what it changed" \
    "A pushed branch that carries no declaration yet is read by the sections it has already changed"
require detecting-concurrency "both claiming patterns are read before their pull request" \
    "every remote \`story/*\` or \`bounded/*\` branch that carries no pull request yet"
require detecting-concurrency "returns each conflict with who holds it" \
    "**Each conflict:** the section, and the pull request or the branch that holds it."
require detecting-concurrency "returns each declaration it could not read" \
    "**Each declaration you could not read:** the pull request or the branch, and why"
require detecting-concurrency "an unread declaration is no pass" "An unread declaration is an unknown, not a pass."
require detecting-concurrency "names its blind spot" "Name the blind spot rather than trusting the net."
require detecting-concurrency "sections are declared, not derived" "Sections are declared, not derived"
require detecting-concurrency "git conflict is only a partial net" "partial safety net"
require detecting-concurrency "says when to go back to the step that invoked it" \
    "Once you have them, go on with the step that invoked this skill."
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them.
absent "detecting-concurrency names no skill that invokes it" "${entry_names%|}|Step [0-9]" detecting-concurrency

# --- abandoning-a-story: the gesture (spec section "Abandoning a story") ---
require abandoning-a-story "says what the invoking skill passes" \
    "The skill that invokes it gives the story's branch."
require abandoning-a-story "closes an open pull request without merging it" \
    "**Close the story's pull request without merging it, if one is open.**"
require abandoning-a-story "a story stopped before its pull request opened has none" \
    "there is nothing to close, only a branch and a worktree to discard"
require abandoning-a-story "deletes the branch on the remote too" \
    "**Delete the branch, locally and on the remote.**"
require abandoning-a-story "a branch left on the remote is a live claim" \
    "reads as a live claim on its sections"
require abandoning-a-story "removes the worktree" "**Remove its worktree.**"
# The worktree goes before the branch: git refuses to delete a branch a worktree
# still has checked out.
skill_text abandoning-a-story
case "$SKILL_TEXT" in
    *"**Remove its worktree.**"*"**Delete the branch, locally and on the remote.**"*)
        pass "abandoning-a-story: the worktree is removed before the branch is deleted" ;;
    *)  fail "abandoning-a-story: the worktree is removed before the branch is deleted" ;;
esac
require abandoning-a-story "nothing reached main" \
    "the spec change, or the deleted gaps-register entry, travels with the code and dies with the branch"
require abandoning-a-story "changes nothing on main" "Change nothing on \`main\`."
require abandoning-a-story "red flag: the branch can stay" \
    "| \"The story is abandoned, the branch can stay\" | A pushed \`story/*\` branch with no pull request reads as a live claim on its sections. Delete it, locally and on the remote. |"
require abandoning-a-story "says when to go back to the step that invoked it" \
    "Once the story is abandoned, go on with the step that invoked this skill."
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them.
absent "abandoning-a-story names no skill that invokes it" "${entry_names%|}|Step [0-9]" abandoning-a-story

# --- applying-a-spec-delta: the specs with a batch's blocks applied ---
require applying-a-spec-delta "says what the invoking skill passes" \
    "The skill that invokes it gives the batch document and the blocks to apply."
require applying-a-spec-delta "the copies are built outside the repository" \
    "**outside the repository**, in a scratch directory"
require applying-a-spec-delta "no block reaches a spec before a story" \
    "no block is written into a spec before a story transcribes it"
require applying-a-spec-delta "only the given blocks are applied" \
    "Apply the given blocks and no other"
require applying-a-spec-delta "a spec no given block targets gets no copy" \
    "A spec none of them targets gets no copy."
# The check is made while applying, so it lives with the copies.
require applying-a-spec-delta "building a copy checks every block" \
    "Check every block as you apply it: it carries its \`D<n>\`, it names the spec and section it targets"
require applying-a-spec-delta "a block matches main or the block before it" \
    "its unchanged and removed lines match \`main\`, or the text the block ordered before it leaves"
require applying-a-spec-delta "a stale block will not apply" \
    "A block that fails this check does not apply"
require applying-a-spec-delta "returns the path of each copy" \
    "Return the path of each copy, with the path of the spec it copies."
require applying-a-spec-delta "returns the blocks that did not apply" \
    "Return each block that did not apply, with the check it failed."
require applying-a-spec-delta "red flag: applying the blocks in the worktree" \
    "| \"Editing the spec in the worktree is quicker, I'll revert it after\" |"
require applying-a-spec-delta "red flag: fitting a block that does not apply" \
    "| \"This block almost applies, I'll fit it as I go\" |"
require applying-a-spec-delta "says when to go back to the step that invoked it" \
    "Once you have the paths, go on with the step that invoked this skill."
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them.
absent "applying-a-spec-delta names no skill that invokes it" "${entry_names%|}|Step [0-9]" applying-a-spec-delta

# --- running-reread-rounds: the rounds of a reread ---
require running-reread-rounds "says what the invoking skill passes" \
    "The skill that invokes it gives: - the text the rounds revise; - what becomes of each finding; - the readings that go out in the first round only, when it has any."
require running-reread-rounds "waits for every reader" \
    "Every reader returns before anything goes up. Wait for all of them and gather their findings, never a running report"
require running-reread-rounds "findings are instructed, not forwarded" \
    "You instruct the findings; you do not forward them."
require running-reread-rounds "the invoking skill says what becomes of a finding" \
    "Work each one through: the invoking skill says what becomes of it."
require running-reread-rounds "the rulings are applied on the text the rounds revise" \
    "Then put to your human partner what you changed and what you could not settle, and apply their rulings on the text the rounds revise."
require running-reread-rounds "the human is spared a draft" \
    "Forwarding raw findings makes your human partner arbitrate a draft, which is the work the review exists to spare them."
require running-reread-rounds "a ruling can end the rounds" \
    "A ruling the invoking skill says ends the reread ends the rounds."
require running-reread-rounds "a round runs on the revised text" \
    "A round runs on the revised text."
require running-reread-rounds "keeps the state a round read" \
    "Keep a copy of the state each round read: the next round's readers are handed it."
require running-reread-rounds "the rounds have stop conditions" \
    "These stop the rounds, and without them they chain indefinitely"
require running-reread-rounds "a revision retouches" \
    "**A revision retouches.** Change only the sentences a finding names. A section rewritten whole is a section no reader has read, and it sends every reading out again."
require running-reread-rounds "a later round reads only the revision" \
    "**A later round reads the revision, and nothing else.** What a revision adds, moves or rewords is unread; what it takes out reopens only what leaned on it"
require running-reread-rounds "nothing unread opens no round" \
    "A revision that leaves nothing unread opens no round."
require running-reread-rounds "a later round's readings" \
    "Dispatch only the readings the revision bears on: a reworded sentence goes back to the reading that found it wanting, an added one to every reading. Hand each reader the state the round before read, next to the revised one."
require running-reread-rounds "a first-round reading is not dispatched again" \
    "A reading given as going out in the first round only is not dispatched again."
require running-reread-rounds "a later dispatch is composed as the first" \
    "Compose each dispatch as the invoking skill composed the first round's."
require running-reread-rounds "keeps a ledger of problems" \
    "Keep a ledger from round to round: each finding's problem, the round that returned it, and what you did with it. Recognise a finding by its problem, not by its words"
require running-reread-rounds "a returning problem goes to the human" \
    "When a second round returns the same problem, put it to your human partner with the option you recommend, and do not reword it a third time."
require running-reread-rounds "three rounds at most" \
    "**The third round is the last you open.** After it, stop and put to your human partner what is still open, with your recommendation. A further round runs only on their decision."
require running-reread-rounds "the reread does not replace the review" \
    "**The reread prepares the review of the pull request that carries the text, it does not replace it.**"
require running-reread-rounds "returns the text" \
    "Return the text as the rounds leave it."
require running-reread-rounds "says when to go back to the skill that invoked it" \
    "Once the rounds are over, go on with the skill that invoked this one: it says what the reread returns."
# The ledger is the conductor's working note: it is kept, never returned.
absent "running-reread-rounds returns no ledger" "[Rr]eturns? [^.]*ledger" running-reread-rounds
require running-reread-rounds "red flag: a reader is done" \
    "| \"This reader is done, I'll put its findings up now\" | The next reader may displace them. Wait for every reader. |"
require running-reread-rounds "red flag: handing over the findings" \
    "| \"I'll hand my human partner the findings to rule on\" | Instruct them first. Your human partner rules on what you changed and what you could not settle. |"
require running-reread-rounds "red flag: one more round" \
    "| \"One more round, the text can still improve\" | The third round is the last you open. After it, your human partner decides whether another runs. |"
require running-reread-rounds "red flag: a section rewritten whole" \
    "| \"This section reads better rewritten whole\" | A rewritten section is unread, and sends every reading out again. Retouch the sentences a finding names. |"
require running-reread-rounds "red flag: a reworded clause" \
    "| \"I reworded the clause, so this finding is a new one\" | A finding is its problem, not its words. Returned by a second round, it goes to your human partner. |"
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them. This one invokes none, and the skills that
# invoke it are internal too: the guard walks every declared skill.
rounds_other_names="supercharlouze:|superpowers:|calling skill|Step [0-9]"
for declared in $(declared_skills); do
    [ "$declared" = "running-reread-rounds" ] && continue
    rounds_other_names="$rounds_other_names|$declared"
done
absent "running-reread-rounds names no skill" "$rounds_other_names" running-reread-rounds

# --- starting-a-branch: the start of a branch ---
require starting-a-branch "says what the invoking skill passes" \
    "The skill that invokes it gives the name of the branch."
require starting-a-branch "starts from main as the remote carries it" \
    "starts a branch from \`main\` as the remote carries it"
require starting-a-branch "fetches first" "git fetch origin"
require starting-a-branch "creates the branch and its workspace through using-git-worktrees" \
    "**Create the branch and its workspace by invoking \`superpowers:using-git-worktrees\`**"
require starting-a-branch "checks the starting point" \
    "git merge-base --is-ancestor origin/main HEAD"
require starting-a-branch "checks the name" "git branch --show-current"
require starting-a-branch "restores the name and the starting point" \
    "restore the name you were given and the starting point before going on"
require starting-a-branch "restores when isolation was declined" \
    "or isolation was declined, restore the name you were given"
require starting-a-branch "puts both right inside the workspace" \
    "git switch -c <branch> origin/main"
require starting-a-branch "a named branch is not enough" "**A named branch is not enough.**"
require starting-a-branch "a reused worktree creates no branch" \
    "concludes \"already in a linked worktree\" and reuses it without creating a branch"
# The fetch comes first, then the workspace, then the restoration.
skill_text starting-a-branch
case "$SKILL_TEXT" in
    *"git fetch origin"*"superpowers:using-git-worktrees"*"git switch -c <branch> origin/main"*)
        pass "starting-a-branch: fetch, then the workspace, then the restoration" ;;
    *)  fail "starting-a-branch: fetch, then the workspace, then the restoration" ;;
esac
require starting-a-branch "red flag: already in a worktree" \
    "| \"I'm already in a worktree, that will do\" | As a place to work, it will. A branch that starts there will not: the work lands on the branch of the piece of work before. Start the branch from \`origin/main\`, wherever you stand. |"
require starting-a-branch "red flag: the harness named the branch" \
    "| \"The harness already named the branch, that will do\" | Under that name the branch claims nothing of what the name you were given claims. Restore the name you were given. |"
require starting-a-branch "says when to go back to the step that invoked it" \
    "Once the branch is started, go on with the step that invoked this skill, in the workspace of the branch."
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them.
absent "starting-a-branch names no skill that invokes it" "${entry_names%|}|Step [0-9]" starting-a-branch

# --- following-the-rules: the delta block (spec section "The model") ---
require following-the-rules "defines the delta block" "**Delta block** — the unit of a batch's spec delta: one targeted section and the exact text"
require following-the-rules "a block is transcribed word for word" "the exact text it must receive, transcribed word for word by a story"

# --- following-the-rules: the technical story (spec section "The model") ---
require following-the-rules "defines the technical story" \
    "**Technical story** — a story that changes nothing observable at its module's boundary."
require following-the-rules "the qualification is declared" \
    "a declared qualification, caught by its stop condition if it turns out to be false"
require following-the-rules "a batch no longer promises behaviour" \
    "It groups several user stories, and targets one or more modules, hence one or more specs."
require following-the-rules "a technical story has a stop condition too" \
    "you discover that it changes something observable at the module's boundary, stop. The story is no longer technical."
require following-the-rules "a ruling replaces no stop condition" \
    "A ruling replaces none of them"
require following-the-rules "a story stops on a constraint or an ADR it cannot hold" \
    "If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner."
require following-the-rules "a contradicted constraint is not this case" \
    "A constraint the spec contradicts does not fall under this condition: the spec wins."
require following-the-rules "a ruling would break a decision of the batch or of the human" \
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

# --- following-the-rules: the shape of a review's end ---
require following-the-rules "the amendment gate covers the design and the constraints" "the decision to change its scope, its spec delta, its technical design, its constraints or its flag"
require using-batches "routing names the design and the constraints" "A batch must change its scope, its spec delta, its technical design, its constraints or its flag"
require following-the-rules "forbids the agent approving or merging" "never approves and never merges a pull request"
require following-the-rules "pushes corrections as fixups"           "pushed as a \`fixup!\` commit"
require following-the-rules "the agreement is given in conversation" "The human gives their agreement in the conversation"
require following-the-rules "names the merge a clear moment"      "a moment to clear the context"
require following-the-rules "the rule covers every gate"          "Merging any review is a moment to clear the context"
require following-the-rules "the handover is conditional"         "Where a next step exists"
require following-the-rules "the handover prompt stands alone"    "That prompt stands on its own"
require using-batches "an unadopted module stops the design"     "the design stops"
require using-batches "Override 1 stays bounded to steps 6 to 9" "still covers steps 6 to 9 and nothing else"
require using-batches "a bounded change adds and removes entries"  "add an entry and delete one"
require following-the-rules "the prompt waits for the merge"      "The prompt waits for the merge announcement, not for the announcement that the pull request is ready"

# --- following-the-rules: guarded code rules (referencing writing-a-user-story) ---
# The rules for code under a flag are written in full in the foundation, and
# no other skill restates them in part: a partial gloss drifts from its text
# with nothing to signal it.
require following-the-rules "the red flag on a flag that is just an if points at the rules" "on for everyone, and off, under the rules of \`Code Under a Feature Flag\`"
absent_everywhere "no skill glosses the rules for code under a flag" \
    "both states working on the same data|both states work on the same data|a lifting that only removes|lifting only removes"

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

require writing-a-user-story "the story skill sends its transcription to the forms of the gating sentence" \
        "states the flag and its default in a gating sentence, in the form \`supercharlouze:following-the-rules\` fixes."
require following-the-rules "the gating sentence names its variable parts" \
        "The flag's name, its default and its lifting condition vary; the rest of each form is fixed."
require following-the-rules "the foundation gives the forms of the gating sentence" \
        "as a gating sentence in one of these forms, which adds its lifting condition when the declared scope reaches beyond the batch:"

require following-the-rules "a corrective batch's delta carries no block" \
        "**Corrective batch** — a batch that brings existing code back into conformance with a spec that is already true. Its spec delta carries no block."

# --- using-batches: the ADR (spec sections "The model", "Architecture decision
# records" and "Bounded change") ---
require following-the-rules "defines the ADR" \
        "**ADR** — the document that records a technical decision of the project and its reason: a \`.md\` file placed directly in \`docs/adr/\`, at \`docs/adr/<slug>.md\`."
# The reference text of the conditions. Word for word: another skill copies it.
require following-the-rules "the conditions of an ADR, word for word" \
        "A technical decision is recorded as an ADR only if it meets these conditions: - undoing it is expensive; - it surprises whoever does not know its context; - it settles between real alternatives."
require following-the-rules "the human decides every ADR" \
        "**Your human partner decides every ADR.** An agent neither writes, rewrites nor deletes one unless they have decided it."
require following-the-rules "what is observable is a spec rule, never an ADR" \
        "What is observable at a module's boundary is a rule of that module's spec, never an ADR."
require following-the-rules "an ADR contradicts no spec and no other ADR" \
        "An ADR contradicts no spec and no other ADR."
require following-the-rules "a replaced decision is rewritten in place" \
        "An ADR whose decision is replaced is rewritten in place, and one whose decision is abandoned is deleted."
require following-the-rules "the commit that rewrites or deletes an ADR says why" \
        "**The commit that rewrites or deletes an ADR says why.**"
require following-the-rules "the adoption gate reviews the ADRs written with the spec" \
        "| Module adoption | the pull request carrying the spec and the gaps register, and the ADRs written with them |"
require using-batches "routing sends an ADR to a bounded change" \
        "| Your human partner wants an ADR written, rewritten or deleted outside the adoption of a module, the opening of a batch, its amendment, the delivery review of a story and the installation | A bounded change, under \`What Is Kept, What Is Rerouted\` below |"
require writing-in-a-spec "a decision with nothing observable has the ADR for outlet" \
        "Exception: a sentence that states a technical decision has an ADR for outlet, under the conditions \`supercharlouze:following-the-rules\` states."
require writing-in-a-spec "a decision housed outside the specs goes to an ADR" \
        "A technical decision that no module boundary makes observable is not a rule: its outlet is an ADR."
require writing-in-a-spec "the scope paragraph names both outlets" \
        "that is where what the test ejects goes, except a technical decision, which has an ADR for outlet"
require writing-in-a-spec "the red flag names the ADR as the outlet" \
        "A technical decision with nothing observable at a module's boundary is no rule at all: its outlet is an ADR. |"
require using-batches "a bounded change writes, rewrites and deletes ADRs" \
        "**(e) It may write, rewrite and delete ADRs, and may carry nothing but ADRs.**"
require using-batches "a bounded change invokes recording-a-decision" \
        "Invoke \`supercharlouze:recording-a-decision\` to write or rewrite one. Delete yourself the one your human partner abandons, and correct yourself, on their decision, a text whose decision does not change."
require following-the-rules "the code holds the ADRs main carries" \
        "The code of a story or of a bounded change holds the ADRs \`main\` carries when its branch starts."
require following-the-rules "no ADR binds the code already on main" \
        "No ADR binds the code already on \`main\`."
require following-the-rules "the delivery gate carries the ADRs the review asks for" \
        "| Story delivery | the pull request carrying a story's code, its spec change if it has one, and the ADRs the review asks for |"
require following-the-rules "the opening gate carries the ADRs changed with the batch document" \
        "| Batch opening | the pull request carrying the batch document, and the ADRs written, rewritten or deleted with it |"
require following-the-rules "the amendment gate carries the ADRs changed with the decision" \
        "| Batch amendment | the pull request carrying the decision to change its scope, its spec delta, its technical design, its constraints or its flag, and the ADRs written, rewritten or deleted with it |"
require using-batches "the opening writes the ADRs the design decided" \
        "On the architectural path, \`supercharlouze:writing-a-batch\` writes, rewrites or deletes at the opening the ADRs they decide."
require using-batches "the bounded ceremony has an exception" \
        "**Bounded** — ceremony unchanged, except for the reading of \`docs/adr/\` stated below, with these rules:"
require using-batches "the design steps have the same exception" \
        "are **kept intact**, except for the reading of \`docs/adr/\` stated below"
require using-batches "the design reads docs/adr before proposing an approach" \
        "On the bounded path and on the architectural path, read every ADR in \`docs/adr/\` before proposing an approach"
require using-batches "the design puts to the human the decision that meets the conditions" \
        "put to your human partner each technical decision the design takes that meets the conditions of an ADR \`supercharlouze:following-the-rules\` states"
require using-batches "a bounded change holds the ADRs" \
        "**(f) It holds the ADRs \`main\` carries when its branch starts.**"
require using-batches "a bounded change rereads docs/adr once its branch exists" \
        "Once \`bounded/<slug>\` is created, reread \`docs/adr/\` and hold what you find there"
require using-batches "a bounded change puts to the human the ADR it cannot hold" \
        "When you cannot hold an ADR, put it to your human partner: if they rule it untenable, rewrite or delete it under rule (e); otherwise hold it."
require using-batches "a bounded change puts to the human the decision that meets the conditions" \
        "**(g) It puts to your human partner the technical decision it takes that meets the conditions of an ADR \`supercharlouze:following-the-rules\` states.**"
require using-batches "a bounded change writes the ADR the human wants" \
        "If they want it as an ADR, write it under rule (e)."
require following-the-rules "red flag: a decision is put to the human" \
        "| \"This decision is technical, no need to bring it to my human partner\" | If it meets the conditions of an ADR, put it to them: only they decide an ADR. |"
require using-batches "an approach that breaks an ADR is not taken" \
        "An approach that breaks an ADR is one the code may not take, and only your human partner decides an ADR."
require using-batches "a bounded change's decision along the way is put to the human too" \
        "That holds for a decision taken along the way as for one taken at design."
require using-batches "the design read may be stale" \
        "the design read it where you stood, and the branch starts from \`main\` as the remote carries it"

# --- following-the-rules: the glossary terms of the review (spec section "The model") ---
require following-the-rules "defines the pull request" \
        "**Pull request** — a change proposed for \`main\`, which the human reviews before it reaches \`main\`."
require following-the-rules "defines the gate" \
        "**Gate** — the human's review of a pull request, whose merge moves a module, a batch or a story forward."
require following-the-rules "defines the reread" \
        "**Reread** — an agent's check of a piece of work. A reread is not a gate."

require writing-a-user-story "the cases of Blocks: none are examples" \
        "\`none\` for a story that transcribes none, such as a corrective batch's story, a technical story or a teardown story."

# --- following-the-rules, the foundation ---

# The foundation is loaded by whoever executes a task of a plan, who loads no
# other skill: a skill it named would be a text that reader never opens.
foundation_skill_names="supercharlouze:|superpowers:|brainstorming|writing-plans|subagent-driven-development|executing-plans|finishing-a-development-branch|using-git-worktrees|receiving-code-review"
for declared in $(declared_skills); do
    [ "$declared" = "following-the-rules" ] && continue
    foundation_skill_names="$foundation_skill_names|$declared"
done
absent "the foundation names no skill" "$foundation_skill_names" following-the-rules

# Each execution rule has a name a story's Global Constraints can cite.
for rule in "spec freeze" "spec authority" "concision" "corrective stop condition" \
    "code under a feature flag" "technical stop condition" \
    "untenable constraint or ADR" "held ADRs" "decision worth an ADR"; do
    require following-the-rules "names the execution rule: $rule" "| \`$rule\` |"
done

# The rules for code under a flag are written in full in the foundation.
require following-the-rules "guarded code holds up in the three states of the flag" \
    "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off:"
require following-the-rules "the two states work on the same data" \
    "The two states work on the same data: what one produces, the other reads and uses, with no error and no data loss."
require following-the-rules "the flag off gives back the behaviour from before the batch" \
    "With the flag off, the user finds the behaviour from before the batch."
require following-the-rules "the pull request tests each state and their coexistence" \
    "The story's pull request tests the flag-on behaviour, the flag-off behaviour, and their coexistence."
require following-the-rules "lifting only removes" \
    "Lifting the flag comes down to deleting the branching and the behaviour from before the batch, without writing anything new."

# The foundation fixes the forms of the gating sentence.
require following-the-rules "the gating sentence with a lifting condition" \
    "🔒 \`billing.recurring\`, off by default — lifted when the \`facturation\` module is fully delivered"
require following-the-rules "what varies in a gating sentence" \
    "The flag's name, its default and its lifting condition vary; the rest of each form is fixed."

# The foundation fixes the form of a prompt that starts a step in a fresh context.
require following-the-rules "a next-step prompt stands on its own" \
    "it names the skill to invoke and the document to start from, and never refers back to the conversation"

# A decision that meets the conditions of an ADR is reported, never written.
require following-the-rules "a decision worth an ADR is reported as an open ruling" \
    "say so in your report: it is recorded as an \`Open ruling:\`, which asks your human partner whether they want it as an ADR. Write nothing in \`docs/adr/\`."

exit $((FAILURES > 0))
