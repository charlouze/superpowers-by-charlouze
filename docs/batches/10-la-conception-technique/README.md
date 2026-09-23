---
status: open
---

# 10 — La conception technique

## Scope

Une conception architecturale décide de la technique autant que du besoin : l'étape
de conception du brainstorming couvre déjà l'architecture, les composants, les flux
de données, la gestion d'erreurs et les tests. Mais le document de lot, qui remplace
le document de conception, n'a nulle part où l'écrire. Ses champs sont `Scope`,
`Spec delta`, `Constraints` et `Feature flag`, le `Spec delta` n'a pas le droit de
porter du mécanisme, et seul `Constraints` atteint les stories. Ce que la conception
décide de la technique se perd donc à l'ouverture, et chaque story le refait en
écrivant son plan. Chez superpowers, la technique arrive jusqu'au plan par le
document de conception, que le plan cite comme sa spec ; ici ce chemin est coupé,
puisque le plan cite la spec vivante du module, qui ne porte que le métier.

Ce lot rouvre ce chemin sans rien ajouter au brainstorming :

- **le document de lot gagne un champ `Technical design`**, qui reçoit la conception
  technique approuvée. C'est un point de départ : le plan d'une story en part, et
  peut s'en écarter ;
- **`Constraints` s'élargit** aux décisions techniques que toute story doit tenir —
  celles dont une story ne peut pas s'écarter sans en casser une autre. C'est le
  seul endroit où une décision technique lie ;
- **une relecture technique** juge la conception avant l'ouverture, hors du contexte
  qui l'a faite : ce qu'elle réalise des blocs, sa tenue face au code existant, son
  architecture, la conception de ses modules, sa robustesse ;
- **une story qui s'écarte de la conception le consigne** sous une forme d'arbitrage
  qui lui est propre, et là où le code de `main` s'est écarté de la conception,
  c'est le code qui fait foi ;
- **une contrainte fausse arrête la story** et remonte à l'humain, qui fait amender
  le lot s'il la juge fausse : ce qui lie ne se quitte pas par un arbitrage ;
- **la clôture réécrit `Technical design`** d'après les écarts des stories
  fusionnées, pour que le document de lot clos se lise comme la conception livrée.

Pourquoi maintenant : le défaut coûte à chaque story de chaque projet qui adopte le
plugin, et c'est le seul contenu de superpowers que l'override 1 perd en remplaçant
le document de conception.

## Spec delta

Tous les blocs visent `docs/specs/supercharlouze.md`.

### D1 — `The model`

Insérer, après l'entrée **Story technique** :

```markdown
**Conception technique** (`technical design`) — ce qu'une conception
architecturale décide de la technique des stories d'un lot sans les y lier. C'est
un point de départ pour leurs plans ; une décision technique qui les lie est une
contrainte du lot.
```

### D2 — `Authority and conflict rules`

Passage actuel :

```markdown
**La spec est l'autorité contraignante de toute revue et de toute relecture.** Le
lot ne porte que ce qu'une spec ne peut pas porter : le périmètre de livraison,
l'ordre des stories, les contraintes de migration et de compatibilité, et la raison
pour laquelle ce travail a lieu maintenant.
```

Remplacé par :

```markdown
**La spec est l'autorité contraignante de toute revue et de toute relecture.** Le
lot ne porte que ce qu'une spec ne peut pas porter : le périmètre de livraison,
l'ordre des stories, les contraintes de migration et de compatibilité, les
décisions techniques que toute story doit tenir, la conception technique de ses
stories, et la raison pour laquelle ce travail a lieu maintenant. Là où le code de
`main` s'est écarté de la conception technique d'un lot, c'est le code qui fait
foi.
```

### D3 — `Batch > The batch document`

Insérer, entre la puce **Spec delta** et la puce **Constraints** :

```markdown
- **Technical design** — la conception technique des stories du lot. C'est un
  point de départ, que le plan d'une story peut quitter. **Ce champ n'est jamais
  laissé blanc** : il porte la conception technique, ou `none` suivi de la raison.
```

### D4 — `Batch > The batch document`

Passage actuel :

```markdown
- **Constraints** — les contraintes de migration et de compatibilité, et l'ordre
  requis des stories ; `none` s'il n'y en a pas. **Rien de normatif n'y figure** :
```

Remplacé par :

```markdown
- **Constraints** — les contraintes de migration et de compatibilité, les
  décisions techniques que toute story doit tenir, et l'ordre requis des stories ;
  `none` s'il n'y en a pas. Une décision technique n'y entre que si une story ne
  peut pas s'en écarter sans en casser une autre ; toute autre reste dans
  `Technical design`. **Rien de normatif n'y figure** :
```

### D5 — `Batch > Opening a batch`

Passage actuel :

