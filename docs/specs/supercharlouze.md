# supercharlouze

## Boundary

Ce module couvre une extension de superpowers qui définit un flux de
développement : une spec vivante par module, des lots de stories qui font grandir
ces specs, des revues humaines tenues en pull request, les documents que ce flux produit —
spec, gaps register, document de lot, document de story — les conventions qu'il
laisse dans le dépôt — arborescence, branches, numéros, langue —, ce qu'il exige du
code applicatif tant qu'un flag le garde, et son installation sur un projet.

Il ne couvre ni superpowers lui-même, ni l'outil qui exécute les agents.

Le plugin entier constitue un seul module.

## Purpose

Le plugin étend superpowers d'un flux de développement : le document de conception
daté et le plan par fonctionnalité y sont remplacés par une spec vivante par module
fonctionnel, et les plans isolés par des lots de stories qui font grandir ces specs.

La spec de `main` décrit exactement ce que fait le code de `main`, et toute
divergence entre les deux est une dérive.

## The model

Chaque concept porte **un seul terme** dans la prose, lié ici au nom anglais que
portent les chemins, les branches et l'ossature des documents. Aucun synonyme n'est
employé.

**Module** (`module`) — un domaine fonctionnel grossier, vu de l'extérieur. Les
modules sont délimités par l'humain, jamais déduits par un agent.

**Spec** (`spec`) — le document vivant d'un module, qui dit ce que son code doit
faire.

**Section** (`section`) — la plus petite unité titrée d'une spec, et l'unité de
tout ce qui se compte dans ce flux : un conflit de concurrence se juge sur une
section, une entrée de gaps register désigne une section. « Exigence » n'est pas
une unité de ce flux.

**Gaps register** (`gaps register`) — le document vivant qui consigne, pour un
module, ce que sa spec ne tient pas : les violations de son code et les gaps
qu'elle ne décrit pas.

**Dérive** (`drift`) — toute divergence entre la spec de `main` et le code de
`main`.

**Lot** (`batch`) — l'unité de livraison : un ensemble de stories qui ajoute du
comportement à une ou plusieurs specs.

**Lot correctif** (`corrective batch`) — un lot dont le spec delta est vide, et qui
remet du code en conformité avec une spec déjà vraie.

**Bloc** (`delta block`) — l'unité du spec delta d'un lot : une section visée et
le texte exact qu'elle doit recevoir, transcrit mot pour mot par une story.

**Story** (`user story`) — le plan d'implémentation d'une part d'un lot, qui vise un
seul module et se livre en une pull request.

**Flag** (`feature flag`) — ce qui garde un comportement incomplet hors de portée
des utilisateurs jusqu'à sa levée.

**Mention de flag** (`gating sentence`) — la ligne `🔒 …` par laquelle une spec
déclare qu'un comportement est gardé par un flag, avec son défaut et, s'il survit à
son lot, la condition qui le lève. Sa forme est fixée dans `Feature flags`.

**Revue** (`gate`) — l'examen par l'humain d'une pull request, dont la fusion
fait avancer un module, un lot ou une story. La vérification d'un travail par un agent
est une relecture, pas une revue.

**Arbitrage** (`ruling`) — une décision prise par un agent sans l'humain, consignée
pour lui.

**Changement borné** (`bounded`) — un changement complet en une pull request, hors
de tout lot.

**Exploration** (`spike`) — un travail qui produit une réponse et aucun artefact.

**Conception architecturale** (`architectural`) — un travail qui demande une
conception avant d'être découpé en stories.

## Built on superpowers

Le flux reprend de superpowers les termes suivants, redéfinis ici réduits à ce dont
il se sert. superpowers en est le propriétaire.

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
  relue. Les arbitrages pris en cours de route, de la forme
  `Ruling: <décision> — <pourquoi> — <ce que ça coûte si c'est faux>`, sont
  présentés à l'humain en fin d'exécution.
- **Conclusion d'une branche** (`superpowers:finishing-a-development-branch`) — le
  choix de ce que devient une branche terminée : fusion locale, pull request, ou
  branche gardée.

## Departures from superpowers

Le flux s'écarte de superpowers en quatre points, et en aucun autre. Partout
ailleurs, superpowers s'applique inchangé. L'emplacement des documents et ce que le
flux ajoute à un plan ne sont pas des écarts : superpowers les laisse au projet.

- **Aucun document de conception daté.** Une conception architecturale se conclut
  par l'ouverture d'un lot : le document de lot remplace le document de conception,
  sa relecture avant ouverture en remplace l'auto-relecture, et la revue d'ouverture
  en remplace la revue humaine. Le plan n'est écrit qu'avec chaque story. Quand un
  module touché n'a pas de spec, son adoption précède la conception du lot, **et ne
  se conduit jamais dans le même contexte qu'elle** : une conception qui découvre un
  module non adopté s'arrête, l'humain choisit de l'abandonner ou de la mettre de
  côté, et elle ne reprend qu'une fois l'adoption fusionnée, dans un nouveau
  contexte.
- **Un lot correctif a une condition d'arrêt de plus.** L'exécution par
  sous-agents s'arrête aussi sur celle-ci, dans un lot correctif seulement :

  > Si, en mettant du code en conformité avec une spec, tu découvres que c'est la
  > **spec** qui a tort et le code qui a raison, arrête-toi. Le lot n'est plus
  > correctif et doit être requalifié.

- **Le mode d'exécution est imposé.** Une story s'exécute par sous-agents, et le
  choix d'un autre mode n'est pas proposé.
- **Une story se conclut par une pull request.** La conclusion de sa branche n'offre
  ni la fusion locale, ni la branche gardée.

## Authority and conflict rules

