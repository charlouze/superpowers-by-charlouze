# supercharlouze

## Boundary

Ce module couvre une extension de superpowers qui définit un flux de
développement : une spec vivante par module, des lots de stories qui font grandir
ces specs, des revues humaines tenues en pull request, les documents que ce flux
produit, les conventions qu'il laisse dans le dépôt, ce qu'il exige du code
applicatif qu'un flag garde ou qui doit tenir un ADR, et son installation sur un
projet.

Il ne couvre ni superpowers lui-même, ni l'outil qui exécute les agents.

Le plugin entier constitue un seul module.

## The model

Chaque concept porte un seul terme, lié ici au nom anglais qu'il porte dans les
chemins, les branches et l'ossature des documents.

Aucun synonyme n'est employé.

**Module** (`module`) — un domaine fonctionnel grossier, vu de l'extérieur.

**Spec** (`spec`) — le document vivant d'un module, qui dit ce que son code doit
faire.

**Section** (`section`) — la plus petite unité titrée d'une spec, et l'unité sur
laquelle se jugent les conflits de concurrence et que désigne une entrée du gaps
register.

**Gaps register** (`gaps register`) — le document vivant qui consigne, pour un
module, ce que sa spec ne tient pas : les violations de son code et les gaps
qu'elle ne décrit pas.

**Dérive** (`drift`) — un code de `main` qui contredit la spec de `main`, ou un
comportement de `main` qu'aucune spec ne décrit.

**Lot** (`batch`) — l'unité de livraison : un ensemble de stories qui vise un ou
plusieurs modules.

**Lot correctif** (`corrective batch`) — un lot qui remet du code en conformité
avec une spec déjà vraie. Son spec delta ne porte aucun bloc.

**Bloc** (`delta block`) — l'unité du spec delta d'un lot : une section visée et
le texte exact qu'elle doit recevoir.

**Story** (`user story`) — le plan d'implémentation d'une part d'un lot, qui vise
un seul module et se livre en une pull request.

**Story technique** (`technical story`) — une story qui ne change rien
d'observable à la frontière de son module.

**Conception technique** (`technical design`) — le mécanisme prévu pour les
stories d'un lot, dont chacune peut s'écarter.

**ADR** (`adr`) — le document qui consigne une décision technique du projet.

**Flag** (`feature flag`) — ce qui garde un comportement incomplet hors de portée
des utilisateurs jusqu'à sa levée.

**Mention de flag** (`gating sentence`) — la ligne par laquelle une spec déclare
qu'un comportement est gardé par un flag.

**Pull request** (`pull request`) — un changement proposé pour `main`, que
l'humain revoit avant qu'il l'atteigne.

**Revue** (`gate`) — l'examen par l'humain d'une pull request, dont la fusion fait
avancer un module, un lot ou une story.

**Relecture** (`reread`) — la vérification d'un travail par un agent. Une
relecture n'est pas une revue.

**Arbitrage** (`ruling`) — une décision prise par un agent sans l'humain,
consignée pour lui.

**Arbitrage ouvert** (`open ruling`) — un arbitrage dont la décision laisse
quelque chose à trancher.

**Arbitrage de conception technique** (`technical design ruling`) — un arbitrage
par lequel une story s'écarte de la conception technique de son lot.

**Changement borné** (`bounded`) — un changement complet en une pull request, hors
de tout lot.

**Exploration** (`spike`) — un travail qui produit une réponse et aucun artefact.

**Conception architecturale** (`architectural`) — un travail qui demande une
conception avant d'être découpé en stories.

## Built on superpowers

Termes empruntés à superpowers, qui en est propriétaire, réduits à ce dont le flux
se sert :

- **Brainstorming** (`superpowers:brainstorming`) — le dialogue qui précède tout
  travail. Il classe ce travail en exploration, changement borné ou conception
  architecturale, et, pour une conception architecturale, conduit le contexte, les
  questions, les approches, une conception présentée par sections, puis son
  approbation.
- **Plan** (`superpowers:writing-plans`) — un plan d'implémentation : un en-tête,
  une section `Global Constraints` qui s'impose à chacune de ses tâches, puis des
  tâches.
