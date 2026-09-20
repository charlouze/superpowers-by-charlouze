# Une entrée se lit seule — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Faire qu'une entrée de gaps register se lise seule — ce qui la
qualifie vit en elle, elle ne renvoie à aucune autre, et le mot qui rendait ce
renvoi naturel quitte la règle qui le portait — puis rendre le register du
plugin conforme le jour même.

**Architecture:** Les blocs D8, D9 et D10 sont déjà transcrits dans la spec :
c'est le premier commit de cette branche. Le travail restant porte ces normes
dans les trois skills qui **ajoutent** une entrée — `adopting-a-module` crée le
fichier et y écrit tous ses gaps d'un coup, `closing-a-batch` consolide les
constats de plusieurs stories, et `using-batches` décrit le changement borné, qui
écrit sans skill à lui —, verrouille chaque couplage par une assertion unique sur
les trois fichiers, et finit par le register du plugin, qui viole aujourd'hui ce
que la spec vient d'énoncer : un paragraphe y qualifie un groupe d'entrées. Les
deux skills qui ne font qu'annoter ou retirer une entrée — `writing-a-batch`,
`writing-a-user-story` — ne sont pas touchées : aucune des trois normes ne
s'adresse à elles.

**Tech Stack:** Markdown (skills, gaps register, document de lot), bash
(`tests/*.sh` ; `shared` et `absent` sur le corps aplati des `SKILL.md` dans
`test-skill-contracts.sh`, nouveau fichier de garde sur le fichier de register).

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/05-une-regle-une-spec-un-registre-propre/README.md
**Sections:** Module > The gaps register
**Blocks:** D8, D9, D10

## Global Constraints

Ces contraintes font implicitement partie des exigences de **chaque** tâche.

### Le gel du fichier de spec

> Entre le commit de transcription et l'ouverture de la pull request, aucune
> tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit
> changer s'arrête.

`docs/specs/supercharlouze.md` est **déjà écrit** — les trois blocs y sont, en
premier commit. Aucune tâche de ce plan n'y touche. Le gel est levé à
l'ouverture de la pull request, pour que la revue puisse porter sur la
formulation de la modification de spec.

Le gaps register, `docs/specs/supercharlouze.gaps.md`, **n'est pas** le fichier
de spec et n'est pas gelé : la tâche 4 l'édite, et elle seule.

### La règle d'autorité

**Quand le document de lot et la spec se contredisent, la spec l'emporte — sans
exception et sans délibération.** Implémenter ce que dit la spec, consigner un
`Ruling:`, et continuer. **Corriger une spec en cours de lot est un acte humain,
jamais celui d'un agent.**

### Les contraintes du lot qui s'appliquent ici, mot pour mot

- **Ordre requis.** D8 et D9 viennent après D3, D4 et D7 — déjà fusionnés par la
  story `05-us-2` —, et D9 après D8, dont il prolonge le texte. **D10 n'impose
  aucun ordre** bien qu'il vise la même section : le paragraphe qu'il remplace
  est celui après lequel D8 insère, et aucun bloc ne le modifie.
- **La phrase jumelle de `adopting-a-module` suit D10.** La skill écrit
  « Each entry is a single addressable item — one list item, never a paragraph of
  running prose. » : la story qui transcrit D10 en retire `addressable` de la même
  façon. Le besoin du geste reste énoncé dans la phrase qui suit, celle qui
  introduit la table des gestes, où il décrit ce dont un écrivain a besoin et non
  une propriété de l'entrée.
