---
status: closed
---

# 08 — Ce que la clôture a laissé passer

## Scope

**La clôture ne lit d'une story que son champ `Blocks:` et sa section
`Observed drift`.** Une story laisse plus que ça, et ce lot ramasse ce qui tombe
entre les deux.

**Un arbitrage resté ouvert.** Un `Ruling:` dont la décision laisse quelque chose à
trancher n'est lu qu'au gate de livraison ; si l'humain fusionne sans agir, il meurt
avec la clôture — et rien ne signale sa disparition, puisque ce qui disparaît ne
laisse pas de trace. La story `06-us-1-le-code-garde` en portait deux, versés au
gaps register sur décision explicite de l'humain, parce qu'aucun devoir ne les
ramassait.

**`Observed drift` ne peut pas les recueillir** : cette section recueille des
**constats**, et un arbitrage ouvert n'en est pas un — c'est une décision restée en
attente, dont l'information utile est ce qui reste à trancher. Les deux voyagent
ensuite ensemble, puisque la clôture les verse au même endroit.

**L'arbitrage ouvert devient un objet du flux, et porte sa forme.** La forme qu'un
arbitrage tient de superpowers —
`Ruling: <décision> — <pourquoi> — <ce que ça coûte si c'est faux>` — ne dit pas
qu'il reste quelque chose à trancher, ni quoi. Ce lot l'écrit **une fois**, là où le
Rulings log est défini : un arbitrage ouvert s'écrit `Open ruling:`, et sa ligne
nomme ce qui reste à trancher. Les deux règles qui font recopier les arbitrages
n'ont alors rien à porter de plus, et ce qui lit n'a plus à reconnaître une catégorie
dans de la prose. Ce nom anglais gagne au passage l'ancrage dans l'ossature que le
glossaire exige de chaque terme.

**Le refus vit à la livraison, parce que c'est le seul endroit où il peut encore
agir.** Une story ne fusionne pas en laissant un arbitrage ouvert sans destination :
celui qui est une violation ou un gap rejoint le gaps register par la consolidation
de la clôture, tout autre est tranché avant la fusion, à la revue où l'humain a déjà
les arbitrages sous les yeux. À la clôture, la story est fusionnée et sa branche
supprimée : on peut y constater qu'un arbitrage n'a pas été résorbé, on ne peut plus
le résorber.

**La clôture, elle, apprend où lire.** Elle nomme le `Rulings log` comme elle nomme
déjà le champ `Feature flag` et le champ `Blocks:`. Le register, symétriquement,
cesse de décrire ce que la clôture ramasse et qui écrit dans son fichier : il ne
régit plus que sa propre tenue. Qui écrit se lit chez chaque écrivain, où c'est déjà
écrit ; deux textes qui énoncent la même chose divergent, et c'est le défaut que ce
lot répare ailleurs — il ne l'introduit pas ici.

**Une branche du flux exige un répertoire qu'une session sur deux ne peut pas
avoir.** Les skills posent, pour chaque pull request de ce flux, la précondition
d'être dans le checkout principal. Une session lancée dans un worktree y est isolée
par le harnais, qui refuse toute commande git visant le checkout partagé : la
précondition est alors inatteignable, et la clôture du lot 06 a dû être conduite
hors de la voie décrite. Ce que cette précondition protège — qu'une clôture
n'atterrisse pas sur la branche de la dernière story — tient au point de départ de
la branche, et il suffit de dire lequel : `main` telle que le remote la porte. Le
répertoire disparaît alors de lui-même, sans qu'on ait à écrire qu'il ne compte pas.
Au passage, « un `main` à jour » ne disait pas à jour par rapport à quoi.

**Ce que ce lot ne fait pas, et pourquoi.**

Une modification de spec qu'une story écrit sans qu'aucun bloc la porte échappe elle
aussi à la clôture. Elle est restée hors de ce lot après examen : la nommer suppose
d'amender deux phrases de `Batch` qui sont des totalités — « le spec delta est **le
texte exact que ce lot écrit dans les specs** » et « la revue d'ouverture […]
**c'est là que l'humain lit ce que diront les specs** ». Sans cet amendement, le flux
comporterait une catégorie de texte de spec qui échappe aux deux phrases, lesquelles
resteraient écrites. Le lot 07 les visait par deux blocs que sa revue a retirés ; il
a fusionné sans eux, et personne ne les tient plus.