- **Exécution par sous-agents** (`superpowers:subagent-driven-development`) —
  l'exécution d'un plan tâche par tâche, chaque tâche confiée à un agent neuf puis
  relue. Les arbitrages pris en cours de route, chacun avec sa décision, sa raison
  et ce qu'il coûte s'il est faux, sont présentés à l'humain en fin d'exécution.
- **Conclusion d'une branche** (`superpowers:finishing-a-development-branch`) — le
  choix de ce que devient une branche terminée : fusion locale, pull request, ou
  branche gardée.

## Departures from superpowers

Le flux s'écarte de superpowers en ces points, et en aucun autre.

L'emplacement des documents et ce que le flux ajoute à un plan ne sont pas des
écarts.

- Aucun document de conception daté. Une conception architecturale se conclut par
  l'ouverture d'un lot : le document de lot remplace le document de conception,
  sa relecture avant ouverture en remplace l'auto-relecture, et la revue
  d'ouverture en remplace la revue humaine.

  Le plan n'est écrit qu'avec chaque story.

  Une conception qui touche un module non adopté s'arrête, et l'humain
  l'abandonne ou la met de côté.

  Le module est adopté hors du contexte de la conception. Celle-ci ne reprend
  qu'une fois l'adoption fusionnée, dans un nouveau contexte.
- Le flux ajoute des conditions d'arrêt à l'exécution par sous-agents. Dans un lot
  correctif seulement :

  > Si, en mettant du code en conformité avec une spec, tu découvres que c'est la
  > spec qui a tort et le code qui a raison, arrête-toi. Le lot n'est plus
  > correctif et doit être requalifié.

  Dans une story technique seulement :

  > Si, en conduisant une story technique, tu découvres qu'elle change quelque
  > chose d'observable à la frontière du module, arrête-toi. La story n'est plus
  > technique.

  Dans une story seulement si son lot déclare des contraintes ou si `main` porte
  un ADR quand sa branche en part :

  > Si, en conduisant une story, tu découvres qu'une contrainte de son lot ou un
  > ADR ne peut pas être tenu, arrête-toi et soumets-le à l'humain.

  Une contrainte que la spec contredit ne relève pas de cette condition, mais de
  `Authority and conflict rules`.

  Un arbitrage ne remplace aucune de ces conditions.
- Une story s'exécute par sous-agents, et le choix d'un autre mode n'est pas
  proposé.
- Une story se conclut par une pull request. La conclusion de sa branche n'offre
  ni la fusion locale, ni la branche gardée.

## Authority and conflict rules

Tout ce qui atteint `main` peut partir en production.

Rien n'atteint `main` sans pull request.

Toute branche du flux part de `main` tel que le remote le porte, et se fusionne
dans `main`.

Une branche porte le nom que son étape lui assigne avant que le travail commence.
Exception : la branche d'un amendement n'a pas de nom assigné.

La spec est l'autorité contraignante de toute revue et de toute relecture.

Hors son spec delta, un lot ne porte que ce qu'une spec ne peut pas porter : son
périmètre, ses flags, ses contraintes et sa conception technique.

La spec de `main` décrit toujours exactement ce que son code fait.

Toute dérive est du travail correctif.

Quand un lot et une spec se contredisent, la spec gagne : l'agent implémente ce
qu'elle dit, consigne un arbitrage, et poursuit.

Seul un humain corrige une spec en cours de lot.

Après le premier commit de sa branche et jusqu'à l'ouverture de sa pull request,
une story ne modifie plus le fichier de spec ; une story qui découvre que la spec
doit changer s'arrête.

À l'ouverture de la pull request, la revue peut faire modifier la spec.

| Revue | Pull request examinée | Sa fusion |
|---|---|---|
| Adoption | la spec et le gaps register du module, et les ADR écrits avec eux | le module est adopté |
| Ouverture | le document de lot, et les ADR écrits, réécrits ou supprimés avec lui | le lot est ouvert |
| Livraison | le code d'une story, sa modification de spec s'il y en a une, et les ADR que la revue fait écrire | la story est livrée |
| Amendement | la décision de changer le périmètre, le spec delta, la conception technique, les contraintes ou le flag d'un lot, et les ADR écrits, réécrits ou supprimés avec elle | le lot est amendé |
| Clôture | la consolidation et `status: closed` | le lot est clos |

L'agent n'approuve ni ne fusionne jamais une pull request de revue.

