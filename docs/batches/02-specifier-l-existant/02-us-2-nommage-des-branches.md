# 02-us-2 — Le nommage des branches : Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Aligner les quatre skills qui créent une branche sur la lecture stricte que la tranche de spec vient de rendre normative, et poser les gardes — positive et négative — qui empêchent la lecture souple et l'affirmation fausse de revenir.

**Architecture:** La tranche de spec est **déjà livrée** — premier commit de cette branche, `a2ddb38`. Elle a retiré de `Branch naming` une phrase affirmée en gras, « Aucun mécanisme de ce système ne dépend du nom de branche », que deux sections de la même spec contredisaient, et posé à la place que **le nom conventionnel doit être rétabli**, un nom quelconque ne suffisant pas.

Cinq passages de skills sont désormais en écart avec la spec, et ce sont deux écarts distincts :

- **La lecture souple** — `adopting-a-module` et `closing-a-batch` se contentent de « make sure a named branch exists ». C'est exactement ce que la spec vient d'écarter.
- **L'affirmation fausse** — `adopting-a-module`, `writing-a-batch` et `writing-a-user-story` répètent que rien ne dépend du nom. Les deux derniers se contredisent d'ailleurs en interne : `writing-a-batch` explique en tête que « the branch name already carries the number », et `writing-a-user-story` dit la même chose de `story/NN-us-N-<slug>`, à quelques dizaines de lignes d'un paragraphe affirmant l'inverse.

**Ces tâches ont une vraie phase rouge**, à la différence de la story précédente. Le comportement à obtenir n'existe pas encore : une assertion écrite avant l'alignement **échoue réellement**, et son échec est l'aveu que le skill ne fait pas ce que la spec exige. Écris donc l'assertion d'abord, constate l'échec, aligne, constate le vert. Pas de preuve par mutation ici — la mutation, c'est l'état actuel du dépôt.

**Ce que ces gardes ne couvrent pas, délibérément :** elles portent sur les skills et jamais sur `docs/specs/supercharlouze.md`. Une assertion qui figerait la prose de la spec prendrait à contre-sens ce qu'est une spec vivante — l'autorité que l'humain amende en revue. La spec est gardée par sa revue, pas par la suite de tests.

**Tech Stack:** Bash, `set -euo pipefail`. `tests/run-all.sh` ramasse `tests/test-*.sh` par glob. Les corps de skills sont comparés **aplatis** (retours à la ligne remplacés par des espaces), donc une phrase coupée par l'habillage est tout de même trouvée — et, réciproquement, une aiguille peut enjamber un retour à la ligne sans dommage.

**Spec:** docs/specs/supercharlouze.md

**Batch:** docs/batches/02-specifier-l-existant/README.md

**Sections:** Branch naming, Git model, Module adoption

## Global Constraints

Contraintes du lot, recopiées mot pour mot depuis `docs/batches/02-specifier-l-existant/README.md` :

