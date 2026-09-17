#!/usr/bin/env bash
# No -e: this file runs its siblings, and a sibling that fails must be counted,
# not abort the run.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SELF="$(basename "$0")"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-suite-integrity"

# The suite guards the plugin; this file guards the suite. Both assertions below
# catch the same failure from opposite ends: a check nobody runs and a check that
# asserts nothing are each indistinguishable from a check that does not exist,
# while still filling the directory as though they were coverage.

# --- 1: nothing hides from the runner ---
# run-all.sh collects `tests/test-*.sh` by glob. A check file under any other
# name is never executed, and nothing reports it — it simply sits there looking
# like part of the suite.
STRAYS=""
for f in "$SCRIPT_DIR"/*.sh; do
    b="$(basename "$f")"
    [ "$b" = "run-all.sh" ] && continue
    case "$b" in
        test-*.sh) ;;
        *)         STRAYS="$STRAYS $b" ;;
    esac
done
if [ -z "$STRAYS" ]; then
    pass "every check file is named so the runner picks it up"
else
    fail "every check file is named so the runner picks it up (missed:$STRAYS)"
fi

# --- 2: no file passes without asserting anything ---
# A file whose body is gutted, or whose assertions sit behind a condition that
# never fires, exits 0 and reads as green. Counting what each file emits is what
# separates a silent file from a satisfied one. Both verdicts count: a file whose
# assertions all fail is still asserting something, and run-all reports it.
SILENT=""
for f in "$SCRIPT_DIR"/test-*.sh; do
    b="$(basename "$f")"
    [ "$b" = "$SELF" ] && continue
    n="$(bash "$f" 2>&1 | grep -c '\[PASS\]\|\[FAIL\]')"
    [ "$n" -gt 0 ] || SILENT="$SILENT $b"
done
if [ -z "$SILENT" ]; then
    pass "every check file emits at least one assertion"
else
    fail "every check file emits at least one assertion (silent:$SILENT)"
fi

exit $((FAILURES > 0))
