#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib.sh"

echo "test-skill-content"

# Every document-producing skill states the language rule (Global Constraints, spec 10).
for s in adopting-a-module opening-a-batch writing-a-batch-document delivering-a-story closing-a-batch recording-a-decision; do
    require "$s" "states the language rule" "English skeleton"
done

# Every document-producing skill sends its writer to the concision rules.
for s in adopting-a-module opening-a-batch amending-a-batch writing-a-batch-document delivering-a-story closing-a-batch recording-a-decision; do
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
require adopting-a-module "ends its review with no condition and the first batch as next step" \
    "**To end the review, invoke \`supercharlouze:finishing-a-pr\` and give it no condition, and this next step: \`supercharlouze:opening-a-batch\`, which starts from the adopted spec, named by path with the gaps register beside it.**"
require adopting-a-module "says why the clear matters after an adoption" \
    "the adoption conversation carried every mechanism you read while auditing the code, which is exactly what must not leak into the batch that follows"
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

# --- opening-a-batch (spec 4, 4.3, 5.2, 8.3) ---
require opening-a-batch "an unadopted module stops the design"   "the design stops"
# The preconditions are checked before any branch, and not counted: the count
# once said four over a list of three.
require opening-a-batch "preconditions come before any branch"   "Check them all **before creating any branch**"
require opening-a-batch "the human abandons or sets the design aside" "abandon the design or set it aside"
require opening-a-batch "the design resumes in a fresh context"   "resumes in a fresh context"
require opening-a-batch "NN accounts for open pull requests"      "open pull request"
require writing-a-batch-document "batch document carries no mutable state" "no mutable state"
require writing-a-batch-document "no story list in the batch document"     "list of stories"
require writing-a-batch-document "the story list counts pushed branches" "completed by the open pull requests and by the pushed \`story/*\` branches that carry no pull request yet"
require opening-a-batch "writes no spec at opening"               "no writing into the specs"
require opening-a-batch "the opening has the document written by the shared skill" \
    "To write the batch document, invoke \`supercharlouze:writing-a-batch-document\` and give it this batch's \`NN\` and its slug."
require amending-a-batch "an amendment has the document amended by the shared skill" \
    "To amend the document, invoke \`supercharlouze:writing-a-batch-document\` and give it the batch document and what the amendment changes in it."
require opening-a-batch "no block is transcribed at opening" \
    "No block is transcribed at opening: each one is transcribed by a story, in that story's own pull request"
require amending-a-batch "an amendment says in its body what changed" \
    "Say in the pull request body what changed and why."
require opening-a-batch "PR review is the human gate"             "review of the batch pull request"
require writing-a-batch-document "declares the Feature flag field"         "Feature flag"
require writing-a-batch-document "flag field is never left empty"          "never left empty"
require writing-a-batch-document "flag is per batch and module"            "per (batch, module)"
require writing-a-batch-document "extended scope names its lifting condition" "lifting condition"
require writing-a-batch-document "the specs are the registry of flags"     "The specs are the registry of flags"
require writing-a-batch-document "a lifting is stated in the spec delta"   "state its lifting in the \`Spec delta\`"
require amending-a-batch "amendment pull request exists"           "amendment pull request"
require amending-a-batch "an amendment covers the design and the constraints" "An amendment changes the scope, the spec delta, the technical design, the constraints or the flag of an open batch"
require amending-a-batch "a design or a constraint that must change is a dead end" "**A batch whose technical design or constraints must change**"
require amending-a-batch "an amendment branch follows no pattern"  "follows none of this plugin's branch patterns"
require amending-a-batch "a delta amendment is reviewed as an opening" "By exception, an amendment that changes the spec delta is reviewed as an opening"
# An amendment says which rereads it owes by what it changes, and passes them.
require amending-a-batch "an amendment owes the technical reread" \
    "An amendment that changes the spec delta, the technical design or the constraints, or that writes or rewrites an ADR, owes the technical reread."
require amending-a-batch "a delta amendment owes the other rereads as well" \
    "One that changes the spec delta owes the coherence reread and the batch-document reread as well."
require amending-a-batch "an amendment has its rereads conducted by the shared skill" \
    "invoke \`supercharlouze:rereading-a-batch\` and give it the amended document, its new or changed blocks together with every block no merged story has declared yet, the rereads it owes, and the path of each ADR it writes or rewrites"
require amending-a-batch "a behaviour or a block taken back makes a delta amendment" "A behaviour or a block that skill returns as taken back to the spec delta makes the amendment one that changes the spec delta"
require amending-a-batch "an amendment's body says what its rereads found" "The body of an amendment says what each of its rereads found, or that it found nothing."
require amending-a-batch "an amendment's body says when there was nothing to reread" "When the technical reread returned that it had nothing to reread, the body says that instead."
require amending-a-batch "its body carries what an opening body carries" "the exact text of every new or changed block, and what the coherence reread found"
require amending-a-batch "an amendment writes, rewrites or deletes ADRs" "An amendment's pull request may also write, rewrite or delete the ADRs your human partner decided with the amendment."
require amending-a-batch "its ADRs come once the document is amended" "Do it once the document is amended."
require amending-a-batch "its ADRs meet the pending blocks of the amended document" "Before writing or rewriting one, invoke \`supercharlouze:applying-a-spec-delta\` and give it the amended document and every block of it that no merged story has declared yet: it returns the copies of the specs, blocks applied."
require amending-a-batch "an amendment's ADR is confronted with the specs as the batch leaves them" "An ADR is confronted with the specs as the batch leaves them, and those blocks are in no spec yet."
require amending-a-batch "an amendment's ADR is written by the shared skill" "Invoke \`supercharlouze:recording-a-decision\` for each ADR to write or to rewrite, and hand it those copies."
require amending-a-batch "an amendment deletes an abandoned ADR" "Delete yourself each ADR your human partner abandoned, in a commit that says why."
require amending-a-batch "its body states the ADRs" "The pull request body states each ADR it writes, rewrites or deletes."
require amending-a-batch "a change of ADRs alone is a bounded change" "A change that touches nothing but ADRs is not an amendment: it goes through a bounded change, under \`supercharlouze:making-a-bounded-change\`."
require amending-a-batch "red flag: an amendment for an ADR alone" "| \"My human partner wants this ADR rewritten, I'll amend the batch for it\" | An amendment changes the batch document. A change that touches nothing but ADRs goes through a bounded change. |"
require amending-a-batch "red flag: an amendment's ADR is reread" "| \"This amendment only changes the scope, the ADR it writes needs no reread\" | An amendment that writes or rewrites an ADR goes through the technical reread, whatever else it changes. |"
require amending-a-batch "an amendment releases what it drops" "An amendment that takes a gaps register entry out of \`Scope\` releases its reservation in the same pull request"
require amending-a-batch "an amendment reserves what it adds" "An amendment that adds a gaps register entry to \`Scope\` reserves it in the same pull request"
require amending-a-batch "an entry without its annotation reads as free" "An entry taken on without its annotation still reads as free, and another batch can reserve it too."
require amending-a-batch "red flag: a reservation is not an opening ceremony" "| \"Reservations are posted at opening, this amendment only edits \`Scope\`\" | A batch reserves every entry it takes on, whenever it takes it on. Reserve in this pull request the entry the amendment adds, or another batch can reserve it too. |"
require writing-a-batch-document "an obvious design is still written" "An obvious design is still a design: write it."
require closing-a-batch "an amendment already released what it dropped" "An entry an amendment took out of \`Scope\` is not among them: that amendment released it."
require delivering-a-story "an abandonment leaves closing the reservation no amendment released" "unless an amendment took its entry out of \`Scope\` and released it"
require closing-a-batch "an amendment's release is the one exception" "except an amendment that takes a reserved entry out of \`Scope\` and releases it"
require closing-a-batch "closing releases whatever the batch reserved" "For every gaps register entry this batch reserved (\`reserved by batch-NN\`) that is still in the file, release it."
require closing-a-batch "what an abandonment leaves came from the opening or an amendment" "put there by the batch's opening pull request or by one of its amendments: the gaps register entry the batch reserved"
require abandoning-a-story "what stays on main came from the opening or an amendment" "were put there by the batch's opening pull request or by one of its amendments, and abandoning a story leaves them as they are."
require delivering-a-story "an abandonment leaves closing the reservation the batch posted" "and the gaps register reservation the batch posted, unless an amendment took its entry out of \`Scope\` and released it"
require opening-a-batch "whatever batch takes an entry on reserves it" "**Whatever batch takes an entry on** reserves it, so that two batches cannot draw the same entry."
# What follows a stop lives in handling-a-stopped-story; using-batches only routes to it.
require using-batches "a fired stop condition routes to handling-a-stopped-story" "When one of them fires, you stop, and \`supercharlouze:handling-a-stopped-story\` conducts what follows."
require using-batches "the routing table leads to handling-a-stopped-story" "| A story has stopped on a stop condition this flow adds | \`supercharlouze:handling-a-stopped-story\` |"
require using-batches "the routing table leads an amendment to amending-a-batch" "| A batch must change its scope, its spec delta, its technical design, its constraints or its flag | \`supercharlouze:amending-a-batch\` |"
require amending-a-batch "the patterns are all named"              "\`adopt/<module>\`, \`batch/NN-<slug>\`, \`batch/NN-<slug>-close\`, \`story/NN-us-N-<slug>\`, \`bounded/<slug>\`, \`chore/supercharlouze-init\`"
require amending-a-batch "a pattern name claims what it does not hold" "would claim what it does not hold"
require amending-a-batch "the amendment declares the flag the block requires" \
    "An amendment that adds the block of an observable change a technical story revealed declares the flag that block requires, if it requires one."