- **Chaque story met à jour les skills qui appliquent ses blocs**, dans la même
  pull request que sa transcription. Une skill qui continuerait d'inviter une
  prose de groupe après la fusion de D8 est une dérive.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`, dans
  la même pull request qu'elle.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**
- **Aucun renvoi numéroté.** Un renvoi nomme la section qu'il vise ; il ne la
  compte pas.
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit
  la spec, la constatation part sous `Observed drift` dans ce document.
- **Le paragraphe de groupe est dissous** par la story qui transcrit D8, dans la
  même pull request : celui qui, sous `## Gaps`, annonce « les entrées qui suivent
  ont été consolidées par la clôture du lot 02 » est retiré, et ce qu'il portait
  pour une entrée qui ne le porte pas déjà est relogé dans cette entrée. Une norme
  que le fichier du plugin violerait le jour de sa transcription n'est pas une
  norme livrée.
- **La clôture ne verse pas au register les deux constats que D8 et D9
  résorbent.** Ils sont consignés sous l'`Observed drift` de `05-us-2`, écrite
  avant que le lot ne les prenne. Ce plan n'a pas à les réécrire.
- **Une seule entrée du gaps register est résorbée** par ce lot, et c'est D3 qui
  l'a fait, dans `05-us-2`. **Ce plan ne résorbe et n'ajoute aucune entrée** : ce
  qu'il fait au fichier est la dissolution du paragraphe de groupe et le relogement
  de ce qu'il portait.
- **Le lot 04 est ouvert en parallèle.** Une tâche qui trouverait un passage cité
  déplacé applique la règle ordinaire : elle ajuste à ce que porte `main`, sans en
  changer le sens, et le nomme dans la pull request.

### Les commits

Tout `git` qui écrit un commit ou parle au remote passe par le wrapper
d'identité de l'agent, et **chaque commit se termine par la ligne de co-auteur de
l'utilisateur** — jamais par une ligne `Co-Authored-By: Claude`, jamais par une
ligne `Claude-Session:` :

```bash
bash ~/.config/github-app/as-agent.sh git commit -m "$(cat <<'EOF'
<type>: <sujet>

Co-Authored-By: Charlouze <me@charlouze.com>
EOF
)"
```

Les blocs `Step 5: Commit` des tâches ci-dessous donnent le `git add` et le
sujet ; ils s'exécutent sous cette forme.

### La langue

Ossature anglaise, prose dans la langue du projet. Les `SKILL.md` du plugin
n'ont que de l'ossature : **tout ce qu'on y écrit est en anglais.** Le gaps
register et ce document portent leur prose en français.

---

### Task 1: D10 — le mot `addressable` quitte la skill

Le mot justifiait qu'une entrée soit un élément de liste : ce qu'un geste doit
pouvoir annoter ou retirer en entier. Mais il se lit aussi comme « faite pour
être pointée », et c'est sous cette lecture qu'une entrée en désigne une autre.
La règle reste, le mot s'en va — et le besoin du geste, lui, reste énoncé par la
phrase suivante, celle qui introduit la table des gestes.

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md:237`
- Test: `tests/test-skill-contracts.sh` (nouvelle assertion `absent`, à la fin du
  fichier, avant `exit`)

**Interfaces:**
- Consumes: rien. `docs/specs/supercharlouze.md` porte déjà D10, en premier
  commit de la branche.
- Produces: rien que les tâches suivantes lisent.

- [ ] **Step 1: Write the failing test**

Ajouter à la fin de `tests/test-skill-contracts.sh`, **avant** la ligne
`exit $((FAILURES > 0))` :

```bash
# `addressable` justifiait la forme d'une entrée et se lisait aussi comme « faite
# pour être pointée » — la lecture sous laquelle une entrée en désigne une autre.
# La spec l'a retiré ; la phrase jumelle de la skill le retire de la même façon.
# Le besoin du geste survit dans la phrase qui suit, où il décrit ce dont un
# écrivain a besoin et non une propriété de l'entrée, et c'est elle qui est
# assertée positivement juste après.
absent "no skill calls an entry addressable" \
    "[Aa]ddressable" \
    adopting-a-module using-batches writing-a-batch writing-a-user-story closing-a-batch

