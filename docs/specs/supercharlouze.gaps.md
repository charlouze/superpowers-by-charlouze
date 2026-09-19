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
`CLAUDE.md`. Ce sont les paris que le `README.md` énonce comme non testés ; ils ne
sont ni conformes ni non conformes, ils sont inobservables ici.

## Violations

- ~~**Verification** — `README.md` renvoie le lecteur à « section 11 of the design
  document » pour la liste des paris non testés, et `commands/init.md` renvoie à
  « spec section 9 » pour la règle de la pull request. Ces deux renvois désignent
  des sections numérotées du document de conception, désormais archivé sous
  `docs/archive/specs/` et privé d'autorité par la présente adoption. La spec
  vivante est l'autorité contraignante et n'a pas de numérotation : les deux
  pointeurs sont d'ores et déjà faux, et ils pourriront davantage à chaque
  amendement de la spec.~~ `reserved by batch-01`

- ~~**Verification** — quatre renvois numérotés au document de conception archivé
  survivent dans `tests/`, du même type que ceux que le lot 01 a corrigés et
  laissés hors de son périmètre parce que l'entrée qu'il avait réservée ne
  nommait que les artefacts livrés : `tests/test-cross-references.sh:66`
  (`(spec 8.1)`, à remplacer par la section `Routing and precedence`), `:74`
  (`(spec 8.2)` → `What is kept, what is rerouted`),
  `tests/test-declared-overrides.sh:104` (`(spec 5.1)` → `Git model`),
  `tests/test-skill-content.sh:35` (`(spec 6)` → `Module adoption`). La garde
  ajoutée par le lot 01 ne les attrape pas : sa portée s'arrête aux artefacts
  livrés, et son libellé le dit. Rien d'autre ne les rattrapera non plus — la
  section `Coverage` ci-dessus déclare que `tests/` n'a été audité que par le
  **nom** de ses assertions.~~ — *sans objet : la spec ne porte plus de règle sur la suite de tests, section `Verification` retirée comme implémentation par le lot 03 ; les renvois numérotés restent dans `tests/`, hors de toute spec.*

- ~~**Verification** — *complète l'entrée ci-dessus, qu'aucun lot ne tient encore.*
  Elle annonce **quatre** renvois numérotés survivant dans `tests/` et en nomme
  quatre. Il y en a **neuf** : `tests/test-command.sh`, `tests/test-cross-references.sh`
  (deux), `tests/test-declared-overrides.sh`, et `tests/test-skill-content.sh`
  (cinq), plusieurs citant chacun plusieurs numéros. Le lot correctif qui prendra
  l'entrée précédente trouverait donc son énumération incomplète et pourrait
  s'arrêter au périmètre annoncé — ce qui est exactement ce que le lot 01 a fait,
  et qui est la raison pour laquelle cette violation existe. Les deux entrées se
  prennent ensemble ; la fusion des deux libellés est une décision humaine.~~ — *sans objet : la spec ne porte plus de règle sur la suite de tests, section `Verification` retirée comme implémentation par le lot 03, comme l'entrée qu'elle complète.*

- **Installing on a project** — la spec énonce sans réserve que « le mode du fichier est
  préservé », et `scripts/init.sh` ne l'offre qu'au mieux : `chmod --reference` est
  une extension GNU que le `chmod` BSD ne connaît pas, l'échec est avalé par
  `2>/dev/null || true`, et `CLAUDE.md` repart alors sous le mode du fichier
  temporaire, `0600`, sans un mot. **Résoluble en ne touchant que le code** — un
  repli portable derrière l'appel GNU — d'où le classement en violation plutôt
  qu'en gap. La garde comportementale livrée par le lot 02 attrape ce cas là où
  elle tourne, mais ne le prévient pas.

- **Installing on a project** — la spec énonce que les refus laissent le fichier
  **intact**, et `scripts/init.sh` exécute `touch "$CLAUDE_MD"` avant les comptages
  de marqueurs : sur un chemin de refus le contenu est bien intact, mais la `mtime`
  a changé. Écart mineur et sans conséquence connue, **résoluble en déplaçant le
  `touch` après les contrôles**, donc en ne touchant que le code.

## Gaps