require amending-a-batch "the exemption question is asked again" \
    "Ask the exemption criterion again of the batch with its new block"
require amending-a-batch "a stopped story is ruled on before it is amended for" \
    "**When a story has stopped and nothing is ruled yet, go to \`supercharlouze:handling-a-stopped-story\` first**"
require delivering-a-story "the human rules the block and its flag" \
    "a block for the observable change, and the flag that block requires, if it requires one"
require opening-a-batch "branch naming convention"                "batch/NN"

# --- handling-a-stopped-story: what follows a stop condition ---
require handling-a-stopped-story "the story stays, the human rules, the story is abandoned or resumes" \
    "The story stays as it stands, your human partner rules between the options of that condition, then the story is abandoned or resumes."
require handling-a-stopped-story "the foundation states the conditions" \
    "\`Stop Conditions\` in \`supercharlouze:following-the-rules\` states each of them."
require handling-a-stopped-story "the entry point of a corrective batch names its section" \
    "| A corrective batch that turned out not to be corrective | Requalifying a Corrective Batch |"
require handling-a-stopped-story "the entry point of a technical story names its section" \
    "| A technical story that turned out to change something observable | Requalifying a Technical Story |"
require handling-a-stopped-story "the entry point of a constraint or an ADR names its section" \
    "| A story stopped on a constraint of its batch or an ADR it cannot hold | A Constraint or an ADR a Story Cannot Hold |"
require handling-a-stopped-story "requalifies a corrective batch" \
    "## Requalifying a Corrective Batch"
require handling-a-stopped-story "a corrective story is abandoned once ruled" "1. **Leave the story as it stands until the choice below is ruled, then abandon it.**"
require handling-a-stopped-story "an open pull request waits for the ruling" "A pull request already open stays open until then."
require handling-a-stopped-story "a corrective story goes through abandoning-a-story once ruled" "Once the choice is ruled, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch"
require handling-a-stopped-story "requalification offers a different batch" "**Rule the remaining work a different batch**"
require handling-a-stopped-story "requalification offers a spec correction carried by a bounded change" \
    "- **Correct the spec**: a bounded change carries the correction they decide, and an amendment reduces the scope of the batch, which stays corrective;"
require handling-a-stopped-story "the steps the ruling asks for release what the batch drops" "The steps the ruling asks for release the reservations of the entries the batch no longer takes on; this session releases none. A reduced or rewritten scope releases them in the amendment pull request that changes \`Scope\`."
require handling-a-stopped-story "the substance of a requalification is the human's" \
    "Never carry out a requalification by deciding the substance yourself."
require handling-a-stopped-story "requalifies a technical story" \
    "## Requalifying a Technical Story"
require handling-a-stopped-story "a technical story stays as it stands until the ruling" "1. **Leave the story as it stands until your human partner has ruled whether the observable change is wanted, then abandon it.** A pull request already open stays open until then. Once it is ruled, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch."
require handling-a-stopped-story "a technical story goes through abandoning-a-story once ruled" "Once it is ruled, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch"
require handling-a-stopped-story "an observable change needs a block" \
    "it needs a block, and a block is acquired by an amendment that goes back through the opening review"
require handling-a-stopped-story "an unwanted change amends nothing" \
    "If the human judges the observable change unwanted instead, there is nothing to amend: the story is abandoned and the batch carries on as it was."
require handling-a-stopped-story "the human rules on a constraint or an ADR a story cannot hold" \
    "**When a story stops on a constraint or an ADR it cannot hold, your human partner rules on the constraint or the ADR.**"
require handling-a-stopped-story "the condition leaves the branch as it is" \
    "Until then the branch and the worktree stay as they are."
require handling-a-stopped-story "an untenable constraint or ADR abandons the story" \
    "If they rule it untenable, the story is abandoned: invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch."
require handling-a-stopped-story "what holds resumes the story" \
    "Otherwise the story resumes and holds the constraint or the ADR, and nothing is amended."
require handling-a-stopped-story "the next steps start in a fresh context" \
    "A ruling that abandons the story may ask for next steps. They start in a fresh context: this conversation carries a stopped execution, and each step is conducted from a document."
require handling-a-stopped-story "asks for a clear context once the story is abandoned, when the ruling asks for next steps" \
    "When it does, once the story is abandoned: 1. **Ask your human partner to clear the context.**"
require handling-a-stopped-story "the prompt takes its form from the foundation" \
    "2. **Give the prompt that starts the next steps**, in the form \`The Git Model\` in \`supercharlouze:following-the-rules\` fixes."
require handling-a-stopped-story "the prompt states the ruling, then each step with its skill and its document" \
    "It states the ruling, then the steps of its row below, in their order, each with the skill to invoke and the document it starts from, by its path. State the ruling as your human partner gave it"
require handling-a-stopped-story "the ruling is stated with the story and what it revealed" \
    "State the ruling as your human partner gave it, and name the story and what it revealed. Not: \"Carry on with the requalification.\" Good: \"Technical story \`07-us-4-renommer-les-echeances\` was abandoned: it changes how a prorated amount is rounded, and that change is wanted.\""
require handling-a-stopped-story "a corrected spec comes with a reduced scope" \
    "| The spec is corrected, and the batch stays corrective on a reduced scope | \`supercharlouze:amending-a-batch\` reduces the \`Scope\`, from the batch document. Then \`supercharlouze:making-a-bounded-change\` carries the correction your human partner decides, from the spec. |"
require handling-a-stopped-story "a rewritten batch goes to an amendment" \
    "| The corrective batch is rewritten as an ordinary batch | \`supercharlouze:amending-a-batch\` rewrites it, from the batch document. |"
require handling-a-stopped-story "a different batch closes this one first" \
    "| The remaining work is a different batch | \`supercharlouze:closing-a-batch\` closes this batch, from the batch document. Then \`supercharlouze:opening-a-batch\` opens the fresh one, from the gaps register whose entries this batch released. |"
require handling-a-stopped-story "a wanted change goes to an amendment, then to an ordinary story" \
    "| The observable change of a technical story is wanted | \`supercharlouze:amending-a-batch\` adds its block, from the batch document. Once that pull request merges, \`supercharlouze:delivering-a-story\` rewrites the work as an ordinary story of the amended batch, from the amended batch document. |"
require handling-a-stopped-story "an untenable constraint goes to an amendment" \
    "| A constraint is untenable | \`supercharlouze:amending-a-batch\` changes or removes it, from the batch document. |"
require handling-a-stopped-story "an untenable ADR goes to a bounded change" \
    "| An ADR is untenable | A bounded change, under \`supercharlouze:making-a-bounded-change\`, rewrites or deletes it, from the ADR. |"
require handling-a-stopped-story "red flag: the next step does not run in this conversation" \
    "| \"The ruling is fresh in this conversation, I'll run the amendment here\" | This conversation carries a stopped execution, which can contradict the document the next step starts from. Ask your human partner to clear the context, and give the prompt. |"
require handling-a-stopped-story "red flag: only the human corrects a spec" \
    "| \"The spec is wrong here, I'll fix it and keep the batch corrective\" | Only the human corrects a spec. Stop the story, present the requalification choice. |"
require handling-a-stopped-story "red flag: requalification does not start by closing" "| \"Requalification starts by closing the story's pull request\" | The story stays as it stands until your human partner has ruled. A pull request already open is closed with the story, once it is abandoned. |"
require handling-a-stopped-story "the red flag keeps the ruling with the human" "Whether a constraint can be held is your human partner's ruling."
absent_everywhere "no step of a ruling is left to the human" \
    "named as theirs|ships through its own pull request|corrects the spec, through a pull request of its own"