- **Ordre requis.** La tranche `Verification` est transcrite **en dernier**,
  après que toutes les autres tranches de ce lot ont été fusionnées sur `main`.
  Chacune des autres livre des gardes structurelles, donc chacune creuse l'écart
  entre la liste normative et ce que `tests/` vérifie réellement — l'écart même
  que cette tranche résorbe. Écrite plus tôt, sa liste serait périmée avant
  d'être fusionnée. Les autres tranches n'ont aucun ordre entre elles.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`,
  dans la même pull request qu'elle. Un contrat que rien ne vérifie redérivera
  comme il a dérivé.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**
- **Aucun renvoi numéroté.** Un renvoi nomme la section qu'il vise ; il ne la
  compte pas. Les sections de la spec vivante sont titrées et non numérotées,
  délibérément, et la garde livrée par le lot 01 le vérifie.
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit
  la spec, la constatation part sous `Observed drift` dans le document de story ;
  elle ne se règle pas par une correction discrète du code ni de la spec.
- **Deux décisions sont déjà tranchées par l'humain au gate d'ouverture** et ne
  se rediscutent pas en cours d'implémentation : la **lecture stricte** du nom
  de branche, et la **non-survie** de `docs/specs/` et `docs/batches/` à un
  clone. Les appliquer, ne pas les rouvrir.
- **Ne toucher à aucune entrée non réservée** du gaps register. Les trois
  entrées laissées disponibles ci-dessus appartiennent à d'autres lots.

**Note sur la deuxième de ces décisions :** la lecture stricte est **acquise**. Cette story l'applique, elle ne la réexamine pas. Si l'alignement te paraît trop large — par exemple parce qu'aucun balayage ne lit `adopt/<module>` — c'est une observation qui va sous `Observed drift`, pas une raison de restreindre l'alignement.

**Gel du fichier de spec :**

> Entre le commit de transcription et l'ouverture de la pull request, aucune tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit changer s'arrête.

Le commit de transcription est `a2ddb38` : il est déjà passé. `docs/specs/supercharlouze.md` est **gelé** pour toute la durée de ce plan. Aucune tâche ne l'ouvre en écriture.

**Règle d'autorité :**

> Quand le batch et la spec se contredisent, **la spec gagne — sans exception et sans délibération**. Implémente ce que dit la spec, inscris un `Ruling:`, et poursuis. **Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.**

---

### Task 1: Le contrat positif — rétablir le nom conventionnel

**Files:**
- Modify: `tests/test-skill-contracts.sh` — deux assertions `shared` ajoutées avant la ligne `exit $((FAILURES > 0))`
- Modify: `skills/adopting-a-module/SKILL.md:119-123`
- Modify: `skills/writing-a-batch/SKILL.md:90-94`
- Modify: `skills/writing-a-user-story/SKILL.md:180-186`
- Modify: `skills/closing-a-batch/SKILL.md:23`

**Interfaces:**
- Consumes: les helpers `body_flat` et `shared` déjà définis dans `tests/test-skill-contracts.sh`. `shared <label> <needle> <skill>...` passe **seulement si** l'aiguille est présente dans **tous** les skills nommés, et nomme les manquants en cas d'échec.
- Produces: la phrase canonique `restore the conventional name before going on` et la phrase `a named branch is not enough`, toutes deux présentes dans les quatre skills. La tâche 2 ne les consomme pas.

- [ ] **Step 1: Écrire les deux assertions — elles doivent échouer**

Insérer avant la dernière ligne `exit $((FAILURES > 0))` de `tests/test-skill-contracts.sh` :

```bash

# `Number allocation` and the concurrency scan both recognise a branch by its
# name, and both on exactly the window where no pull request exists yet. So a
# skill that creates a branch owes more than "some named branch exists": it
# restores the conventional name. The loose reading leaves a branch that is
# invisible to both scans, holding neither its number nor its sections.
shared "every branch-creating skill restores the conventional name" \
    "restore the conventional name before going on" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch

shared "and each says a named branch is not enough" \
    "named branch is not enough" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch
```

L'aiguille omet l'article de tête volontairement : les quatre textes de remplacement écrivent cette phrase en **début** de phrase, donc `A named branch is not enough`, avec une majuscule. Le helper compare octet pour octet, sans normaliser la casse. Ne « répare » pas l'aiguille en y remettant un `a` minuscule.

- [ ] **Step 2: Lancer le test — il doit ÉCHOUER, et c'est le but**

Run: `bash tests/test-skill-contracts.sh`
Expected: deux `[FAIL]`, chacun nommant **les quatre** skills comme manquants :

```
  [FAIL] every branch-creating skill restores the conventional name (missing in: adopting-a-module writing-a-batch writing-a-user-story closing-a-batch)
  [FAIL] and each says a named branch is not enough (missing in: adopting-a-module writing-a-batch writing-a-user-story closing-a-batch)