- ~~**The batch document** — `writing-a-batch` impose une section `## Constraints`
  (contraintes de migration et de compatibilité, ordre requis des stories, `none`
  s'il n'y en a pas), que `writing-a-user-story` recopie **verbatim** dans les
  `Global Constraints` de chaque plan. Aucun document validé ne nomme cette
  section ni ne décrit la convention `none` ou la recopie verbatim, alors que la
  spec fait de ces contraintes ce que le batch porte et que la spec ne porte pas.~~ `reserved by batch-02`

- ~~**The batch document** — `writing-a-batch` impose une section `## Live flags` où
  chaque flag vivant remonté reçoit la décision de l'humain, écrite sous forme de
  **deux chaînes littérales** : `carried by this batch — lifting story owed` et
  `not this batch — <reason>`. `closing-a-batch` recherche la première **au mot
  près** pour savoir quels flags le lot devait lever. Aucun document validé ne
  décrit cette section, ni le fait que la décision soit consignée dans le
  document, ni ce couplage par chaîne littérale entre deux skills — qui est
  pourtant le seul canal par lequel un flag hérité atteint le contrôle de clôture.~~ `reserved by batch-02`

- ~~**Closing a batch** — le contrôle des flags porte, dans `closing-a-batch`, sur
  les flags **que le lot a déclarés** *et* sur ceux **qu'il a hérités par une
  décision au gate d'ouverture**, avec un test distinct pour les seconds : la
  décision humaine rend « dépensée » la portée étendue déclarée par le lot
  d'origine, donc l'entrée n'est réglée que si le flag a disparu du code et de la
  spec. Aucun document validé ne décrit la notion de flag hérité ni ce test
  particulier ; la spec ne connaît que les flags du lot.~~ `reserved by batch-02`

- ~~**Closing a batch** — `closing-a-batch` exécute le **contrôle du devoir 5 avant
  les devoirs 1 à 4**, au motif qu'un refus doit être gratuit : les quatre
  premiers écrivent, aucun n'est rejouable sans dupliquer ses effets, et un refus
  tardif échouerait quatre devoirs d'écriture sur une branche que personne ne
  peut fusionner. La spec énonce six devoirs dans l'ordre 1 à 6 et ne décrit
  aucune inversion.~~ `reserved by batch-02`

- ~~**Closing a batch** — `closing-a-batch` énonce que le devoir 4 **n'a rien à
  comparer pour un lot correctif**, dont le spec delta est vide par définition, et
  que le devoir 3 en tient alors lieu — avec l'interdiction explicite de reclasser
  les entrées libérées en gaps neufs. Aucun document validé ne porte cette
  exception.~~ `reserved by batch-02`

- ~~**The user story document** — `writing-a-user-story` fait porter aux
  `Global Constraints` **plus que les deux choses que la spec y met** : outre les
  contraintes du batch et le gel du fichier de spec, la règle « la spec gagne, et
  corriger une spec est un acte humain », et — dans un lot correctif — la
  cinquième condition d'arrêt recopiée intégralement. Le motif est load-bearing :
  les `Global Constraints` sont le seul canal que lisent les sous-agents
  implémenteurs de SDD, donc une condition d'arrêt qui n'y figure pas n'atteint
  jamais l'agent qui doit l'appliquer. La spec en reste à deux éléments.~~ `reserved by batch-02`

- ~~**Module adoption** — `adopting-a-module` fixe la **place de la création de la
  branche dans l'ordre des étapes** : avant que le moindre fichier soit écrit,
  parce que `superpowers:using-git-worktrees` ouvre un répertoire séparé et
  qu'une spec écrite plus tôt resterait sur `main` dans le checkout principal. La
  spec ordonne les étapes de l'adoption sans placer celle-là, et aucun document
  validé n'énonce cette contrainte d'ordre.~~ `reserved by batch-02`

- ~~**Branch naming** — `writing-a-batch` impose qu'une pull request d'amendement
  parte d'une **branche distincte au nom sans signification**, et interdit de
  réutiliser `batch/NN-<slug>` que la pull request d'ouverture peut encore tenir
  sur le remote. La table de nommage de la spec n'a pas de ligne pour
  l'amendement.~~ `reserved by batch-02`

