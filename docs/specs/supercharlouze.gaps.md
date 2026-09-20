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

- **Concurrency detection / The user story document** — la spec fait du champ
  `Sections:` « ce que lit la détection de concurrence », et la détection ne
  retient que les pull requests et les branches **dont le diff touche le fichier
  de spec**. Or le premier commit d'une story corrective ne touche pas la spec,
  par construction : il supprime une entrée du gaps register. Une story corrective
  est donc structurellement invisible de ce mécanisme, et le `Sections:` que la
  spec lui impose de déclarer n'est jamais lu par personne. Constaté par le
  lot 01, dont c'était le cas. **Rien à corriger dans le code : les deux règles
  sont implémentées fidèlement, c'est leur conjonction qui est muette.** Résorber
  cette entrée veut dire décider ce que la spec doit dire — soit exempter une
  story corrective de la déclaration, soit étendre le filtre au gaps register —
  et cette décision est humaine. D'où le classement en *gap* plutôt qu'en
  violation : un lot correctif la prendrait et buterait aussitôt sur la cinquième
  condition d'arrêt. `reserved by batch-09`

- **Installing on a project** — le second membre de la phrase sur les répertoires
  que l'installation crée, également falsifiable :
  « rien dans ce système ne lit ces répertoires avant qu'un document y soit écrit ».
  `writing-a-batch` prescrit `ls docs/batches/` pour attribuer `NN`, exécuté
  exactement quand le répertoire peut être absent, et `writing-a-user-story` fait de
  même sur le répertoire du lot. L'impact est faible — un `ls` qui échoue laisse
  déduire `NN=1` — mais la phrase est présentée comme une garantie. Formulation
  tenable : « aucune **décision** de ce système ne dépend de leur existence ».
  Consolidée par la clôture du lot 02, depuis l'`Observed drift` d'une de ses
  stories. Classée en *gap* et non en *violation* : la spec y a tort et le code y
  a raison, si bien qu'un lot correctif qui la prendrait buterait aussitôt sur la
  cinquième condition d'arrêt — la résorber veut dire corriger une spec, ce qu'un
  agent ne peut pas faire.

- **Installing on a project** — « ce qui subsiste n'appartient pas au plugin : il n'est ni
  déplacé, ni supprimé » n'est vrai qu'**en dehors de `specs/` et `plans/`**. Le
  balayage `find "$from" -depth -type d -exec rmdir {} +` supprime un répertoire
  étranger vide placé sous `docs/superpowers/specs/`, et un fichier étranger déposé
  là est déplacé vers `docs/archive/specs/`. Borner la phrase suffirait ; changer le
  code serait l'autre sortie, et c'est ce choix qui rend la décision humaine.
  Consolidée par la clôture du lot 02, depuis l'`Observed drift` d'une de ses
  stories. Classée en *gap* et non en *violation* : la spec y a tort et le code y
  a raison, si bien qu'un lot correctif qui la prendrait buterait aussitôt sur la
  cinquième condition d'arrêt — la résorber veut dire corriger une spec, ce qu'un
  agent ne peut pas faire.

- **Code under a feature flag** — la clause qui clôt la section, « Le code gardé
  **est écrit de sorte que** lever le flag se réduise à supprimer le branchement et
  le comportement d'avant le lot », prescrit une manière d'écrire le code, là où
  `The spec document` pose qu'une spec dit le métier et jamais le mécanisme. Elle
  échoue au test que la spec s'impose à elle-même : un développeur ayant implémenté
  la même intention avec un branchement plus lourd ne lirait pas cette phrase comme
  vraie de son code. Les quatre règles qui la précèdent y survivent — elles portent
  sur ce que l'utilisateur observe —, c'est la cinquième qui porte sur la forme du
  code. Relevée par la story `06-us-1-le-code-garde`, qui l'a transcrite telle
  quelle : le texte avait été validé au gate d'ouverture du lot 06, il est depuis la
  spec, et corriger une spec est un acte humain. Résorber veut dire reformuler la
  clause en termes de ce que la levée doit pouvoir faire, et c'est cette décision
  qui est humaine — d'où le classement en *gap*.