Le flux suppose deux contraintes du projet : **`main` est protégée**, tout y passe
par une pull request, et **`main` est déployée en continu**, chaque fusion part en
production. Il n'existe ni branche de lot ni branche d'intégration : une story se
fusionne dans `main`, et c'est un flag, pas une branche, qui garde un lot incomplet
hors de portée des utilisateurs.

**Toute branche du flux part d'un `main` à jour**, jamais d'une autre branche, et
**porte le nom que son étape lui assigne** avant que le travail commence, y compris
quand l'outil qui l'a créée en a choisi un autre ou a laissé un HEAD détaché : le
nom est alors rétabli. Une branche nommée autrement ne suffit pas.

**La spec est l'autorité contraignante de toute revue et de toute relecture.** Le
lot ne porte que ce qu'une spec ne peut pas porter : le périmètre de livraison,
l'ordre des stories, les contraintes de migration et de compatibilité, et la raison
pour laquelle ce travail a lieu maintenant.

**La pull request d'une story porte sa modification de spec et le code qui la
réalise**, livrés ensemble ou pas du tout. **La spec de `main` décrit toujours
exactement ce que son code fait.** Toute dérive est du travail correctif, sans exception.

**Quand un lot et une spec se contredisent, la spec gagne — sans exception et sans
délibération.** L'agent implémente ce que dit la spec, consigne un arbitrage, et
poursuit. **Corriger une spec en cours de lot est un acte humain, jamais un acte
d'agent.**

**Le gel du fichier de spec, avec un début et une fin :**

> Entre le commit de transcription et l'ouverture de la pull request, aucune tâche
> ne modifie le fichier de spec. Une story qui découvre que la spec doit changer
> s'arrête.

Le gel est levé à l'ouverture de la pull request : les demandes de la revue sont des
décisions humaines, y compris sur la formulation de sa modification de spec.

**Tout conflit est consigné pour l'humain**, comme arbitrage. Les arbitrages d'une
story sont recopiés dans son document, sur sa branche, avant la fusion.

**Les revues :**

| Revue | Pull request examinée | Sa fusion |
|---|---|---|
| Adoption | la spec et le gaps register du module | le module est adopté |
| Ouverture | le document de lot | le lot est ouvert |
| Livraison | la modification de spec et le code d'une story | la story est livrée |
| Amendement | la décision de changer le périmètre ou le flag d'un lot | le lot est amendé |
| Clôture | le changelog, la consolidation et `status: closed` | le lot est clos |

**L'agent n'approuve ni ne fusionne jamais une pull request de revue.**
L'approbation et la fusion sont des gestes humains.

**Pendant une revue, la branche n'est pas réécrite.** Chaque correction demandée
est poussée en commit `fixup!` du commit qu'elle corrige, ou en commit à part
quand elle porte une décision nouvelle, pour que l'humain voie sur la pull request
ce qui a changé depuis sa dernière lecture. **L'humain donne son accord dans la
conversation avec l'agent.** L'agent fond alors les `fixup!` dans les commits
qu'ils corrigent, pousse la branche réécrite, et annonce que la pull request est
prête à être approuvée et fusionnée.

**La fusion d'une revue est un moment de vider le contexte** : le document fusionné
porte alors tout ce dont la suite a besoin, et la conversation n'est plus qu'un
brouillon qui peut le contredire.

L'agent ne peut pas vider son propre contexte : en annonçant la pull request
prête, il dit que sa fusion sera ce moment. Quand une étape suivante existe, il la
nomme et donne dans un bloc à copier-coller le prompt qui la lance après le clear.
**Ce prompt se suffit à lui-même** : il nomme la skill à invoquer et le document
d'où repartir, et ne renvoie jamais à la conversation.

## Module

Un module a une spec et un gaps register, qui naissent ensemble à son adoption.
Aucun lot ne touche un module qui n'est pas adopté.

### Module adoption

L'adoption produit une pull request portant deux documents et aucun code : la spec
et le gaps register du module.

**Ordre d'autorité des sources :**

1. **Les documents validés** sont normatifs sur les **intentions qu'ils
   énoncent**, jamais sur les **mécanismes qu'ils décrivent**. Un mécanisme lu
   dans un document validé n'entre pas dans la spec : il devient un gap nommant
   son document, et seul l'humain peut l'en promouvoir. Dans cette limite, eux
   seuls créent du texte normatif.
2. **Le code** ne corrige jamais un document. Il comble les *silences* des
   documents — les comportements qu'aucun document n'a jamais décrits — et ce qu'il
   y révèle n'entre pas dans la spec de sa propre autorité : c'est un gap, que seul
   l'humain peut promouvoir en spécification.
3. **L'humain** tranche les contradictions.

**Reconstruire une spec depuis le code est exclu.**

**On ne lit pas « à travers » un mécanisme pour en déduire l'intention qu'il
servait.** La clause *On ne reformule pas un mécanisme en règle* de
`The spec document` vaut ici. Ce qu'un document énonce comme intention est
normatif et entre ; ce qu'il énonce comme mécanisme devient un gap. Déduire une
intention d'un mécanisme est la reconstruction depuis le code par un autre
chemin, que ce mécanisme soit lu dans le code ou dans un document validé.

**Étapes :**

1. **Délimiter le module** — l'humain le nomme et en trace les contours. Un agent
   ne propose pas de découpage de lui-même : il demande d'abord à l'humain le sien.
   S'il le souhaite, l'agent y réfléchit avec lui — il montre ce qui existe comme
   matière, pose des questions, confronte des options — mais la décision reste
   celle de l'humain, et rien n'est écrit tant qu'il ne l'a pas prise.
2. **Inventorier les documents validés** qui le couvrent — anciens documents de
   conception superpowers, README, docs métier, ADR. Présenter la liste à l'humain
   **avant** d'écrire quoi que ce soit, pour qu'il puisse ajouter une source
   manquante ou en écarter une qui n'a jamais été validée. L'inventaire retenu est
   consigné dans le corps de la pull request d'adoption ; la spec ne liste pas ses
   sources.
