---
status: open
---

# 07 — La relecture de cohérence

## Scope

Ce lot fait **relire le spec delta d'un lot contre la totalité de chaque spec
qu'il touche**, sur l'état que ses blocs produiront, avant que sa pull request
d'ouverture s'ouvre.

La revue d'ouverture lit des blocs. Elle les lit bien : depuis le lot 04, chacun
porte le texte exact que sa section recevra, et l'humain le voit avant qu'aucun
code ne se construise dessus. Mais un bloc peut être juste pris isolément et
rendre faux un passage qu'aucun bloc ne vise — et rien ne regarde ce passage. Ni
la revue d'ouverture, qui lit les blocs. Ni les revues de tâche, qui ne voient
qu'une tranche. Ni les gardes structurelles, vertes sur un fichier qui porte les
deux formulations.

Le lot livre une seule chose, à un seul moment : **une relecture définie, conduite
à l'ouverture**. Elle lit l'état que les blocs produiront, et non les blocs pris
un à un. Elle n'est jamais conduite dans le contexte qui les a écrits — celui-là
en relirait les intentions plutôt que le texte. Elle pose trois questions : ce que
les blocs rendent faux ailleurs, ce qu'ils omettent, et ce qu'une spec doit tenir.
Et le corps de la pull request d'ouverture déclare tout cela — l'indépendance et
les trouvailles —, sans quoi rien de la relecture ne serait observable et sa règle
n'en serait pas une.

**La relecture ne prescrit pas la suite de ses trouvailles**, et c'est une
décision de ce lot. La spec route déjà les trouvailles par type : un mécanisme
part au gaps register (`The spec document`), une règle qui déborde un module
déclenche un arrêt humain (`Module`), et le texte des blocs est lu par la revue
d'ouverture de toute façon. Toute phrase résumant ces routes en une seule les
écrase, et trois tours de relecture successifs l'ont démontré sur ce lot avant
que sa suppression rende un tour sans bloquant. La relecture est une lecture ;
ses suites appartiennent aux règles qu'elle met en cause.

**Pourquoi maintenant.** Parce que la pratique existe, qu'elle a fait ses preuves,
et que rien ne la porte. Au lot 06, elle a été conduite à la demande de
l'utilisateur, sur une copie de la spec où les blocs étaient déjà appliqués : elle
y a trouvé le défaut le plus grave du lot — une condition accrochée au lot alors
que le flag est par couple (lot, module) — que ni l'agent ni l'humain n'avaient
vu, plus cinq défauts de formulation et deux conséquences non tirées, devenues
deux blocs de plus. Au lot 04, où elle n'a pas été conduite, elle aurait attrapé
deux défauts qui sont passés : deux passages devenus faux ailleurs, trouvés à la
revue finale de 04-us-2 — donc tard, et l'un corrigé hors de tout bloc —, et un
bloc qui énumérait les moments où vider le contexte en oubliant la clôture. Une
pratique qui ne tient qu'au fait que quelqu'un pense à la demander n'est pas une
règle, et c'est exactement ce que ce flux transforme en règle partout ailleurs.

**Pourquoi à l'ouverture seulement.** Les trois cas ci-dessus sont tous visibles
sur l'état final du delta, donc tous attrapés à l'ouverture ; aucun n'aurait
demandé une relecture ailleurs. Ce lot ne spécifie donc que ce que ces incidents
ont démontré, et sa propre relecture a écarté tout le reste : une relecture au
moment où une story transcrit, une relecture de l'amendement, et l'extension de la
règle à tout ce qui écrit dans une spec. Chacune de ces trois pistes a produit des
contradictions avec des règles existantes, et aucune n'avait d'incident derrière
elle.

Le lot 04 en était la condition. Un spec delta énoncé comme intention ne s'applique
pas à une spec : il n'y a rien à simuler, donc rien à relire. Le texte exact est ce
qui rend cette lecture faisable, et le lot 04 vient de le livrer.

