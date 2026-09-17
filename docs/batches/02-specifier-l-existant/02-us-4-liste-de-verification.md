# 02-us-4 — La liste de vérification : Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Livrer la seule catégorie du plancher de `Verification` que rien ne couvrait — l'intégrité de la suite elle-même.

**Architecture:** La tranche de spec est **déjà livrée** — premier commit de cette branche, `683644e`. Elle a transformé la liste de cinq contrôles en **plancher** et l'a étendue aux dix catégories que la suite sert réellement.

**Neuf de ces dix catégories décrivent ce qui existe déjà** et n'appellent aucun code : métadonnées, front matter, renvois, bloc `CLAUDE.md`, overrides, commande d'init, comportement du script d'init, contenu des skills, contrats entre skills. Les 185 assertions des huit fichiers les couvrent. Cette story n'y touche pas.

**La dixième est neuve, et elle garde la suite contre elle-même :** *aucun fichier de test n'échappe au lanceur, et aucun ne passe sans rien affirmer.* Les deux moitiés visent la même chose par deux bouts — une garde que personne n'exécute et une garde qui n'affirme rien sont toutes deux indiscernables d'une garde absente, tout en peuplant le répertoire comme si elles couvraient quelque chose.

Ce n'est pas théorique dans ce dépôt. `tests/run-all.sh` ramasse par le glob `test-*.sh` : un fichier nommé autrement ne serait jamais exécuté, et rien ne le signalerait. Et la section `Coverage` du gaps register déclare elle-même que l'audit d'adoption a lu les tests **par le nom de leurs assertions**, pas ligne à ligne — donc « un test qui passerait sans rien vérifier ne serait pas détecté ». Cette garde attrape la forme grossière de ce défaut : le fichier entier qui n'affirme rien.

**Tech Stack:** Bash. Le fichier neuf est ramassé par le glob de `run-all.sh` sans être déclaré nulle part. Il exécute ses frères pour compter ce qu'ils émettent, donc il s'exclut lui-même — sans quoi il s'appellerait sans fin.

**Spec:** docs/specs/supercharlouze.md

**Batch:** docs/batches/02-specifier-l-existant/README.md

**Sections:** Verification

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

**Cette dernière contrainte mérite une insistance particulière ici.** Les trois entrées restantes du registre sont désormais les seules non barrées, et **deux d'entre elles portent le titre `Verification`**, comme la section que cette story transcrit. L'une est la violation des renvois numérotés survivant dans `tests/` — c'est-à-dire dans les fichiers mêmes que tu vas modifier. Ne la corrige pas au passage : elle appartient à un lot correctif qui ne l'a pas encore prise.

**Gel du fichier de spec :**

> Entre le commit de transcription et l'ouverture de la pull request, aucune tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit changer s'arrête.

Le commit de transcription est `683644e` : il est déjà passé. `docs/specs/supercharlouze.md` est **gelé** pour toute la durée de ce plan, et `docs/specs/supercharlouze.gaps.md` avec lui — sa dernière entrée réservée y est déjà barrée.

**Règle d'autorité :**

> Quand le batch et la spec se contredisent, **la spec gagne — sans exception et sans délibération**. Implémente ce que dit la spec, inscris un `Ruling:`, et poursuis. **Corriger une spec en cours de lot est un acte humain, jamais un acte d'agent.**

---

### Task 1: Garder l'intégrité de la suite

**Files:**
- Create: `tests/test-suite-integrity.sh`

**Interfaces:**
- Consumes: rien. Le fichier est autonome et définit ses propres `pass` / `fail`, sur le patron des sept autres.
- Produces: rien qu'une autre tâche consomme. Cette story n'a qu'une tâche.
- `tests/run-all.sh` ramasse `tests/test-*.sh` par glob : le fichier neuf n'a **rien à déclarer nulle part**, et c'est précisément la propriété que sa première assertion garde.

- [ ] **Step 1: Écrire le fichier**

