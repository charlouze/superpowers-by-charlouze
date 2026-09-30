#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-skill-contracts"

# Body only: everything after the closing --- of the frontmatter, flattened so a
# phrase matches regardless of wrapping.
# `tr -s ' '` squeezes runs of spaces to one, so a needle stays matchable when the
# prose it targets is re-wrapped: without it, a wrapped line whose continuation is
# indented flattens to several spaces where the needle has one, and the guard turns
# red on text that is correct. No needle in this suite contains two consecutive
# spaces, so squeezing changes nothing else.
# The `sed` drops a leading blockquote marker, so a norm written as a block quote
# flattens like any other prose and a needle may span two of its lines. Kept
# identical to the helper in test-skill-content.sh: two flatteners of the same
# name behaving differently is a trap for whoever writes the next needle.
body_flat() {
    awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$1" \
        | sed 's/^>[[:space:]]\{0,1\}//' | tr '\n' ' ' | tr -s ' '
}

# A coupling between two skills only holds if both ends spell it identically.
# One assertion over several files, never one per file: two separate assertions
# would both stay green while one end drifted away from the other.
shared() {
    local label="$1" needle="$2"
    shift 2
    local missing=""
    local s f b
    for s in "$@"; do
        f="$REPO_ROOT/skills/$s/SKILL.md"
        b=""
        [ -f "$f" ] && b="$(body_flat "$f")"
        case "$b" in
            *"$needle"*) ;;
            *) missing="$missing $s" ;;
        esac
    done
    if [ -z "$missing" ]; then
        pass "$label"
    else
        fail "$label (missing in:$missing)"
    fi
}

# The mirror of `shared`: a claim that must survive nowhere. Used for a sentence
# a spec change removed, which is otherwise guarded by nothing — the positive
# assertions would stay green on a file that carried both the new phrasing and
# the old, contradicting one.
#
# Matches an extended regular expression against the flattened body, not a
# literal substring: the claim this test hunts is a denial ("nothing depends
# on the branch name"), and the doctrine this branch establishes is written in
# the same words, affirmatively ("Number allocation depends on the branch
# name"). A literal match cannot tell the two apart and would turn red on the
# true sentence, inviting the writer to delete it.
#
# Fails explicitly, naming the file, when a listed skill does not exist: an
# empty body from a missing file never matches, and a silent pass there would
# mean the assertion inspected nothing.
absent() {
    local label="$1" needle="$2"
    shift 2
    local found=""
    local s f b
    for s in "$@"; do
        f="$REPO_ROOT/skills/$s/SKILL.md"
        if [ ! -f "$f" ]; then
            fail "$label (no such skill: $s)"
            return
        fi
        b="$(body_flat "$f")"
        if echo "$b" | grep -Eq "$needle"; then
            found="$found $s"
        fi
    done
    if [ -z "$found" ]; then
        pass "$label"
    else
        fail "$label (present in:$found)"
    fi
}

# The specs are the registry of flags: a batch that lifts a flag declared by
# another says so in its spec delta, and nothing copies flags into the batch
# document. The former `Live flags` section and its rulings must survive nowhere,
# or a skill keeps asking for a section no batch document carries any more.
absent "no skill keeps a Live flags section or its rulings" \
    "Live flags|carried by this batch|inherited by a ruling" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module


# Number allocation and the concurrency scan both recognise a branch by its
# name, and both on exactly the window where no pull request exists yet. So a
# skill that creates a branch owes more than "some named branch exists": it
# restores the conventional name, and the starting point the flow requires. The
# loose reading leaves a branch that is invisible to both scans, holding neither
# its number nor its sections — or one that is visible and built on the wrong
# base.
shared "every branch-creating skill restores the name and the starting point" \
    "restore the conventional name and the starting point before going on" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

shared "and each says a named branch is not enough" \
    "named branch is not enough" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

# The concurrency scan's filter is the branch name, and both ends must spell it
# the same: the one that scans (`writing-a-user-story`) and the one that states
# the rule (`using-batches`). One assertion over both files — two separate ones
# would each stay green while one end reworded away from the other.
shared "the concurrency filter is the branch name on both ends" \
    "filter is the branch name" \
    using-batches writing-a-user-story

