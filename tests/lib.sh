# Sourced by the check files, never run: what they share.
# A caller may set SKILLS_DIR and SKILLS_FILE before sourcing, which is how
# test-lib.sh points these helpers at a fixture.

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$LIB_DIR/.." && pwd)"
SKILLS_DIR="${SKILLS_DIR:-$REPO_ROOT/skills}"
SKILLS_FILE="${SKILLS_FILE:-$LIB_DIR/skills.txt}"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

# --- the declared skills ---

# The names of the declared skills, one per line: all of them, or those of the
# type given.
declared_skills() {
    tr -d '\r' < "$SKILLS_FILE" \
        | awk -v type="${1:-}" '/^#/ || NF == 0 { next } type == "" || $2 == type { print $1 }'
}

# The type a skill is declared with.
skill_type() {
    tr -d '\r' < "$SKILLS_FILE" | awk -v name="$1" '!/^#/ && $1 == name { print $2; exit }'
}

# The lines of the declaration that declare nothing usable: a line that is not
# a name and a type, a type that is none of the three, a name declared twice.
invalid_declarations() {
    tr -d '\r' < "$SKILLS_FILE" | awk '
        /^#/ || NF == 0 { next }
        NF != 2 || $2 !~ /^(entry|internal|foundation)$/ || seen[$1]++ { print }'
}

# The front matter of a declared skill, without its fences.
skill_front() {
    awk 'NR>1 && /^---$/{exit} NR>1{print}' "$SKILLS_DIR/$1/SKILL.md" 2>/dev/null || true
}

# --- the form of an internal skill ---

# What breaks the form of an internal skill, one finding per line. A skill
# declared internal is hidden from the slash menu, its description asks for an
# explicit call, and it stays invocable by the skills: `disable-model-invocation`
# would stop the calling skills from invoking it too. No other skill carries
# that description.
internal_form_offenders() {
    local s front desc
    for s in $(declared_skills); do
        front="$(skill_front "$s")"
        desc="$(printf '%s\n' "$front" | sed -n 's/^description:[[:space:]]*//p' | head -1)"
        if [ "$(skill_type "$s")" = "internal" ]; then
            if ! printf '%s\n' "$front" | grep -qx 'user-invocable: false'; then
                echo "$s is not hidden from the slash menu"
            fi
            case "$desc" in
                "Use only when a skill tells you to invoke $s, never on "*) ;;
                *) echo "$s does not ask for an explicit call" ;;
            esac
            case "$front" in
                *"disable-model-invocation"*) echo "$s is not invocable by the skills" ;;
            esac
        else
            case "$desc" in
                *"Use only when a skill tells you to invoke"*)
                    echo "$s carries the description of an internal skill" ;;
            esac
        fi
    done
}

# --- the reading tool ---

# A file flattened, so a phrase matches regardless of wrapping. A SKILL.md is
# read after the closing --- of its front matter. A file of `references/` has no
# front matter and is read whole, the --- lines it carries included. Block quote
# markers are dropped from both.
# `tr -s ' '` squeezes runs of spaces to one, so a needle stays matchable when the
# prose it targets is re-wrapped: without it, a wrapped line whose continuation is
# indented flattens to several spaces where the needle has one, and the guard turns
# red on text that is correct. No needle in this suite contains two consecutive
# spaces, so squeezing changes nothing else.
# The `sed` drops a leading blockquote marker for the same reason: a norm written
# as a block quote would otherwise flatten with a stray `>` at every line break,
# and a needle spanning two of its lines could never match. No needle in this
# suite contains `>`.
body_flat() {
    case "$1" in
        */references/*) cat "$1" ;;
        *)              awk 'f{print} /^---$/{c++; if(c==2) f=1}' "$1" ;;
    esac | sed 's/^>[[:space:]]\{0,1\}//' | tr '\n' ' ' | tr -s ' '
}

# What a content guard reads of a skill: its body, then each file of its
# `references/`. Empty when the skill does not exist.
# Read once per skill and kept: flattening forks, and a guard over every skill
# would flatten each of them again. `skill_text` leaves the text in SKILL_TEXT
# rather than printing it, since a command substitution would lose what it kept.
# The text is kept for the life of the shell: a skill rewritten after its first
# read is read as it was.
skill_text() {
    local var="SKILL_TEXT_${1//[^A-Za-z0-9]/_}" d="$SKILLS_DIR/$1" r
    if [ -z "${!var+x}" ]; then
        SKILL_TEXT=""
        if [ -f "$d/SKILL.md" ]; then
            SKILL_TEXT="$(body_flat "$d/SKILL.md"
                for r in "$d"/references/*; do
                    if [ -f "$r" ]; then body_flat "$r"; fi
                done)"
        fi
        printf -v "$var" '%s' "$SKILL_TEXT"
    fi
    SKILL_TEXT="${!var}"
}

# --- the content guards ---

# A skill states a phrase.
require() {
    local skill="$1" label="$2" needle="$3"
    skill_text "$skill"
    case "$SKILL_TEXT" in
        *"$needle"*) pass "$skill: $label" ;;
        *)           fail "$skill: $label" ;;
    esac
}

# A coupling between two skills only holds if both ends spell it identically.
# One assertion over several skills, never one per skill: two separate assertions
# would both stay green while one end drifted away from the other.
shared() {
    local label="$1" needle="$2"
    shift 2
    local missing="" s
    for s in "$@"; do
        skill_text "$s"
        case "$SKILL_TEXT" in
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
# assertions would stay green on a skill that carried both the new phrasing and
# the old, contradicting one.
#
# Matches an extended regular expression, not a literal substring: the claim
# hunted may be a denial ("nothing depends on the branch name") while the
# doctrine is written in the same words, affirmatively ("Number allocation
# depends on the branch name"). A literal match cannot tell the two apart and
# would turn red on the true sentence, inviting the writer to delete it.
#
# Fails explicitly, naming the skill, when a listed skill does not exist: an
# empty body never matches, and a silent pass there would mean the assertion
# inspected nothing.
absent() {
    local label="$1" needle="$2"
    shift 2
    local found="" s
    for s in "$@"; do
        if [ ! -f "$SKILLS_DIR/$s/SKILL.md" ]; then
            fail "$label (no such skill: $s)"
            return
        fi
        skill_text "$s"
        if grep -Eq "$needle" <<<"$SKILL_TEXT"; then
            found="$found $s"
        fi
    done
    if [ -z "$found" ]; then
        pass "$label"
    else
        fail "$label (present in:$found)"
    fi
}

# `absent` over every declared skill. A negative guard that holds for all the
# skills uses it, so a skill declared later is covered without touching the
# guard.
absent_everywhere() {
    local label="$1" needle="$2"
    # shellcheck disable=SC2046
    absent "$label" "$needle" $(declared_skills)
}
