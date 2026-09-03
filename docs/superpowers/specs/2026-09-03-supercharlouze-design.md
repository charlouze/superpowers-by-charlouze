# supercharlouze — Design

**Goal:** un plugin Claude Code qui surcharge l'organisation des specs et des
plans de superpowers. Il remplace les documents de conception datés et jetables
par une spécification vivante par module fonctionnel, et remplace les plans
isolés par des *batches* de user stories qui font grandir ces specs.

**Status:** conception validée le 2026-09-03, révisée après quatre relectures
adversariales. Rien n'est encore implémenté.

**Plugin name:** `supercharlouze` (namespace de tous les skills). Dépôt :
`superpowers-by-charlouze`.

**Target harness:** Claude Code uniquement.

---

## 1. Problem

superpowers écrit un document de conception daté par fonctionnalité
(`docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`) et un plan par
fonctionnalité (`docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`). Les
deux sont des instantanés d'une intention à un moment donné, et aucun n'est
jamais repris.

Rien ne capitalise. Au bout de dix fonctionnalités, le comportement d'un module
est éparpillé dans dix documents qui décrivent chacun un delta et dont aucun ne
décrit l'état courant. Aucun artefact ne répond à la question « que fait le
module facturation aujourd'hui ? » — et par conséquent aucun artefact ne peut
révéler que le code a dérivé de ce qui avait été validé.

## 2. Model

**Module** — un domaine fonctionnel grossier, vu de l'extérieur. Les modules
sont délimités par l'humain, jamais déduits par un agent. Préférer peu de gros
modules à beaucoup de petits : un projet à trois modules est normal, un projet
à quinze est une erreur de découpage. Ce plugin entier constitue un seul
module.

**Spec** — un document vivant par module, dans `docs/specs/<module>.md`. Elle
est **normative** (ce que le code doit faire), pas descriptive (ce que le code
fait par accident). Elle ne porte pas de date. Elle est l'autorité contraignante
de toutes les revues.

**Section** — la plus petite unité titrée d'une spec. C'est l'unité de tout ce
qui se compte dans ce système : un conflit de concurrence se juge sur une
section, une entrée de gaps register désigne une section. Le mot « exigence »
n'est pas employé comme unité, faute de pouvoir en définir la granularité.

**Batch** (« lot ») — l'unité de livraison, dans `docs/batches/NN-<slug>/`. Un
batch regroupe plusieurs user stories. Sa raison d'être est d'ajouter des
fonctionnalités à une ou plusieurs specs. Un batch peut être transverse à
plusieurs modules.

**User story** — un plan d'implémentation, dans
`docs/batches/NN-<slug>/NN-us-N-<slug>.md`. Elle appartient à exactement un
batch et vise exactement **un** module, donc une seule spec. C'est aussi l'unité
de livraison technique : **une story, une branche, une pull request** — et cette
pull request porte *à la fois* la tranche de spec et le code qui la réalise
(§5.1).

**Corrective batch** — un batch dont le spec delta est vide. Son but est de
remettre le code existant en conformité avec une spec déjà vraie. Son périmètre
est puisé dans le gaps register d'un module.

**Feature flag** — le mécanisme qui rend une story livrable seule sans exposer un
lot à moitié fait. `main` est déployée en continu (§5.1), donc chaque story
fusionnée part en production ; un lot dont les stories exposeraient du
comportement incomplet en déclare un.

**Le flag est un objet spécifié, pas un détail d'implémentation.** La section de
spec concernée énonce son nom et son défaut — *« derrière le flag
`billing.recurring`, désactivé par défaut »*. Sans cette déclaration, une story
fusionnée derrière un flag rendrait la spec fausse au sens des utilisateurs, et
rouvrirait par la fenêtre exactement l'écart que le §4.1 sert à fermer.

**Le flag est par couple (lot, module).** Pas par story — le lot est la frontière
au-delà de laquelle il n'y a plus rien d'incomplet. Mais pas par lot non plus :
un lot transverse (§2) qui garde du comportement dans deux modules déclare
**deux** flags, un par module. Sans quoi sa story de levée devrait retirer la
phrase de gating dans deux specs, alors qu'une story vise exactement un module —
elle serait impossible à écrire. Avec un flag par module, chaque module a sa
phrase, son branchement et sa story de levée, et l'invariant tient.

**Sa durée de vie est courte, et c'est le lot qui la borne par défaut.** Un flag
qui traîne est du code mort que plus personne n'ose retirer — le mode de panne
classique, et il est silencieux.

**Portée étendue, par exception.** Un flag peut légitimement survivre à son lot :
un module entier construit sur plusieurs lots, qu'on n'ouvre qu'une fois complet,
en est le cas type. Le flag déclare alors sa portée **et la condition qui le
lève** — « levé quand le module `facturation` est intégralement livré ». Cette
déclaration n'est pas une formalité : c'est elle qui distingue un flag encore
utile d'un flag oublié, et sans elle les deux se ressemblent exactement.

Un flag à portée étendue n'est pas orphelin pour autant, parce qu'il vit dans la
**spec du module** : sa phrase de gating est lue par quiconque lit la spec, à
chaque adoption, à chaque audit, à chaque ouverture de lot touchant la section.
C'est sa visibilité qui le protège de l'oubli, pas un registre séparé.

**Le critère d'exemption tient en une question :** *une story de ce lot,
fusionnée seule, laisserait-elle un utilisateur devant quelque chose
d'incomplet ?* Si non, pas de flag. Trois familles répondent non par
construction :

- **Refactor et infrastructure** — ils ne changent aucun comportement, donc
  chaque pull request est déployable telle quelle. C'est la définition même d'un
  refactor, pas une tolérance qu'on leur accorde.
- **Lot correctif** — il rétablit un comportement déjà promis par la spec. Le
  garder derrière un flag reviendrait à retarder une mise en conformité, ce qui
  est l'inverse de son objet. En pratique il tient souvent en une seule story.
- **Lot à story unique** — rien n'est jamais à moitié livré.

## 3. Authority and conflict rules

La spec est l'autorité contraignante. Le batch ne porte que ce qu'une spec ne
peut pas porter : le périmètre de livraison, l'ordre des user stories, les
contraintes de migration et de compatibilité, et la raison pour laquelle ce
travail a lieu maintenant.

**Quand un batch et une spec se contredisent, la spec gagne — sans exception et
sans délibération.** L'agent implémente ce que dit la spec, inscrit un
`Ruling:`, et poursuit. **Corriger une spec en cours de batch est un acte
humain, jamais un acte d'agent.**

**Corollaire opérationnel — le gel du fichier de spec, et sa borne.** Parce que
la tranche de spec et le code voyagent dans la même branche (§5.1), le fichier
de spec est physiquement éditable par les tâches de SDD, ce qu'il n'était pas
quand il vivait ailleurs. La règle est donc portée au niveau du fichier, **avec
un début et une fin** :

> Entre le commit de transcription et l'ouverture de la pull request, aucune
> tâche ne modifie le fichier de spec. Une story qui découvre que la spec doit
> changer s'arrête.

Après l'ouverture de la pull request, le gel est levé : les demandes de la revue
sont des décisions humaines, y compris sur la formulation de la tranche de spec,
et elles s'appliquent sur la branche de la story (§5.3). Un gel sans borne
rendrait littéralement impossible de répondre à une revue — ou de résoudre un
conflit de fusion portant sur le fichier de spec.

Cette règle est recopiée dans la section `Global Constraints` de chaque plan
(§4.4), donc sous les yeux de chaque implémenteur et de chaque reviewer.

**Tout conflit est consigné pour l'humain.** On réutilise le mécanisme existant
plutôt que d'en inventer un : `superpowers:subagent-driven-development` tient un
ledger dont les décisions prennent la forme
`Ruling: <décision> — <pourquoi> — <ce que ça coûte si c'est faux>`, et les
présente sous le titre « Rulings I made » avant de supprimer son workspace. Ces
rulings sont recopiés dans le document de story, sur la branche de la story,
avant que la pull request soit fusionnée — donc dans la session où ils existent
encore.