3. **Créer la branche `adopt/<module>`.**
4. **Écrire la spec depuis ces documents seuls.** Fusion, déduplication, mise en
   cohérence. Chaque phrase écrite passe le test de l'autre implémentation, et ce
   qu'il éjecte devient un gap nommant le document dont il vient. Quand deux
   documents validés se contredisent, le plus récent l'emporte par défaut, et
   cet arbitrage est consigné — jamais résolu en silence. L'adoption n'ayant pas de
   document de story, ces arbitrages vivent dans **le corps de la pull
   request d'adoption**.
5. **Auditer le code contre la spec** et compléter le gaps register de ce que
   l'audit révèle, dans ses deux catégories et avec sa couverture déclarée. Ne
   rien corriger dans le code au passage : résorber une violation est un lot à
   part entière.
6. **Proposer à l'humain de promouvoir les gaps.** Pour chaque gap qui décrit un
   comportement observable à la frontière du module, l'adoption demande à
   l'humain, gap par gap, si ce comportement porte une intention voulue. Ce qu'il
   valide entre dans la spec, dans la section que ce comportement contraint, et
   sort du gaps register ; le reste y demeure. L'intention est formulée ou validée
   par l'humain, jamais déduite, et un mécanisme ne lui est pas soumis.
7. **Ouvrir la pull request d'adoption.** Sa revue est la seule de l'adoption.

**Conclue par** la fusion de sa pull request : le module est adopté.

**Cas dégradé — un module sans aucun document validé.** L'adoption bascule en
dialogue : elle énumère les comportements **observables à la frontière du module**,
groupés en sections candidates, et demande à l'humain **section par section**,
« est-ce voulu ? » — une question posée sur l'intention, jamais sur le mécanisme.
**Un mécanisme ne se soumet pas à validation humaine.** Ce que l'humain valide
devient la spec ; le reste part en gaps. Le corps de la pull request d'adoption
consigne alors qu'aucun document validé n'existait, plutôt que de rester muet. Le même
traitement s'applique à un inventaire partiel : la partie couverte suit les étapes
2 à 6, la partie non couverte suit ce dialogue.

### The spec document

La spec vit dans `docs/specs/<module>.md`. Elle est **normative** — ce que le code
doit faire — et non descriptive. Elle ne porte **ni date, ni statut, ni marqueur de
travail en cours.**

**Ce dont une spec parle.** Une spec porte des règles et des intentions métier ; le
mécanisme reste dans le code. C'est une propriété de contenu distincte de la
normativité : une spec normative peut encore imposer un mécanisme. Les clauses qui
suivent s'appliquent ensemble.

**Le test de l'autre implémentation.** Le critère n'est pas un vocabulaire interdit,
mais une question posée à chaque phrase qu'on s'apprête à écrire :

> Un autre développeur, ayant implémenté la même intention autrement, lirait-il
> cette phrase comme vraie de son code ?

Oui : c'est une règle, elle entre. Non : c'est cette implémentation-ci, elle reste
dans le code.

Le test porte sur la **frontière du module**, jamais sur les mots. Un module dont le
domaine est l'infrastructure — un pipeline de déploiement, ou ce plugin-ci — énonce
des noms de branches et des pull requests comme règles, dès lors qu'ils sont
observables à sa frontière.

Deux corollaires :

- **une règle ne bouge pas quand un mécanisme bouge.** Une phrase qu'un changement
  d'avis purement technique obligerait à réécrire décrit la technique ;
- **la spec ne légifère pas sur la qualité du code.** Une implémentation maladroite
  qui produit le comportement promis est conforme.

**On ne reformule pas un mécanisme en règle.** L'intention derrière un mécanisme ne
se déduit pas : elle vient d'un document validé ou de l'humain. Une intention
paraphrasée depuis le code est de la reconstruction depuis le code.

Quatre signes la reconnaissent sans rien connaître du domaine :

- la section a **la forme du code** — une phrase par branche, un paragraphe par
  module technique ;
- elle est **vague là où le code est précis** — « quelques minutes » est un nombre
  effacé ;
- elle **nomme un acteur interne** — ce qui surveille, ce qui calcule, ce que ce
  module ne compte pas ;
- **personne hors du module ne pourrait dire si elle est tenue.**

La question qui les tranche tous : *qu'est-ce qu'un utilisateur ou un module voisin
perd si cette phrase est fausse ?* Si la réponse est « rien d'observable », ce n'est
pas une règle — c'est un gap, et il part au gaps register.

**Un choix métier porte son chiffre.** Une durée, un pas, une fenêtre, un plafond,
un délai de garantie sont des décisions métier, et une décision métier s'écrit avec
sa valeur. Si la valeur change, c'est la spec qui change. **Le flou est proscrit.**

Tout chiffre écrit dans une spec répond à cette question :

> Celui-là, d'où vient-il — d'une décision, ou d'une lecture du code ?

Un chiffre qui vient d'une lecture du code, ou dont on ne sait pas dire d'où il
vient, est un gap, pas une garantie — y compris quand il a la forme d'une garantie
que toute implémentation pourrait tenir.

**La structure de la spec suit le métier.** Une règle vit là où vit le comportement
qu'elle contraint. Une section qui reproduit la décomposition interne du code
— « les ports », « les adapters », « ce qui écrit où » — ou qui range les règles
par leur nature plutôt que par ce qu'elles contraignent — « les invariants », « les
contraintes » — est **proscrite**. Une section qui porte un concept observable à la
frontière du module — une convention de nommage, une règle d'autorité — suit le
métier, même quand ce concept vaut pour plusieurs comportements.

