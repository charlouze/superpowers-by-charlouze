# Corriger une spec jugée fausse Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Un changement borné porte, sans toucher au code, la correction d'une spec que l'humain juge fausse, y compris quand la condition d'arrêt d'un lot correctif s'est déclenchée.

**Architecture:** `making-a-bounded-change` reçoit l'exception dans sa règle (a), et `using-batches`, la description de la skill et le `README` y mènent. `handling-a-stopped-story` confie la correction à ce changement borné, après l'amendement qui réduit le périmètre du lot et qui transmet l'étape suivante. Chaque norme a sa garde dans `tests/`, écrite avant le texte.

**Tech Stack:** Markdown pour les skills, Bash pour les gardes de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** Batch > Amending a batch, Bounded change
**Blocks:** D2, D3

## Global Constraints

Avant de commencer, lis `skills/following-the-rules/SKILL.md` dans ce worktree : il porte les règles d'exécution. Ne l'invoque pas comme skill, la version installée du plugin ne l'a pas.

### Les contraintes du lot

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

### Le gel du fichier de spec

> Between the first commit of the branch and the opening of the pull request, no
> task modifies the spec file. A story that discovers the spec must change stops.

### L'autorité

Quand le lot et la spec se contredisent, la spec gagne : implémente ce qu'elle dit, consigne un `Ruling:`, et poursuis. Seul l'humain corrige une spec en cours de lot.

### La concision

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

### Une contrainte ou un ADR intenable

> If, while conducting a story, you discover that a constraint of its batch or an ADR cannot be held, stop and put it to your human partner.
>
> A constraint the spec contradicts does not fall under this condition: the spec wins.

### Les ADR tenus

> The code this story writes holds these ADRs.

- `docs/adr/une-skill-par-moment-d-invocation.md`

### Une décision qui mérite un ADR

> A technical decision is recorded as an ADR only if it meets these conditions:
>
> - undoing it is expensive;
> - it surprises whoever does not know its context;
> - it settles between real alternatives.
>
> When you take a technical decision that meets them, say so in your report: it
> is recorded as an `Open ruling:`, which asks your human partner whether they
> want it as an ADR. Write nothing in `docs/adr/`.

### Ce poste

- Toute commande `git` qui écrit un commit ou parle au remote passe par `bash ~/.config/github-app/as-agent.sh git …`, y compris `rebase`, `commit --amend` et `cherry-pick`.
- Un commit se termine par `Co-Authored-By: Charlouze <me@charlouze.com>` et par aucune autre ligne d'attribution.
- Ni `python` ni `node`. L'outil Bash mange les barres obliques inverses dans les heredocs et les `sed` en ligne : écris les fichiers avec l'outil d'édition de fichiers.
- Les `SKILL.md` gardent des fins de ligne LF.
- La suite entière se lance par `bash tests/run-all.sh`, prend environ trois minutes, et demande un délai de cinq minutes. Un seul fichier se lance par `bash tests/test-skill-content.sh`.
- Une skill est entièrement anglaise et ne cite aucune section de `docs/specs/supercharlouze.md`.
- Montre l'étape rouge de chaque garde dans ton rapport.
- Une correction d'un commit de cette story est un `fixup!` de ce commit.

## Review Focus

- Un agent qui juge lui-même une spec fausse : la skill réserve le jugement et la correction à l'humain, et son red flag le redit.
- Un changement borné qui corrige une spec et retouche le code : la skill dit qu'il ne touche pas au code.
- Une correction de spec qui règle une entrée du gaps register : la skill fait supprimer l'entrée dans la même pull request.
- Une correction de spec écrite sans passer par `writing-in-a-spec` : la phrase d'invocation suit l'exception et vaut pour elle.
- Le prompt de la décision « la spec est corrigée » : il nomme deux étapes, chacune avec sa skill et son document, et aucune n'est laissée à l'humain.

---

### Task 1: Un changement borné porte la correction d'une spec jugée fausse

**Files:**
- Modify: `skills/making-a-bounded-change/SKILL.md`
- Modify: `skills/using-batches/SKILL.md` (table de routage)
- Modify: `README.md` (section `What stays outside a batch`, tableau `Skills`)
- Test: `tests/test-skill-content.sh`, `tests/test-skill-contracts.sh`, `tests/test-cross-references.sh`

**Interfaces:**
- Consumes: rien.
- Produces: la skill `supercharlouze:making-a-bounded-change` porte la correction d'une spec que l'humain juge fausse ; la tâche 2 la nomme dans `handling-a-stopped-story`.

- [ ] **Step 1: Écris les gardes**

Dans `tests/test-skill-content.sh`, juste après la garde `"red flag: a small fix that leaves the spec silent"` (ses deux lignes), ajoute :