**Concurrence.** Deux stories qui touchent la même section d'une même spec sont
un conflit. **La détection est celle du §5.3 : chaque document de story déclare
les sections qu'elle touche, et une story qui démarre les compare à celles des
pull requests ouvertes.** Le conflit de fusion git n'est qu'un filet **partiel**
— git conflicte sur des lignes, pas sur des sections, donc deux stories
modifiant la même section à des endroits éloignés fusionnent proprement. Compter
sur lui reviendrait à laisser passer exactement le cas qu'on veut attraper.

## 4. Artifact layout

```
docs/
  specs/
    facturation.md                spec vivante, une par module, non datée
    facturation.gaps.md           gaps register du module
  batches/
    07-facturation-recurrente/
      README.md                   le batch
      07-us-1-abonnement.md       une user story = un plan superpowers
      07-us-2-relance.md
  archive/
    specs/                        anciens docs/superpowers/specs/
    plans/                        anciens docs/superpowers/plans/
```

Les *patrons* de chemins sont anglais et figés ; les *slugs* suivent la langue
du projet, puisqu'ils nomment des objets métier (§10).

**Attribution des numéros.** `NN` (batch) et `us-N` (story) suivent la même
règle : le plus petit entier non utilisé **dans `docs/batches/` sur `main`** et
**non revendiqué par une pull request ouverte** (`gh pr list`). Les deux
conditions sont nécessaires, et pour la même raison dans les deux cas : un
artefact n'atteint `main` qu'à la fusion de sa pull request, donc le contenu du
répertoire ignore tout ce qui est en vol. Se fier au seul contenu de `main`
ferait prendre le même numéro à deux batches ouverts en parallèle, ou à deux
stories écrites pendant qu'une troisième est en revue.

**Le préfixe `NN-` des fichiers de story** garantit l'unicité des basenames.
Sur le chemin nominal il est confortable plutôt que nécessaire : chaque story
s'exécute dans son propre worktree, et `sdd-workspace` résout son répertoire via
`git rev-parse --show-toplevel`, donc deux stories ont des workspaces
physiquement disjoints. Il devient nécessaire sur les chemins dégradés — worktree
refusé par l'humain, isolation indisponible — où deux stories partageraient un
checkout : `sdd-workspace` dérive alors le workspace du **basename** du plan, et
deux `us-1-setup.md` partageraient `progress.md`. SDD détecterait un ledger
étranger, mais sa consigne — le laisser en place et en démarrer un autre — est
inapplicable au même chemin.

**Nommage des branches**, appliqué par le plugin et non par superpowers :

| Type de pull request | Branche |
|---|---|
| Story | `story/NN-us-N-<slug>` |
| Ouverture de batch | `batch/NN-<slug>` |
| Clôture de batch | `batch/NN-<slug>-close` |
| Adoption d'un module | `adopt/<module>` |
| `init` | `chore/supercharlouze-init` |
| Bounded (§8.2) | `fix/<slug>` |

Ce nommage est une convention que le plugin **fait respecter lui-même** (§5.1),
pas une propriété de `superpowers:using-git-worktrees` : ce skill préfère les
outils natifs du harness, qui choisissent le nom de branche, et peut aboutir à
un HEAD détaché dont la branche ne sera nommée qu'au moment de la finition.
Aucun mécanisme de ce document ne dépend du nom de branche — l'identification
passe par la pull request et par le document de story.

### 4.1 Spec document

Décrit le comportement. Ni date, ni statut, ni marqueur — **rien qui signale un
travail en cours**. C'est une propriété du modèle git et non une préférence de
style : sur `main`, la spec et le code avancent ensemble, dans la même pull
request (§5.1), donc il n'existe jamais d'état où la spec décrirait quelque
chose que le code ne fait pas encore.

- Une table **Changelog** en pied de document porte l'historique :
  `batch | date | change`. **Une ligne par batch, écrite par `closing-a-batch`**
  (§5.4) — pas une ligne par story. Le changelog est de granularité batch par
  nature ; le faire écrire par chaque story ferait conflicter au même point
  toutes les stories d'un même module en vol simultanément, ce qui est le
  régime nominal. Les modifications faites hors de tout batch (§8.2) portent
  `out-of-batch` et sont écrites par leur propre pull request.
- Une section **Sources** liste les documents validés consommés lors de
  l'adoption (§6), par leur chemin **après archivage** (`docs/archive/...`).
  Elle est ce qui rend calculable l'état des lieux de `init` (§9).

Le changelog est un confort de lecture, pas un mécanisme : aucune règle de ce
document n'en dépend. L'historique faisant autorité est celui du fichier lui-même
(`git log docs/specs/<module>.md`), et il est exact par construction puisque
chaque changement de spec voyage avec son code.

**Comportement sous flag.** Une section décrivant un comportement encore gardé
énonce son flag, son défaut, et — si la portée dépasse le lot — **sa condition de
levée** (§2) :

```markdown
🔒 `billing.recurring`, off by default — lifted when the `facturation` module is fully delivered
```

La spec reste donc exactement vraie : elle ne décrit pas seulement ce que le code
fait, mais **ce qu'il expose et sous quelle condition**. Cette phrase disparaît
quand le flag est retiré (§5.3), et c'est un changement de spec comme un autre.

**La condition de levée est écrite ici et pas seulement dans le document de
lot**, parce que c'est ici qu'on la lit. Le document de lot finit par se clore ;
la spec, elle, est relue à chaque adoption, chaque audit et chaque ouverture de
lot. Une condition qui ne vivrait que dans un document clos, sans pointeur depuis
la spec, rendrait indiscernables un flag encore utile et un flag oublié —
c'est-à-dire exactement la distinction dont dépend le §5.4.

**La règle de dérive s'énonce alors sans exception :** *toute divergence entre
la spec de `main` et le code de `main` est une dérive*, donc du travail
correctif. Il n'y a pas de cas « pas encore livré » à excepter, parce que ce cas
n'existe pas.

### 4.2 Gaps register

`docs/specs/<module>.gaps.md` est un document vivant, pas un rapport jetable.
Deux sections distinctes, parce qu'elles ne se traitent pas pareil :

- **Violations** — le code contredit la spec. Alimente un *corrective batch*.
- **Gaps** — le code fait des choses qu'aucune spec ne décrit. Alimente un
  batch ordinaire qui les spécifie enfin.

**Qui écrit dedans.** Il faut distinguer deux gestes, parce qu'ils n'ont pas le
même profil de contention.

**Ajouter une entrée** — `adopting-a-module` à la création (§6.4), puis
**`closing-a-batch`** seul, qui consolide en une pull request les dérives que les
stories du batch ont constatées hors périmètre. Les stories **n'ajoutent pas** :
elles consignent leurs constats dans leur propre document, sous **Observed
drift**. Un ajout se fait en fin de section et concurrence tous les autres ajouts
du même module — c'est exactement la contention que le changelog vient d'éviter,
et elle se règle de la même façon : un seul écrivain par batch.

**Barrer une entrée existante** — la pull request de la story qui la résorbe, ou
d'un bounded. Le geste est local à une ligne déjà écrite, donc deux stories qui
barrent des entrées différentes ne se marchent pas dessus. Le §5.3 en fait même
le premier commit d'une story corrective, précisément pour fixer son périmètre.

Un bounded (§8.2) n'appartient à aucun batch : il ajoute comme il barre,
directement, et ne concurrence qu'un autre bounded.

**Réservation, consommation, libération.** Chaque entrée désigne une section de
la spec.

- **Réservée** par la pull request d'ouverture du batch qui la prend en charge
  (annotation `reserved by batch-08`).
- **Barrée** par la pull request de la story qui la résorbe, atomiquement avec
  le code qui la résorbe.
- **Libérée** par `closing-a-batch` si elle n'a pas été consommée — story
  abandonnée, périmètre revu. Sans cette étape, une story abandonnée laisserait
  sur `main` une réservation perpétuelle qui empêcherait tout autre batch de
  reprendre l'écart : la réservation vit sur `main`, fermer la pull request de
  la story ne l'emporte pas.

