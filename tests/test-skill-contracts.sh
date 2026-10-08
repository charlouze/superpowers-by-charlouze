#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib.sh"

echo "test-skill-contracts"

# The specs are the registry of flags: a batch that lifts a flag declared by
# another says so in its spec delta, and nothing copies flags into the batch
# document. The former `Live flags` section and its rulings must survive nowhere,
# or a skill keeps asking for a section no batch document carries any more.
absent_everywhere "no skill keeps a Live flags section or its rulings" \
    "Live flags|carried by this batch|inherited by a ruling"


# A branch is started in one place, `starting-a-branch`. A skill that creates a
# branch invokes it and passes the name of the branch.
for s in adopting-a-module opening-a-batch amending-a-batch delivering-a-story closing-a-batch making-a-bounded-change; do
    require "$s" "invokes starting-a-branch with the name of the branch" \
        "nvoke \`supercharlouze:starting-a-branch\` and give it the name"
done
require adopting-a-module "an adoption passes adopt/<module>" \
    "Invoke \`supercharlouze:starting-a-branch\` and give it the name \`adopt/<module>\`"
require opening-a-batch "an opening passes batch/NN-<slug>" \
    "Invoke \`supercharlouze:starting-a-branch\` and give it the name \`batch/NN-<slug>\`."
require amending-a-batch "an amendment passes the name it chose" \
    "Invoke \`supercharlouze:starting-a-branch\` and give it the name you chose."
require closing-a-batch "a closing passes batch/NN-<slug>-close" \
    "**Invoke \`supercharlouze:starting-a-branch\` and give it the name \`batch/NN-<slug>-close\`.**"
require delivering-a-story "a story passes story/NN-us-N-<slug>" \
    "Invoke \`supercharlouze:starting-a-branch\` and give it the name \`story/NN-us-N-<slug>\`."
require making-a-bounded-change "a bounded change passes bounded/<slug>" \
    "invoke \`supercharlouze:starting-a-branch\` and give it the name \`bounded/<slug>\`"
# Allocation reads `origin/main` before the branch exists, so it fetches itself.
# The opening keeps its allocation in a reference, read at that step.
case "$(body_flat "$REPO_ROOT/skills/opening-a-batch/references/allocating-nn.md" 2>/dev/null || true)" in
    *"git fetch origin git ls-tree --name-only origin/main docs/batches/"*)
        pass "opening-a-batch: allocation fetches before it reads the remote" ;;
    *)  fail "opening-a-batch: allocation fetches before it reads the remote" ;;
esac
case "$(body_flat "$REPO_ROOT/skills/opening-a-batch/SKILL.md")" in
    *"git ls-tree"*|*"smallest integer"*)
        fail "opening-a-batch: the allocation is written in its reference alone" ;;
    *)  pass "opening-a-batch: the allocation is written in its reference alone" ;;
esac
require opening-a-batch "the opening allocates NN from its reference" \
    "Allocate \`NN\` as \`skills/opening-a-batch/references/allocating-nn.md\` says"
# A story keeps its allocation in a reference too, read at that step.
case "$(body_flat "$REPO_ROOT/skills/delivering-a-story/references/allocating-us-n.md" 2>/dev/null || true)" in
    *"git fetch origin git ls-tree --name-only origin/main docs/batches/NN-<slug>/"*)
        pass "delivering-a-story: allocation fetches before it reads the remote" ;;
    *)  fail "delivering-a-story: allocation fetches before it reads the remote" ;;
esac
case "$(body_flat "$REPO_ROOT/skills/delivering-a-story/SKILL.md")" in
    *"git ls-tree"*|*"smallest integer"*)
        fail "delivering-a-story: the allocation is written in its reference alone" ;;
    *)  pass "delivering-a-story: the allocation is written in its reference alone" ;;
esac
require delivering-a-story "the story allocates us-N from its reference" \
    "Allocate \`us-N\` as \`skills/delivering-a-story/references/allocating-us-n.md\` says"
# How a branch is started is spelled there and nowhere else. Walks the declared
# skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the start of a branch" \
    "named branch is not enough|restore the conventional name|detached HEAD|harness's native tooling|wherever you happened to be|GIT_DIR != GIT_COMMON|already in a linked worktree|merge-base --is-ancestor|[Ii]nvoking .superpowers:using-git-worktrees|then branch from .origin/main.|using-git-worktrees (opens|reuses)|branch from .origin/main.: otherwise|create the branch from .origin/main. yourself|Branch from .origin/main., wherever you stand" \
    $(declared_skills | grep -vx starting-a-branch)

# The concurrency scan lives in one place, `detecting-concurrency`. A skill
# whose work claims sections invokes it, passes what varies and stops on what it
# returns: `delivering-a-story` for a story, `making-a-bounded-change` for the
# bounded change.
require delivering-a-story "a story invokes detecting-concurrency with its spec and its sections" \
    "invoke \`supercharlouze:detecting-concurrency\` and give it the story's spec and those sections"
require making-a-bounded-change "a bounded change invokes detecting-concurrency before creating its branch" \
    "Invoke \`supercharlouze:detecting-concurrency\` before creating \`bounded/<slug>\`, and give it that spec and those sections"
require making-a-bounded-change "a redone detection receives the section and the branch" \
    "invoke it again, and give it that section and \`bounded/<slug>\` as well"
for s in delivering-a-story making-a-bounded-change; do
    require "$s" "stops on what detecting-concurrency returns" \
        "Stop if it returns a conflict or a declaration it could not read"
done
# A story about to touch a section the detection was not run for detects again,
# and passes its branch, which the scan leaves out. The rule is written in
# `Step 1`; the steps where one more section turns up point at it.
require delivering-a-story "a story detects again before it touches one more section" \
    "**Detect again before the story touches a section the detection was not run for**, as long as its pull request is not open: invoke \`supercharlouze:detecting-concurrency\` again, and give it the story's spec, that section and the story's branch."
require delivering-a-story "a section detected again joins the declaration before it is touched" \
    "add the section to it, then commit and push before touching it"
require delivering-a-story "the transcription waits for the detection of one more section" \
    "**A block or a removal that reaches a section the detection was not run for is not written yet:** detect again first (Step 1)."
require delivering-a-story "the plan's sections go through the detection before the story document is committed" \
    "One the detection was not run for goes through it before the story document is committed (Step 1)."
require delivering-a-story "a section a task reveals is detected before anything else is dispatched" \
    "shows the story reaching a section \`Sections:\` does not name, detect again before dispatching anything else"
# Both pieces of work stop a redone detection in the same words, and answer the
# same excuse.
for s in delivering-a-story making-a-bounded-change; do
    require "$s" "stops on what a redone detection returns" \
        "Stop again if it returns a conflict or a declaration it could not read"
done
shared "red flag: the first detection does not cover one more section" \
    "| \"It's one more section of the same spec, the detection already ran\" | It ran for the sections it was given, and never looked at this one. Detect again before touching it, and stop if it is held or a declaration cannot be read. |" \
    delivering-a-story making-a-bounded-change
# The detection is redone for a section the work is about to touch, not for a
# declaration that changed: a bounded change has no declaration before its pull
# request opens.
absent_everywhere "no skill redoes the detection on a changed declaration" \
    "declaration that changes before the pull request opens|still cheap to undo"
# What it carries is spelled there and nowhere else. Walks the declared skills,
# so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the concurrency scan" \
    "filter is the branch name|carries no declaration yet|or .bounded/[*]. branch that carries no pull request yet|unread declaration is an unknown|Sections are declared, not derived|conflicts on lines, not|names both in the body of its pull request|Step 1 of .supercharlouze" \
    $(declared_skills | grep -vx detecting-concurrency)
