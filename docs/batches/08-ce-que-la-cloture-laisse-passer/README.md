---
status: open
---

# 08 — Ce que la clôture a laissé passer

## Scope

**La clôture ne lit d'une story que son champ `Blocks:` et sa section
`Observed drift`.** Une story laisse plus que ça, et trois objets le démontrent.

**Un arbitrage resté ouvert.** Un `Ruling:` qui parque un constat ou remonte une
question à l'humain n'est lu qu'au gate de livraison ; si l'humain fusionne sans
agir, il meurt avec la clôture — et rien ne signale sa disparition, puisque ce qui
disparaît ne laisse pas de trace. La story `06-us-1-le-code-garde` en portait deux,
versés au gaps register sur décision explicite de l'humain, parce qu'aucun devoir
ne les ramassait.

**Une écriture de spec hors de tout bloc.** Le gel du fichier de spec se lève à
l'ouverture de la pull request, « y compris sur la formulation de sa modification
de spec » : une modification demandée en revue est donc déjà légitime, et elle
n'appartient à aucun bloc. La clôture ne la voit nulle part — ni au constat des
blocs non livrés, puisqu'elle n'est dans le `Blocks:` d'aucune story, ni à la ligne
de changelog, qui n'a aucune source pour elle. Précédent : la story
`04-us-2-la-transcription`, dont un arbitrage a dû écrire « à reprendre dans la
ligne de changelog du lot » dans un document que la clôture ne lit pas.

Deux conséquences suivent, et ce lot les prend. Une écriture hors bloc peut toucher
une section que le champ `Sections:` de la story ne déclare pas ; or c'est ce champ
que lit la détection de concurrence, et un lot voisin scanne alors une déclaration
périmée tant que la pull request reste ouverte. Et rien ne sépare aujourd'hui une
écriture hors bloc d'un amendement du lot, alors que les deux chemins se ressemblent
assez pour qu'un agent prenne le plus court.

**Ce qu'`Observed drift` ne couvre pas**, par construction : la section est définie
pour les divergences entre spec et code, et les deux objets ci-dessus n'en sont
pas.

Trois mécanismes pour un même trou serait la mauvaise réponse. Ce lot en pose un
seul : **la queue du document de story est ce qu'elle laisse à la clôture**, et la
clôture la draine entière. Ce qui n'a pas de destination l'arrête, comme l'arrête
déjà un flag qui survit sans portée déclarée — une mention dans un corps de pull
request se lit ou ne se lit pas, un refus non.

**Une branche du flux exige un répertoire qu'une session sur deux ne peut pas
avoir.** Les skills posent, pour chaque pull request de ce flux, la précondition
d'être dans le checkout principal. Une session lancée dans un worktree y est isolée
par le harnais, qui refuse toute commande git visant le checkout partagé : la
précondition est alors inatteignable, et la clôture du lot 06 a dû être conduite
hors de la voie décrite. Ce que cette précondition protège — qu'une clôture
n'atterrisse pas sur la branche de la dernière story — tient au point de départ de
la branche, que la spec énonce déjà.

**Pourquoi maintenant.** Les deux sujets ont été constatés le même jour, à la
clôture du lot 06, et par elle : le premier parce que deux arbitrages ont dû être
sauvés à la main, le second parce que la clôture s'est faite hors précondition. Le
troisième objet est venu du lot conçu en parallèle sur la relecture de cohérence du
spec delta, et c'est lui qui a montré que les trois n'en font qu'un. **Ce lot
n'attend rien de lui** : l'enregistrement d'une écriture hors bloc a de la matière
dès sa fusion, puisque le geste est déjà légitime en revue ; l'autorisation que
l'autre lot prépare vit dans `Story > Delivering a story`, que ce lot ne touche
pas.

## Spec delta

Module `supercharlouze`, une seule spec : `docs/specs/supercharlouze.md`.

### D1 — `Authority and conflict rules`

Passage actuel :

> **Toute branche du flux part d'un `main` à jour**, jamais d'une autre branche, et
> **porte le nom que son étape lui assigne** avant que le travail commence, y compris
> quand l'outil qui l'a créée en a choisi un autre ou a laissé un HEAD détaché : le
> nom est alors rétabli. Une branche nommée autrement ne suffit pas.

Texte qui le remplace :