Le registre déclare aussi **sa propre couverture** : quelles parties du module
ont été auditées, lesquelles ne l'ont pas été, et pourquoi. Un registre vide qui
signifie « rien n'a été examiné » ne doit pas ressembler à un registre vide qui
signifie « tout est conforme ».

### 4.3 Batch document

Un `README.md` avec un front matter `status: open | closed`, et :

- **Scope** — ce que ce batch livre, et pourquoi maintenant.
- **Spec delta** — le comportement ajouté à chaque spec, énoncé comme
  intention. Ce delta n'est transcrit dans aucune spec à l'ouverture : il l'est
  tranche par tranche, par la pull request de chaque story (§5.3). Pour un
  corrective batch, ce champ est vide et remplacé par les entrées du gaps
  register que le batch réserve.
- **Feature flag** — le nom du flag, son défaut, et sa **portée** ; ou `none`
  avec la raison de l'exemption (§2). Ce champ est **obligatoire et jamais
  vide** : « aucun flag » doit être une décision énoncée et revue, pas un oubli.
  C'est le gate d'ouverture (§5.2) qui l'examine, et c'est le bon endroit — au
  moment où le périmètre du lot est encore devant nous.

  ```markdown
  Feature flag: `billing.recurring`, off by default — scope: this batch
  Feature flag: `billing.recurring`, off by default — scope: beyond this batch,
                lifted when the `facturation` module is fully delivered
  Feature flag: none — corrective batch, restores behaviour the spec already promises
  ```

  Une portée qui dépasse le lot **doit nommer sa condition de levée**. C'est la
  seule chose qui distingue un flag encore utile d'un flag oublié.

**Le document de batch ne porte aucun état mutable**, et c'est délibéré : il est
écrit une fois par sa pull request d'ouverture, et **rien dans le déroulement
normal ne le modifie**.

Il reste **amendable par une pull request d'amendement**, revue comme les autres.
C'est le chemin de sortie de deux impasses réelles : un lot exempté de flag qui
découvre en chemin qu'il en fallait un — un « refactor » qui changeait du
comportement, un lot mono-story qui se scinde — et un lot dont on décide de
réduire ou d'abandonner le périmètre. Sans ce chemin, ces deux situations n'ont
aucune issue : le champ `Feature flag` a été décidé à l'ouverture et la clôture
le contrôle. L'amendement n'est pas de l'état mutable au fil de l'eau — c'est une
décision humaine explicite, qui passe par une revue.

Deux conséquences de l'absence d'état mutable.

- **La liste des stories n'y figure pas** : elle est le contenu du répertoire du
  batch, complété par les pull requests ouvertes. Une liste maintenue à la main
  serait modifiée par chaque story et produirait un conflit de fusion à chaque
  fois, pour aucune information que le système ne possède déjà.
- **L'état d'une story n'y figure pas non plus** : l'état d'une story *est*
  l'état de sa pull request. Cocher une case reviendrait à recopier une vérité
  que `gh pr list` donne mieux, et à la désynchroniser dès la première pull
  request fusionnée hors session.

### 4.4 User story document

Un plan superpowers standard, produit par `superpowers:writing-plans`,
enregistré dans le répertoire du batch, avec un header étendu :

```markdown
**Spec:** docs/specs/facturation.md
**Batch:** docs/batches/07-facturation-recurrente/README.md
**Sections:** Abonnement > Renouvellement, Abonnement > Proration
```

`Spec:` est le champ que `subagent-driven-development` lit déjà comme autorité
contraignante — le faire pointer vers la spec vivante du module est ce qui fait
fonctionner l'intégration sans modifier superpowers.

`Sections:` **est le mécanisme de détection de concurrence** (§3, §5.3). Il est
déclaré et non déduit : lire un diff pour deviner quelles sections une story
touche est fragile, alors que l'auteur de la story le sait.

Le document porte en outre un **Rulings log** et une section **Observed drift**,
remplis avant la fusion (§3, §4.2).

**Ce montage n'est correct qu'à trois conditions**, toutes load-bearing :

1. **La transcription est incrémentale** — une tranche par story, jamais le
   delta complet du batch. Sinon la spec décrirait, pendant l'exécution de la
   story 1, le comportement des stories suivantes, et les reviewers de SDD
   signaleraient comme manquant ce qui n'est pas encore livré.
2. **La transcription est le premier commit de la branche**, avant que le plan
   soit écrit et que la moindre tâche s'exécute. Pas pour une raison de
   visibilité — le fichier serait lisible dans le worktree même non commité —
   mais parce que c'est ce qui rend la norme **antérieure et opposable** au
   code : elle est déjà dans l'histoire de la branche quand l'implémentation
   commence, elle voyage dans la pull request, et le gel du §3 a un point de
   départ identifiable.
3. **La branche part d'un `main` à jour, depuis le checkout principal** (§5.1).

`Global Constraints` — que `superpowers:writing-plans` définit comme faisant
implicitement partie des exigences de chaque tâche — porte deux choses : les
contraintes que le batch impose, recopiées mot pour mot, et **le gel du fichier
de spec** (§3).

## 5. Batch lifecycle

Vue d'ensemble. Les losanges hexagonaux sont les **gates humains**, et chacun est
une revue de pull request — le plugin n'en ajoute aucun ailleurs.

```mermaid
flowchart TD
    REQ["Demande architecturale"] --> ADOPTED{"Module adopté ?"}

    ADOPTED -->|non| AD["adopting-a-module"]
    AD --> ADPR[["PR : spec + gaps register"]]
    ADPR --> ADG{{"Revue = gate d'adoption"}}
    ADG --> WB

    ADOPTED -->|oui| WB["writing-a-batch"]
    WB --> BPR[["PR : document de batch<br/>scope, spec delta, réservations<br/>feature flag ou exemption motivée"]]
    BPR --> BG{{"Revue = gate d'ouverture"}}

    BG --> WS["writing-a-user-story"]
    WS --> SPR[["PR : tranche de spec + code<br/>gardé par le flag s'il y en a un"]]
    SPR --> SG{{"Revue = gate de livraison"}}

    SG --> MORE{"D'autres stories ?"}
    MORE -->|oui, une par une| WS
    MORE -->|non| FLAG{"Ce lot lève-t-il un flag ?"}
    FLAG -->|oui| LIFT["Story de levée — une par module gardé<br/>écrite via writing-a-user-story"]
    LIFT --> LPR[["PR : retrait du branchement<br/>et de la phrase de gating"]]
    LPR --> LG{{"Revue = gate de livraison"}}
    LG --> CB
    FLAG -->|"non — portée étendue déclarée,<br/>ou lot sans flag"| CB["closing-a-batch"]
    CB --> CPR[["PR : changelog, consolidation, libérations,<br/>constats, contrôle des flags, status: closed"]]
    CPR --> CG{{"Revue = gate de clôture"}}

    SG -.->|PR fermée sans fusion| ABANDON["Story abandonnée<br/>rien à révoquer"]
    ABANDON -.->|résidus sur main| CB
```

L'arête pointillée est le seul chemin non nominal : une story abandonnée ne
laisse rien dans la spec, mais laisse sur `main` sa réservation au gaps register
et l'intention annoncée par le batch — que la clôture doit constater (§5.4).

### 5.1 Git model

Deux contraintes du projet, pas des choix de ce plugin, et tout le modèle en
découle :

- **`main` est protégée** : tout passe par une pull request.
- **`main` est déployée en continu** : chaque fusion part en production.

La seconde est la raison d'être des feature flags (§2), et elle **écarte les deux
alternatives naturelles**. Une branche de lot, ou une branche `develop` façon
gitflow, protégeraient la production en retenant le travail — mais au prix d'un
angle mort : une story fusionnée dans une branche de lot n'est ni une pull
request ouverte ni sur `main`, donc elle devient invisible à la détection de
concurrence du §5.3, pour toute la durée du lot. Et une branche `develop` fait
pire : elle crée **deux baselines** pour la règle de dérive — la spec de
référence sur `develop`, le code en production sur `main` — et un lot correctif
ne sait plus contre quoi il corrige. Le flag protège la production sans retenir
le code, donc sans créer ni angle mort ni seconde baseline.