Le lot répond enfin à un décalage plus ancien : les retours de l'humain sur une
modification de spec arrivaient quand l'agent était déjà passé au plan ou au code.
La réponse est **en amont** et non en aval — le texte que l'humain lit au gate
d'ouverture a déjà été relu, et rien ne s'appuie encore dessus.

### Ce que le lot livre dans les skills

Les blocs écrivent la norme ; `writing-a-batch` reçoit la conduite, qui est du
mécanisme et n'entre dans aucune spec. Quatre choses, et elles sont du périmètre
de livraison de ce lot :

- **La lecture du modèle**, conduite avec `domain-driven-design` quand la skill
  est disponible — langue ubiquitaire, frontières, place d'un concept dans le
  modèle. Elle ne correspond à aucune des trois questions et les nourrit toutes
  les trois. **L'invocation est conditionnelle** : le plugin recommande la skill
  et n'en dépend nulle part, donc son absence ne bloque rien.
- **Les lecteurs rendent tous avant que rien ne remonte.** L'agent qui conduit la
  relecture attend la fin de **tous** les lecteurs, rassemble leurs constats, puis
  les soumet à l'humain — jamais un rapport au fil de l'eau. Un rapport partiel
  fait instruire des constats que le lecteur suivant déplace, et fait rendre deux
  fois le même arbitrage.
- **La distinction entre les deux relectures.** La relecture avant ouverture
  porte sur le document de lot entier — scope, contraintes, champ flag, passages
  cités. La relecture de cohérence ne porte que sur les blocs et l'état qu'ils
  produiront. Les confondre ferait disparaître la première, et un lot correctif,
  sans blocs, n'aurait plus aucune relecture.
- **Quatre conditions d'arrêt**, sans lesquelles les tours s'enchaînent
  indéfiniment :
  1. **On ne relance que sur du texte que la relecture n'a pas lu.** Une révision
     qui retranche ne rouvre rien, une révision qui ajoute une phrase si — et
     **déplacer une phrase est une addition**, sa portée changeant avec son
     emplacement.
  2. **Deux tours qui butent sur la même clause ferment la question de sa
     formulation.** Il faut alors retirer la clause ou la soumettre à l'humain.
  3. **Un tour qui ne rend que des trouvailles déjà instruites et déclinées est
     un tour de trop.** Ce qui reste est un désaccord de jugement, et un jugement
     se tranche au gate.
  4. **La relecture prépare le gate, elle ne le remplace pas.**

Ces quatre conditions sont tirées de la relecture de ce lot, et la deuxième de
son échec : une même clause y a été réécrite trois fois avant d'être supprimée,
ce que la condition interdit désormais.

### Ce que le lot ne couvre pas

**La mention d'un flag.** Lisant les blocs seuls, la relecture ne la voit pas :
aujourd'hui une story l'écrit dans une spec sans qu'aucun bloc la porte, et la
retire de même quand le flag est à portée de lot. La décision est prise — **la
gestion des mentions de flag doit passer systématiquement par des blocs du spec
delta**, comme tout autre texte qu'un lot met dans une spec — et ce lot ne la
livre pas. C'est un changement de modèle, sur quatre sections qu'il ne déclare
pas : `Batch > The batch document`, `Feature flags`, `Lifting a feature flag` et
`Story > Delivering a story`. Il laisse trois questions à trancher : qu'un bloc
puisse citer ce qu'un bloc du même delta insère, alors qu'un bloc cite `main` tel
qu'il est ; ce que devient le champ `Feature flag`, qui porterait alors la même
information que la mention ; et le sort de la clause de `Delivering a story` qui
fait porter la mention à la modification de spec, que la transcription mot pour
mot rendrait redondante.

Ce que cette règle fermerait : **rien ne vérifie aujourd'hui qu'une mention
déclarée a bien été écrite.** La clôture ne contrôle que la *survie* d'un flag —
« encore présent — dans le code ou par sa mention dans une spec ». Une story qui
omet la mention laisse le bras « dans le code » tenir seul, puis la story de
levée retire le branchement : les deux bras tombent ensemble, le contrôle passe
en silence, et la spec de `main` aura décrit comme acquis, pendant toute la vie
du flag, un comportement qui était gardé. Portée par un bloc, la mention
entrerait dans le champ `Blocks:` des stories, donc dans le constat des blocs non
livrés.