# The former filter — keep only the pull requests and the branches whose diff
# touches the spec file — made invisible every story whose pull request touches
# no spec at all. It must survive nowhere, or the scan regains the blind spot
# this one closes.
absent "no skill filters the concurrency scan by the spec file a diff touches" \
    "touches this story's spec file|touches this spec file|touch this spec file|files include this story's spec file" \
    using-batches writing-a-user-story

# The branch name says who claims sections; the declaration says in which spec.
# A pushed branch that carries no declaration yet has only its diff to say so,
# and both ends must state it the same way: the one that scans and the one that
# states the rule.
shared "a branch with no declaration yet is read by what it changed" \
    "A pushed branch that carries no declaration yet is read by the sections it has already changed" \
    using-batches writing-a-user-story

# Pushed branches with no pull request are read under both patterns that claim
# sections. A scan of `story/*` alone misses a pushed bounded change.
shared "both claiming patterns are read before their pull request" \
    "every remote \`story/*\` or \`bounded/*\` branch that carries no pull request yet" \
    using-batches writing-a-user-story

# A branch that has not declared yet used to stop a story as soon as it had
# changed the story's spec file. The sections it changed now stand in for its
# declaration, so that stop must survive nowhere.
absent "a branch with no declaration yet is not an unknown" \
    "concerns the spec it has already changed|it is an unknown and stops you|stop on an unknown" \
    using-batches writing-a-user-story

# The content rule lives in one place, `using-batches`. A skill that writes into a
# spec file names it and reuses its question verbatim rather than restating it —
# a second formulation of the same rule is exactly what drifts. One assertion over
# the files: separate ones would all stay green while one end reworded.
# `adopting-a-module` is in the list because it does not merely write into a spec,
# it creates one: every sentence of a spec's first version passes through it.
# `closing-a-batch` is not: since it dropped the changelog line, it no longer
# writes into a spec file at all.
shared "whoever writes into a spec spells the other-implementation test identically" \
    "read this sentence as true of their code" \
    using-batches writing-a-user-story adopting-a-module

# The corrective batch's stop condition is copied "in full" into a story's
# Global Constraints. `using-batches` states it and `writing-a-user-story` has it
# copied; a copy that adds or drops a sentence is no longer the condition the
# spec names. One assertion over both ends.
shared "the corrective stop condition is copied exactly as stated" \
    "you discover that it is the **spec** that is wrong and the code that is right, stop. The batch is no longer corrective and must be requalified." \
    using-batches writing-a-user-story

# The technical story's stop condition travels the same way: `using-batches`
# states it and `writing-a-user-story` has it copied into a story's Global
# Constraints. Same argument as above — a copy that adds or drops a sentence is no
# longer the condition the spec names. One assertion over both ends.
shared "the technical stop condition is copied exactly as stated" \
    "If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical." \
    using-batches writing-a-user-story

# The concision rules are copied into every story's Global Constraints.
# `using-batches` states them and `writing-a-user-story` has them copied; a rule
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
        using-batches writing-a-user-story
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
    using-batches writing-a-batch

# `writing-a-user-story` fixes the forms of the gating sentence, and
# `using-batches` quotes the one without a lifting condition. Two spellings of
# the same sentence is how a live flag stops being found. One assertion over the
# skills that write it out.
shared "the gating sentence is spelled in its fixed form" \
    "🔒 \`billing.recurring\`, off by default" \
    using-batches writing-a-user-story

# The forms of the gating sentence are neither counted nor designated by their
# rank: the one with a lifting condition is recognised by that condition.
absent "no skill counts or ranks the forms of the gating sentence" \
    "gating sentence of the first form|or of the second when|one of the two forms" \
    using-batches writing-a-user-story

# A gap's *category* does not depend on where you stand; only its sources do. So
# the skills that gloss it to route say what a gap is and never where it comes
# from: naming a source there would teach `using-batches` a word — a validated
# document — that means nothing outside an adoption, and would have to be kept in
# step with every context that finds gaps some other way.
#
# Scoped to the gloss, not the file: `using-batches` names a validated document
# legitimately elsewhere, in the content rule, as one of the two places an
# intention may come from.
absent "no routing gloss names a source of gaps" \
    "Gaps\*?\*?[^.|]{0,160}validated document" \
    using-batches writing-a-batch