```

C'est la phase rouge réelle de cette tâche : aucun des quatre skills ne fait ce que la spec exige. Si l'un d'eux apparaissait déjà comme présent, arrête-toi et signale-le — cela voudrait dire que le dépôt n'est pas dans l'état que ce plan décrit.

- [ ] **Step 3: Aligner `adopting-a-module`**

Remplacer, dans `skills/adopting-a-module/SKILL.md`, ce paragraphe :

```markdown
That skill prefers the harness's native tooling, which picks its own branch name
and may leave you on a detached HEAD. If it leaves you on a differently named
branch or on a detached HEAD, make sure a named branch exists before you
continue — nothing in this system depends on the branch name, but a pull request
needs a branch.
```

par :

```markdown
That skill prefers the harness's native tooling, which picks its own branch name
and may leave you on a detached HEAD. If it leaves you on a differently named
branch or on a detached HEAD, restore the conventional name before going on:
`adopt/<module>`. **A named branch is not enough.** Number allocation and the
concurrency scan both recognise a branch by its name, on exactly the window where
no pull request exists yet, so a branch left under a harness-chosen name is
invisible to both — and a convention that holds only where a scan happens to read
it is one nobody can rely on.
```

- [ ] **Step 4: Aligner `writing-a-batch`**

Remplacer, dans `skills/writing-a-batch/SKILL.md`, ce paragraphe :

```markdown
Create the branch and workspace by invoking `superpowers:using-git-worktrees`.
That skill prefers the harness's native tooling, which picks its own branch name
and may leave you on a detached HEAD. This plugin enforces its own naming: if you
end up elsewhere, make sure a branch named `batch/NN-<slug>` exists before going
on. No mechanism depends on the name — but a pull request needs a branch.
```

par :

```markdown
Create the branch and workspace by invoking `superpowers:using-git-worktrees`.
That skill prefers the harness's native tooling, which picks its own branch name
and may leave you on a detached HEAD. This plugin enforces its own naming: if you
end up elsewhere, restore the conventional name before going on:
`batch/NN-<slug>`. **A named branch is not enough.** Allocating `NN` above reads
`batch/*` and `story/*` on the remote to refuse a number already claimed, so a
branch left under a harness-chosen name claims nothing, and hands its number to
the next batch opened in parallel.
```

- [ ] **Step 5: Aligner `writing-a-user-story`**

Remplacer, dans `skills/writing-a-user-story/SKILL.md`, ce paragraphe :

```markdown
Create the branch and the workspace by invoking
`superpowers:using-git-worktrees`. That skill prefers the harness's native
tooling, which picks its own branch name, and may leave a detached HEAD. If it
produces another name, a detached HEAD, or if isolation is declined, make sure
a **named branch exists** before going further. No mechanism here depends on
the name — identification goes through the pull request and the story document
— but a pull request cannot be opened without a branch.
```

par :

```markdown
Create the branch and the workspace by invoking
`superpowers:using-git-worktrees`. That skill prefers the harness's native
tooling, which picks its own branch name, and may leave a detached HEAD. If it
produces another name, a detached HEAD, or if isolation is declined, restore the
conventional name before going on: `story/NN-us-N-<slug>`. **A named branch is
not enough.** Step 1's third source and this step's allocation both read
`story/*` on the remote, so a branch under any other name is invisible to every
sibling for the whole length of an implementation — it holds neither its `us-N`
nor its sections, and the push at the end of Step 3 buys nothing.
```

- [ ] **Step 6: Aligner `closing-a-batch`**

Remplacer, dans `skills/closing-a-batch/SKILL.md`, cette ligne (une seule ligne longue, ne la ré-habille pas — le fichier n'habille pas ses puces) :

```markdown
- **Create the branch and its workspace by invoking `superpowers:using-git-worktrees`.** The conventional name is `batch/NN-<slug>-close`, enforced by this plugin, not by that skill. If it lands on a differently named branch or a detached HEAD, make sure a named branch exists before continuing — nothing depends on the name, but a pull request needs a branch.
```

par :

```markdown
- **Create the branch and its workspace by invoking `superpowers:using-git-worktrees`.** The conventional name is `batch/NN-<slug>-close`, enforced by this plugin, not by that skill. If it lands on a differently named branch or a detached HEAD, restore the conventional name before going on. **A named branch is not enough:** `batch/*` is what number allocation reads on the remote to refuse a number already claimed, so a branch under a harness-chosen name claims nothing.
```

- [ ] **Step 7: Lancer la suite — tout doit passer au vert**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`, et dans la section `test-skill-contracts` les deux nouvelles lignes en `[PASS]`.

- [ ] **Step 8: Commit**

```bash
git add tests/test-skill-contracts.sh skills/adopting-a-module/SKILL.md skills/writing-a-batch/SKILL.md skills/writing-a-user-story/SKILL.md skills/closing-a-batch/SKILL.md
git commit -m "fix: les quatre skills rétablissent le nom conventionnel"
```

---

### Task 2: Le contrat négatif — l'affirmation fausse ne doit pas revenir

**Files:**
- Modify: `tests/test-skill-contracts.sh` — helper `absent` ajouté après le helper `shared`, et deux assertions avant `exit $((FAILURES > 0))`
- Modify: `skills/writing-a-batch/SKILL.md` — le paragraphe de la section *Amending a Batch*

**Interfaces:**
- Consumes: les helpers `body_flat`, `pass` et `fail` déjà définis dans `tests/test-skill-contracts.sh`, et la fonction `shared` que la tâche 1 a laissée inchangée.
- Produces: le helper `absent <label> <needle> <skill>...`, symétrique de `shared` — il passe **seulement si** l'aiguille est absente de **tous** les skills nommés, et nomme les fautifs en cas d'échec.

