---
status: open
---

# 03 — Le métier, pas le mécanisme

## Scope

Ce lot donne à la spec une **seconde propriété de contenu**, à côté de « normative
et non descriptive » : une spec porte des règles et des intentions métier, et le
mécanisme reste dans le code. Les deux axes sont orthogonaux, et c'est tout le
problème — rien aujourd'hui n'empêche une spec parfaitement normative d'imposer un
magasin de données, un déclencheur ou une couche d'adapters.

La règle a **deux moitiés**, et la seconde est celle qui mord. La première dit ce
qui n'entre pas : un test de remplaçabilité, appliqué à la frontière du module. La
seconde dit ce qu'on n'a pas le droit d'écrire à la place : **on ne reformule pas
un mécanisme en règle**. Une moitié sans l'autre ne tient pas — le test éjecte le
mécanisme et laisse un trou, et un agent qui doit remplir un trou invente.

Le lot porte aussi les deux conséquences propres à l'adoption, qui est le seul
moment où une spec s'écrit contre des documents et contre du code existant :
l'autorité d'un document validé porte sur l'intention et non sur le mécanisme, et
le cas dégradé — celui qui énumère depuis le code — le fait à la frontière du
module.

**Pourquoi maintenant.** Parce que le trou vient de coûter trois itérations et deux
revues de rejet sur une adoption réelle, dans un dépôt qui utilise ce plugin :
`charlouze/beacon-hosting#45`, adoption du module `session`. Les trois versions
sont lisibles dans l'historique de la branche, et elles forment la meilleure
matière que ce lot pouvait espérer.

**v1** (`d2760b3`, 774 lignes) est une description d'architecture. Sections
`The ports of this context`, `The server record`, `Who reads and writes here` : le
modèle de document du magasin champ par champ, la colonne « Écrivain » qui vaut
`Functions`, les règles de sécurité du moteur, la table des ports et leurs
adapters. Verdict de la revue : *« tu as écrit une spec qui décrit le
fonctionnement d'un code source lié à une méthode d'hébergement »*.

**v2** (`9f34685`, 396 lignes) est la version qui justifie à elle seule la seconde
moitié de la règle. Verdict de la revue : *« cette fois t'as essayé de tourner tes
contraintes techniques en règle métier… c'est plus vicieux »*. Elle l'est, et elle
est instructive :

- le tableau des garanties garde **une ligne par branche de code** du balayage
  périodique, et remplace les nombres par « quelques minutes », « quelques dizaines
  de minutes ». Le flou n'est pas de la prudence : c'est un nombre effacé, donc une
  garantie que rien ne peut contredire. La v3 remet 2, 5, 25, 10 — parce que ce
  sont des **promesses**, et une promesse porte son chiffre ;
- *« Une fermeture demande la disparition d'un serveur de jeu, jamais celle d'une
  liste d'objets »* est la table des ports de la v1, reformulée en métier. Rien
  hors du module ne peut l'observer ;
- *« Ce qui surveille ce rattrapage n'appartient pas à ce module »* et *« le calcul
  d'une échéance vit dans l'application »* sont de l'architecture en prose ;
- et surtout : *« Ce dont l'origine n'est pas prouvable est signalé, jamais
  détruit »* est le comportement du code, promu en règle. **Dans la v3, exactement
  la même chose est listée en violation du gaps register.** Le blanchiment a
  transformé une dérive en canon, dans le même document, à une itération d'écart.

C'est la démonstration, sur pièces, que reformuler un mécanisme en métier est de la
**reconstruction depuis le code par un autre chemin** — la règle porteuse du plugin
contournée d'un cran, sans qu'aucune de ses formulations actuelles ne s'y oppose.

