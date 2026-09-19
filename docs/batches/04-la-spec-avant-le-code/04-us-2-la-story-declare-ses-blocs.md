# 04 — us-2 — Une story déclare les blocs qu'elle transcrit — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Porter dans les skills ce que les blocs D5, D6, D7 et D8 viennent d'écrire dans la spec : une story choisit les blocs qu'elle transcrit, les déclare dans son champ `Blocks:`, les transcrit mot pour mot en nommant tout écart dans sa pull request, et la clôture lit ce champ pour constater les blocs non livrés.

**Architecture:** Trois blocs sur quatre vivent dans `skills/writing-a-user-story/SKILL.md`, seule skill qui écrit une story : le choix des blocs entre dans son `Overview` (D6), le champ `Blocks:` dans le gabarit d'en-tête de son `Step 4` (D7), et les trois conditions de la transcription dans son `Step 3` (D8). Le quatrième change la méthode du devoir 5 de `skills/closing-a-batch/SKILL.md` (D5) : il ne compare plus le delta annoncé au contenu des specs, il lit les déclarations `Blocks:` des stories fusionnées. Ce champ est donc un couplage à deux bouts, et il repart avec une assertion `shared` qui les verrouille ensemble — deux assertions séparées resteraient vertes pendant qu'un bout renomme le champ. Chaque norme ajoutée repart avec sa garde dans `tests/`, écrite rouge avant le texte qui la fait passer.

**Tech Stack:** Markdown (skills), bash (`tests/*.sh`, exécutées par `tests/run-all.sh`).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/04-la-spec-avant-le-code/README.md
**Sections:** Batch > Closing a batch, Story, Story > The user story document, Story > Delivering a story
**Blocks:** D5, D6, D7, D8

## Global Constraints

Le gel du fichier de spec, la règle d'autorité, la convention de commit, puis la section `Constraints` du lot copiée verbatim. Tout cela fait implicitement partie des exigences de chaque tâche.

**Gel du fichier de spec.** Entre le commit de transcription et l'ouverture de la pull request, aucune tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit changer s'arrête. `docs/specs/supercharlouze.md` a reçu D5, D6, D7 et D8 dans le commit `ce53974`, premier commit de cette branche : il n'y a plus rien à y écrire dans cette story.

**Autorité.** Quand le lot et la spec se contredisent, **la spec gagne — sans exception et sans délibération.** Implémente ce que dit la spec, inscris un `Ruling:`, et continue. **Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.**

**Commits.** Chaque commit passe par le wrapper d'identité de l'agent — `bash ~/.config/github-app/as-agent.sh git commit …` — suit Conventional Commits, et se termine par la ligne `Co-Authored-By: Charlouze <me@charlouze.com>`, sans aucune autre ligne d'attribution.

**Comment passer un message de commit.** Les messages de ce plan portent des accents et des apostrophes, et le shell de ce poste n'est pas celui que la syntaxe d'un here-string suppose. Chaque tâche écrit donc son message dans `/tmp/msg.txt` avec un heredoc `<<'EOF'` — quoté, pour que rien ne s'y interpole — puis commite avec `-F /tmp/msg.txt`. Le wrapper et le heredoc ne vont pas dans la même commande : écris le fichier d'abord, commite ensuite.

Constraints du lot, copiées verbatim :

- **Ordre requis.** D1 et D3, qui définissent le bloc et sa forme, sont transcrits
  **au plus tard dans la même story** que D7 et D8, qui font transcrire des blocs
  par une story : le champ `Blocks:` désigne des identifiants que seul le document
  de lot définit. Les autres blocs n'imposent aucun ordre.
- **Ce lot applique déjà ce qu'il introduit.** Ses stories déclarent `Blocks:`,
  transcrivent leurs blocs mot pour mot et nomment tout écart dans leur pull
  request, même là où les skills publiées ne le demandent pas encore. Leurs revues
  suivent D9 dès la première.
