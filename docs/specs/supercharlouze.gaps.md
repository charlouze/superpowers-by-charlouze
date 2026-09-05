# supercharlouze — Gaps register

## Coverage

**Audité intégralement, ligne à ligne**, contre chaque section de
`docs/specs/supercharlouze.md` :

- les cinq `skills/*/SKILL.md` — `using-batches`, `adopting-a-module`,
  `writing-a-batch`, `writing-a-user-story`, `closing-a-batch` ;
- `skills/using-batches/references/claude-md-block.md` et le `CLAUDE.md` du dépôt ;
- `commands/init.md` et `scripts/init.sh` ;
- `.claude-plugin/plugin.json` et `.claude-plugin/marketplace.json` ;
- `README.md`.

**Audité partiellement :** `tests/` — les huit scripts ont été lus par le **nom de
leurs assertions** (sortie de `tests/run-all.sh`, 90 assertions), pas ligne à ligne.
Ce qu'une assertion vérifie réellement n'a donc pas été confronté à ce que son nom
annonce. Un test qui passerait sans rien vérifier ne serait pas détecté par cet
audit.

**Non audité :** rien d'autre — le module ne contient aucun autre fichier suivi.

**Ce que cet audit ne pouvait pas faire :** la spec porte des règles dont la
conformité ne s'observe pas dans un fichier — le respect du gel du fichier de spec
par les implémenteurs de SDD, le respect de l'Override 4 au moment où
`finishing-a-development-branch` présente son menu, la solidité du levier
`CLAUDE.md`. Ce sont les paris que la section `Verification` de la spec énonce
comme non testés ; ils ne sont ni conformes ni non conformes, ils sont
inobservables ici.

## Violations

- **Verification** — `README.md` renvoie le lecteur à « section 11 of the design
  document » pour la liste des paris non testés, et `commands/init.md` renvoie à
  « spec section 9 » pour la règle de la pull request. Ces deux renvois désignent
  des sections numérotées du document de conception, désormais archivé sous
  `docs/archive/specs/` et privé d'autorité par la présente adoption. La spec
  vivante est l'autorité contraignante et n'a pas de numérotation : les deux
  pointeurs sont d'ores et déjà faux, et ils pourriront davantage à chaque
  amendement de la spec. `reserved by batch-01`

## Gaps

- **The batch document** — `writing-a-batch` impose une section `## Constraints`
  (contraintes de migration et de compatibilité, ordre requis des stories, `none`
  s'il n'y en a pas), que `writing-a-user-story` recopie **verbatim** dans les
  `Global Constraints` de chaque plan. Aucun document validé ne nomme cette
  section ni ne décrit la convention `none` ou la recopie verbatim, alors que la
  spec fait de ces contraintes ce que le batch porte et que la spec ne porte pas.

- **The batch document** — `writing-a-batch` impose une section `## Live flags` où
  chaque flag vivant remonté reçoit la décision de l'humain, écrite sous forme de
  **deux chaînes littérales** : `carried by this batch — lifting story owed` et
  `not this batch — <reason>`. `closing-a-batch` recherche la première **au mot
  près** pour savoir quels flags le lot devait lever. Aucun document validé ne
  décrit cette section, ni le fait que la décision soit consignée dans le
  document, ni ce couplage par chaîne littérale entre deux skills — qui est
  pourtant le seul canal par lequel un flag hérité atteint le contrôle de clôture.

- **Closing a batch** — le contrôle des flags porte, dans `closing-a-batch`, sur
  les flags **que le lot a déclarés** *et* sur ceux **qu'il a hérités par une
  décision au gate d'ouverture**, avec un test distinct pour les seconds : la
  décision humaine rend « dépensée » la portée étendue déclarée par le lot
  d'origine, donc l'entrée n'est réglée que si le flag a disparu du code et de la
  spec. Aucun document validé ne décrit la notion de flag hérité ni ce test
  particulier ; la spec ne connaît que les flags du lot.

- **Closing a batch** — `closing-a-batch` exécute le **contrôle du devoir 5 avant
  les devoirs 1 à 4**, au motif qu'un refus doit être gratuit : les quatre
  premiers écrivent, aucun n'est rejouable sans dupliquer ses effets, et un refus
  tardif échouerait quatre devoirs d'écriture sur une branche que personne ne
  peut fusionner. La spec énonce six devoirs dans l'ordre 1 à 6 et ne décrit
  aucune inversion.

