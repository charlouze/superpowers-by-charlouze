---
name: detecting-concurrency
description: Use only when a skill tells you to invoke detecting-concurrency, never on a request to check who else is working on a spec - scans the work in flight on the remote for the sections a piece of work will touch, and returns the conflicts and the declarations it could not read
user-invocable: false
---

# Detecting Concurrency

## Overview

This skill checks that nobody else holds the sections a piece of work will
touch. `Authority and Conflict Rules` in `supercharlouze:following-the-rules`
says what a conflict is and what each claimant declares.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the detecting-concurrency skill to check who else holds these sections."

The skill that invokes it gives the spec the work targets, the sections it will
touch and, when the work already has one, its branch.

It returns the conflicts and the declarations it could not read
(`What It Returns`). Once you have them, go on with the step that invoked this
skill.

## The Scan

Fetch first: the work in flight arrives from the remote, and a scan of a stale
state answers about a state that is already behind.

```bash
git fetch origin
```

When the work has a branch, leave that branch and its pull request out of
everything below.

1. **List the open pull requests together with their head ref**, and keep those
   whose branch is `story/*` or `bounded/*`. Bare `gh pr list` does not print the
   head ref, so ask for it explicitly:

   ```bash
   gh pr list --state open --limit 100 --json number,headRefName
   gh pr view <n> --json number,headRefName   # one pull request at a time
   ```

   **The filter is the branch name, not the files the pull request touches.**
   Only those branches claim sections, so the head ref
   answers on its own — nothing to fetch and no file to read. And a pull request
   that touches no spec at all still holds its sections: a corrective story's
   first commit deletes a gaps register entry, so a filter on the spec file made
   it invisible to every sibling for its whole life.

2. **For each of those, read its declaration — wherever that pull request
   keeps it.** A story keeps it in its story document, which lives on the
   *other* pull request's head branch and not in your worktree, so read it at
   the head ref: `Spec:` names the spec, `Sections:` the sections. A **bounded
   change** (`bounded/<slug>`) has no story document at all: it names both in the
   body of its pull request, so read the body. Look in the place that kind of
   pull request actually uses — demanding a story document from a bounded
   change would find nothing, and "nothing found" is an unknown
   (`What It Returns`), so every piece of work would stop for as long as any
   bounded pull request stayed open. That is a false stop, and a false stop jams
   the nominal path instead of protecting it.

   ```bash
   gh api "repos/{owner}/{repo}/contents/<path>?ref=<headRefName>" --jq .content | base64 -d
   git fetch origin <headRefName> && git show FETCH_HEAD:<path>   # local alternative
   gh pr view <n> --json body --jq .body                          # bounded change: bounded/<slug>
   ```

   **A declaration naming a spec other than the work's holds nothing against
   it.** The branch name says who claims sections; the declaration says in which
   spec. That is why the filter of point 1 can be as wide as it is — it lets in
   every claimant, and the declaration sorts them.

3. **Read the same declaration on every remote `story/*` or `bounded/*` branch
   that carries no pull request yet.** A story's pull request opens only at the
   end of its implementation, so a sibling holds its sections for that whole
   stretch without appearing in point 1 above. Its branch, however, is on the
   remote from its very first commit, so the remote sees it:

   ```bash
   git ls-remote --heads origin 'story/*' 'bounded/*'
   git show origin/<branch>:docs/batches/NN-<slug>/NN-us-N-<slug>.md
   git diff -U0 origin/main...origin/<branch> -- docs/specs/<module>.md   # no declaration yet
   ```

   Skip the branches already covered by a pull request in point 1.

   A pushed branch that carries no declaration yet is read by the sections it
   has already changed. That is a story branch between its spec commit and its
   plan commit, or a bounded change before its pull request opens. Diff it
   against `main` on the work's spec file, and take as claimed every section a
   hunk touches, named by the heading path it falls under in the branch's
   version, or in `main`'s for a removed section. A branch that changed nothing
   in that spec file claims nothing against the work.
4. Intersect all of those with the sections the work will touch.

## What It Returns

- **Each conflict:** the section, and the pull request or the branch that holds
  it.
- **Each declaration you could not read:** the pull request or the branch, and
  why: fetch failed, story document without its `Sections:` field, pull request
  body silent on a bounded change.

**An unread declaration is an unknown, not a pass.** Silently treating it as
empty turns the one real net into "found nothing". A pushed branch that has not
declared yet is not an unknown: point 3 reads it by what it changed. Nor is a
bounded change having no story document: its declaration is in its pull request
body, read per point 2.

## What the Scan Does Not See

**Name the blind spot rather than trusting the net.** What this scan sees is
what is on the remote: open pull requests, and pushed `story/*` and `bounded/*`
branches. A piece of work that has created its branch but not yet pushed it is
invisible to every sibling, and no amount of care here finds it. Read the scan
as complete for work already on the remote, and as blind to everything else.

Sections are declared, not derived, wherever a declaration exists: reading a
diff to guess which sections a story touches is fragile, whereas the story's
author knows them. The diff stands in only for a pushed branch that has not
declared yet, and it shows only what that branch has already changed.

Do not fall back on git. A merge conflict is only a **partial safety net** —
git conflicts on lines, not on sections, so two stories editing the same
section in distant places merge cleanly. Relying on it lets through exactly the
case this scan exists to catch.

## Red Flags

| Thought | Reality |
|---------|---------|
| "No merge conflict, so no one else is on this section" | Git conflicts on lines, not sections; two edits far apart in one section merge cleanly. Read the declarations. |
| "No open pull request touches this spec, so the section is free" | The filter is the branch name, not the files: a pull request that touches no spec holds its sections all the same. And a story holds them from its first commit until its pull request opens — read the pushed `story/*` and `bounded/*` branches too. |
| "This pull request has no story document, so its declaration cannot be read" | Not if it is a `bounded/<slug>`: a bounded change declares its sections in its pull request body. Read it there. Returning it as unread would halt every piece of work for as long as one bounded pull request stays open. |