- **Chaque story met à jour les skills qui appliquent ses blocs**, dans la même
  pull request que sa transcription : `writing-a-batch`, `writing-a-user-story`,
  `closing-a-batch`, `using-batches` et `adopting-a-module` selon les blocs qu'elle
  prend. Une skill qui continuerait de parler de « spec delta comme intention »
  après la fusion de D3 est une dérive.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`, dans la
  même pull request qu'elle.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**
- **Aucun renvoi numéroté.** Un renvoi nomme la section qu'il vise ; il ne la compte
  pas.
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit la
  spec, la constatation part sous `Observed drift` dans le document de story.
- **Cinq décisions sont tranchées au gate d'ouverture** et ne se rediscutent pas
  en cours d'implémentation : **une adoption ne partage jamais le contexte de la
  conception d'un lot**, et une conception qui découvre un module non adopté
  s'arrête plutôt que d'enchaîner ; le spec delta est découpé **par section, jamais par
  story**, et le document de lot ne porte aucune liste de stories ; le texte est lu
  **dans le document de lot**, bloc par bloc, et non comme un diff de la spec ;
  l'accord de fin de revue se donne **dans la conversation**, l'approbation et la
  fusion restant des gestes humains sur GitHub ; il n'y a **pas de pause après le
  plan** — c'est le texte de la spec que l'humain revoit en amont, pas le
  découpage du travail.
- **Hors périmètre** : l'exécution de stories en parallèle, les pull requests
  empilées et le lancement de plusieurs stories sans intervention, l'endroit où
  noter une idée qui émerge hors du lot en cours, et l'identité GitHub propre à
  l'agent — qui relève de la configuration de chaque dépôt, pas du plugin.
- **Une seule entrée du gaps register est touchée** : *Batch / Closing a batch*,
  réservée par ce lot et résorbée par D2. Aucune autre.

---

## Files

- Modify: `skills/writing-a-user-story/SKILL.md` — `Overview` (tâche 1), `Step 4` (tâche 2), `Step 3` et `Red Flags` (tâche 3).
- Modify: `skills/closing-a-batch/SKILL.md` — devoir 5 (tâche 4).
- Test: `tests/test-skill-content.sh` — les gardes par skill, une par norme ajoutée.
- Test: `tests/test-skill-contracts.sh` — l'assertion `shared` du champ `Blocks:` (tâche 4).

Rien d'autre n'est touché. `docs/specs/supercharlouze.md` est gelé (voir `Global Constraints`), et `using-batches`, `writing-a-batch` et `adopting-a-module` ne portent aucune phrase que ces quatre blocs contredisent — c'est vérifié à la tâche 4.

## Interfaces

- **Tâche 1 produit** la phrase du choix des blocs dans `Overview`, que la tâche 2 prolonge en la reliant au champ qu'elle introduit.
- **Tâche 2 produit** le nom du champ, `Blocks:`, et son gabarit `**Blocks:** D3, D7`. **Tâche 3 le consomme** dans la condition « mot pour mot », **tâche 4 le consomme** comme ce que lit le devoir 5, et l'assertion `shared` de la tâche 4 verrouille les deux bouts sur la même graphie.
- Les helpers des tests sont déjà en place et ne changent pas : `require <skill> <label> <needle>` dans `tests/test-skill-content.sh`, `shared <label> <needle> <skills…>` dans `tests/test-skill-contracts.sh`. Les deux aplatissent le corps de la skill après son frontmatter, donc un `needle` se compare sans se soucier du retour à la ligne, et ne doit jamais contenir deux espaces consécutifs.

---

### Task 1: Le choix des blocs entre dans l'`Overview` de `writing-a-user-story`

Bloc **D6**. La story est l'endroit où le découpage se décide : le document de lot porte des blocs et aucune liste de stories, donc rien n'a rattaché un bloc à une story d'avance.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md:25-27`
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: rien.
- Produces: la phrase `Each story chooses, as it is written, the blocks of the spec delta it transcribes`, que la tâche 2 relie au champ `Blocks:`.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh`, à la suite du bloc `# --- writing-a-user-story: what Global Constraints carries … ---`, ajouter :

```bash
# --- writing-a-user-story: the story's blocks (spec sections "Story",
# "The user story document", "Delivering a story") ---
require writing-a-user-story "each story chooses its own blocks"  "chooses, as it is written, the blocks of the spec delta it transcribes"
require writing-a-user-story "a block is never shared"            "a block is never shared between two stories"
```

- [ ] **Step 2: Lancer la suite et vérifier que ces deux gardes échouent**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur `writing-a-user-story: each story chooses its own blocks` et `writing-a-user-story: a block is never shared`, et rien d'autre en rouge.