- **Closing a batch** — `closing-a-batch` énonce que le devoir 4 **n'a rien à
  comparer pour un lot correctif**, dont le spec delta est vide par définition, et
  que le devoir 3 en tient alors lieu — avec l'interdiction explicite de reclasser
  les entrées libérées en gaps neufs. Aucun document validé ne porte cette
  exception.

- **The user story document** — `writing-a-user-story` fait porter aux
  `Global Constraints` **plus que les deux choses que la spec y met** : outre les
  contraintes du batch et le gel du fichier de spec, la règle « la spec gagne, et
  corriger une spec est un acte humain », et — dans un lot correctif — la
  cinquième condition d'arrêt recopiée intégralement. Le motif est load-bearing :
  les `Global Constraints` sont le seul canal que lisent les sous-agents
  implémenteurs de SDD, donc une condition d'arrêt qui n'y figure pas n'atteint
  jamais l'agent qui doit l'appliquer. La spec en reste à deux éléments.

- **Module adoption** — `adopting-a-module` fixe la **place de la création de la
  branche dans l'ordre des étapes** : avant que le moindre fichier soit écrit,
  parce que `superpowers:using-git-worktrees` ouvre un répertoire séparé et
  qu'une spec écrite plus tôt resterait sur `main` dans le checkout principal. La
  spec ordonne les étapes de l'adoption sans placer celle-là, et aucun document
  validé n'énonce cette contrainte d'ordre.

- **Branch naming** — `writing-a-batch` impose qu'une pull request d'amendement
  parte d'une **branche distincte au nom sans signification**, et interdit de
  réutiliser `batch/NN-<slug>` que la pull request d'ouverture peut encore tenir
  sur le remote. La table de nommage de la spec n'a pas de ligne pour
  l'amendement.

- **Branch naming** — la spec demande que le plugin crée la branche au nom
  conventionnel, et qu'il **s'assure qu'une branche nommée existe** si l'outil
  natif du harnais en a choisi un autre. Les skills implémentent cette phrase de
  deux façons : `writing-a-batch` exige de rétablir le nom conventionnel
  (« make sure a branch named `batch/NN-<slug>` exists before going on »), tandis
  qu'`adopting-a-module` se contente de n'importe quelle branche nommée. Les deux
  satisfont la spec, qui ne dit pas laquelle des deux lectures elle veut — la
  présente pull request en est l'illustration, portée par une branche que le
  harnais a nommée `worktree-adopt+supercharlouze` et non `adopt/supercharlouze`.

- **The init command** — `scripts/init.sh` porte plusieurs comportements de sûreté
  qu'aucun document validé ne décrit, et que la spec réduit à « insérer ou mettre
  à jour, sans jamais dupliquer » : il **refuse toute l'exécution** si un document
  archivé occupe déjà un chemin de destination, avant de déplacer quoi que ce
  soit ; il **refuse et laisse le fichier intact** si les marqueurs `CLAUDE.md`
  sont absents d'un côté, dupliqués, ou inversés ; il délimite le bloc par une
  paire de marqueurs HTML (`<!-- supercharlouze:begin -->` / `:end`) appariés
  **sur la ligne entière**, de sorte qu'une prose citant les marqueurs ne soit pas
  prise pour un bloc ; il préserve le mode du fichier ; et il supprime
  l'arborescence `docs/superpowers` une fois vidée.

- **Document layout** — l'arborescence que `init` crée comporte deux répertoires
  qui restent vides jusqu'au premier usage, `docs/specs/` et `docs/batches/`. Git
  ne suit pas les répertoires vides : sur `main`, ils n'existent pas, et un clone
  frais ne les a pas. Le script les recrée à chaque exécution, donc le code est
  conforme à ce que la spec lui demande — mais aucun document validé ne dit si
  l'arborescence doit survivre à un clone, ni ce qu'un dépôt est censé porter
  entre l'init et la première spec.

- **Verification** — la suite de tests vérifie **au-delà des cinq contrôles que la
  spec énumère** : cas limites de l'init (collision d'archivage, marqueurs
  inversés, dupliqués, cités en prose, survie d'un `CLAUDE.md.tmp` préexistant,
  migration d'un sous-arbre imbriqué, portée de la lecture de `Sources`),
  assertions de contenu sur les quatre skills productifs, assertions sur le
  fichier de commande. Ces contrôles sont structurels et légitimes, mais la liste
  normative de la spec n'en couvre que cinq.
