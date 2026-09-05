---
description: Set up or migrate this project to the supercharlouze specs-and-plans layout
argument-hint: "[project path — defaults to the current directory]"
---

Set up this project for supercharlouze. Target: $ARGUMENTS — if empty, the
current directory.

Everything in this system ships through a pull request, and this command is no
exception (spec section 9).

1. From the main checkout, on an up-to-date `main`, create the branch
   `chore/supercharlouze-init`.
2. Run `bash ${CLAUDE_PLUGIN_ROOT}/scripts/init.sh <target>`. It is idempotent:
   it creates `docs/specs/`, `docs/batches/` and `docs/archive/`, moves any
   `docs/superpowers/specs` and `docs/superpowers/plans` under `docs/archive/`,
   and installs or refreshes the CLAUDE.md block. Running it twice changes
   nothing the second time. If it refuses because the CLAUDE.md markers are
   unbalanced, stop and tell your human partner — do not repair the file
   yourself.
3. Commit, push, and open the pull request.
4. Report the script's output as a state of play: which modules are adopted, and
   which archived documents no spec claims as a source.

**Do not adopt anything.** Adoption is a deliberate, per-module decision made by
your human partner, and it runs through `supercharlouze:adopting-a-module`.

**Do not propose a module breakdown.** Module boundaries belong to your human
partner, and a suggestion reads as a decision.

Then read `supercharlouze:using-batches` so the rest of the session follows the
overridden workflow.