Pendant une revue, l'humain voit sur la pull request ce que chaque correction
demandée a changé depuis sa dernière lecture.

L'humain donne son accord dans la conversation ; l'agent annonce alors la pull
request prête.

Sur `main`, une correction de revue est fondue dans le commit qu'elle corrige, sauf
si elle porte une décision nouvelle.

La fusion d'une revue est le moment de vider le contexte.

Quand l'humain annonce une fusion et qu'une étape suivante existe, l'agent la nomme
et donne le prompt qui la lance dans un contexte vide.

Quand une story arrêtée par une condition d'arrêt (`Departures from superpowers`)
est abandonnée et que la décision de l'humain demande une étape suivante, l'agent
la nomme et donne le prompt qui la lance dans un contexte vide, et ce prompt
énonce cette décision.

Chacun de ces prompts nomme la skill à invoquer et le document d'où repartir, et
ne renvoie jamais à la conversation.

## Module

Un module a une spec et un gaps register, qui naissent ensemble à son adoption.

Aucun lot ne touche un module qui n'est pas adopté.

L'humain délimite les modules. Un agent n'en propose aucun découpage de lui-même.

### Module adoption

L'adoption produit une pull request portant la spec et le gaps register du module,
les ADR qu'elle écrit, et aucun code.

Ordre d'autorité des sources :

1. Les documents validés sont normatifs sur les intentions qu'ils énoncent, jamais
   sur les mécanismes qu'ils décrivent. Hors ce que l'humain promeut, eux seuls
   créent du texte normatif.
2. Le code ne corrige jamais un document. Ce qu'il révèle là où les documents se
   taisent est un gap.
3. L'humain tranche les contradictions.

Une intention ne se déduit pas d'un mécanisme, qu'il soit lu dans le code ou dans
un document validé : elle vient d'un document validé ou de l'humain.

Étapes :

1. Délimiter le module avec l'humain. Rien n'est écrit avant sa décision.
2. Inventorier les documents validés qui couvrent le module, et soumettre la liste
   à l'humain avant d'écrire. Le corps de la pull request porte l'inventaire
   retenu.
3. Créer la branche `adopt/<module>`.
4. Écrire la spec depuis ces seuls documents. Ce qui n'y est pas une règle devient
   un gap nommant son document.

   Exception : une décision technique qui réunit les conditions d'un ADR
   (`Architecture decision records`) est soumise à l'humain. S'il la veut en ADR,
   l'adoption l'écrit ; sinon, elle devient un gap.

   Quand deux documents validés se contredisent, le plus récent l'emporte par
   défaut, et cet arbitrage figure dans le corps de la pull request.
5. Auditer le code contre la spec, et consigner au gaps register ce que l'audit
   révèle. Le code n'est pas corrigé.
6. Soumettre à l'humain, un par un, les gaps qui décrivent un comportement
   observable à la frontière du module. Celui qu'il valide comme intention entre
   dans la spec et sort du gaps register.

   Un mécanisme ne lui est pas soumis.
7. Faire relire la spec en entier, hors du contexte qui l'a écrite : tient-elle ce
   qu'une spec doit tenir (`The spec document`), et est-elle précise et concise
   (`Concision`) ?
8. Ouvrir la pull request d'adoption. Sa revue est la seule de l'adoption.

Sans aucun document validé, l'adoption énumère les comportements observables à la
frontière du module, groupés en sections candidates, et demande à l'humain,
section par section, s'ils sont voulus. Ce qu'il valide devient la spec ; le reste
part en gaps.

Le corps de la pull request dit alors qu'aucun document validé n'existait.

Quand les documents validés ne couvrent qu'une partie du module, l'adoption suit
les étapes 2 à 6 pour cette partie, et ce dialogue pour le reste.

### The spec document

La spec vit dans `docs/specs/<module>.md`.

Elle ne porte ni date, ni statut, ni marqueur de travail en cours. Exception : la
mention d'un flag.

Une spec porte des règles métier, jamais le mécanisme qui les réalise. Une règle
énonce une intention que toute implémentation qui la réalise rend vraie : ce
qu'elle dit s'observe hors du module, que ses mots soient techniques ou métier.

Une décision métier chiffrée s'écrit avec sa valeur.

Une règle vit dans la section du comportement qu'elle contraint. Une règle qui en
contraint plusieurs vit dans une section qui nomme ce qu'elle règle.