# Le mot part, la règle reste : sans cette assertion, supprimer la phrase entière
# passerait au vert.
shared "the entry's shape is still stated without the word" \
    "one list item, never a paragraph of running prose" \
    adopting-a-module
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-contracts.sh`
Expected: `[FAIL] no skill calls an entry addressable (present in: adopting-a-module)`.
La seconde assertion passe déjà — la phrase existe, avec le mot en trop.

- [ ] **Step 3: Write minimal implementation**

Dans `skills/adopting-a-module/SKILL.md`, remplacer :

```markdown
**Each entry is a single addressable item — one list item, never a paragraph of
running prose.**
```

par :

```markdown
**Each entry is one list item, never a paragraph of running prose.**
```

Ne rien changer d'autre : la phrase qui suit — « You are the only skill that ever
*creates* this file… Each of them needs a thing it can point at, whether to
annotate it in place or to take it out whole: » — porte déjà le besoin du geste,
et c'est elle qui remplace la justification retirée.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/test-skill-contracts.sh`
Expected: les deux nouvelles assertions en `[PASS]`, et aucune régression.

- [ ] **Step 5: Commit**

```bash
git add skills/adopting-a-module/SKILL.md tests/test-skill-contracts.sh
git commit -m "refactor: une entrée est un élément de liste, sans être dite adressable"
```

---

### Task 2: D8 — ce qui qualifie une entrée vit dans l'entrée

Trois écrivains **ajoutent** une entrée : l'adoption, qui crée le fichier et y
écrit tous ses gaps d'un coup ; la clôture, qui consolide les constats de
plusieurs stories ; le changement borné, qui écrit depuis sa propre pull request.
Ce sont les trois seuls endroits où une prose de groupe peut naître, et elles
l'écrivent dans les mêmes mots, sous une assertion unique — trois assertions
séparées resteraient vertes pendant qu'un bord dérive.

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md` (étape `5. Audit the code against
  the spec`, juste après la phrase que la tâche 1 a raccourcie)
- Modify: `skills/closing-a-batch/SKILL.md` (devoir `3. Consolidate observed
  drift`, après le paragraphe « Read the file's history before adding an entry »)
- Modify: `skills/using-batches/SKILL.md` (clause `(d)` du changement borné)
- Test: `tests/test-skill-contracts.sh` (nouvelle assertion `shared`)

**Interfaces:**
- Consumes: la phrase raccourcie par la tâche 1, dans `adopting-a-module` — la
  nouvelle prose s'insère juste après elle.
- Produces: la phrase exacte `What qualifies an entry lives in the entry.`,
  présente dans les trois skills. La tâche 3 écrit la sienne juste après, dans
  les trois mêmes endroits.

- [ ] **Step 1: Write the failing test**

Ajouter à la fin de `tests/test-skill-contracts.sh`, **avant** la ligne
`exit $((FAILURES > 0))` :

```bash
# Un register se relit entrée par entrée, et rien ne fait suivre une prose qui
# qualifie un groupe : elle devient fausse sans que personne ne l'ait touchée.
# Les trois skills qui *ajoutent* une entrée le disent — l'adoption écrit tous
# ses gaps d'un coup, la clôture consolide plusieurs stories, le changement borné
# écrit seul. Une assertion unique sur les trois : trois `require` resteraient
# verts pendant qu'un bord se reformule.
shared "every writer that adds an entry keeps a group's qualification out" \
    "What qualifies an entry lives in the entry" \
    adopting-a-module closing-a-batch using-batches
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-contracts.sh`
Expected: `[FAIL] every writer that adds an entry keeps a group's qualification out (missing in: adopting-a-module closing-a-batch using-batches)`.

- [ ] **Step 3: Write minimal implementation**

Dans `skills/adopting-a-module/SKILL.md`, insérer juste après le paragraphe
« Each entry is one list item, never a paragraph of running prose. » et la phrase
qui le suit jusqu'à la table des gestes — donc **après** la table et après le
paragraphe « A register written as flowing paragraphs… Write entries so those
gestures are mechanical. » — le paragraphe :