**Une pull request de story porte la tranche de spec et le code qui la
réalise.** Ils sont livrés ensemble ou pas du tout. C'est ce qui donne à `main`
sa propriété centrale : **sa spec décrit toujours exactement ce que son code
fait.** Aucun état intermédiaire à signaler, donc aucun marqueur, aucune
sémantique à faire comprendre à des agents qui ignorent ce plugin, et aucune
exception à la règle de dérive.

```mermaid
gitGraph
    commit id: "état initial"
    branch "batch/07-facturation-recurrente"
    commit id: "document de batch"
    checkout main
    merge "batch/07-facturation-recurrente" tag: "PR #40"
    branch "story/07-us-1-abonnement"
    commit id: "us-1 tranche de spec"
    commit id: "us-1 test rouge"
    commit id: "us-1 implémentation"
    commit id: "us-1 rulings"
    checkout main
    branch "story/07-us-2-relance"
    commit id: "us-2 tranche de spec"
    checkout main
    merge "story/07-us-1-abonnement" tag: "PR #41"
    checkout "story/07-us-2-relance"
    commit id: "us-2 implémentation"
    checkout main
    merge "story/07-us-2-relance" tag: "PR #42"
    branch "batch/07-close"
    commit id: "changelog, status closed"
    checkout main
    merge "batch/07-close" tag: "PR #43"
```

Ce graphe porte l'invariant central : **la tranche de spec est le premier commit
de chaque branche**, et elle rejoint `main` par la même fusion que son code. À
aucun instant `main` ne connaît une spec en avance sur son code. Les deux stories
sont en vol simultanément — c'est le régime nominal, pas un cas limite. Et
`main` ne reçoit **que des fusions** : l'ouverture et la clôture du lot ont leurs
propres branches, comme tout le reste.

**Les gates humains sont des revues de pull request.** Le plugin n'ajoute pas de
cérémonie : il place ses points de validation là où votre flux en a déjà.

| Gate | Artefact revu |
|---|---|
| Adoption d'un module (§6.5) | la PR portant la spec et le gaps register |
| Ouverture d'un batch (§5.2) | la PR portant le document de batch |
| Livraison d'une story | la PR portant la tranche de spec et le code |
| Clôture d'un batch (§5.4) | la PR portant changelog, consolidation et `status: closed` |
| Amendement d'un batch (§4.3) | la PR portant la décision de changer son périmètre ou son flag |

**L'abandon d'une story est presque gratuit.** Fermer sa pull request sans la
fusionner jette la transcription avec le code : rien à révoquer, aucune spec à
remettre d'aplomb. Deux résidus subsistent néanmoins sur `main`, et ils ont un
porteur (§5.4) : la réservation au gaps register posée par la PR d'ouverture du
batch, et l'intention annoncée dans le spec delta du batch et jamais livrée.

**Création de la branche.** Le plugin crée lui-même la branche au nom
conventionnel (§4) et l'espace de travail, en invoquant
`superpowers:using-git-worktrees`. Si ce skill aboutit à une branche autrement
nommée, à un HEAD détaché, ou si l'isolation est refusée, le plugin s'assure
qu'une branche nommée existe avant de continuer — aucun mécanisme ne dépend du
nom, mais une branche doit exister pour qu'une pull request puisse être ouverte.

SDD, à son démarrage, invoque `superpowers:using-git-worktrees`, dont le **Step 0**
détecte `GIT_DIR != GIT_COMMON`, conclut « already in a linked worktree » et
réutilise l'existant. C'est le comportement documenté de ce skill, pas un
détournement — et c'est bien à lui qu'il appartient, non à SDD, qui ne fait que
l'appeler. Ce Step 0 comporte aussi un garde sous-module : dans un sous-module,
`GIT_DIR != GIT_COMMON` est vrai sans qu'il s'agisse d'un worktree. Un projet en
sous-modules sort donc du chemin décrit ici, et ce plugin ne le couvre pas.

**Préconditions, à vérifier avant de créer une branche, pour toute pull request
de ce système :**

- **Être dans le checkout principal.** `finishing-a-development-branch`
  **préserve** le worktree sur le chemin « PR ». Une session qui enchaîne deux
  stories sans en sortir verrait `using-git-worktrees` sauter la création et
  poser le code de la seconde story sur la branche de la première.
- **Être sur `main`, rafraîchie.** Les fusions arrivent depuis le remote : sans
  `fetch`/`pull`, l'attribution des numéros et la détection de concurrence
  raisonnent sur un état périmé.

**Hypothèse assumée :** `gh` est disponible et authentifié. L'attribution des
numéros et la détection de concurrence l'interrogent. Sans lui, les deux
dégradent vers un filet partiel — collision visible à l'ouverture de la pull
request, conflit de fusion — mais elles ne préviennent plus.

### 5.2 Opening — `writing-a-batch`

Vérifier que chaque module touché possède une spec adoptée ; sinon l'adoption
est un préalable bloquant (§6). Attribuer `NN` (§4). Rédiger le document de
batch : scope, spec delta comme intention, et le champ `Feature flag` (§4.3).
Pour un corrective batch, réserver dans le gaps register les entrées prises en
charge (§4.2). **Aucune écriture dans les specs à ce stade.**

**Faire remonter les flags vivants — au niveau du module, pas de la section.**
Lister toute phrase de gating présente dans les specs des modules que ce lot
touche, quelles que soient les sections visées, et la reporter dans le document
de batch avec sa condition de levée. L'humain tranche au gate : ce lot
satisfait-il la condition, et porte-t-il donc la story de levée (§5.3) ?

La granularité est ce qui rend le contrôle utile. Une remontée limitée aux
sections que le lot modifie laisserait un flag à portée étendue survivre
indéfiniment : le dernier lot d'un module ajoute typiquement des sections neuves
sans toucher les anciennes, donc rien ne remonterait, le module serait
« intégralement livré », et le flag resterait éteint pour toujours. Les modules
étant grossiers par construction (§2), remonter au module coûte peu et ferme ce
trou. C'est ici, et nulle part ailleurs, qu'on redemande à chaque lot si un flag
est arrivé à terme.

Ouvrir la pull request du batch. **Sa revue est le gate humain** : tant qu'elle
n'est pas fusionnée, aucune story ne s'écrit. C'est la transposition du gate de
superpowers, qui fait relire la spec écrite avant de passer à la planification —
avec l'avantage que la revue a lieu dans l'outil où vous revoyez déjà tout le
reste.

### 5.3 Running — `writing-a-user-story`

Les user stories sont écrites **une par une** : la story N+1 est écrite en
connaissant ce qu'a produit la story N. Plusieurs peuvent être en vol
simultanément, c'est le régime normal d'un flux par pull request.

Le détail des passages de relais, et les deux endroits exacts où les overrides
mordent :

```mermaid
sequenceDiagram
    autonumber
    participant SC as writing-a-user-story
    participant SP as superpowers
    participant G as git + gh
    participant H as Humain

    SC->>G: préconditions — checkout principal, main rafraîchie
    SC->>G: lire les champs Sections des PR ouvertes sur la même spec
    Note over SC,G: arrêt si l'intersection n'est pas vide — §3
    SC->>G: créer story/NN-us-N et son worktree
    SC->>G: commit 1 — la tranche de spec, avant tout code
    SC->>SP: writing-plans — Global Constraints portent le gel de la spec
    SP->>SP: subagent-driven-development
    Note over SP: mode d'exécution imposé — Override 3
    SP->>SP: finishing-a-development-branch
    Note over SP: choix contraint à la pull request — Override 4
    SP->>G: push et ouverture de la pull request
    SC->>G: commit — rulings et observed drift, périssables
    G->>H: revue de la pull request
    H-->>SC: demandes de correction — le gel est levé
    H->>G: fusion
```

Pour chacune :

1. **Vérifier les préconditions** du §5.1 — checkout principal, `main`
   rafraîchie.
