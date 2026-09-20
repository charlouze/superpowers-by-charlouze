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

**Ce qu'`Observed drift` ne couvre pas**, par construction : la section est définie
pour les divergences entre spec et code, et les deux objets ci-dessus n'en sont
pas.

Trois mécanismes pour un même trou serait la mauvaise réponse. Ce lot en pose un
seul : **la queue du document de story est ce qu'elle laisse à la clôture**, et la
clôture la draine entière. Ce qui n'a pas de destination l'arrête, comme l'arrête
déjà un flag qui survit sans portée déclarée — une mention dans un corps de pull
request se lit ou ne se lit pas, un refus non.

**Deux choses écrivent dans cette queue, et aucune ne sait le faire aujourd'hui.**
La forme d'un arbitrage vient de superpowers —
`Ruling: <décision> — <pourquoi> — <ce que ça coûte si c'est faux>` — et les deux
règles qui alimentent le `Rulings log` disent **recopier** : une recopie ne peut pas
produire une information que la forme ne porte pas. Et l'étape qui remplit ces
sections avant la fusion en énumère **deux**, alors qu'il y en aura trois. Ce lot
répare les deux, sans quoi son propre contrôle de clôture lirait une distinction
qu'aucun chemin n'écrit.

**Une écriture hors bloc déborde de la déclaration qui la protège.** Elle peut
toucher une section que le champ `Sections:` ne déclare pas ; or c'est ce champ que
lit la détection de concurrence, et un lot voisin scanne alors une déclaration
périmée tant que la pull request reste ouverte. Étendre la déclaration ne suffit
pas : la détection n'a qu'une issue écrite, l'arrêt, et elle est inapplicable à une
story dont le travail est déjà fait. Les deux cas sont réellement distincts, et la
section qui porte la détection doit les distinguer.

**Ce lot ne dit pas ce qui sépare une écriture hors bloc d'un amendement.** Il
l'enregistre et la draine ; la frontière vit dans `Amending a batch`, que ce lot ne
touche pas.

**Une branche du flux exige un répertoire qu'une session sur deux ne peut pas
avoir.** Les skills posent, pour chaque pull request de ce flux, la précondition
d'être dans le checkout principal. Une session lancée dans un worktree y est isolée
par le harnais, qui refuse toute commande git visant le checkout partagé : la
précondition est alors inatteignable, et la clôture du lot 06 a dû être conduite
hors de la voie décrite. Ce que cette précondition protège — qu'une clôture
n'atterrisse pas sur la branche de la dernière story — tient au point de départ de
la branche, et il suffit de dire lequel : `main` telle que le remote la porte. Le
répertoire disparaît alors de lui-même, sans qu'on ait à écrire qu'il ne compte pas.

**Pourquoi maintenant.** Les deux sujets ont été constatés le même jour, à la
clôture du lot 06, et par elle : le premier parce que deux arbitrages ont dû être
sauvés à la main, le second parce que la clôture s'est faite hors précondition. Le
troisième objet est venu du lot conçu en parallèle sur la relecture de cohérence du
spec delta, et c'est lui qui a montré que les trois n'en font qu'un. **Ce lot
n'attend rien de lui** : l'enregistrement d'une écriture hors bloc a de la matière
dès sa fusion, puisque le geste est déjà légitime en revue.

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

> **Bloc** (`delta block`) — l'unité du spec delta d'un lot : une section visée et
> le texte exact qu'elle doit recevoir, transcrit mot pour mot par une story.

Texte qui le remplace :

> **Bloc** (`delta block`) — l'unité du spec delta d'un lot : une section visée et
> le texte exact qu'elle doit recevoir, transcrit mot pour mot par une story.
>
> **Écriture hors bloc** (`off-block spec change`) — une modification de spec qu'une
> story écrit sans qu'aucun bloc la porte.

### D3 — `The model`

Passage actuel :

> **Arbitrage** (`ruling`) — une décision prise par un agent sans l'humain, consignée
> pour lui.

Texte qui le remplace :

> **Arbitrage** (`ruling`) — une décision prise par un agent sans l'humain, consignée
> pour lui.
>
> **Arbitrage ouvert** (`open ruling`) — un arbitrage qui parque un constat ou remonte
> une question, et laisse donc quelque chose à trancher après la fusion.

### D4 — `Story > The user story document`

Passage actuel :

> Le document porte en outre un **Rulings log** et une section **Observed drift**,
> remplis avant la fusion. Les deux sont **créées vides au moment du plan**, en même
> temps que l'en-tête, et laissées vides si rien n'est venu : une section vide
> signifie « examiné, rien trouvé ».

Texte qui le remplace :

> Le document porte en outre les sections **Rulings log**, **Observed drift** et
> **Off-block spec changes**, **créées vides au moment du plan**, en même temps que
> l'en-tête, remplies avant la fusion, et laissées vides si rien n'est venu : une
> section vide signifie « examiné, rien trouvé ».
>
> `Off-block spec changes` porte les écritures hors bloc de la story.

### D5 — `Story > The user story document`

Passage actuel :

> `Sections:` déclare les sections que la story touche, et c'est ce que lit la
> détection de concurrence. Il est déclaré par l'auteur de la story, jamais déduit
> d'un diff.

Texte qui le remplace :