Un dernier constat, de la même pull request, montre que la fuite n'a pas besoin
d'être grossière pour coûter. La v3 — celle que la revue a acceptée — écrit encore
« le système vérifie toutes les cinq minutes », un intervalle de balayage, juste à
côté d'un tableau de garanties par ailleurs irréprochable. Son gaps register porte
en conséquence une violation : *« la vérification est différée à trente minutes au
lieu des cinq que la spec garantit »*. Le code fait du backoff au repos, ce qui est
sain ; la garantie métier réelle — au bout de combien de temps une ressource
orpheline disparaît — n'est nulle part. **La fuite a fabriqué un lot correctif
contre du code sain, et laissé la vraie règle non spécifiée.**

**Une v4 a suivi** (`3d59552`, 256 lignes), après vingt-cinq commentaires en ligne
qui reprennent la spec phrase par phrase. Deux enseignements, et ils tirent en sens
inverse l'un de l'autre :

- **la fuite la plus tenace est celle qui ressemble le plus à une garantie.**
  « Le système vérifie toutes les cinq minutes » a traversé les **quatre** versions
  sans qu'aucune revue ne l'arrête, alors que la table de garanties juste en dessous
  est irréprochable. Une revue humaine attentive, quatre fois de suite, ne suffit
  pas : c'est un critère écrit qu'il faut ;
- **et la peur du mécanisme fabrique du flou.** Plusieurs commentaires réclament
  l'inverse de ce que la règle pourrait laisser croire — *« n'ayons pas peur d'être
  précis… une session dure 4h et si un jour on fait évoluer ça, on fera évoluer la
  spec »*, *« repousse d'une heure la fermeture et c'est disponible 30 minutes avant
  la fin »*, ou simplement *« combien de temps ? »* en face d'une phrase vague. Une
  règle qui interdit le mécanisme sans exiger la précision produit mécaniquement la
  v2. Le contrepoids est donc dans le delta, pas en commentaire.

**Un commentaire vise le plugin et non l'adoption**, et il est signalé plutôt que
fondu dans le périmètre : *« je ne comprends pas l'intérêt d'une section `Sources`.
[…] c'est toujours la spec qui fait foi pour tout malgré d'autres sources. Elle
devient elle-même source incontestable. »* La v4 a supprimé la section. C'est une
contestation d'une règle que ce plugin prescrit — la section `Sources` et l'état des
lieux de `init` qui la lit — et elle se tranche dans un lot à elle, pas ici.

**Ce qui a sorti cette adoption de l'ornière mérite d'être consigné** : la v3 est
celle qui a été écrite en invoquant la skill `domain-driven-design`, et c'est de là
que vient sa section `Ubiquitous language`. Le plugin n'y est pour rien — aucune de
ses formulations n'a rattrapé la v1 ni la v2, et ce qui a rattrapé la v3 lui est
extérieur. C'est un argument pour la question laissée ouverte plus bas, et c'est
aussi la mesure de ce que ce lot doit accomplir tout seul.

**Ce lot ne puise pas dans le gaps register** et ne réserve donc aucune entrée :
aucune des entrées de `docs/specs/supercharlouze.gaps.md` ne porte sur le contenu
d'une spec. Il ajoute de la norme neuve, tirée d'une décision humaine prise en
conception.

## Spec delta

Module `supercharlouze`, une seule spec. Le delta est énoncé par section de spec.

### `The spec document`

La section énonce aujourd'hui ce qu'une spec **ne porte pas** en fait de
métadonnées — ni date, ni statut, ni marqueur — et ce qu'elle porte en fait de
structure. Elle ne dit rien de ce dont une spec **parle**. Le delta l'ajoute, en
cinq clauses indissociables.

**Première clause — le test de l'autre implémentation.** Une spec porte des règles
et des intentions métier ; le mécanisme est dans le code. Le critère n'est pas un
vocabulaire interdit mais une question, posée à chaque phrase qu'on s'apprête à
écrire :

> Un autre développeur, ayant implémenté la même intention autrement, lirait-il
> cette phrase comme vraie de son code ?