Une règle appartient à une seule spec. Une règle qui contraindrait un comportement
observable à la frontière de plus d'un module signale un découpage à revoir :
l'agent s'arrête et soumet le cas à l'humain.

Le glossaire d'une spec définit les concepts du domaine, et eux seuls, avec le nom
que chacun porte dans le code et dans l'interface, quand il en a un. Le code et
l'interface emploient ce nom.

Une spec redéfinit chaque terme qu'elle emprunte à la spec d'un autre module,
réduit à ce qu'elle en utilise, et nomme cette spec. Un terme emprunté n'est pas
une règle partagée.

Tout ce qu'une spec contient est normatif et au même niveau. Exception : l'aparté,
qu'un projet admet en déclarant la convention qui le distingue d'une règle.

Un aparté ne porte aucune règle.

### The gaps register

`docs/specs/<module>.gaps.md` range ses entrées dans ces catégories :

- **Violations** — le code contredit la spec ;
- **Gaps** — ce qu'aucune spec ne décrit.

Chaque entrée désigne une section de la spec.

Une entrée qui vient d'un document nomme ce document.

Tout ce qui qualifie une entrée est écrit dans l'entrée, jamais dans un texte
commun à plusieurs entrées.

Une entrée ne renvoie à aucune autre entrée.

Dans un lot, seule la pull request de clôture ajoute des entrées au gaps register.

Le gaps register ne porte que ce qui reste à régler.

Une entrée réglée est supprimée, et le commit qui la supprime dit pourquoi.

Un constat déjà supprimé ne se réinscrit que si l'entrée dit ce qui a changé
depuis.

Un lot réserve les entrées qu'il prend en charge. Deux lots ne réservent jamais la
même entrée.

Le gaps register dit quelles parties du module ont été auditées contre la spec, et
pourquoi les autres ne l'ont pas été.

## Batch

Un lot vit dans `docs/batches/NN-<slug>/`.

Un lot est identifié par `NN`, le plus petit entier ni utilisé dans
`docs/batches/` sur `main`, ni revendiqué par une pull request ouverte ou par une
branche poussée.

La branche `batch/NN-<slug>` revendique `NN`.

Le document de lot ne change que par un amendement, ou à sa clôture.

Il ne porte ni la liste de ses stories, ni leur état.

### The batch document

Le document de lot est un `README.md` qui porte un statut, `open` ou `closed`, et
ces champs :

- **Scope** — ce que ce lot livre, dont les entrées du gaps register qu'il prend en
  charge ;
- **Spec delta** — le texte exact que ce lot écrit dans les specs, en blocs ; ou
  `none` suivi de sa raison ;
- **Technical design** — la conception technique du lot ; ou `none` suivi de sa
  raison ;
- **Constraints** — seulement les contraintes de migration et de compatibilité,
  les décisions techniques sur lesquelles repose le reste de la conception
  technique, et l'ordre requis des stories et des blocs ; ou `none` ;
- **Feature flag** — les flags que ce lot déclare, chacun avec son nom, son défaut,
  sa portée et, si elle dépasse le lot, sa condition de levée ; ou `none` suivi de
  la raison de l'exemption.

Les contraintes d'un lot ne lient que ses stories.

Chaque bloc porte un identifiant unique dans le lot, et nomme la spec et la section
qu'il vise.

Un bloc montre ce qu'il change dans le paragraphe qui le contient.

Aucun bloc n'est rattaché à une story.

Un lot qui lève un flag déclaré par un autre lot le fait par un bloc qui retire sa
mention.

### The coherence reread

La relecture de cohérence relit en entier chaque spec que touche le spec delta,
blocs appliqués.

Un lot sans bloc s'en passe.

Elle pose ces questions à chaque spec touchée :

- Qu'est-ce que les blocs rendent faux ailleurs ? Un passage qu'aucun d'eux ne vise
  et qu'ils contredisent.
- Qu'est-ce qu'ils omettent ? Un cas devant lequel ils passent, une conséquence
  qu'ils ne tirent pas.
- Tiennent-ils ce qu'une spec doit tenir (`The spec document`) ?
- Sont-ils précis et concis (`Concision`) ?

Elle n'est jamais conduite dans le contexte qui a écrit les blocs.

