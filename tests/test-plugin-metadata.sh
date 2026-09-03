#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-plugin-metadata"

PLUGIN_JSON="$REPO_ROOT/.claude-plugin/plugin.json"
MARKET_JSON="$REPO_ROOT/.claude-plugin/marketplace.json"

for f in "$PLUGIN_JSON" "$MARKET_JSON"; do
    if [ -f "$f" ]; then
        pass "$(basename "$f") exists"
    else
        fail "$(basename "$f") exists"
    fi
done

# Read a field with node. The path goes through argv, never interpolated into
# the -e program: Git Bash hands node a /c/Users/... path, and node on Windows
# would resolve it as C:\c\Users\... and fail with ENOENT.
read_field() {
    node -e '
        const fs = require("fs");
        const o = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
        const path = process.argv[2].split(".");
        let v = o;
        for (const k of path) { v = v === undefined ? v : v[/^\d+$/.test(k) ? Number(k) : k]; }
        process.stdout.write(v === undefined ? "" : String(v));
    ' "$1" "$2" 2>/dev/null || true
}

for f in "$PLUGIN_JSON" "$MARKET_JSON"; do
    if [ -f "$f" ] && node -e 'JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"))' "$f" 2>/dev/null; then
        pass "$(basename "$f") is valid JSON"
    else
        fail "$(basename "$f") is valid JSON"
    fi
done

NAME="$(read_field "$PLUGIN_JSON" "name")"
if [ "$NAME" = "supercharlouze" ]; then
    pass "plugin name is supercharlouze"
else
    fail "plugin name is supercharlouze (got '$NAME')"
fi

PV="$(read_field "$PLUGIN_JSON" "version")"
MV="$(read_field "$MARKET_JSON" "plugins.0.version")"
if [ -n "$PV" ] && [ "$PV" = "$MV" ]; then
    pass "versions agree ($PV)"
else
    fail "versions agree (plugin '$PV', marketplace '$MV')"
fi

MN="$(read_field "$MARKET_JSON" "plugins.0.name")"
if [ "$MN" = "supercharlouze" ]; then
    pass "marketplace entry names the plugin"
else
    fail "marketplace entry names the plugin (got '$MN')"
fi

exit $((FAILURES > 0))