```markdown
**What qualifies an entry lives in the entry.** Besides its coverage, the register
carries nothing but entries: no prose qualifies a *group* of them — where they came
from, how they were classified, how many there are. Entries are added and removed
one at a time, and nothing keeps such a paragraph honest: it goes false without
anyone touching it. What it would say of several entries is repeated in each, and
where an entry came from is read in the history of the file. You write this file's
first entries all at once, which is exactly when a group paragraph feels natural —
and it is the one moment nobody is left to notice it later.
```

Dans `skills/closing-a-batch/SKILL.md`, devoir `3. Consolidate observed drift`,
insérer après le paragraphe « **Read the file's history before adding an entry**
(`git log -p docs/specs/<module>.gaps.md`)… reopens a decision nobody has
reviewed. » :

```markdown
**What qualifies an entry lives in the entry.** Besides its coverage, the register
carries nothing but entries: no prose qualifies a *group* of them — where they came
from, how they were classified, how many there are. Entries are added and removed
one at a time, and nothing keeps such a paragraph honest: it goes false without
anyone touching it. What it would say of several entries is repeated in each, and
where an entry came from is read in the history of the file. You arrive with a
batch's worth of findings at once, so the temptation is yours more than anyone's:
write "consolidated by batch NN" into each entry that needs it, never above them.
```

Dans `skills/using-batches/SKILL.md`, clause `(d)` du changement borné, ajouter à
la fin de la clause, avant la phrase « The batch path is stricter… » :

```markdown
What qualifies an entry lives in the entry: no prose qualifies a *group* of them, and what an entry's neighbours have in common is repeated in each of them.
```

`using-batches` écrit ses paragraphes sur une seule ligne, sans repli : suivre le
fichier.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`, la nouvelle assertion en `[PASS]`.

- [ ] **Step 5: Commit**

```bash
git add skills/adopting-a-module/SKILL.md skills/closing-a-batch/SKILL.md skills/using-batches/SKILL.md tests/test-skill-contracts.sh
git commit -m "feat: ce qui qualifie une entrée vit dans l'entrée"
```

---

### Task 3: D9 — une entrée ne renvoie à aucune autre entrée

La suppression emporte la cible d'un renvoi sans toucher celui qui renvoie. La
règle prolonge le texte de la tâche 2, dans les trois mêmes skills.

**Files:**
- Modify: `skills/adopting-a-module/SKILL.md` (juste après le paragraphe de la
  tâche 2)
- Modify: `skills/closing-a-batch/SKILL.md` (juste après le paragraphe de la
  tâche 2)
- Modify: `skills/using-batches/SKILL.md` (clause `(d)`, juste après la phrase de
  la tâche 2)
- Test: `tests/test-skill-contracts.sh` (nouvelle assertion `shared`)

**Interfaces:**
- Consumes: le paragraphe `What qualifies an entry lives in the entry.` écrit par
  la tâche 2, dans les trois fichiers — le nouveau texte s'insère juste après.
- Produces: la phrase exacte `An entry designates no other entry.`, présente dans
  les trois skills.

- [ ] **Step 1: Write the failing test**

Ajouter à la fin de `tests/test-skill-contracts.sh`, **avant** la ligne
`exit $((FAILURES > 0))` :

```bash
# Une entrée réglée quitte le fichier et emporte ce qui pointait vers elle : le
# renvoi d'entrée à entrée perd sa cible sans que personne ne l'édite. Les mêmes
# trois écrivains le disent, dans les mêmes mots, sous une assertion unique.
shared "every writer that adds an entry keeps entries from pointing at each other" \
    "An entry designates no other entry" \
    adopting-a-module closing-a-batch using-batches
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-skill-contracts.sh`
Expected: `[FAIL] every writer that adds an entry keeps entries from pointing at each other (missing in: adopting-a-module closing-a-batch using-batches)`.

- [ ] **Step 3: Write minimal implementation**

Dans `skills/adopting-a-module/SKILL.md` et `skills/closing-a-batch/SKILL.md`,
insérer juste après le paragraphe écrit par la tâche 2 :

```markdown
**An entry designates no other entry.** A settled entry leaves the file whole, and
it takes with it anything that pointed at it — by name or by position. What an entry
needs from its neighbour it states itself.
```

Dans `skills/using-batches/SKILL.md`, clause `(d)`, ajouter juste après la phrase
écrite par la tâche 2 :

```markdown
An entry designates no other entry: a settled entry leaves the file whole, and takes with it anything that pointed at it.
```

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`, la nouvelle assertion en `[PASS]`.