- ~~**Branch naming** — la spec demande que le plugin crée la branche au nom
  conventionnel, et qu'il **s'assure qu'une branche nommée existe** si l'outil
  natif du harnais en a choisi un autre. Les skills implémentent cette phrase de
  deux façons : `writing-a-batch` exige de rétablir le nom conventionnel
  (« make sure a branch named `batch/NN-<slug>` exists before going on »), tandis
  qu'`adopting-a-module` se contente de n'importe quelle branche nommée. Les deux
  satisfont la spec, qui ne dit pas laquelle des deux lectures elle veut — la
  présente pull request en est l'illustration, portée par une branche que le
  harnais a nommée `worktree-adopt+supercharlouze` et non `adopt/supercharlouze`.~~ `reserved by batch-02`

- ~~**The init command** — `scripts/init.sh` porte plusieurs comportements de sûreté
  qu'aucun document validé ne décrit, et que la spec réduit à « insérer ou mettre
  à jour, sans jamais dupliquer » : il **refuse toute l'exécution** si un document
  archivé occupe déjà un chemin de destination, avant de déplacer quoi que ce
  soit ; il **refuse et laisse le fichier intact** si les marqueurs `CLAUDE.md`
  sont absents d'un côté, dupliqués, ou inversés ; il délimite le bloc par une
  paire de marqueurs HTML (`<!-- supercharlouze:begin -->` / `:end`) appariés
  **sur la ligne entière**, de sorte qu'une prose citant les marqueurs ne soit pas
  prise pour un bloc ; il préserve le mode du fichier ; et il supprime
  l'arborescence `docs/superpowers` une fois vidée.~~ `reserved by batch-02`

- ~~**Document layout** — l'arborescence que `init` crée comporte deux répertoires
  qui restent vides jusqu'au premier usage, `docs/specs/` et `docs/batches/`. Git
  ne suit pas les répertoires vides : sur `main`, ils n'existent pas, et un clone
  frais ne les a pas. Le script les recrée à chaque exécution, donc le code est
  conforme à ce que la spec lui demande — mais aucun document validé ne dit si
  l'arborescence doit survivre à un clone, ni ce qu'un dépôt est censé porter
  entre l'init et la première spec.~~ `reserved by batch-02`

- ~~**Verification** — la suite de tests vérifie **au-delà des cinq contrôles que la
  spec énumère** : cas limites de l'init (collision d'archivage, marqueurs
  inversés, dupliqués, cités en prose, survie d'un `CLAUDE.md.tmp` préexistant,
  migration d'un sous-arbre imbriqué, portée de la lecture de `Sources`),
  assertions de contenu sur les quatre skills productifs, assertions sur le
  fichier de commande. Ces contrôles sont structurels et légitimes, mais la liste
  normative de la spec n'en couvre que cinq.~~ `reserved by batch-02`

- **Concurrency detection / The user story document** — la spec fait du champ
  `Sections:` « ce que lit la détection de concurrence », et la détection ne
  retient que les pull requests et les branches **dont le diff touche le fichier
  de spec**. Or le premier commit d'une story corrective ne touche pas la spec,
  par construction : il barre une entrée du gaps register. Une story corrective
  est donc structurellement invisible de ce mécanisme, et le `Sections:` que la
  spec lui impose de déclarer n'est jamais lu par personne. Constaté par le
  lot 01, dont c'était le cas. **Rien à corriger dans le code : les deux règles
  sont implémentées fidèlement, c'est leur conjonction qui est muette.** Résorber
  cette entrée veut dire décider ce que la spec doit dire — soit exempter une
  story corrective de la déclaration, soit étendre le filtre au gaps register —
  et cette décision est humaine. D'où le classement en *gap* plutôt qu'en
  violation : un lot correctif la prendrait et buterait aussitôt sur la cinquième
  condition d'arrêt.

- ~~**Verification** — le lot 01 a ajouté une garde qui vérifie que les sections
  nommées par un renvoi **existent**, jamais que la section citée dit ce que le
  renvoi prétend. Un déplacement de contenu d'une section à l'autre laisse le
  renvoi vert et faux. Aucun document validé ne dit quel niveau de vérification
  un renvoi doit à sa cible, ni si un tel contrôle est seulement souhaitable.~~ — *sans objet : la spec ne porte plus de règle sur la suite de tests, section `Verification` retirée comme implémentation par le lot 03.*

**Les entrées qui suivent ont été consolidées par la clôture du lot 02**, depuis
les sections `Observed drift` de ses quatre stories. Elles partagent une forme :
**la spec y a tort et le code y a raison.** Elles sont classées en *Gaps* et non en
*Violations* par le précédent que porte déjà l'entrée *Concurrency detection*
ci-dessus — un lot correctif qui les prendrait buterait aussitôt sur la cinquième
condition d'arrêt, puisque les résorber veut dire corriger une spec, ce qu'un agent
ne peut pas faire. Les deux constats qu'un changement de code seul peut résoudre
sont sous *Violations*.