# `following-the-rules` keeps what a conflict is and what a claimant declares.
require following-the-rules "a conflict is judged on a section of one spec" \
    "touching the same section of the same spec are a conflict"
require following-the-rules "each claimant declares its spec and its sections" \
    "Each claimant declares its spec and its sections"

# The former filter — keep only the pull requests and the branches whose diff
# touches the spec file — made invisible every story whose pull request touches
# no spec at all. It must survive nowhere, or the scan regains the blind spot
# this one closes.
absent_everywhere "no skill filters the concurrency scan by the spec file a diff touches" \
    "touches this story's spec file|touches this spec file|touch this spec file|files include this story's spec file"

# A branch that has not declared yet used to stop a story as soon as it had
# changed the story's spec file. The sections it changed now stand in for its
# declaration, so that stop must survive nowhere.
absent_everywhere "a branch with no declaration yet is not an unknown" \
    "concerns the spec it has already changed|it is an unknown and stops you|stop on an unknown"

# What a spec contains lives in one place, `writing-in-a-spec`. A skill that
# writes a text a spec receives invokes it and restates nothing: a second
# formulation of the same rule is what drifts. `adopting-a-module` writes a
# spec's first version, `writing-a-batch-document` the blocks a spec will receive,
# `delivering-a-story` their transcription, and `making-a-bounded-change` the
# spec update of a bounded change. `closing-a-batch` writes into no spec file.
require writing-in-a-spec "states the question of the other-implementation test" \
    "read this sentence as true of their code"
for s in making-a-bounded-change adopting-a-module writing-a-batch-document delivering-a-story; do
    require "$s" "invokes writing-in-a-spec before writing a text a spec receives" \
        "nvoke \`supercharlouze:writing-in-a-spec\` before"
done
# The question is spelled in the skill that carries it and nowhere else. Walks
# the declared skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill spells the question of the other-implementation test" \
    "read this sentence as true of their code" \
    $(declared_skills | grep -vx writing-in-a-spec)

# The test has one name. The reading a spec reader receives is written in full
# in `rereading-a-spec`, since a reader loads no skill, and it names the test as
# the skill that carries it does.
shared "the other-implementation test bears one name" \
    "other-implementation test" \
    writing-in-a-spec rereading-a-spec adopting-a-module

# The shape of a gaps register, the rules of an entry and the gestures live in
# one place, `writing-in-a-gaps-register`. A skill that writes in a register
# invokes it and restates nothing: `adopting-a-module` creates the file and
# removes the entry of a gap it promotes, `closing-a-batch` adds and releases,
# `making-a-bounded-change` carries the bounded change, `opening-a-batch` reserves, `amending-a-batch`
# reserves and releases, `delivering-a-story` removes the entry its story resolves.
for s in adopting-a-module closing-a-batch making-a-bounded-change opening-a-batch amending-a-batch delivering-a-story; do
    require "$s" "invokes writing-in-a-gaps-register before writing in a gaps register" \
        "nvoke \`supercharlouze:writing-in-a-gaps-register\` before"
done
# What it carries is spelled there and nowhere else. Walks the declared skills,
# so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the rules of a gaps register entry or its gestures" \
    "What qualifies an entry lives in the entry|An entry designates no other entry|is one list item|Read the file's history before adding an entry|re-entered only if the entry says what has changed|the commit that removes it says why|removes the reservation annotation|declares its own coverage|— Gaps register|Within a batch, only the closing pull request adds entries to the gaps register" \
    $(declared_skills | grep -vx writing-in-a-gaps-register)

# Each caller passes what varies: the batch number of a reservation and of its
# release, the reason of a removal, the coverage an audit gives.
require opening-a-batch "the opening invokes the reservation with its number" \
    "invoke \`supercharlouze:writing-in-a-gaps-register\` before reserving one, and give it this batch's \`NN\`"
require amending-a-batch "an amendment invokes the reservation with its number" \
    "reserves it in the same pull request: invoke \`supercharlouze:writing-in-a-gaps-register\` before reserving it, and give it this batch's \`NN\`"
require amending-a-batch "an amendment invokes the release with its number" \
    "releases its reservation in the same pull request: invoke \`supercharlouze:writing-in-a-gaps-register\` before releasing it, and give it this batch's \`NN\`"
require adopting-a-module "the adoption writes the coverage from its audit" \
    "Write the register's \`Coverage\` from this audit"
require adopting-a-module "a promotion gives the removal its reason" \
    "that is the reason the commit that removes it gives"
require delivering-a-story "a story adds no entry itself" \
    "Do not add those observations to the gaps register yourself"
require closing-a-batch "the consolidation is written into each entry" \
    "write \"consolidated by batch NN\" into each entry that needs it, never above them"
require closing-a-batch "the release invokes the gesture" \
    "release it. Invoke \`supercharlouze:writing-in-a-gaps-register\` before releasing one."
require closing-a-batch "an undelivered block joins the register through the gesture" \
    "invoke \`supercharlouze:writing-in-a-gaps-register\` and add it under **Gaps**"

# A story's Global Constraints names the execution rules and copies none: the
# foundation is the one place each is written, and whoever executes or reviews a
# task reads it there. The template of Global Constraints lets a plan cite every
# name the foundation gives, and no other: a name the foundation does not give
# sends its reader to a rule that is written nowhere, and a name the template
# leaves out is a rule no plan can ask for.
foundation_rule_names() {
    awk '/^## Execution Rules$/ { f = 1; next }
         f && /^#/ { exit }
         f && /^\| `/ { split($0, cell, "`"); print cell[2] }' \
        "$SKILLS_DIR/following-the-rules/SKILL.md" | sort
}
template_rule_names() {
    { grep -m1 '^\*\*Execution rules:\*\*' \
        "$SKILLS_DIR/delivering-a-story/references/global-constraints.md" 2>/dev/null || true; } \
        | { grep -oE '`[^`]+`' || true; } | tr -d '`' | sort
}
FOUNDATION_RULES="$(foundation_rule_names)"
TEMPLATE_RULES="$(template_rule_names)"
if [ -n "$FOUNDATION_RULES" ] && [ "$FOUNDATION_RULES" = "$TEMPLATE_RULES" ]; then
    pass "the Global Constraints template cites every execution rule the foundation names, and no other"
else
    fail "the Global Constraints template cites every execution rule the foundation names, and no other"
fi

# The stop conditions the flow adds are written in the foundation, each with the
# sentence that bounds it.
require following-the-rules "states the corrective stop condition" \
    "you discover that it is the **spec** that is wrong and the code that is right, stop. The batch is no longer corrective and must be requalified."
require following-the-rules "states the technical stop condition" \
    "If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical."
require following-the-rules "states the stop condition on a constraint or an ADR" \
    "If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner. A constraint the spec contradicts does not fall under this condition: the spec wins."

# The condition no longer bears on a constraint alone, nor fires only in a batch
# that declares constraints: the former wording must survive nowhere, or a story
# with an ADR and no constraint would carry no stop condition.
absent "the stop condition is no longer bounded to a constraint" \
    "a constraint of its batch cannot be held|constraint condition|whose batch declares constraints only" \
    using-batches following-the-rules delivering-a-story

# An unrecorded departure is answered by the delivery review, not by what
# closing does with the design: the former red flag must survive nowhere.
absent "an unrecorded departure no longer leaves the design false" \
    "describing a mechanism nobody built" \
    delivering-a-story