```bash
require making-a-bounded-change "a bounded change carries the correction of a spec the human judges wrong" \
        "**Exception: when your human partner judges that a spec is wrong and the code is right, it carries the spec correction they decide, and touches no code.**"
require making-a-bounded-change "the judgment and the correction are the human's" \
        "Both the judgment and the correction are your human partner's: a correction you derive from the code alone canonises the drift it describes."
require making-a-bounded-change "a correction removes the gaps register entry it settles" \
        "When the correction settles a gaps register entry, remove that entry under rule (d)."
require making-a-bounded-change "the invocation of writing-in-a-spec follows the exception" \
        "remove that entry under rule (d). When it updates a spec, invoke \`supercharlouze:writing-in-a-spec\` before writing in it."
require making-a-bounded-change "none is the declaration of a change that writes in no spec" \
        "it is what a bounded change that writes in no spec has to say"
require making-a-bounded-change "red flag: the agent does not judge a spec wrong" \
        "| \"The code is right and the spec is plainly wrong, I'll correct the spec\" | Only your human partner judges a spec wrong, and they decide the correction. Put it to them, and write nothing in the spec until they have decided. |"
require making-a-bounded-change "red flag: a spec correction touches no code" \
        "| \"While I correct the spec, I'll tidy the code it describes\" | A spec correction touches no code: the code is what your human partner judged right. A code change is another bounded change. |"
case "$(skill_front making-a-bounded-change)" in
    *"a spec your human partner judges wrong where the code is right"*)
        pass "making-a-bounded-change: the description names the spec judged wrong" ;;
    *)  fail "making-a-bounded-change: the description names the spec judged wrong" ;;
esac
```

Dans `tests/test-skill-contracts.sh`, juste après la garde `"the routing table leads bounded work to making-a-bounded-change"` (ses deux lignes), ajoute :

```bash
require using-batches "the routing table leads a spec judged wrong to making-a-bounded-change" \
    "| Your human partner judges that a spec is wrong and the code is right | \`supercharlouze:making-a-bounded-change\` |"
```

Dans `tests/test-cross-references.sh`, remplace dans le `case "$MROW"` le motif

```bash
    *"A well-scoped change that needs no batch, or an ADR to write, rewrite or delete outside a batch"*)
```

par

```bash
    *"A well-scoped change that needs no batch, a spec the human judges wrong where the code is right, or an ADR to write, rewrite or delete outside a batch"*)
```

et ajoute, juste après le `esac` de ce `case` :

```bash

# The README states the exception of the bounded change: the correction of a
# spec the human judges wrong. Read flattened, since the README wraps.
if tr '\n' ' ' < "$REPO_ROOT/README.md" | tr -s ' ' | grep -qF "it carries, without touching the code, the correction of a spec the human judges wrong where the code is right"; then
    pass "the README states the spec correction a bounded change carries"
else
    fail "the README states the spec correction a bounded change carries"
fi
```

- [ ] **Step 2: Lance les gardes et constate le rouge**

Run: `bash tests/test-skill-content.sh | grep FAIL; bash tests/test-skill-contracts.sh | grep FAIL; bash tests/test-cross-references.sh | grep FAIL`
Expected: onze `[FAIL]`, les huit de `test-skill-content.sh`, celui de `test-skill-contracts.sh` et les deux de `test-cross-references.sh`, et aucun autre.

- [ ] **Step 3: Écris l'exception dans `skills/making-a-bounded-change/SKILL.md`**

Dans le front matter, remplace dans `description:`

```
a well-scoped change that needs no batch, or an ADR your human partner wants written, rewritten or deleted outside a batch
```

par

```
a well-scoped change that needs no batch, a spec your human partner judges wrong where the code is right, or an ADR your human partner wants written, rewritten or deleted outside a batch
```

Dans la règle (a), retire la dernière phrase de la puce, ` When it updates a spec, invoke `supercharlouze:writing-in-a-spec` before writing in it.` : la puce finit sur « which canonises the drift it describes. ». Puis ajoute, entre la puce (a) et la puce (b), ces deux paragraphes en retrait de deux espaces, chacun précédé d'une ligne vide, et une ligne vide avant la puce (b) :

```markdown

  **Exception: when your human partner judges that a spec is wrong and the code is right, it carries the spec correction they decide, and touches no code.** Both the judgment and the correction are your human partner's: a correction you derive from the code alone canonises the drift it describes. When the correction settles a gaps register entry, remove that entry under rule (d).

  When it updates a spec, invoke `supercharlouze:writing-in-a-spec` before writing in it.

```

Dans la règle (b), remplace

```
it is what a bounded change that changes nothing observable has to say
```

par

```
it is what a bounded change that writes in no spec has to say
```

Dans le tableau `Red Flags`, ajoute ces deux lignes à la fin :

