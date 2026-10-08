# Extraction de `starting-a-branch` Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La skill interne `starting-a-branch` porte le départ d'une branche, et les skills qui créent une branche l'invoquent à la place de leur copie.

**Architecture:** La skill reçoit le nom de la branche. Elle fetch, crée la branche et son espace de travail par `superpowers:using-git-worktrees`, puis restaure le nom reçu et le point de départ `origin/main`. `adopting-a-module`, `writing-a-batch` pour l'ouverture et pour l'amendement, `closing-a-batch`, `writing-a-user-story` et `using-batches` pour le changement borné l'invoquent en lui passant ce nom. Les deux contrats `shared` qui tenaient les copies deviennent des gardes sur la skill, une garde tient l'invocation dans chaque appelante, et une garde négative interdit le texte ailleurs. `following-the-rules` garde la règle et ne change pas.

**Tech Stack:** Markdown pour les skills, Bash pour `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes

## Global Constraints

### Constraints of the batch

Les skills portent les noms que `Technical design` leur donne.

`using-batches` garde son nom, que le bloc d'instructions des projets installés
cite.

La story qui renomme une skill redonne, avec le nouveau nom, le prompt en attente
qui nomme l'ancien.

Une skill interne porte `user-invocable: false` et une description de la forme
« Use only when a skill tells you to invoke <nom>, never on … ».

Une skill interne nomme les skills qu'elle invoque, jamais celles qui
l'invoquent.

Un texte de plus d'une ou deux phrases que plusieurs skills partagent vit dans une
skill interne, jamais dans une ref.

Une story fusionnée laisse chaque référence `supercharlouze:<nom>` résolue et la
suite de tests verte.

Jusqu'à la story qui transcrit D6, D7 et D8, `Global Constraints` recopie ses
textes, et les contrats `shared` qui les tiennent identiques suivent ces textes
dans les skills qui les portent.

Chaque skill extraite l'est par une story à elle.

Les stories se livrent une à la fois, dans cet ordre, libre entre les skills d'un
même rang que « puis » ne sépare pas :

1. l'outillage des tests ;
2. `following-the-rules` ;
3. `writing-in-a-spec`, `writing-in-a-gaps-register`, `detecting-concurrency`,
   `abandoning-a-story`, `applying-a-spec-delta` et `running-reread-rounds` ;
4. `starting-a-branch`, puis `finishing-a-pr` ;
5. `writing-a-batch-document`, puis `rereading-a-batch` ;
6. `amending-a-batch`, dont la story renomme `writing-a-batch` en
   `opening-a-batch` ;
7. `handling-a-stopped-story`, `making-a-bounded-change`, puis le renommage de
   `writing-a-user-story` en `delivering-a-story`.

La story qui résorbe la violation sur `The gaps register` suit l'extraction de
`amending-a-batch`.

La story qui extrait `following-the-rules` résorbe le gap sur `Code under a
feature flag` et `The user story document`.

D1 et D4 sont transcrits par une même story, qui suit l'extraction de
`handling-a-stopped-story`.

D2 et D3 sont transcrits par une même story, qui suit l'extraction de
`making-a-bounded-change`.

D6, D7 et D8 sont transcrits par une même story, qui suit le renommage en
`delivering-a-story`.

La story qui transcrit D5 suit ce renommage.

### The freeze of the spec file

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

### The authority rule

When the batch and the spec contradict each other, the spec wins, without
exception and without deliberation. Implement what the spec says, record a
`Ruling:`, and carry on. Correcting a spec mid-batch is a human act, never an
agent's.

### The concision rules

> These rules hold for every document, pull request body and commit message
> this story writes.
>
> Every sentence says one exact thing, once, and stands on its own.
>
> Every paragraph carries one rule.
>
> A rule says how far it holds, and an exception presents itself as one.
>
> A text says what it delivers or decides, without telling how it got there or
> why. Exception: a reason that is explicitly asked for, such as the why of a
> ruling.
>
> No sentence is set in relief: no bold that ranks one sentence above its
> neighbours.

### The stop condition of a technical story

> If, while conducting a technical story, you discover that it changes something observable at the module's boundary, stop. The story is no longer technical.

### The stop condition on a constraint or an ADR

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

### The ADRs

> The code this story writes holds these ADRs.

- `docs/adr/une-skill-par-moment-d-invocation.md`

### The conditions of an ADR

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

### This repository

- Every `git` command that writes a commit or talks to the remote goes through
  `bash ~/.config/github-app/as-agent.sh git …`. A commit message ends with
  `Co-Authored-By: Charlouze <me@charlouze.com>` and carries no other
  attribution line.
- A skill is English, cites no section of `docs/specs/supercharlouze.md`, and
  follows the rules of `Writing a skill` in the repository's `CLAUDE.md`.
- A `SKILL.md` has LF line endings.
- Write and edit files with the file tools, never with a heredoc, `sed` or
  `perl` in the shell: the shell of this machine eats backslashes.
- The machine has neither `python` nor `node`.
- A guard is written before the text it holds, and each task shows its red step.
- `bash tests/run-all.sh` runs the whole suite, in about two minutes.

## Review Focus

- A caller that keeps a sentence of the gesture, in its body or in its `Red Flags` table: the negative guard of Task 2 refuses it.
- A caller that no longer fetches before it reads `origin/main` to allocate a number: `writing-a-batch` and `writing-a-user-story` keep `git fetch origin` at the head of their allocation.
- The amendment, whose branch follows no pattern: the skill restores the name it was given, so the amendment passes the name it chose and is no exception.
- A name of an entry skill, or a numbered step, in `starting-a-branch`: the guard of Task 1 refuses it.
- A needle that no longer matches because the prose it targets was re-wrapped with two spaces or a stray character: run the whole suite, not the edited file alone.

---

### Task 1: The skill `starting-a-branch`

**Files:**
- Create: `skills/starting-a-branch/SKILL.md`
- Modify: `tests/skills.txt`
- Modify: `tests/test-skill-content.sh` (after the `running-reread-rounds` block, before `# --- following-the-rules: the delta block`)
- Modify: `tests/test-cross-references.sh` (after the block on the README row of `running-reread-rounds`)
- Modify: `README.md` (the `Skills` table)