# The concision rules are written in the foundation, where whoever executes or
# reviews a task reads them.
for rule in \
    "Every sentence says one exact thing, once, and stands on its own." \
    "Every paragraph carries one rule." \
    "A rule says how far it holds, and an exception presents itself as one." \
    "A text says what it delivers or decides, without telling how it got there or why." \
    "No sentence is set in relief"; do
    require following-the-rules "states the concision rule: $rule" "$rule"
done

# The mirror: an item of Global Constraints is named, never counted or numbered.
# An ordinal goes false in every paragraph the day an item is added or removed.
absent "no Global Constraints item is counted or numbered" \
    "(first|second|third|fourth|fifth|sixth|seventh|eighth) thing|[0-9]\. the (constraints|freeze|authority|concision)|[0-9]\. \*\*in a " \
    delivering-a-story

# The mirror: the story header does not count its fields.
absent "the story header does not count its fields" \
    "(two|three|four|five|six|seven) fields|five on a technical story" \
    delivering-a-story

# The three families that answer the exemption criterion by construction are
# listed in the foundation. The skill that writes the `Feature flag` field
# points at them, and no other skill spells them a second time.
require following-the-rules "the flag exemption names the technical batch" \
    "**A batch all of whose stories are technical** — none of them changes what is observable at its module's boundary, so every pull request is deployable as it stands. That is what the qualification means, not a tolerance granted to it."
require writing-a-batch-document "points at the exemption criterion and its families" \
    "Decide it by \`The Model\` in \`supercharlouze:following-the-rules\`: the exemption criterion and the families that answer it by construction"
# shellcheck disable=SC2046
absent "no other skill spells the exemption families" \
    "That is what the qualification means|Gating it would delay a conformance fix|nothing is ever half delivered" \
    $(declared_skills | grep -vx following-the-rules)

# `following-the-rules` fixes the forms of the gating sentence, and
# `delivering-a-story` points at it. Two spellings of the same sentence is how
# a live flag stops being found, so the forms are written out in one place only.
require following-the-rules "the gating sentence is spelled in its fixed form" \
    "🔒 \`billing.recurring\`, off by default"

# The forms of the gating sentence are neither counted nor designated by their
# rank: the one with a lifting condition is recognised by that condition.
absent "no skill counts or ranks the forms of the gating sentence" \
    "gating sentence of the first form|or of the second when|one of the two forms" \
    using-batches following-the-rules delivering-a-story

# A gap's *category* does not depend on where you stand; only its sources do. So
# the skills that gloss it to route say what a gap is and never where it comes
# from: naming a source there would teach `using-batches` a word — a validated
# document — that means nothing outside an adoption, and would have to be kept in
# step with every context that finds gaps some other way.
#
# Scoped to the gloss, not the file: a skill may name a validated document
# legitimately elsewhere, as one of the two places an intention may come from.
absent "no routing gloss names a source of gaps" \
    "Gaps\*?\*?[^.|]{0,160}validated document" \
    using-batches following-the-rules opening-a-batch

# `Branch naming` used to deny, in bold, that any mechanism of this system
# depends on a branch's name. Two sections of the same spec contradicted it, and
# the denial is gone. No skill may carry it either — but the guard has to catch
# the *denial*, not the words: "Number allocation depends on the branch name" is
# the true statement this branch exists to establish, and a literal match would
# turn red on it and invite the writer to delete it.
absent_everywhere "no skill denies that the branch name matters" \
    "(nothing|Nothing|no mechanism|No mechanism)[^.]{0,40}depends on the (branch )?name"

# The spec delta is exact text, in blocks (spec section "The batch document"). A
# skill that still calls what a batch announced an "intention" contradicts it.
# The regex hunts the delta's former phrasings, and any sentence pairing
# "delta" or "announced" with "intention": the content rule's own
# "business rules and intentions", and "the same intention" in the
# other-implementation test, are true sentences and must stay green.
absent_everywhere "no skill calls the spec delta an intention" \
    "stated as intention|as intention only|like any other intention|an intention like any other|intentions? (the (batch|delta) )?announced|announced intention|announced no intention|an intention not delivered|carries the intention|(delta|announc)[^.]{0,60}[Ii]ntention|[Ii]ntention[^.]{0,60}(delta|announc)"

# The `Blocks:` field is one coupling with two ends: a story document declares it
# (spec section "The user story document"), and closing reads it to find the
# blocks nobody delivered (spec section "Closing a batch"). One assertion over
# both files — two separate ones would each stay green while one end renamed the
# field, which is the whole failure this locks out.
shared "both ends spell the Blocks field alike" \
    "\`Blocks:\`" \
    delivering-a-story closing-a-batch

# The withdrawal duty reads the `Blocks:` declarations, not the specs: a block
# fitted to a `main` that moved since the batch opened is delivered even though
# its text no
# longer matches the delta word for word, and diffing the specs against that
# delta would wrongly report it missing. A positive assertion cannot lock this
# out — the Red Flags table and the withdrawal duty can both carry the new
# wording while an old cell or clause still points a reader at the specs, and a
# `require` on the new text would stay green regardless. The regex targets the
# two forms that phrase found: "check the specs on main" and "against what
# actually shipped". It must not match that duty's own contrast —
# "Diffing the specs against the delta would report it missing" — which pairs
# "specs" with "the delta", never with "main" or "shipped".
absent_everywhere "no skill finds undelivered blocks by reading or diffing the specs" \
    "[Cc]heck the specs on main|against what (actually )?shipped"

# The form of a batch document lives in one place, `writing-a-batch-document`.
# A skill that writes or amends one invokes it and passes what varies: the
# number and the slug of a document to write, or the document and what changes
# in it.
for s in opening-a-batch amending-a-batch; do
    require "$s" "invokes writing-a-batch-document to write or amend the batch document" \
        "nvoke \`supercharlouze:writing-a-batch-document\` and give it"
done
# The form is spelled there and nowhere else. Walks the declared skills, so one
# declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the form of a batch document" \
    "exact text, in blocks|unique within the batch|Give the paragraph in a .diff. fence|No block is attached to a story|faces several specs at once|Nothing normative goes in .Constraints.|bind only its stories|Three shapes of the field|one line per guarded module|There is no other list to keep|list of stories does not appear|history of its own scope" \
    $(declared_skills | grep -vx writing-a-batch-document)

# The end of a review is conducted in one place, `finishing-a-pr`. A skill whose
# pull request is reviewed invokes it, and passes its conditions and its next
# step.
for s in adopting-a-module opening-a-batch amending-a-batch delivering-a-story closing-a-batch; do
    require "$s" "ends its review by invoking finishing-a-pr" \
        "nvoke \`supercharlouze:finishing-a-pr\` and give it"
done
# How a review ends is spelled there and nowhere else, apart from the rules the
# foundation keeps. Walks the declared skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the end of a review" \
    "pushed as a .fixup!. commit|[Ss]quash the fixups|[Ss]quash the .fixup!. commits|[Aa]nnounce (that )?the pull request (is )?ready|ready to be approved and merged|[Nn]ever approves? (and|or) (never )?merges?|agreement in the conversation|block to copy and paste|announces the merge|prompts? stands on its own|refers back to (this|the) conversation" \
    $(declared_skills | grep -vx -e finishing-a-pr -e following-the-rules)
