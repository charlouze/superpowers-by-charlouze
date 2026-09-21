# Changelog

## [0.6.0](https://github.com/charlouze/superpowers-by-charlouze/compare/v0.5.0...v0.6.0) (2026-09-21)


### Features

* batch 08 us-1 — l'arbitrage ouvert ([#50](https://github.com/charlouze/superpowers-by-charlouze/issues/50)) ([a920477](https://github.com/charlouze/superpowers-by-charlouze/commit/a920477a6154135a64311c903dea1d4ea0ddac30))
* batch 08 us-2 — la destination d'un arbitrage ouvert ([#52](https://github.com/charlouze/superpowers-by-charlouze/issues/52)) ([f3798f5](https://github.com/charlouze/superpowers-by-charlouze/commit/f3798f54747a4ecb0571847e883eefa04c2457ba))
* batch 08 us-3 — le point de départ d'une branche ([#53](https://github.com/charlouze/superpowers-by-charlouze/issues/53)) ([ff96c5e](https://github.com/charlouze/superpowers-by-charlouze/commit/ff96c5e4ffccd62192c48c237c6aebc3e60ba452))
* ce qui qualifie une entrée du gaps register vit dans l'entrée ([cbd3e97](https://github.com/charlouze/superpowers-by-charlouze/commit/cbd3e97b0a457e287d166ef891403aec88102969))
* l'ouverture d'un lot énonce ses six étapes dans l'ordre ([8f1b340](https://github.com/charlouze/superpowers-by-charlouze/commit/8f1b34096d57699aa0c77ec0d9dcd6023233e29d))
* la clôture dit qu'elle est la borne du document de lot ([cf6882d](https://github.com/charlouze/superpowers-by-charlouze/commit/cf6882d1705d45745729c224567ad817ba0c6a73))
* la clôture lit le Rulings log autant que l'Observed drift ([e0af210](https://github.com/charlouze/superpowers-by-charlouze/commit/e0af2108bb840cfe62188754d196c8354f14c434))
* le conducteur instruit les constats avant de les soumettre ([1801978](https://github.com/charlouze/superpowers-by-charlouze/commit/1801978bf797096310d345388cb9cbcdd620200a))
* on n'ajoute pas une entrée sans savoir ce qui a déjà été écarté ([723adc3](https://github.com/charlouze/superpowers-by-charlouze/commit/723adc317a35b78e915d8a785ff0ce2025a8778f))
* quatre conditions arrêtent les tours de relecture ([cbaa14d](https://github.com/charlouze/superpowers-by-charlouze/commit/cbaa14dc735d1e10633d05f3e8f3490a886875fd))
* un arbitrage ouvert ne franchit pas la fusion sans destination ([1eac6c3](https://github.com/charlouze/superpowers-by-charlouze/commit/1eac6c3fb844eaa68d309de68d2a464b0334b788))
* un arbitrage ouvert se reconnaît à sa forme ([5c79236](https://github.com/charlouze/superpowers-by-charlouze/commit/5c79236c7f5442be37fc3f7ad9f636839dbc6ae1))
* un changement borné supprime une entrée au lieu de la barrer ([61716ba](https://github.com/charlouze/superpowers-by-charlouze/commit/61716ba13093e7ff15c6943797496d06790029fe))
* une adoption qui promeut un gap en retire l'entrée ([0e604cd](https://github.com/charlouze/superpowers-by-charlouze/commit/0e604cdd0c83c52079cfddd1f95d4fb314896f7d))
* une branche du flux part de main telle que le remote la porte ([39834e1](https://github.com/charlouze/superpowers-by-charlouze/commit/39834e1860a3d5bc074491879403607ecebd28e2))
* une entrée du gaps register ne renvoie à aucune autre ([ee0d29f](https://github.com/charlouze/superpowers-by-charlouze/commit/ee0d29f0bd2fefb03d8df1872f873011c756efeb))
* une entrée réglée quitte le fichier, et le commit dit pourquoi ([dd5f35c](https://github.com/charlouze/superpowers-by-charlouze/commit/dd5f35cf630e1fbecd593e52b7301dc1a4498548))
* une relecture emploie un lecteur par lecture ([5d41900](https://github.com/charlouze/superpowers-by-charlouze/commit/5d4190018c15389e5fe9bbc1f7734bc1da84bafc))
* une story corrective supprime l'entrée qu'elle résorbe ([1330fef](https://github.com/charlouze/superpowers-by-charlouze/commit/1330fef845bb6e905de8bd57025f9e09b55768d8))
* writing-a-batch conduit la relecture de cohérence avant d'ouvrir ([889425c](https://github.com/charlouze/superpowers-by-charlouze/commit/889425cce69444613bef183bebce012b0f3873ae))


### Bug Fixes

* la table des pièges de writing-a-batch admet la clôture ([9d1be9c](https://github.com/charlouze/superpowers-by-charlouze/commit/9d1be9c6159b3ad4ed5e0f72a3e283243ecbbbc1))

## [0.5.0](https://github.com/charlouze/superpowers-by-charlouze/compare/v0.4.0...v0.5.0) (2026-09-20)


### Features

* l'adoption s'arrête devant une règle qui déborde d'un module ([d77f144](https://github.com/charlouze/superpowers-by-charlouze/commit/d77f1442a6c866f831fa1e6b5fbb4d4e5875412f))
* l'agent n'approuve ni ne fusionne, et ne réécrit pas pendant la revue ([9bdf652](https://github.com/charlouze/superpowers-by-charlouze/commit/9bdf6528b9cc16f7ca4dc374474b917052811e09))
* la clôture aussi est un moment de vider le contexte ([64557d4](https://github.com/charlouze/superpowers-by-charlouze/commit/64557d41bf27ce33a807239f3916097d5a298639))
* la doctrine du flag renvoie aux règles du code gardé ([299b457](https://github.com/charlouze/superpowers-by-charlouze/commit/299b4574faacb0292c84250417648519445eb350))
* la fusion d'une revue est un moment de vider le contexte ([a9750e4](https://github.com/charlouze/superpowers-by-charlouze/commit/a9750e4d074f472771612b717e5dd9ad96a0da9b))
* la livraison est un moment de clear, la clôture n'en est pas un ([a32fb75](https://github.com/charlouze/superpowers-by-charlouze/commit/a32fb759ab823832e54b827efeb59f811f04f648))
* la revue d'adoption se termine sur un prompt qui se suffit ([e89c43f](https://github.com/charlouze/superpowers-by-charlouze/commit/e89c43f8b4759f6b6a5320428800cf6effa5cfef))
* le routage et l'Override 1 disent l'arrêt, pas l'enchaînement ([0109809](https://github.com/charlouze/superpowers-by-charlouze/commit/01098096257dc75f2fbb91a42eacdc758c818d0b))
* les règles du code gardé atteignent les Global Constraints ([fe0fc22](https://github.com/charlouze/superpowers-by-charlouze/commit/fe0fc22f52c1d7e3261bad07e57b8387462d95a7))
* les revues d'ouverture et d'amendement nomment leur étape suivante ([76c60b7](https://github.com/charlouze/superpowers-by-charlouze/commit/76c60b7824a650f3c3b62ccb88ac99d5dea3b5d2))
* on arrive à l'adoption dans un contexte neuf, et on en repart de même ([0d33596](https://github.com/charlouze/superpowers-by-charlouze/commit/0d33596fd7738dba984721a448d4c00cbeb9f0b4))
* un spec delta n'écrit pas la même règle dans deux specs ([e84111c](https://github.com/charlouze/superpowers-by-charlouze/commit/e84111cd7a98b07bc3d32886a829313b5a0ea785))
* une conception qui découvre un module non adopté s'arrête ([c64f7e4](https://github.com/charlouze/superpowers-by-charlouze/commit/c64f7e47fd512242ae09862f2be642f7cbac8d84))
* une période d'observation fait passer le défaut déclaré de off à on ([8a3bf82](https://github.com/charlouze/superpowers-by-charlouze/commit/8a3bf826d5eb5aa3b416608130af69763633f4e5))
* une règle appartient à une seule spec, et il n'y a pas de spec au-dessus des specs ([d5315df](https://github.com/charlouze/superpowers-by-charlouze/commit/d5315df725517dd24549bd61381171978edd0f2d))
* une règle qui déborde n'est pas un conflit que la règle d'autorité tranche ([88db380](https://github.com/charlouze/superpowers-by-charlouze/commit/88db380c977d9263146ca40ed28ea68f23daabf5))

## [0.4.0](https://github.com/charlouze/superpowers-by-charlouze/compare/v0.3.0...v0.4.0) (2026-09-20)


### Features

* ce qu'un lot annonce, ce sont des blocs, plus des intentions ([2edf8b3](https://github.com/charlouze/superpowers-by-charlouze/commit/2edf8b391c79d72b5cc88f8baed0aac62e2fc91c))
* l'en-tête d'une story déclare les blocs qu'elle transcrit ([113d92c](https://github.com/charlouze/superpowers-by-charlouze/commit/113d92cd5e6fab43c108ae62a375814a9d2dcb9b))
* la clôture constate les blocs non livrés depuis les champs Blocks: ([4a3c164](https://github.com/charlouze/superpowers-by-charlouze/commit/4a3c164906659c0d782378968f7784a2184ddfcb))
* la transcription est mot pour mot, et tout écart est nommé dans la PR ([4349c59](https://github.com/charlouze/superpowers-by-charlouze/commit/4349c5918987039587adf39852087152de54036a))
* le document de lot écrit son spec delta en blocs de texte exact ([edd4d1c](https://github.com/charlouze/superpowers-by-charlouze/commit/edd4d1c0cbbba3067b1d09fdc7701e6c89a539c2))
* le glossaire définit le bloc du spec delta ([1d2443a](https://github.com/charlouze/superpowers-by-charlouze/commit/1d2443a2238ce13ce8e01e4744061d7925bd6aa1))
* une story choisit les blocs du spec delta qu'elle transcrit ([d137f72](https://github.com/charlouze/superpowers-by-charlouze/commit/d137f72ffa3657cef796ec2cd3c6f07df492daa2))
