# La fin d'une revue a une forme — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Donner une forme à la fin de chaque revue — l'agent n'approuve ni ne
fusionne, les corrections se poussent en `fixup!`, et la fusion d'une revue qui
fait d'un document la référence est un moment de vider le contexte.

**Architecture:** Le bloc D9 est déjà transcrit dans `Authority and conflict
rules` de la spec : c'est le premier commit de cette branche. Le travail restant
porte les trois normes de ce bloc dans les cinq skills, chacune là où elle
conclut sa revue, puis les verrouille par des gardes structurelles. La norme
partagée s'énonce une fois dans `using-batches`, qui porte déjà la table des
revues ; chaque skill de revue dit ensuite ce qui la concerne — l'étape suivante
qu'elle nomme et le prompt qu'elle donne — et `closing-a-batch` dit qu'elle n'est
**pas** un moment de clear, ce qui est la seule façon de rendre l'exception
lisible.

**Tech Stack:** Markdown (skills, spec, document de lot), bash (`tests/*.sh`,
assertions par `require` et `shared` sur le corps aplati des SKILL.md).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/04-la-spec-avant-le-code/README.md
**Sections:** Authority and conflict rules
**Blocks:** D9

## Global Constraints

Le gel du fichier de spec :

> Entre le commit de transcription et l'ouverture de la pull request, aucune tâche
> ne modifie le fichier de spec. Une story qui découvre que la spec doit changer
> s'arrête.

`docs/specs/supercharlouze.md` porte déjà la transcription de D9, faite avant ce
plan. Aucune tâche de ce plan ne le rouvre.

**Quand un lot et une spec se contredisent, la spec gagne — sans exception et
sans délibération.** Implémente ce que dit la spec, consigne un `Ruling:`, et
poursuis. **Corriger une spec en cours de lot est un acte humain, jamais un acte
d'agent.**

Les contraintes du lot, recopiées verbatim :

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

Deux d'entre elles décident du contour de cette story : la dernière — cette story
prend D9, pas D2, donc **elle ne touche pas le gaps register** — et « ne rien
aligner en silence ».

---

## File Structure

| Fichier | Responsabilité dans cette story |
|---|---|
| `docs/specs/supercharlouze.md` | Porte D9 dans `Authority and conflict rules`. **Déjà commité, gelé.** |
| `skills/using-batches/SKILL.md` | Énonce les trois normes une fois, sous la table des gates. |
| `skills/adopting-a-module/SKILL.md` | Fin de la revue d'adoption : étape suivante et prompt. |
| `skills/writing-a-batch/SKILL.md` | Fin des revues d'ouverture et d'amendement : étape suivante et prompt. |
| `skills/writing-a-user-story/SKILL.md` | Fin de la revue de livraison : étape suivante et prompt. |
| `skills/closing-a-batch/SKILL.md` | Dit que la revue de clôture n'est **pas** un moment de clear. |
| `tests/test-skill-contracts.sh` | Garde partagée : les normes que toutes les skills de revue portent. |
| `tests/test-skill-content.sh` | Gardes par skill : l'étape suivante nommée, le prompt, l'exception de clôture. |

**Les deux fichiers de test se répartissent par nature d'assertion, pas par
commodité.** `test-skill-contracts.sh` porte `shared()`, qui vérifie une même
chaîne dans plusieurs skills en une seule assertion — c'est ce qu'il faut pour
une norme dont les extrémités doivent s'écrire à l'identique, parce que des
assertions séparées resteraient vertes pendant qu'une extrémité dérive.
`test-skill-content.sh` porte `require()`, une skill une assertion — c'est ce
qu'il faut pour ce qui est propre à chaque revue.

**Les couplages `shared` s'écrivent dans la dernière tâche, et c'est un choix,
pas une négligence.** Une assertion qui porte sur cinq fichiers ne peut pas
verdir tant que les cinq ne sont pas écrits ; posée en tâche 1, elle resterait
rouge pendant quatre tâches, et une suite sciemment rouge sur quatre revues est
une suite que le cinquième relecteur n'interroge plus. Posée en tâche 5 **avant**
que les deux derniers fichiers soient écrits, elle est rouge pour la bonne
raison, puis verte — le cycle normal, sans fenêtre. Chaque tâche garde donc sa
propre `require`, rouge puis verte en son sein.

---

## Task 1: La norme partagée dans `using-batches`

**Files:**
- Modify: `skills/using-batches/SKILL.md` — section `Authority and Conflict Rules`, après la table des gates
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Produces: les trois chaînes littérales que toutes les tâches suivantes
  réutilisent **mot pour mot** dans les autres skills :
  - `never approves and never merges a pull request`
  - `pushed as a `fixup!` commit`
  - `a moment to clear the context`

