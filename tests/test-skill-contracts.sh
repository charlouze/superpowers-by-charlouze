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
for s in adopting-a-module writing-a-batch writing-a-user-story closing-a-batch using-batches; do
    require "$s" "invokes starting-a-branch with the name of the branch" \
        "nvoke \`supercharlouze:starting-a-branch\` and give it the name"
done
require adopting-a-module "an adoption passes adopt/<module>" \
    "Invoke \`supercharlouze:starting-a-branch\` and give it the name \`adopt/<module>\`"
require writing-a-batch "an opening passes batch/NN-<slug>" \
    "Invoke \`supercharlouze:starting-a-branch\` and give it the name \`batch/NN-<slug>\`."
require writing-a-batch "an amendment passes the name it chose" \
    "Invoke \`supercharlouze:starting-a-branch\` and give it the name you chose."
require closing-a-batch "a closing passes batch/NN-<slug>-close" \
    "**Invoke \`supercharlouze:starting-a-branch\` and give it the name \`batch/NN-<slug>-close\`.**"
require writing-a-user-story "a story passes story/NN-us-N-<slug>" \
    "Invoke \`supercharlouze:starting-a-branch\` and give it the name \`story/NN-us-N-<slug>\`."
require using-batches "a bounded change passes bounded/<slug>" \
    "invoke \`supercharlouze:starting-a-branch\` and give it the name \`bounded/<slug>\`"
# Allocation reads `origin/main` before the branch exists, so it fetches itself.
case "$(body_flat "$REPO_ROOT/skills/writing-a-batch/SKILL.md")" in
    *"git fetch origin git ls-tree --name-only origin/main docs/batches/"*)
        pass "writing-a-batch: allocation fetches before it reads the remote" ;;
    *)  fail "writing-a-batch: allocation fetches before it reads the remote" ;;
esac
case "$(body_flat "$REPO_ROOT/skills/writing-a-user-story/SKILL.md")" in
    *"git fetch origin git ls-tree --name-only origin/main docs/batches/NN-<slug>/"*)
        pass "writing-a-user-story: allocation fetches before it reads the remote" ;;
    *)  fail "writing-a-user-story: allocation fetches before it reads the remote" ;;
esac
# How a branch is started is spelled there and nowhere else. Walks the declared
# skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the start of a branch" \
    "named branch is not enough|restore the conventional name|detached HEAD|harness's native tooling|wherever you happened to be|GIT_DIR != GIT_COMMON|already in a linked worktree|merge-base --is-ancestor|[Ii]nvoking .superpowers:using-git-worktrees|then branch from .origin/main.|using-git-worktrees (opens|reuses)|branch from .origin/main.: otherwise|create the branch from .origin/main. yourself|Branch from .origin/main., wherever you stand" \
    $(declared_skills | grep -vx starting-a-branch)

# The concurrency scan lives in one place, `detecting-concurrency`. A skill
# whose work claims sections invokes it, passes what varies and stops on what it
# returns: `writing-a-user-story` for a story, `using-batches` for the bounded
# change.
require writing-a-user-story "a story invokes detecting-concurrency with its spec and its sections" \
    "invoke \`supercharlouze:detecting-concurrency\` and give it the story's spec and those sections"
require using-batches "a bounded change invokes detecting-concurrency before creating its branch" \
    "Invoke \`supercharlouze:detecting-concurrency\` before creating \`bounded/<slug>\`, and give it that spec and those sections"
require using-batches "a redone detection receives the branch" \
    "invoke it again, and give it \`bounded/<slug>\` as well"
for s in writing-a-user-story using-batches; do
    require "$s" "stops on what detecting-concurrency returns" \
        "Stop if it returns a conflict or a declaration it could not read"
done
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
# spec's first version, `writing-a-batch` the blocks a spec will receive,
# `writing-a-user-story` their transcription, and `using-batches` carries the
# bounded change. `closing-a-batch` writes into no spec file.
require writing-in-a-spec "states the question of the other-implementation test" \
    "read this sentence as true of their code"