**Nommer n'est pas mécaniser.** Un glossaire qui lie un terme métier au nom porté
par le code et par l'interface est une règle, pas une fuite : il énonce que ce
concept s'appelle pareil partout, et renommer l'identifiant sans toucher au
glossaire rend la spec fausse. Un glossaire ne porte pas les noms qui ne sont ceux
de personne : un type de persistance, une classe d'adapter, un document de magasin.

**Tout ce qu'une spec contient est normatif, au même niveau.** Une spec ne
hiérarchise pas ses règles. Il n'y a ni règles principales, ni recommandations, ni
bonnes pratiques dans une spec — ce qui n'est pas opposable n'y entre pas. Un projet
qui veut un **aparté non normatif** — un exemple, une précision qui tempère une
règle voisine — déclare la convention qui le rend reconnaissable et s'y tient ;
aucun balisage n'est imposé, un aparté se distingue d'une règle et n'en porte
jamais une.

**Un module redéfinit ce qu'il emprunte.** Une spec se lit seule. Un terme dont un
module voisin fait autorité est redéfini ici, **réduit à ce dont ce module se
sert**, en nommant la spec qui en est propriétaire. L'emprunt réduit est un contrat,
pas une duplication.

**Périmètre de ces clauses.** Elles portent sur le fichier de spec, **toutes ses
lignes**, y compris la cellule `change` du changelog, et valent pour quiconque y
écrit. Elles ne portent pas sur `docs/specs/<module>.gaps.md`, qui n'est pas une
spec : une entrée de gaps register nomme un mécanisme, et c'est là que part tout ce que
le test éjecte.

Un élément de structure est fixe : une table **Changelog** en pied de document
porte l'historique `batch | date | change`. **Une ligne par lot, écrite par sa
pull request de clôture**, jamais une ligne par story. Les modifications faites
hors de tout lot portent `out-of-batch` et sont écrites par leur propre pull
request.

Une spec ne liste pas les documents qui l'ont nourrie à son adoption.

Aucune règle ne repose sur le changelog. L'historique qui fait autorité est celui du
fichier lui-même (`git log docs/specs/<module>.md`).

Une section décrivant un comportement encore gardé porte la mention de son flag
(`Feature flags`).

### The gaps register

`docs/specs/<module>.gaps.md` est un document vivant. Il range ses entrées en deux
catégories, chacune sous son propre titre :

- **Violations** — le code contredit la spec. Alimente un lot correctif.
- **Gaps** — un comportement ou une exigence réels qu'aucune spec ne décrit.
  Alimente un lot ordinaire qui les spécifie enfin.

**La catégorie ne dépend pas du contexte, ses sources oui.** Une adoption trouve
ses gaps en auditant le code et dans ce que l'écriture de la spec éjecte des
documents validés ; une story, dans le code qu'elle traverse ; un changement borné,
dans ce qu'il rencontre. **Une entrée nomme le document dont elle vient** quand
elle vient d'un document.

Chaque entrée désigne une section de la spec et est **un item adressable — un
élément de liste, jamais un paragraphe de prose courante.**

**Ajouter une entrée** — la pull request d'adoption à la création, puis la pull
request de clôture d'un lot seule, qui consolide les dérives constatées hors
périmètre par les stories du lot. Les stories **n'ajoutent pas** : elles consignent
leurs constats dans leur propre document, sous **Observed drift**. Une entrée
s'ajoute à la fin de sa catégorie. Un seul écrivain
par lot.

**Barrer une entrée existante** — la pull request de la story qui la résorbe, ou
celle d'un changement borné.

Un changement borné n'appartient à aucun lot : il ajoute comme il barre,
directement.

**Réservation, consommation, libération :**

- **Réservée** par la pull request d'ouverture du lot qui la prend en charge
  (annotation `reserved by batch-NN`).
- **Barrée** par la pull request de la story qui la résorbe, atomiquement avec le
  code qui la résorbe.
- **Libérée** par la pull request de clôture si elle n'a pas été consommée.

Le gaps register déclare aussi **sa propre couverture** : quelles parties du module ont
été auditées, lesquelles ne l'ont pas été, et pourquoi.

## Batch

Un lot vit dans `docs/batches/NN-<slug>/`. Il peut être transverse à plusieurs
modules.

**Un lot est identifié par `NN`**, le plus petit entier

- non utilisé dans `docs/batches/` sur `main`,
- non revendiqué par une pull request ouverte,
- non revendiqué par une branche poussée qui ne porte pas encore de pull request.

Seules les branches `batch/*` et `story/*` revendiquent un numéro :
`batch/NN-<slug>` revendique `NN`, et `story/NN-us-N-<slug>` revendique `NN` et
`us-N`.

**Le document de lot ne porte aucun état mutable**, et rien dans le déroulement
normal ne le modifie. En conséquence :

- **la liste des stories n'y figure pas** : elle est le contenu du répertoire du
  lot, complété par les pull requests ouvertes et par les branches `story/*`
  poussées qui ne portent pas encore de pull request ;
- **l'état d'une story n'y figure pas** : l'état d'une story *est* l'état de sa
  pull request.

**Il reste amendable par une pull request d'amendement** (`Amending a batch`),
revue comme les autres.

### The batch document

Un `README.md` avec un front matter `status: open | closed`, et :

