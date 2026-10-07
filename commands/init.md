---
description: Set up or migrate this project to the supercharlouze specs-and-plans layout
argument-hint: "[project path — defaults to the current directory]"
---

Set up this project for supercharlouze. Target: $ARGUMENTS — if empty, the
current directory.

Everything in this system ships through a pull request, and this command is no
exception — see `Installing on a project` in
`${CLAUDE_PLUGIN_ROOT}/docs/specs/supercharlouze.md`.

1. Fetch, then create the branch `chore/supercharlouze-init` from `main` as the
   remote carries it.
2. Run `bash ${CLAUDE_PLUGIN_ROOT}/scripts/init.sh <target>`. It is idempotent:
   it creates `docs/specs/`, `docs/batches/` and `docs/archive/`, moves any
   `docs/superpowers/specs` and `docs/superpowers/plans` under `docs/archive/`,
   installs or refreshes the CLAUDE.md block, and lists the adopted modules and
   the ADRs `docs/adr/` already carries. Running it twice changes nothing the
   second time. If it refuses because the CLAUDE.md markers are unbalanced, stop
   and tell your human partner, and do not repair the file yourself.
3. Before committing, put each ADR the script lists under `existing ADRs:` to
   your human partner. Tell them that the code written from now on must hold
   every ADR they keep. Ask, for each one, whether they keep or abandon it, and
   why when they abandon it. Keep an ADR they want rewritten: this pull request
   rewrites none.
4. Commit what the script changed. Then delete the ADRs your human partner
   abandoned, in a commit of its own whose message says why each one is
   abandoned.
5. Push, and open the pull request.
6. Report the state of play: which modules are adopted, and which ADRs your
   human partner kept.

**Do not adopt anything.** Adoption is a deliberate, per-module decision made by
your human partner, and it runs through `supercharlouze:adopting-a-module`.

**Do not propose a module breakdown.** Module boundaries belong to your human
partner, and a suggestion reads as a decision.

Then read `supercharlouze:using-batches` so the rest of the session follows the
overridden workflow.
