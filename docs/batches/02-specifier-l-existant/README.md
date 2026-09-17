---
status: open
---

# 02 — Spécifier l'existant

## Scope

Ce lot fait dire à `docs/specs/supercharlouze.md` ce que le plugin fait déjà. Il
puise dans la section *Gaps* du registre `docs/specs/supercharlouze.gaps.md`,
c'est-à-dire dans les endroits où le code porte du comportement qu'aucune spec ne
décrit. Il n'ajoute aucune fonctionnalité : il ajoute de la norme là où il n'y en
avait pas, et une garde structurelle derrière chaque norme ajoutée.

**Pourquoi maintenant.** Quatre de ces silences sont des **contrats entre
skills** : la section `## Constraints` d'un document de lot recopiée verbatim
dans les `Global Constraints` de chaque story, les deux chaînes littérales de
`## Live flags` que `closing-a-batch` cherche au mot près, la liste des quatre
éléments que `Global Constraints` doit porter pour atteindre les sous-agents de
SDD. Ces canaux sont le câblage du système, et la spec n'en dit rien. Quelqu'un
qui réécrirait un skill depuis la seule spec — ce que la spec est faite pour
permettre, puisqu'elle est l'autorité contraignante de toute revue — casserait
la machine sans qu'aucune revue puisse le voir : le code resterait conforme à
une spec muette.

Le reste du périmètre tient au même fil. La spec affirme en gras qu'aucun
mécanisme ne dépend du nom de branche, alors que deux de ses propres sections
reconnaissent une branche à son nom ; les sûretés de `scripts/init.sh` sont ce
qui distingue une commande idempotente d'une commande qui écrase ; et la liste
des contrôles de `Verification` est énoncée comme close alors que la suite en
vérifie trois fois plus, si bien que chaque garde ajoutée fabrique
mécaniquement un gap neuf. Ce lot arrête cette production.

Deux entrées de *Gaps* restent délibérément hors périmètre, parce qu'elles
demandent de **décider** et non de décrire : l'invisibilité structurelle d'une
story corrective vis-à-vis de la détection de concurrence, et le niveau de
vérification qu'un renvoi doit à sa cible. L'unique entrée de *Violations* est
également hors périmètre : c'est de la matière à lot correctif, et ce lot-ci est
ordinaire.

## Spec delta

Module `supercharlouze`, une seule spec. Le delta est énoncé par section de
spec, qui est l'unité de tout ce qui se compte dans ce système.

### `The batch document`

La spec énumère les champs du document de lot — scope, spec delta, feature flag
— et ignore deux sections que `writing-a-batch` impose et que d'autres skills
lisent. Le delta les ajoute :

- **`## Constraints`** : contraintes de migration et de compatibilité, ordre
  requis des stories, `none` s'il n'y en a pas. Elle est recopiée **verbatim**
  dans les `Global Constraints` de chaque story, où `superpowers:writing-plans`
  en fait implicitement une exigence de chaque tâche. Elle ne porte rien de
  normatif : la spec reste seule autorité sur le comportement.
- **`## Live flags`** : chaque flag vivant remonté au gate d'ouverture, avec la
  décision de l'humain écrite sous l'une de **deux chaînes littérales** —
  `carried by this batch — lifting story owed` ou `not this batch — <reason>` —
  et `none` s'il n'y en a pas. Le caractère littéral est **normatif et non
  stylistique** : `closing-a-batch` reconnaît un flag hérité par correspondance
  au mot près, et cette section est le seul canal par lequel une décision prise
  au gate d'ouverture atteint le contrôle de clôture. Une reformulation rend le
  flag invisible du seul contrôle qui pouvait le rattraper.

### `The user story document`

La spec énonce que `Global Constraints` porte deux choses ;
`writing-a-user-story` y en met quatre. Le delta porte la liste à quatre :
les contraintes du lot recopiées verbatim, le gel du fichier de spec, la règle
« la spec gagne, et corriger une spec est un acte humain », et — en lot
correctif seulement — la cinquième condition d'arrêt recopiée intégralement.

Le motif est écrit avec, parce qu'il est load-bearing : `Global Constraints` est
le seul canal que lisent les sous-agents implémenteurs de SDD. Une règle
énoncée ailleurs n'atteint jamais l'agent qui doit l'appliquer, et une condition
d'arrêt qu'on n'atteint pas ne s'arrête sur rien.

### `Closing a batch`

Trois précisions sur les six devoirs, qu'aucun document validé ne porte :

- Le **contrôle du devoir 5 s'exécute avant les devoirs 1 à 4**, la numérotation
  restant celle du modèle. Motif : le devoir 5 n'écrit rien et il lui est permis
  de refuser ; les quatre autres écrivent, et aucun n'est rejouable sans
  dupliquer ses effets — un refus tardif échouerait quatre devoirs d'écriture
  sur une branche que personne ne peut fusionner.
- Le devoir 5 porte sur les flags que le lot a **déclarés** *et* sur ceux qu'il a
  **hérités** par une décision au gate d'ouverture. Pour un flag hérité, **la
  décision remplace la déclaration comme test** : le flag déclaré par un lot
  antérieur a déjà une portée et une condition de levée, donc le lire contre la
  règle générale l'acquitterait à tous les coups. La décision humaine rend cette
  portée dépensée, et l'entrée n'est réglée que si le flag a disparu du code
  **et** de la phrase de gating de la spec.
- Le devoir 4 **n'a rien à comparer pour un lot correctif**, dont le spec delta
  est vide par définition ; le devoir 3 en tient lieu, et les entrées libérées ne
  sont pas reclassées en gaps neufs.