# --- writing-a-batch-document: the batch document contract (spec section "The batch document") ---
# The guards that stay on opening-a-batch here hold what its reread and its pull
# request body say of the document.
require writing-a-batch-document "template declares the Constraints section" "## Constraints"
require writing-a-batch-document "Constraints are copied verbatim to stories" "Every story's \`Global Constraints\` copies this section **verbatim**"
require writing-a-batch-document "Constraints carry nothing normative"       "Nothing normative goes in \`Constraints\`"
require writing-a-batch-document "Constraints keep shared decisions from being reinvented" \
    "and its own version of a decision the rest of the design relies on"

require writing-a-batch-document "the delta is exact text, in blocks"        "written here as **exact text, in blocks**"
require writing-a-batch-document "a block carries a unique D<n>"             "Each one carries an identifier \`D<n>\`, unique within the batch"
require writing-a-batch-document "a block shows its change in its paragraph" "A block shows what it changes in the paragraph that contains it"
require writing-a-batch-document "the paragraph is given as a diff"           "Give the paragraph in a \`diff\` fence"
require writing-a-batch-document "the paragraph is taken from main"           "take the paragraph from \`main\` as it stands"
require writing-a-batch-document "no block is attached to a story"           "No block is attached to a story"
require writing-a-batch-document "two changes to a section are two blocks"   "carries two blocks, and \`Constraints\` states their order"
require writing-a-batch-document "a lifting is a block removing the sentence" "as a block that removes its gating sentence"
require writing-a-batch-document "the batch document faces several specs" "the one document that faces several specs at once"
require writing-a-batch-document "twin blocks are not a delta"        "two blocks writing the same rule into two specs"
# Closing finds an undelivered block from the `Blocks:` declarations, not from what
# reached the specs (spec section "Closing a batch"). The two coincide on the nominal
# path and part exactly where a block was fitted to a `main` that had moved: it was
# transcribed and it was declared, but its text no longer matches the delta.
require writing-a-batch-document "undelivered means nobody declared it"      "the delta announced and no story declared"

# The `Spec delta` field is never blank: it carries blocks, or `none` and the
# reason (spec section "The batch document"). A blank is an omission nobody
# can review, exactly as an omitted `Feature flag` would be; the `none` and
# its reason make "no block" a statable decision rather than a silence.
require writing-a-batch-document "the delta field is never left blank"       "The \`Spec delta\` field is never left blank"
require writing-a-batch-document "the field carries blocks or none"          "It carries the blocks, or \`none\` and the reason"
require writing-a-batch-document "a corrective batch lists its entries in Scope" "Its \`Spec delta\` reads \`none\` with that reason, and its \`Scope\` lists the *Violations* entries it takes on"
require writing-a-batch-document "the template forbids a blank delta"        "Never left blank: with no block, \`none\` and the reason"
require writing-a-batch-document "the template's Scope names the entries"    "<What this batch delivers, including every gaps register entry it takes on.>"
require writing-a-batch-document "the template's Constraints are bounded"    "<Only the migration and compatibility constraints, the technical decisions the rest of the technical design relies on, and the required order of the stories and of the blocks."
# A technical decision is a constraint only when the rest of the technical design
# relies on it (spec section "The batch document"); every other one is design.
require writing-a-batch-document "a decision is a constraint only if the design relies on it" \
    "A technical decision goes in \`Constraints\` only if the rest of the technical design relies on it"
require writing-a-batch-document "every other decision is design" \
    "Every other technical decision goes in \`Technical design\`, where a story may depart from it."
# A batch's constraints bind only its stories (spec section "The batch document"):
# neither another batch nor the code that comes after the batch has to hold them.
require writing-a-batch-document "a batch's constraints bind only its stories" \
    "A batch's constraints bind only its stories."
require opening-a-batch "the PR body puts the constraints to the reviewer" \
    "the technical design, or the reason for its \`none\`; the constraints; the flag decision;"
# The batch document carries the technical design of its stories (spec section
# "The batch document"): between the delta and the constraints, never blank.
require writing-a-batch-document "the template places the design after the delta" \
    "with no block, \`none\` and the reason.> ## Technical design <The design your human partner approved during the brainstorming"
require writing-a-batch-document "the template places the design before the constraints" \
    "with no design, \`none\` and the reason.> ## Constraints"
require writing-a-batch-document "the design field is never left blank" \
    "Never left blank: with no design, \`none\` and the reason"
require writing-a-batch-document "the design comes from the brainstorming" \
    "\`Technical design\` carries the design your human partner approved during \`superpowers:brainstorming\`"
require writing-a-batch-document "a story may depart from the design" \
    "a story may depart from it by recording a \`Technical design ruling:\`"
require writing-a-batch-document "an observable behaviour is a block, not design" \
    "What a user or a neighbouring module would observe goes in a block, never in \`Technical design\`."
require opening-a-batch "the PR body puts the design to the reviewer" \
    "the technical design, or the reason for its \`none\`;"

# --- opening-a-batch: the opening review (spec section "Opening a batch") ---
require opening-a-batch "the opening review bears on the exact text" "It bears on the exact text of every block"
require opening-a-batch "the text is read in the batch document"     "block by block, in the batch document"
require opening-a-batch "the PR body puts the block text to the reviewer" "has to rule on: the exact text of every block"
# With no block there is no block text to read, and the gate is the same gate
# (spec section "Opening a batch"). What it reads instead is the reason for
# the `none` and the entries `Scope` takes on, so a blockless batch passes
# the opening review rather than passing it by.
require opening-a-batch "a blockless delta still faces the gate" "the review bears on what stands in their place"
require opening-a-batch "what the gate reads in the blocks' place" "the reason for the \`none\`, and the entries \`Scope\` takes on"
require opening-a-batch "the PR body carries it to the reviewer" "the exact text of every block, or the reason for the \`none\`"

# --- opening-a-batch: the ordered opening, and the rereads it places ---
require opening-a-batch "the opening is stated in order"        "Opening a new batch runs these steps, in this order"
# Step 3 names every field the opening writes (spec section "Opening a batch").
# `Constraints` was the one missing: a step that lists three fields out of four
# reads as exhaustive, and the field it leaves out is the one each story copies
# verbatim into its `Global Constraints`.
require opening-a-batch "step 3 names every field it writes"    "3. **Write the batch document**: \`Scope\`, \`Spec delta\`, \`Technical design\`, \`Constraints\`, \`Feature flag\`"
require opening-a-batch "step 3 ends on the ADRs"               "then write, rewrite or delete the ADRs your human partner decided (\`The ADRs\`)"
# The opening places the rereads and says which are due; `rereading-a-batch`
# conducts them.
require opening-a-batch "the rereads are step 5" \
    "5. **Have the batch reread**: the coherence reread, the technical reread and the batch-document reread (\`The Rereads\`)."
require opening-a-batch "the pull request is step 6" \
    "6. **Open the pull request** from \`batch/NN-<slug>\`"
require opening-a-batch "the opening has its rereads conducted by the shared skill" \
    "Invoke \`supercharlouze:rereading-a-batch\` and give it the batch document, every block of its spec delta, those rereads as the rereads due, and the path of each ADR this pull request writes or rewrites."
require opening-a-batch "an opening owes every reread" \
    "**An opening owes every reread, whatever the batch carries.** A reread that has nothing to read says so itself."
require opening-a-batch "the pull request body says what each reread found" \
    "The body of the pull request says what each reread found, or that it found nothing."
require opening-a-batch "the pull request body says when there was nothing to reread" \
    "When the technical reread returned that it had nothing to reread, the body says that instead."
require opening-a-batch "a reread is visible from the pull request" \
    "A reread nobody can see from the pull request is a practice again, not a rule."
require opening-a-batch "red flag: skipping the technical reread" \
    "| \"The batch has no design and no constraints, I'll skip the technical reread\" | An opening owes every reread. The technical reread says itself when it has nothing to reread, and it rereads the ADRs this pull request writes. |"