> **Toute branche du flux part d'`origin/main` fraîchement rafraîchi**, jamais d'une
> autre branche, et **porte le nom que son étape lui assigne** avant que le travail
> commence, y compris quand l'outil qui l'a créée en a choisi un autre ou a laissé
> un HEAD détaché : le nom est alors rétabli. Une branche nommée autrement ne suffit
> pas. **Aucune étape n'exige d'être conduite depuis un répertoire de travail
> particulier** : le point de départ de la branche est ce qui la sépare du travail
> précédent.

### D2 — `Story > The user story document`

Passage actuel :

> Le document porte en outre un **Rulings log** et une section **Observed drift**,
> remplis avant la fusion. Les deux sont **créées vides au moment du plan**, en même
> temps que l'en-tête, et laissées vides si rien n'est venu : une section vide
> signifie « examiné, rien trouvé ».

Texte qui le remplace :

> Le document porte en outre trois sections — **Rulings log**, **Observed drift** et
> **Off-block spec changes** —, qui sont **ce qu'une story laisse à la clôture**.
> Elles sont **créées vides au moment du plan**, en même temps que l'en-tête,
> remplies avant la fusion, et laissées vides si rien n'est venu : une section vide
> signifie « examiné, rien trouvé ».
>
> **Off-block spec changes** porte ce que la story a écrit dans la spec hors de tout
> bloc. Une telle écriture **ne change pas ce que le lot promet** : ce qui le change
> passe par un amendement, sinon la story suivante transcrirait son bloc par-dessus.
>
> Un arbitrage **laisse quelque chose** quand il parque un constat ou remonte une
> question à l'humain, et le `Rulings log` le dit en nommant ce qui reste à
> trancher. Les autres sont des décisions prises et appliquées, que la fusion
> referme.

### D3 — `Batch > Closing a batch`

Texte inséré après le paragraphe « **Trois sorties, pas une impasse.** … », donc
avant « **La pull request de clôture porte :** » :

> **Un lot ne peut pas être clos tant qu'un arbitrage resté ouvert n'a pas reçu sa
> destination.** Un arbitrage qui est une violation ou un gap en a une : le gaps
> register. Pour tout autre, l'humain la donne et la pull request de clôture la
> nomme ; elle peut être hors de ce modèle.

### D4 — `Batch > Closing a batch`

Passage actuel, deuxième puce de la liste « **La pull request de clôture
porte :** » :

> - **la consolidation dans le gaps register** des sections `Observed drift` des
>   stories du lot ;

Texte qui le remplace :

> - **la reprise des trois sections que chaque story lui laisse** : les
>   `Observed drift` consolidées dans le gaps register, les arbitrages restés
>   ouverts à leur destination, et les écritures de spec hors bloc portées par la
>   ligne de changelog ;

### D5 — `Story > The user story document`

Passage actuel :

> `Sections:` déclare les sections que la story touche, et c'est ce que lit la
> détection de concurrence. Il est déclaré par l'auteur de la story, jamais déduit
> d'un diff.

Texte qui le remplace :

> `Sections:` déclare les sections que la story touche, et c'est ce que lit la
> détection de concurrence. Il est déclaré par l'auteur de la story, jamais déduit
> d'un diff, et **une écriture hors bloc qui touche une section qu'il ne déclare pas
> l'y ajoute**.

## Constraints

- **Ordre requis.** D2, D3, D4 et D5 sont transcrits **dans la même story**. D3 et
  D4 visent la même section et nomment tous deux ce que seul D2 définit — « les
  trois sections » et « un arbitrage resté ouvert » ; D5 vise la même section que
  D2 et nomme l'écriture hors bloc que D2 définit. D1 n'impose aucun ordre.
- **Ce lot applique déjà ce qu'il introduit.** Ses stories portent les trois
  sections dès la première, et nomment dans leur `Off-block spec changes` toute
  écriture de spec faite hors bloc, même là où les skills publiées n'en demandent
  encore que deux. Leurs propres clôtures n'auront alors rien à rattraper.

## Feature flag

Feature flag: none — chaque story est complète dans sa propre pull request

Une story de ce lot, fusionnée seule, ne laisse personne devant quelque chose
d'incomplet. D1 livrée seule est une règle qui vaut dès qu'elle est lue. D2, D3, D4
et D5 voyagent ensemble par la contrainte d'ordre ci-dessus, qui interdit qu'une
section soit nommée avant d'être définie ou drainée avant d'exister.