# The abandonment of a stopped story is the other moment that asks for a clear
# context: the skill that conducts it makes the request, and takes the form of
# the prompt from the foundation.
# shellcheck disable=SC2046
absent "no other skill asks for a clear context" \
    "[Cc]lear the context" \
    $(declared_skills | grep -vx -e finishing-a-pr -e following-the-rules -e handling-a-stopped-story)
absent "the steps a ruling asks for are not conducted in the session that took it" \
    "Take them in the order their row gives" \
    handling-a-stopped-story

# The next step is named, and its prompt given, when the human announces the
# merge, not when the agent announces the pull request ready: given then, the
# review that follows buries it. One assertion over the review-ending
# skills, and the former timing hunted in all of them.
absent_everywhere "no skill hands over the next step at the ready announcement" \
    "[Tt]he announcement (says so|names|therefore names)|announcing it ready is where|an announcement that names|when it announces the pull request ready"

# The observation period was two stories "enable, then remove" before the
# declared default and the effective state were told apart. Enabling is the
# project's gesture and changes no spec; the first story moves the declared
# default. The positive needles on the new sentence would stay green beside a
# restored old one, so the old phrasing is what has to be absent.
absent "the observation period is not described as enable-then-remove" \
    "split it into two stories" \
    delivering-a-story

# Adoption never sharing the design's context is one coupling with two ends:
# `opening-a-batch` states it as the reason its Preconditions stop, and
# `using-batches` repeats it in Override 1. One assertion over both files —
# two separate `require` calls would each stay green while one end drifted
# away from the other's wording.
shared "adoption never shares the design's context" \
    "never conducted in the same context" \
    opening-a-batch using-batches

# The old norm called adoption a "blocking precondition" and this branch
# retired that wording along with the wordings it produced ("Adoption is
# blocking", "blocking; nothing starts"). Nothing else guards this: the
# positive assertions above stay green on a file that carries both the new
# paragraph and a resurrected old one.
absent_everywhere "no skill carries the retired blocking-precondition wording" \
    "blocking precondition|Adoption is blocking|blocking; nothing starts"

# The directory-does-not-matter justification belongs to following-the-rules, which
# states the preconditions common to every pull request of this system. A
# path skill that restates it creates a second formulation of one rule, and a
# second formulation is what drifts.
absent "only following-the-rules justifies dropping the directory precondition" \
    "Where you are standing does not matter" \
    adopting-a-module opening-a-batch amending-a-batch delivering-a-story closing-a-batch recording-a-decision

# One home per rule: `writing-in-a-spec` states that a rule belongs to exactly
# one spec, and the skills that invoke it keep only what their own step does
# when a rule reaches past one module.
require writing-in-a-spec "a rule belongs to exactly one spec, stated where it lives" \
    "**A rule belongs to exactly one spec.** A rule that would constrain behaviour observable at the boundary of more than one module is not a rule looking for a home"

# Each skill that invokes it names the rule where its own step stops on it.
for s in adopting-a-module writing-a-batch-document delivering-a-story; do
    require "$s" "names the rule its step stops on" "**A rule belongs to exactly one spec.**"
done

# The batch document's immutability has a bound, and the bound is the closure
# (spec section `Batch`). `writing-a-batch-document` states the rule and its
# bound; `closing-a-batch` is the end that performs it and says only what it
# does to the document.
require writing-a-batch-document "the batch document's immutability is bounded at closing" \
    "nothing in the normal course of the batch modifies it **until closing**"
require closing-a-batch "closing is the one moment that touches the batch document" \
    "It is also the only moment in a batch's normal course that touches the batch document itself: *Withdraw the blocks no story delivered* removes them from it, and *Set status: closed* flips its front matter."
require closing-a-batch "any other edit of the batch document goes through an amendment" \
    "Anything else that would edit the document goes through an amendment pull request of its own, which \`supercharlouze:amending-a-batch\` owns."
# shellcheck disable=SC2046
absent "no other skill restates the immutability of the batch document" \
    "nothing in the normal course of the batch modifies it" \
    $(declared_skills | grep -vx writing-a-batch-document)

# The spec used to deny the bound outright — the batch document carries no
# mutable state and *nothing* in the normal course modifies it, full stop — while
# its own `Closing a batch` section described the closure amending it. Block D2
# retired the denial; no skill may restate it. The `shared` assertion above
# cannot catch that: it stays green on a file carrying the bounded sentence and
# an unbounded one beside it, and the two would contradict each other with the
# suite green.
#
# The regex hunts the denial left *unbounded*, never the true sentence. After
# `batch modifies it` the bounded form has a space then a star, so neither
# alternative reaches it: `( [^*])` needs a space followed by anything but a
# star, `([^ ])` needs anything but a space. Every terminated form is caught —
# "modifies it.", "modifies it, ever" — as is an unbolded "modifies it until
# closing", which is a drift from the one spelling the assertion above fixes.
absent_everywhere "no skill denies that the batch document changes at closing" \
    "batch modifies it( [^*]|[^ ])"

# The first commit of a story that transcribes no block is described in two places —
# the skill that prescribes it and the one that explains why it is the exception of
# form to "the spec change ships first". One assertion over both: two `require`
# calls would each stay green while one end drifted back to striking the entry.
shared "a story with no block still deletes its entry that way" \
    "deletes the gaps register entry it resolves" \
    delivering-a-story following-the-rules

# What that first commit carries besides the removal, so the branch holds a document
# from its first commit and the plan has somewhere to be written at Step 4.
shared "that first commit carries the story document's header" \
    "the header of the story document and its empty \`Rulings log\` and \`Observed drift\` sections" \
    delivering-a-story following-the-rules

# The removal is not obligatory: a technical story removes nothing, so that first
# commit carries the header alone. Both skills enumerate the removals, and an
# enumeration nothing marks as illustrative reads as the list of cases allowed —
# which would send a technical story looking for something to strike.
shared "the removal is not obligatory" \
    "removes, if it removes anything" \
    delivering-a-story following-the-rules

# The mirror: the case is no longer the corrective batch's alone, and a skill that
# still scopes it there sends any other blockless story looking for a rule that
# names a batch kind it does not belong to.
absent_everywhere "no skill scopes the blockless first commit to a corrective story" \
    "\*\*Corrective story\.\*\*|A corrective story is the one exception"

# Removal leaves no trace in the register, so what a module already rejected is
# readable only in the file's history. The skill that carries the gestures
# states that read.
require writing-in-a-gaps-register "the history is read before an entry is added" \
    "Read the file's history before adding an entry"

# The removal duty — say why in the commit, because the file keeps nothing once
# the entry is gone — is stated by the skill that carries the gestures.
require writing-in-a-gaps-register "a removal says why in its commit" \
    "the commit that removes it says why"

# The gesture that abandons a story lives in one place, `abandoning-a-story`. A
# skill that abandons a story invokes it and passes the story's branch.
for s in handling-a-stopped-story delivering-a-story; do
    require "$s" "invokes abandoning-a-story with the story's branch" \
        "invoke \`supercharlouze:abandoning-a-story\` and give it the story's branch"
done
# What it carries is spelled there and nowhere else. Walks the declared skills,
# so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the abandonment gesture" \
    "dies with the branch|live claim on its sections|[Dd]elete (its|the story|the abandoned) branch|[Rr]emove its worktree|worktree removed|discard the branch" \
    $(declared_skills | grep -vx abandoning-a-story)

# The copies of the specs, blocks applied, are built in one place,
# `applying-a-spec-delta`. A skill that needs them invokes it and passes the
# batch document and the blocks to apply.
for s in opening-a-batch amending-a-batch rereading-a-batch; do
    require "$s" "invokes applying-a-spec-delta with the batch document and the blocks" \
        "nvoke \`supercharlouze:applying-a-spec-delta\` and give it the"