Oui : c'est une règle, elle entre. Non : c'est votre implémentation, elle reste dans
le code. La forme est délibérément celle-là plutôt qu'un « personne hors du module
ne s'en apercevrait » — imaginer un collègue est à la portée d'un agent, imaginer un
observateur externe ne l'est pas. Le test se formule de façon équivalente par la
remplaçabilité — *ce mécanisme peut-il être remplacé sans rendre la spec fausse pour
quiconque est hors du module ?* — et les deux se recoupent ; c'est la première qu'on
applique.

**Corollaire, le test de stabilité.** Une règle ne bouge pas quand un mécanisme
bouge. Si un changement d'avis purement technique obligeait à réécrire la phrase,
c'est que la phrase décrivait la technique.

**Second corollaire : la spec ne légifère pas sur la qualité du code.** Une
implémentation maladroite qui produit le comportement promis est conforme. La spec
dit ce qui doit être vrai, jamais par quel chemin ni avec quelle élégance.

Le test porte sur la **frontière du module**, jamais sur les mots, et c'est ce qui
le rend applicable partout. Un module dont le domaine *est* l'infrastructure — un
pipeline de déploiement, ou ce plugin-ci — énonce des noms de branches et des appels
`gh` comme règles, parce qu'à sa frontière ils sont observables et qu'un autre
implémenteur les lirait comme vrais du sien. Un vocabulaire interdit rendrait la
présente spec illégale ; le test la laisse s'écrire.

**Deuxième clause — on ne reformule pas un mécanisme en règle.** Le test dit ce qui
sort, pas ce qui le remplace, et c'est là qu'un agent invente. L'intention derrière
un mécanisme ne se **déduit** pas : elle vient d'un document validé ou de l'humain.
Une intention paraphrasée depuis le code est de la reconstruction depuis le code, et
la règle qui en sort a trois défauts qu'aucune revue n'attrape facilement : elle est
invérifiable de l'extérieur, elle a la forme du code plutôt que celle du métier, et
elle **canonise la dérive** — puisque c'est le comportement observé qu'elle décrit.

Quatre signes reconnaissent un blanchiment sans rien connaître du domaine, et la
spec les énonce :

1. la section a **la forme du code** — une phrase par branche, un paragraphe par
   module technique ;
2. elle est **vague là où le code est précis** — un « quelques minutes » est un
   nombre effacé, pas une promesse prudente ;
3. elle **nomme un acteur interne** — ce qui surveille, ce qui calcule, ce que ce
   module ne compte pas ;
4. **personne hors du module ne pourrait dire si elle est tenue.**

La question qui tranche les quatre : *qu'est-ce qu'un utilisateur ou un module
voisin perd si cette phrase est fausse ?* Si la réponse est « rien d'observable »,
ce n'est pas une règle — c'est un gap, et il part au registre.

**Troisième clause — un choix métier porte son chiffre.** C'est le contrepoids des
deux premières, et sans lui elles fabriquent du flou : un agent à qui l'on interdit
le mécanisme écrit « quelques minutes » et croit avoir obéi. Une durée, un pas, une
fenêtre, un plafond, un délai de garantie sont des **décisions métier**, et une
décision métier s'écrit avec sa valeur. « Une session dure quatre heures », « la
prolongation repousse la fermeture d'une heure et n'est offerte que dans les trente
dernières minutes » : si la valeur change un jour, c'est la spec qui change, et
c'est exactement ce à quoi sert une spec vivante. **Le flou n'est pas de la
prudence** — c'est une règle qu'aucun code ne peut contredire, donc une règle qui ne
sert à rien.

Ce qui distingue ce chiffre-là du chiffre qu'il faut proscrire est le test de la
première clause, et rien d'autre : un autre implémenteur lirait « une session dure
quatre heures » comme vraie de son code, et ne reconnaîtrait pas « le balayage passe
toutes les cinq minutes ».

