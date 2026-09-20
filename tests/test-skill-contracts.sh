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
body_flat() {
    awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$1" | tr '\n' ' ' | tr -s ' '
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
# restores the conventional name. The loose reading leaves a branch that is
# invisible to both scans, holding neither its number nor its sections.
shared "every branch-creating skill restores the conventional name" \
    "restore the conventional name before going on" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

shared "and each says a named branch is not enough" \
    "named branch is not enough" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

# The content rule lives in one place, `using-batches`. A skill that writes into a
# spec file names it and reuses its question verbatim rather than restating it —
# a second formulation of the same rule is exactly what drifts. One assertion over
# the four files: separate ones would all stay green while one end reworded.
# `adopting-a-module` is in the list because it does not merely write into a spec,
# it creates one: every sentence of a spec's first version passes through it.
shared "whoever writes into a spec spells the other-implementation test identically" \
    "read this sentence as true of their code" \
    using-batches writing-a-user-story closing-a-batch adopting-a-module

# The corrective batch's stop condition is copied "in full" into a story's
# Global Constraints. `using-batches` states it and `writing-a-user-story` has it
# copied; a copy that adds or drops a sentence is no longer the condition the
# spec names. One assertion over both ends.
shared "the corrective stop condition is copied exactly as stated" \
    "you discover that it is the **spec** that is wrong and the code that is right, stop. The batch is no longer corrective and must be requalified." \
    using-batches writing-a-user-story

# The gating sentence has one form, fixed by the spec's template. `using-batches`
# names it and `writing-a-user-story` shows it. Two spellings of the same sentence
# is how a live flag stops being found. One assertion over the two skills that
# write it out.
shared "the gating sentence is spelled in the spec's one form" \
    "🔒 \`billing.recurring\`, off by default" \
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

# Duty 6 reads the `Blocks:` declarations, not the specs: a block fitted to a
# `main` that moved since the batch opened is delivered even though its text no
# longer matches the delta word for word, and diffing the specs against that
# delta would wrongly report it missing. A positive assertion cannot lock this
# out — the Red Flags table and the duty 6 precondition can both carry the new
# wording while an old cell or clause still points a reader at the specs, and a
# `require` on the new text would stay green regardless. The regex targets the
# two forms that phrase found: "check the specs on main" and "against what
# actually shipped". It must not match duty 6's own contrast in closing-a-batch —
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

# A corrective story's first commit is described in two places — the skill that
# prescribes it and the one that explains why it is the single exception of form
# to "the spec change ships first". One assertion over both: two `require` calls
# would each stay green while one end drifted back to striking the entry.
shared "a corrective story's first commit deletes its entry" \
    "deletes the gaps register entry it resolves" \
    writing-a-user-story using-batches

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

# The open ruling is named in the skill whose step 6 copies the rulings and in
# the routing skill that states the same duty in one clause, and in the skill
# that refuses to close on one. Three couplings, three assertions over every
# end: what an open ruling is, what the copy owes it, and what refuses to
# close without it. `require` calls per skill would each stay green while one
# end reworded, and an agent reading that end would recognise a different set
# of rulings, or none.
shared "the open ruling is defined alike wherever it is named" \
    "whose decision was to park a finding or to hand it to your human partner" \
    writing-a-user-story using-batches closing-a-batch

shared "the copy names what is left to settle" \
    "the copy names what is left to settle" \
    writing-a-user-story using-batches

shared "both ends name closing as what reads it" \
    "refuses to close a batch while an open ruling has no destination" \
    writing-a-user-story using-batches

exit $((FAILURES > 0))