# --- opening-a-batch: the ADRs of an opening (spec section "Opening a batch") ---
require opening-a-batch "the ADRs change in the opening pull request" "Write, rewrite or delete in this pull request, with the batch document, the ADRs your human partner decided during the brainstorming."
require opening-a-batch "the blocks are applied before an ADR is written" "Before writing or rewriting one, invoke \`supercharlouze:applying-a-spec-delta\` and give it the batch document and every block of its spec delta: it returns the copies of the specs, blocks applied."
require opening-a-batch "an ADR is confronted with the specs as the batch leaves them" "An ADR is confronted with the specs as the batch leaves them, and no block is in a spec yet."
require opening-a-batch "an ADR is written by the shared skill" "Invoke \`supercharlouze:recording-a-decision\` for each ADR to write or to rewrite, and hand it those copies."
require opening-a-batch "an abandoned ADR is deleted" "Delete yourself each ADR your human partner abandoned, in a commit that says why."
require opening-a-batch "the PR body puts the ADRs to the reviewer" "any flag lifting the delta announces; and each ADR this pull request writes, rewrites or deletes."
require opening-a-batch "red flag: writing the ADR by hand" "| \"My human partner decided this ADR, I'll write the file myself\" | Invoke \`supercharlouze:recording-a-decision\`. It confronts the decision with the specs, blocks applied, and with the other ADRs. |"
require opening-a-batch "red flag: an ADR nobody decided" "| \"This design decision deserves an ADR, I'll write it with the batch\" | Only your human partner decides an ADR. Put the decision to them, and write it once they want it. |"

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

# --- opening-a-batch: ending the opening and amendment reviews ---
require opening-a-batch "an opening ends its review with no condition and the first story as next step" \
    "**To end the review, invoke \`supercharlouze:finishing-a-pr\` and give it no condition, and this next step: \`supercharlouze:delivering-a-story\`, which starts from the batch document, with a prompt that says to choose the blocks from those the document still carries.**"
require opening-a-batch "the merged document carries the design too" \
    "the exact text of every block and the technical design, which is what the design conversation was for"
require amending-a-batch "an amendment ends its review with no condition and hands back to the batch" \
    "**To end the review of an amendment, invoke \`supercharlouze:finishing-a-pr\` and give it no condition, and this next step: whatever the batch was doing when it stopped, with the skill that conducts it, starting from the amended batch document.**"
require amending-a-batch "an amendment a ruling started hands on the step that follows it" \
    "When the prompt that started the amendment states a ruling and names a step after the amendment, give that step instead, with its skill and its document, and have its prompt state the ruling."
require opening-a-batch "allocation reads main on the remote" "git ls-tree --name-only origin/main docs/batches/"

# --- delivering-a-story (spec 3, 4.4, 5.1, 5.3) ---
require delivering-a-story "concurrency via declared Sections"  "Sections:"
require delivering-a-story "transcription is the first commit"  "first commit on the branch"
require delivering-a-story "freeze travels in Global Constraints" "Global Constraints"
require delivering-a-story "freeze ends when the PR opens"      "freeze is lifted when the pull request opens"
require delivering-a-story "hands off to writing-plans"         "superpowers:writing-plans"
require delivering-a-story "requires SDD"                       "superpowers:subagent-driven-development"
require delivering-a-story "constrains finishing to the PR"     "Push and create a Pull Request"
require delivering-a-story "records rulings before the merge"   "Rulings log"
require delivering-a-story "records observed drift"             "Observed drift"
require delivering-a-story "an open ruling has its own form"    "An open ruling is written \`Open ruling:\`"
require delivering-a-story "an open ruling says what is left"   "ends with what is left to settle, then with the gaps register category"
# The plan starts from the batch's technical design, and every departure is a
# technical design ruling (spec section "Delivering a story").
require delivering-a-story "the plan starts from the technical design" \
    "**The plan starts from the batch's \`Technical design\`**, and its \`Architecture:\` line derives from it."
require delivering-a-story "an ADR wins over the design, then main's code" \
    "Exceptions: where an ADR contradicts the design, the plan follows the ADR; elsewhere, where the code on \`main\` has departed from the design, as an earlier story of the batch may have, the plan starts from the code."
require delivering-a-story "the plan reads docs/adr in the story's worktree" \
    "Read every ADR in \`docs/adr/\`, in this story's worktree, before writing the plan"
require delivering-a-story "no design, nothing to start from" \
    "A batch whose \`Technical design\` is \`none\` gives the plan nothing to start from."
# Every departure, the plan's as well as the execution's, is recorded at Step 6.
require delivering-a-story "step 6 records every departure from the design" \
    "Write as a \`Technical design ruling:\`, with the three parts of a \`Ruling:\`, every departure from the batch's \`Technical design\` that the plan or the execution took, except where the plan follows an ADR or the code on \`main\`."
require delivering-a-story "answers review feedback"            "review feedback"
require delivering-a-story "an open ruling needs a destination"  "A story does not merge leaving an open ruling without a destination"
require delivering-a-story "the review is the last place to act" \
    "Your human partner has the rulings in front of them here, and nowhere later."
require delivering-a-story "ends its review on the condition of its open rulings" \
    "**To end the review, invoke \`supercharlouze:finishing-a-pr\` and give it this condition: no \`Open ruling:\` without a destination stands in the \`Rulings log\`.**"
require delivering-a-story "story branch naming convention"     "story/NN"
require delivering-a-story "spec change states flag and default" "states the flag and its default"
require delivering-a-story "the gating sentence follows the story's module" "If the batch declares a feature flag for this story's module"
require delivering-a-story "one lifting story per module"       "one lifting story per guarded module"
require delivering-a-story "teardown story exists"              "teardown story"
require delivering-a-story "a technical story declares itself" \
    "**A technical story carries \`Technical: yes\` in its header**"
require delivering-a-story "a technical story touches no section" \
    "its \`Sections:\` is \`none\`"
require delivering-a-story "no other story carries that field" \
    "No other story carries that field"
require delivering-a-story "a fired stop condition routes to handling-a-stopped-story" \
    "**When one of them fires, stop: \`supercharlouze:handling-a-stopped-story\` conducts what follows.**"
require delivering-a-story "a rule belongs to exactly one spec" "A rule belongs to exactly one spec."
require delivering-a-story "no ruling houses a rule twice"      "no ruling puts a rule in two places"

# --- delivering-a-story: what Global Constraints carries (spec section "The user story document") ---
require delivering-a-story "GC carries the batch Constraints"   "\`Constraints\` section copied verbatim"
require delivering-a-story "GC carries the spec freeze"         "freeze of the spec file"
require delivering-a-story "GC carries the authority rule"      "That rule is the authority rule \`Global Constraints\` carries"
require delivering-a-story "the authority rule is stated in full" "the spec wins — without exception and without deliberation"
require delivering-a-story "GC carries the corrective stop condition" "the stop condition proper to a corrective batch, written out in full"
require delivering-a-story "GC lists the concision rules"       "- the concision rules;"
require delivering-a-story "GC carries the concision rules"     "In every story, \`Global Constraints\` carries the concision rules, written out in full"
require delivering-a-story "the concision block names what it covers" "These rules hold for every document, pull request body and commit message this story writes"
require delivering-a-story "GC carries the guarded-code rules"  "carries the rules for code under a flag, written out in full"
require delivering-a-story "GC carries the technical stop condition" "carries the stop condition proper to a technical story, written out in full"
require delivering-a-story "GC lists the technical stop condition" "- **in a technical story only**, the stop condition proper to a technical story"
require delivering-a-story "GC lists the stop condition on a constraint or an ADR" \
    "- **only if the batch declares constraints or \`docs/adr/\` carries an ADR**, the stop condition on a constraint or an ADR that cannot be held"
require delivering-a-story "GC carries the stop condition on a constraint or an ADR" \
    "**In a story whose batch declares constraints, or whose \`docs/adr/\` carries an ADR, \`Global Constraints\` carries the stop condition on a constraint or an ADR that cannot be held, written out in full.**"
require delivering-a-story "a batch declares constraints when they are not none" \
    "A batch declares constraints when its \`Constraints\` section is not \`none\`."
require delivering-a-story "docs/adr carries an ADR when a .md file sits in it" \
    "\`docs/adr/\` carries an ADR when a \`.md\` file is placed directly in it, in this story's worktree."
require delivering-a-story "working around a constraint or an ADR breaks what the implementer cannot see" \
    "A constraint is a decision another story of the batch relies on, and an ADR is a decision your human partner took for all the code to come, so an implementer who works around either breaks something they cannot see."
require delivering-a-story "step 5 names both triggers of the condition" \
    "In a story whose batch declares constraints or whose \`docs/adr/\` carries an ADR: if, while conducting it, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner."
require delivering-a-story "step 5 sets aside the constraint the spec contradicts" \
    "A constraint the spec contradicts is not this case, since the spec wins."
require delivering-a-story "the worktree carries the ADRs the code holds" \
    "the worktree carries the ADRs \`main\` carried when the branch started, which are the ones this story's code holds."
require delivering-a-story "an implementer leaves the ADR to the review" \
    "Only your human partner decides an ADR, so an implementer who takes such a decision reports it and leaves the file to the review."