**Interfaces:**
- Consumes: `require`, `absent`, `skill_text`, `pass`, `fail` from `tests/lib.sh`; the variable `entry_names`, which `tests/test-skill-content.sh` already sets.
- Produces: the skill `supercharlouze:starting-a-branch`, which Task 2 makes the branch-creating skills invoke. It is given the name of the branch.

- [ ] **Step 1: Write the failing guards**

In `tests/test-skill-content.sh`, insert after the line `absent "running-reread-rounds names no skill" "$rounds_other_names" running-reread-rounds` and its following blank line:

```bash
# --- starting-a-branch: the start of a branch ---
require starting-a-branch "says what the invoking skill passes" \
    "The skill that invokes it gives the name of the branch."
require starting-a-branch "starts from main as the remote carries it" \
    "starts a branch from \`main\` as the remote carries it"
require starting-a-branch "fetches first" "git fetch origin"
require starting-a-branch "creates the branch and its workspace through using-git-worktrees" \
    "**Create the branch and its workspace by invoking \`superpowers:using-git-worktrees\`**"
require starting-a-branch "checks the starting point" \
    "git merge-base --is-ancestor origin/main HEAD"
require starting-a-branch "restores the name and the starting point" \
    "restore the name you were given and the starting point before going on"
require starting-a-branch "puts both right inside the workspace" \
    "git switch -c <branch> origin/main"
require starting-a-branch "a named branch is not enough" "**A named branch is not enough.**"
require starting-a-branch "a reused worktree creates no branch" \
    "concludes \"already in a linked worktree\" and reuses it without creating a branch"
# The fetch comes before the branch, and the check after it.
skill_text starting-a-branch
case "$SKILL_TEXT" in
    *"git fetch origin"*"superpowers:using-git-worktrees"*"git switch -c <branch> origin/main"*)
        pass "starting-a-branch: fetch, then the workspace, then the restoration" ;;
    *)  fail "starting-a-branch: fetch, then the workspace, then the restoration" ;;
esac
require starting-a-branch "red flag: already in a worktree" \
    "| \"I'm already in a worktree, that will do\" |"
require starting-a-branch "red flag: the harness named the branch" \
    "| \"The harness already named the branch, that will do\" |"
require starting-a-branch "says when to go back to the step that invoked it" \
    "Once the branch is started, go on with the step that invoked this skill, in the workspace of the branch."
# An internal skill names the skills it invokes, never those that invoke it, nor
# a numbered step of one of them.
absent "starting-a-branch names no skill that invokes it" "${entry_names%|}|Step [0-9]" starting-a-branch

```