**Quatrième clause — la structure de la spec suit le métier.** Une règle vit **là où
vit le comportement qu'elle contraint**, et non regroupée dans une section qui
rassemble les règles par nature. Une section « les invariants », « les ports », « ce
qui écrit où » a la forme des couches du code, et cette forme suffit à trahir
l'origine du texte même quand chaque phrase, prise seule, passerait le test. C'est
le premier signe de blanchiment, énoncé du côté constructif.

**Cinquième clause — nommer n'est pas mécaniser.** Un glossaire qui lie un terme
métier au nom porté par le code et par l'interface est **une règle et non une
fuite** : il énonce que ce concept s'appelle pareil partout, ce qui est exactement
ce qui permet à un expert du domaine de lire le code et d'y reconnaître ses
intentions. Cette règle passe le test : renommer l'identifiant sans toucher au
glossaire rend la spec fausse, puisqu'elle promettait le contraire. Sans cette
clause, un agent appliquant la première mécaniquement supprimerait le glossaire —
l'inverse de ce qu'on veut. Ce qu'un glossaire n'a pas à porter, ce sont les noms
qui ne sont ceux de personne : un type de persistance, une classe d'adapter, un
document de magasin.

**Périmètre de la règle.** Elle porte sur le fichier de spec, **toutes ses lignes**,
y compris la cellule `change` du changelog — c'est une propriété du document, donc
elle vaut pour quiconque y écrit, sans qu'aucun skill n'ait à se la voir rappeler
avec plus de force qu'un autre. Elle ne porte **pas** sur
`docs/specs/<module>.gaps.md`, qui n'est pas une spec : une entrée de registre
nomme un mécanisme, c'est son métier, et c'est là que part tout ce que le test
éjecte. Dire les deux est nécessaire : une règle sans exutoire déclaré laisse un
agent qui l'a comprise sans aucun endroit où écrire ce qu'il a trouvé.

### `Module adoption`

Deux conséquences, propres à l'adoption parce qu'elle est le seul moment où une
spec s'écrit contre des documents et contre du code existant.

**L'ordre d'autorité des sources est resserré.** Un document validé fait autorité
sur les **intentions qu'il énonce**, pas sur les **mécanismes qu'il décrit** — et un
document de conception en est plein. Un mécanisme lu dans un document validé n'entre
pas dans la spec : il est consigné au gaps register, où seul l'humain peut le
promouvoir. Rien n'est perdu, tout est adressable, et la promotion reste un acte
humain — la mécanique qui existe déjà pour les silences. Et la deuxième clause
ci-dessus vaut ici aussi, avec la même force : on ne lit pas « à travers » un
mécanisme pour en déduire l'intention qu'il servait. Ce qu'un document énonce comme
intention est normatif et entre ; ce qu'il énonce comme mécanisme part en gap.

**Le cas dégradé énumère à la frontière.** L'adoption sans document validé bascule
en dialogue et « énumère les comportements trouvés dans le code » — formulation qui
invite exactement ce que la v1 de l'exemple ci-dessus a produit, puisqu'un agent qui
lit du code y voit d'abord de l'infrastructure. Le delta la borne : l'énumération
porte sur les comportements **observables à la frontière du module**, et la question
posée section par section porte sur l'intention, jamais sur le mécanisme. Un
mécanisme ne se soumet pas à validation humaine — le valider n'en ferait pas une
règle, seulement une dérive approuvée.

### `The gaps register`

La spec définit un gap comme « le code fait des choses qu'aucune spec ne décrit ».
Le delta élargit d'un cran, parce qu'une source neuve y écrit désormais : un
mécanisme prescrit par un **document validé** et laissé hors de la spec est un gap,
et son entrée **nomme le document dont il vient**. Le cas nominal rentrait déjà sans
forcer — le document prescrit, le code exécute — mais un mécanisme prescrit et
absent du code n'était ni un gap ni une violation, et n'avait nulle part où aller.
Nommer la source est ce qui permet à l'humain de le promouvoir en connaissance de
cause plutôt que de relire le document entier.