require delivering-a-story "GC lists the ADRs the code holds" \
    "- **only if \`docs/adr/\` carries an ADR**, the paths of the ADRs this story's code holds;"
require delivering-a-story "GC lists the conditions of an ADR" \
    "- the conditions of an ADR, with the obligation to record as an \`Open ruling:\` the decision that meets them."
require delivering-a-story "GC carries the paths of the ADRs" \
    "**When \`docs/adr/\` carries an ADR, \`Global Constraints\` lists the path of each one, under the sentence below.**"
require delivering-a-story "the sentence the paths sit under" \
    "The code this story writes holds these ADRs."
require delivering-a-story "an ADR left out of the list binds nobody" \
    "An implementer reads only this list, so an ADR whose path is missing from it binds nobody."
require delivering-a-story "GC carries the conditions of an ADR" \
    "**In every story, \`Global Constraints\` carries the conditions of an ADR, written out in full, with the obligation to record the decision that meets them.**"
require delivering-a-story "a task records the decision as an open ruling" \
    "When you take a technical decision that meets them, say so in your report: it is recorded as an \`Open ruling:\`, which asks your human partner whether they want it as an ADR. Write nothing in \`docs/adr/\`."
require delivering-a-story "no task writes in docs/adr" \
    "No task writes in \`docs/adr/\`. The ADR a decision of this story deserves is written at the review (Step 7), once your human partner wants it."
require delivering-a-story "step 6 records the decision that meets the conditions" \
    "Write as an \`Open ruling:\` every technical decision the plan or the execution took that meets the conditions of an ADR, its line ending with whether your human partner wants it as an ADR."
require delivering-a-story "the review settles the ADR" \
    "If they want the ADR, invoke \`supercharlouze:recording-a-decision\` and commit the file it writes in a commit of its own."
require delivering-a-story "the human settles the open ruling on an ADR" \
    "**Your human partner settles an open ruling on a decision that meets the conditions of an ADR.**"
require delivering-a-story "nothing written is recorded" \
    "If nothing is written, record in the \`Rulings log\` what they ruled."
require delivering-a-story "a later correction of the ADR is a fixup" \
    "A correction of the ADR's text asked for afterwards, which does not change its decision, is a \`fixup!\` of that commit."
require delivering-a-story "red flag: a departure left out surprises the review" \
    "| \"My plan departs only slightly from the design, no ruling needed\" | Every departure is a \`Technical design ruling:\`. One left out reaches the delivery review as a surprise. |"
require delivering-a-story "red flag: the plan follows the ADR, then main's code" \
    "| \"\`main\`'s code contradicts the design, so the design wins\" | The design only guides. Where an ADR contradicts it, the plan follows the ADR; elsewhere, where \`main\`'s code departed from it, the plan starts from the code. |"
require delivering-a-story "red flag: no task writes the ADR" \
    "| \"This decision deserves an ADR, I'll write it with the code\" | No task writes in \`docs/adr/\`. Record an \`Open ruling:\`, and write the ADR at the review if your human partner wants it. |"
require delivering-a-story "red flag: a ruling replaces no stop condition" \
    "| \"This constraint, or this ADR, cannot be held, I'll work around it and record a ruling\" | A ruling replaces no stop condition. Another story of the batch relies on that constraint, and your human partner decided that ADR: stop and put it to them. |"
require delivering-a-story "the owning batch does not decide"   "whether the flag was declared by this story's batch or by another one"
require delivering-a-story "GC is the only channel to SDD subagents" "only channel to this skill's rules is this list"

# --- delivering-a-story: the rules a guarded story copies into Global
# Constraints (spec section "Code under a feature flag") ---
require delivering-a-story "guarded code holds up in every situation" "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off:"
require delivering-a-story "both states work on the same data" "The two states work on the same data: what one produces, the other reads and uses, with no error and no data loss."
require delivering-a-story "flag off restores the former behaviour" "With the flag off, the user finds the behaviour from before the batch."
require delivering-a-story "both states and their coexistence are tested" "The story's pull request tests the flag-on behaviour, the flag-off behaviour, and their coexistence."
require delivering-a-story "lifting only removes"               "Lifting the flag comes down to deleting the branching and the behaviour from before the batch, without writing anything new."
require following-the-rules "the foundation states the rules for code under a flag" "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off:"

# --- delivering-a-story: Lifting and Teardown Stories ---
require delivering-a-story "an observation period is two stories" "the first moves the declared default of the gating sentence from \`off\` to \`on\`"
require delivering-a-story "declared default is not the effective state" "The declared default and the effective state are two different things"
require delivering-a-story "only a story changes the declared default" "Only a story changes the declared default"

# --- delivering-a-story: the story's blocks (spec sections "Story",
# "The user story document", "Delivering a story") ---
require delivering-a-story "a story knows its batch's stories"   "each knowing the stories of its batch already written"
require delivering-a-story "each story chooses its own blocks"  "chooses, as it is written, the blocks of the spec delta it transcribes"
require delivering-a-story "a block is never shared"            "a block is never shared between two stories"
require delivering-a-story "the header carries extra fields"     "extend the standard header with the fields below"
require delivering-a-story "the header template declares Blocks"  "**Blocks:** D3, D7"
# A section title is skeleton, so the example header names English sections.
require delivering-a-story "the header example names English sections" "**Sections:** Subscription > Renewal, Subscription > Proration"
require delivering-a-story "Blocks is what closing reads"         "reads to find the blocks nobody delivered"
require delivering-a-story "Blocks is none when none is taken"    "\`none\` for a story that transcribes none"
require delivering-a-story "three properties are load-bearing"    "Three properties are load-bearing"
require delivering-a-story "transcription is word for word"       "exactly as the opening review read it"
require delivering-a-story "a diff block yields its paragraph"    "is transcribed as the paragraph it produces"
require delivering-a-story "main moved under a block's paragraph" "the paragraph a block changes no longer reads in \`main\` as the block shows it"
require delivering-a-story "a divergence is named in the PR"      "Every divergence from a block is named in the body of the pull request"
require delivering-a-story "main moved: fit the block"            "When \`main\` moved under a block, fit the block to what \`main\` now carries"
require delivering-a-story "a problematic block goes to the human" "When the block's text is a problem, stop and put it to your human partner before transcribing it"
require delivering-a-story "a doubtful block stops the story"     "Do not transcribe a text you believe is wrong"
require delivering-a-story "no divergence amends the batch document" "Neither case amends the batch document"
require delivering-a-story "hands over to the next story" \
    "Give it this next step: the next story, conducted by \`supercharlouze:delivering-a-story\` from the batch document, with a prompt that says to choose from the blocks no merged story has declared."
require delivering-a-story "hands over to the closing after the last blocks" \
    "If this story took the batch's last undelivered blocks, give it \`supercharlouze:closing-a-batch\` instead, from the same document."
require delivering-a-story "allocation reads main on the remote" "git ls-tree --name-only origin/main docs/batches/"

# --- delivering-a-story: what the spec leaves to the skill (sections
# "The user story document", "Delivering a story", "Abandoning a story") ---
# The spec states the rules; these details are the method, and the skill is the
# only place that still carries them.
require delivering-a-story "the NN- prefix keeps basenames unique" "The \`NN-\` prefix keeps basenames unique across batches"
require delivering-a-story "Spec: is the binding authority"       "\`Spec:\` is the field \`subagent-driven-development\` already reads as the binding authority"
require delivering-a-story "never the batch's whole delta"        "and never the batch's whole delta"
require delivering-a-story "an open batch has its opening merged" "Its opening pull request is merged and its document says \`status: open\`"
require delivering-a-story "the plan goes into the first commit's document" "Step 4 then writes the plan into that document rather than creating it"
require delivering-a-story "the plan is pushed immediately"       "and push it immediately"
require delivering-a-story "the records are pushed"               "Commit both on the branch and push, so they merge with it"
require delivering-a-story "the merge delivers the story"         "The story is delivered when its pull request is merged"
require delivering-a-story "abandoning goes through abandoning-a-story" "**To abandon a story, invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch.**"

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
# Closing has no next step, and says so when it ends its review: a skill that
# dropped it would send an agent inventing a step the model does not have.
require closing-a-batch "ends its review with no condition and no next step" \
    "**To end the review, invoke \`supercharlouze:finishing-a-pr\` and give it no condition and no next step.**"
require closing-a-batch "what follows a closed batch is chosen elsewhere" \
    "What comes after a closed batch is chosen outside this model."