- [ ] **Step 5: Commit**

```bash
git add skills/adopting-a-module/SKILL.md skills/closing-a-batch/SKILL.md skills/using-batches/SKILL.md tests/test-skill-contracts.sh
git commit -m "feat: une entrée ne renvoie à aucune autre entrée"
```

---

### Task 4: Le register du plugin s'y conforme, et une garde structurelle l'y tient

Le fichier du plugin viole les deux normes que les tâches 2 et 3 viennent
d'écrire : sous `## Gaps`, un paragraphe de prose courante qualifie un groupe
d'entrées — leur provenance, leur classement, leur forme commune — et désigne au
passage une entrée voisine. Il est dissous, et ce qu'il portait pour une entrée
qui ne le porte pas déjà est relogé dans cette entrée. La garde est structurelle :
elle lit le fichier, pas une skill.

**Files:**
- Create: `tests/test-gaps-register.sh`
- Modify: `docs/specs/supercharlouze.gaps.md` (section `## Gaps`)

**Interfaces:**
- Consumes: rien des tâches précédentes. La garde lit `docs/specs/*.gaps.md`,
  jamais un `SKILL.md`.
- Produces: rien.

- [ ] **Step 1: Write the failing test**

Créer `tests/test-gaps-register.sh` :

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-gaps-register"

# Les deux assertions ci-dessous lisent le fichier de register lui-même, pas une
# skill : une norme sur la forme d'une entrée qui n'est gardée que dans la prose
# des skills laisse le fichier libre de la violer, et c'est exactement ce qui est
# arrivé. Seules les catégories d'entrées sont lues — `## Coverage` est de la
# prose par construction, et n'est pas concernée.
#
# Ce que ces gardes n'attrapent pas : un renvoi écrit autrement que par les
# tournures listées, et une prose de groupe repliée en élément de liste. Elles
# attrapent la forme sous laquelle le défaut est apparu, ce qui est le maximum
# qu'une garde textuelle puisse promettre ici.

# Les lignes des sections `## Violations` et `## Gaps`, catégories comprises,
# jusqu'au prochain titre de niveau 2 ou la fin du fichier.
entry_lines() {
    awk '
        /^## / { inside = ($0 == "## Violations" || $0 == "## Gaps"); next }
        inside { print }
    ' "$1"
}