- [ ] **Step 3: Écrire le texte**

Dans `skills/writing-a-user-story/SKILL.md`, après le paragraphe `Stories are written **one at a time**: …` et avant `A story targets exactly **one** module`, insérer :

```markdown
**Each story chooses, as it is written, the blocks of the spec delta it
transcribes**, and transcribes them entirely: a block is never shared between two
stories. Nothing attached them in advance — the batch document carries blocks and
no list of stories — so the choice is made here, and the `Blocks:` field of
Step 4 is what records it.
```

- [ ] **Step 4: Lancer la suite et vérifier qu'elle est verte**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Commiter**

```bash
cat > /tmp/msg.txt <<'EOF'
feat: une story choisit les blocs du spec delta qu'elle transcrit

Rien ne les lui rattache d'avance : le document de lot porte des blocs et
aucune liste de stories.

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

```bash
bash ~/.config/github-app/as-agent.sh git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh
```

```bash
bash ~/.config/github-app/as-agent.sh git commit -F /tmp/msg.txt
```

---

### Task 2: Le champ `Blocks:` entre dans le gabarit d'en-tête du `Step 4`

Bloc **D7**. L'en-tête de la story gagne un quatrième champ, et ce champ est ce que la clôture lira.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md:267-279`
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la phrase de la tâche 1, qui renvoie au « `Blocks:` field of Step 4 ».
- Produces: la graphie du champ, `Blocks:`, et son gabarit `**Blocks:** D3, D7`. La tâche 3 et la tâche 4 s'appuient dessus.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh`, à la suite des deux gardes de la tâche 1, ajouter :

```bash
require writing-a-user-story "the header carries four extra fields" "extend the standard header with four fields"
require writing-a-user-story "the header template declares Blocks"  "**Blocks:** D3, D7"
require writing-a-user-story "Blocks is what closing reads"         "reads to find the blocks nobody delivered"
require writing-a-user-story "Blocks is none when none is taken"    "\`none\` for a story that transcribes none"
```

- [ ] **Step 2: Lancer la suite et vérifier que ces quatre gardes échouent**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur les quatre libellés ci-dessus, et rien d'autre en rouge.

- [ ] **Step 3: Écrire le texte**

Dans `skills/writing-a-user-story/SKILL.md`, `Step 4`, remplacer `extend the standard header with three fields.` par `extend the standard header with four fields.`, puis ajouter la ligne `**Blocks:** D3, D7` à la fin du bloc de code du gabarit :

```markdown
**Spec:** docs/specs/facturation.md
**Batch:** docs/batches/07-facturation-recurrente/README.md
**Sections:** Abonnement > Renouvellement, Abonnement > Proration
**Blocks:** D3, D7
```

Puis, après le paragraphe `` `Spec:` is the field … `Sections:` is what the *next* story's Step 1 reads. ``, insérer :

```markdown
`Blocks:` declares the blocks of the spec delta this story transcribes — the
`D<n>` identifiers the batch document defines — and it is what
`supercharlouze:closing-a-batch` reads to find the blocks nobody delivered. It is
`none` for a story that transcribes none: a corrective batch's story, a teardown
story. Write it even though the blocks are already committed by now, because
Step 3's commit says what the spec received, and this field says which blocks
this story answered for — which is the question closing asks.
```

- [ ] **Step 4: Lancer la suite et vérifier qu'elle est verte**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Commiter**