```markdown
3. Rédige le document de lot : `Scope`, `Spec delta`, `Constraints`,
   `Feature flag`.
```

Remplacé par :

```markdown
3. Rédige le document de lot : `Scope`, `Spec delta`, `Technical design`,
   `Constraints`, `Feature flag`.
```

### D6 — `Batch > The technical reread`

Une section nouvelle, insérée après `Batch > The coherence reread` :

```markdown
### The technical reread

La relecture technique lit la conception technique d'un lot et les décisions
techniques de ses `Constraints`, contre les specs dans l'état que ses blocs
produiront, s'il en porte, et contre le code de `main`. Quand le lot ne porte ni
l'une ni les autres — `Technical design` vaut `none` et `Constraints` ne porte
aucune décision technique —, elle n'a pas lieu.

**Elle n'est jamais conduite dans le contexte qui a écrit ce qu'elle lit**, et le
corps de la pull request qui le porte — d'ouverture ou d'amendement — le déclare,
avec ce qu'elle a trouvé ou qu'elle n'a rien trouvé.
```

### D7 — `Batch > Opening a batch`

Passage actuel :

```markdown
5. **Fait passer le spec delta entier par la relecture de cohérence**
   (`The coherence reread`).
```

Remplacé par :

```markdown
5. **Fait passer le spec delta entier par la relecture de cohérence**
   (`The coherence reread`), **et sa conception technique par la relecture
   technique** (`The technical reread`).
```

### D8 — `The model`

Insérer, après l'entrée **Arbitrage ouvert** :

```markdown
**Arbitrage de conception** (`design ruling`) — un arbitrage par lequel une story
s'écarte de la conception technique de son lot.
```

### D9 — `Departures from superpowers`

Passage actuel :

```markdown
  Un arbitrage ne remplace ni l'une ni l'autre.
```

Remplacé par :

```markdown
  Dans une story dont le lot déclare des contraintes seulement :

  > Si, en conduisant une story, tu découvres qu'une contrainte de son lot est
  > fausse, arrête-toi et soumets-la à l'humain.

  Une contrainte que la spec contredit ne relève pas de cette condition, mais de la
  règle d'autorité (`Authority and conflict rules`).

  Un arbitrage ne remplace aucune d'elles.
```

### D10 — `Story > The user story document`

Passage actuel :

```markdown
**Un arbitrage ouvert s'écrit `Open ruling:`** là où les autres s'écrivent
`Ruling:`, et sa ligne se termine par ce qui reste à trancher, puis par la
catégorie du gaps register qui l'accueille quand il en rejoint une.
```

Remplacé par :

```markdown
**Un arbitrage ouvert s'écrit `Open ruling:`**, et sa ligne se termine par ce qui
reste à trancher, puis par la catégorie du gaps register qui l'accueille quand il
en rejoint une. **Un arbitrage de conception s'écrit `Design ruling:`**, et se
consigne dans le `Rulings log` qu'il naisse à l'écriture du plan ou pendant
l'exécution ; il ne porte que ce qui est tranché, et ce qu'il laisse à trancher
s'écrit dans un `Open ruling:` à part. Les autres arbitrages s'écrivent `Ruling:`.
```

### D11 — `Story > The user story document`

Passage actuel :

```markdown
6. **dans une story technique seulement**, la condition d'arrêt propre à la story
   technique (`Departures from superpowers`), recopiée intégralement.
```

Remplacé par :

```markdown
6. **dans une story technique seulement**, la condition d'arrêt propre à la story
   technique (`Departures from superpowers`), recopiée intégralement ;
7. **dans une story dont le lot déclare des contraintes seulement**, la condition
   d'arrêt sur une contrainte fausse (`Departures from superpowers`), recopiée
   intégralement.
```

### D12 — `Story > Delivering a story`

Passage actuel :

```markdown
4. **Écrire le plan** — le document de story, avec ses `Global Constraints`, puis
   **le commiter et le pousser immédiatement**, avant que l'exécution démarre.
```

Remplacé par :

```markdown
4. **Écrire le plan** — le document de story, avec ses `Global Constraints`, puis
   **le commiter et le pousser immédiatement**, avant que l'exécution démarre. Le
   plan part de la conception technique du lot.
```

### D13 — `Batch > Amending a batch`

Passage actuel :

```markdown
Un amendement change le périmètre ou le flag d'un lot ouvert, par une pull request
sur son document existant. C'est par lui qu'un lot exempté de flag en déclare un,
qu'un flag reçoit une portée étendue, et qu'un lot réduit ou abandonne son
périmètre.
```

Remplacé par :

```markdown
Un amendement change le périmètre, les contraintes ou le flag d'un lot ouvert, par
une pull request sur son document existant. C'est par lui qu'un lot exempté de flag
en déclare un, qu'un flag reçoit une portée étendue, qu'un lot réduit ou abandonne
son périmètre, et qu'une contrainte qui s'est révélée fausse est corrigée. Un
amendement qui change les décisions techniques de ses contraintes les fait passer
par la relecture technique (`The technical reread`).
```