- **Scope** — ce que ce lot livre, et pourquoi maintenant.
- **Spec delta** — le texte exact que ce lot écrit dans les specs, en **blocs**.
  Chaque bloc porte un identifiant `D<n>`, unique dans le lot, et nomme la spec et
  la section qu'il vise. Pour modifier un passage, il cite le passage actuel puis
  le texte qui le remplace ; pour en retirer un, il le cite ; pour ajouter du
  texte, il donne ce texte et l'endroit où il s'insère. **Aucun bloc n'est rattaché à une story** : c'est la story qui
  choisit, en s'écrivant, les blocs qu'elle transcrit. Une section qui change deux
  fois au cours du lot porte deux blocs, et `Constraints` donne leur ordre. Aucun
  bloc n'est transcrit dans une spec à l'ouverture : chacun l'est par une story,
  dans sa propre pull request. Un lot qui lève un flag déclaré par un autre lot le
  fait par un bloc qui retire sa mention : c'est une modification de spec comme une
  autre. Pour un lot correctif, ce champ est vide et remplacé par les entrées du
  gaps register que le lot réserve.
- **Constraints** — les contraintes de migration et de compatibilité, et l'ordre
  requis des stories ; `none` s'il n'y en a pas. **Rien de normatif n'y figure** :
  la spec reste seule autorité sur le comportement. Chaque story la recopie
  **verbatim** dans ses `Global Constraints` ; elle s'écrit donc comme des
  contraintes qu'un implémenteur peut respecter, et non comme du contexte.
- **Feature flag** — les flags que ce lot déclare : pour chacun son nom, son défaut
  et sa portée ; ou `none` avec la raison de l'exemption. Ce champ est
  **obligatoire et jamais vide**. Une portée
  qui dépasse le lot **nomme sa condition de levée**. Il prend, pour chaque flag,
  l'une de ces formes :

  ```markdown
  Feature flag: `<flag>`, <on|off> by default — scope: this batch
  Feature flag: `<flag>`, <on|off> by default — scope: beyond this batch, lifted when <condition de levée>
  Feature flag: none — <raison de l'exemption>
  ```

### Opening a batch

Une conception architecturale se conclut ici (`Departures from superpowers`).
L'ouverture :

1. Vérifie que chaque module touché est adopté ; sinon l'ouverture s'arrête, et
   l'adoption se conduit à part (`Departures from superpowers`).
2. Attribue `NN`.
3. Rédige le document de lot : scope, spec delta en blocs de texte exact, champ
   `Feature flag`.
4. **Réserve dans le gaps register toute entrée que ce lot prend en charge** —
   lot correctif puisant dans *Violations* comme lot ordinaire puisant dans
   *Gaps*. Deux lots ne réservent jamais la même entrée. **Aucune écriture dans
   les specs à ce stade.**
5. Ouvre la pull request du lot, sur la branche `batch/NN-<slug>`.

**La revue d'ouverture porte sur le texte exact de chaque bloc** : c'est là que
l'humain lit ce que diront les specs, avant qu'aucun code ne s'écrive dessus.

**Conclue par** la fusion de sa pull request : le lot est ouvert. Tant qu'elle n'est
pas fusionnée, aucune story ne s'écrit.

### Amending a batch

Un amendement change le périmètre ou le flag d'un lot ouvert, par une pull request
sur son document existant. C'est par lui qu'un lot exempté de flag en déclare un,
qu'un flag reçoit une portée étendue, et qu'un lot réduit ou abandonne son
périmètre.

Sa branche est distincte de `batch/NN-<slug>`, et son nom est sans signification :
elle ne revendique ni numéro ni section.

**Requalification d'un lot correctif.** Quand sa condition d'arrêt propre se
déclenche (`Departures from superpowers`), la story en cours est abandonnée
(`Abandoning a story`) une fois la requalification tranchée ; la réservation au
gaps register n'est pas touchée. Puis l'humain tranche :

- soit il corrige la spec — lui seul le peut — et le lot reste correctif sur un
  périmètre réduit ;
- soit le lot est réécrit comme lot ordinaire, avec un spec delta, par un
  amendement. **Cette réécriture garde `NN` et son répertoire**, et repasse la revue
  d'ouverture.

Un `NN` neuf n'est attribué que si l'humain juge le travail restant être un
*autre* lot, et celui-ci est alors clos plutôt que laissé ouvert. Dans tous les
cas, les réservations au gaps register sont révisées.

**Conclu par** la fusion de sa pull request : le lot est amendé.

### Closing a batch

Quand toutes les stories du lot sont fusionnées ou abandonnées et que l'humain
considère le lot terminé, sa clôture passe par une pull request, sur la branche
`batch/NN-<slug>-close`.

**Un lot ne peut pas être clos tant qu'un flag qu'il a déclaré subsiste par
accident.** Un flag de son champ `Feature flag` encore présent — dans le code ou
par sa mention dans une spec — n'est acceptable que si sa portée étendue et sa
condition de levée sont déclarées ; sinon, sa story de levée n'a pas été écrite. Un
flag déclaré par un autre lot n'entre pas dans ce contrôle : sa levée, si le spec
delta l'annonce, est un bloc comme un autre.

**Trois sorties, pas une impasse.** Un lot dont on renonce au périmètre alors que
des stories gardées sont déjà sur `main` ne reste pas ouvert indéfiniment. L'humain
choisit : écrire la story de levée et livrer ce qui existe ; déclarer au flag une
portée étendue par un amendement, ce qui reporte la décision à un lot ultérieur ;
ou écrire une **story de démontage** qui retire le code gardé et ce
qu'il avait ajouté à la spec.

**La pull request de clôture porte :**

- **la ligne de changelog** de chaque spec touchée — un lot, une ligne ;
- **la consolidation dans le gaps register** des sections `Observed drift` des
  stories du lot ;
- **la libération des réservations non consommées** ;
- **le constat des blocs non livrés** : un bloc du spec delta qu'aucune story
  fusionnée ne déclare dans son champ `Blocks:` est inscrit au gaps register comme
  *gap*, et le texte du lot est amendé pour ne plus promettre ce qu'il n'a pas
  livré ;
- **`status: closed`** dans le document de lot.