Ces trois chaînes sont le contrat de ce plan. Ne les reformule dans aucune tâche :
la tâche 5 pose sur elles des assertions `shared()` qui portent sur cinq fichiers
à la fois, et une skill qui énonce la même norme avec d'autres mots les fait
échouer sans qu'on voie laquelle a dérivé.

**Contexte pour l'implémenteur.** `skills/using-batches/SKILL.md` porte, dans
`Authority and Conflict Rules`, la table « Gate / Artifact reviewed ». Les trois
normes s'ajoutent juste après cette table, dans le même ordre que dans la spec :
l'agent n'approuve ni ne fusionne, la branche n'est pas réécrite pendant la
revue, la fusion est un moment de clear. La skill est **intégralement anglaise** —
c'est la règle `Language` de ce plugin, qui n'a pas de prose métier. La spec, elle,
est en français : tu transposes le sens, tu ne traduis pas mot à mot une phrase de
spec dans une skill.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh`, ajouter un bloc `using-batches` :

```bash
# --- using-batches: the shape of a review's end ---
require using-batches "forbids the agent approving or merging" "never approves and never merges a pull request"
require using-batches "pushes corrections as fixups"           "pushed as a \`fixup!\` commit"
require using-batches "the agreement is given in conversation" "The human gives their agreement in the conversation"
```

- [ ] **Step 2: Lancer les gardes et vérifier qu'elles échouent**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — trois lignes `[FAIL] using-batches: ...`.

Si l'une passe du premier coup, arrête-toi : la chaîne est déjà quelque part et
cette garde ne garde rien.

- [ ] **Step 3: Écrire la norme dans `using-batches`**

Dans `skills/using-batches/SKILL.md`, juste après la table des gates, ajouter :

```markdown
**The agent never approves and never merges a pull request.** Approving and
merging are human acts, at every gate in the table above without exception.

**During a review the branch is not rewritten.** Each requested correction is
pushed as a `fixup!` commit of the commit it corrects, or as a commit of its own
when it carries a fresh decision, so that the human sees on the pull request what
changed since they last read it. **The human gives their agreement in the
conversation**, not through a GitHub approval. The agent then squashes the
`fixup!` commits into the commits they correct, pushes the rewritten branch, and
announces that the pull request is ready to be approved and merged.

Rewriting earlier would destroy what the review is reading. A force-push that
lands mid-review replaces the commits the human has comments on, and their
comments come back attached to nothing.
```

- [ ] **Step 4: Lancer les gardes et vérifier qu'elles passent**

Run: `bash tests/test-skill-content.sh`
Expected: les trois assertions `using-batches` passent.

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F- <<'EOF'
feat: l'agent n'approuve ni ne fusionne, et ne réécrit pas pendant la revue

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

## Task 2: Le moment de vider le contexte, énoncé dans `using-batches`

**Files:**
- Modify: `skills/using-batches/SKILL.md` — à la suite de ce qu'a écrit la tâche 1
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: la norme écrite par la tâche 1, juste au-dessus.
- Produces: la chaîne `a moment to clear the context`, et la forme du prompt que
  les tâches 3 à 5 donnent chacune pour leur étape suivante.

**Contexte pour l'implémenteur.** Cette norme se sépare de la précédente sur un
point : elle ne vaut pas pour les cinq revues. La clôture en est exclue, parce que
rien ne la suit. C'est pourquoi le `shared` que posera la tâche 5 portera sur
**quatre** skills et non cinq, et pourquoi la tâche 5 écrira l'exception
explicitement dans `closing-a-batch`.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh`, à la suite des `require using-batches` de la
tâche 1 :

```bash
require using-batches "names the merge a clear moment"      "a moment to clear the context"
require using-batches "excludes the closing review from it" "Merging a closing review is not one"
require using-batches "the handover prompt stands alone"    "That prompt stands on its own"
```

- [ ] **Step 2: Lancer les gardes et vérifier qu'elles échouent**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — trois lignes `[FAIL] using-batches: ...`.

- [ ] **Step 3: Écrire la norme**

Dans `skills/using-batches/SKILL.md`, à la suite du texte de la tâche 1 :