2. **Détecter la concurrence** : lister les pull requests ouvertes touchant le
   même fichier de spec, lire leur champ `Sections:` (§4.4), et **s'arrêter** si
   l'intersection avec les sections visées n'est pas vide. C'est le mécanisme,
   pas une précaution : le conflit de fusion git ne rattraperait pas deux
   modifications éloignées d'une même section.
3. **Attribuer `us-N`** (§4) et **créer la branche** (§5.1).
4. **Commiter la tranche du delta propre à cette story** — premier commit de la
   branche (§4.4, condition 2).

   Si le lot déclare un feature flag (§4.3), la tranche transcrite **énonce le
   flag et son défaut** (§4.1). Le code de la story, écrit ensuite, sera gardé
   par ce flag.

   **Cas correctif :** le delta étant vide, ce premier commit ne touche pas la
   spec. Il barre l'entrée du gaps register que la story résorbe, ce qui joue le
   même rôle : fixer le périmètre dans l'histoire de la branche avant que le
   code commence.
5. **Appeler `superpowers:writing-plans`**, en portant dans `Global Constraints`
   les contraintes du batch et le gel du fichier de spec (§3).
6. **`superpowers:subagent-driven-development`** exécute, puis conclut comme il
   le fait toujours sur `superpowers:finishing-a-development-branch`. **Le choix
   y est contraint à « Push and create a Pull Request »** — c'est l'Override 4
   (§8.3) : le merge local détruit la branche sans jamais pouvoir atteindre le
   remote, et garder la branche laisse la story sans état observable.
7. **Avant fusion**, recopier les lignes `Ruling:` du message final de SDD dans
   le Rulings log du document de story, et consigner sous **Observed drift** les
   dérives constatées hors périmètre. Ces informations sont périssables — le
   workspace de SDD est déjà supprimé et la fusion peut avoir lieu des jours
   plus tard, dans une autre session. Elles sont poussées sur la branche, donc
   fusionnées avec elle.
8. **Répondre à la revue.** Les demandes du reviewer s'appliquent sur la branche
   de la story, y compris sur la formulation de la tranche de spec : le gel du §3
   est levé à l'ouverture de la pull request, précisément pour que ce soit
   possible. Le worktree est préservé par `finishing-a-development-branch` sur ce
   chemin, donc l'itération s'y fait.

La story est livrée quand sa pull request est fusionnée. Il n'y a rien à cocher
ni à réconcilier : son état *est* l'état de sa pull request.

**La story de levée** supprime le branchement dans le code et la phrase de gating
dans la spec — donc du code et une tranche de spec, dans une pull request :
exactement la forme d'une story, sans mécanisme nouveau. C'est elle qui met la
fonctionnalité en production.

**Une story de levée par flag, donc par module** (§2). Un lot transverse gardant
deux modules en écrit deux, chacune retirant la phrase de gating de sa spec et le
branchement de son module — et chacune respecte l'invariant « une story, un
module ».

Elle est la **dernière story du lot** quand le flag est à portée de lot. Quand la
portée est étendue (§2), elle appartient au lot qui satisfait la condition de
levée déclarée — souvent le dernier lot d'un module en construction. Ce n'est pas
au lot courant de le deviner : `writing-a-batch` fait remonter au gate
d'ouverture (§5.2) tout flag vivant sur les modules que le lot touche, et
l'humain tranche si ce lot est celui qui lève.

Elle est **une story et non un devoir de clôture** parce qu'elle porte du code,
et que du code mérite une revue et un cycle de tests. Si vous voulez une période
d'observation entre l'activation et le nettoyage, coupez-la en deux stories —
activer, puis retirer. Le modèle le supporte sans rien changer.

**Sans story de levée, le flag survit à son lot par accident.** C'est le mode de
panne classique des feature flags, et il est silencieux. `closing-a-batch`
refuse donc de clore tant qu'un flag survit **sans portée étendue déclarée**
(§5.4) — la survie voulue reste possible, la survie par oubli non.

### 5.4 Closing — `closing-a-batch`

Quand toutes les stories du batch sont fusionnées ou abandonnées et que l'humain
considère le batch terminé, une pull request de clôture :

1. **Écrit la ligne de changelog** de chaque spec touchée (§4.1) — un batch, une
   ligne.
2. **Consolide dans le gaps register** les sections `Observed drift` des stories
   du batch (§4.2).