# `Branch naming` used to deny, in bold, that any mechanism of this system
# depends on a branch's name. Two sections of the same spec contradicted it, and
# the denial is gone. No skill may carry it either — but the guard has to catch
# the *denial*, not the words: "Number allocation depends on the branch name" is
# the true statement this branch exists to establish, and a literal match would
# turn red on it and invite the writer to delete it.
absent "no skill denies that the branch name matters" \
    "(nothing|Nothing|no mechanism|No mechanism)[^.]{0,40}depends on the (branch )?name" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch using-batches

# The spec delta is exact text, in blocks (spec section "The batch document"). A
# skill that still calls what a batch announced an "intention" contradicts it.
# The regex hunts the delta's former phrasings, and any sentence pairing
# "delta" or "announced" with "intention": the content rule's own
# "business rules and intentions", and "the same intention" in the
# other-implementation test, are true sentences and must stay green.
absent "no skill calls the spec delta an intention" \
    "stated as intention|as intention only|like any other intention|an intention like any other|intentions? (the (batch|delta) )?announced|announced intention|announced no intention|an intention not delivered|carries the intention|(delta|announc)[^.]{0,60}[Ii]ntention|[Ii]ntention[^.]{0,60}(delta|announc)" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

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
absent "no skill finds undelivered blocks by reading or diffing the specs" \
    "[Cc]heck the specs on main|against what (actually )?shipped" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# The end of a review is one norm with five ends. `shared` and not five `require`
# calls: separate assertions would each stay green while one skill drifted away
# from the wording the others use, and a skill that says "the agent may merge
# once approved" would contradict the spec with its own test passing.
shared "every review-ending skill forbids the agent approving or merging" \
    "never approves and never merges a pull request" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

shared "every review-ending skill pushes corrections as fixup! commits" \
    "pushed as a \`fixup!\` commit" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

# All five: every review merge is a clear moment, closing included — nothing
# follows a closing, so what comes next is unrelated work that the closed batch's
# context would only pollute. What sets closing apart is that it has no next step
# to name and so hands over no prompt, which is a different claim and is guarded
# per-skill in test-skill-content.sh. Keeping that distinction out of this
# assertion is deliberate: this one asks whether the five skills say the same
# thing in the same words, and they do.
shared "every review-ending skill names the merge a clear moment" \
    "is a moment to clear the context" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

# The next step is named, and its prompt given, when the human announces the
# merge, not when the agent announces the pull request ready: given then, the
# review that follows buries it. One assertion over the review-ending
# skills, and the former timing hunted in all of them.
shared "every review-ending skill acts on the merge announcement" \
    "your human partner announces the merge" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

absent "no skill hands over the next step at the ready announcement" \
    "[Tt]he announcement (says so|names|therefore names)|announcing it ready is where|an announcement that names|when it announces the pull request ready" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

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
absent "no skill carries the retired blocking-precondition wording" \
    "blocking precondition|Adoption is blocking|blocking; nothing starts" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# The directory-does-not-matter justification belongs to using-batches, which
# states the preconditions common to every pull request of this system. A
# path skill that restates it creates a second formulation of one rule, and a
# second formulation is what drifts.
absent "only using-batches justifies dropping the directory precondition" \
    "Where you are standing does not matter" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

# One home per rule: the norm is stated in the four skills that write normative
# text, and it is stated there word for word. One assertion, never one per file:
# four separate assertions would each stay green while one end drifts away from
# the other three.
shared "a rule belongs to exactly one spec" "A rule belongs to exactly one spec." \
    using-batches adopting-a-module writing-a-batch writing-a-user-story

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
absent "no skill denies that the batch document changes at closing" \
    "batch modifies it( [^*]|[^ ])" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# The first commit of a story that transcribes no block is described in two places —
# the skill that prescribes it and the one that explains why it is the exception of
# form to "the spec change ships first". One assertion over both: two `require`
# calls would each stay green while one end drifted back to striking the entry.
shared "a story with no block still deletes its entry that way" \
    "deletes the gaps register entry it resolves" \
    writing-a-user-story using-batches