for s in using-batches adopting-a-module writing-a-batch writing-a-user-story; do
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
# `using-batches` carries the bounded change, `writing-a-batch` reserves and
# releases, `writing-a-user-story` removes the entry its story resolves.
for s in adopting-a-module closing-a-batch using-batches writing-a-batch writing-a-user-story; do
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
require writing-a-batch "the opening invokes the reservation with its number" \
    "invoke \`supercharlouze:writing-in-a-gaps-register\` before reserving one, and give it this batch's \`NN\`"
require writing-a-batch "an amendment invokes the release" \
    "releases its reservation in the same pull request: invoke \`supercharlouze:writing-in-a-gaps-register\` before releasing it"
require adopting-a-module "the adoption writes the coverage from its audit" \
    "Write the register's \`Coverage\` from this audit"
require adopting-a-module "a promotion gives the removal its reason" \
    "that is the reason the commit that removes it gives"
require writing-a-user-story "a story adds no entry itself" \
    "Do not add those observations to the gaps register yourself"
require closing-a-batch "the consolidation is written into each entry" \
    "write \"consolidated by batch NN\" into each entry that needs it, never above them"
require closing-a-batch "the release invokes the gesture" \
    "release it. Invoke \`supercharlouze:writing-in-a-gaps-register\` before releasing one."
require closing-a-batch "an undelivered block joins the register through the gesture" \
    "invoke \`supercharlouze:writing-in-a-gaps-register\` and add it under **Gaps**"

# The corrective batch's stop condition is copied "in full" into a story's
# Global Constraints. `following-the-rules` states it and `writing-a-user-story` has it
# copied; a copy that adds or drops a sentence is no longer the condition the
# spec names. One assertion over both ends.
shared "the corrective stop condition is copied exactly as stated" \
    "you discover that it is the **spec** that is wrong and the code that is right, stop. The batch is no longer corrective and must be requalified." \
    following-the-rules writing-a-user-story

# The technical story's stop condition travels the same way: `following-the-rules`
# states it and `writing-a-user-story` has it copied into a story's Global
# Constraints. Same argument as above — a copy that adds or drops a sentence is no
# longer the condition the spec names. One assertion over both ends.
shared "the technical stop condition is copied exactly as stated" \
    "If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical." \
    following-the-rules writing-a-user-story

# The stop condition on a constraint or an ADR that cannot be held travels the
# same way, with the sentence that bounds it: an implementer who meets a
# constraint the spec contradicts must find, in the same copy, that this is not
# the case.
shared "the stop condition on a constraint or an ADR is copied exactly as stated" \
    "If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner. A constraint the spec contradicts does not fall under this condition: the spec wins." \
    following-the-rules writing-a-user-story

# The condition no longer bears on a constraint alone, nor fires only in a batch
# that declares constraints: the former wording must survive nowhere, or a story
# with an ADR and no constraint would carry no stop condition.
absent "the stop condition is no longer bounded to a constraint" \
    "a constraint of its batch cannot be held|constraint condition|whose batch declares constraints only" \
    using-batches following-the-rules writing-a-user-story

# The conditions of an ADR are copied into every story's Global Constraints.
# `following-the-rules` states them and `writing-a-user-story` has them copied: a
# condition spelled differently in the copy is no longer the threshold the
# human agreed to.
shared "the conditions of an ADR are copied exactly as stated" \
    "A technical decision is recorded as an ADR only if it meets these conditions: - undoing it is expensive; - it surprises whoever does not know its context; - it settles between real alternatives." \
    following-the-rules writing-a-user-story

# An unrecorded departure is answered by the delivery review, not by what
# closing does with the design: the former red flag must survive nowhere.
absent "an unrecorded departure no longer leaves the design false" \
    "describing a mechanism nobody built" \
    writing-a-user-story