require closing-a-batch "a closing a ruling started hands on the step that follows it" \
    "Exception: when the prompt that started the closing states a ruling and names a step after the closing, give that step, with its skill and its document, and have its prompt state the ruling."

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
require making-a-bounded-change "a bounded change invokes writing-in-a-spec before writing in a spec" \
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

# --- finishing-a-pr: the end of a review ---
require finishing-a-pr "says what the invoking skill passes" \
    "The skill that invokes it gives the conditions the announcement waits on, or none, and the next step, or none."
require finishing-a-pr "says what a next step comes with" \
    "A next step comes with the skill that conducts it and the document it starts from, and with what else its prompt must say when there is anything."
require finishing-a-pr "points at the rules of the foundation" \
    "The rules this skill applies are those of \`The Git Model\` in \`supercharlouze:following-the-rules\`"
require finishing-a-pr "pushes a correction as a fixup" \
    "**Push each correction the review asks for as a \`fixup!\` commit of the commit it corrects.**"
require finishing-a-pr "a fresh decision is a commit of its own" \
    "A correction that carries a fresh decision is a commit of its own: a review that changes the wording of a spec change is deciding something, not fixing a slip."
require finishing-a-pr "waits for the agreement in the conversation" \
    "**Wait for your human partner's agreement, given in the conversation.**"
require finishing-a-pr "checks the conditions it was given" \
    "**Check each condition you were given.**"
require finishing-a-pr "a condition that does not hold sends back to the review" \
    "When one does not hold, say which one, squash nothing and go back to the review: it goes on until the condition holds and your human partner agrees again."
require finishing-a-pr "squashes the fixups and pushes" \
    "**Squash the \`fixup!\` commits into the commits they correct, and push the rewritten branch.**"
require finishing-a-pr "announces the pull request ready" \
    "**Announce that the pull request is ready to be approved and merged.**"
# Corrections, the agreement, the conditions, the squash, then the announcement.
skill_text finishing-a-pr
case "$SKILL_TEXT" in
    *"**Push each correction"*"**Wait for your human partner's agreement"*"**Check each condition you were given.**"*"**Squash the "*"**Announce that the pull request is ready"*"When your human partner announces the merge"*)
        pass "finishing-a-pr: corrections, agreement, conditions, squash, announcement, then the merge" ;;
    *)  fail "finishing-a-pr: corrections, agreement, conditions, squash, announcement, then the merge" ;;
esac
require finishing-a-pr "acts on the merge announcement" \
    "When your human partner announces the merge"
require finishing-a-pr "asks for a clear context" "**Ask them to clear the context.**"
require finishing-a-pr "gives the prompt of the next step" \
    "**If you were given a next step, name it and give, in a block to copy and paste, the prompt that starts it in a fresh context.**"
require finishing-a-pr "the prompt names the skill and the document" \
    "The prompt names the skill to invoke and the document to start from, by its path, says what else you were given for it, and never refers back to this conversation."
require finishing-a-pr "no next step, no prompt" "Without a next step, give no prompt."
require finishing-a-pr "red flag: amending instead of a fixup" \
    "| \"The correction is tiny, I'll amend the commit and force-push\" | A force-push mid-review replaces the commits your human partner has comments on. Push a \`fixup!\`. |"
require finishing-a-pr "red flag: a GitHub approval is not the agreement" \
    "| \"They approved on GitHub, that is their agreement\" | The agreement is given in the conversation. Ask for it there before you squash. |"
require finishing-a-pr "red flag: a condition settled after the merge" \
    "| \"They agreed, the condition can be settled after the merge\" | After the merge the branch is gone and nothing settles it. Go back to the review. |"
require finishing-a-pr "red flag: merging oneself" \
    "| \"They agreed, I can merge it myself\" | Approving and merging are your human partner's acts. Announce the pull request ready and wait. |"
require finishing-a-pr "red flag: the prompt given at the ready announcement" \
    "| \"The pull request is ready, I'll give the next prompt now\" | The review may go on and bury it, or change the document it names. Give it when the merge is announced. |"
require finishing-a-pr "says when to go back to the step that invoked it" \
    "Once you have answered the merge announcement, go on with the step that invoked this skill."
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them.
absent "finishing-a-pr names no skill that invokes it" "${entry_names%|}|Step [0-9]" finishing-a-pr

# --- writing-a-batch-document: the form of a batch document ---
require writing-a-batch-document "says what the invoking skill gives" \
    "The skill that invokes it gives the batch's \`NN\` and its slug for a document to write, or the batch document and what changes in it for a document to amend."
require writing-a-batch-document "a new document is written whole" \
    "Write a new document whole, from the template below."
require writing-a-batch-document "an amended document keeps no history" \
    "Amend a document in place, in the fields the change touches, and keep in it no history of what it said before."
require writing-a-batch-document "says when to go back to the step that invoked it" \
    "Once the document is written, go on with the step that invoked this skill."
require writing-a-batch-document "the document lives in the batch directory" \
    "Write \`docs/batches/NN-<slug>/README.md\`"
require writing-a-batch-document "the flag decision follows the model of the foundation" \
    "Decide it by \`The Model\` in \`supercharlouze:following-the-rules\`"
require writing-a-batch-document "the field has three shapes" \
    "Three shapes of the field, and there are no others"
require writing-a-batch-document "a cross-module batch writes one line per guarded module" \
    "one line per guarded module"
require writing-a-batch-document "the gating sentence is left to the story" \
    "do not write it into the spec yourself"
require writing-a-batch-document "a block is written under the rules of a spec" \
    "**Invoke \`supercharlouze:writing-in-a-spec\` before writing a block.**"
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them.
absent "writing-a-batch-document names no skill that invokes it" "${entry_names%|}|Step [0-9]" writing-a-batch-document

# --- rereading-a-batch: the rereads of a batch ---
require rereading-a-batch "says what the invoking skill passes" \
    "The skill that invokes it gives: - the batch document; - the blocks to apply; - the rereads due; - the path of each ADR the pull request writes or rewrites."
require rereading-a-batch "the rereads run in order" \
    "Run the rereads due, in this order: the coherence reread, the technical reread, the batch-document reread."
require rereading-a-batch "each reread has its own object" "**Each reread has its own object.**"
require rereading-a-batch "the coherence reread's object is stated" \
    "The coherence reread bears on the blocks and on the state they produce, read whole."
require rereading-a-batch "the technical reread's object is stated" \
    "The technical reread bears on the technical design and the constraints, on the blocks read against the ADRs, and on the ADRs the pull request writes or rewrites."
require rereading-a-batch "the document reread names every field" \
    "The batch-document reread bears on the whole document: \`Scope\`, \`Spec delta\`, \`Technical design\`, \`Constraints\`, \`Feature flag\`."
# Merged into another reread, the batch-document reread disappears wherever
# that one does not run.
require rereading-a-batch "merging them strands a batch without blocks" \
    "leaving a batch that has no blocks without a reread of its document"
require rereading-a-batch "says when to go back to the step that invoked it" \
    "Once the last reread has returned, return what \`What It Returns\` lists, and go on with the step that invoked this skill."
# The applied copies come from `applying-a-spec-delta`, before the first reread
# and again once a reread has touched a block.
require rereading-a-batch "the blocks are applied before the first reread" \
    "Before the first reread, invoke \`supercharlouze:applying-a-spec-delta\` and give it the batch document and the blocks you were given."
require rereading-a-batch "no block, nothing to apply" \
    "Given no block, skip the invocation: each spec is read as it stands."
require rereading-a-batch "the blocks are applied again once a reread touched one" \
    "**Invoke it again each time a reread has changed or added a block**, and give it the blocks as they now read."
require rereading-a-batch "a block that does not apply holds the rereads" \
    "**A block it returns as not applied is a delta gone stale.** Start no reread while one is left: put the block to your human partner."
# The coherence reread.
require rereading-a-batch "the coherence reread reads the applied state" \
    "The coherence reread reads each touched spec whole, on the state its blocks produce."
require rereading-a-batch "no block skips the coherence reread" "**Given no block, skip it.**"
require rereading-a-batch "the skip is not a dispensation" "so with no block it has nothing to read"
require rereading-a-batch "a blockless batch still owes the rereads that follow" \
    "Such a batch still owes the rereads that follow."
require rereading-a-batch "each applied copy goes to the shared reread" \
    "invoke \`supercharlouze:rereading-a-spec\` on each applied copy, with the path of the spec it applies to"
require rereading-a-batch "revisions go back into the blocks" \
    "Carry every revision it returns back into the blocks: into the block whose text it changes, or into a new block when it changes a passage no block targets."
require rereading-a-batch "revised blocks are applied again" \
    "Then have the blocks applied again (\`The Applied Copies\`)."