### D14 — `Batch > Amending a batch`

Insérer, avant la ligne **Conclu par** :

```markdown
**Correction d'une contrainte fausse.** Quand la condition d'arrêt sur une
contrainte fausse se déclenche (`Departures from superpowers`), l'humain tranche.
S'il juge la contrainte fausse, la story est abandonnée (`Abandoning a story`), et
un amendement corrige les `Constraints` du lot ; sinon, la story reprend en la
tenant.
```

### D15 — `Authority and conflict rules`

Passage actuel :

```markdown
| Amendement | la décision de changer le périmètre ou le flag d'un lot | le lot est amendé |
```

Remplacé par :

```markdown
| Amendement | la décision de changer le périmètre, les contraintes ou le flag d'un lot | le lot est amendé |
```

### D16 — `Batch > Closing a batch`

Passage actuel :

```markdown
- **le constat des blocs non livrés** : un bloc du spec delta qu'aucune story
  fusionnée ne déclare dans son champ `Blocks:` est inscrit au gaps register comme
  *gap*, et le texte du lot est amendé pour ne plus promettre ce qu'il n'a pas
  livré ;
```

Remplacé par :

```markdown
- **le constat des blocs non livrés** : un bloc du spec delta qu'aucune story
  fusionnée ne déclare dans son champ `Blocks:` est inscrit au gaps register comme
  *gap*, et le texte du lot est amendé pour ne plus promettre ce qu'il n'a pas
  livré ;
- **la conception technique réécrite** pour que le champ `Technical design` se
  lise comme la conception technique livrée : d'après les arbitrages de conception
  des stories fusionnées, et sans ce que le lot n'a pas livré ;
```

### D17 — `Batch > Opening a batch`

Passage actuel :

```markdown
**La revue d'ouverture porte sur le texte exact de chaque bloc** : c'est là que
l'humain lit ce que diront les specs, avant qu'aucun code ne s'écrive dessus. Quand
le champ `Spec delta` ne porte aucun bloc, elle porte sur ce qui en tient lieu : les
entrées réservées, ou la raison du `none`.
```

Remplacé par :

```markdown
**La revue d'ouverture porte sur le texte exact de chaque bloc** : c'est là que
l'humain lit ce que diront les specs, avant qu'aucun code ne s'écrive dessus. Quand
le champ `Spec delta` ne porte aucun bloc, elle porte sur ce qui en tient lieu : les
entrées réservées, ou la raison du `none`. Elle porte aussi sur la conception
technique du lot et sur ses `Constraints`.
```

## Technical design

Ce champ n'existe pas encore sur `main` : ce lot l'écrit parce que sa propre
conception a de quoi le remplir, et sans la relecture technique, qu'il crée.

**Le champ et ses contraintes — `skills/writing-a-batch/SKILL.md`.** Le gabarit de
`## The Batch Document` gagne `## Technical design` entre `## Spec delta` et
`## Constraints`, avec son texte de gabarit — la conception approuvée à l'étape de
conception du brainstorming, un point de départ, jamais blanche. Le paragraphe
**`Constraints` is where the batch says what a spec cannot** s'étend aux décisions
techniques que toute story doit tenir, avec leur critère d'entrée. `## Opening, in
Order` nomme le champ à l'étape 3. La relecture du document de lot de
`## Opening the Pull Request` gagne « `Technical design` filled », et le corps de
la pull request énonce `Constraints` et `Technical design` parmi ce que l'humain
tranche. Le paragraphe qui fait remplacer la queue du brainstorming par cette pull
request dit où va ce que l'étape 5 a décidé de la technique.

**La relecture technique — `skills/writing-a-batch/SKILL.md` et un fichier de
référence neuf.** Une section `## The Technical Reread`, après
`## The Coherence Reread`, sur le même patron : lancée à l'étape 5 de l'ouverture
avec la relecture de cohérence, hors du contexte qui a conçu, un lecteur par
lecture, tous rendus avant que rien ne monte, les constats instruits et non
transmis. Elle reprend les quatre conditions qui arrêtent les tours en les
**nommant**, sans les recopier. Ses cinq lectures sont écrites pour un lecteur qui
n'a rien d'autre, collées mot pour mot dans le prompt :

1. **Couverture** — la conception réalise-t-elle ce que les blocs promettent ?
2. **Ancrage dans le code** — ce qu'elle suppose exister existe-t-il, suit-elle la
   structure en place, touche-t-elle ce qu'elle croit toucher ?
3. **Architecture** — découpage en unités, frontières, sens des dépendances ; avec
   `clean-architecture` si elle est disponible, sans elle sinon.