```markdown
**Merging an adoption, opening, delivery or amendment review is a moment to clear
the context.** The merged document then carries everything the next step needs,
and the conversation is only a draft that can contradict it. Merging a closing
review is not one: nothing follows it.

The agent cannot clear its own context. So when it announces the pull request
ready, it says that merging it will be that moment, names the next step, and
gives — in a block to copy and paste — the prompt that starts that step after the
clear. **That prompt stands on its own:** it names the skill to invoke and the
document to start from, and never refers back to the conversation.

"Never refers back to the conversation" is the whole point. A prompt saying
"continue what we discussed" is worthless after a clear, and it is worthless in a
way nobody notices until the context is already gone.
```

- [ ] **Step 4: Lancer les gardes et vérifier qu'elles passent**

Run: `bash tests/test-skill-content.sh`
Expected: les six assertions `using-batches` passent.

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills/using-batches/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F- <<'EOF'
feat: la fusion d'une revue est un moment de vider le contexte

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

## Task 3: La fin de la revue d'adoption

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md` — section `7. Open the adoption pull request`, à la fin
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: les trois chaînes de contrat des tâches 1 et 2.
- Produces: rien que les tâches suivantes consomment.

**Contexte pour l'implémenteur.** La section `7. Open the adoption pull request`
se termine aujourd'hui sur « An open adoption pull request is not adoption; do not
start `supercharlouze:writing-a-batch` on the strength of one. » Le texte s'ajoute
après cette phrase. L'étape suivante d'une adoption est la **conception du lot**,
donc `supercharlouze:writing-a-batch`, et le document d'où repartir est la spec
fraîchement adoptée.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh`, dans le bloc `adopting-a-module` :

```bash
require adopting-a-module "ends the review as every gate does"   "never approves and never merges a pull request"
require adopting-a-module "pushes corrections as fixups"         "pushed as a \`fixup!\` commit"
require adopting-a-module "names the merge a clear moment"       "a moment to clear the context"
require adopting-a-module "names the next step after the clear"  "names \`supercharlouze:writing-a-batch\` as the next step"
require adopting-a-module "hands over a self-contained prompt"   "the prompt names the adopted spec by path"
```

- [ ] **Step 2: Lancer les gardes et vérifier qu'elles échouent**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — cinq lignes `[FAIL] adopting-a-module: ...`.

- [ ] **Step 3: Écrire le texte**

À la fin de `### 7. Open the adoption pull request`, ajouter :

```markdown
**Ending the review.** The agent never approves and never merges a pull request,
here as at every gate. Each correction the review asks for is pushed as a
`fixup!` commit of the commit it corrects; your human partner gives their
agreement in the conversation, and only then do you squash the fixups, push, and
announce the pull request ready.

**Merging this pull request is a moment to clear the context**, and announcing it
ready is where you say so. The adoption conversation carried an inventory,
rulings and a boundary argument that the merged documents now carry better than
it does — and worse, it carried every mechanism you read while auditing the code,
which is exactly what must not leak into the batch that follows.

So the announcement names `supercharlouze:writing-a-batch` as the next step, and
gives the prompt for it in a block to copy and paste after the clear. **That
prompt stands on its own:** the prompt names the adopted spec by path, and the
gaps register beside it, and never refers back to this conversation.
```

- [ ] **Step 4: Lancer les gardes et vérifier qu'elles passent**

Run: `bash tests/test-skill-content.sh`
Expected: les cinq nouvelles assertions `adopting-a-module` passent.

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills/adopting-a-module/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F- <<'EOF'
feat: la revue d'adoption se termine sur un prompt qui se suffit

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

## Task 4: La fin des revues d'ouverture et d'amendement

**Files:**
- Modify: `skills/writing-a-batch/SKILL.md` — sections `Opening the Pull Request` et `Amending a Batch`, à la fin de chacune
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: les trois chaînes de contrat des tâches 1 et 2.
- Produces: rien que les tâches suivantes consomment.

**Contexte pour l'implémenteur.** Cette skill porte **deux** revues, et c'est la
seule dans ce cas : l'ouverture et l'amendement. Les deux sont des moments de
clear, et elles ne nomment pas la même étape suivante — l'ouverture enchaîne sur
la première story, l'amendement rend la main à ce que le lot faisait. Écris les
deux ; n'en écris pas une en laissant l'autre se débrouiller.

`Opening the Pull Request` se termine sur « …into the one where you already review
everything else. » `Amending a Batch` se termine sur « …it is an explicit human
decision that goes through a review. »

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh`, dans le bloc `writing-a-batch` :

```bash
require writing-a-batch "ends the review as every gate does"      "never approves and never merges a pull request"
require writing-a-batch "pushes corrections as fixups"            "pushed as a \`fixup!\` commit"
require writing-a-batch "names the merge a clear moment"          "a moment to clear the context"
require writing-a-batch "opening hands over to the first story"   "names \`supercharlouze:writing-a-user-story\` as the next step"
require writing-a-batch "an amendment is a clear moment too"      "An amendment merges into the same clear moment"
```

- [ ] **Step 2: Lancer les gardes et vérifier qu'elles échouent**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — cinq lignes `[FAIL] writing-a-batch: ...`.

- [ ] **Step 3: Écrire le texte de l'ouverture**

À la fin de `## Opening the Pull Request`, ajouter :