In `tests/test-cross-references.sh`, insert after the `esac` that closes the block on the README row of `running-reread-rounds` (the one whose labels read `the README row of running-reread-rounds rules out direct use`) and its following blank line:

```bash
# The README row of starting-a-branch, like the other internal skills', says it
# is not for direct use and names none of the skills that invoke it.
BROW="$(grep -F '`supercharlouze:starting-a-branch`' "$REPO_ROOT/README.md" || true)"
case "$BROW" in
    *"using-batches"*|*"adopting-a-module"*|*"writing-a-batch"*|*"writing-a-user-story"*|*"closing-a-batch"*|*"invoked by"*)
        fail "the README row of starting-a-branch names no caller" ;;
    *)  pass "the README row of starting-a-branch names no caller" ;;
esac
case "$BROW" in
    *"Never directly"*) pass "the README row of starting-a-branch rules out direct use" ;;
    *)                  fail "the README row of starting-a-branch rules out direct use" ;;
esac

```

In `tests/skills.txt`, insert after the line `running-reread-rounds internal`:

```
starting-a-branch internal
```

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-content.sh | grep -c 'FAIL.*starting-a-branch'` then `bash tests/test-cross-references.sh | grep 'starting-a-branch'` then `bash tests/test-skill-frontmatter.sh | grep FAIL`
Expected: the `require` and `case` guards of the skill FAIL, `the README row of starting-a-branch rules out direct use` FAILS, and the front matter test fails on a declared skill that has no directory. Keep the output for your report.

- [ ] **Step 3: Write the skill**

Create `skills/starting-a-branch/SKILL.md`, with LF line endings, with exactly this content:

````markdown
---
name: starting-a-branch
description: Use only when a skill tells you to invoke starting-a-branch, never on a request to create a branch - fetches, creates the branch and its workspace, and restores the name it was given and the starting point origin/main
user-invocable: false
---

# Starting a Branch

## Overview

This skill starts a branch from `main` as the remote carries it.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the starting-a-branch skill to start this branch."

The skill that invokes it gives the name of the branch.

Once the branch is started, go on with the step that invoked this skill, in the workspace of the branch.

## The Gesture

1. **Fetch.**

   ```bash
   git fetch origin
   ```

   Merges arrive from the remote, so a branch started without the fetch starts
   from a `main` that is already behind.

2. **Create the branch and its workspace by invoking
   `superpowers:using-git-worktrees`**, then move into that workspace.

3. **Check the name and the starting point**, whatever that skill reported:

   ```bash
   git branch --show-current
   git merge-base --is-ancestor origin/main HEAD
   ```

   That skill prefers the harness's native tooling, which picks its own branch
   name, may leave a detached HEAD, and may branch from wherever you happened to
   be. And from inside a linked worktree it sees `GIT_DIR != GIT_COMMON`,
   concludes "already in a linked worktree" and reuses it without creating a
   branch: the work would land on the branch of the piece of work before.

4. **If the branch bears another name, HEAD is detached, the starting point is
   not `origin/main`, or isolation was declined, restore the name you were given
   and the starting point before going on**, inside the workspace:

   ```bash
   git switch -c <branch> origin/main
   ```

**A named branch is not enough.** Until its pull request opens, a piece of work
is recognised by the name of its branch on the remote. A branch under another
name claims nothing of what the name you were given claims, and a branch started
elsewhere carries commits that are not its own.

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'm already in a worktree, that will do" | As a place to work, it will. A branch that starts there will not: the work lands on the branch of the piece of work before. Start the branch from `origin/main`, wherever you stand. |
| "The harness already named the branch, that will do" | Under that name the branch claims nothing of what the name you were given claims. Restore the name you were given. |
````

- [ ] **Step 4: Add the README row**

In `README.md`, insert after the row that starts with ``| `supercharlouze:running-reread-rounds` |``:

```markdown
| `supercharlouze:starting-a-branch` | Never directly — a building block the other skills invoke to start a branch from `main` as the remote carries it: fetch, create the branch and its workspace, restore its name and its starting point |
```

- [ ] **Step 5: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: every file passes, no `[FAIL]` line. A negative guard that walks every declared skill may refuse a phrase of the new skill: report it with the guard's label instead of rewording the skill on your own.

- [ ] **Step 6: Commit**

```bash
git add skills/starting-a-branch tests/skills.txt tests/test-skill-content.sh tests/test-cross-references.sh README.md
bash ~/.config/github-app/as-agent.sh git commit -m "feat: la skill interne starting-a-branch porte le départ d'une branche" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