# What that first commit carries besides the removal, so the branch holds a document
# from its first commit and the plan has somewhere to be written at Step 4.
shared "that first commit carries the story document's header" \
    "the header of the story document and its empty \`Rulings log\` and \`Observed drift\` sections" \
    writing-a-user-story using-batches

# The removal is not obligatory: a technical story removes nothing, so that first
# commit carries the header alone. Both skills enumerate the removals, and an
# enumeration nothing marks as illustrative reads as the list of cases allowed —
# which would send a technical story looking for something to strike.
shared "the removal is not obligatory" \
    "removes, if it removes anything" \
    writing-a-user-story using-batches

# The mirror: the case is no longer the corrective batch's alone, and a skill that
# still scopes it there sends any other blockless story looking for a rule that
# names a batch kind it does not belong to.
absent "no skill scopes the blockless first commit to a corrective story" \
    "\*\*Corrective story\.\*\*|A corrective story is the one exception" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# Removal leaves no trace in the register, so what a module already rejected is
# readable only in the file's history. Both writers that add an entry — a
# batch's closing and a bounded change — owe that read. One assertion over both,
# because a rule only one of them carries is a rule the other writer never sees.
shared "both writers read the file's history before adding" \
    "Read the file's history before adding an entry" \
    closing-a-batch using-batches

# The removal duty — say why in the commit, because the file keeps nothing once
# the entry is gone — is stated in four skills, and it is stated word for word.
# Three of them prescribe a removal; `closing-a-batch` states it while explaining
# why an entry a story resolved is not there to release, which is the one place a
# reader could otherwise conclude that closing removes entries too. One assertion
# over the four: four `require` calls would each stay green while one end reworded
# the duty away from the others.
shared "the removal duty is spelled alike wherever it is stated" \
    "the commit that removes it says why" \
    adopting-a-module writing-a-user-story closing-a-batch using-batches

# The same sentence about what an abandoned story leaves behind is written in
# two skills, and it names the gesture the register now uses. One assertion over
# both: separate ones would let the two accounts of an abandonment drift apart,
# and an agent reading either would believe it had the whole picture.
shared "both accounts of an abandonment name the same residue" \
    "the spec change, or the deleted gaps-register entry, travels with the code and dies with the branch" \
    writing-a-batch writing-a-user-story

# The mirror of the positive assertions above: a skill that carried both the new
# wording and the old would leave every one of them green while still telling an
# agent to strike a register entry. The needle is the bare token, because a
# pattern aimed at the register misses the one line that matters most — a table
# row naming the gesture, whose "entry" is the column header, out of reach of any
# sane window. A bare token has no holes as long as the word means nothing else
# in these five files, which is why the source inventory says "drop" instead.
absent "no skill strikes a gaps register entry" \
    "[Ss]truck|[Ss]trik" \
    adopting-a-module using-batches writing-a-batch writing-a-user-story closing-a-batch

# `addressable` justified an entry's shape and also read as "made to be pointed
# at" — the reading under which one entry designates another. The spec dropped
# it; the skill's twin sentence drops it the same way. The gesture's need
# survives in the sentence that follows, where it describes what a writer
# needs rather than a property of the entry, and that is the sentence asserted
# positively right after.
absent "no skill calls an entry addressable" \
    "[Aa]ddressable" \
    adopting-a-module using-batches writing-a-batch writing-a-user-story closing-a-batch

# The word leaves, the rule stays: without this assertion, deleting the whole
# sentence would pass green.
shared "the entry's shape is still stated without the word" \
    "one list item, never a paragraph of running prose" \
    adopting-a-module

# A register is reread entry by entry, and nothing keeps a prose that
# qualifies a group in step: it goes false without anyone having touched it.
# The three skills that *add* an entry say so — adoption writes all its gaps
# at once, closing consolidates several stories, the bounded change writes
# alone. One assertion over the three: three `require`s would stay green while
# one edge got reworded.
shared "every writer that adds an entry keeps a group's qualification out" \
    "What qualifies an entry lives in the entry" \
    adopting-a-module closing-a-batch using-batches