- **Code under a feature flag / The user story document** — les quatre règles sont
  écrites en entier à un seul endroit, `writing-a-user-story`, et trois
  reformulations partielles en circulent ailleurs sans que rien ne les y rattache :
  le renvoi de la doctrine du flag dans `using-batches`, une ligne `Red Flags` de la
  même skill, et une troisième formulation de la règle du registre des flags. Aucune
  spec ne dit ce qu'une glose doit à son texte canonique, ni combien de
  reformulations partielles d'une même règle un module tolère. La division « écrit
  en entier à un seul endroit, désigné ailleurs » tient aujourd'hui parce qu'aucune
  de ces gloses n'est une reformulation complète, mais rien ne la soutient : une
  glose peut dériver de son texte canonique sans que quoi que ce soit le signale, et
  un lecteur se fier à la mauvaise. Relevée puis parquée par la story
  `06-us-1-le-code-garde`.

- **The spec document / The gaps register** — ce que le test de l'autre
  implémentation éjecte d'une spec, et qui n'est le gap d'aucun module, n'a
  aucune sortie. Une décision d'ingénierie qui vaut pour tout le projet et
  qu'aucune frontière de module ne rend observable échoue au test, part donc au
  gaps register, où la catégorie *Gaps* promet qu'un lot ordinaire « les spécifie
  enfin » — lot qui réappliquerait le test et l'éjecterait de nouveau. La boucle
  se referme : rien ne dit où une telle décision vit, ni ce qui l'en sort. Le
  dépôt `charlouze/beacon-hosting`, qui consomme ce plugin, a tranché tout seul en
  rangeant ce genre de décision dans son `CLAUDE.md`, hors de toute spec.
  Constatée par la story `05-us-1-le-domicile-d-une-regle`, dont le lot a
  explicitement laissé ce cas hors de son périmètre. **Gap et non violation :**
  les deux règles sont implémentées fidèlement, c'est leur conjonction qui est
  muette ; résorber veut dire décider ce que la spec doit dire, et cette décision
  est humaine.

- **The spec document** — la règle « un renvoi nomme la section qu'il vise » n'est
  écrite dans aucune spec, et rien n'attrape un renvoi par la position. Le lot 01
  a été ouvert sur ce principe et a livré deux gardes, mais celle qui traque les
  renvois ne cherche que les renvois **numérotés** (`section N`, `§N`,
  `(spec N.N)`) ; un renvoi qui désigne sa cible par sa place — « le second membre
  de la même phrase », « le paragraphe qui précède » — passe au travers. La règle
  ne se lit aujourd'hui que dans une ligne de changelog, que la spec range en
  commodité de lecture dont aucune règle ne dépend, et dans les `Constraints` d'un
  lot, qui ne lient que ses propres stories. Ce que ce silence coûte se voit à
  l'usage : un renvoi par la position se recible tout seul quand un paragraphe
  s'insère avant lui, sans que personne n'édite la phrase, et il perd sa cible
  quand elle disparaît. La règle générale vaudrait pour les skills, les specs et
  les documents de lot, et déborde donc la section qui l'accueillerait.
  Constatée par la story `05-us-1-le-domicile-d-une-regle`, puis rangée hors
  périmètre par son lot, qui n'a tranché que le cas du gaps register. **Gap et non
  violation :** il n'y a pas de norme à faire respecter, il y a une norme à
  écrire, et l'écrire est un acte humain.

- **Language** — la section énonce que « le plugin lui-même est intégralement
  anglais — skills, commandes, README, bloc d'instructions, messages », et rien ne
  dit si le tiret illustre ou délimite : ni `tests/` ni `scripts/` n'y figurent.
  La convention réelle est pourtant sans exception — aucun fichier de ces deux
  répertoires ne portait de commentaire en français —, mais la phrase ne la
  garantit pas. Ce que ce silence coûte s'est vu : un plan de story a prescrit du
  français dans `tests/`, une revue de tâche l'a laissé passer, et c'est la revue
  de branche qui l'a relevé. Constatée par la story
  `05-us-3-une-entree-se-lit-seule`. **Gap et non violation :** le code respecte
  la règle générale, c'est la phrase qui ne dit pas si sa liste illustre ou
  délimite ; trancher veut dire décider ce que la spec doit dire, et cette
  décision est humaine.