# The concision rules are copied into every story's Global Constraints.
# `following-the-rules` states them and `writing-a-user-story` has them copied; a rule
# spelled differently in the copy is no longer the rule the implementers obey.
# Only each rule's first sentence is pinned: the copy adapts the exception and
# the gloss on relief for an implementer who reads nothing else.
for rule in \
    "Every sentence says one exact thing, once, and stands on its own." \
    "Every paragraph carries one rule." \
    "A rule says how far it holds, and an exception presents itself as one." \
    "A text says what it delivers or decides, without telling how it got there or why." \
    "No sentence is set in relief"; do
    shared "the concision rule is copied as stated: $rule" "$rule" \
        following-the-rules writing-a-user-story
done

# The mirror: an item of Global Constraints is named, never counted or numbered.
# An ordinal goes false in every paragraph the day an item is added or removed.
absent "no Global Constraints item is counted or numbered" \
    "(first|second|third|fourth|fifth|sixth|seventh|eighth) thing|[0-9]\. the (constraints|freeze|authority|concision)|[0-9]\. \*\*in a " \
    writing-a-user-story

# The mirror: the story header does not count its fields.
absent "the story header does not count its fields" \
    "(two|three|four|five|six|seven) fields|five on a technical story" \
    writing-a-user-story

# The three families that answer the exemption criterion by construction are
# listed in both skills. A family spelled two ways is a family a reader cannot
# claim: the batch document quotes the wording, and the opening review reads it.
# One assertion over both ends.
shared "the flag exemption names the technical batch identically" \
    "**A batch all of whose stories are technical** — none of them changes what is observable at its module's boundary, so every pull request is deployable as it stands. That is what the qualification means, not a tolerance granted to it." \
    following-the-rules writing-a-batch

# `following-the-rules` fixes the forms of the gating sentence, and
# `writing-a-user-story` points at it. Two spellings of the same sentence is how
# a live flag stops being found, so the forms are written out in one place only.
require following-the-rules "the gating sentence is spelled in its fixed form" \
    "🔒 \`billing.recurring\`, off by default"

# The forms of the gating sentence are neither counted nor designated by their
# rank: the one with a lifting condition is recognised by that condition.
absent "no skill counts or ranks the forms of the gating sentence" \
    "gating sentence of the first form|or of the second when|one of the two forms" \
    using-batches following-the-rules writing-a-user-story

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
    using-batches following-the-rules writing-a-batch

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
    writing-a-user-story closing-a-batch

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

# The end of a review is one norm with five ends. `shared` and not five `require`
# calls: separate assertions would each stay green while one skill drifted away
# from the wording the others use, and a skill that says "the agent may merge
# once approved" would contradict the spec with its own test passing.
shared "every review-ending skill forbids the agent approving or merging" \
    "never approves and never merges a pull request" \
    following-the-rules adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

shared "every review-ending skill pushes corrections as fixup! commits" \
    "pushed as a \`fixup!\` commit" \
    following-the-rules adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

# All five: every review merge is a clear moment, closing included — nothing
# follows a closing, so what comes next is unrelated work that the closed batch's
# context would only pollute. What sets closing apart is that it has no next step
# to name and so hands over no prompt, which is a different claim and is guarded
# per-skill in test-skill-content.sh. Keeping that distinction out of this
# assertion is deliberate: this one asks whether the five skills say the same
# thing in the same words, and they do.
shared "every review-ending skill names the merge a clear moment" \
    "is a moment to clear the context" \
    following-the-rules adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

# The next step is named, and its prompt given, when the human announces the
# merge, not when the agent announces the pull request ready: given then, the
# review that follows buries it. One assertion over the review-ending
# skills, and the former timing hunted in all of them.
shared "every review-ending skill acts on the merge announcement" \
    "your human partner announces the merge" \
    following-the-rules adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

absent_everywhere "no skill hands over the next step at the ready announcement" \
    "[Tt]he announcement (says so|names|therefore names)|announcing it ready is where|an announcement that names|when it announces the pull request ready"