4. **Conception des modules** — profondeur des modules, masquage d'information,
   fuites entre modules, complexité ; avec `software-design-philosophy` si elle est
   disponible, sans elle sinon.
5. **Robustesse** — gestion d'erreurs, stratégie de test, risques non nommés.

Le lecteur reçoit la conception et les contraintes, la spec dans l'état que
produiront les blocs, et le dépôt. Son prompt vit dans
`skills/writing-a-batch/references/technical-reader-prompt.md` et non dans
`reader-prompt.md`, qui est écrit pour des lectures de spec : ses deux états, son
interdit de lire un diff, son « do not revise the specification » ne veulent rien
dire pour une conception. Le README recommande `clean-architecture` et
`software-design-philosophy` à côté de `domain-driven-design`, sans que le plugin
en dépende.

**La story — `skills/writing-a-user-story/SKILL.md`, `skills/using-batches/SKILL.md`
et `skills/writing-a-batch/SKILL.md`.** Dans writing-a-user-story, `## Step 4 —
Write the Plan` dit que le plan part de `Technical design`, comme writing-plans part
du document de conception chez superpowers, et que sa ligne `Architecture:` en
dérive ; la forme `Design ruling:` à côté de celle de `Open ruling:`, et qu'un écart
pris à l'écriture du plan s'y consigne aussitôt ; et un septième élément de
`Global Constraints`, la condition d'arrêt sur une contrainte fausse, recopiée mot
pour mot. `## Step 6` recopie sous cette forme les écarts venus du registre de SDD.
Dans using-batches, l'override 2 s'allonge de cette condition, dans son texte
anglais de référence, et c'est lui que les deux autres skills recopient ;
`## Authority and Conflict Rules` y dit que le code de `main` fait foi là où il
s'est écarté de la conception technique. Dans writing-a-batch, `## Amending a Batch`
couvre les contraintes et la correction d'une contrainte fausse, sur le patron de
`## Requalifying a Technical Story` : l'humain tranche d'abord, et l'amendement
passe la relecture technique.

**La clôture — `skills/closing-a-batch/SKILL.md`.** Un devoir de plus : relever les
`Design ruling:` des stories fusionnées dans le même passage que les
`Open ruling:`, et réécrire `Technical design` pour qu'il se lise comme la
conception technique livrée, en retirant ce qui servait des blocs non livrés. Rien
à faire quand le champ vaut `none` ; les stories abandonnées ne comptent pas. La
skill dit la limite de la section consolidée — vraie à la clôture, pas au-delà, le
code faisant foi ensuite — et la spec ne la dit pas.

**Les tests.** La suite est structurelle : chaque story ajoute ses assertions dans
`tests/test-skill-content.sh` et `tests/test-skill-contracts.sh` — en particulier
une assertion `shared` qui exige la condition d'arrêt sur une contrainte fausse mot
pour mot dans using-batches et writing-a-user-story, comme pour les deux autres —,
et le prompt du lecteur technique reçoit son propre fichier de test, sur le modèle
de `tests/test-reader-prompt.sh`.

## Constraints

**Ordre des blocs.** `D1` et `D3` posent le terme et le champ, et précèdent tout
bloc qui nomme la conception technique ou `Technical design` : `D2`, `D6`, `D7`,
`D8`, `D10`, `D12`, `D16` et `D17`. `D6` précède `D7` et `D13`, qui nomment la
relecture technique. `D9` précède `D11` et `D14`, qui renvoient à la condition
d'arrêt qu'il écrit. `D8` et `D10` précèdent `D16`, qui relit les arbitrages de
conception. Tous les autres sont indépendants.

**Six sections portent plusieurs blocs, dont l'ordre entre eux est libre** : leurs
ancres sont disjointes. `The model` (`D1`, `D8`), `Authority and conflict rules`
(`D2`, `D15`), `Batch > The batch document` (`D3`, `D4`), `Batch > Opening a batch`
(`D5`, `D7`, `D17`), `Story > The user story document` (`D10`, `D11`), `Batch >
Amending a batch` (`D13`, `D14`).

**Un lot ouvert avant la transcription de `D3` n'a pas de champ
`Technical design`** : sa clôture n'a pas de conception à réécrire, et ses stories
n'ont pas de conception dont partir.

**Les noms sont fixés ici, et toute story les emploie tels quels** : le champ
`Technical design`, la forme `Design ruling:`, la section `The technical reread`
dans la spec et `## The Technical Reread` dans writing-a-batch, le fichier
`skills/writing-a-batch/references/technical-reader-prompt.md`.

**`bash tests/run-all.sh` passe à la fin de chaque story.**

## Feature flag

Feature flag: none — chaque story est complète dans sa propre pull request, et
l'ordre des blocs ci-dessus interdit qu'une règle livrée renvoie à une règle non
livrée.