# A settled entry leaves the file and takes with it whatever pointed at it:
# the entry-to-entry cross-reference loses its target without anyone editing
# it. The same three writers say so, in the same words, under one assertion.
shared "every writer that adds an entry keeps entries from pointing at each other" \
    "An entry designates no other entry" \
    adopting-a-module closing-a-batch using-batches

# The pairing of a spec change with its code is stated by the negation, because a
# story may carry code alone — a corrective batch's story does today. Both skills
# that state it must spell it alike: the doctrine and the procedure drifting apart
# here is exactly how an agent ends up believing a story owes the spec a sentence.
shared "the pairing is stated by the negation" \
    "never carries its spec change without the code that implements it" \
    using-batches writing-a-user-story

# The mirror. The positive assertion above stays green on a file that carries both
# the negation and the old unconditional claim, and it is the old one an agent would
# obey — it is the shorter and the more emphatic of the two.
absent "no skill pairs spec change and code unconditionally" \
    "ship together or not at all|\*both\* the spec change|the spec change and the code together" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# The freeze is copied verbatim into the Global Constraints of every plan, so the
# skill that states the norm and the skill that copies it must spell it identically.
# Two separate assertions would each stay green while the copied wording drifted
# from the stated one, and the implementers only ever read the copy.
shared "the freeze is spelled alike wherever it is stated" \
    "Between the first commit of the branch and the opening of the pull request, no task modifies the spec file" \
    using-batches writing-a-user-story

# The mirror. A skill carrying both anchors would leave the positive assertion
# green while still handing implementers the old one. The needle is the bare term:
# no branch of this flow has a commit called that any more — the branch has a first
# commit, whose content is a transcription or something else depending on the story
# — so the term returning anywhere is the drift, not just the old freeze opening.
absent "no skill anchors the freeze on a transcription commit" \
    "transcription commit" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# What an abandonment leaves on `main` is not a fixed count: a story that
# transcribed no block announced no intention in the spec delta, so it leaves the
# reservation alone. A skill that counts hands closing a checklist of the wrong
# length, and closing is the only skill that picks these up.
absent "no skill counts what an abandonment leaves on main" \
    "Two residues|two residues|two things it never touched" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# Transcribing no block does not mean touching no spec: a teardown story removes
# from the spec what no block announced, and its first commit carries that removal.
# Both skills that describe the blockless first commit must name that case. The
# negation they state is already guarded; its justification was not, and the two
# ends drifted into claiming a blockless story never touches the spec.
shared "both skills name the blockless story that still changes the spec" \
    "teardown story removes from the spec what no block announced" \
    using-batches writing-a-user-story

# The unconditional claim the spec change removed: a bounded change used to be
# said never to leave the spec silent. The positive assertion above would stay
# green on a file carrying both phrasings, and the two contradict each other —
# one says the spec is always updated, the other says it depends.
absent "no skill says a bounded change never leaves the spec silent" \
       "never leaves the spec silent" \
       using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

# The old declaration named only the sections. Left standing beside the new one,
# it would tell a bounded change that naming its sections is enough — and a
# reader comparing sections against the wrong spec finds conflicts that are not
# there, or misses the one that is.
#
# The needle carries "therefore" on purpose. Step 1 of writing-a-user-story
# tells a *reader* where a bounded change keeps its declaration, in words that
# overlap this one; that sentence belongs to the concurrency detection rule and
# is not what this guard hunts. "therefore declares its sections" appears only
# where the duty is laid on the bounded change itself.
absent "no skill says a bounded change declares only its sections" \
       "therefore declares its sections" \
       using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

# Closing used to file every undelivered block as a gap on its own. The human
# now decides, block by block; a leftover of the old duty would file them all.
absent "no skill files an undelivered block as a gap on its own" \
    "Write the shortfall into the gaps register|inscribed in the gaps register as" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# A bounded change's branch is `bounded/<slug>`. A skill still naming the former
# pattern would scan, or create, a branch nobody else reads as a claim.
absent "no skill names the former bounded branch" \
    "\`fix/" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# A spec carries no date, no status and no work-in-progress marker, except the
# gating sentence of a flag. Both skills that describe a spec say it alike.
shared "a flag's gating sentence is the one marker a spec admits" \
    "no work-in-progress marker, except a flag's gating sentence" \
    using-batches adopting-a-module