```markdown
| "The code is right and the spec is plainly wrong, I'll correct the spec" | Only your human partner judges a spec wrong, and they decide the correction. Put it to them, and write nothing in the spec until they have decided. |
| "While I correct the spec, I'll tidy the code it describes" | A spec correction touches no code: the code is what your human partner judged right. A code change is another bounded change. |
```

- [ ] **Step 4: Ajoute la ligne de routage dans `skills/using-batches/SKILL.md`**

Dans la table `Route by situation`, juste avant la ligne `| Bounded work | …`, ajoute :

```markdown
| Your human partner judges that a spec is wrong and the code is right | `supercharlouze:making-a-bounded-change` |
```

- [ ] **Step 5: Mets le `README.md` à jour**

Dans le tableau `Skills`, la ligne de `supercharlouze:making-a-bounded-change` devient :

```markdown
| `supercharlouze:making-a-bounded-change` | A well-scoped change that needs no batch, a spec the human judges wrong where the code is right, or an ADR to write, rewrite or delete outside a batch |
```

Dans `What stays outside a batch`, après « and says nothing there only when nothing does; », insère « it carries, without touching the code, the correction of a spec the human judges wrong where the code is right; » et recoupe le paragraphe à 80 colonnes sans changer ses autres mots.

- [ ] **Step 6: Lance la suite entière**

Run: `bash tests/run-all.sh | grep -c PASS; bash tests/run-all.sh | grep FAIL; bash tests/run-all.sh | tail -1`
Expected: 1464 `[PASS]`, aucun `[FAIL]`, `all tests passed`.

- [ ] **Step 7: Commit**

```bash
git add skills/making-a-bounded-change/SKILL.md skills/using-batches/SKILL.md README.md tests/test-skill-content.sh tests/test-skill-contracts.sh tests/test-cross-references.sh
bash ~/.config/github-app/as-agent.sh git commit -F <fichier de message>
```

Message :

```
feat: un changement borné porte la correction d'une spec que l'humain juge fausse

Co-Authored-By: Charlouze <me@charlouze.com>
```

### Task 2: La correction d'une spec après l'arrêt d'un lot correctif passe par un changement borné

**Files:**
- Modify: `skills/handling-a-stopped-story/SKILL.md`
- Test: `tests/test-skill-content.sh`

**Interfaces:**
- Consumes: `supercharlouze:making-a-bounded-change`, qui porte la correction d'une spec que l'humain juge fausse (tâche 1) ; `supercharlouze:amending-a-batch`, qui transmet à la fin de sa revue l'étape que son prompt nomme après lui.
- Produces: rien.

- [ ] **Step 1: Écris les gardes**

Dans `tests/test-skill-content.sh`, sous « handling-a-stopped-story: what follows a stop condition » :

Remplace la garde `"the prompt states the ruling, then each step with its skill and its document"` par :

```bash
require handling-a-stopped-story "the prompt states the ruling, then each step with its skill and its document" \
    "It states the ruling, then the steps of its row below, in their order, each with the skill to invoke and the document it starts from, by its path. State the ruling as your human partner gave it"
```

Remplace la garde `"a corrected spec comes with a reduced scope"` par :

```bash
require handling-a-stopped-story "a corrected spec comes with a reduced scope" \
    "| The spec is corrected, and the batch stays corrective on a reduced scope | \`supercharlouze:amending-a-batch\` reduces the \`Scope\`, from the batch document. Then \`supercharlouze:making-a-bounded-change\` carries the correction your human partner decided, from the spec. |"
```

Ajoute, juste après la garde `"requalification offers a different batch"` :

```bash
require handling-a-stopped-story "requalification offers a spec correction carried by a bounded change" \
    "- **Correct the spec**: a bounded change carries the correction they decide, and an amendment reduces the scope of the batch, which stays corrective;"
```

Ajoute, juste après la garde `"the red flag keeps the ruling with the human"` :

```bash
absent_everywhere "no step of a ruling is left to the human" \
    "named as theirs|ships through its own pull request|corrects the spec, through a pull request of its own"
```

- [ ] **Step 2: Lance les gardes et constate le rouge**

Run: `bash tests/test-skill-content.sh | grep FAIL`
Expected: quatre `[FAIL]`, ceux des quatre gardes ci-dessus, et aucun autre.

- [ ] **Step 3: Réécris `skills/handling-a-stopped-story/SKILL.md`**

Dans `Requalifying a Corrective Batch`, étape 2, remplace la puce

```markdown
   - **Correct the spec**: the batch stays corrective, on a reduced scope,
     and the corrected spec ships through its own pull request;
```

par

```markdown
   - **Correct the spec**: a bounded change carries the correction they decide,
     and an amendment reduces the scope of the batch, which stays corrective;
```

Dans `What the Ruling Asks For`, étape 2, retire la phrase « A step the row gives to your human partner is named as theirs. » : l'étape finit sur « by its path. », recoupée à 80 colonnes.