# The observation period was two stories "enable, then remove" before the
# declared default and the effective state were told apart. Enabling is the
# project's gesture and changes no spec; the first story moves the declared
# default. The positive needles on the new sentence would stay green beside a
# restored old one, so the old phrasing is what has to be absent.
absent "the observation period is not described as enable-then-remove" \
    "split it into two stories" \
    writing-a-user-story

# Adoption never sharing the design's context is one coupling with two ends:
# `writing-a-batch` states it as the reason its Preconditions stop, and
# `using-batches` repeats it in Override 1. One assertion over both files —
# two separate `require` calls would each stay green while one end drifted
# away from the other's wording.
shared "adoption never shares the design's context" \
    "never conducted in the same context" \
    writing-a-batch using-batches

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
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch recording-a-decision

# One home per rule: `writing-in-a-spec` states that a rule belongs to exactly
# one spec, and the skills that invoke it keep only what their own step does
# when a rule reaches past one module.
require writing-in-a-spec "a rule belongs to exactly one spec, stated where it lives" \
    "**A rule belongs to exactly one spec.** A rule that would constrain behaviour observable at the boundary of more than one module is not a rule looking for a home"

# Each skill that invokes it names the rule where its own step stops on it.
for s in adopting-a-module writing-a-batch writing-a-user-story; do
    require "$s" "names the rule its step stops on" "**A rule belongs to exactly one spec.**"
done

# The batch document's immutability has a bound, and the bound is this closure
# (spec section `Batch`). `writing-a-batch` states the rule and names closing as
# the exception; `closing-a-batch` is the end that performs it — it amends the
# document and flips its front matter. One assertion over both files: two
# `require` calls would each stay green while one end reworded the bound away
# from the other, which is the whole failure this locks out.
shared "the batch document's immutability is bounded at closing, spelled alike" \
    "nothing in the normal course of the batch modifies it **until closing**" \
    writing-a-batch closing-a-batch

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
    writing-a-user-story following-the-rules

# What that first commit carries besides the removal, so the branch holds a document
# from its first commit and the plan has somewhere to be written at Step 4.
shared "that first commit carries the story document's header" \
    "the header of the story document and its empty \`Rulings log\` and \`Observed drift\` sections" \
    writing-a-user-story following-the-rules

# The removal is not obligatory: a technical story removes nothing, so that first
# commit carries the header alone. Both skills enumerate the removals, and an
# enumeration nothing marks as illustrative reads as the list of cases allowed —
# which would send a technical story looking for something to strike.
shared "the removal is not obligatory" \
    "removes, if it removes anything" \
    writing-a-user-story following-the-rules

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
for s in writing-a-batch writing-a-user-story; do
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
require writing-a-batch "invokes applying-a-spec-delta with the batch document and the blocks" \
    "nvoke \`supercharlouze:applying-a-spec-delta\` and give it the"
# How they are built is spelled there and nowhere else. Walks the declared
# skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates how the applied copies are built" \
    "outside the repository|scratch directory|checks every block|fails this check does not apply|the text the block ordered before it leaves|[Bb]uild (a|that|the) cop(y|ies)|cop(y|ies) built|coherence reread built|Coherence Reread\` builds it" \
    $(declared_skills | grep -vx applying-a-spec-delta)

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
    following-the-rules writing-a-user-story

# The mirror. The positive assertion above stays green on a file that carries both
# the negation and the old unconditional claim, and it is the old one an agent would
# obey — it is the shorter and the more emphatic of the two.
absent_everywhere "no skill pairs spec change and code unconditionally" \
    "ship together or not at all|\*both\* the spec change|the spec change and the code together"