### Task 2: The branch-creating skills invoke `starting-a-branch`

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md` (`Steps`, `3. Create the branch`, `Red Flags`)
- Modify: `skills/writing-a-batch/SKILL.md` (`Preconditions`, `Allocating NN`, `Amending a Batch`)
- Modify: `skills/closing-a-batch/SKILL.md` (`Preconditions`, `Red Flags`)
- Modify: `skills/writing-a-user-story/SKILL.md` (`Preconditions`, `Step 2`, `Red Flags`)
- Modify: `skills/using-batches/SKILL.md` (the sentence that names `bounded/<slug>`)
- Modify: `tests/test-skill-contracts.sh` (the two `shared` contracts at the top)
- Modify: `tests/test-skill-content.sh` (the guard `branches from main as the remote carries it`)

**Interfaces:**
- Consumes: the skill `supercharlouze:starting-a-branch` of Task 1, which is given the name of the branch; `require`, `absent`, `declared_skills` from `tests/lib.sh`.
- Produces: nothing a later task relies on.

`skills/following-the-rules/SKILL.md` does not change: it keeps the rule, the skill carries the gesture.

- [ ] **Step 1: Write the failing guards**

In `tests/test-skill-contracts.sh`, replace the block that runs from the comment line `# Number allocation and the concurrency scan both recognise a branch by its` to the line `    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch` that closes the second `shared` call (both `shared` calls included) with:

```bash
# A branch is started in one place, `starting-a-branch`. A skill that creates a
# branch invokes it and passes the name of the branch.
for s in adopting-a-module writing-a-batch writing-a-user-story closing-a-batch using-batches; do
    require "$s" "invokes starting-a-branch with the name of the branch" \
        "nvoke \`supercharlouze:starting-a-branch\` and give it the name"
done
require adopting-a-module "an adoption passes adopt/<module>" \
    "Invoke \`supercharlouze:starting-a-branch\` and give it the name \`adopt/<module>\`"
require writing-a-batch "an opening passes batch/NN-<slug>" \
    "Invoke \`supercharlouze:starting-a-branch\` and give it the name \`batch/NN-<slug>\`."
require writing-a-batch "an amendment passes the name it chose" \
    "Invoke \`supercharlouze:starting-a-branch\` and give it the name you chose."
require closing-a-batch "a closing passes batch/NN-<slug>-close" \
    "**Invoke \`supercharlouze:starting-a-branch\` and give it the name \`batch/NN-<slug>-close\`.**"
require writing-a-user-story "a story passes story/NN-us-N-<slug>" \
    "Invoke \`supercharlouze:starting-a-branch\` and give it the name \`story/NN-us-N-<slug>\`."
require using-batches "a bounded change passes bounded/<slug>" \
    "invoke \`supercharlouze:starting-a-branch\` and give it the name \`bounded/<slug>\`"
# Allocation reads `origin/main` before the branch exists, so it fetches itself.
case "$(body_flat "$REPO_ROOT/skills/writing-a-batch/SKILL.md")" in
    *"git fetch origin git ls-tree --name-only origin/main docs/batches/"*)
        pass "writing-a-batch: allocation fetches before it reads the remote" ;;
    *)  fail "writing-a-batch: allocation fetches before it reads the remote" ;;
esac
case "$(body_flat "$REPO_ROOT/skills/writing-a-user-story/SKILL.md")" in
    *"git fetch origin git ls-tree --name-only origin/main docs/batches/NN-<slug>/"*)
        pass "writing-a-user-story: allocation fetches before it reads the remote" ;;
    *)  fail "writing-a-user-story: allocation fetches before it reads the remote" ;;
esac
# How a branch is started is spelled there and nowhere else. Walks the declared
# skills, so one declared later is covered.
# shellcheck disable=SC2046
absent "no other skill restates the start of a branch" \
    "named branch is not enough|restore the conventional name|detached HEAD|harness's native tooling|wherever you happened to be|GIT_DIR != GIT_COMMON|already in a linked worktree|merge-base --is-ancestor|[Ii]nvoking .superpowers:using-git-worktrees|then branch from .origin/main|using-git-worktrees (opens|reuses)|branch from .origin/main.: otherwise|create the branch from .origin/main. yourself|Branch from .origin/main., wherever you stand" \
    $(declared_skills | grep -vx starting-a-branch)
```

In `tests/test-skill-content.sh`, delete the line:

```bash
require writing-a-user-story "branches from main as the remote carries it" "starts from \`main\` as the remote carries it"
```

Task 1 already guards that phrase on `starting-a-branch`.

- [ ] **Step 2: Run the guards to verify they fail**

Run: `bash tests/test-skill-contracts.sh | grep -E 'starting-a-branch|start of a branch|allocation fetches|passes '`
Expected: every one of these lines is `[FAIL]`, and the negative guard names `adopting-a-module writing-a-batch closing-a-batch writing-a-user-story` as holding the text. Keep the output for your report.

- [ ] **Step 3: Rewrite `adopting-a-module`**

In `## Steps`, replace the passage that runs from `**Check the preconditions first, before creating any branch and long before` to `started, and the new workspace would open empty.` with:

```markdown
**Check the precondition first, before creating any branch and long before
writing a line of either document: `gh` is available and authenticated.** The
adoption ends in a pull request.

The order below is not a suggestion. **The branch exists before either document
is written** — step 3 — because its workspace is a *separate directory*: writing
the spec first would leave it uncommitted where you started, and the new
workspace would open empty.
```

In `### 3. Create the branch`, replace the two paragraphs that run from `Now, and not later. Create the branch` to `length of an implementation.` with:

```markdown
Now, and not later. Invoke `supercharlouze:starting-a-branch` and give it the
name `adopt/<module>`: every file the next two steps write belongs in the
workspace it leaves you in.
```

The paragraph `The two steps before this one are dialogue: …` stays.

In `## Red Flags`, replace the row that starts with `| "I'll write the two documents first and create the branch to carry them" |` with:

```markdown
| "I'll write the two documents first and create the branch to carry them" | The branch's workspace is a separate, empty directory. The branch comes first, at step 3, or both files stay stranded where you started. |
```

