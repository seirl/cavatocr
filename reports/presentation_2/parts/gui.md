#L'interface graphique
##Bases
###L'interface graphique ou GUI, de l'anglais graphical user interface, est la partie visible du projet.
C'est avec elle qu'interagit l'utilisateur.
Elle n'est pas necessaire sous linux, car ce sont principalement des vrais mecs a barbe qui n'ont besoin que de lignes de commandes, mais l'interface graphique est un plus non negligable pour le projet, et sa possible exportation sur d'autres plateformes.
Les debut de l'interface graphique se trouve dans la  Xerox Star, qui est un ordinateur cre\'e\' par Xerox en 1981. C'est une station de travail destine\'e a\' e\^tre utilise\'e pour du travail de bureau par des utilisateurs occasionnels. Ces utilisateurs sont des employe\'s de bureau, contrairement a\' la majorite\' des utilisateurs, qui, en 1981, sont des informaticiens. L'utilisation de cet ordinateur consiste a\' imiter le travail de bureau, les symboles a\' l'e\'cran font analogie a\' des objets familiers de ce type d'activite\', tels que dossiers, documents, classeurs, calculatrice et machine a\' e\'crire. Cette interface est techniquement plus cou\^teuse, mais rend l'ordinateur beaucoup plus simple d'emploi.
###La creation de notre interface nous a ouvert de nombreux choix comme faire l'interface directement dans la console sans gestion de la sourie comme celle du minitel ou une interface plus classique et moderne.
Les quelques recherches faites nous ont mene sur les bibliotheques GTK, GTK+ et lablGTK qui permettent de creer facilement des interfaces "user friendly" agreables et epurees.
L'utilisation de la sourie permet donc d'eviter de devoir apprendre un lexique et une syntaxe de commande propre a notre programe, et aussi d'eviter les erreurs de dactylographie.
Nous avons donc de\'cie\' de faire une interface graphique a l'aide de GTK et lablGTK
###Le principe de cre\'ation de notre interface est donc d'avoir une fenetre pouvant etre reduite ou agrandie contenant des boutons ayant des icones, pictogrammes ou logos representatif pour que a partir du visuel uniquement, la manipulation soit simple et ergonomique. La communication entre la machine et l'humain se fait donc de la meme maniere qu'entre deux humains, le dialogue est facilite\' et les erreurs possibles sont prise en compte, comme par exemple tenter de binariser une image non existante.
##Premier jets
###//image
###Le tout premier jet etait plus un test de l'utilisation de GTK qu'une re\'el tentative d'interface construite. Elle possede tout de meme les principales bases de l'interface finale, c'est a dire le bouton pour charger une image, et celui pour la traiter. Cependant l'image n'est pas affiche\'e et l'utilisateur n'est pas assure\' qu'il extrait la bonne.
##Premiere soutenance
###Lors de la premiere soutenance la partie graphique de l'interface etait presque finie, elle ressemblait a cela:
###//image
###Cependant toute la partie "active" n'existait pas et restait a cre\'er
##Evolution de l'interface
###L'interface a e\'te\' alle\'ge\'e et le code re\'organise\' et correctement commente\'. Le probleme de l'interface etait aussi l'interface entre le choix de l'image par l'utilisateur et cela pose quelques probelemes de fonctionement interne qui seront resolu pour la version finale.
###//image
### 