**Pourquoi une assertion négative.** La tâche 1 garde ce que les skills *doivent* dire. Elle ne garde pas ce qu'ils ne doivent **plus** dire : un futur rédacteur peut parfaitement ajouter la phrase canonique et laisser à côté l'ancienne affirmation, et la suite resterait verte sur un texte qui se contredit — ce qui est précisément l'état dont cette story sort. Les deux assertions sont donc complémentaires et aucune ne remplace l'autre.

- [ ] **Step 1: Ajouter le helper `absent`**

Insérer dans `tests/test-skill-contracts.sh`, immédiatement après la fonction `shared` et avant la première assertion :

```bash

# The mirror of `shared`: a claim that must survive nowhere. Used for a sentence
# a spec slice removed, which is otherwise guarded by nothing — the positive
# assertions would stay green on a file that carried both the new phrasing and
# the old, contradicting one.
absent() {
    local label="$1" needle="$2"
    shift 2
    local found=""
    local s f b
    for s in "$@"; do
        f="$REPO_ROOT/skills/$s/SKILL.md"
        b=""
        [ -f "$f" ] && b="$(body_flat "$f")"
        case "$b" in
            *"$needle"*) found="$found $s" ;;
        esac
    done
    if [ -z "$found" ]; then
        pass "$label"
    else
        fail "$label (present in:$found)"
    fi
}
```

- [ ] **Step 2: Écrire les deux assertions — l'une doit échouer**

Insérer avant la ligne `exit $((FAILURES > 0))` :

```bash

# `Branch naming` used to claim, in bold, that no mechanism of this system
# depends on the branch name. Two sections of the same spec contradicted it, and
# the claim is gone. No skill may carry it either — in any of its wordings.
absent "no skill claims the branch name is irrelevant" \
    "depends on the name" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch using-batches

absent "no skill claims it in the long form" \
    "depends on the branch name" \
    adopting-a-module writing-a-batch writing-a-user-story closing-a-batch using-batches
```

- [ ] **Step 3: Lancer le test — la première assertion doit ÉCHOUER**

Run: `bash tests/test-skill-contracts.sh`
Expected :

```
  [FAIL] no skill claims the branch name is irrelevant (present in: writing-a-batch)
  [PASS] no skill claims it in the long form
```

La seconde passe déjà : la tâche 1 a supprimé la seule occurrence de la forme longue, dans `adopting-a-module`. La première échoue sur `writing-a-batch`, où la section *Amending a Batch* dit encore « nothing here depends on the name ».

Si la première échoue en nommant un **autre** skill que `writing-a-batch`, arrête-toi et signale-le : la tâche 1 aurait laissé une occurrence derrière elle.

- [ ] **Step 4: Reformuler le paragraphe d'amendement**

L'affirmation y est **vraie** — rien ne cherche une branche d'amendement — mais elle est écrite dans les mots généraux que la spec vient de récuser, et c'est ce qui la rend indistinguable de la fausse. Remplacer, dans `skills/writing-a-batch/SKILL.md`, section *Amending a Batch* :

```markdown
Do it on a **distinct branch whose name carries no meaning** — do not reuse
`batch/NN-<slug>`, which the opening pull request may still hold on the remote;
nothing here depends on the name. Edit the batch document **in place** — no
```

par :

```markdown
Do it on a **distinct branch whose name carries no meaning** — do not reuse
`batch/NN-<slug>`, which the opening pull request may still hold on the remote.
An amendment claims neither a fresh number nor any sections, so no scan looks for
its branch and its name has nothing to carry: that is what makes it the one
exception to restoring a conventional name, and the exception holds for that
reason alone. Edit the batch document **in place** — no
```