- **Batch / Closing a batch** — la spec affirme sans réserve que « le
  document de lot ne porte aucun état mutable, et rien dans le déroulement normal
  ne le modifie », et sa propre section `Closing a batch` la contredit : le constat
  des intentions non livrées amende le texte du lot pour ne plus promettre ce qu'il
  n'a pas livré, et la clôture bascule son front matter en `status: closed`. `closing-a-batch` énonce
  d'ailleurs la règle **avec** l'exception que la spec nie — « nothing in the normal
  course of the batch modifies it **until closing** ». Le code a raison. Résorber
  veut dire borner la phrase sur la clôture, et c'est une décision humaine.
  `reserved by batch-04`

- ~~**Branch naming** — « Une branche laissée sous le nom qu'un outil natif lui a
  donné est invisible des deux » se lit comme général et ne vaut que de `batch/*` et
  `story/*`. Ni `adopt/<module>`, ni `chore/supercharlouze-init`, ni `fix/<slug>` ne
  sont lus par l'un des deux mécanismes : pour eux la phrase est fausse. **Le coût
  est démontré, pas hypothétique** — cette phrase a produit, dans le plan de la
  story 02-us-2, un paragraphe affirmant une causalité inexistante, rattrapé en
  *Critical* à la revue de tâche et corrigé au commit `b4564ba`. Reformulation
  suggérée : « invisible des deux là où ces balayages portent — `batch/*` et
  `story/*` ».~~ — *sans objet : la phrase visée a quitté `Branch naming` avec la restructuration du lot 03.*

- ~~**Branch naming** — le critère donné à l'exception d'amendement en licencierait
  quatre. Le paragraphe pose que l'amendement est la seule exception « par
  construction », au motif qu'il ne revendique ni numéro ni sections et qu'aucun
  balayage ne le cherche. Ce critère est **exactement aussi vrai** de
  `adopt/<module>`, `chore/supercharlouze-init` et `fix/<slug>`. La spec déclare
  donc une exception unique en donnant une raison qui en autorise quatre, et elle
  entre en tension directe avec `adopting-a-module`, à qui le lot 02 a dû faire
  écrire que n'être pas balayé n'exempte **pas**. La vraie raison est ailleurs : la
  table n'assigne à l'amendement aucun nom conventionnel à rétablir.~~ — *sans objet : le paragraphe visé a quitté `Branch naming` avec la restructuration du lot 03 ; la spec ne fait plus de l'amendement une exception, elle lui donne une ligne de la table et dit qu'il ne revendique ni numéro ni section.*

- ~~**Branch naming / Number allocation** — la dépendance au nom de branche est plus
  large que la spec ne le dit. Elle affirme que les deux mécanismes lisent le nom
  « tous deux exactement sur la fenêtre où la pull request n'existe pas encore ».
  C'est faux pour `Number allocation`, dont la **deuxième** condition — un numéro
  revendiqué par une pull request ouverte — se résout elle aussi par le nom, via
  `headRefName` : `writing-a-batch` l'écrit noir sur blanc, « the number is in the
  head branch name, and nothing else in a pull request states it ». Un lot ouvert
  depuis une branche mal nommée, pull request **ouverte**, ne revendique son numéro
  pour personne. La lecture stricte en sort renforcée ; c'est le raisonnement écrit
  qui est plus étroit que le système décrit.~~ — *sans objet : la phrase visée a quitté la spec avec la restructuration du lot 03 ; `Batch` dit désormais que seules `batch/*` et `story/*` revendiquent un numéro.*

- **The gaps register** — le registre n'a pas de vocabulaire pour « retirée parce
  que fausse ». La story 02-us-2 a barré l'entrée *Module adoption* non parce qu'un
  code la résorbait, mais parce qu'elle était factuellement fausse. Or la spec
  définit le barré comme le geste de « la pull request de la story qui la résorbe,
  **atomiquement avec le code qui la résorbe** ». Relue plus tard, cette entrée dira
  donc « résorbée par cette pull request », ce qui est faux : aucun code ne l'a
  résorbée, elle a été retirée. Il manque une annotation distinguant les deux
  gestes — et le présent commentaire de consolidation est, lui aussi, une forme que
  la spec ne décrit pas.