done
# How they are built is spelled there and nowhere else. Walks the declared
# skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates how the applied copies are built" \
    "outside the repository|scratch directory|checks every block|fails this check does not apply|the text the block ordered before it leaves|[Bb]uild (a|that|the) cop(y|ies)|cop(y|ies) built|coherence reread built|Coherence Reread\` builds it" \
    $(declared_skills | grep -vx applying-a-spec-delta)

# The rereads of a batch are conducted in one place, `rereading-a-batch`. A
# skill whose pull request owes them invokes it, and passes the batch document,
# the blocks to apply, the rereads due and the ADRs the pull request writes or
# rewrites.
for s in opening-a-batch amending-a-batch; do
    require "$s" "invokes rereading-a-batch to have a batch reread" \
        "nvoke \`supercharlouze:rereading-a-batch\` and give it"
done
# How they are conducted is spelled there and nowhere else. Walks the declared
# skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates how a batch is reread" \
    "Carry every revision it returns back into|coherence reread has closed its rounds|on each applied copy|outside the context that wrote the document|back to the coherence reread|changed or added a block|returns as not applied" \
    $(declared_skills | grep -vx rereading-a-batch)
# The batch skill reaches the two rereads through that skill only.
absent "the batch skill invokes neither reread itself" \
    "supercharlouze:rereading-a-spec|supercharlouze:rereading-a-technical-design" \
    opening-a-batch amending-a-batch

# An amendment and a requalification are conducted in one place,
# `amending-a-batch`. The skill that opens a batch carries neither.
absent "the opening carries no amendment and no requalification" \
    "amendment|[Rr]equalif" \
    opening-a-batch

# What follows a stop condition is conducted in one place,
# `handling-a-stopped-story`. The skill that amends a batch abandons no story
# and puts no choice to the human.
absent "the amendment carries no handling of a stopped story" \
    "abandoning-a-story|Put the choice to the human|[Rr]equalifying|rules on the constraint" \
    amending-a-batch

# The mirror of the positive assertions above: a skill that carried both the new
# wording and the old would leave every one of them green while still telling an
# agent to strike a register entry. The needle is the bare token, because a
# pattern aimed at the register misses the one line that matters most — a table
# row naming the gesture, whose "entry" is the column header, out of reach of any
# sane window. A bare token has no holes as long as the word means nothing else
# in these five files, which is why the source inventory says "drop" instead.
absent_everywhere "no skill strikes a gaps register entry" \
    "[Ss]truck|[Ss]trik"

# `addressable` justified an entry's shape and also read as "made to be pointed
# at" — the reading under which one entry designates another. The spec dropped
# it; the skill's twin sentence drops it the same way. The gesture's need
# survives in the sentence that follows, where it describes what a writer
# needs rather than a property of the entry, and that is the sentence asserted
# positively right after.
absent_everywhere "no skill calls an entry addressable" \
    "[Aa]ddressable"

# A register is reread entry by entry, and nothing keeps a prose that
# qualifies a group in step: it goes false without anyone having touched it.
# The skill that carries the rules of an entry says so.
require writing-in-a-gaps-register "a group's qualification stays out of the register" \
    "What qualifies an entry lives in the entry"

# A settled entry leaves the file and takes with it whatever pointed at it:
# the entry-to-entry cross-reference loses its target without anyone editing
# it. The same skill says so.
require writing-in-a-gaps-register "entries do not point at each other" \
    "An entry designates no other entry"

# The pairing of a spec change with its code is stated by the negation, because a
# story may carry code alone — a corrective batch's story does today. Both skills
# that state it must spell it alike: the doctrine and the procedure drifting apart
# here is exactly how an agent ends up believing a story owes the spec a sentence.
shared "the pairing is stated by the negation" \
    "never carries its spec change without the code that implements it" \
    following-the-rules delivering-a-story

# The mirror. The positive assertion above stays green on a file that carries both
# the negation and the old unconditional claim, and it is the old one an agent would
# obey — it is the shorter and the more emphatic of the two.
absent_everywhere "no skill pairs spec change and code unconditionally" \
    "ship together or not at all|\*both\* the spec change|the spec change and the code together"

# The freeze is written in the foundation, where whoever executes or reviews a
# task reads it.
require following-the-rules "states the freeze of the spec file" \
    "Between the first commit of the branch and the opening of the pull request, no task modifies the spec file"

# The authority rule is written in the foundation, where whoever executes or
# reviews a task reads it.
require following-the-rules "states that the spec wins over the batch" \
    "**When a batch and a spec contradict each other, the spec wins — no exception, no deliberation.**"
require following-the-rules "states that correcting a spec is a human act" \
    "**Correcting a spec mid-batch is a human act, never an agent's.**"

# The mirror. A skill carrying both anchors would leave the positive assertion
# green while still handing implementers the old one. The needle is the bare term:
# no branch of this flow has a commit called that any more — the branch has a first
# commit, whose content is a transcription or something else depending on the story
# — so the term returning anywhere is the drift, not just the old freeze opening.
absent_everywhere "no skill anchors the freeze on a transcription commit" \
    "transcription commit"

# What an abandonment leaves on `main` is not a fixed count: a story that
# transcribed no block announced no intention in the spec delta, so it leaves the
# reservation alone. A skill that counts hands closing a checklist of the wrong
# length, and closing is the only skill that picks these up.
absent_everywhere "no skill counts what an abandonment leaves on main" \
    "Two residues|two residues|two things it never touched"

# Transcribing no block does not mean touching no spec: a teardown story removes
# from the spec what no block announced, and its first commit carries that removal.
# Both skills that describe the blockless first commit must name that case. The
# negation they state is already guarded; its justification was not, and the two
# ends drifted into claiming a blockless story never touches the spec.
shared "both skills name the blockless story that still changes the spec" \
    "teardown story removes from the spec what no block announced" \
    following-the-rules delivering-a-story

# The unconditional claim the spec change removed: a bounded change used to be
# said never to leave the spec silent. The positive assertion above would stay
# green on a file carrying both phrasings, and the two contradict each other —
# one says the spec is always updated, the other says it depends.
absent_everywhere "no skill says a bounded change never leaves the spec silent" \
       "never leaves the spec silent"

# The old declaration named only the sections. Left standing beside the new one,
# it would tell a bounded change that naming its sections is enough — and a
# reader comparing sections against the wrong spec finds conflicts that are not
# there, or misses the one that is.
#
# The needle carries "therefore" on purpose. detecting-concurrency
# tells a *reader* where a bounded change keeps its declaration, in words that
# overlap this one; that sentence belongs to the concurrency detection rule and
# is not what this guard hunts. "therefore declares its sections" appears only
# where the duty is laid on the bounded change itself.
absent_everywhere "no skill says a bounded change declares only its sections" \
       "therefore declares its sections"

# Closing used to file every undelivered block as a gap on its own. The human
# now decides, block by block; a leftover of the old duty would file them all.
absent_everywhere "no skill files an undelivered block as a gap on its own" \
    "Write the shortfall into the gaps register|inscribed in the gaps register as"

# A bounded change's branch is `bounded/<slug>`. A skill still naming the former
# pattern would scan, or create, a branch nobody else reads as a claim.
absent_everywhere "no skill names the former bounded branch" \
    "\`fix/"

# A spec carries no date, no status and no work-in-progress marker, except the
# gating sentence of a flag. Both skills that describe a spec say it alike.
shared "a flag's gating sentence is the one marker a spec admits" \
    "no work-in-progress marker, except a flag's gating sentence" \
    following-the-rules adopting-a-module