Dans le tableau de la même section, la première ligne devient :

```markdown
| The spec is corrected, and the batch stays corrective on a reduced scope | `supercharlouze:amending-a-batch` reduces the `Scope`, from the batch document. Then `supercharlouze:making-a-bounded-change` carries the correction your human partner decided, from the spec. |
```

- [ ] **Step 4: Lance la suite entière**

Run: `bash tests/run-all.sh | grep -c PASS; bash tests/run-all.sh | grep FAIL; bash tests/run-all.sh | tail -1`
Expected: 1466 `[PASS]`, aucun `[FAIL]`, `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add skills/handling-a-stopped-story/SKILL.md tests/test-skill-content.sh
bash ~/.config/github-app/as-agent.sh git commit -F <fichier de message>
```

Message :

```
feat: la correction d'une spec après l'arrêt d'un lot correctif passe par un changement borné

Co-Authored-By: Charlouze <me@charlouze.com>
```

## Rulings log

- Ruling: après la décision de corriger la spec, l'amendement qui réduit le périmètre précède le changement borné qui porte la correction — la spec n'ordonne pas les deux, `amending-a-batch` transmet déjà à la fin de sa revue l'étape que son prompt nomme après lui alors que `making-a-bounded-change` ne conduit pas la fin de la sienne, et l'amendement libère l'entrée du gaps register que la correction supprime ensuite — si c'est faux, la ligne du tableau `What the Ruling Asks For` s'inverse et `making-a-bounded-change` doit apprendre à transmettre une étape suivante ; d'ici là, rien ne donne le prompt qui reprend le lot après le changement borné.
- Ruling: `making-a-bounded-change` n'invoque pas `finishing-a-pr` — la spec ne compte pas la pull request d'un changement borné parmi les revues, donc lui donner la fin d'une revue ajouterait un comportement qu'aucun bloc n'annonce — si c'est faux, un changement borné qui serait la première de plusieurs étapes ne transmet rien.
- Ruling: la description de `making-a-bounded-change`, sa ligne du `README` et une ligne de la table de routage de `using-batches` nomment la spec que l'humain juge fausse — la description est ce qui déclenche une skill, et sans cette ligne la table de routage n'envoie une spec que le code contredit que vers un lot correctif — si c'est faux, trois lignes et leurs gardes à reprendre.
- Ruling: une correction qui règle une entrée du gaps register la supprime dans la même pull request, par la règle (d) — la spec dit déjà qu'une entrée réglée est supprimée, et l'amendement l'a libérée à ce moment — si c'est faux, une phrase et sa garde à retirer.
- Ruling: dans la règle (b) de `making-a-bounded-change`, `none` devient ce que déclare un changement borné « that writes in no spec », et non plus « that changes nothing observable » — une correction de spec ne change rien d'observable et déclare pourtant ses sections — si c'est faux, quatre mots à remettre.
- Ruling: la phrase qui invoque `writing-in-a-spec` quitte la puce (a) et suit l'exception, dans un paragraphe à elle — elle vaut ainsi pour la mise à jour avec le code comme pour la correction, sans seconde invocation — si c'est faux, la phrase retourne à la fin de la puce et l'exception en reçoit une copie.
- Ruling: les phrases « Correcting a spec is a human act, never an agent act » et « no agent may correct a spec » de `handling-a-stopped-story`, et leurs pareilles du socle, de `delivering-a-story` et du `README`, restent telles quelles — la spec garde « seul un humain corrige une spec en cours de lot », et la skill dit que l'humain juge et décide la correction qu'un changement borné porte — si c'est faux, un lecteur littéral y voit un agent qui écrit ce qu'aucun agent ne corrige, et quatre fichiers sont à reformuler.
- Ruling: « canonises the drift it describes » reste écrit deux fois dans la règle (a) de `making-a-bounded-change` — chaque emploi donne la raison d'une règle différente, le silence de la spec et la correction réservée à l'humain — si c'est faux, une raison à reformuler avec sa garde.
- Ruling: le plan ci-dessus garde le texte planifié de la tâche 2, où le prompt dit « the correction your human partner decided » ; le texte livré dit « decides », et la garde qui refuse à toute autre skill les règles du changement borné refuse aussi « it carries the spec correction they decide » — la relecture finale a relevé que la correction se décide dans le changement borné, pas avant — si c'est faux, un mot et un motif à reprendre.

## Observed drift

- `Authority and conflict rules` — la spec ne dit pas si la pull request d'un changement borné est une revue : son tableau des revues ne la compte pas, alors que « quand l'humain annonce une fusion et qu'une étape suivante existe, l'agent la nomme et donne le prompt » ne dit pas de quelle fusion il s'agit. Aucune skill ne donne donc le prompt de l'étape qui suit un changement borné.