require rereading-a-batch "a boundary rule stops the rereads" \
    "A rule it returns as reaching past its module's boundary stops the rereads: put the breakdown to your human partner."
# The technical reread.
require rereading-a-batch "the technical reread waits for the coherence reread" \
    "**Start it only once the coherence reread has closed its rounds.** Run side by side, each reread revises what the other is reading"
require rereading-a-batch "the reread is handed the batch document and its specs" \
    "Invoke \`supercharlouze:rereading-a-technical-design\` with the batch document and each spec the batch touches"
require rereading-a-batch "a spec no block targets goes as it is" \
    "its applied copy, or the spec itself when no block targets it"
require rereading-a-batch "the invocation hands the specs, the ADRs and their paths" \
    "Hand it also \`docs/specs/\`, \`docs/adr/\` and the path of each ADR the pull request writes or rewrites."
require rereading-a-batch "a corrected ADR is handed to the reread" \
    "An ADR whose text you corrected on a finding counts among those it rewrites."
require rereading-a-batch "revisions go back into the design" \
    "Carry every revision it returns back into \`Technical design\` and \`Constraints\`"
require rereading-a-batch "the technical reread changes no spec delta" \
    "The technical reread itself never changes \`Spec delta\`: only your human partner takes a behaviour or a block back to it."
require rereading-a-batch "what is taken back sends the batch back to the coherence reread" \
    "**A behaviour or a block it returns as taken back to the spec delta sends the batch back to the coherence reread.**"
require rereading-a-batch "the block taken back is the one the human rules" \
    "Write the block your human partner rules, or correct the block as they correct it, and have the blocks applied again (\`The Applied Copies\`)."
require rereading-a-batch "what is taken back makes the other rereads due" \
    "The coherence reread and the batch-document reread are due from then on, whatever you were given: run the coherence reread, then the technical reread again."
require rereading-a-batch "the technical reread changes no ADR" "The technical reread changes no ADR either."
require rereading-a-batch "an ADR corrected on a finding goes back through the reread" \
    "When your human partner has an ADR corrected on a finding it returns, invoke \`supercharlouze:recording-a-decision\` and hand it the applied copies if the correction changes the ADR's decision, and correct the text yourself if it does not. When they abandon the ADR, delete it. After a correction or a deletion, invoke the technical reread again."
# The batch-document reread.
require rereading-a-batch "the document reread comes last" \
    "The batch-document reread comes after the technical reread and bears on the whole document."
require rereading-a-batch "the document reread is conducted outside this context" \
    "Conduct it outside the context that wrote the document, by dispatching a subagent"
require rereading-a-batch "the dispatch is composed from the reader prompt" \
    "Compose the dispatch from \`skills/rereading-a-batch/references/document-reader-prompt.md\`"
require rereading-a-batch "the document is revised on the report" "Revise the document on what it reports."
require rereading-a-batch "says what it returns" \
    "Return: - the batch document, revised; - what each reread you ran found, or that it found nothing, written for a pull request body, and for a technical reread that returned that it had nothing to reread, that instead; - each behaviour and each block your human partner took back to the spec delta."
require rereading-a-batch "red flag: rereading one's own blocks" \
    "| \"I wrote these blocks, I can reread them myself\" |"
require rereading-a-batch "red flag: both rereads together" \
    "| \"The rereads read different things, I'll run them together\" | Each revises what the other is reading."
require rereading-a-batch "red flag: rereading one's own design" \
    "| \"I wrote this design, I can reread it myself\" | The context that argued it into existence rereads its intentions, not its text. Invoke \`supercharlouze:rereading-a-technical-design\`. |"
require rereading-a-batch "red flag: a corrected ADR is reread" \
    "| \"I only corrected the ADR's wording, no need to reread again\" | The corrected text is one no reader has read. Invoke the technical reread again. |"
require rereading-a-batch "red flag: copies left as they were" \
    "| \"The reread only reworded a block, the copies I have are close enough\" |"
require rereading-a-batch "red flag: starting with a block unapplied" \
    "| \"One block does not apply, the rereads can start on the others\" |"
require rereading-a-batch "red flag: a block taken back skips the coherence reread" \
    "| \"Only the technical reread was due, the block taken back can skip the coherence reread\" |"
require rereading-a-batch "red flag: checking the document oneself" \
    "| \"I know what each field must hold, I'll check the document myself\" |"
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them.
absent "rereading-a-batch names no skill that invokes it" "${entry_names%|}|Step [0-9]" rereading-a-batch

# --- rereading-a-batch: the prompt of the batch-document reader ---
# A subagent reads this prompt and nothing else: it loads no skill of the
# plugin, so the prompt stands on its own and names none.
DOC_PROMPT="$SKILLS_DIR/rereading-a-batch/references/document-reader-prompt.md"
DOC_FLAT=""
if [ -f "$DOC_PROMPT" ]; then
    pass "the document reader prompt exists"
    DOC_FLAT="$(body_flat "$DOC_PROMPT")"
else
    fail "the document reader prompt exists"
fi
doc_has() {
    case "$DOC_FLAT" in
        *"$2"*) pass "document reader prompt: $1" ;;
        *)      fail "document reader prompt: $1" ;;
    esac
}
doc_has "one reader, one document"           "One reader, one batch document"
doc_has "the slots are those of the labelled lines" "Fill the \`<…>\` slot of each line that opens on a bold label before dispatching"
doc_has "the text below the rule is the dispatch" "Send the text below the rule as the whole dispatch"
doc_has "an unfilled slot reads nothing"     "a slot left as written is a reader with nothing to read"
doc_has "the reader did not write it"        "You did not write it, and you are not being asked to improve it"
doc_has "the batch document is handed over"  "**The batch document:**"
doc_has "the specifications are handed over" "**The specifications:**"
doc_has "a gaps register is no specification" "A gaps register is not a specification"
doc_has "Scope states what the batch delivers" "**\`Scope\`** states what the batch delivers"
doc_has "every entry taken on is named and reserved" \
    "It names every gaps register entry the batch takes on, and each of those entries is reserved for this batch in its gaps register"
doc_has "the delta is filled" \
    "**\`Spec delta\`** is filled: it carries blocks, or \`none\` followed by the reason"
doc_has "the design is filled" \
    "**\`Technical design\`** is filled: it carries the design the stories are planned from, or \`none\` followed by the reason"
doc_has "Constraints are bounded" \
    "**\`Constraints\`** carries only migration and compatibility constraints, the technical decisions the rest of the technical design relies on, and the required order of the stories and of the blocks, or reads \`none\`"
doc_has "the flag field is filled"           "**\`Feature flag\`** is filled"
doc_has "a lifting is a block"               "\`Spec delta\` carries a block that removes that sentence"
doc_has "a finding names its field"          "the field it bears on, the passage quoted, and what is wrong with it"
doc_has "an empty result is reported"        "Return \"nothing found\" when you found nothing"
doc_has "the reader loads no skill"          "Load no skill: everything you need is in this prompt"
doc_has "the reader revises nothing"         "Do not revise the document, and modify no file"
doc_has "the reader dispatches nothing"      "Do not dispatch subagents"
doc_has "the reader runs nothing"            "Run nothing: you read files and search them"
doc_has "the block lines are not the reader's to check" "is not yours to check: that check is made elsewhere"
DOC_NAMED=""
for s in $(declared_skills); do
    case "$DOC_FLAT" in
        *"$s"*) DOC_NAMED="$DOC_NAMED $s" ;;
    esac
done
case "$DOC_FLAT" in
    *"supercharlouze:"*|*"superpowers:"*) DOC_NAMED="$DOC_NAMED a-prefixed-skill" ;;
esac
if [ -z "$DOC_NAMED" ]; then
    pass "the document reader prompt names no skill"
else
    fail "the document reader prompt names no skill (named:$DOC_NAMED)"
fi

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
require delivering-a-story "the justification covers the ADR" \
    "and an ADR is a decision your human partner took, so only they judge it untenable."