# The freeze is copied verbatim into the Global Constraints of every plan, so the
# skill that states the norm and the skill that copies it must spell it identically.
# Two separate assertions would each stay green while the copied wording drifted
# from the stated one, and the implementers only ever read the copy.
shared "the freeze is spelled alike wherever it is stated" \
    "Between the first commit of the branch and the opening of the pull request, no task modifies the spec file" \
    following-the-rules writing-a-user-story

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
    following-the-rules writing-a-user-story

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
    writing-a-batch

# A reread says in which context it runs. "Fresh eyes" names no context an agent
# can reach.
absent_everywhere "no skill rereads with fresh eyes" \
    "fresh eyes"

# One skill rereads a spec, new or changed, and the skills that need a spec
# reread invoke it rather than carrying readers of their own.
shared "the skills that have a spec reread invoke the shared reread" \
    "invoke \`supercharlouze:rereading-a-spec\`" \
    adopting-a-module writing-a-batch
absent "no calling skill carries readings of its own" \
    "Does this specification hold what a specification must hold|precise and concise\\?|Where does this sit in the model|Every reader returns before anything goes up|stop the rounds" \
    adopting-a-module writing-a-batch
# The dependency runs one way: the reread knows none of the skills that invoke
# it, and says nothing a calling skill would have to keep in step with. What a
# reader gets is its own business.
absent "the reread names no skill that invokes it" \
    "supercharlouze:([^r]|r[^u]|ru[^n])|adopting-a-module|writing-a-batch|calling skill" \
    rereading-a-spec
absent "no calling skill says what a reader gets" \
    "as a new spec|as a changed spec|never the blocks|the spec as \`main\` carries it" \
    adopting-a-module writing-a-batch

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
    writing-a-batch

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
    using-batches following-the-rules writing-a-batch

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

# A corrective story is abandoned once the requalification is ruled: no skill has
# its pull request closed at the stop.
absent "no skill closes a corrective story's pull request at the stop" \
    "Therefore: \*\*close the story's pull request|So: \*\*close the story's pull request|Abandon the story, closing its pull request|exactly as a requalified corrective story is abandoned" \
    using-batches following-the-rules writing-a-batch writing-a-user-story recording-a-decision

# using-batches routes a requalification to writing-a-batch: it neither opens on
# what the requalification does not do nor copies its procedure.
absent "using-batches copies no requalification procedure" \
    "does not start by closing a pull request|abandon the story|close its pull request|no longer takes on are released|a fresh \`NN\`|settled elsewhere" \
    using-batches following-the-rules

# A requalified technical story brings the flag its block requires, if any, not a
# flag by default.
absent_everywhere "no skill makes a lost technical exemption declare a flag" \
    "declares one by that same amendment|a flag if the batch was exempted because all of its stories were technical"

# The mirror: a story states a flag only when its batch declares one for the
# story's module. The former unconditional sentence must not survive.
absent "no story states a flag its module does not carry" \
    "If the batch declares a feature flag, the transcribed" \
    writing-a-user-story

# The mirror: the divergence rule says what to do, and no longer lists causes.
absent "no story skill lists the causes of a divergence" \
    "legitimate cause" \
    writing-a-user-story

# The rules for code under a flag were rewritten. The former wording must survive
# nowhere: the positive needles would stay green beside it.
absent "no skill keeps the former guarded-code rules" \
    "Whatever way the project switches its flags|Switching off stays possible at all times|It holds four rules|coexisting on the same data|switching off is always possible|save for the data produced with the flag on" \
    using-batches following-the-rules writing-a-user-story

# The spec no longer fixes the form of the gating sentence; a skill does.
absent_everywhere "no skill says the spec fixes the gating sentence's form" \
    "form the spec fixes|form fixed by the spec"

# Each flag is independent of the others. The skills that declare a flag per
# (batch, module) say it in the same words.
shared "each flag is independent of the others" \
    "Each flag is switched on, switched off and lifted independently of the others: one flag's lifting story waits for no other flag's." \
    following-the-rules writing-a-batch

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
    writing-a-user-story

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
    writing-a-batch using-batches following-the-rules writing-a-user-story closing-a-batch recording-a-decision