Le corps de la pull request d'ouverture dit ce qu'elle a trouvé, ou qu'elle n'a
rien trouvé.

### The technical reread

La relecture technique relit :

- la conception technique et les contraintes du lot, contre les specs, blocs
  appliqués, et contre le code de `main` ;
- les blocs, la conception technique et les contraintes du lot, contre les ADR
  tels que la pull request d'ouverture ou d'amendement les laisse ;
- chaque ADR que cette pull request écrit ou réécrit, contre les specs, blocs
  appliqués, et contre les autres ADR.

Une ouverture s'en passe quand le lot n'a ni conception technique ni contraintes,
et que sa pull request ne laisse aucun ADR dans `docs/adr/`.

Elle n'est jamais conduite dans le contexte qui a écrit ce qu'elle relit.

Le corps de la pull request d'ouverture ou d'amendement dit ce qu'elle a trouvé,
ou qu'elle n'a rien trouvé.

### Opening a batch

L'ouverture :

1. vérifie que chaque module touché est adopté, et s'arrête sinon ;
2. attribue `NN` ;
3. rédige le document de lot, puis écrit, réécrit ou supprime des ADR s'il y a
   lieu ;
4. réserve les entrées du gaps register que le lot prend en charge ;
5. fait passer le spec delta par la relecture de cohérence ;
6. fait passer le lot par la relecture technique ;
7. relit le document de lot en entier ;
8. ouvre la pull request du lot, sur la branche `batch/NN-<slug>`.

Rien n'est écrit dans les specs à l'ouverture.

### Amending a batch

Un amendement change le périmètre, le spec delta, la conception technique, les
contraintes ou le flag d'un lot ouvert, par une pull request sur son document.

La pull request d'un amendement peut aussi écrire, réécrire ou supprimer des ADR.

Exception à la revue d'amendement : un amendement qui change le spec delta est revu
comme une ouverture.

Quand la condition d'arrêt d'un lot correctif se déclenche, l'humain tranche :

- soit il décide de corriger la spec : un changement borné porte cette
  correction (`Bounded change`), et un amendement réduit le périmètre du lot,
  qui reste correctif ;
- soit un amendement réécrit le lot comme lot ordinaire, en gardant `NN` et son
  répertoire ;
- soit il juge le travail restant être un autre lot, qui reçoit un `NN` neuf, et le
  lot requalifié est clos.

La story en cours est abandonnée une fois la requalification tranchée.

Les entrées du gaps register que le lot ne prend plus en charge sont libérées.

Quand la condition d'arrêt d'une story technique se déclenche, la story est
abandonnée une fois que l'humain a tranché si le changement observable qu'elle a
révélé est voulu.

Si l'humain veut le changement observable qu'elle a révélé, un amendement ajoute
son bloc, et le flag qu'il exige s'il en exige un (`Feature flags`).

Quand une story s'arrête sur une contrainte qu'elle ne peut pas tenir, l'humain
juge la contrainte. S'il la juge intenable, la story est abandonnée et un
amendement modifie ou retire la contrainte ; sinon, la story reprend en la tenant.

Un amendement qui change le spec delta, la conception technique ou les contraintes
d'un lot, ou qui écrit ou réécrit un ADR, passe par la relecture technique.

### Closing a batch

Quand toutes les stories du lot sont fusionnées ou abandonnées et que l'humain
considère le lot terminé, sa clôture passe par une pull request, sur la branche
`batch/NN-<slug>-close`.

Un lot ne se clôt pas tant qu'un flag qu'il a déclaré subsiste, dans le code ou par
sa mention dans une spec, sans que sa portée étendue et sa condition de levée
soient déclarées.

Un flag déclaré par un autre lot n'entre pas dans ce contrôle.

Quand l'humain renonce au périmètre d'un lot dont des stories gardées sont sur
`main`, il choisit : écrire la story de levée et livrer ce qui existe ; déclarer au
flag une portée étendue par un amendement ; ou écrire une story de démontage, qui
retire le code gardé et ce qu'il avait ajouté à la spec.

La pull request de clôture porte :

- la consolidation dans le gaps register de ce que les documents des stories ont
  laissé : leurs dérives observées, et les arbitrages ouverts qu'ils classent en
  violation ou en gap ;
