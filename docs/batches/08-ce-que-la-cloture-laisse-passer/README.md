---
status: open
---

# 08 — Ce que la clôture a laissé passer

## Scope

**La clôture ne lit d'une story que son champ `Blocks:` et sa section
`Observed drift`.** Une story laisse plus que ça, et ce lot ramasse ce qui tombe
entre les deux.

**Un arbitrage resté ouvert.** Un `Ruling:` qui parque un constat ou le remonte à
l'humain n'est lu qu'au gate de livraison ; si l'humain fusionne sans agir, il meurt
avec la clôture — et rien ne signale sa disparition, puisque ce qui disparaît ne
laisse pas de trace. La story `06-us-1-le-code-garde` en portait deux, versés au
gaps register sur décision explicite de l'humain, parce qu'aucun devoir ne les
ramassait.

**`Observed drift` ne peut pas les recueillir**, par construction : la section est
définie pour les divergences entre spec et code, et un constat parqué n'en est pas
une — un mécanisme prescrit mais pas encore construit n'est ni une violation ni un
gap.

**Deux choses écrivent dans cette queue, et aucune ne sait le faire aujourd'hui.**
La forme d'un arbitrage vient de superpowers —
`Ruling: <décision> — <pourquoi> — <ce que ça coûte si c'est faux>` — et les deux
règles qui alimentent le `Rulings log` disent **recopier** : une recopie ne peut pas
produire une information que la forme ne porte pas. Ce lot fait donc nommer, à
l'étape qui recopie, ce qui reste à trancher — sans quoi son propre contrôle de
clôture lirait une distinction qu'aucun chemin n'écrit.

**Ce qui n'a pas de destination arrête la clôture**, comme l'arrête déjà un flag qui
survit sans portée déclarée. Une mention dans un corps de pull request se lit ou ne
se lit pas ; un refus, non.

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

**Ce que ce lot ne fait pas, et pourquoi.** Une modification de spec qu'une story
écrit sans qu'aucun bloc la porte échappe elle aussi à la clôture. Elle est restée
hors de ce lot après examen : la nommer suppose d'amender deux phrases de `Batch`
qui sont des totalités — « le spec delta est **le texte exact que ce lot écrit dans
les specs** » et « la revue d'ouverture […] **c'est là que l'humain lit ce que diront
les specs** ». Sans cet amendement, le flux comporterait une catégorie de texte de
spec qui échappe aux deux phrases, lesquelles resteraient écrites. Ces deux sections
sont tenues par le lot conçu en parallèle sur la relecture de cohérence du spec
delta, à qui le sujet est signalé.

**Pourquoi maintenant.** Les deux sujets ont été constatés le même jour, à la clôture
du lot 06, et par elle : le premier parce que deux arbitrages ont dû être sauvés à la
main, le second parce que la clôture s'est faite hors précondition.

## Spec delta

Module `supercharlouze`, une seule spec : `docs/specs/supercharlouze.md`.

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
> **Arbitrage ouvert** (`open ruling`) — un arbitrage dont la décision est de parquer
> un constat ou de le remonter à l'humain, et qui laisse donc quelque chose à trancher
> après la fusion.

### D3 — `Story > Delivering a story`

Passage actuel :

> 6. **Avant la fusion**, recopier les arbitrages de l'exécution dans le Rulings log,
>    consigner sous **Observed drift** les dérives constatées hors périmètre, et
>    pousser les deux sur la branche.

Texte qui le remplace :

> 6. **Avant la fusion**, recopier les arbitrages de l'exécution dans le Rulings log,
>    en nommant pour chaque arbitrage ouvert ce qui reste à trancher, consigner sous
>    **Observed drift** les dérives constatées hors périmètre, et pousser les deux
>    sur la branche.

### D4 — `Batch > Closing a batch`

Texte inséré après le paragraphe « **Trois sorties, pas une impasse.** … », donc
avant « **La pull request de clôture porte :** » :

> **Un lot ne peut pas être clos tant qu'un arbitrage ouvert n'a pas reçu sa
> destination.** Celui qui est une violation ou un gap rejoint la consolidation dans
> le gaps register. Pour tout autre, l'humain la donne et la pull request de clôture
> la nomme.

### D5 — `Batch > Closing a batch`

Passage actuel, deuxième puce de la liste « **La pull request de clôture
porte :** » :

> - **la consolidation dans le gaps register** des sections `Observed drift` des
>   stories du lot ;

Texte qui le remplace :

> - **la consolidation dans le gaps register** des sections `Observed drift` des
>   stories du lot, et des arbitrages ouverts qui l'ont rejointe ;

## Constraints

- **Ordre requis.** D2 à D5 sont transcrits **dans la même story** : D3, D4 et D5
  emploient le terme que D2 pose au glossaire, et D4 et D5 visent la même section.
  Livré par tranches, chaque bloc nommerait quelque chose que la spec ne définit pas
  encore. D1 n'impose aucun ordre.
- **Une dérive constatée en concevant ce lot part en `Observed drift`**, et la
  clôture la versera au gaps register. La spec énonce deux totalités — « le spec
  delta est **le texte exact que ce lot écrit dans les specs**, en blocs » et « la
  revue d'ouverture […] **c'est là que l'humain lit ce que diront les specs** » —
  que ses propres règles contredisent : l'étape 3 de `Delivering a story` fait
  écrire la mention d'un flag par la story sans qu'aucun bloc la porte, la story de
  démontage retire de la spec ce que le lot y avait ajouté avec `Blocks: none`, et
  la levée d'un flag à portée de lot n'exige pas davantage de bloc. Le code fait ce
  que ces règles disent ; ce sont les deux totalités qui ont tort. Constat
  antérieur à ce lot, hors de son périmètre, et à ne pas résorber ici.

- **`Module > The gaps register` est hors périmètre, et le lot le sait.** La phrase
  qui énumère les sources d'une entrée — « une story, dans le code qu'elle
  traverse » — ne nomme pas l'arbitrage ouvert que D4 envoie à la consolidation.
  Elle est donc incomplète après ce lot, sans être fausse : l'énumération des
  **écrivains** reste exacte, et seule la description de ce que la clôture consolide
  reste partielle, comme elle l'est déjà pour les blocs non livrés. La section est
  tenue par la story `05-us-3-une-entree-se-lit-seule`. Ce constat part en
  `Observed drift`, et la clôture de ce lot le versera au gaps register.

## Feature flag

Feature flag: none — chaque story est complète dans sa propre pull request

Une story de ce lot, fusionnée seule, ne laisse personne devant quelque chose
d'incomplet. D1 livrée seule est une règle qui vaut dès qu'elle est lue. D2 à D5
voyagent ensemble par la contrainte d'ordre ci-dessus, qui interdit qu'un terme soit
employé avant d'être posé.
