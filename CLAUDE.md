<!-- supercharlouze:begin -->
## Specs and plans

This project overrides how superpowers organizes specs and plans.
Invoke `supercharlouze:using-batches` before any design work, and again before executing any plan.
It relocates specs and plans, replaces steps 6 to 9 of the architectural checklist of superpowers:brainstorming, extends the stop conditions of superpowers:subagent-driven-development, requires subagent-driven-development as the execution mode, and constrains superpowers:finishing-a-development-branch to the pull request option.
It declares each of these overrides explicitly; where it declares none, superpowers applies unchanged.
<!-- supercharlouze:end -->

## Writing a skill

`CONTRIBUTING.md` says how a change reaches `main`, how it is tested and how it is released.

A skill is the plugin's code, and it is entirely English.

A skill never cites a section of `docs/specs/supercharlouze.md`, which is French and is not among what the plugin ships: what an agent needs is stated in the skill itself. A section a skill names in parentheses is one of its own. This search lists them, and `tests/test-cross-references.sh` fails on one that is not a heading of the skill that names it:

```bash
grep -rnoE '\(`[A-Z][A-Za-z ]+`\)' skills/*/SKILL.md
```

The spec states the rules. A skill carries the method, the reasons that help decide, and examples.

A skill is concise by these rules, which are its own:

- Every sentence changes what an agent does. A sentence without which an agent would act the same is cut.
- A reason fits in one sentence. It is there so that an agent can handle a case the skill did not foresee.
- A skill says only what an agent does not already know. It does not explain git, a pull request or a test.
- A skill gives instructions. Not: "the branch is created from `origin/main` after a fetch". Good: "fetch, then branch from `origin/main`".
- An example shows the bad case before the good one. For a question of measure, such as how much to write, it shows too much, then too little, then the right amount.
- The excuse an agent gives itself to skip a rule is answered in the skill's `Red Flags` table: the thought, then what answers it.
- Bold marks what an agent under pressure is tempted to skip. Bold on every other sentence marks nothing.
- What a single step needs, such as a template or a prompt to paste, lives in `references/`, and the skill points to it at that step.

A text meant to be pasted into a subagent's prompt is written for that subagent, who has nothing else: it stands on its own.

A rule is written in full in one place and pointed at everywhere else, because a second copy drifts.

Every norm a skill states is held by a guard in `tests/`, written before the text.