absent "no skill denies a spec every marker" \
    "A spec carries none, ever" \
    using-batches following-the-rules adopting-a-module writing-in-a-spec

# A batch no longer says why it happens now, and its reserved entries go under
# `Scope`, not under `Spec delta`. The positive assertions stay green beside a
# leftover of the old wording, so the old wording is hunted too.
absent_everywhere "no skill asks a batch why it happens now" \
    "why now|happens now"

absent_everywhere "no skill files reserved entries under the spec delta" \
    "gaps register entries it reserves, or|gaps register entries this batch reserves|replacing the reserved gaps entries|delivery perimeter|required ordering of the user stories"

# A block shows its change in the paragraph that contains it. The former form,
# a quoted passage then its replacement, must survive nowhere.
absent_everywhere "no skill has a block quote a passage" \
    "quoted passage|quotes the current passage|passage a block quotes|Quote the passage|the passage it removes"

# The coherence reread checks every block against `main` as it builds the applied
# copy. A block check left in the batch-document reread would run it twice.
absent "the batch-document reread leaves the blocks to the coherence reread" \
    "every block's paragraph|every block's unchanged and removed lines matching" \
    opening-a-batch amending-a-batch rereading-a-batch

# A reread says in which context it runs. "Fresh eyes" names no context an agent
# can reach.
absent_everywhere "no skill rereads with fresh eyes" \
    "fresh eyes"

# One skill rereads a spec, new or changed, and the skills that need a spec
# reread invoke it rather than carrying readers of their own.
shared "the skills that have a spec reread invoke the shared reread" \
    "invoke \`supercharlouze:rereading-a-spec\`" \
    adopting-a-module rereading-a-batch
absent "no calling skill carries readings of its own" \
    "Does this specification hold what a specification must hold|precise and concise\\?|Where does this sit in the model|Every reader returns before anything goes up|stop the rounds" \
    adopting-a-module opening-a-batch amending-a-batch rereading-a-batch
# The dependency runs one way: the reread knows none of the skills that invoke
# it, and says nothing a calling skill would have to keep in step with. What a
# reader gets is its own business.
absent "the reread names no skill that invokes it" \
    "supercharlouze:([^r]|r[^u]|ru[^n])|adopting-a-module|opening-a-batch|amending-a-batch|calling skill" \
    rereading-a-spec
absent "no calling skill says what a reader gets" \
    "as a new spec|as a changed spec|never the blocks|the spec as \`main\` carries it" \
    adopting-a-module opening-a-batch amending-a-batch rereading-a-batch

# An amendment changes the scope, the spec delta or the flag of an open batch.
# A leftover naming only scope and flag would send a spec delta change nowhere.
absent_everywhere "no skill bounds an amendment to scope and flag" \
    "scope or (its |the |of )?flag"

# An amendment also changes the technical design and the constraints. A leftover
# ending the list on the spec delta would send a constraint ruled untenable
# nowhere.
absent_everywhere "no skill bounds an amendment to scope, spec delta and flag" \
    "spec delta or (its |the |of )?flag"

# An amendment that writes or rewrites an ADR goes through the technical reread.
# A leftover ending the trigger on the constraints would let an ADR written by an
# amendment reach the review unread.
absent "an amendment's technical reread is not bound to the batch document" \
    "or the constraints goes through the technical reread" \
    amending-a-batch

# Everything that reaches `main` may ship to production. The flow presumes no
# more of the project: a skill still requiring continuous deployment asks more
# than the flow does.
absent_everywhere "no skill requires continuous deployment" \
    "[Cc]ontinuous"

# Within a batch, one pull request adds to a gaps register: the closing one.
# The skill that carries the gestures says so.
require writing-in-a-gaps-register "only the closing pull request adds entries within a batch" \
    "Within a batch, only the closing pull request adds entries to the gaps register"

# A finding the register already let go comes back only with what changed.
require writing-in-a-gaps-register "a deleted finding is re-entered only with what changed" \
    "A finding already deleted from the register is re-entered only if the entry says what has changed since"

# The spec no longer carries the register's format; the skill that carries the
# gestures keeps it.
require writing-in-a-gaps-register "an added entry keeps the entry format" \
    "An entry is one list item, added at the end of its category"

# The former wording left the batch's adding writer unnamed, and placed an
# entry at the end of a section.
absent_everywhere "no skill leaves the batch's adding writer unnamed" \
    "one writer per batch|single writer per batch|at the end of a section"

# The batch-document reread is a step of its own, before the pull request opens.
absent_everywhere "no skill folds the document reread into opening the pull request" \
    "Reread the batch document, then open the pull request|these six steps"

# The batch rules neither count their steps and choices nor designate one by its
# rank: the list carries the count, and a rank goes false when a step is added.
absent "the batch rules neither count nor rank their steps and choices" \
    "runs these [a-z]+ steps|Step 7 opens|step 3 releases|among three choices" \
    using-batches following-the-rules opening-a-batch amending-a-batch

# The specs carry no changelog any more. No shipped skill file names one:
# frontmatter included, which the content guards skip.
CHANGELOG_HITS="$(grep -rli 'changelog' "$REPO_ROOT/skills" || true)"
if [ -z "$CHANGELOG_HITS" ]; then
    pass "no skill file names a changelog"
else
    fail "no skill file names a changelog (present in: $(echo $CHANGELOG_HITS))"
fi

# Entries a batch no longer takes on are released, not merely revised, and an
# amendment releases them before closing does.
absent_everywhere "no skill merely revises reservations" \
    "reservations are revised|Revise the gaps register reservations|a scope revised mid-flight|and \`supercharlouze:closing-a-batch\` releases it\.|No other skill picks them up|A fresh \`NN\` only if|out of the scope releases it"

# A batch reserves an entry at its opening or by an amendment: no skill says a
# reservation comes from the opening alone.
absent_everywhere "no skill ties a reservation to the opening alone" \
    "reserved at opening|Reservation is a property of the opening pull request|reservation posted by the batch's opening pull request|by the batch's own opening pull request|put there by the batch's opening pull request,|it got there when the batch's opening pull request merged"

# A corrective story is abandoned once the requalification is ruled: no skill has
# its pull request closed at the stop.
absent "no skill closes a corrective story's pull request at the stop" \
    "Therefore: \*\*close the story's pull request|So: \*\*close the story's pull request|Abandon the story, closing its pull request|exactly as a requalified corrective story is abandoned" \
    using-batches following-the-rules opening-a-batch amending-a-batch delivering-a-story recording-a-decision handling-a-stopped-story

# A technical story is abandoned once its ruling is given: no skill has its pull
# request closed at the stop either.
absent_everywhere "no skill closes a technical story's pull request at the stop" \
    "Close its pull request without merging it if one is already open|Close it only if it is already open|[*][*]Abandon the story[.][*][*]"

# using-batches routes a stopped story to handling-a-stopped-story: it neither
# opens on what a requalification does not do nor copies its procedure.
absent "using-batches copies no requalification procedure" \
    "does not start by closing a pull request|abandon the story|close its pull request|no longer takes on are released|a fresh \`NN\`|settled elsewhere" \
    using-batches following-the-rules

# What follows a stop is spelled in handling-a-stopped-story and nowhere else:
# a skill that routes to it says nothing of the ruling nor of the abandonment.
absent "no routing skill restates what follows a stop" \
    "conducts the requalification|rule a constraint untenable|rule an ADR untenable|requalification is ruled|decision goes to|or a corrective batch must be requalified" \
    using-batches delivering-a-story