**L'écriture de spec hors de tout bloc**, dont la mention d'un flag n'est qu'un
cas, et que la clôture ne voit pas davantage. Le lot 08 l'a examinée et laissée
dehors, parce que la nommer suppose d'amender d'abord les deux totalités de
`Batch` ; son document renvoie ces deux sections au présent lot. Celui-ci les
décline à son tour : les deux blocs qui les bornaient ont été renvoyés à sa revue
d'ouverture, et la décision ci-dessus les rendra vraies plutôt que bornées. Ce
lot ne garde donc que `Batch` et `Batch > Opening a batch`, pour ce que la
relecture y écrit ; `Batch > The batch document` n'est tenue par personne.

**Sans preneur, et tous relevés par la relecture de ce lot** : l'amendement qui
ajoute, réécrit ou retire des blocs, qu'aucune revue nommée ne lit — la table des
revues donne à la revue d'amendement pour objet « la décision de changer le
périmètre ou le flag » ; les blocs réécrits en réponse à la revue d'ouverture,
qui ne repassent par aucune relecture ; l'adoption, qui écrit une spec entière et
n'a que sa revue ; le changement borné, qui écrit dans une spec sans qu'aucune
revue d'ouverture ait lu son texte ; la story de démontage et la story de levée
d'un flag à portée de lot, qui retirent du texte de spec sans bloc ; et la ligne
de changelog d'une clôture.

**Et le nombre de lecteurs que la relecture emploie**, qui est du mécanisme et
que ce lot ne fixe nulle part.

## Spec delta

Module `supercharlouze`, une seule spec : `docs/specs/supercharlouze.md`.

### D1 — `docs/specs/supercharlouze.md`, section `Batch`

Insérer une sous-section entière, après la section `### The batch document` et
avant `### Opening a batch` :

```markdown
### The coherence reread

La relecture de cohérence lit les blocs d'un spec delta contre la totalité de
chaque spec qu'ils touchent, sur l'état qu'ils produiront et sans qu'aucun soit
écrit dans une spec.

**Elle pose trois questions à chaque spec touchée :**

- **Qu'est-ce que les blocs rendent faux ailleurs ?** Un passage qu'aucun d'eux
  ne vise et qu'ils contredisent.
- **Qu'est-ce qu'ils omettent ?** Un cas devant lequel ils passent, une
  conséquence qu'ils ne tirent pas.
- **Tiennent-ils ce qu'une spec doit tenir ?** (`The spec document`)

**Elle n'est jamais conduite dans le contexte qui a écrit les blocs**, et le
corps de la pull request d'ouverture le déclare, avec ce qu'elle a trouvé ou
qu'elle n'a rien trouvé.
```

### D2 — `docs/specs/supercharlouze.md`, section `Batch > Opening a batch`

Remplacer :

```markdown
5. Ouvre la pull request du lot, sur la branche `batch/NN-<slug>`.
```

par :

```markdown
5. **Fait passer le spec delta entier par la relecture de cohérence**
   (`The coherence reread`).
6. Ouvre la pull request du lot, sur la branche `batch/NN-<slug>`.
```

## Constraints

- **Ordre requis.** D1 est transcrit **au plus tard dans la même story** que D2,
  qui le nomme.
- **Chaque norme ajoutée repart avec une garde structurelle** dans `tests/`, dans
  la même pull request qu'elle.
- **`tests/run-all.sh` est vert avant l'ouverture de toute pull request.**

## Feature flag

Feature flag: none — chaque story est complète dans sa propre pull request

Une story de ce lot, fusionnée seule, ne laisse personne devant quelque chose
d'incomplet : une norme vaut dès qu'elle est lue, et les blocs entrent dans des
sections que personne d'autre ne tient.