## Constraints

- **Ordre requis.** La tranche `The spec document` est transcrite **en premier** et
  fusionnée avant que la seconde commence : la tranche `Module adoption` cite la
  règle que la première pose, et l'écrire contre un texte non fusionné produirait
  deux formulations concurrentes de la même règle. Les deux tranches n'ont aucun
  autre ordre entre elles, et il n'y en a que deux.
- **La spec de ce plugin doit survivre à la règle qu'elle énonce.**
  `docs/specs/supercharlouze.md` est pleine de noms de branches, d'appels `gh` et de
  mécanique git — légitimement, parce qu'ils sont observables à la frontière de ce
  module. Toute formulation qui rendrait cette spec illégale est une mauvaise
  formulation, et il faut la reprendre plutôt que l'excepter. C'est le meilleur test
  disponible de la règle, et il est gratuit.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`, dans la
  même pull request qu'elle.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**
- **Aucun renvoi numéroté.** Un renvoi nomme la section qu'il vise ; il ne la compte
  pas.
- **Ne rien aligner en silence.** Là où l'écriture révèle que le code contredit la
  spec, la constatation part sous `Observed drift` dans le document de story.
- **Cinq décisions sont tranchées au gate d'ouverture** et ne se rediscutent pas en
  cours d'implémentation : le critère est le **test de l'autre implémentation** et
  non une liste de mots interdits ; un mécanisme lu dans un document validé **part
  au registre** plutôt que d'être lu à travers pour en déduire une intention ; **un
  choix métier porte son chiffre**, la règle n'autorisant jamais le flou ; **nommer
  n'est pas mécaniser**, donc un glossaire métier reste ; et le gaps register est
  **hors du périmètre** de la règle.
- **La contestation de la section `Sources` est hors périmètre.** Elle est réelle,
  elle vise ce plugin, et elle demande de décider si une spec vivante a encore
  besoin de déclarer ce qui l'a nourrie — avec l'état des lieux de `init` qui en
  dépend. Aucune story de ce lot n'y touche, ni pour la défendre ni pour la retirer.
- **Aucune dépendance à `domain-driven-design`.** La règle s'énonce de façon
  autonome, et elle doit tenir pour un agent qui n'a jamais chargé cette skill.
  Faire de `domain-driven-design` un prérequis du plugin, au même rang que
  superpowers, est une question ouverte et délibérément hors de ce lot — mais
  l'exemple ci-dessus l'a rendue plus sérieuse, puisque c'est son invocation qui a
  produit la seule version acceptable des trois. Trancher cette question demande de
  peser une dépendance externe que le plugin ne contrôle pas ; c'est une décision
  humaine, elle ne se prend pas au détour d'une story.
- **Ne toucher à aucune entrée du gaps register.** Ce lot n'en réserve aucune ;
  toutes appartiennent à d'autres lots.

## Feature flag

Feature flag: none — chaque story est complète dans sa propre pull request

Le critère d'exemption est une question : une story de ce lot, fusionnée seule,
laisserait-elle un utilisateur devant quelque chose d'incomplet ? Non. Chacune écrit
une règle qui vaut dès qu'elle est lue, et il n'existe aucune porte à ouvrir sur de
la prose de skill — la tranche `The spec document` fusionnée seule laisse un plugin
dont la règle est énoncée et applicable, simplement pas encore déclinée à
l'adoption.

## Live flags

none

Vérifié sur l'intégralité de `docs/specs/supercharlouze.md`, au niveau du module et
non des sections visées. Le fichier ne contient qu'une seule occurrence de `🔒`,
ligne 232 : c'est l'**exemple illustratif** de la section *The spec document*, à
l'intérieur d'un bloc de code, qui montre la forme qu'une phrase de gating doit
prendre sans en déclarer une. Aucun flag n'est vivant sur ce module, et ce lot n'en
hérite aucun.
