# Global Constraints

Write the `Global Constraints` section of the plan from this template. Whoever
executes or reviews a task reads it with nothing else in hand: change nothing in
it but what the steps below fill.

```markdown
## Global Constraints

**Constraints of the batch**, which every task of this plan holds:

<the `Constraints` section of the batch document, word for word>

**Execution rules:** `spec freeze`, `spec authority`, `concision`, `corrective stop condition`, `code under a feature flag`, `technical stop condition`, `untenable constraint or ADR`, `held ADRs`, `decision worth an ADR`
Before you execute or review a task of this plan, invoke
`supercharlouze:following-the-rules`. Its `Execution Rules` section says where
each rule named here is written: read them there, and follow them.

**ADRs the code of this story holds:** `docs/adr/<slug>.md`, `docs/adr/<slug>.md`
```

1. Copy the `Constraints` section of the batch document under the first label,
   verbatim.
2. Keep on the `Execution rules:` line the name of each rule that holds for
   this story, and delete the others. `Execution Rules` in
   `supercharlouze:following-the-rules` says which story each rule holds for.
   A batch declares constraints when its `Constraints` section is not `none`.
   `docs/adr/` carries an ADR when a `.md` file is placed directly in it, in
   this story's worktree.
3. Under the last label, list the path of every ADR `docs/adr/` carries in this
   story's worktree, and write `none` when it carries none. An implementer
   reads only this list, so an ADR whose path is missing from it binds nobody.
