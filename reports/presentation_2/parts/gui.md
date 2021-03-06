### Bases

L'interface graphique ou GUI, de l'anglais graphical user interface, est la
partie visible du projet. C'est avec elle qu'interagit l'utilisateur.  Elle
n'est pas necessaire sous linux, car ce sont principalement des vrais mecs a
barbe qui n'ont besoin que de lignes de commandes, mais l'interface graphique
est un plus non negligable pour le projet, et sa possible exportation sur
d'autres plateformes.  Les debut de l'interface graphique se trouve dans la
Xerox Star, qui est un ordinateur créé par Xerox en 1981. C'est une station
de travail destinée à être utilisée pour du travail de bureau par des
utilisateurs occasionnels. Ces utilisateurs sont des employés de bureau,
contrairement à la majorité des utilisateurs, qui, en 1981, sont des
informaticiens. L'utilisation de cet ordinateur consiste à imiter le travail
de bureau, les symboles à l'écran font analogie à des objets familiers de
ce type d'activité, tels que dossiers, documents, classeurs, calculatrice et
machine à écrire. Cette interface est techniquement plus coûteuse, mais
rend l'ordinateur beaucoup plus simple d'emploi. La creation de notre interface
nous a ouvert de nombreux choix comme faire l'interface directement dans la
console sans gestion de la sourie comme celle du minitel ou une interface plus
classique et moderne.  Les quelques recherches faites nous ont mene sur les
bibliotheques GTK, GTK+ et lablGTK qui permettent de creer facilement des
interfaces "user friendly" agreables et epurees.  L'utilisation de la sourie
permet donc d'eviter de devoir apprendre un lexique et une syntaxe de commande
propre a notre programe, et aussi d'eviter les erreurs de dactylographie.  Nous
avons donc décidé de faire une interface graphique a l'aide de GTK et lablGTK

Le principe de création de notre interface est donc d'avoir une fenetre
pouvant etre reduite ou agrandie contenant des boutons ayant des icones,
pictogrammes ou logos representatif pour que a partir du visuel uniquement, la
manipulation soit simple et ergonomique. La communication entre la machine et
l'humain se fait donc de la meme maniere qu'entre deux humains, le dialogue est
facilité et les erreurs possibles sont prise en compte, comme par exemple
tenter de binariser une image non existante.

### Premier jets

![L'interface finale](images/gui_1.png)

Le tout premier jet etait plus un test de l'utilisation de GTK qu'une réel
tentative d'interface construite. Elle possede tout de meme les principales
bases de l'interface finale, c'est a dire le bouton pour charger une image, et
celui pour la traiter. Cependant l'image n'est pas affichée et l'utilisateur
n'est pas assuré qu'il extrait la bonne.

### Premiere soutenance

Lors de la premiere soutenance la partie graphique de l'interface etait presque
finie, elle ressemblait a cela:

![L'interface finale](images/gui_2.png)

Cependant toute la partie "active" n'existait pas et restait a créer

### Evolution de l'interface

L'interface a été allégée et le code réorganisé et correctement
commenté. Le probleme de l'interface etait aussi l'interface entre le choix de
l'image par l'utilisateur et cela pose quelques probelemes de fonctionement
interne qui seront resolu pour la version finale.

![L'interface finale](images/gui_3.png)

### L'interface finale

L'interface finale comporte tout dans sa simplification la plus totale, elle est
composée de la version precedente epurée d'un bouton avec en sortie le texte
dans une fenetre de type "pop up"

![L'interface finale](images/gui_4.png)

