# La concision Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Les skills imposent la précision et la concision à tout texte que le flux écrit et à ce que l'agent dit à l'humain, et la relecture de cohérence vérifie que les blocs sont précis et concis.

**Architecture:** `using-batches` porte deux sections neuves, `Concision` et `Conversation`, énoncées en anglais avec leurs raisons et des exemples. Les quatre skills qui écrivent des documents y renvoient depuis leur section `Language`. `writing-a-batch` ajoute une lecture à la relecture de cohérence, qui se suffit à elle-même puisqu'elle est collée dans le prompt d'un lecteur.

**Tech Stack:** Markdown (skills), bash (gardes de `tests/`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/11-la-concision/README.md
**Sections:** Batch > The coherence reread, Concision, Conversation
**Blocks:** D13, D28, D29

## Global Constraints

1. Contraintes du lot, recopiées mot pour mot :
   - `D28` est transcrit au plus tard avec `D13`, avec `D18` et avec `D29`.
   - `D16` et `D25` sont transcrits au plus tard avec `D30`, et `D30` au plus tard avec
     `D9`.
   - `D9` est transcrit au plus tard avec `D7`, et `D7` au plus tard avec `D3` et avec
     `D26`.
   - `D17` est transcrit au plus tard avec `D6`.
   - `D6` et `D12` sont transcrits ensemble.
2. Gel du fichier de spec :

   > Between the transcription commit and the opening of the pull request, no task
   > modifies the spec file. A story that discovers the spec must change stops.

3. Autorité : quand le lot et la spec se contredisent, la spec gagne, sans exception et sans délibération. Implémenter ce que dit la spec, consigner un `Ruling:`, et poursuivre. Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.
4. Les skills livrées sont intégralement en anglais, et ne citent jamais une section de `docs/specs/supercharlouze.md` : ce fichier est propre à ce dépôt et ne voyage pas avec le plugin. Contrôle : `grep -rnoE '\(`[A-Z][A-Za-z ]+`\)' skills/*/SKILL.md` ne renvoie rien.
5. Hors périmètre : les `Global Constraints` d'une story (`writing-a-user-story`) et le document de lot (`Scope`, forme des blocs). D'autres stories du lot les réécrivent.
6. Commits : sujet en français, au format Conventional Commits, un sujet par commit, terminé par la ligne `Co-Authored-By: Charlouze <me@charlouze.com>` et aucune autre attribution. Toute commande `git commit` ou `git push` passe par `bash ~/.config/github-app/as-agent.sh git …`.

## Review Focus

- Une lecture de cohérence collée seule dans un prompt : elle doit se comprendre sans le reste de la skill. Aucune phrase ne renvoie à `Concision` ou à `using-batches`.
- Les lectures ne sont comptées nulle part, ni dans la skill, ni dans le gabarit `reader-prompt.md`, ni dans les gardes, et la lecture du modèle reste la dernière.
- Le corps de la pull request d'ouverture ne déclare plus que la relecture a eu lieu hors contexte. Il dit ce qu'elle a trouvé, ou qu'elle n'a rien trouvé.
- Les exemples « pas bien → bien » de `Concision` respectent eux-mêmes la règle, et aucune phrase n'y est mise en gras.
- `Conversation` laisse l'identifiant suivre entre parenthèses, mais jamais seul.

---

### Task 1: La section `Concision` de `using-batches`

**Files:**
- Modify: `skills/using-batches/SKILL.md` (nouvelle section après `## Language`, une ligne dans `## Red Flags`)
- Modify: `skills/adopting-a-module/SKILL.md`, `skills/writing-a-batch/SKILL.md`, `skills/writing-a-user-story/SKILL.md`, `skills/closing-a-batch/SKILL.md` (une phrase à la fin de `## Language`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Produces: la section `## Concision` de `using-batches`, que la Task 2 cite et dont la Task 3 recopie les règles.

- [ ] **Step 1: Write the failing guards**

Ajouter à `tests/test-skill-content.sh`, juste après la boucle `states the language rule` :

```bash
# Every document-producing skill sends its writer to the concision rules.
for s in adopting-a-module writing-a-batch writing-a-user-story closing-a-batch; do
    require "$s" "points at the concision rules" "follows \`Concision\` in \`supercharlouze:using-batches\`"
done

# --- using-batches: concision ---
require using-batches "concision covers every text the flow writes" "hold for every text this flow writes: its documents, its pull request bodies and its commit messages"
require using-batches "one exact thing, once"              "Every sentence says one exact thing, once, and stands on its own"
require using-batches "one rule per paragraph"             "Every paragraph carries one rule"
require using-batches "a rule states its reach"            "A rule says how far it holds, and an exception presents itself as one"
require using-batches "what, not how or why"               "A text says what it delivers or decides, without telling how it got there or why"
require using-batches "the requested reason is the exception" "Exception: the reason this flow explicitly asks for"
require using-batches "nothing set in relief"              "No sentence is set in relief"
require using-batches "the cut test"                       "would a reader who never saw the previous version lose anything if this sentence went?"
require using-batches "too little is as wrong as too much" "Too little is as wrong as too much"
```

- [ ] **Step 2: Run the guards and see them fail**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: les 13 nouvelles gardes en `[FAIL]`.

- [ ] **Step 3: Write the section**

Insérer dans `skills/using-batches/SKILL.md`, entre la fin de `## Language` et `## Red Flags` :

```markdown
## Concision

These rules hold for every text this flow writes: its documents, its pull request bodies and its commit messages. A text nobody manages to reread is no longer an authority, and the rules are what keeps it readable.

Every sentence says one exact thing, once, and stands on its own.

Every paragraph carries one rule.

A rule says how far it holds, and an exception presents itself as one.

A text says what it delivers or decides, without telling how it got there or why. Exception: the reason this flow explicitly asks for, such as the why of a ruling or of the commit that deletes a gaps register entry.

No sentence is set in relief. Bold that ranks one sentence above its neighbours tells the reader the others bind less.

### How to apply them

The cut test, asked of every sentence before you commit it: would a reader who never saw the previous version lose anything if this sentence went? If not, cut it. Two kinds of sentence fail it every time. The refutation of a version that no longer exists ("X is no exception") answers a text the reader will never see. And the particular case the general rule already covers ("every review merge" already includes the closing one) makes the reader doubt the cases that are not spelled out.

Too little is as wrong as too much. A bound ("only", "and nothing else") is a rule; cut it and the rule widens. A vague word ("nature", "handled appropriately") is replaced by the concrete rule it hides. When you strip a mechanism from a sentence, check that the intention it served is still written somewhere.

Examples, each bad then good:

- One rule per paragraph. Not: "Every branch starts from `main` and merges into `main`. Except an amendment's, it bears the name its step assigns." The exception reads as if it held for both rules. Good: each rule on its own line, the exception attached to the one rule it touches.
- Write what you mean. Not: "no prose qualifies a group of entries". Good: "everything that qualifies an entry is written in the entry".
- Write the positive case. Not: "reaches `main` as a separate commit only if it carries a fresh decision". Good: "is squashed into the commit it corrects, unless it carries a fresh decision".
- Say what to do rather than listing cases. Not: "a divergence has only two legitimate causes: …". Good: "when `main` moved under a block, the story fits it; when a block's text is a problem, the agent puts it to the human".
- Two rules that paraphrase each other become one. Two phrasings reassure an agent and confuse a human, who looks for the difference between them.
- A field carries what its name says. Reserved gaps register entries go under `Scope`, not under `Spec delta`.
- No dash in place of a comma or of "that is".
- An option that reads as an obligation is taken out when it is a human decision.
- "Word for word" applies only to what really is copied word for word.
- A means is not the intention. Not: "each task runs in a subagent". Good: "each task is reviewed".
```

Puis, dans `## Red Flags` de `using-batches`, ajouter la ligne :

```markdown
| "This sentence is safer in, even if it repeats the rule above" | A text that says what goes without saying makes the reader doubt what does not, and ends up unread. Apply the cut test. |
```

Puis ajouter, comme dernière phrase de la section `## Language` de chacune des quatre skills `adopting-a-module`, `writing-a-batch`, `writing-a-user-story` et `closing-a-batch`, en paragraphe à part :

```markdown
Every text this skill writes follows `Concision` in `supercharlouze:using-batches`.
```

- [ ] **Step 4: Run the suite**

Run: `bash tests/run-all.sh | grep -E 'FAIL|all tests'`
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: tout texte du flux suit les règles de concision

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

### Task 2: La section `Conversation` de `using-batches`

**Files:**
- Modify: `skills/using-batches/SKILL.md` (nouvelle section après `## Concision`, une ligne dans `## Red Flags`)
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la section `## Concision` de la Task 1.

- [ ] **Step 1: Write the failing guards**

Ajouter à `tests/test-skill-content.sh`, après les gardes `using-batches` de la Task 1 :

```bash
# --- using-batches: conversation ---
require using-batches "conversation follows concision"     "What the agent says to the human follows \`Concision\`"
require using-batches "named by section and change"        "is named by the section it targets and what it changes there, never by its identifier alone"
require using-batches "the identifier may follow"          "The identifier may follow in parentheses"
```

- [ ] **Step 2: Run the guards and see them fail**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: les 3 nouvelles gardes en `[FAIL]`.

- [ ] **Step 3: Write the section**

Insérer dans `skills/using-batches/SKILL.md`, entre `## Concision` (avec sa sous-section) et `## Red Flags` :

```markdown
## Conversation

What the agent says to the human follows `Concision` above.

Facing the human, a delta block, a story or a gaps register entry is named by the section it targets and what it changes there, never by its identifier alone. Identifiers serve the documents and the agents; a human who hears "D12 conflicts with D6" does not know what either says, and naming the section alone still leaves them guessing what moves. Not: "D12 is ready". Good: "the block on `The batch document`, which moves the reserved entries into `Scope`, is ready".

The identifier may follow in parentheses when the human has to find it in the document.
```

Puis, dans `## Red Flags`, ajouter la ligne :

```markdown
| "The human has the batch document, `D12` is enough" | They do not keep the identifiers in mind. Name the section the block targets and what it changes there. |
```

- [ ] **Step 4: Run the suite**

Run: `bash tests/run-all.sh | grep -E 'FAIL|all tests'`
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: l'agent désigne un bloc par sa section et ce qu'il y change

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

### Task 3: La lecture de concision de la relecture de cohérence

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` (section `## The Coherence Reread`)
- Modify: `skills/writing-a-batch/references/reader-prompt.md`
- Test: `tests/test-skill-content.sh`, `tests/test-reader-prompt.sh`

**Interfaces:**
- Consumes: les règles de `## Concision` de la Task 1, recopiées dans la lecture, sans renvoi.

- [ ] **Step 1: Update the guards and see them fail**

Dans `tests/test-skill-content.sh`, section `writing-a-batch: the coherence reread` :
- remplacer la garde `the pull request body declares the reread` par :

```bash
require writing-a-batch "the pull request body says what the reread found" "The pull request body says what the reread found, or that it found nothing"
```

- ajouter, après la garde `reading 3: what a spec must hold` :

```bash
require writing-a-batch "reading 4: precise and concise"   "Is this change precise and concise?"
require writing-a-batch "the concision reading is self-contained" "Every paragraph carries one rule"
```

- renommer le libellé `reading 4: where this sits in the model` en `reading 5: where this sits in the model` (l'aiguille ne change pas) ;
- ajouter :

```bash
require writing-a-batch "five readings"                     "**The five readings.**"
require writing-a-batch "the model reading comes last"      "The fifth answers none of the first four and feeds all four"
```

Dans `tests/test-reader-prompt.sh` :
- remplacer l'aiguille de `the reading comes from the skill` par `one of the five that \`## The Coherence Reread\` states, pasted **word for word** from there` ;
- ajouter la ligne `precise and concise` à la liste `NEEDLES`.

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-reader-prompt.sh | grep FAIL`
Expected: les gardes nouvelles ou modifiées en `[FAIL]`.

- [ ] **Step 2: Rewrite the readings**

Dans `skills/writing-a-batch/SKILL.md`, section `## The Coherence Reread` :
- `**The four readings.**` devient `**The five readings.**`, et la phrase qui annonce les motions des lecteurs dit cinq motions : ajouter « a check of the wording » à son énumération, avant « a look at the model » et remplacer « four different motions » par « five different motions ».
- Insérer, entre la troisième lecture (`Does this specification hold…`) et celle du modèle (`Where does this sit in the model?`), la lecture suivante, en citation comme les autres. Elle est collée seule dans le prompt d'un lecteur : elle ne renvoie à rien.

```markdown
> **Is this change precise and concise?** Read every sentence the change
> brings. Each says one exact thing, once, and stands on its own. Every
> paragraph carries one rule. A rule says how far it holds, and an exception
> presents itself as one. A text says what it delivers or decides, without
> telling how it got there or why. No sentence is set in relief. A sentence
> whose removal would cost a reader nothing fails; so does a vague word where a
> concrete rule belongs. Report the sentences that fail, and what each breaks.
```

- `The fourth answers none of the first three and feeds all three` devient `The fifth answers none of the first four and feeds all four`.
- Remplacer le paragraphe qui commence par `**The pull request body declares the reread**` par :

```markdown
The pull request body says what the reread found, or that it found nothing. A reread nobody can see from the pull request is a practice again, not a rule.
```

Dans `skills/writing-a-batch/references/reader-prompt.md`, remplacer `one of the four that` par `one of the five that`.

- [ ] **Step 3: Run the suite**

Run: `bash tests/run-all.sh | grep -E 'FAIL|all tests'`
Expected: `all tests passed`.

- [ ] **Step 4: Commit**

```bash
git add skills/writing-a-batch tests/test-skill-content.sh tests/test-reader-prompt.sh
bash ~/.config/github-app/as-agent.sh git commit -F - <<'EOF'
feat: la relecture de cohérence vérifie que les blocs sont précis et concis

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

## Rulings log

- Ruling: the Global Constraint 4 control grep is read as "adds no new hit"; the five existing hits in writing-a-batch (steps citing the skill's own sections `Preconditions`, `Allocating NN`, `The Batch Document`, `The Coherence Reread`, `Opening the Pull Request`) cite the skill's own sections, not the spec, and stay — the constraint's intent is "never cite a spec section" — if wrong, a later story must rephrase those five step references.
- Ruling: Task 3 also updates the test comments that count "four readings" to five — comments that miscount are drift the Concision rules forbid, and it touches no assertion — if wrong, a one-line revert of comment text.
- Ruling: fix all three final-review minors in one fix wave, including the plan-prescribed wording of three Concision example lines (lead-in becomes "Examples:", "on its own line" becomes "in its own paragraph", the option example becomes "An option the human decides is taken out of the text when it reads as an obligation.") — the plan's Review Focus requires the examples to respect the rule they illustrate, the spec says nothing about the examples, and the plan's exact text contradicted its own Review Focus — if wrong, the human restores the plan's three original lines.
- Ruling: final-review declined items (concision reading omits the requested-reason exception; "feeds all four"; identifier in parentheses stricter than spec; pre-existing plugin text breaking the new rules; spec four questions vs skill five readings; Opening the Pull Request list omitting reread findings) are left as they stand — each is plan-prescribed text compatible with the spec, or pre-existing text outside this story — if wrong, a later story of the batch adjusts them.
- Ruling: à la revue, aucun texte ne compte plus les lectures de la relecture de cohérence ni ses questions dans la spec, et `Concision` gagne l'exemple « A list does not announce how many items it holds ». Cela remplace l'arbitrage qui recomptait à cinq les commentaires des tests, et rend sans objet l'écart entre les quatre questions de la spec et les cinq lectures de la skill — un décompte ne dit rien que la liste ne dise, et chaque lecture ajoutée forçait à retoucher la skill, le gabarit et les gardes — si c'est faux, les décomptes reviennent et chaque lecture ajoutée les remet à jour.
- Ruling: à la revue, `## Preconditions` de `writing-a-batch` dit « Check them all » au lieu de « Check all four », ce qui résorbe l'écart que cette story avait relevé (quatre conditions annoncées, trois listées) ; l'entrée d'`Observed drift` est retirée — si c'est faux, elle revient sous `Observed drift` pour la clôture.
- Ruling: le bloc de la relecture de cohérence dans le document de lot garde « quatre questions » ; seule la spec transcrite ne compte plus — le document de lot est sur `main` et aucune story ne le transcrit plus — si c'est faux, la clôture du lot aligne le bloc.

## Observed drift