3. **Libère les réservations non consommées** (§4.2).
4. **Constate les intentions non livrées** : si le spec delta annoncé à
   l'ouverture n'a pas été entièrement transcrit — story abandonnée, périmètre
   réduit en chemin — l'écart est inscrit au gaps register comme *gap*, et le
   texte du batch est amendé pour ne plus promettre ce qu'il n'a pas livré.
   Sans cette étape, l'abandon d'une story serait invisible : ni dérive (la spec
   et le code sont d'accord, tous deux silencieux), ni gap, juste une promesse
   oubliée dans un document clos.
5. **Vérifie qu'aucun flag du lot ne subsiste par accident.** Un flag encore
   présent — dans le code ou comme phrase de gating dans une spec — n'est
   acceptable que si sa **portée étendue et sa condition de levée** sont
   déclarées (§2, §4.1, §4.3). Sinon la story de levée n'a pas été écrite (§5.3)
   et le lot **ne peut pas être clos**. La distinction est tout l'objet du
   contrôle : un flag voulu et un flag oublié se ressemblent parfaitement dans le
   code, et seule la déclaration les sépare.

   **Trois sorties, pas une impasse.** Un lot dont on renonce au périmètre alors
   que des stories gardées sont déjà sur `main` ne doit pas rester ouvert à
   jamais. L'humain choisit : écrire la story de levée et livrer ce qui existe ;
   déclarer au flag une portée étendue par une pull request d'amendement (§4.3),
   ce qui reporte la décision à un lot ultérieur ; ou écrire une **story de
   démontage** qui retire le code gardé et la tranche de spec correspondante.
   Sans ces trois sorties, le refus de clore fabriquerait précisément le code
   mort sous flag qu'il existe pour empêcher.
6. **Passe `status: closed`.**

Cette pull request est revue comme les autres : la clôture acte une décision
humaine — que le batch a livré ce qu'il devait — et cette décision mérite sa
revue.

## 6. Module adoption

`supercharlouze:adopting-a-module` établit la vérité dont tout le reste dépend.
C'est l'opération la plus délicate du système.

**Ordre d'autorité des sources :**

1. **Les documents validés** sont normatifs. Ils font la vérité.
2. **Le code** ne corrige jamais un document. Il comble les *silences* des
   documents — les comportements qu'aucun document n'a jamais décrits.
3. **L'humain** tranche les contradictions.

Reconstruire une spec depuis le code est explicitement écarté : cela
canoniserait la dérive et détruirait la propriété même qui rend les corrective
batches possibles.

**Steps:**

1. **Delimit the module** — l'humain le nomme et en trace les contours. Le skill
   ne les déduit jamais. Préférer un gros module à plusieurs petits.
2. **Inventory the validated documents** qui le couvrent — anciens design docs
   superpowers, README, docs métier, ADR. Présenter la liste à l'humain *avant*
   d'écrire quoi que ce soit, pour qu'il puisse ajouter une source manquante ou
   en écarter une qui n'a jamais été validée. La qualité de la spec est plafonnée
   par cet inventaire. **L'inventaire retenu est enregistré dans la section
   `Sources` de la spec** (§4.1) : c'est le seul lien persistant entre une spec
   et ce qui l'a nourrie, et `init` en dépend (§9).
3. **Write the spec from those documents only.** Fusion, déduplication, mise en
   cohérence. Quand deux documents validés se contredisent, le plus récent
   l'emporte par défaut — consigné comme ruling, jamais résolu en silence.
4. **Audit the code against the spec** et produire le gaps register, avec ses
   deux sections et sa couverture déclarée (§4.2).
5. **Mandatory human review** — c'est la revue de la pull request d'adoption
   (§5.1). Tant qu'elle n'est pas fusionnée, le module n'est pas adopté et aucun
   batch ne peut démarrer dessus.

**Cas dégradé — un module sans aucun document validé.** L'adoption depuis les
documents est impossible et la reconstruction depuis le code est écartée. Le
skill bascule alors en dialogue : il énumère les comportements trouvés dans le
code et demande à l'humain, section par section, « est-ce voulu ? ». Ce que
l'humain valide devient la spec ; le reste part en gaps.

## 7. Skills

| Skill | Trigger | Produces |
|---|---|---|
| `using-batches` | point d'entrée, cité par le bloc `CLAUDE.md` | le routage, le vocabulaire, les règles d'autorité, les overrides déclarés (§8.3) |
| `adopting-a-module` | premier batch touchant un module sans spec | la PR d'adoption : spec (avec ses `Sources`) + gaps register |
| `writing-a-batch` | ouverture d'un batch, amendement (§4.3), ou requalification (§8.3) | la PR de batch : `NN`, scope, spec delta, `Feature flag`, réservations, flags vivants remontés |
| `writing-a-user-story` | une story à écrire, y compris levée ou démontage | la PR de story : tranche de spec, plan, code, rulings, observed drift |
| `closing-a-batch` | toutes les stories fusionnées ou abandonnées | la PR de clôture : changelog, consolidation, libérations, constats, contrôle des flags, `status: closed` |

Quatre skills productifs, un de routage. Le cycle d'une story tient dans un seul
skill parce que la pull request porte son état : il n'y a ni enregistrement à
rapatrier après coup, ni réconciliation à faire tourner.

## 8. Routing and precedence

### 8.1 The lever

La préséance sur superpowers s'obtient par le `CLAUDE.md` du projet, parce que
c'est le levier que superpowers concède explicitement.
`superpowers:using-superpowers` se termine par *« User instructions (CLAUDE.md,
AGENTS.md, GEMINI.md, etc, direct requests) take precedence over skills »*. Ce
pari est plus solide qu'il n'y paraît : le hook `SessionStart` de superpowers
injecte l'**intégralité** de `using-superpowers` au démarrage de chaque session,
cette phrase comprise. La concession n'attend donc pas qu'un skill soit chargé.

`writing-plans` porte en outre une concession directe : *« (User preferences for
plan location override this default) »*. Le bloc `CLAUDE.md` s'appuie dessus pour
déplacer les plans vers `docs/batches/`. `brainstorming` porte la même
concession pour l'emplacement des specs, mais elle est **sans objet ici** :
l'Override 1 remplace l'étape 6 qui écrirait ce document, donc il n'y a aucun
emplacement à relocaliser. Ce n'est vrai que parce que l'override porte sur les
étapes 6 à 9 ; s'il ne portait que sur l'état terminal, le design doc daté serait
écrit et cette concession redeviendrait le bon levier.

Un hook `SessionStart` propre au plugin a été écarté : l'ordre entre les hooks
de deux plugins n'est pas spécifié, ce qui laisserait deux blocs
`EXTREMELY_IMPORTANT` concurrents et produirait des échecs intermittents.

Le bloc inséré par `/supercharlouze:init` est délibérément minuscule et stable :

```markdown
## Specs and plans

This project overrides how superpowers organizes specs and plans.
Invoke `supercharlouze:using-batches` before any design work, and again before executing any plan.
It relocates specs and plans, replaces steps 6 to 9 of the architectural checklist of superpowers:brainstorming, extends the stop conditions of superpowers:subagent-driven-development, requires subagent-driven-development as the execution mode, and constrains superpowers:finishing-a-development-branch to the pull request option.
It declares each of these overrides explicitly; where it declares none, superpowers applies unchanged.
```

Le bloc **énumère les quatre overrides du §8.3, sans en omettre un**. Par
l'argument même de cette section — le bloc est le seul artefact garanti en
contexte, et ce qu'il affirme l'emporte sur un skill chargé à la demande — un
override absent du bloc serait exactement aussi fragile que celui qu'une
formulation trop large aurait tué. Il demande aussi l'invocation **avant
exécution d'un plan** autant qu'avant la conception, sans quoi `using-batches`
n'est pas en contexte quand ses règles d'exécution doivent s'appliquer.

### 8.2 What is kept, what is rerouted

La classification spike / bounded / architectural de superpowers est
**conservée telle quelle** — elle est orthogonale à ce modèle, et elle est
bonne. Seul l'état terminal du chemin architectural est dévié :

```mermaid
flowchart LR
    B["superpowers:brainstorming<br/>classification inchangée"]

    B -->|spike| SPIKE["Réponse, aucun artefact"]
    B -->|bounded| BOUND["PR unique — code + mise à jour de spec<br/>changelog out-of-batch<br/>même détection de concurrence"]
    B -->|architectural| ARCH

    ARCH["writing-a-batch"]
    ARCH --> STORIES["writing-a-user-story<br/>puis superpowers:writing-plans"]

    B -.->|"chemin natif remplacé"| NATIVE["design doc daté<br/>+ writing-plans"]

    classDef over fill:#1f6feb,stroke:#1f6feb,color:#ffffff
    classDef dead fill:#f6f8fa,stroke:#999999,color:#999999

    class ARCH over
    class NATIVE dead
```

Le nœud bleu est l'**Override 1** ; le nœud grisé est ce que superpowers ferait
sans ce plugin, et que sa propre règle fermée impose — d'où la nécessité de
déclarer l'override (§8.3).

- **Spike** — inchangé. Aucun artefact.
- **Bounded** — cérémonie inchangée, avec deux règles :
  - **(a) il ne laisse jamais la spec muette.** Qu'il *altère* un comportement
    déjà décrit ou qu'il en *ajoute* un que nulle spec ne décrit, sa pull
    request met la spec à jour en même temps que le code, avec une ligne de
    changelog `out-of-batch`. Traiter seulement le cas « altère » rouvrirait le
    même trou un cran à côté.
  - **(b) il subit la même détection de concurrence** que les stories (§5.3) et
    déclare donc ses sections dans le corps de sa pull request, sans quoi il
    percuterait une story en vol par une porte dérobée.

  Pas de batch, pas de user story : un bounded est déjà une pull request, il
  porte simplement sa mise à jour de spec. **Pas de feature flag non plus** : un
  bounded est complet dans sa propre pull request, donc il satisfait le critère
  d'exemption du §2 par construction.
- **Architectural** — les **étapes 6 à 9** de la checklist architecturale
  (design doc daté, self-review, revue humaine, transition vers
  `writing-plans`) sont remplacées par `supercharlouze:writing-a-batch`. C'est un
  override déclaré (§8.3). Les étapes 1 à 5 — contexte, questions, approches,
  design présenté par sections, approbation — sont **conservées intactes** :
  c'est le travail de conception lui-même, et il n'a aucune raison de changer.

### 8.3 Declared overrides of closed rules

superpowers énonce plusieurs de ses règles comme fermées. Une exception
implicite à une règle marquée « et seulement celles-ci » ne survivra pas à une
session sous pression : chacune doit donc être **nommée comme un override** dans
`using-batches` et dans le bloc `CLAUDE.md` (§8.1), avec sa justification. Il y
en a quatre, et il ne doit jamais y en avoir une cinquième non déclarée.

**Override 1 — la queue du chemin architectural, étapes 6 à 9.** La checklist
architecturale de `brainstorming` se termine par quatre étapes : **6.** écrire le
design doc daté, **7.** self-review, **8.** revue humaine de la spec écrite,
**9.** transition vers `writing-plans`. Le skill verrouille la neuvième —
*« Architectural: the ONLY skill you invoke after brainstorming is
writing-plans »*, redoublé par *« Do NOT invoke any other skill. writing-plans is
the next step »*.

**Cet override remplace les quatre, pas seulement la dernière.** Ne rerouter que
l'étape 9 laisserait les étapes 6 à 8 s'exécuter, et un design doc daté
continuerait d'être écrit dans `docs/superpowers/specs/` — exactement ce que ce
plugin existe pour supprimer. C'est un seul override, correctement délimité, et
non deux : la substitution porte sur un bloc terminal cohérent.

Justification : `writing-a-batch` n'est pas un skill d'implémentation — la
catégorie que la règle de l'étape 9 protège — mais un substitut à l'étape
documentaire qui précède `writing-plans`, lequel reste appelé, depuis
`writing-a-user-story`. Et la substitution préserve chacune des étapes
remplacées : l'étape 6 devient le document de batch, la 7 sa relecture avant
ouverture, et **la 8 devient la revue de la pull request de batch** (§5.2) — la
revue humaine n'est pas supprimée, elle change d'outil.

**Override 2 — la cinquième condition d'arrêt de SDD.**
`subagent-driven-development` énonce *« Four things stop you, and only these »*.
Ce plugin en ajoute une, pour les corrective batches seulement :

> Si, en mettant du code en conformité avec une spec, tu découvres que c'est la
> **spec** qui a tort et le code qui a raison, arrête-toi. Le batch n'est plus
> correctif et doit être requalifié.

Justification : les quatre conditions de SDD supposent qu'une autorité valide
existe. Ici c'est l'autorité elle-même qui est en cause, et le §3 interdit à un
agent de corriger une spec.

**Procédure de requalification**, portée par `writing-a-batch` : la pull request
de la story est fermée sans fusion. Puis l'humain tranche : soit il corrige la
spec — lui seul le peut (§3) — et le batch reste correctif sur un périmètre
réduit ; soit le batch est réécrit comme batch ordinaire, avec un spec delta, par
une nouvelle pull request de batch qui repasse par la revue du §5.2. Dans les
deux cas les réservations au gaps register sont révisées, et `closing-a-batch`
libérera celles qui restent (§5.4).

**Override 3 — le mode d'exécution imposé.** `writing-plans` se termine en
proposant à l'humain un choix entre `subagent-driven-development` et
`executing-plans`. Ce plugin impose SDD. Justification : le rapatriement des
rulings (§3) dépend du ledger de SDD ; `executing-plans` n'en tient pas, et la
trace des arbitrages serait perdue.

**Override 4 — la sortie imposée de `finishing-a-development-branch`.** Ce skill
présente trois options — merge local, pull request, garder la branche — et
attend un choix humain. Sur le chemin story, ce plugin contraint le choix à
**« Push and create a Pull Request »**.

Justification, énoncée exactement — les deux autres options ne sont pas
équivalentes.

**« Merge back locally » est activement destructrice.** Elle fusionne sur la
`main` **locale**, lance les tests, puis **supprime le worktree et la branche**.
Elle ne pousse jamais, donc rien n'échoue sur le moment : le travail se retrouve
dans un commit local qui ne pourra jamais atteindre le remote, et la branche qui
aurait porté une pull request n'existe plus. Le rapatriement des rulings (§5.3,
étape 7) n'a jamais lieu, puisqu'il se fait sur la branche avant fusion.