absent "no skill denies a spec every marker" \
    "A spec carries none, ever" \
    using-batches adopting-a-module

# A batch no longer says why it happens now, and its reserved entries go under
# `Scope`, not under `Spec delta`. The positive assertions stay green beside a
# leftover of the old wording, so the old wording is hunted too.
absent "no skill asks a batch why it happens now" \
    "why now|happens now" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

absent "no skill files reserved entries under the spec delta" \
    "gaps register entries it reserves, or|gaps register entries this batch reserves|replacing the reserved gaps entries|delivery perimeter|required ordering of the user stories" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# A block shows its change in the paragraph that contains it. The former form,
# a quoted passage then its replacement, must survive nowhere.
absent "no skill has a block quote a passage" \
    "quoted passage|quotes the current passage|passage a block quotes|Quote the passage|the passage it removes" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# The coherence reread checks every block against `main` as it builds the applied
# copy. A block check left in the batch-document reread would run it twice.
absent "the batch-document reread leaves the blocks to the coherence reread" \
    "every block's paragraph|every block's unchanged and removed lines matching" \
    writing-a-batch

# A reread says in which context it runs. "Fresh eyes" names no context an agent
# can reach.
absent "no skill rereads with fresh eyes" \
    "fresh eyes" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module rereading-a-spec

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
    "supercharlouze:|adopting-a-module|writing-a-batch|calling skill" \
    rereading-a-spec
absent "no calling skill says what a reader gets" \
    "as a new spec|as a changed spec|never the blocks|the spec as \`main\` carries it" \
    adopting-a-module writing-a-batch

# An amendment changes the scope, the spec delta or the flag of an open batch.
# A leftover naming only scope and flag would send a spec delta change nowhere.
absent "no skill bounds an amendment to scope and flag" \
    "scope or (its |the |of )?flag" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# Everything that reaches `main` may ship to production. The flow presumes no
# more of the project: a skill still requiring continuous deployment asks more
# than the flow does.
absent "no skill requires continuous deployment" \
    "[Cc]ontinuous" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# Within a batch, one pull request adds to a gaps register: the closing one.
# Every skill on the batch path says so in the same words.
shared "only the closing pull request adds entries within a batch" \
    "Within a batch, only the closing pull request adds entries to the gaps register" \
    closing-a-batch using-batches writing-a-user-story

# A finding the register already let go comes back only with what changed.
# The writers that add an entry say so alike.
shared "a deleted finding is re-entered only with what changed" \
    "A finding already deleted from the register is re-entered only if the entry says what has changed since" \
    closing-a-batch using-batches

# The spec no longer carries the register's format; the writers that append
# to it keep it.
shared "the writers that append keep the entry format" \
    "An entry is one list item, added at the end of its category" \
    closing-a-batch using-batches

# The former wording left the batch's adding writer unnamed, and placed an
# entry at the end of a section.
absent "no skill leaves the batch's adding writer unnamed" \
    "one writer per batch|single writer per batch|at the end of a section" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# The gesture table of the adoption lists every writer, the closing that adds
# included.
shared "the adoption's gesture table names the closing that adds" \
    "| Add | \`supercharlouze:closing-a-batch\`, in the batch's closing pull request |" \
    adopting-a-module

# The batch-document reread is a step of its own, before the pull request opens.
absent "no skill folds the document reread into opening the pull request" \
    "Reread the batch document, then open the pull request|these six steps" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# The batch rules neither count their steps and choices nor designate one by its
# rank: the list carries the count, and a rank goes false when a step is added.
absent "the batch rules neither count nor rank their steps and choices" \
    "runs these [a-z]+ steps|Step 7 opens|step 3 releases|among three choices" \
    using-batches writing-a-batch

# The specs carry no changelog any more. No shipped skill file names one:
# frontmatter and references included, which `body_flat` would skip.
CHANGELOG_HITS="$(grep -rli 'changelog' "$REPO_ROOT/skills" || true)"
if [ -z "$CHANGELOG_HITS" ]; then
    pass "no skill file names a changelog"
else
    fail "no skill file names a changelog (present in: $(echo $CHANGELOG_HITS))"
fi