**L'arbitrage ouvert hors du chemin nominal** reste également dehors, et c'est un lot
à lui seul. Trois chemins produisent des arbitrages sans qu'aucun Rulings log
n'atteigne `main` : l'**adoption**, dont l'étape 4 applique « le plus récent
l'emporte » sans l'humain et loge ses arbitrages dans un corps de pull request ; le
**changement borné**, qui n'a ni document de story ni clôture ; et la **story
abandonnée**, dont le document meurt avec sa branche. Le dernier ne se règle pas
d'une phrase : ce qu'elle a trouvé devrait atteindre `main` avant que sa branche
disparaisse, alors que `Module > The gaps register` réserve l'écriture à la pull
request d'adoption et à celle de clôture — « un seul écrivain par lot » — et que la
clôture ne peut pas lire un document qui n'existe plus. Décider qui écrit est une
conception, pas un amendement.

**Pourquoi maintenant.** Les deux sujets ont été constatés le même jour, à la clôture
du lot 06, et par elle : le premier parce que deux arbitrages ont dû être sauvés à la
main, le second parce que la clôture s'est faite hors précondition.

## Spec delta

Module `supercharlouze`, une seule spec : `docs/specs/supercharlouze.md`.

Les identifiants `D3`, `D4`, `D6` et `D7` ont été portés par des blocs que
l'amendement du 21 septembre a supprimés. Ils ne sont pas réattribués.

### D1 — `Authority and conflict rules`

Passage actuel :

> **Toute branche du flux part d'un `main` à jour**, jamais d'une autre branche, et
> **porte le nom que son étape lui assigne** avant que le travail commence, y compris
> quand l'outil qui l'a créée en a choisi un autre ou a laissé un HEAD détaché : le
> nom est alors rétabli. Une branche nommée autrement ne suffit pas.

Texte qui le remplace :

> **Toute branche du flux part de `main` telle que le remote la porte**, jamais d'une
> autre branche, et **porte le nom que son étape lui assigne** avant que le travail
> commence, y compris quand l'outil qui l'a créée en a choisi un autre ou a laissé un
> HEAD détaché : le nom est alors rétabli. Une branche nommée autrement ne suffit pas.

### D2 — `The model`

Passage actuel :

> **Arbitrage** (`ruling`) — une décision prise par un agent sans l'humain, consignée
> pour lui.

Texte qui le remplace :

> **Arbitrage** (`ruling`) — une décision prise par un agent sans l'humain, consignée
> pour lui.
>
> **Arbitrage ouvert** (`open ruling`) — un arbitrage dont la décision laisse quelque
> chose à trancher.

### D5 — `Batch > Closing a batch`

Passage actuel, deuxième puce de la liste « **La pull request de clôture
porte :** » :

> - **la consolidation dans le gaps register** des sections `Observed drift` des
>   stories du lot ;

Texte qui le remplace :

> - **la consolidation dans le gaps register** de ce que les documents des stories
>   du lot ont laissé : leurs sections `Observed drift`, et les arbitrages ouverts
>   que leur `Rulings log` classe en violation ou en gap ;

### D8 — `Story > The user story document`

Texte inséré après le paragraphe qui ouvre par « Le document porte en outre un
**Rulings log** et une section **Observed drift**, », donc avant «
`Global Constraints` porte » :

> **Un arbitrage ouvert s'écrit `Open ruling:`** là où les autres s'écrivent
> `Ruling:`, et sa ligne se termine par ce qui reste à trancher, puis par la
> catégorie du gaps register qui l'accueille quand il en rejoint une.

Bloc d'insertion et non de remplacement à dessein : le lot 09 réécrit ce paragraphe
par son D6, et une insertion n'a besoin que de son ancre, que ce D6 conserve.

### D9 — `Story > Delivering a story`

Texte inséré après l'étape 7 de la liste numérotée, donc avant « **Conclue par** la
fusion de sa pull request : la story est livrée. » :