- la libération des réservations non consommées ;
- le retrait du document de lot des blocs qu'aucune story fusionnée n'a livrés.
  L'humain décide si chacun rejoint le gaps register ;
- le statut `closed` du document de lot.

## Story

Une story appartient à exactement un lot et vise exactement un module.

Une story se livre sur une branche, par une pull request.

Cette pull request ne porte jamais sa modification de spec sans le code qui la
réalise.

Une story est identifiée par `us-N` dans son lot, attribué selon la règle qui
identifie un lot (`Batch`).

Sa branche `story/NN-us-N-<slug>` revendique `NN` et `us-N`.

Une story s'écrit en connaissant les stories de son lot déjà écrites.

Plusieurs stories d'un lot peuvent être en cours de livraison à la fois.

Chaque story choisit, en s'écrivant, les blocs qu'elle transcrit, et les transcrit
en entier.

### The user story document

Le document de story est un plan, enregistré dans
`docs/batches/NN-<slug>/NN-us-N-<slug>.md`.

Son en-tête déclare :

- `Spec:` — la spec du module visé ;
- `Batch:` — le document de son lot ;
- `Sections:` — les sections de la spec que la story va modifier ;
- `Blocks:` — les blocs qu'elle transcrit, ou `none` ;
- `Technical:` — `yes` pour une story technique, dont `Sections:` vaut alors
  `none`. Aucune autre story ne porte ce champ.

Le document porte aussi un `Rulings log` et une section `Observed drift`, créés
vides avec l'en-tête.

Ils sont complétés avant la fusion s'il y a lieu. Vides, ils signifient « examiné,
rien trouvé ».

Un arbitrage ouvert dit ce qui reste à trancher, et la catégorie du gaps register
qui l'accueille quand il en rejoint une.

`Global Constraints` porte :

1. la section `Constraints` du lot, recopiée mot pour mot ;
2. le gel du fichier de spec ;
3. la primauté de la spec sur le lot, et la correction d'une spec réservée à
   l'humain ;
4. les règles de `Concision` ;
5. dans un lot correctif seulement, sa condition d'arrêt
   (`Departures from superpowers`) ;
6. dans une story qui écrit du code gardé par un flag seulement, les règles de
   `Code under a feature flag`, quel que soit le lot qui déclare le flag ;
7. dans une story technique seulement, sa condition d'arrêt
   (`Departures from superpowers`) ;
8. seulement si le lot déclare des contraintes ou si `main` porte un ADR quand la
   branche de la story en part, la condition d'arrêt sur une contrainte ou un ADR
   qui ne peut pas être tenu (`Departures from superpowers`) ;
9. seulement si `main` porte un ADR quand la branche de la story en part,
   l'obligation de tenir ces ADR (`Architecture decision records`) ;
10. les conditions auxquelles une décision technique est consignée en ADR
    (`Architecture decision records`), et l'obligation de soumettre comme
    arbitrage ouvert la décision qui les réunit (`Delivering a story`).

### Concurrency detection

Deux stories, ou une story et un changement borné, qui touchent la même section
d'une même spec sont un conflit.

Seules les branches `story/*` et `bounded/*` revendiquent des sections.

Chacune déclare sa spec et ses sections : une story dans son document de story, un
changement borné dans le corps de sa pull request.

La détection lit les déclarations des pull requests ouvertes. Pour une branche
poussée qui ne porte pas encore de déclaration, elle prend les sections que la
branche a déjà modifiées.

Le travail qui démarre s'arrête si l'une de ses sections est ainsi revendiquée.

Il s'arrête aussi si une déclaration n'a pas pu être lue.

Un travail qui, avant l'ouverture de sa pull request, va toucher une section pour
laquelle il n'a pas fait la détection la fait, et s'arrête si cette section est
revendiquée ou si une déclaration n'a pas pu être lue.

### Delivering a story

Précondition, vérifiée avant de créer la branche : le lot est ouvert.