# Entries a batch no longer takes on are released, not merely revised, and an
# amendment releases them before closing does.
absent "no skill merely revises reservations" \
    "reservations are revised|Revise the gaps register reservations|a scope revised mid-flight|and \`supercharlouze:closing-a-batch\` releases it\.|No other skill picks them up|A fresh \`NN\` only if|out of the scope releases it" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

# A corrective story is abandoned once the requalification is ruled: no skill has
# its pull request closed at the stop.
absent "no skill closes a corrective story's pull request at the stop" \
    "Therefore: \*\*close the story's pull request|So: \*\*close the story's pull request|Abandon the story, closing its pull request|exactly as a requalified corrective story is abandoned" \
    using-batches writing-a-batch writing-a-user-story

# using-batches routes a requalification to writing-a-batch: it neither opens on
# what the requalification does not do nor copies its procedure.
absent "using-batches copies no requalification procedure" \
    "does not start by closing a pull request|abandon the story|close its pull request|no longer takes on are released|a fresh \`NN\`|settled elsewhere" \
    using-batches

# A requalified technical story brings the flag its block requires, if any, not a
# flag by default.
absent "no skill makes a lost technical exemption declare a flag" \
    "declares one by that same amendment|a flag if the batch was exempted because all of its stories were technical" \
    using-batches writing-a-batch writing-a-user-story closing-a-batch adopting-a-module

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
    using-batches writing-a-user-story

# The spec no longer fixes the form of the gating sentence; a skill does.
absent "no skill says the spec fixes the gating sentence's form" \
    "form the spec fixes|form fixed by the spec" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

# Each flag is independent of the others. The skills that declare a flag per
# (batch, module) say it in the same words.
shared "each flag is independent of the others" \
    "Each flag is switched on, switched off and lifted independently of the others: one flag's lifting story waits for no other flag's." \
    using-batches writing-a-batch

# A corrective batch's spec delta carries no block; the field itself is never
# left blank.
absent "no skill says a corrective batch's spec delta is empty" \
    "spec delta is empty" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

# Drift is code that contradicts the spec, or behaviour no spec describes. A
# divergence from a block is another matter and keeps its word.
absent "no skill calls a divergence between spec and code drift" \
    "divergence between (the )?spec" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch
absent "no skill narrows drift to a contradiction" \
    "contradiction between (the )?spec" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch
shared "drift covers code that contradicts the spec and behaviour no spec describes" \
    "any code on \`main\` that contradicts the spec on \`main\`, and any behaviour on \`main\` that no spec describes, is drift" \
    using-batches
shared "observed drift takes both kinds of drift" \
    "Record under **Observed drift** the drift you noticed *outside* this story's scope: code that contradicts the spec, and behaviour no spec describes." \
    writing-a-user-story

# The spec names what a ruling carries; the skills keep the form of its line.
shared "the skills keep the form of a ruling line" \
    "\`Ruling: <decision> — <why> — <what it costs if it is wrong>\`" \
    using-batches adopting-a-module

# The plugin's own language is a rule of the plugin's repository, not of the
# projects the skills work on.
absent "no skill states the plugin's own language" \
    "entirely English" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch rereading-a-spec

# A batch's constraints now include its shared technical decisions, so the old
# enumeration of what a batch carries must not survive beside the new one.
absent "a batch no longer lists only migration constraints" \
    "its flags, the order of its stories and of its blocks, and its migration" \
    using-batches

# Constraints now carry shared technical decisions as well, so the old bound —
# migration and compatibility, then the order — must not survive anywhere.
absent "Constraints are no longer bounded to migration and order" \
    "migration and compatibility constraints,? and the required order" \
    writing-a-batch using-batches writing-a-user-story closing-a-batch

# A constraint is judged against the technical design, known at opening, never
# against the stories, which do not exist yet.
absent "no constraint is judged against the stories" \
    "without breaking another" \
    writing-a-batch using-batches writing-a-user-story closing-a-batch

# A story writes its departures from the design in a form closing reads back,
# and the batch document spells the same form.
shared "the batch, the story and closing spell a technical design ruling alike" \
    "\`Technical design ruling:\`" \
    writing-a-batch writing-a-user-story closing-a-batch

exit $((FAILURES > 0))
