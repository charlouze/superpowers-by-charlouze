---
name: finishing-a-pr
description: Use only when a skill tells you to invoke finishing-a-pr, never on a request to finish or merge a pull request - conducts the end of a pull request's review, from its corrections to the squash and the announcement that it is ready, then asks for a clear context when the merge is announced and gives the prompt of the next step
user-invocable: false
---

# Finishing a PR

## Overview

This skill conducts the end of a pull request's review, then answers the
announcement of its merge.

It is invoked by another skill, never on a request of your human partner.

**Announce at start:** "I'm using the finishing-a-pr skill to end this review."

The skill that invokes it gives the conditions the announcement waits on, or
none, and the next step, or none.

A next step comes with the skill that conducts it and the document it starts
from, and with what else its prompt must say when there is anything.

The rules this skill applies are those of `The Git Model` in
`supercharlouze:following-the-rules`: this skill carries the gestures, in their
order.

Once you have answered the merge announcement, go on with the step that invoked
this skill.

## The Review

1. **Push each correction the review asks for as a `fixup!` commit of the commit
   it corrects.** A correction that carries a fresh decision is a commit of its
   own: a review that changes the wording of a spec change is deciding
   something, not fixing a slip.
2. **Wait for your human partner's agreement, given in the conversation.**
3. **Check each condition you were given.** When one does not hold, say which
   one, squash nothing and go back to the review: it goes on until the
   condition holds and your human partner agrees again.
4. **Squash the `fixup!` commits into the commits they correct, and push the
   rewritten branch.**
5. **Announce that the pull request is ready to be approved and merged.**

## The Merge

When your human partner announces the merge:

1. **Ask them to clear the context.**
2. **If you were given a next step, name it and give, in a block to copy and
   paste, the prompt that starts it in a fresh context.** The prompt names the
   skill to invoke and the document to start from, by its path, says what else
   you were given for it, and never refers back to this conversation.

Without a next step, give no prompt.

## Red Flags

| Thought | Reality |
|---------|---------|
| "The correction is tiny, I'll amend the commit and force-push" | A force-push mid-review replaces the commits your human partner has comments on. Push a `fixup!`. |
| "They approved on GitHub, that is their agreement" | The agreement is given in the conversation. Ask for it there before you squash. |
| "They agreed, the condition can be settled after the merge" | After the merge the branch is gone and nothing settles it. Go back to the review. |
| "They agreed, I can merge it myself" | Approving and merging are your human partner's acts. Announce the pull request ready and wait. |
| "The pull request is ready, I'll give the next prompt now" | The review may go on and bury it, or change the document it names. Give it when the merge is announced. |