```bash
cat > tests/test-suite-integrity.sh <<'EOF'
#!/usr/bin/env bash
# No -e: this file runs its siblings, and a sibling that fails must be counted,
# not abort the run.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SELF="$(basename "$0")"
FAILURES=0

pass() { echo "  [PASS] $1"; }
fail() { echo "  [FAIL] $1"; FAILURES=$((FAILURES + 1)); }

echo "test-suite-integrity"

# The suite guards the plugin; this file guards the suite. Both assertions below
# catch the same failure from opposite ends: a check nobody runs and a check that
# asserts nothing are each indistinguishable from a check that does not exist,
# while still filling the directory as though they were coverage.

# --- 1: nothing hides from the runner ---
# run-all.sh collects `tests/test-*.sh` by glob. A check file under any other
# name is never executed, and nothing reports it — it simply sits there looking
# like part of the suite.
STRAYS=""
for f in "$SCRIPT_DIR"/*.sh; do
    b="$(basename "$f")"
    [ "$b" = "run-all.sh" ] && continue
    case "$b" in
        test-*.sh) ;;
        *)         STRAYS="$STRAYS $b" ;;
    esac
done
if [ -z "$STRAYS" ]; then
    pass "every check file is named so the runner picks it up"
else
    fail "every check file is named so the runner picks it up (missed:$STRAYS)"
fi

# --- 2: no file passes without asserting anything ---
# A file whose body is gutted, or whose assertions sit behind a condition that
# never fires, exits 0 and reads as green. Counting what each file emits is what
# separates a silent file from a satisfied one. Both verdicts count: a file whose
# assertions all fail is still asserting something, and run-all reports it.
SILENT=""
for f in "$SCRIPT_DIR"/test-*.sh; do
    b="$(basename "$f")"
    [ "$b" = "$SELF" ] && continue
    n="$(bash "$f" 2>&1 | grep -c '\[PASS\]\|\[FAIL\]')"
    [ "$n" -gt 0 ] || SILENT="$SILENT $b"
done
if [ -z "$SILENT" ]; then
    pass "every check file emits at least one assertion"
else
    fail "every check file emits at least one assertion (silent:$SILENT)"
fi

exit $((FAILURES > 0))
EOF
```

- [ ] **Step 2: Lancer le fichier seul — les deux assertions doivent PASSER**

Run: `bash tests/test-suite-integrity.sh`
Expected:

```
test-suite-integrity
  [PASS] every check file is named so the runner picks it up
  [PASS] every check file emits at least one assertion
```

C'est un test de caractérisation : la suite est saine aujourd'hui. Les deux preuves suivantes sont ce qui distingue cette garde d'une garde qui ne regarde rien.

- [ ] **Step 3: Prouver que la première assertion mord**

```bash
printf '#!/usr/bin/env bash\necho "stray"\n' > tests/check-stray.sh
bash tests/test-suite-integrity.sh
rm -f tests/check-stray.sh
```

Expected : `[FAIL] every check file is named so the runner picks it up (missed: check-stray.sh)`, puis le fichier est supprimé.

Le nom `check-stray.sh` est choisi exprès : il ressemble à un fichier de contrôle et ne sera jamais exécuté par le lanceur.

- [ ] **Step 4: Prouver que la seconde assertion mord**

```bash
printf '#!/usr/bin/env bash\necho "test-silent"\nexit 0\n' > tests/test-silent.sh
bash tests/test-suite-integrity.sh
rm -f tests/test-silent.sh
```

Expected : `[FAIL] every check file emits at least one assertion (silent: test-silent.sh)`, puis le fichier est supprimé.

Ce faux fichier est le cas exact que la garde existe pour attraper : il porte le bon nom, le lanceur l'exécute, il sort avec le code 0, et il n'affirme rien. Sans cette assertion il compterait comme un fichier de test vert.

- [ ] **Step 5: Vérifier la suite complète et l'absence de résidu**

```bash
bash tests/run-all.sh
git status --short
```

Expected : `all tests passed`, avec `test-suite-integrity` dans la sortie, et `git status --short` ne montrant que `tests/test-suite-integrity.sh` en fichier non suivi. Les deux fichiers de preuve doivent avoir disparu.

- [ ] **Step 6: Commit**

```bash
git add tests/test-suite-integrity.sh
git commit -m "test: garder l'intégrité de la suite elle-même"
```

---

## Rulings log

Cinq décisions, recopiées du ledger SDD avant sa suppression. La liste est exhaustive.

- **Ruling:** le contenu de la garde et ses deux preuves ont été **vérifiés au pre-flight**, puis le fichier a été supprimé et la tâche dispatchée normalement — **pourquoi :** vérifier qu'un plan annonce des sorties réelles est du travail de pre-flight, et les trois stories précédentes ont chacune livré un défaut de plan que seule la chaîne de revue a rattrapé. Garder le fichier aurait fait sauter le rapport d'implémenteur, la revue de tâche et la revue finale pour l'unique livrable de la story — **coût si c'est faux :** un dispatch dépensé à recréer un fichier dont le contenu est déjà dans le brief.

- **Ruling:** la tranche dit ce que « structurel » signifie mais **n'ajoute pas** de règle de préséance (« le comportemental l'emporte quand les deux sont possibles ») — **pourquoi :** la dérive consignée par la story précédente avertissait que cette tranche hériterait sinon de ma propre mélecture et rétrécirait la section sans que personne ne l'ait décidé ; clarifier le mot est donc dans le périmètre. Une règle de préséance est une norme neuve que l'humain n'a pas tranchée au gate, et c'est en élargissant sans mandat que la story précédente a coûté un Critical — **coût si c'est faux :** la section est d'une phrase plus faible qu'elle ne pourrait, et un lot ultérieur ajoute la règle. *La revue finale a jugé cette omission correcte, et pour une raison que je n'avais pas : le plancher assigne déjà la méthode par catégorie là où elle compte — le bullet du script d'init dit « par son comportement », ceux des skills sont par nature des assertions sur du texte. Une règle globale serait redondante sur les dix catégories existantes et ne lierait que les futures.*