# A constraint is judged against the technical design, known at opening, never
# against the stories, which do not exist yet.
absent "no constraint is judged against the stories" \
    "without breaking another" \
    writing-a-batch using-batches following-the-rules writing-a-user-story closing-a-batch recording-a-decision

# A story writes its departures from the design in the form the batch document
# spells.
shared "the batch and the story spell a technical design ruling alike" \
    "\`Technical design ruling:\`" \
    writing-a-batch writing-a-user-story

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
    "supercharlouze:([^r]|r[^u]|ru[^n])|using-batches|adopting-a-module|writing-a-batch|writing-a-user-story|closing-a-batch|rereading-a-spec|recording-a-decision|calling skill" \
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
    writing-a-batch

# The opening invokes the technical reread for every batch, and the reread says
# itself when it has nothing to reread: the former skip must survive nowhere, or
# a batch with no design would open with its ADRs unread.
absent "the opening no longer skips the technical reread" \
    "skipped when the batch has neither|both read \`none\` skips this step" \
    writing-a-batch

# The opening now places more than two rereads; the former count must not survive.
absent "the opening counts no rereads" \
    "[Tt]wo rereads|[Tt]hree rereads" \
    writing-a-batch

# The flow's stop conditions are named, never counted: a count goes false in
# every skill the day a condition is added, as it did when the constraint
# condition joined the corrective and the technical ones.
absent "no skill counts the stop conditions the flow adds" \
    "adds (two|three|four)( stop)? conditions|adds (two|three|four)[.,]|(both|either|neither) (stop )?conditions?" \
    using-batches following-the-rules writing-a-user-story writing-a-batch recording-a-decision

# The rules of a bounded change are listed, never counted: a count goes false
# the day a rule is added, as it did when the ADR rule joined them.
absent "no skill counts the rules of a bounded change" \
    "with (four|five|six|seven) rules|the (four|five|six|seven) rules" \
    using-batches following-the-rules

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
    "writing-a-batch|writing-a-user-story|adopting-a-module|calling skill" \
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

# The rules for code under a flag are written in full in the foundation, and
# `writing-a-user-story` has them copied into a story's Global Constraints. A
# copy that adds or drops a rule is no longer what the foundation states. One
# assertion over both ends.
shared "the rules for code under a flag are copied exactly as stated" \
    "Code guarded by a feature flag holds up when the flag is on for some users only, on for everyone, and off: - The two states work on the same data: what one produces, the other reads and uses, with no error and no data loss. - With the flag off, the user finds the behaviour from before the batch. - The story's pull request tests the flag-on behaviour, the flag-off behaviour, and their coexistence. - Lifting the flag comes down to deleting the branching and the behaviour from before the batch, without writing anything new." \
    following-the-rules writing-a-user-story

# The story skill says where each text it has copied is stated.
require writing-a-user-story "copies the rules for code under a flag as the foundation states them" \
    "Copy the block below verbatim, exactly as \`supercharlouze:following-the-rules\` states it"
require writing-a-user-story "takes the form of the gating sentence from the foundation" \
    "in the form \`supercharlouze:following-the-rules\` fixes"
absent "the story skill no longer claims to be where the rules for code under a flag are written" \
    "the only place those rules are written out" \
    writing-a-user-story

# No copied text is said to be stated by using-batches any more.
absent "no copied text is attributed to using-batches" \
    "exactly as \`supercharlouze:using-batches\` states it|those \`supercharlouze:using-batches\` states" \
    writing-a-user-story

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

# The obligation to report a decision that meets the conditions of an ADR is
# stated in the foundation and copied into a story's Global Constraints.
shared "the open ruling obligation is copied exactly as stated" \
    "it is recorded as an \`Open ruling:\`, which asks your human partner whether they want it as an ADR. Write nothing in \`docs/adr/\`." \
    following-the-rules writing-a-user-story

exit $((FAILURES > 0))