- ~~**Document layout** — la clause écrite par la story 02-us-3 est fausse dans ce
  dépôt même. Elle affirme que `docs/specs/` et `docs/batches/` « ne sont donc pas
  sur `main` » ; `git ls-tree -r main` les y trouve tous les deux, et le fichier qui
  porte la phrase est l'un d'eux. La prémisse est vraie — ils restent vides jusqu'à
  leur premier usage — mais la conclusion est au présent absolu. Reformulation
  tenable : « **tant qu'ils sont vides**, ils ne sont pas sur `main` ».~~ — *résolue par la reformulation que l'entrée suggérait : le lot 03 écrit qu'un répertoire n'est sur `main` qu'à partir du premier document qu'il reçoit.*

- **Installing on a project** — second membre de la même phrase, également falsifiable :
  « rien dans ce système ne lit ces répertoires avant qu'un document y soit écrit ».
  `writing-a-batch` prescrit `ls docs/batches/` pour attribuer `NN`, exécuté
  exactement quand le répertoire peut être absent, et `writing-a-user-story` fait de
  même sur le répertoire du lot. L'impact est faible — un `ls` qui échoue laisse
  déduire `NN=1` — mais la phrase est présentée comme une garantie. Formulation
  tenable : « aucune **décision** de ce système ne dépend de leur existence ».

- **Installing on a project** — « ce qui subsiste n'appartient pas au plugin : il n'est ni
  déplacé, ni supprimé » n'est vrai qu'**en dehors de `specs/` et `plans/`**. Le
  balayage `find "$from" -depth -type d -exec rmdir {} +` supprime un répertoire
  étranger vide placé sous `docs/superpowers/specs/`, et un fichier étranger déposé
  là est déplacé vers `docs/archive/specs/`. Borner la phrase suffirait ; changer le
  code serait l'autre sortie, et c'est ce choix qui rend la décision humaine.

- ~~**Verification** — le bullet sur le contenu des skills promet plus que la suite ne
  tient. « Chacun énonce les règles que cette spec lui attribue » est un
  quantificateur universel sur un ensemble non énuméré, là où tous ses voisins
  énumèrent des propriétés concrètes, et `tests/test-skill-content.sh` affirme une
  soixantaine de chaînes littérales choisies à la main. La liste étant désormais un
  **plancher**, c'est une obligation permanente que rien ne soutient. Deux règles le
  démontrent : la **troisième condition** de `Number allocation` — un numéro
  revendiqué par une branche poussée sans pull request, avec ses patrons
  différenciés — et la **place de la story de levée**, dernière du lot quand le flag
  est à portée de lot ; les deux sont énoncées par les skills et touchées par aucune
  assertion. Reformulation d'une ligne : « chacun énonce, **dans sa formulation
  littérale, un ensemble nommé** de règles que cette spec lui attribue ».~~ — *sans objet : la spec ne porte plus de règle sur la suite de tests, section `Verification` retirée comme implémentation par le lot 03.*

- ~~**Verification** — la clause sur les sections nommées est universelle, sa garde
  est énumérée. « Chaque section nommée par un renvoi existe dans cette spec » est
  **vraie aujourd'hui** — le balayage des artefacts livrés ne trouve que deux renvois
  de ce type — mais la garde itère une paire codée en dur. Un renvoi nommé ajouté
  demain ne serait vérifié par rien.~~ — *sans objet : la spec ne porte plus de règle sur la suite de tests, section `Verification` retirée comme implémentation par le lot 03.*

- ~~**Verification** — la clause sur les chemins est plus étroite que ses mots.
  « Chaque chemin relatif cité d'un skill à l'autre existe » : la garde ne reconnaît
  que les chemins entre accents graves sous `skills`, `scripts`, `commands`, `tests`
  et `.claude-plugin`, et ne balaie que `skills/` et `commands/`. Un chemin `docs/…`,
  ou cité depuis `README.md` ou `scripts/`, n'est pas vérifié. Cette formulation est
  **antérieure au lot 02**, recopiée mot pour mot de l'ancienne liste de cinq — elle
  n'est donc pas une promesse neuve, seulement une promesse restée trop large.~~ — *sans objet : la spec ne porte plus de règle sur la suite de tests, section `Verification` retirée comme implémentation par le lot 03.*