**« Keep the branch as-is » n'est pas destructrice et reste compatible avec une
`main` protégée** — elle est simplement hors flux : sans pull request, la story
n'a pas d'état observable et ne sera jamais livrée. Elle est écartée pour cette
raison, pas parce qu'elle casserait quelque chose.

Cet override retire donc un choix qui ne peut pas aboutir, et un choix qui
n'aboutit nulle part.

**Ce qui n'est délibérément pas un override :** l'état terminal de SDD. Ce
plugin n'intercale rien entre SDD et `finishing-a-development-branch` — il
contraint ce que ce dernier propose, ce qui est l'Override 4, et rien d'autre.
La réutilisation du worktree existant par `using-git-worktrees` (§5.1) n'en est
pas un non plus : c'est le comportement documenté de son Step 0.

## 9. The `init` command

`/supercharlouze:init` est idempotente et n'adopte jamais rien. Comme tout le
reste, elle produit une pull request (branche `chore/supercharlouze-init`).

1. Créer `docs/specs/`, `docs/batches/`, `docs/archive/`.
2. Déplacer `docs/superpowers/specs/` vers `docs/archive/specs/` et
   `docs/superpowers/plans/` vers `docs/archive/plans/`, en conservant les noms
   de fichiers. La structure est fixée ici parce que le point 4 en dépend :
   `Sources` enregistre les chemins d'archive, et la correspondance doit être
   exacte.
3. Insérer le bloc `CLAUDE.md`, ou le mettre à jour sur place s'il est déjà
   présent. Ne jamais le dupliquer. Fonctionne aussi bien sur un projet qui a
   déjà un `CLAUDE.md` que sur un projet qui n'en a pas.
4. Rendre l'état des lieux : quels modules sont adoptés (une spec existe dans
   `docs/specs/`), et quels documents archivés ne figurent dans la section
   `Sources` d'aucune spec (§4.1, §6.2) — c'est ce qui rend ce calcul décidable
   plutôt qu'affaire d'heuristique. La commande ne **propose pas** de découpage
   en modules — §6 le réserve à l'humain, et une suggestion serait lue comme une
   décision.

## 10. Language

La frontière ne passe pas entre les documents, elle passe **à l'intérieur** de
chaque document : ossature en anglais, prose dans la langue du projet.

- **L'ossature est anglaise, partout.** Titres de sections, noms de champs,
  libellés de templates, valeurs de front matter (`status: open | closed`),
  en-têtes de tableaux, patrons de chemins et de branches, noms de skills et de
  commandes. Cela vaut pour le plugin comme pour les documents qu'il produit.
- **La prose est dans la langue du projet** — français par défaut ici. Le corps
  des exigences, les descriptions, les justifications, les slugs de fichiers et
  de répertoires, qui nomment des objets métier.
- **Le plugin lui-même est intégralement anglais** — skills, commandes, README,
  bloc `CLAUDE.md`, messages. Il n'a pas de prose métier ; il n'a que de
  l'ossature.

C'est le « feeling superpowers » conservé : un document de ce système se lit
comme un document superpowers, avec du contenu français. Et l'ossature anglaise
imposée par `superpowers:writing-plans` aux user stories (`Global Constraints`,
`Files`, `Interfaces`) n'est alors plus une exception subie — c'est la règle
générale, déjà appliquée par superpowers.

Le présent document suit cette règle.

## 11. Verification

**Contrôles structurels uniquement**, automatisés et bon marché :

- `plugin.json` est valide.
- Chaque `SKILL.md` a un front matter avec `name` et `description`.
- Les chemins cités d'un skill à l'autre existent.
- Le bloc `CLAUDE.md` s'insère proprement dans un fichier existant, dans un
  projet sans `CLAUDE.md`, et ne se duplique pas à la deuxième exécution.
- Chacun des quatre overrides du §8.3 est présent et nommé **à la fois** dans
  `using-batches` et dans le bloc `CLAUDE.md`.

**Ce qui n'est pas testé, et qui est donc un pari assumé :**

- La solidité du levier `CLAUDE.md` pour le routage — le point de rupture le
  plus probable de la conception.
- Le respect du gel du fichier de spec par les implémenteurs de SDD (§3). La
  règle voyage dans `Global Constraints`, donc sous leurs yeux, mais rien ne
  garantit qu'elle soit suivie.
- Le respect de l'Override 4 au moment où `finishing-a-development-branch`
  présente son menu.

La phase 2 du plan d'amorçage est ce qui éprouve ces paris en pratique.

## 12. Bootstrap plan

**Phase 1 — construire la v1 avec superpowers nu.** Le plugin ne peut pas se
construire lui-même : `writing-a-batch` n'existe pas encore. La v1 suit donc le
chemin superpowers standard — ce document de conception, puis
`superpowers:writing-plans`, puis `subagent-driven-development`.

**Phase 2 — dogfooding sur ce dépôt.** Une fois la v1 livrée, lancer
`/supercharlouze:init` sur `superpowers-by-charlouze` lui-même. Il sera alors un
vrai projet superpowers, avec des documents de conception datés à migrer, et
dont on connaît chaque ligne — le bon premier sujet pour l'init, la migration et
l'adoption, avant de les lâcher sur des projets réels. Le dépôt utilise déjà un
flux par pull request sur une branche protégée, donc il éprouve le modèle du
§5.1 sur son chemin nominal dès le premier batch.