**Un lot correctif n'a pas de bloc non livré à constater** : son spec delta est
vide. Une entrée réservée et jamais résorbée est une réservation non consommée,
libérée comme les autres ; elle n'est pas reclassée en gap neuf.

**Conclue par** la fusion de sa pull request : le lot est clos. Cette revue acte une
décision humaine, comme les autres.

## Story

Une story appartient à exactement un lot et vise exactement **un** module, donc une
seule spec. C'est l'unité de livraison technique : **une story, une branche, une
pull request**, et cette pull request porte à la fois sa modification de spec et le
code qui la réalise.

**Une story est identifiée par `us-N` dans son lot**, attribué selon la règle qui
identifie un lot (`Batch`).

Les stories d'un lot sont écrites **une par une** — la story N+1 en connaissant ce
qu'a produit la story N — et plusieurs peuvent être en vol simultanément. **Chaque
story choisit, en s'écrivant, les blocs du spec delta qu'elle transcrit**, et les
transcrit en entier : un bloc n'est jamais partagé entre deux stories. L'état d'une
story *est* l'état de sa pull request : il n'y a rien à cocher ni à réconcilier.

### The user story document

Un plan, enregistré dans `docs/batches/NN-<slug>/NN-us-N-<slug>.md`. **Son basename
est unique parmi les documents de story du dépôt**, ce que garantit le préfixe
`NN-`. Il porte un en-tête étendu :

```markdown
**Spec:** docs/specs/<module>.md
**Batch:** docs/batches/NN-<slug>/README.md
**Sections:** <section> > <sous-section>, <section>
**Blocks:** D<n>, D<n>
```

`Spec:` désigne la spec vivante du module visé, autorité contraignante de toute
revue et de toute relecture de la story.

`Sections:` déclare les sections que la story touche, et c'est ce que lit la
détection de concurrence. Il est déclaré par l'auteur de la story, jamais déduit
d'un diff.

`Blocks:` déclare les blocs du spec delta que la story transcrit, et c'est ce que
lit la clôture pour constater les blocs non livrés. Il vaut `none` pour une story
qui n'en transcrit aucun — une story de lot correctif, une story de démontage.

Le document porte en outre un **Rulings log** et une section **Observed drift**,
remplis avant la fusion. Les deux sont **créées vides au moment du plan**, en même
temps que l'en-tête, et laissées vides si rien n'est venu : une section vide
signifie « examiné, rien trouvé ».

`Global Constraints` porte cinq choses :

1. les contraintes que le lot impose, sa section `Constraints` recopiée mot pour
   mot ;
2. le gel du fichier de spec ;
3. la règle d'autorité — la spec gagne sans délibération, et corriger une spec est
   un acte humain, jamais un acte d'agent ;
4. **dans un lot correctif seulement**, la condition d'arrêt propre au lot
   correctif (`Departures from superpowers`), recopiée intégralement ;
5. **dans une story qui écrit du code gardé par un flag seulement**, les règles du
   code gardé (`Code under a feature flag`), recopiées intégralement — que le flag
   soit déclaré par le lot de la story ou par un autre.

### Concurrency detection

Deux stories qui touchent la même section d'une même spec sont un conflit. La
détection est **par déclaration**, et lit **deux sources distantes** :

- les **pull requests ouvertes** touchant le même fichier de spec, dont on lit le
  champ `Sections:` ;
- les **branches `story/*` poussées qui ne portent pas encore de pull request et
  dont le diff contre `main` touche le même fichier de spec**, dont on lit le même
  champ sur leur tête.

Le même filtre par fichier de spec s'applique aux deux sources.

**La déclaration `Sections:` se lit là où la pull request la tient** : dans le
document de story pour une story, dans le corps de la pull request pour un
changement borné, qui n'a pas de document de story.

**Il faut s'arrêter** si l'intersection avec les sections visées n'est pas vide, et
**s'arrêter aussi si un champ `Sections:` n'a pas pu être lu** — lecture en échec,
document absent, champ manquant. Une branche poussée dont le document de story
n'existe pas encore arrête pareillement.

**La détection ne voit que ce qui est sur le remote** : une branche créée mais non
poussée lui est invisible.

**Le conflit de fusion git ne remplace pas cette détection.**

### Delivering a story

**Précondition**, vérifiée avant de créer la branche : le lot existe et est
ouvert — sa pull request d'ouverture est fusionnée et son document porte
`status: open`.

1. **Détecter la concurrence** sur les deux sources.
2. **Attribuer `us-N`** et **créer la branche** `story/NN-us-N-<slug>`.
3. **Commiter la transcription des blocs de cette story, puis pousser la branche
   immédiatement.** La transcription obéit à trois conditions :
   - **elle est mot pour mot** — le texte des blocs que déclare `Blocks:`, tel que
     la revue d'ouverture l'a lu, et jamais le delta complet du lot ;
   - **elle est le premier commit de la branche**, avant que le plan soit écrit et
     que la moindre tâche s'exécute : la norme précède le code dans l'histoire de
     la branche ;
   - **tout écart avec un bloc est nommé dans la pull request**, et tranché à la
     revue de livraison. Un écart n'a que deux causes légitimes. Soit `main` a
     changé depuis l'ouverture et le passage que le bloc cite n'y figure plus tel
     quel : la story ajuste le bloc à ce que porte `main`, sans en changer le sens.
     Soit le texte du bloc pose problème : l'agent s'arrête et le soumet à l'humain
     avant de le transcrire. Dans les deux cas, le document de lot n'est pas
     amendé.

   Si le lot déclare un flag, la modification de spec porte la mention du flag.

   **Cas correctif :** le delta étant vide, ce premier commit ne touche pas la
   spec ; il barre l'entrée du gaps register que la story résorbe.
4. **Écrire le plan** — le document de story, avec ses `Global Constraints`, puis
   **le commiter et le pousser immédiatement**, avant que l'exécution démarre.