### `Branch naming` et `Git model`

`Branch naming` affirme en gras : « **Aucun mécanisme de ce système ne dépend du
nom de branche** ». Deux sections de la même spec la contredisent :

- `Number allocation` refuse un numéro « non revendiqué par une branche poussée
  qui ne porte pas encore de pull request », et précise que `NN` se cherche
  contre `batch/*` **et** `story/*` ;
- `Concurrency detection` lit comme seconde source « les branches `story/*`
  poussées qui ne portent pas encore de pull request ».

Les deux reconnaissent une branche **à son nom**, et précisément sur la fenêtre
où la pull request n'existe pas encore — celle que la spec décrit ailleurs comme
« ce qui rend le mécanisme vrai ». Une branche que l'outil natif du harnais a
nommée autrement est invisible des deux. Le delta :

- **retire la phrase fausse** et pose que le nom conventionnel doit être
  **rétabli** quand l'outil natif en a choisi un autre — la lecture stricte, que
  `writing-a-batch` applique déjà et que `adopting-a-module` et
  `closing-a-batch` devront rejoindre ;
- **ajoute à la table de nommage la ligne manquante** : une pull request
  d'amendement part d'une branche distincte au nom sans signification, jamais
  `batch/NN-<slug>`, que la pull request d'ouverture peut encore tenir sur le
  remote.

### `Module adoption`

**Rien à transcrire.** L'entrée du registre affirme que la spec ordonne les
étapes de l'adoption sans y placer la création de la branche ; la spec la place
à son étape 3, entre la présentation de l'inventaire et l'écriture des
documents, au même rang que `adopting-a-module`. Les deux documents ont été
écrits dans la même pull request d'adoption. L'entrée est **fausse telle
qu'écrite** : elle est barrée avec son motif dans la pull request de la story,
et rien n'entre dans la spec de son fait.

### `The init command` et `Document layout`

La spec réduit l'init à « insérer ou mettre à jour, sans jamais dupliquer ». Le
delta rend normatives les sûretés que `scripts/init.sh` porte déjà : refus de
**toute** l'exécution si un document archivé occupe déjà un chemin de
destination, **avant** de déplacer quoi que ce soit ; refus laissant le fichier
intact si les marqueurs `CLAUDE.md` sont absents d'un côté, dupliqués ou
inversés ; appariement des marqueurs sur la **ligne entière**, pour qu'une prose
qui les cite ne soit pas prise pour un bloc ; préservation du mode du fichier ;
suppression de l'arborescence `docs/superpowers` une fois vidée.

`Document layout` dit en outre ce qu'un dépôt porte entre l'init et la première
spec : `docs/specs/` et `docs/batches/` **ne survivent pas à un clone**, git ne
suivant pas les répertoires vides, et rien n'en dépend avant la première spec
puisque `init` les recrée à chaque exécution.

### `Verification`

La liste des cinq contrôles est énoncée comme close alors que la suite en
vérifie davantage — cas limites de l'init, assertions de contenu sur les quatre
skills productifs, assertions sur le fichier de commande, gardes livrées par le
lot 01. Le delta la reformule en **plancher** — ce que la suite doit au minimum
couvrir — et l'étend aux catégories déjà servies : métadonnées de plugin, front
matter des skills, renvois entre skills et existence des sections nommées,
insertion du bloc `CLAUDE.md` et ses cas limites, les quatre overrides déclarés,
assertions de contenu sur les quatre skills productifs, fichier de commande.

Un plancher et non une liste close : énumérée exhaustivement, la liste ferait de
chaque garde neuve un gap neuf, ce qui est exactement l'entrée que cette tranche
résorbe.

### Entrées réservées par ce lot

Douze entrées de la section *Gaps* de `docs/specs/supercharlouze.gaps.md`,
annotées `reserved by batch-02` par cette pull request : les deux entrées
*The batch document*, les trois entrées *Closing a batch*, l'entrée
*The user story document*, l'entrée *Module adoption*, les deux entrées
*Branch naming*, l'entrée *The init command*, l'entrée *Document layout*, et
l'entrée *Verification* portant sur l'étendue de la suite de tests.

Ne sont **pas** réservées, et restent disponibles : l'entrée
*Concurrency detection / The user story document*, l'entrée *Verification*
portant sur ce qu'un renvoi doit à sa cible, et l'unique entrée de *Violations*.

## Constraints

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

## Feature flag

Feature flag: none — chaque story est complète dans sa propre pull request

Le critère d'exemption est une question : une story de ce lot, fusionnée seule,
laisserait-elle un utilisateur devant quelque chose d'incomplet ? Non. Chaque
story écrit dans la spec du comportement que le code produit déjà, et barre les
entrées du registre qu'elle résorbe ; rien n'est jamais à moitié livré, et il
n'existe aucun état intermédiaire à masquer. Ce n'est pas l'exemption
« refactor » invoquée par commodité — c'est le critère lui-même qui répond non.

## Live flags

none

Vérifié sur l'intégralité de `docs/specs/supercharlouze.md`, au niveau du
module et non des sections visées. Le fichier ne contient qu'une seule
occurrence de `🔒`, ligne 201 : c'est l'**exemple illustratif** de la section
*The spec document*, à l'intérieur d'un bloc de code, qui montre la forme
qu'une phrase de gating doit prendre sans en déclarer une. Aucun flag n'est
vivant sur ce module, et ce lot n'en hérite aucun.