# A requalified technical story brings the flag its block requires, if any, not a
# flag by default.
absent_everywhere "no skill makes a lost technical exemption declare a flag" \
    "declares one by that same amendment|a flag if the batch was exempted because all of its stories were technical"

# The mirror: a story states a flag only when its batch declares one for the
# story's module. The former unconditional sentence must not survive.
absent "no story states a flag its module does not carry" \
    "If the batch declares a feature flag, the transcribed" \
    delivering-a-story

# The mirror: the divergence rule says what to do, and no longer lists causes.
absent "no story skill lists the causes of a divergence" \
    "legitimate cause" \
    delivering-a-story

# The rules for code under a flag were rewritten. The former wording must survive
# nowhere: the positive needles would stay green beside it.
absent "no skill keeps the former guarded-code rules" \
    "Whatever way the project switches its flags|Switching off stays possible at all times|It holds four rules|coexisting on the same data|switching off is always possible|save for the data produced with the flag on" \
    using-batches following-the-rules delivering-a-story

# The spec no longer fixes the form of the gating sentence; a skill does.
absent_everywhere "no skill says the spec fixes the gating sentence's form" \
    "form the spec fixes|form fixed by the spec"

# Each flag is independent of the others. The foundation says it, and the skill
# that writes the `Feature flag` field points at the foundation for one flag
# per (batch, module).
require following-the-rules "each flag is independent of the others" \
    "Each flag is switched on, switched off and lifted independently of the others: one flag's lifting story waits for no other flag's."
require writing-a-batch-document "points at one flag per batch and module" \
    "one flag per (batch, module)"
# shellcheck disable=SC2046
absent "no other skill restates the independence of the flags" \
    "lifted independently of the others" \
    $(declared_skills | grep -vx following-the-rules)

# A corrective batch's spec delta carries no block; the field itself is never
# left blank.
absent_everywhere "no skill says a corrective batch's spec delta is empty" \
    "spec delta is empty"

# Drift is code that contradicts the spec, or behaviour no spec describes. A
# divergence from a block is another matter and keeps its word.
absent_everywhere "no skill calls a divergence between spec and code drift" \
    "divergence between (the )?spec"
absent_everywhere "no skill narrows drift to a contradiction" \
    "contradiction between (the )?spec"
shared "drift covers code that contradicts the spec and behaviour no spec describes" \
    "any code on \`main\` that contradicts the spec on \`main\`, and any behaviour on \`main\` that no spec describes, is drift" \
    following-the-rules
shared "observed drift takes both kinds of drift" \
    "Record under **Observed drift** the drift you noticed *outside* this story's scope: code that contradicts the spec, and behaviour no spec describes." \
    delivering-a-story

# The spec names what a ruling carries; the skills keep the form of its line.
shared "the skills keep the form of a ruling line" \
    "\`Ruling: <decision> — <why> — <what it costs if it is wrong>\`" \
    following-the-rules adopting-a-module

# The plugin's own language is a rule of the plugin's repository, not of the
# projects the skills work on.
absent_everywhere "no skill states the plugin's own language" \
    "entirely English"

# A batch's constraints now include its shared technical decisions, so the old
# enumeration of what a batch carries must not survive beside the new one.
absent "a batch no longer lists only migration constraints" \
    "its flags, the order of its stories and of its blocks, and its migration" \
    using-batches following-the-rules

# Constraints now carry shared technical decisions as well, so the old bound —
# migration and compatibility, then the order — must not survive anywhere.
absent "Constraints are no longer bounded to migration and order" \
    "migration and compatibility constraints,? and the required order" \
    opening-a-batch amending-a-batch writing-a-batch-document using-batches following-the-rules delivering-a-story closing-a-batch recording-a-decision

# A constraint is judged against the technical design, known at opening, never
# against the stories, which do not exist yet.
absent "no constraint is judged against the stories" \
    "without breaking another" \
    opening-a-batch amending-a-batch writing-a-batch-document using-batches following-the-rules delivering-a-story closing-a-batch recording-a-decision

# A story writes its departures from the design in the form the batch document
# spells.
shared "the batch and the story spell a technical design ruling alike" \
    "\`Technical design ruling:\`" \
    writing-a-batch-document delivering-a-story

# Both rereads dispatch their readers the same way. One assertion per rule over
# both skills, so neither drifts alone.
shared "both rereads dispatch on the conductor's model" \
    "Dispatch every reader on the model you run on, and name that model in the dispatch" \
    rereading-a-spec rereading-a-technical-design
shared "both rereads send out fewer readings after the first round" \
    "This is the first round's dispatch: a later round sends out fewer (\`Findings and Rounds\`)." \
    rereading-a-spec rereading-a-technical-design

# The rounds of a reread are run in one place, `running-reread-rounds`. A reread
# invokes it once its first round is dispatched, and passes what varies from one
# reread to the other.
for s in rereading-a-spec rereading-a-technical-design; do
    require "$s" "invokes running-reread-rounds once the first round is dispatched" \
        "Once the first round is dispatched, invoke \`supercharlouze:running-reread-rounds\` and give it"
done
# How the rounds run is spelled there and nowhere else. Walks the declared
# skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the rounds of a reread" \
    "Every reader returns before anything goes up|never a running report|You instruct the findings|arbitrate a draft|A revision retouches|Keep a copy of the state each round read|reads the revision, and nothing else|leaves nothing unread opens no round|Dispatch only the readings the revision bears on|Keep a ledger from round to round|do not reword it a third time|third round is the last you open|These stop the rounds|it does not replace it|A round runs on the revised text|rewritten whole|I reworded the clause|One more round|put its findings up now|the findings to rule on" \
    $(declared_skills | grep -vx running-reread-rounds)
# The conditions these replaced never stopped a reread: one read as an order to
# reopen, the other waited for a round with no fresh finding, which a reader of
# freshly revised text always has.
absent "no reread reopens on every unread state" \
    "A fresh round only on a state|already examined and declined|Two rounds stuck on the same clause" \
    rereading-a-spec rereading-a-technical-design running-reread-rounds

# The technical reread knows none of the skills that invoke it.
absent "the technical reread names no skill that invokes it" \
    "supercharlouze:([^r]|r[^u]|ru[^n])|using-batches|adopting-a-module|opening-a-batch|amending-a-batch|handling-a-stopped-story|making-a-bounded-change|delivering-a-story|closing-a-batch|rereading-a-spec|recording-a-decision|calling skill" \
    rereading-a-technical-design

# A reading is dispatched when its object exists: the sentence that gave every
# batch every reading must survive nowhere, or a batch with no design would send
# out readings that have nothing to read.
absent "the technical reread no longer gives every batch every reading" \
    "Every batch gets every reading" \
    rereading-a-technical-design

# The readings of the technical reread live in its skill; the batch skill that
# invokes it carries none of them.
absent "the batch skill carries no technical reading of its own" \
    "deliver what the batch promises|stand on the code as it is|hold as an architecture|modules this design draws deep|How does this design fail|blocks and the design hold the ADRs|stand with the specifications and the other ADRs" \
    opening-a-batch amending-a-batch rereading-a-batch

# The opening invokes the technical reread for every batch, and the reread says
# itself when it has nothing to reread: the former skip must survive nowhere, or
# a batch with no design would open with its ADRs unread.
absent "the opening no longer skips the technical reread" \
    "skipped when the batch has neither|both read \`none\` skips this step" \
    opening-a-batch amending-a-batch rereading-a-batch