```bash
cat > /tmp/msg.txt <<'EOF'
feat: l'en-tête d'une story déclare les blocs qu'elle transcrit

Le champ Blocks: vaut none pour une story qui n'en transcrit aucun.

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

```bash
bash ~/.config/github-app/as-agent.sh git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh
```

```bash
bash ~/.config/github-app/as-agent.sh git commit -F /tmp/msg.txt
```

---

### Task 3: Les trois conditions de la transcription dans le `Step 3`

Bloc **D8**. La transcription devient mot pour mot, et tout écart avec un bloc est nommé dans la pull request.

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md:197-217` puis la table `Red Flags`
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la graphie `Blocks:` de la tâche 2.
- Produces: rien que les tâches suivantes lisent.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh`, à la suite des gardes de la tâche 2, ajouter :

```bash
require writing-a-user-story "three properties are load-bearing"    "Three properties are load-bearing"
require writing-a-user-story "transcription is word for word"       "exactly as the opening review read it"
require writing-a-user-story "a divergence is named in the PR"      "Every divergence from a block is named in the body of the pull request"
require writing-a-user-story "a divergence has two legitimate causes" "only two legitimate causes"
require writing-a-user-story "a doubtful block stops the story"     "Do not transcribe a text you believe is wrong"
require writing-a-user-story "no divergence amends the batch document" "Neither case amends the batch document"
```

- [ ] **Step 2: Lancer la suite et vérifier que ces six gardes échouent**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL sur les six libellés ci-dessus, et rien d'autre en rouge.

- [ ] **Step 3: Écrire le texte**

Dans `skills/writing-a-user-story/SKILL.md`, `Step 3`, remplacer le premier paragraphe, la phrase `Both properties are load-bearing.` et le paragraphe `**Incremental.** …` par :

```markdown
Transcribe into `docs/specs/<module>.md` the blocks of the batch's spec delta
that **this** story takes, and commit them as the **first commit on the
branch** — before the plan is written, before any task runs. **A lifting story
transcribes a removal:** its block deletes the gating sentence from the spec
instead of adding behaviour, and that deletion is this same first commit (see
Lifting and Teardown Stories below).

Three properties are load-bearing.

**Word for word.** The text of the blocks `Blocks:` declares, exactly as the
opening review read it, and never the batch's whole delta. Rewording it would put into
the spec a sentence no gate ever ruled on, and would make the opening review a
review of something else. Transcribing the whole delta is the other failure: the
spec would describe, while story 1 is still executing, the behaviour of the
stories that follow — and the SDD reviewers would flag as missing what is not yet
meant to be delivered.
```

Le paragraphe `**First.** …` reste tel quel. Juste après lui, insérer :

```markdown
**Named in the pull request.** Every divergence from a block is named in the body
of the pull request Step 5 opens, and ruled on at the delivery review. A
divergence has only two legitimate causes:

- **`main` moved.** The passage a block quotes is no longer there as written,
  because another story or a bounded change landed on that section since the
  batch opened. Fit the block to what `main` now carries, without changing its
  meaning, and say in the pull request what you fitted and why.
- **The block's text is a problem.** Stop, and put it to your human partner
  before transcribing it. Do not transcribe a text you believe is wrong, and do
  not repair it on your own: the opening gate is where that text was ruled on,
  and reopening it is your human partner's act.

**Neither case amends the batch document.** It records what the opening review
read, and editing it would erase the very text a reviewer compares your
transcription against. The divergence lives in the pull request, where it is
visible and gets ruled on.
```

Puis, dans la table `Red Flags`, après la ligne `| "I'll write the whole batch delta now, it's more efficient" | … |`, ajouter :

```markdown
| "This block's wording is off, I'll improve it as I transcribe" | The opening gate ruled on that exact text. Transcribe it word for word, or stop and put the problem to your human partner. |
| "`main` moved, so I'll amend the batch document to match" | Fit the block to `main` without changing its meaning, and name the divergence in the pull request. The batch document records what the review read. |
```

- [ ] **Step 4: Lancer la suite et vérifier qu'elle est verte**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Commiter**

```bash
cat > /tmp/msg.txt <<'EOF'
feat: la transcription est mot pour mot, et tout écart est nommé dans la PR

Un écart n'a que deux causes légitimes : main qui a bougé, ou un texte de
bloc qui pose problème. Ni l'une ni l'autre n'amende le document de lot.

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

```bash
bash ~/.config/github-app/as-agent.sh git add skills/writing-a-user-story/SKILL.md tests/test-skill-content.sh
```

```bash
bash ~/.config/github-app/as-agent.sh git commit -F /tmp/msg.txt
```

---

### Task 4: Le devoir 5 de la clôture lit les déclarations `Blocks:`

Bloc **D5**. La clôture ne compare plus le delta annoncé au contenu des specs : elle lit ce que les stories ont déclaré.