5. **Exécuter par sous-agents**, puis conclure la branche par une pull request
   (`Departures from superpowers`).
6. **Avant la fusion**, recopier les arbitrages de l'exécution dans le Rulings log,
   consigner sous **Observed drift** les dérives constatées hors périmètre, et
   pousser les deux sur la branche.
7. **Répondre à la revue** sur la branche de la story.

**Conclue par** la fusion de sa pull request : la story est livrée.

### Abandoning a story

Sa pull request est fermée sans fusion s'il y en a une, et dans tous les cas sa
branche est supprimée localement **et sur le remote**. Deux résidus subsistent sur
`main`, que la clôture constate : la réservation au gaps register posée par la
pull request d'ouverture, et l'intention annoncée dans le spec delta et jamais
livrée.

## Feature flags

Un flag rend une story livrable seule sans exposer un lot à moitié fait. Un lot dont
les stories exposeraient du comportement incomplet en déclare un.

**Le flag est un objet spécifié.** La section de spec concernée énonce son nom et
son défaut, par sa mention.

**Le flag est par couple (lot, module).** Pas par story, et pas par lot : un lot
transverse qui garde du comportement dans deux modules déclare deux flags, un par
module.

**Par défaut, un flag ne survit pas à son lot.** Un flag qui lui survit déclare sa
portée et la condition qui le lève.

**Le critère d'exemption tient en une question :** une story de ce lot, fusionnée
seule, laisserait-elle un utilisateur devant quelque chose d'incomplet ? Si non,
pas de flag. Trois familles répondent non par construction :

- **Refactor et infrastructure** — ils ne changent aucun comportement.
- **Lot correctif** — il rétablit un comportement que la spec promet déjà.
- **Lot à story unique** — rien n'est jamais à moitié livré.

**La mention d'un flag** énonce son nom et son défaut, et — si la portée dépasse le
lot — sa condition de levée, sous l'une de ces deux formes :

```markdown
🔒 `<flag>`, <on|off> by default
🔒 `<flag>`, <on|off> by default — lifted when <condition de levée>
```

Elle disparaît quand le flag est retiré, et c'est un changement de spec comme un
autre. La condition de levée est écrite dans la spec, et pas seulement dans le
document de lot. **La spec est le seul registre des flags** : un flag existe tant
que sa mention y figure, dans la section qu'il couvre.

### Code under a feature flag

Le code gardé par un flag tient l'activation pour une partie des utilisateurs
seulement, l'activation pour tous et la désactivation, quelle que soit la manière
dont le projet active ses flags. Il tient quatre règles :

- **Les deux états cohabitent.** Un utilisateur au flag activé et un utilisateur
  au flag désactivé travaillent côte à côte sur les mêmes données. Ce que l'un
  produit, l'autre peut le lire et s'en servir.
- **La désactivation reste toujours possible.** Désactiver le flag, pour un
  utilisateur ou pour tous, laisse lisible et utilisable ce que l'état activé a
  produit, sans erreur ni perte de donnée.
- **Rien d'autre ne change.** Flag désactivé, l'utilisateur retrouve le
  comportement d'avant le lot, aux données produites sous flag activé près.
- **Chaque état est vérifié.** La pull request de la story porte des tests du
  comportement flag activé, du comportement flag désactivé et de leur
  cohabitation.

**La levée ne fera que retirer.** Le code gardé est écrit de sorte que lever le
flag se réduise à supprimer le branchement et le comportement d'avant le lot, sans
rien écrire de neuf.

### Lifting a feature flag

La story de levée supprime le branchement dans le code et la mention du flag dans
la spec. C'est une story ordinaire — du code et une modification de spec, dans une
pull request — et c'est elle qui met la fonctionnalité en production.

**Une story de levée par flag, donc par module.** Un lot transverse gardant deux
modules en écrit deux, et chacune respecte l'invariant « une story, un module ».

Elle est la dernière story du lot quand le flag est à portée de lot. Quand la
portée est étendue, elle appartient au lot dont le spec delta annonce la levée, et
que l'humain valide à la revue d'ouverture comme le reste de ce delta.

La levée est **une story, jamais une part de la clôture.** Une période
d'observation se fait en deux stories : la première fait passer le défaut déclaré
par la mention de `off` à `on`, la seconde supprime le branchement et la mention.

**Le défaut déclaré et l'état effectif sont deux choses distinctes.** La spec
déclare un défaut ; activer le flag pour une partie des utilisateurs, ou le
désactiver, est un geste du projet, qui ne change rien à ce que la spec déclare.
Seule une story change le défaut déclaré.

**Conclue par** la fusion de sa pull request : le flag est levé.

## Bounded change

Un changement borné n'a ni lot ni story : c'est une pull request qui porte sa mise
à jour de spec, sur une branche `fix/<slug>`. Quatre règles :

- **(a) Il ne laisse jamais la spec muette.** Qu'il *altère* un comportement déjà
  décrit ou qu'il en *ajoute* un que nulle spec ne décrit, sa pull request met la
  spec à jour en même temps que le code, avec une ligne de changelog
  `out-of-batch`.
- **(b) Il subit la même détection de concurrence qu'une story**, et déclare donc
  ses sections **dans le corps de sa pull request**. Son angle mort est accepté :
  entre son premier commit et l'ouverture de sa pull request, rien ne porte sa
  déclaration.
- **(c) Il ne porte aucun flag** : il est complet dans sa propre pull request.
- **(d) Il écrit directement dans un gaps register** : n'appartenant à aucun lot,
  il peut y ajouter comme y barrer une entrée depuis sa propre pull request.

## Installing on a project

L'installation est **idempotente** et **n'adopte jamais rien**. Elle produit une
pull request, sur la branche `chore/supercharlouze-init`, qui :