# The opening now places more than two rereads; the former count must not survive.
absent "the opening counts no rereads" \
    "[Tt]wo rereads|[Tt]hree rereads" \
    opening-a-batch amending-a-batch rereading-a-batch

# The flow's stop conditions are named, never counted: a count goes false in
# every skill the day a condition is added, as it did when the constraint
# condition joined the corrective and the technical ones.
absent "no skill counts the stop conditions the flow adds" \
    "adds (two|three|four)( stop)? conditions|adds (two|three|four)[.,]|(both|either|neither) (stop )?conditions?" \
    using-batches following-the-rules delivering-a-story opening-a-batch amending-a-batch recording-a-decision handling-a-stopped-story

# The rules of a bounded change are listed, never counted: a count goes false
# the day a rule is added, as it did when the ADR rule joined them.
absent "no skill counts the rules of a bounded change" \
    "with (four|five|six|seven) rules|the (four|five|six|seven) rules" \
    using-batches following-the-rules making-a-bounded-change

# An opening and an amendment both write the ADRs their human partner decided.
# Each skill carries the gesture, since an agent reads only the one it invoked:
# one assertion per sentence over both, so neither copy drifts alone.
shared "the opening and the amendment have an ADR written the same way" \
    "Invoke \`supercharlouze:recording-a-decision\` for each ADR to write or to rewrite, and hand it those copies." \
    opening-a-batch amending-a-batch
shared "the opening and the amendment delete an abandoned ADR the same way" \
    "Delete yourself each ADR your human partner abandoned, in a commit that says why." \
    opening-a-batch amending-a-batch
shared "the opening and the amendment answer the ADR written by hand alike" \
    "| \"My human partner decided this ADR, I'll write the file myself\" | Invoke \`supercharlouze:recording-a-decision\`. It confronts the decision with the specs, blocks applied, and with the other ADRs. |" \
    opening-a-batch amending-a-batch

# What an ADR is on disk, and what it does not carry, is said alike by the skill
# that defines it and the skill that writes it.
shared "an ADR is a file placed directly in docs/adr, on both ends" \
    "a \`.md\` file placed directly in \`docs/adr/\`" \
    following-the-rules recording-a-decision
shared "an ADR this flow writes carries no date and no status, on both ends" \
    "An ADR this flow writes or rewrites carries no date and no status." \
    following-the-rules recording-a-decision

# The dependency runs one way: recording-a-decision knows none of the skills
# that invoke it, and says nothing they would have to keep in step with.
absent "recording-a-decision names no skill that invokes it" \
    "opening-a-batch|amending-a-batch|delivering-a-story|adopting-a-module|calling skill" \
    recording-a-decision

# recording-a-decision is told not to commit, and not who does.
absent "recording-a-decision does not say who commits" \
    "invoked this one (does|commits)|invokes this one (does|commits)" \
    recording-a-decision

# The conditions of an ADR are written in following-the-rules alone: the adoption
# points at them.
absent "the adoption does not copy the conditions of an ADR" \
    "undoing it is expensive|settles between real alternatives" \
    adopting-a-module

# The rules for code under a flag are written in full in the foundation, as one
# block.
require following-the-rules "states the rules for code under a flag as one block" \
    "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off: - The two states work on the same data: what one produces, the other reads and uses, with no error and no data loss. - With the flag off, the user finds the behaviour from before the batch. - The story's pull request tests the flag-on behaviour, the flag-off behaviour, and their coexistence. - Lifting the flag comes down to deleting the branching and the behaviour from before the batch, without writing anything new."

require delivering-a-story "takes the form of the gating sentence from the foundation" \
    "in the form \`supercharlouze:following-the-rules\` fixes"
absent "the story skill no longer claims to be where the rules for code under a flag are written" \
    "the only place those rules are written out" \
    delivering-a-story

# No copied text is said to be stated by using-batches any more.
absent "no copied text is attributed to using-batches" \
    "exactly as \`supercharlouze:using-batches\` states it|those \`supercharlouze:using-batches\` states" \
    delivering-a-story

# What holds at every moment lives in the foundation, and an agent reads only
# the skill it invoked: every entry skill starts by invoking it. Walks the
# declared list, so an entry skill declared later is covered.
for s in $(declared_skills entry); do
    require "$s" "starts by invoking the foundation" \
        "**Start by invoking \`supercharlouze:following-the-rules\`, unless this session already has.**"
done

# A rule the foundation carries is pointed at there, never at using-batches.
absent_everywhere "no skill points at using-batches for a rule the foundation carries" \
    "\`Concision\` in \`supercharlouze:using-batches\`|\`The Model\` of \`supercharlouze:using-batches\`"

# The prompt of the batch-document reader is pasted into the dispatch of a
# subagent that loads no skill, so it copies what it needs from the skills that
# state it. One assertion over both ends, so a copy does not drift.
shared "the document reader is told the bound of Constraints as the document skill states it" \
    "migration and compatibility constraints, the technical decisions the rest of the technical design relies on, and the required order of the stories and of the blocks" \
    writing-a-batch-document rereading-a-batch
shared "the document reader is told the reservation annotation as the register skill states it" \
    "\`reserved by batch-NN\`" \
    writing-in-a-gaps-register rereading-a-batch
shared "the document reader is told the gating sentence as the foundation states it" \
    "🔒 \`billing.recurring\`, off by default" \
    following-the-rules rereading-a-batch
shared "the document reader is told a block's identifier as the document skill states it" \
    "carries an identifier \`D<n>\`" \
    writing-a-batch-document rereading-a-batch

# The rules of a bounded change live in one place, `making-a-bounded-change`.
# `using-batches` routes to it and restates none of them. Walks the declared
# skills, so one declared later is covered.
require using-batches "the routing table leads bounded work to making-a-bounded-change" \
    "| Bounded work | \`supercharlouze:making-a-bounded-change\` |"
require using-batches "the routing table leads a spec judged wrong to making-a-bounded-change" \
    "| Your human partner judges that a spec is wrong and the code is right | \`supercharlouze:making-a-bounded-change\` |"
require using-batches "the routing table reroutes nothing of a spike" \
    "| Spike | Nothing is rerouted |"
# shellcheck disable=SC2046
absent "no other skill restates the rules of a bounded change" \
    "if and only if nothing observable at the module's boundary changes|That silence is not a tolerance|It carries no feature flag|add an entry and delete one|may carry nothing but ADRs|redoes the detection|under rule \(e\)|reread .docs/adr/. and hold what you find there|the spec can stay silent about it|it carries the spec correction they decide" \
    $(declared_skills | grep -vx making-a-bounded-change)
absent "using-batches keeps no section the bounded path is sent to" \
    "under .What Is Kept, What Is Rerouted. below|except what .What Is Kept, What Is Rerouted. states below|with these rules:" \
    using-batches

# A skill that sends work to a bounded change names the skill that carries it.
absent_everywhere "no skill sends a bounded change to using-batches" \
    "bounded change, under .supercharlouze:using-batches"

# The red flags of the story path live in delivering-a-story: using-batches
# routes, and keeps none of them.
absent "using-batches keeps no red flag of the story path" \
    "local merge is quicker|transcribe the whole spec delta now" \
    using-batches

# The reservations a requalified batch drops are released by the steps the
# ruling asks for: the skill that takes the ruling does not make it a step of
# its own procedure.
absent "the session that takes a ruling releases no reservation" \
    "[*][*]Release the reservations" \
    handling-a-stopped-story

exit $((FAILURES > 0))