**Files:**
- Modify: `skills/closing-a-batch/SKILL.md` — la section `### 5. Record blocks announced but never delivered`
- Test: `tests/test-skill-content.sh`
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: la graphie `Blocks:` de la tâche 2.
- Produces: rien.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh`, à la suite de la garde `require closing-a-batch "records undelivered blocks" …` déjà présente, ajouter :

```bash
require closing-a-batch "duty 5 reads the Blocks declarations"   "Read the \`Blocks:\` field of every story document in the batch directory"
require closing-a-batch "a block nobody declared is undelivered" "no collected declaration names is a block announced but never delivered"
require closing-a-batch "the directory holds the merged stories" "holds exactly the batch's merged stories"
require closing-a-batch "reads the declarations, not the specs"  "Read the declarations, not the specs"
```

Puis, dans `tests/test-skill-contracts.sh`, juste avant la ligne `exit $((FAILURES > 0))`, ajouter :

```bash
# The `Blocks:` field is one coupling with two ends: a story document declares it
# (spec section "The user story document"), and closing reads it to find the
# blocks nobody delivered (spec section "Closing a batch"). One assertion over
# both files — two separate ones would each stay green while one end renamed the
# field, which is the whole failure this locks out.
shared "both ends spell the Blocks field alike" \
    "\`Blocks:\`" \
    writing-a-user-story closing-a-batch
```

- [ ] **Step 2: Lancer les deux fichiers et vérifier que les cinq gardes échouent**

Run: `bash tests/test-skill-content.sh; bash tests/test-skill-contracts.sh`
Expected: FAIL sur les quatre libellés `closing-a-batch` ci-dessus, et FAIL sur `both ends spell the Blocks field alike` en nommant `closing-a-batch` comme le bout manquant. Rien d'autre en rouge — `writing-a-user-story` porte déjà le champ depuis la tâche 2.

- [ ] **Step 3: Écrire le texte**

Dans `skills/closing-a-batch/SKILL.md`, sous `### 5. Record blocks announced but never delivered`, remplacer la phrase `Compare the spec delta the batch announced at opening against what actually reached the specs. For everything **announced but never delivered** — story abandoned, scope cut along the way — do both of these:` par :

```markdown
Read the `Blocks:` field of every story document in the batch directory, and collect the `D<n>` identifiers they declare; a `none` declares nothing. **A block the batch document's `Spec delta` defines and that no collected declaration names is a block announced but never delivered** — story abandoned, scope cut along the way. For each one, do both of these:
```

Les deux points numérotés qui suivent, et le paragraphe `Both, not either. …`, restent tels quels. Après ce paragraphe, avant `**A corrective batch has nothing to compare here**`, insérer :

```markdown
**The batch directory on `main` holds exactly the batch's merged stories.** An artifact only reaches `main` when its pull request merges, and closing runs once every story is merged or abandoned — so an abandoned story left no document there, and there is nothing to subtract from what you collect.

**Read the declarations, not the specs.** A block fitted to a `main` that had moved is a block that was delivered, and its text in the spec no longer matches the batch document word for word. Diffing the specs against the delta would report it missing; the declaration reports it delivered, which is what it is. Judging a transcription is the delivery review's job, and it is already done.
```

- [ ] **Step 4: Lancer la suite et vérifier qu'elle est verte**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`

- [ ] **Step 5: Vérifier qu'aucune autre skill ne contredit ces quatre blocs**

Run: `grep -rn "three fields\|announced at opening\|Incremental\|part of the batch's spec delta" skills/`
Expected: aucune occurrence. Ce sont les formulations que les quatre tâches remplacent ; une survivante ailleurs serait une skill qui contredit la spec fusionnée.

Puis :

Run: `grep -rn "Blocks:" skills/`
Expected: des occurrences dans `writing-a-user-story/SKILL.md` et `closing-a-batch/SKILL.md`, et nulle part ailleurs.

Si l'une des deux vérifications remonte quelque chose, corriger la formulation dans la même tâche et relancer `bash tests/run-all.sh`.

- [ ] **Step 6: Commiter**

```bash
cat > /tmp/msg.txt <<'EOF'
feat: la clôture constate les blocs non livrés depuis les champs Blocks:

Elle lit les déclarations des stories fusionnées, et non plus le contenu
des specs : un bloc ajusté à un main qui avait bougé reste un bloc livré.

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

```bash
bash ~/.config/github-app/as-agent.sh git add skills/closing-a-batch/SKILL.md tests/test-skill-content.sh tests/test-skill-contracts.sh
```

```bash
bash ~/.config/github-app/as-agent.sh git commit -F /tmp/msg.txt
```

---

## Rulings log

## Observed drift
