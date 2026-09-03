#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FAILED=0

for t in "$SCRIPT_DIR"/test-*.sh; do
    [ -f "$t" ] || continue
    if ! bash "$t"; then
        FAILED=$((FAILED + 1))
    fi
done

if [ "$FAILED" -gt 0 ]; then
    echo "$FAILED test file(s) failed"
    exit 1
fi

echo "all tests passed"