1. crée `docs/specs/`, `docs/batches/`, `docs/archive/` ;
2. déplace `docs/superpowers/specs/` vers `docs/archive/specs/` et
   `docs/superpowers/plans/` vers `docs/archive/plans/`, en conservant les noms de
   fichiers ;
3. insère dans le fichier d'instructions que l'agent lit au démarrage un bloc qui
   fait entrer toute conception et toute exécution de plan dans ce flux, ou le met
   à jour sur place s'il est déjà présent, **sans jamais le dupliquer**, que le
   projet ait déjà ce fichier ou non ;
4. rend l'état des lieux : quels modules sont adoptés — une spec existe dans
   `docs/specs/`.

**Ses refus sont normatifs au même titre que ce qu'elle fait :**

- **Collision d'archivage — refus de toute l'exécution, avant le moindre
  déplacement.** Si un document occupe déjà l'un des chemins de destination,
  l'installation les énumère tous et s'arrête sans rien déplacer.
- **Marqueurs du bloc cassés — refus, et fichier laissé intact.** Un marqueur
  d'ouverture sans fermeture, une fermeture sans ouverture, l'un ou l'autre en
  double, ou une fermeture placée avant son ouverture : l'installation nomme le
  défaut et sort sans réécrire. Elle ne devine pas où le bloc s'arrête.
- **Les marqueurs sont des lignes entières, jamais des sous-chaînes.** Une prose
  qui cite un marqueur n'est pas un bloc.
- **Le mode du fichier est préservé.**
- **L'arborescence `docs/superpowers` est supprimée une fois vidée, et seulement
  une fois vidée.** Ce qui y subsiste n'appartient pas au plugin : il n'est ni
  déplacé, ni supprimé, et sa présence laisse le répertoire en place.

**Elle ne propose aucun découpage en modules** : le découpage appartient à l'humain.

**Les répertoires qu'elle crée sont une destination, pas un état que le dépôt
maintient.** Un répertoire n'est sur `main` qu'à partir du premier document qu'il
reçoit : un clone frais peut donc ne pas le porter, et l'installation le recrée à
chaque exécution. Rien dans ce flux ne lit ces répertoires avant qu'un document y
soit écrit.

## Language

La frontière ne passe pas entre les documents, elle passe **à l'intérieur** de
chaque document : ossature en anglais, prose dans la langue du projet.

- **L'ossature est anglaise, partout** — titres de sections, noms de champs,
  libellés de gabarits, valeurs de front matter (`status: open | closed`),
  en-têtes de tableaux, patrons de chemins et de branches, noms de skills et de
  commandes. Cela vaut pour le plugin comme pour les documents qu'il produit.
- **La prose est dans la langue du projet** — corps des exigences, descriptions,
  justifications, et les slugs de fichiers et de répertoires, qui nomment des objets
  métier.
- **Le plugin lui-même est intégralement anglais** — skills, commandes, README,
  bloc d'instructions, messages.

## Changelog

| batch | date | change |
|---|---|---|
| 01 | 2026-09-05 | Lot correctif : les renvois des artefacts livrés nomment leur section de cette spec au lieu de citer un numéro du document de conception archivé, et deux gardes structurelles empêchent la réapparition du défaut — l'une contre les renvois numérotés, l'autre contre un renvoi dont la section n'existe plus. |
| 02 | 2026-09-17 | Douze silences comblés : le document de lot déclare ses sections `Constraints` et `Live flags`, dont les deux chaînes littérales par lesquelles une décision de gate atteint le contrôle de clôture ; `Global Constraints` porte quatre éléments et non deux, parce que c'est le seul canal que lisent les sous-agents de SDD ; les devoirs de clôture énoncent l'antériorité du contrôle des flags, les flags hérités et le cas du lot correctif ; le nom conventionnel de branche doit être **rétabli** et non simplement exister, la table gagne sa ligne d'amendement, et l'affirmation contraire est retirée ; les refus du script d'init deviennent normatifs et l'arborescence est déclarée non survivante à un clone ; la liste de vérification devient un plancher de dix catégories et dit ce que « structurel » veut dire. La suite passe de 90 à 187 assertions, dont une garde neuve sur l'intégrité de la suite elle-même. |
| 03 | 2026-09-19 | Une spec dit le métier et jamais le mécanisme : le test de l'autre implémentation, l'interdiction de reformuler un mécanisme en règle, un choix métier écrit avec sa valeur et dont on sait d'où elle vient, une structure qui suit le métier, un glossaire qui reste, tout au même niveau normatif, et un terme emprunté redéfini par le module qui s'en sert. L'adoption ne tient un document validé pour normatif que sur ses intentions, énumère à la frontière du module quand aucun document n'existe, demande son découpage à l'humain et lui propose de promouvoir les gaps un par un ; une entrée du gaps register nomme le document dont elle vient. La spec du plugin s'y conforme : elle est rangée par objet et par étape du flux, ne liste plus ses sources, fait de ses mentions de flag le seul registre des flags et n'impose plus d'ordre à la clôture. |
| 06 | 2026-09-20 | Ce que le code gardé par un flag doit tenir entre sa déclaration et sa levée est désormais écrit : les deux états cohabitent sur les mêmes données, la désactivation reste toujours possible, rien d'autre ne change, chaque état est vérifié, et la levée ne fera que retirer. Ces règles atteignent celui qui écrit le code par les `Global Constraints` de toute story qui en écrit sous flag, que le flag soit déclaré par son lot ou par un autre. La frontière du module annonce pour la première fois ce que ce flux exige du code applicatif d'un projet. Et une période d'observation se fait en deux stories : le défaut que la mention de flag déclare cesse d'être confondu avec l'état effectif du flag, que le projet règle comme il veut sans que la spec en soit changée. |