> **Une story ne fusionne pas en laissant un arbitrage ouvert sans destination.**
> Celui qui est une violation ou un gap rejoint le gaps register par la consolidation
> de la clôture. Tout autre est tranché avant la fusion, à la revue de livraison, et
> le `Rulings log` porte ce qui a été tranché.

### D10 — `Module > The gaps register`

Passage actuel :

> **Ajouter une entrée** — la pull request d'adoption à la création, puis la pull
> request de clôture d'un lot seule, qui consolide les dérives constatées hors
> périmètre par les stories du lot. Les stories **n'ajoutent pas** : elles consignent
> leurs constats dans leur propre document, sous **Observed drift**. Une entrée
> s'ajoute à la fin de sa catégorie. Un seul écrivain
> par lot.

Texte qui le remplace :

> **Ajouter une entrée** — une entrée s'ajoute à la fin de sa catégorie. Un seul
> écrivain par lot.

Ce bloc **retire** de la section tout ce qui désigne des écrivains. Un register
régit la tenue de son fichier ; qui y écrit se lit chez chaque écrivain, et y est
déjà écrit — `Module adoption` produit la pull request qui porte le register puis le
complète de ce que l'audit révèle, `Batch > Closing a batch` porte la consolidation
et l'inscription des blocs non livrés, `Bounded change` règle (d) écrit directement.
Une liste ici est un second texte à tenir synchrone d'un ensemble de sections qui
bougent, et c'est exactement la dérive que ce lot répare ailleurs.

**« Un seul écrivain par lot » reste**, et c'est délibéré : c'est la seule contrainte
de ce paragraphe qu'aucune section d'écrivain ne porte, et c'est elle qui interdit à
une story d'écrire. Elle la pose sans nommer personne.

## Constraints

- **Ordre requis.** D5, D8 et D9 emploient le terme que D2 pose au glossaire : ils
  sont transcrits dans la même story que D2, ou après elle. D5 emploie en outre le
  classement que D8 fait écrire dans le `Rulings log` : il ne précède pas D8. D1 et
  D10 n'imposent aucun ordre.
- **Deux constats faits en concevant ce lot partent en `Observed drift`**, et la
  clôture les versera au gaps register. Tous deux sont antérieurs à ce lot, hors de
  son périmètre, et ne sont pas à résorber ici.

  **Les deux totalités de `Batch`** — « le spec delta est **le texte exact que ce
  lot écrit dans les specs**, en blocs » et « la revue d'ouverture […] **c'est là
  que l'humain lit ce que diront les specs** » — que les propres règles de la spec
  contredisent : l'étape 3 de `Delivering a story` fait écrire la mention d'un flag
  par la story sans qu'aucun bloc la porte, la story de démontage retire de la spec
  ce que le lot y avait ajouté avec `Blocks: none`, et la levée d'un flag à portée
  de lot n'exige pas davantage de bloc. Le code fait ce que ces règles disent ; ce
  sont les deux totalités qui ont tort.

  **L'énumération de `Blocks: none`** dans `Story > The user story document` cite la
  story de lot correctif et la story de démontage, et omet la story de levée d'un
  flag à portée de lot, qui n'en transcrit pas davantage.

- **Consigner avec eux que leur canal n'a pas de définition qui les couvre.**
  `The model` définit la dérive comme une divergence entre la spec de `main` et son
  code ; ces deux constats sont des contradictions entre règles d'une même spec.
  Ils partent tout de même en `Observed drift`, faute d'autre chemin et parce que le
  précédent existe sur `main` — la story `05-us-1-le-domicile-d-une-regle` y a versé
  un constat de même nature, classé en *gap* à la clôture. Que cette section serve à
  plus que ce que sa définition dit est un constat de plus, qu'aucun lot ne tient.

## Feature flag

Feature flag: none — chaque story est complète dans sa propre pull request

Une story de ce lot, fusionnée seule, ne laisse personne devant quelque chose
d'incomplet. D1 et D10 livrées seules sont des règles qui valent dès qu'elles sont
lues. Les quatre autres voyagent sous la contrainte d'ordre ci-dessus, qui interdit
qu'un terme soit employé avant d'être posé.
