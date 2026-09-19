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

exit $((FAILURES > 0))