1. Détecter la concurrence.
2. Attribuer `us-N` et créer la branche `story/NN-us-N-<slug>`.
3. Commiter en premier la transcription des blocs de la story, mot pour mot, puis
   pousser la branche.

   Si le lot déclare un flag pour ce module, la modification de spec porte sa
   mention.

   Quand `main` a changé sous un bloc, la story l'ajuste sans en changer le sens.

   Quand le texte d'un bloc pose problème, l'agent le soumet à l'humain avant de
   le transcrire.

   Tout écart avec un bloc est nommé dans la pull request et tranché à la revue de
   livraison. Le document de lot n'est pas amendé.

   Une story qui ne transcrit aucun bloc commite en premier l'en-tête de son
   document de story, avec son `Rulings log` et son `Observed drift` vides, et ce
   qu'elle retire s'il y a lieu : l'entrée du gaps register qu'elle résorbe, ou la
   modification de spec qu'aucun bloc n'annonce.
4. Écrire le plan dans le document de story, le commiter et le pousser avant
   l'exécution.

   Le plan part de la conception technique du lot. Exceptions : là où un ADR la
   contredit, il suit l'ADR ; ailleurs, là où le code de `main` s'en est écarté,
   il part du code.

   Tout autre écart du plan à la conception technique est un arbitrage de
   conception technique, consigné dans le `Rulings log`.
5. Exécuter le plan par l'exécution par sous-agents de superpowers
   (`Built on superpowers`), puis conclure la branche par une pull request.
6. Avant la fusion, recopier les arbitrages de l'exécution dans le
   `Rulings log`, et consigner sous `Observed drift` les dérives constatées hors du
   périmètre de la story.
7. Répondre à la revue sur la branche de la story.

Une story ne fusionne pas avec un arbitrage ouvert sans destination.

Un arbitrage ouvert qui est une violation ou un gap rejoint le gaps register à la
clôture.

Tout autre arbitrage ouvert est tranché à la revue de livraison, et le
`Rulings log` porte ce qui a été tranché.

Une story soumet comme arbitrage ouvert la décision technique qu'elle prend et qui
réunit les conditions auxquelles elle serait consignée en ADR
(`Architecture decision records`). Si l'humain la veut en ADR, la story l'écrit
en réponse à la revue.

### Abandoning a story

La pull request d'une story abandonnée, s'il y en a une, est fermée sans fusion.

Sa branche est supprimée, sur le remote compris.

La clôture constate ce qui en subsiste sur `main` : la réservation au gaps
register, et les blocs jamais livrés.

## Feature flags

Un lot dont une story, fusionnée seule, laisserait un utilisateur devant quelque
chose d'incomplet déclare un flag par module qu'il garde.

Par défaut, un flag ne survit pas à son lot.

Un flag qui survit à son lot déclare sa portée et la condition qui le lève.

La section de spec qui décrit un comportement gardé porte la mention de son flag :
son nom, son défaut et, si sa portée dépasse le lot, sa condition de levée.

La spec est le seul registre des flags.

Chaque flag s'active, se désactive et se lève indépendamment des autres.

### Code under a feature flag

Le code gardé par un flag supporte l'activation pour une partie des utilisateurs,
l'activation pour tous et la désactivation :

- Les deux états travaillent sur les mêmes données : ce que l'un produit, l'autre
  le lit et s'en sert, sans erreur ni perte de donnée.
- Flag désactivé, l'utilisateur retrouve le comportement d'avant le lot.
- La pull request de la story teste le comportement flag activé, flag désactivé,
  et leur cohabitation.
- Lever le flag se réduit à supprimer le branchement et le comportement d'avant le
  lot, sans rien écrire de neuf.

### Lifting a feature flag

La story de levée supprime le branchement dans le code et la mention du flag dans
la spec.

Chaque flag a sa story de levée.

Elle est la dernière story du lot quand le flag est à portée de lot.

Quand la portée est étendue, elle appartient au lot dont le spec delta annonce la
levée.

Seule une story change le défaut qu'une mention de flag déclare.

## Architecture decision records

Un ADR vit dans `docs/adr/<slug>.md`.

Il énonce une décision et sa raison.

Un ADR que le flux écrit ou réécrit ne porte ni date ni statut.

Une décision technique n'est consignée en ADR que si elle réunit ces conditions :

- la défaire coûte cher ;
- elle surprend qui n'en connaît pas le contexte ;
- elle tranche entre de vraies alternatives.

Un agent n'écrit, ne réécrit ni ne supprime un ADR sans que l'humain l'ait décidé.

Ce qui s'observe à la frontière d'un module est une règle de sa spec, jamais un
ADR.

Un ADR ne contredit aucune spec ni aucun autre ADR.