```markdown
**Ending the review.** The agent never approves and never merges a pull request.
Each correction the review asks for is pushed as a `fixup!` commit of the commit
it corrects — the block texts are what the human is reading, and a force-push
mid-review replaces the very lines their comments hang on. Your human partner
gives their agreement in the conversation; then you squash the fixups, push, and
announce the pull request ready.

**Merging this pull request is a moment to clear the context.** The batch
document now carries the exact text of every block, which is what the design
conversation was for — and that conversation also carries every option you
discarded on the way, which the first story must not inherit.

The announcement therefore names `supercharlouze:writing-a-user-story` as the
next step and gives its prompt in a block to copy and paste. **That prompt stands
on its own:** it names the batch document by path and says to choose the blocks
from those the document still carries, and it never refers back to this
conversation.
```

- [ ] **Step 4: Écrire le texte de l'amendement**

À la fin de `## Amending a Batch`, ajouter :

```markdown
**An amendment merges into the same clear moment as an opening**, and ends its
review the same way: fixups during the review, agreement in the conversation,
squash, and an announcement that names the next step. What differs is which step
that is — an amendment hands back to whatever the batch was doing when it stopped,
so the announcement names that, and its prompt names the amended batch document
by path.
```

- [ ] **Step 5: Lancer les gardes et vérifier qu'elles passent**

Run: `bash tests/test-skill-content.sh`
Expected: les cinq nouvelles assertions `writing-a-batch` passent.

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-batch/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F- <<'EOF'
feat: les revues d'ouverture et d'amendement nomment leur étape suivante

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

## Task 5: La fin de la revue de livraison, et l'exception de la clôture

**Files:**
- Modify: `skills/writing-a-user-story/SKILL.md` — section `Step 7 — Answer the Review`
- Modify: `skills/closing-a-batch/SKILL.md` — section `6. Set status: closed`
- Test: `tests/test-skill-content.sh`
- Test: `tests/test-skill-contracts.sh`

**Interfaces:**
- Consumes: les trois chaînes de contrat des tâches 1 et 2.
- Produces: la fin du plan. Cette tâche est aussi celle qui **verrouille** le
  couplage entre les cinq skills : trois d'entre elles portent déjà les chaînes,
  deux non, donc les `shared` posés à l'étape 1 sont rouges pour la bonne raison
  avant de verdir à l'étape 5.

**Contexte pour l'implémenteur.** Les deux fichiers vont ensemble parce qu'ils
portent les deux faces d'une même distinction : la livraison **est** un moment de
clear, la clôture **n'en est pas** un. Séparés en deux tâches, le second serait un
commit qui n'ajoute qu'une négation, et un relecteur ne verrait pas contre quoi
elle s'oppose.

Dans `writing-a-user-story`, le texte s'insère après « its state *is* the state of
its pull request. » et avant le paragraphe `**Abandoning is almost free.**` — la
fin de la section parle d'abandon, et la fin de revue n'a rien à voir avec elle.

Dans `closing-a-batch`, le texte s'ajoute à la fin de `### 6. Set status: closed`.

- [ ] **Step 1: Écrire les gardes qui échouent**

Dans `tests/test-skill-content.sh` :

```bash
require writing-a-user-story "ends the review as every gate does"   "never approves and never merges a pull request"
require writing-a-user-story "pushes corrections as fixups"         "pushed as a \`fixup!\` commit"
require writing-a-user-story "names the merge a clear moment"       "a moment to clear the context"
require writing-a-user-story "hands over to the next story"         "names the next story as the next step"

require closing-a-batch "ends the review as every gate does"  "never approves and never merges a pull request"
require closing-a-batch "pushes corrections as fixups"        "pushed as a \`fixup!\` commit"
require closing-a-batch "denies being a clear moment"         "Merging a closing review is not a moment to clear the context"
```

Puis, dans `tests/test-skill-contracts.sh`, à la suite des `shared` existants —
c'est le verrou du couplage, et il vient **après** les `require` parce qu'il
répond à une autre question : non pas « chaque skill le dit-elle ? » mais « le
disent-elles toutes dans les mêmes mots ? » :