- [ ] **Step 5: Lancer la suite — tout doit passer au vert**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`, et les deux assertions `absent` en `[PASS]`.

- [ ] **Step 6: Vérifier que la garde négative mord encore**

Une assertion négative qui passe est indistinguable d'une assertion négative qui ne regarde rien. Prouve-la :

```bash
printf '\nnothing here depends on the name.\n' >> skills/using-batches/SKILL.md
bash tests/test-skill-contracts.sh
```

Expected: `[FAIL] no skill claims the branch name is irrelevant (present in: using-batches)`.

Puis reviens et re-vérifie :

```bash
git checkout -- skills/using-batches/SKILL.md
bash tests/run-all.sh
```

Expected: `all tests passed`.

- [ ] **Step 7: Commit**

```bash
git add tests/test-skill-contracts.sh skills/writing-a-batch/SKILL.md
git commit -m "fix: l'affirmation retirée de la spec ne survit dans aucun skill"
```

---

## Rulings log

Huit décisions prises pendant l'exécution, recopiées du ledger SDD avant sa suppression. La liste est exhaustive.

- **Ruling:** l'aiguille `a named branch is not enough` est corrigée **dans le plan lui-même**, en `named branch is not enough` sans l'article — **pourquoi :** ce n'était pas un risque mais un plan qui ne pouvait pas aboutir. Les quatre textes de remplacement ouvrent une phrase par `A named branch is not enough`, majuscule, et le helper compare octet pour octet sans replier la casse ; l'implémenteur aurait aligné les quatre skills correctement et vu rouge quand même, avec pour réflexe le plus probable de corriger les quatre phrases pour satisfaire un test faux — **coût si c'est faux :** l'aiguille est d'un mot plus courte, donc un peu plus lâche.

- **Ruling:** les tâches 1 et 2 partent **séparément et dans cet ordre**, jamais groupées — **pourquoi :** elles ne sont pas de même forme, et surtout la phase rouge de la tâche 2 n'est juste qu'une fois la tâche 1 fusionnée ; les grouper aurait fondu les deux phases rouges en une et détruit la preuve que chaque contrat est indépendamment non gardé aujourd'hui — **coût si c'est faux :** un siège de revue de plus que strictement nécessaire.

- **Ruling:** modèle de milieu de gamme pour les implémenteurs et les revues de tâche, le plus capable pour la revue finale — **pourquoi :** cette story est de l'alignement de prose, où le risque principal est un remplacement multi-lignes raté, tandis que la revue finale doit juger si quatre paragraphes disent vraiment ce que la spec exige, ce qui est du jugement — **coût si c'est faux :** quelques centimes.

- **Ruling:** le finding Critical l'emporte sur le texte que le plan imposait — **pourquoi :** mon plan faisait dire à `adopting-a-module` que l'attribution des numéros et le balayage de concurrence reconnaissent sa branche à son nom. C'est faux : ils balaient `batch/*` et `story/*`, jamais `adopt/*`, et une branche d'adoption est également invisible sous le bon nom et sous le mauvais. La règle n'est pas rétrécie pour autant — la spec l'exige pour tous les types de branche de sa table — c'est le **motif** qui est refait — **coût si c'est faux :** si l'humain décide plus tard que la règle uniforme ne doit pas couvrir les types non balayés, ce paragraphe aura argumenté sur des bases honnêtes mais plus faibles, et sera à réécrire plutôt qu'à supprimer.

- **Ruling:** l'imprécision de la tranche de spec est **aussi** consignée sous `Observed drift` — **pourquoi :** la même looseness vit dans la spec fusionnée ; le fichier est gelé pour la durée du plan et corriger une spec est de toute façon un acte humain, donc la mettre devant l'humain à la revue vaut mieux que laisser une phrase qui m'a déjà induit en erreur une fois — **coût si c'est faux :** un reviewer passe une minute sur une phrase qu'il juge assez claire.

- **Ruling:** l'imprécision n'est **pas** corrigée ici et part au gate humain — **pourquoi :** le gel, l'acte humain, et surtout deux extensions que la revue finale a trouvées et que je n'avais pas vues : le paragraphe d'exception d'amendement se justifie par un critère qui licencie quatre types de branche au lieu d'un, et l'affirmation que les deux mécanismes lisent le nom « exactement sur la fenêtre où la pull request n'existe pas encore » sous-estime la dépendance — **coût si c'est faux :** la pull request porte une discussion plus longue que l'humain ne le voulait.

- **Ruling:** le finding résiduel de la re-revue — la clause `nothing reads `batch/*-close`` de mon propre correctif — est **porteur et corrigé**, bien que SDD n'autorise qu'une vague après la revue finale — **pourquoi :** la clause est fausse, `Number allocation` globant `batch/*` qui matche `batch/NN-<slug>-close` ; ce qui rend le nom sans conséquence est que `main` tient déjà le numéro, ce que la suite de la phrase disait correctement. C'était la **troisième** occurrence du défaut exact que cette story existe pour éliminer, à l'intérieur du correctif de la deuxième — expédier celle-là rendrait faux le livrable même de la story, et c'est ce qui la rend porteuse plutôt que cosmétique — **coût si c'est faux :** un dispatch de plus que le budget de SDD ne le prévoit.

- **Ruling:** l'observation hors périmètre sur le helper `absent` est **parquée** — **pourquoi :** il ne signale que le *premier* fichier manquant d'une liste, donc un second nom fautif se cacherait derrière le premier. C'est réel mais rien ne construit dessus : tous les sites d'appel nomment des skills qui existent, et l'échec qu'il dégrade est déjà un échec bruyant — **coût si c'est faux :** si le helper est réemployé plus tard avec une liste plus longue, un second nom fautif reste invisible.

## Observed drift

Quatre constats **hors du périmètre de cette story**, laissés tels quels conformément à la contrainte du lot « ne rien aligner en silence ».

**Avertissement de classement pour la clôture :** les trois premiers ne sont **pas** des divergences entre le code et la spec. Ce sont des défauts de cohérence **interne à la spec**, que le vocabulaire du registre — *Violations* pour « le code contredit la spec », *Gaps* pour « le code fait ce qu'aucune spec ne décrit » — ne prévoit pas. Les consigner en *Gaps* par défaut les ferait passer pour du comportement non spécifié, ce qu'ils ne sont pas. La clôture devra trancher où ils vont, et c'est une décision humaine.

- **`Branch naming` — la phrase que cette tranche a écrite se lit comme générale alors qu'elle n'est vraie que des patrons balayés.** « Une branche laissée sous le nom qu'un outil natif lui a donné est invisible des deux » vaut pour `batch/*` et `story/*`. Ni `adopt/<module>`, ni `chore/supercharlouze-init`, ni `fix/<slug>` ne sont lus par l'un des deux mécanismes : pour eux la phrase est fausse. **Le coût est démontré, pas hypothétique :** cette phrase a produit, dans le plan de cette story, un paragraphe affirmant une causalité inexistante, rattrapé en Critical à la revue de tâche et corrigé au commit `b4564ba`. Reformulation suggérée : « invisible des deux là où ces balayages portent — `batch/*` et `story/*` ».

- **`Branch naming` — le critère donné à l'exception d'amendement en licencierait quatre.** Le paragraphe dit que l'amendement est la seule exception « par construction », au motif qu'il ne revendique ni numéro ni sections, donc qu'aucun balayage ne le cherche. Ce critère est **exactement aussi vrai** de `adopt/<module>`, de `chore/supercharlouze-init` et de `fix/<slug>`. La spec déclare donc une exception unique en donnant une raison qui en autorise quatre — et elle entre en tension directe avec `adopting-a-module`, que cette même story a dû faire écrire que n'être pas balayé n'exempte **pas**. La vraie raison de l'exception est ailleurs : la table n'assigne à l'amendement aucun nom conventionnel à rétablir, seulement l'interdiction de réutiliser `batch/NN-<slug>`.

- **`Branch naming` / `Number allocation` — la dépendance au nom est plus large que la tranche ne le dit.** La tranche affirme que les deux mécanismes lisent le nom « tous deux exactement sur la fenêtre où la pull request n'existe pas encore ». C'est faux pour `Number allocation`, dont la **deuxième** condition — un numéro revendiqué par une pull request ouverte — se résout elle aussi par le nom de branche : `writing-a-batch` l'écrit noir sur blanc, « the number is in the head branch name, and nothing else in a pull request states it ». Un lot ouvert depuis une branche mal nommée, pull request **ouverte**, ne revendique donc son numéro pour personne. La lecture stricte en sort renforcée ; le raisonnement écrit dans la spec est plus étroit que le système qu'il décrit.

- **`The gaps register` — le registre n'a pas de vocabulaire pour « retirée parce que fausse ».** Cette story a barré l'entrée *Module adoption* non parce qu'un code la résorbait, mais parce qu'elle était factuellement fausse : elle affirmait que la spec ne place pas la création de branche dans l'ordre des étapes de l'adoption, alors que la spec la place à son étape 3, au même rang que le skill. Or la spec définit le barré comme le geste de « la pull request de la story qui la résorbe, **atomiquement avec le code qui la résorbe** ». Relue plus tard, l'entrée barrée dira donc « résorbée par cette pull request », ce qui est faux : aucun code ne l'a résorbée, elle a été retirée. Il manque au registre une annotation distinguant les deux gestes.
