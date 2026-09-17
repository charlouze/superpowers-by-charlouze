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

## Observed drift