# --- 1: rien qu'une entrée sous une catégorie ---
# Une entrée est un élément de liste. Une ligne non vide qui ne commence ni par
# `- ` ni par une indentation est de la prose courante : soit un paragraphe qui
# qualifie un groupe d'entrées, soit une entrée écrite en prose. Les deux sont
# interdits par la même règle.
BAD=""
for f in "$REPO_ROOT"/docs/specs/*.gaps.md; do
    [ -f "$f" ] || continue
    while IFS= read -r line; do
        [ -n "${line// /}" ] || continue
        case "$line" in
            "- "*|"  "*) ;;
            *) BAD="$BAD $(basename "$f"): ${line:0:40}" ;;
        esac
    done < <(entry_lines "$f")
done
if [ -z "$BAD" ]; then
    pass "a gaps register category carries entries and nothing else"
else
    fail "a gaps register category carries entries and nothing else ($BAD)"
fi

# --- 2: aucune entrée n'en désigne une autre ---
# Une entrée réglée quitte le fichier et emporte ce qui pointait vers elle. Les
# tournures ci-dessous sont celles par lesquelles un renvoi d'entrée à entrée
# s'écrit : la position, et l'article défini qui pointe une entrée nommée.
BAD=""
for f in "$REPO_ROOT"/docs/specs/*.gaps.md; do
    [ -f "$f" ] || continue
    hits="$(entry_lines "$f" | grep -icE "ci-dessus|ci-dessous|l'entrée|les entrées|entrée précédente|entrée suivante" || true)"
    [ "$hits" = "0" ] || BAD="$BAD $(basename "$f"):$hits"
done
if [ -z "$BAD" ]; then
    pass "no gaps register entry designates another"
else
    fail "no gaps register entry designates another ($BAD)"
fi

exit $((FAILURES > 0))
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/test-gaps-register.sh`
Expected: les **deux** assertions en `[FAIL]` — le paragraphe de groupe sous
`## Gaps` est de la prose courante, et il désigne une entrée voisine par son nom
et par sa position.

- [ ] **Step 3: Write minimal implementation**

Dans `docs/specs/supercharlouze.gaps.md`, **supprimer** le paragraphe qui ouvre
sur « **Les entrées qui suivent ont été consolidées par la clôture du lot 02** »
et court jusqu'à « Les deux constats qu'un changement de code seul peut résoudre
sont sous *Violations*. », ainsi que la ligne vide qui le suit.

Puis reloger ce qu'il portait dans les deux entrées qui ne le portent pas déjà.
Les deux entrées `**Code under a feature flag**` qui le suivent ne reçoivent
rien : elles nomment déjà la story qui les a relevées et disent déjà pourquoi
elles sont classées en *gap* — et elles ne viennent pas du lot 02, ce que le
paragraphe affirmait à tort.

Ajouter à la fin de l'entrée `**Installing on a project**` qui commence par « le
second membre de la phrase sur les répertoires que l'installation crée », après
« … « aucune **décision** de ce système ne dépend de leur existence » » :

```markdown
  Consolidée par la clôture du lot 02, depuis l'`Observed drift` d'une de ses
  stories. Classée en *gap* et non en *violation* : la spec y a tort et le code y
  a raison, si bien qu'un lot correctif qui la prendrait buterait aussitôt sur la
  cinquième condition d'arrêt — la résorber veut dire corriger une spec, ce qu'un
  agent ne peut pas faire.
```

Ajouter le même paragraphe à la fin de l'entrée `**Installing on a project**` qui
commence par « « ce qui subsiste n'appartient pas au plugin » », après « … et
c'est ce choix qui rend la décision humaine. » :

```markdown
  Consolidée par la clôture du lot 02, depuis l'`Observed drift` d'une de ses
  stories. Classée en *gap* et non en *violation* : la spec y a tort et le code y
  a raison, si bien qu'un lot correctif qui la prendrait buterait aussitôt sur la
  cinquième condition d'arrêt — la résorber veut dire corriger une spec, ce qu'un
  agent ne peut pas faire.
```

Le texte est répété mot pour mot dans les deux entrées, et c'est exactement ce
que la norme prescrit : ce qu'une prose dirait de plusieurs entrées se répète
dans chacune.

**Ne toucher à rien d'autre** : aucune entrée n'est ajoutée, aucune n'est
supprimée, et les annotations `reserved by batch-NN` restent telles quelles.

- [ ] **Step 4: Run test to verify it passes**

Run: `bash tests/run-all.sh`
Expected: `all tests passed`, avec `test-gaps-register` et ses deux assertions en
`[PASS]`, et `test-suite-integrity` toujours vert — le nouveau fichier est nommé
`test-*.sh` et émet deux assertions.

- [ ] **Step 5: Commit**

```bash
git add tests/test-gaps-register.sh docs/specs/supercharlouze.gaps.md
git commit -m "fix: le register du plugin ne porte plus de prose de groupe"
```

---

## Rulings log

## Observed drift