Un ADR dont la décision est remplacée est réécrit sur place.

Un ADR dont la décision est abandonnée est supprimé.

Le commit qui réécrit ou supprime un ADR dit pourquoi.

Le code d'une story ou d'un changement borné tient les ADR que `main` porte quand
sa branche en part.

Aucun ADR ne s'impose au code déjà sur `main`.

Quand une story s'arrête sur un ADR qu'elle ne peut pas tenir, l'humain juge
l'ADR. S'il le juge intenable, la story est abandonnée et un changement borné
réécrit ou supprime l'ADR ; sinon, la story reprend en le tenant.

## Bounded change

Un changement borné n'a ni lot ni story : c'est une pull request unique, sur une
branche `bounded/<slug>`.

Quand il change quelque chose d'observable à la frontière du module, sa pull
request met la spec à jour avec le code. Sinon, la spec reste muette.

Exception : quand l'humain juge qu'une spec a tort et que le code a raison, un
changement borné porte la correction de spec que l'humain décide, sans toucher
au code.

Il déclare dans le corps de sa pull request la spec qu'il vise et les sections
qu'il touche, ou `none`.

Il subit la même détection de concurrence qu'une story.

Il ne porte aucun flag.

Il peut ajouter et supprimer des entrées du gaps register.

Il peut écrire, réécrire et supprimer des ADR.

Il peut ne porter que des ADR.

Quand un changement borné ne peut pas tenir un ADR, il le soumet à l'humain. Si
l'humain juge l'ADR intenable, le changement borné le réécrit ou le supprime ;
sinon, il le tient.

Un changement borné soumet à l'humain la décision technique qu'il prend et qui
réunit les conditions auxquelles elle serait consignée en ADR
(`Architecture decision records`). Si l'humain la veut en ADR, il l'écrit.

## Installing on a project

L'installation est idempotente.

Elle n'adopte jamais rien.

Elle produit une pull request, sur la branche `chore/supercharlouze-init`, qui :

1. crée `docs/specs/`, `docs/batches/` et `docs/archive/` ;
2. déplace `docs/superpowers/specs/` vers `docs/archive/specs/` et
   `docs/superpowers/plans/` vers `docs/archive/plans/`, en conservant les noms de
   fichiers. Si un document occupe déjà une destination, elle énumère toutes les
   destinations occupées et s'arrête avant tout déplacement ;
3. insère dans le fichier d'instructions que l'agent lit au démarrage, en le créant
   s'il n'existe pas, un bloc qui fait entrer toute conception et toute exécution
   de plan dans ce flux. Si ce bloc est déjà présent, elle le met à jour sur place,
   sans jamais le dupliquer ;
4. liste les modules déjà adoptés, c'est-à-dire ceux dont une spec existe dans
   `docs/specs/` ;
5. soumet à l'humain les ADR que `docs/adr/` porte déjà, et supprime ceux qu'il
   abandonne.

Une fois ses documents déplacés, `docs/superpowers` est supprimé s'il est vide. S'il
contient autre chose, l'installation le laisse en place sans y toucher.

## Language

L'ossature d'un document est anglaise : titres de sections, noms de champs,
libellés de gabarits, valeurs de statut, en-têtes de tableaux, patrons de chemins
et de branches, noms de skills et de commandes.

Sa prose est dans la langue du projet, comme les slugs de fichiers et de
répertoires.

Exception : ce que le plugin livre — skills, commandes, scripts, tests, README,
bloc d'instructions, messages — est intégralement anglais.

## Concision

Ces règles valent pour tout texte que le flux écrit : ses documents, les corps de
ses pull requests et ses messages de commit.

Chaque phrase dit une chose exacte, une seule fois, et se comprend seule.

Chaque paragraphe porte une seule règle.

Une règle dit jusqu'où elle vaut, et une exception se présente comme telle.

Un texte dit ce qu'il livre ou décide, sans raconter comment on y est arrivé ni
pourquoi. Exception : la raison que ce flux demande explicitement.

Aucune phrase n'est mise en relief.

## Conversation

Ce que l'agent dit à l'humain suit les règles de `Concision`.

Face à l'humain, un bloc, une story ou une entrée du gaps register se désigne par
la section qu'il vise et ce qu'il y change, jamais par son seul identifiant.