- **Ruling:** modèle de milieu de gamme pour l'implémenteur et la revue de tâche, le plus capable pour la revue finale — **pourquoi :** même raisonnement que les trois stories précédentes — **coût si c'est faux :** quelques centimes.

- **Ruling:** le barrement accidentel de l'entrée de *Violations* est **annulé par retour du fichier**, puis l'entrée visée est barrée par édition du texte exact — **pourquoi :** le même `perl` avait servi aux trois stories précédentes sans dommage, mais trois entrées portent ici le titre `Verification` et le motif non gourmand a traversé les sections jusqu'à la première réservation rencontrée, barrant un défaut enregistré que nul lot n'a pris et laissant un `~~~~` derrière lui. Le contrôle arithmétique d'après-barrement l'a vu — 12 → 14 là où 13 était attendu. La leçon n'est pas « vérifier le compte », qui était déjà en place et qui a sauvé la mise : c'est qu'un outil ayant marché trois fois n'est pas validé pour la quatrième quand la forme des données change — **coût si c'est faux :** aucun ; l'état final a été vérifié entrée par entrée et la revue finale l'a reconfirmé, sans résidu.

- **Ruling:** **aucune vague de correction** n'est dispatchée après la revue finale — **pourquoi :** son unique finding *Important* vise une phrase du fichier de spec, gelé depuis la transcription, et corriger une spec est un acte humain ; ses deux *Minor* sur les renvois sont l'un antérieur à cette branche, l'autre recopié mot pour mot de l'ancienne liste de cinq, donc ni l'un ni l'autre n'est une régression de cette story. Il ne reste rien qu'un implémenteur puisse corriger — **coût si c'est faux :** la pull request porte un constat de plus à lire.

## Observed drift

Quatre constats **hors du périmètre de cette story**. Le premier vise la tranche que cette story vient d'écrire ; les trois autres lui sont antérieurs.

- **`Verification` — le bullet sur le contenu des skills promet plus que la suite ne tient.** Il énonce « chacun énonce les règles que cette spec lui attribue », quantificateur universel sur un ensemble non énuméré, là où tous ses voisins énumèrent des propriétés concrètes. `tests/test-skill-content.sh` affirme une soixantaine de chaînes littérales choisies à la main. La liste étant désormais un **plancher**, ce bullet est une obligation permanente que rien ne soutient.

  **Deux règles que la spec attribue, que les skills énoncent, et qu'aucune assertion ne touche :** la **troisième condition** de `Number allocation` — un numéro revendiqué par une branche poussée sans pull request, avec ses patrons différenciés `batch/*` et `story/*` — que `writing-a-batch` et `writing-a-user-story` portent tous deux, et que nul `grep` de `tests/` ne trouve ; et la **place de la story de levée**, dernière du lot quand le flag est à portée de lot.

  **Ce que ça coûte :** une story future réécrit l'étape de détection pour ne lire que les pull requests ouvertes, la suite reste verte, et le reviewer — lisant dans l'autorité contraignante que le contenu des skills est gardé — fusionne. Deux stories sœurs prennent alors le même `us-N`, c'est-à-dire exactement la collision silencieuse que la section `Branch naming` existe pour empêcher.

  Reformulation tenable, d'une ligne : « chacun énonce, **dans sa formulation littérale, un ensemble nommé** de règles que cette spec lui attribue ». Le fichier étant gelé, c'est une décision humaine au gate.

- **`Verification` — la clause sur les sections nommées est universelle, sa garde est énumérée.** « Chaque section nommée par un renvoi existe dans cette spec » est **vraie aujourd'hui** — le balayage des artefacts livrés ne trouve que deux renvois de ce type — mais la garde itère une paire codée en dur. Un renvoi nommé ajouté demain ne serait vérifié par rien. Antérieur à cette branche.

- **`Verification` — la clause sur les chemins est plus étroite que ses mots.** « Chaque chemin relatif cité d'un skill à l'autre existe » : la garde ne reconnaît que les chemins entre accents graves sous `skills`, `scripts`, `commands`, `tests` et `.claude-plugin`, et ne balaie que `skills/` et `commands/`. Un chemin `docs/…`, ou cité depuis `README.md`, n'est pas vérifié. **Recopié mot pour mot de l'ancienne liste de cinq**, donc pas une régression de cette story — signalé pour qu'on ne le prenne pas pour une promesse neuve.

- **`Verification` (section *Violations* du registre) — l'entrée sur les renvois numérotés sous-compte ses propres sites.** Elle annonce « quatre renvois numérotés survivent dans `tests/` » et en nomme quatre. Il y en a **neuf** : `test-command.sh`, `test-cross-references.sh` (deux), `test-declared-overrides.sh`, et `test-skill-content.sh` (cinq). L'entrée n'est pas réservée et cette story n'y a pas touché, comme il se doit — mais le lot correctif qui la prendra trouvera son énumération incomplète et pourrait s'arrêter au périmètre annoncé, comme le lot 01 l'a déjà fait une fois.