> `Sections:` déclare les sections que la story touche, et c'est ce que lit la
> détection de concurrence. Il est déclaré par l'auteur de la story, jamais déduit
> d'un diff, et **l'auteur l'étend à toute section qu'une écriture hors bloc a
> touchée**.

### D6 — `Story > Concurrency detection`

Passage actuel :

> **Il faut s'arrêter** si l'intersection avec les sections visées n'est pas vide, et
> **s'arrêter aussi si un champ `Sections:` n'a pas pu être lu** — lecture en échec,
> document absent, champ manquant. Une branche poussée dont le document de story
> n'existe pas encore arrête pareillement.

Texte qui le remplace :

> **Une story qui démarre s'arrête** si l'intersection avec les sections qu'elle vise
> n'est pas vide, et **s'arrête aussi si un champ `Sections:` n'a pas pu être lu** —
> lecture en échec, document absent, champ manquant. Une branche poussée dont le
> document de story n'existe pas encore arrête pareillement.
>
> **Une story déjà en vol ne s'arrête pas** : quand une écriture hors bloc étend son
> `Sections:`, la détection est refaite sur la section ajoutée, et le conflit qu'elle
> trouve se tranche à la revue de livraison. Son travail est fait ; il n'y a plus rien
> à ne pas commencer.

### D7 — `Story > Delivering a story`

Passage actuel :

> 6. **Avant la fusion**, recopier les arbitrages de l'exécution dans le Rulings log,
>    consigner sous **Observed drift** les dérives constatées hors périmètre, et
>    pousser les deux sur la branche.

Texte qui le remplace :

> 6. **Avant la fusion**, recopier les arbitrages de l'exécution dans le Rulings log,
>    en nommant pour chaque arbitrage ouvert ce qui reste à trancher, consigner sous
>    **Observed drift** les dérives constatées hors périmètre, et pousser les deux
>    sur la branche.

### D8 — `Batch > Closing a batch`

Texte inséré après le paragraphe « **Trois sorties, pas une impasse.** … », donc
avant « **La pull request de clôture porte :** » :

> **Un lot ne peut pas être clos tant qu'un arbitrage ouvert n'a pas reçu sa
> destination.** Celui qui est une violation ou un gap rejoint la consolidation dans
> le gaps register. Pour tout autre, l'humain la donne et la pull request de clôture
> la nomme.

### D9 — `Batch > Closing a batch`

Passage actuel, deuxième puce de la liste « **La pull request de clôture
porte :** » :

> - **la consolidation dans le gaps register** des sections `Observed drift` des
>   stories du lot ;

Texte qui le remplace :

> - **la consolidation dans le gaps register** des sections `Observed drift` des
>   stories du lot, et des arbitrages ouverts qui l'ont rejointe ;
> - **la reprise de leurs écritures hors bloc** dans la ligne de changelog ;

### D10 — `Bounded change`

Passage actuel :

> - **(b) Il subit la même détection de concurrence qu'une story**, et déclare donc
>   ses sections **dans le corps de sa pull request**. Son angle mort est accepté :
>   entre son premier commit et l'ouverture de sa pull request, rien ne porte sa
>   déclaration.

Texte qui le remplace :

> - **(b) Il subit la même détection de concurrence qu'une story**, et déclare donc
>   ses sections **dans le corps de sa pull request**, qu'il étend comme une story
>   étend le sien. Son angle mort est accepté : entre son premier commit et
>   l'ouverture de sa pull request, rien ne porte sa déclaration.

## Constraints

- **Ordre requis.** D2 à D9 sont transcrits **dans la même story**. Les blocs se
  citent les uns les autres de bout en bout : D4 à D9 emploient les deux termes que
  D2 et D3 posent au glossaire, D6 règle le sort d'une écriture hors bloc que D4
  définit, et D8 et D9 drainent ce que D4 fait porter au document. Livré par
  tranches, chaque bloc nommerait quelque chose que la spec ne définit pas encore.
  D10 vient après, D1 n'impose aucun ordre.
- **Ce lot applique déjà ce qu'il introduit.** Ses stories portent les trois
  sections dès la première, et nomment dans leur `Off-block spec changes` toute
  écriture de spec faite hors bloc, même là où les skills publiées n'en demandent
  encore que deux. Leurs propres clôtures n'auront alors rien à rattraper.
- **`Module > The gaps register` est hors périmètre, et le lot le sait.** La phrase
  qui énumère les sources d'une entrée — « une story, dans le code qu'elle
  traverse » — ne nomme pas l'arbitrage ouvert que D8 envoie à la consolidation.
  Elle est donc incomplète après ce lot, sans être fausse : l'énumération des
  **écrivains** reste exacte, et seule la description de ce que la clôture consolide
  reste partielle, comme elle l'est déjà pour les blocs non livrés. La section est
  tenue par la story `05-us-3-une-entree-se-lit-seule`. Ce constat part en
  `Observed drift`, et la clôture de ce lot le versera au gaps register.

## Feature flag

Feature flag: none — chaque story est complète dans sa propre pull request

Une story de ce lot, fusionnée seule, ne laisse personne devant quelque chose
d'incomplet. D1 livrée seule est une règle qui vaut dès qu'elle est lue, D10 aussi.
D2 à D9 voyagent ensemble par la contrainte d'ordre ci-dessus, qui interdit qu'un
terme soit employé avant d'être posé, qu'une section soit remplie avant d'exister,
ou drainée avant d'être remplie.
