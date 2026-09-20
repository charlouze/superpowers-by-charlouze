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

# Duty 5 reads the `Blocks:` declarations, not the specs: a block fitted to a
# `main` that moved since the batch opened is delivered even though its text no
# longer matches the delta word for word, and diffing the specs against that
# delta would wrongly report it missing. A positive assertion cannot lock this
# out — the Red Flags table and the duty 5 precondition can both carry the new
# wording while an old cell or clause still points a reader at the specs, and a
# `require` on the new text would stay green regardless. The regex targets the
# two forms that phrase found: "check the specs on main" and "against what
# actually shipped". It must not match duty 5's own contrast at line 91 —
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

exit $((FAILURES > 0))