and delete the row that starts with `| "I'm already in a worktree, that will do" |`.

- [ ] **Step 4: Rewrite `writing-a-batch`**

In `## Preconditions`, delete item 2 whole, from `2. **The branch you are about to create starts from` to `behind.`, and renumber the item `3. **\`gh\` is available and authenticated.**` to `2.`.

In `## Allocating NN`, replace:

````markdown
`story/*` branch that carries no pull request yet**. All three, always:

```bash
git ls-tree --name-only origin/main docs/batches/
````

with:

````markdown
`story/*` branch that carries no pull request yet**. Fetch, then read all three,
always:

```bash
git fetch origin
git ls-tree --name-only origin/main docs/batches/
````

In the same section, replace the paragraph that runs from `Create the branch and workspace by invoking` to `hands its number to the next batch opened in parallel.` with:

```markdown
Invoke `supercharlouze:starting-a-branch` and give it the name `batch/NN-<slug>`.
```

In `## Amending a Batch`, replace the passage that runs from `and a name that follows none has nothing to carry: that is what makes it the one` to `restoring a conventional name, and the exception holds for that reason alone.` with:

```markdown
and a name that follows none has nothing to carry. Invoke
`supercharlouze:starting-a-branch` and give it the name you chose.
```

The sentence `Edit the batch document in place, …` that follows stays, and starts a line of its own in the same paragraph.

- [ ] **Step 5: Rewrite `closing-a-batch`**

In `## Preconditions`, replace the two bullets `- **The close branch starts from \`main\` as the remote carries it.** …` and `- **Create the branch and its workspace by invoking \`superpowers:using-git-worktrees\`.** …` with this one bullet, on one line like its neighbours:

```markdown
- **Invoke `supercharlouze:starting-a-branch` and give it the name `batch/NN-<slug>-close`.** The documents below are read on that branch: read from a `main` behind the remote, they leave out the stories merged since.
```

In `## Red Flags`, delete the row that starts with `| "I'm already in a worktree from this batch's last story, I'll close from here" |`.

- [ ] **Step 6: Rewrite `writing-a-user-story`**

In `## Preconditions`, delete the first bullet whole, from `- **This story's branch starts from \`main\` as the remote carries it.** Fetch,` to `state that is already behind.`.

In `## Step 2 — Allocate us-N and Create the Branch`, replace:

````markdown
```bash
git ls-tree --name-only origin/main docs/batches/NN-<slug>/
````

with:

````markdown
```bash
git fetch origin
git ls-tree --name-only origin/main docs/batches/NN-<slug>/
````

In the same step, replace the paragraph that runs from `Create the branch and the workspace by invoking` to `its \`us-N\` nor its sections, and the push at the end of Step 3 buys nothing.` with:

```markdown
Invoke `supercharlouze:starting-a-branch` and give it the name
`story/NN-us-N-<slug>`.
```

In `## Red Flags`, delete the row that starts with `| "I'm already in a worktree, that's fine" |`.

- [ ] **Step 7: Rewrite `using-batches`**

Replace the sentence `Its branch is \`bounded/<slug>\`.` that ends the paragraph starting with `No batch, no user story:` with:

```markdown
Its branch is `bounded/<slug>`: invoke `supercharlouze:starting-a-branch` and give it the name `bounded/<slug>`.
```

- [ ] **Step 8: Run the whole suite**

Run: `bash tests/run-all.sh`
Expected: every file passes, no `[FAIL]` line. If a guard of another file held a sentence this task removed, report its label and the sentence instead of restoring the sentence.

- [ ] **Step 9: Commit**

```bash
git add skills tests
bash ~/.config/github-app/as-agent.sh git commit -m "feat: les skills qui créent une branche invoquent starting-a-branch" -m "Co-Authored-By: Charlouze <me@charlouze.com>"
```

## Rulings log

## Observed drift