# --- following-the-rules: the shape of a review's end ---
require following-the-rules "the amendment gate covers the design and the constraints" "the decision to change its scope, its spec delta, its technical design, its constraints or its flag"
require using-batches "routing names the design and the constraints" "A batch must change its scope, its spec delta, its technical design, its constraints or its flag"
require following-the-rules "forbids the agent approving or merging" "never approves and never merges a pull request"
require following-the-rules "pushes corrections as fixups"           "pushed as a \`fixup!\` commit"
require following-the-rules "the agreement is given in conversation" "The human gives their agreement in the conversation"
require following-the-rules "names the merge a clear moment"      "a moment to clear the context"
require following-the-rules "the rule covers every gate"          "Merging any review is a moment to clear the context"
require following-the-rules "the handover is conditional"         "Where a next step exists"
require following-the-rules "an abandonment after a stop is a clear moment too" "**Abandoning a story after a stop condition is a moment to clear the context too, when the ruling asks for a next step.**"
require following-the-rules "the prompt given after an abandonment states the ruling" "The agent asks its human partner to clear the context, names that step and gives its prompt the same way, and that prompt states the ruling: the story's branch is gone, and no document carries what was ruled yet."
require following-the-rules "each handover prompt stands alone"   "**Each of these prompts stands on its own:** it names the skill to invoke and the document to start from, and never refers back to the conversation."
require using-batches "an unadopted module stops the design"     "the design stops"
require using-batches "Override 1 stays bounded to steps 6 to 9" "still covers steps 6 to 9 and nothing else"
require making-a-bounded-change "a bounded change adds and removes entries"  "add an entry and delete one"
require following-the-rules "the prompt waits for the merge"      "After a review, the prompt waits for the merge announcement, not for the announcement that the pull request is ready"

# --- following-the-rules: guarded code rules (referencing delivering-a-story) ---
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
for s in using-batches opening-a-batch writing-a-batch-document; do
    case "$(body_flat "$REPO_ROOT/skills/$s/SKILL.md")" in
        *"Refactor and infrastructure"*) fail "$s: the old exemption family is gone" ;;
        *)                               pass "$s: the old exemption family is gone" ;;
    esac
done

# --- making-a-bounded-change: the bounded change (spec `Bounded change`) ---
require making-a-bounded-change "a bounded change may leave the spec silent" \
        "if and only if nothing observable at the module's boundary changes"
require making-a-bounded-change "a silent bounded change leaves the spec untouched" \
        "the spec stays silent. That silence is not a tolerance"
require making-a-bounded-change "a bounded change names the spec it targets" \
        "the spec it targets and the sections it touches"
require making-a-bounded-change "a bounded change touching no section declares none" \
        "when it touches none"
require making-a-bounded-change "a changed declaration redoes the detection" \
        "redoes the detection"
require making-a-bounded-change "a bounded change has no batch and no user story" \
        "A bounded change has no batch and no user story: it is already a single pull request, and whether it carries a spec update is what rule (a) decides."
require making-a-bounded-change "the ceremony of bounded work is kept, with the reading of docs/adr" \
        "Its ceremony is the one \`superpowers:brainstorming\` gives bounded work, to which \`supercharlouze:using-batches\` adds the reading of \`docs/adr/\` by the design."
require making-a-bounded-change "the rules are what the pull request holds besides" \
        "\`The Rules\` are what its pull request holds besides."
require making-a-bounded-change "a bounded change carries no flag" \
        "**(c) It carries no feature flag.**"
require making-a-bounded-change "red flag: a small fix that leaves the spec silent" \
        "| \"This is a small fix, the spec can stay silent about it\" | Only if nothing observable at the module's boundary changes."
require making-a-bounded-change "a bounded change carries the correction of a spec the human judges wrong" \
        "**Exception: when your human partner judges that a spec is wrong and the code is right, it carries the spec correction they decide, and touches no code.**"
require making-a-bounded-change "the judgment and the correction are the human's" \
        "Both the judgment and the correction are your human partner's: a correction you derive from the code alone canonises the drift it describes."
require making-a-bounded-change "a correction removes the gaps register entry it settles" \
        "When the correction settles a gaps register entry, remove that entry under rule (d)."
require making-a-bounded-change "the invocation of writing-in-a-spec follows the exception" \
        "remove that entry under rule (d). When it updates a spec, invoke \`supercharlouze:writing-in-a-spec\` before writing in it."
require making-a-bounded-change "none is the declaration of a change that writes in no spec" \
        "it is what a bounded change that writes in no spec has to say"
require making-a-bounded-change "red flag: the agent does not judge a spec wrong" \
        "| \"The code is right and the spec is plainly wrong, I'll correct the spec\" | Only your human partner judges a spec wrong, and they decide the correction. Put it to them, and write nothing in the spec until they have decided. |"
require making-a-bounded-change "red flag: a spec correction touches no code" \
        "| \"While I correct the spec, I'll tidy the code it describes\" | A spec correction touches no code: the code is what your human partner judged right. A code change is another bounded change. |"
case "$(skill_front making-a-bounded-change)" in
    *"a spec your human partner judges wrong where the code is right"*)
        pass "making-a-bounded-change: the description names the spec judged wrong" ;;
    *)  fail "making-a-bounded-change: the description names the spec judged wrong" ;;
esac

require delivering-a-story "the story skill sends its transcription to the forms of the gating sentence" \
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
        "| Your human partner wants an ADR written, rewritten or deleted outside the adoption of a module, the opening of a batch, its amendment, the delivery review of a story and the installation | \`supercharlouze:making-a-bounded-change\` |"
require writing-in-a-spec "a decision with nothing observable has the ADR for outlet" \
        "Exception: a sentence that states a technical decision has an ADR for outlet, under the conditions \`supercharlouze:following-the-rules\` states."
require writing-in-a-spec "a decision housed outside the specs goes to an ADR" \
        "A technical decision that no module boundary makes observable is not a rule: its outlet is an ADR."
require writing-in-a-spec "the scope paragraph names both outlets" \
        "that is where what the test ejects goes, except a technical decision, which has an ADR for outlet"
require writing-in-a-spec "the red flag names the ADR as the outlet" \
        "A technical decision with nothing observable at a module's boundary is no rule at all: its outlet is an ADR. |"
require making-a-bounded-change "a bounded change writes, rewrites and deletes ADRs" \
        "**(e) It may write, rewrite and delete ADRs, and may carry nothing but ADRs.**"
require making-a-bounded-change "a bounded change invokes recording-a-decision" \
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
        "On the architectural path, \`supercharlouze:opening-a-batch\` writes, rewrites or deletes at the opening the ADRs they decide."
require using-batches "the bounded ceremony has an exception" \
        "**Bounded** — ceremony unchanged, except for the reading of \`docs/adr/\` stated below. \`supercharlouze:making-a-bounded-change\` carries the rules its pull request holds."
require using-batches "the design steps have the same exception" \
        "are **kept intact**, except for the reading of \`docs/adr/\` stated below"
require using-batches "the design reads docs/adr before proposing an approach" \
        "On the bounded path and on the architectural path, read every ADR in \`docs/adr/\` before proposing an approach"
require using-batches "the design puts to the human the decision that meets the conditions" \
        "put to your human partner each technical decision the design takes that meets the conditions of an ADR \`supercharlouze:following-the-rules\` states"
require making-a-bounded-change "a bounded change holds the ADRs" \
        "**(f) It holds the ADRs \`main\` carries when its branch starts.**"
require making-a-bounded-change "a bounded change rereads docs/adr once its branch exists" \
        "Once \`bounded/<slug>\` is created, reread \`docs/adr/\` and hold what you find there"
require making-a-bounded-change "a bounded change puts to the human the ADR it cannot hold" \
        "When you cannot hold an ADR, put it to your human partner: if they rule it untenable, rewrite or delete it under rule (e); otherwise hold it."
require making-a-bounded-change "a bounded change puts to the human the decision that meets the conditions" \
        "**(g) It puts to your human partner the technical decision it takes that meets the conditions of an ADR \`supercharlouze:following-the-rules\` states.**"
require making-a-bounded-change "a bounded change writes the ADR the human wants" \
        "If they want it as an ADR, write it under rule (e)."
require following-the-rules "red flag: a decision is put to the human" \
        "| \"This decision is technical, no need to bring it to my human partner\" | If it meets the conditions of an ADR, put it to them: only they decide an ADR. |"
require using-batches "an approach that breaks an ADR is not taken" \
        "An approach that breaks an ADR is one the code may not take, and only your human partner decides an ADR."
require making-a-bounded-change "a bounded change's decision along the way is put to the human too" \
        "That holds for a decision taken along the way as for one taken at design."
require making-a-bounded-change "the design read may be stale" \
        "the design read it where you stood, and the branch starts from \`main\` as the remote carries it"

# --- following-the-rules: the glossary terms of the review (spec section "The model") ---
require following-the-rules "defines the pull request" \
        "**Pull request** — a change proposed for \`main\`, which the human reviews before it reaches \`main\`."
require following-the-rules "defines the gate" \
        "**Gate** — the human's review of a pull request, whose merge moves a module, a batch or a story forward."
require following-the-rules "defines the reread" \
        "**Reread** — an agent's check of a piece of work. A reread is not a gate."

require delivering-a-story "the cases of Blocks: none are examples" \
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