```bash
# The end of a review is one norm with five ends. `shared` and not five `require`
# calls: separate assertions would each stay green while one skill drifted away
# from the wording the others use, and a skill that says "the agent may merge
# once approved" would contradict the spec with its own test passing.
shared "every review-ending skill forbids the agent approving or merging" \
    "never approves and never merges a pull request" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

shared "every review-ending skill pushes corrections as fixup! commits" \
    "pushed as a \`fixup!\` commit" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

# Four skills, not five: a closing review is followed by nothing, so it is not a
# clear moment. `closing-a-batch` carries the exception instead, guarded by the
# `require` above. Listing it here would demand of it the very sentence it exists
# to deny — and it would pass, because its denial contains the phrase.
shared "every clear-moment skill names the merge as one" \
    "a moment to clear the context" \
    using-batches adopting-a-module writing-a-batch writing-a-user-story
```

- [ ] **Step 2: Lancer les gardes et vérifier qu'elles échouent**

Run: `bash tests/test-skill-content.sh`
Expected: FAIL — quatre lignes `writing-a-user-story` et trois lignes
`closing-a-batch`.

Run: `bash tests/test-skill-contracts.sh`
Expected: FAIL — les deux premiers `shared` listent `missing in:
writing-a-user-story closing-a-batch`, le troisième `missing in:
writing-a-user-story`.

- [ ] **Step 3: Écrire le texte de la livraison**

Dans `skills/writing-a-user-story/SKILL.md`, après « its state *is* the state of
its pull request. » :

```markdown
**Ending the review.** The agent never approves and never merges a pull request.
Each correction is pushed as a `fixup!` commit of the commit it corrects — or as
a commit of its own when it carries a fresh decision, which on this path is
common: a review that changes the wording of the spec change is deciding
something, not fixing a slip. Your human partner gives their agreement in the
conversation; then you squash the fixups, push the rewritten branch, and announce
the pull request ready to be approved and merged.

**Merging it is a moment to clear the context**, and the announcement says so. On
this path the conversation is the heaviest of any gate — it carries a plan, an
SDD ledger, and every file the implementers touched — while `main` now carries the
spec change and the code together, which is all the next story needs.

So the announcement names the next story as the next step, and gives its prompt in
a block to copy and paste. **That prompt stands on its own:** it names the batch
document by path and says to choose from the blocks it still carries, and never
refers back to this conversation. Everything perishable is already in the story
document — that is what `Step 6 — Record Before the Merge` was for.
```

- [ ] **Step 4: Écrire le texte de la clôture**

À la fin de `### 6. Set status: closed` dans `skills/closing-a-batch/SKILL.md` :

```markdown
**Ending the review.** The agent never approves and never merges a pull request. Each correction is pushed as a `fixup!` commit of the commit it corrects; your human partner gives their agreement in the conversation, and only then do you squash the fixups, push, and announce the pull request ready.

**Merging a closing review is not a moment to clear the context**, and this is the one gate where that is true. The other four hand a merged document to a next step that must read it with fresh eyes. Closing hands over to nothing — the batch is done, and the residue it collected has already gone into the gaps registers and the changelog lines. So the announcement says the pull request is ready, names the next step as none, and gives no prompt. Offering one here would invent a step the model does not have.
```

Note l'absence de retour à la ligne à 80 colonnes : `closing-a-batch/SKILL.md`
écrit ses paragraphes sur une seule ligne. Suis le fichier que tu modifies, pas
les autres.

- [ ] **Step 5: Lancer toutes les gardes et vérifier qu'elles passent**

Run: `bash tests/test-skill-content.sh`
Expected: PASS sur les sept nouvelles assertions.

Run: `bash tests/test-skill-contracts.sh`
Expected: **PASS** — les trois `shared` verdissent, les cinq skills étant
désormais écrites.

Run: `bash tests/run-all.sh`
Expected: `all tests passed`.

Si `test-cross-references.sh` ou `test-declared-overrides.sh` échoue, ne le
contourne pas : un renvoi que tu as écrit nomme une section qui n'existe pas, ou
compte un numéro au lieu de la nommer. Corrige le renvoi.

- [ ] **Step 6: Commit**

```bash
git add skills/writing-a-user-story/SKILL.md skills/closing-a-batch/SKILL.md \
        tests/test-skill-content.sh tests/test-skill-contracts.sh
bash ~/.config/github-app/as-agent.sh git commit -F- <<'EOF'
feat: la livraison est un moment de clear, la clôture n'en est pas un

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
```

---

## Rulings log

## Observed drift