**Nombre de modules pour ce dépôt : un — `superpowers-override`.**

## 13. Rejected alternatives

| Alternative | Motif du rejet |
|---|---|
| Forker superpowers | Le projet refuse explicitement les PR spécifiques à un fork ; la divergence serait maintenue seul, sans gain par rapport à un plugin compagnon. |
| `CLAUDE.md` par projet, sans plugin | Suffisant pour les chemins et le vocabulaire, insuffisant face à la checklist en dur de `brainstorming`. |
| Hook `SessionStart` pour la préséance | Ordre non spécifié entre hooks de plugins ; échecs intermittents. |
| Le batch l'emporte sur la spec pendant le batch | La spec est ce que lisent les reviewers ; la laisser fausse ruine sa raison d'être. |
| Un agent corrige la spec pour résoudre un conflit | Inverse silencieusement l'autorité : c'est alors l'intention du batch qui gagne (§3). |
| Gel du fichier de spec sans borne de fin | Rendrait impossible de répondre à une revue ou de résoudre un conflit de fusion sur ce fichier (§3). |
| Delta complet transcrit à l'ouverture du batch | Les reviewers signaleraient comme manquant le comportement des stories suivantes (§4.4). |
| Commits documentaires directs sur `main` | `main` est protégée : tout passe par une pull request. Toute la machinerie de marqueurs et de réconciliation qui suit n'existait que pour compenser l'écart temporel que ce modèle créait. |
| Marqueurs `🚧` dans la spec | Sans objet : la spec et le code avancent dans la même pull request, donc `main` ne connaît jamais d'état « spécifié mais pas encore livré » (§4.1). |
| Réconciliation par interrogation des PR fusionnées | Servait à fermer une story dont l'état vivait ailleurs que dans sa PR. L'état d'une story *est* l'état de sa PR (§4.3). |
| Skill de rapatriement post-exécution | Les rulings sont poussés sur la branche de la story avant fusion (§5.3). |
| Conflit de fusion git comme mécanisme de détection de concurrence | Git conflicte sur des lignes, pas sur des sections : deux modifications éloignées d'une même section fusionnent proprement. Filet partiel seulement (§3). |
| Changelog écrit par chaque story | Ferait conflicter au même point toutes les stories d'un module en vol simultanément — le régime nominal. Une ligne par batch, écrite à la clôture (§4.1). |
| Gaps register écrit par chaque story | Même contention. Les stories consignent sous `Observed drift`, `closing-a-batch` consolide (§4.2). |
| Liste des stories maintenue dans le document de batch | Conflit de fusion à chaque story, pour une information que le répertoire et `gh pr list` donnent déjà (§4.3). |
| Cases à cocher pour l'état des stories | Recopie une vérité que `gh pr list` donne mieux, et se désynchronise dès la première PR fusionnée hors session (§4.3). |
| Sections d'une story déduites de son diff | Fragile ; l'auteur de la story les connaît, donc elles sont déclarées (§4.4). |
| Une branche par batch, fusionnée dans `main` à la clôture | Protégerait la production en retenant le travail, mais une story fusionnée dans la branche de lot n'est ni une PR ouverte ni sur `main` : elle devient invisible à la détection de concurrence pendant toute la durée du lot. Et la branche vieillit, avec le fichier de spec pour surface de conflit (§5.1). |
| Une branche `develop` façon gitflow | Même angle mort, mais permanent. Et surtout **deux baselines** pour la règle de dérive — spec de référence sur `develop`, code en production sur `main` — donc un lot correctif ne sait plus contre quoi il corrige (§5.1). |
| Feature flag non spécifié, traité comme un détail d'implémentation | Une story fusionnée derrière un flag rendrait la spec fausse au sens des utilisateurs, et rouvrirait l'écart que le §4.1 ferme. Le flag et son défaut sont énoncés dans la spec (§2). |
| Levée du flag comme devoir de `closing-a-batch` | Elle porte du code, donc elle mérite une revue et un cycle de tests : c'est une story (§5.3). La clôture se contente de vérifier qu'elle a eu lieu. |
| Champ `Feature flag` facultatif dans le document de batch | « Aucun flag » doit être une décision énoncée et revue au gate d'ouverture, pas un oubli (§4.3). |
| Flag obligatoirement borné au lot | Interdirait le cas légitime du module construit sur plusieurs lots et ouvert seulement une fois complet. La portée peut dépasser le lot, à condition d'être déclarée avec sa condition de levée (§2). |
| Registre séparé des flags vivants | Le flag vit déjà dans la spec du module, lue à chaque adoption, audit et ouverture de lot. Un second registre serait un doublon à resynchroniser (§2). |
| Un flag par lot, y compris pour un lot transverse | Sa story de levée devrait retirer la phrase de gating dans deux specs, alors qu'une story vise un module. Un flag par couple (lot, module) (§2). |
| Condition de levée logée seulement dans le document de lot | Ce document se clôt, et aucun pointeur n'y mène depuis la spec ; la condition doit être lisible là où le flag se lit (§4.1). |
| Remontée des flags vivants au niveau de la section | Un lot ajoutant des sections neuves sans toucher les gardées ne ferait rien remonter, et le flag survivrait indéfiniment (§5.2). |
| Document de batch strictement immuable jusqu'à la clôture | Laisse sans issue le lot exempté qui découvre qu'il fallait un flag, et le lot dont on réduit le périmètre. Amendable par une PR revue (§4.3). |
| Refus de clôture sans porte de sortie | Un lot renoncé avec des stories gardées déjà fusionnées resterait ouvert à jamais, avec le code mort sous flag que le contrôle existe pour empêcher (§5.4). |
| Override 1 limité à l'état terminal de `brainstorming` | Les étapes 6 à 8 continueraient de s'exécuter et un design doc daté serait écrit — ce que ce plugin existe pour supprimer (§8.3). |
| Numéros attribués sur le seul contenu de `main` | Un artefact n'atteint `main` qu'à la fusion : deux batches ou deux stories en vol prendraient le même numéro (§4). |
| Dépendre du nom de branche produit par `using-git-worktrees` | Ce skill préfère les outils natifs du harness, qui nomment eux-mêmes, et peut aboutir à un HEAD détaché (§4). |
| Laisser `finishing-a-development-branch` proposer ses trois options | Le merge local détruit worktree et branche avant d'échouer au push contre la protection, et emporte les rulings non rapatriés (Override 4). |
| Entrées du gaps register sans réservation à l'ouverture | Deux corrective batches concurrents piocheraient dans le même stock (§4.2). |
| Réservations jamais libérées | Une story abandonnée laisserait sur `main` une réservation perpétuelle bloquant tout autre batch (§4.2). |
| Clôture sans constat des intentions non livrées | Une story abandonnée serait invisible : ni dérive, ni gap, juste une promesse oubliée (§5.4). |
| Gaps register alimenté seulement à l'adoption | La règle de dérive du §4.1 s'appuierait sur un audit qui n'a plus jamais lieu (§4.2). |
| Pas de gate à l'ouverture d'un batch | Laisserait entrer du normatif dans l'autorité contraignante sans validation (§5.2). |
| Citer la concession « spec location » de `brainstorming` | Sans objet sous l'Override 1 (§8.1). |
| Statut permanent par section dans la spec | Un document qui se lit comme un registre et non comme une spécification. |
| Spec reconstruite depuis le code à l'adoption | Canonise la dérive ; détruit la prémisse des corrective batches. |
| Comportement non documenté absorbé dans la spec à l'adoption | La spec ne doit contenir que du validé ; le reste appartient au gaps register. |
| « Exigence » comme unité de concurrence | Granularité indéfinissable ; la section, unité titrée, est vérifiable (§2). |
| Support multi-harness | Seul Claude Code est utilisé ; chaque harness supplémentaire est du portage sans retour. |
| Documents intégralement anglais | La spec est lue et amendée par l'humain ; l'anglais n'y sert que la machine. |
| Documents intégralement français, ossature comprise | Perd le « feeling superpowers », et casse les champs que `subagent-driven-development` lit (§4.4). |
