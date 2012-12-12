Le membre en charge de cette partie était Thomas Kostas

> *Boredom is not an end-product, is comparatively rather an early stage in life
> and art. You've got to go by or past or through boredom, as through a filter,
> before the clear product emerges.*

> -- F. Scott Fitzgerald

### Chargement de l'image

Nous avons fait le choix d'utiliser la bibliothèque SDL pour le traitement de
notre image et toute les opérations qui suivent celui-ci. Nous avons choisi
cette bibliothèque car elle était bien documentée et car nous avions appris à la
manipuler en TP.

Ce choix a été aussi motivé par le fait que la documention présente sur
internet est assez complête. En effet c'est une bibliothèque très utilisée dans
le monde de la création d'applications multimédias en deux dimensions comme les
jeux vidéo, les démos graphiques, les émulateurs, etc. Sa simplicité, sa
flexibilité, sa portabilité et surtout sa licence GNU LGPL contribuent à son
grand succès. Elle est de plus considérée comme un outil suffisamment simple, et
est souvent conseillée aux programmeurs débutants pour commencer dans le monde
de la programmation multimédia.

![Logo](images/SDL_logo.png)

### Passage en niveau de gris

L'image que l'on doit traiter est tout d'abord chargée sous forme d'une SDL
surface. Cette SDL surface est accessible à la manière d'une matrice. Une des
fonctionnalités de SDL nous permet d'accéder à la valeur RGB (red, green, blue)
de chaque pixel.

Pour opérer le passage en niveau de gris nous multiplions chaque composante de
ce triplet par des valeurs spécifiques :

- le rouge est multiplié par $0.3$
- le vert est multiplié par $0.59$
- le bleu est multiplié par $0.11$
\vspace{0.5cm}
Ces formules rendent compte de la manière dont l’œil humain perçoit les trois
composantes, rouge, vert et bleu, de la lumière. Pour chacune d'elles, la somme
des 3 coefficients vaut 1. On remarquera la forte inégalité entre ceux-ci : une
lumière verte apparaît plus claire qu'une lumière rouge, et encore plus qu'une
lumière bleue.
\vspace{0.5cm}

Une fois ces multiplications effectuées nous additionnons le résultat puis nous
le divisons par 255. Cette opération nous donne le niveau de gris du pixel
étudié.

Nous appliquons cette opération à chaque pixel de l'image en entrée et nous
plaçons le résultat dans une matrice de même taille que l'image. Nous avons
fait le choix de placer ces valeurs dans une matrice pour un accès plus rapide
par la suite et cela nous évite aussi la création de multiple SDL Surfaces.

À la suite de cette étape, nous avons en mémoire une matrice contenant le
niveau de gris de chaque pixel. Si l'on créait un SDL surface contenant en
chaque pixel (en rgb) les valeurs de la matrice obtenue, nous obtiendrons une
image en niveau de gris.

![Image en niveau de gris](images/gris.jpg)

### Filtrage de l'image

Pour la réalisation de cette partie la majorité du travail à été axé sur la
recherche. En effet il nous fallait un algorithme permettant efficacement de
supprimer les bruits d'une image sans en altérer le contenu. L'algorithme qui
nous à paru le plus efficace parmi ceux dont la difficulté de compréhension
n'était pas trop grande est le filtre médian.

Le filtre médian que nous avons implémenté s'applique sur une fenêtre de 9
pixels. En effet la fonction de passage en niveaux de gris nous permet
d'obtenir un tableau contenant la valeur en niveau de gris de chaque pixel. Sur
cette matrice, pixel par pixel, nous analysons les valeurs des pixels entourant
le courant (celui que nous désirons filtrer) Toutes les valeurs sont récupérées
puis triées dans un vecteur. L'élément médian de ce vecteur sera la nouvelle
valeur du pixel filtré.

\vspace{0.5cm}

Voici le fonctionnement de l'algorithme :

On a la matrice de l'image donc chaque case est symbolisée ainsi : (colonne,
ligne), et le pixel analysé en $(x, y)$ dans la matrice de l'image.

On s'intéresse au niveau de gris des pixels en ces positions :

- $(x, y)$
- $(x-1, y-1)$
- $(x, y-1)$
- $(x+1, y-1)$
- $(x-1, y)$
- $(x+1, y)$
- $(x-1, y+1)$
- $(x, y+1)$
- $(x+1, y+1)$

Ces valeurs de niveaux de gris sont enregistrés dans un tableau. Ce tableau est
trié et l'élément médian de cette énumération se trouvera en cinquième position
du tableau. La valeur du pixel en position (x, y) sera alors fixé à cette valeur
médiane.

Ce filtrage est satisfaisant pour le traitement de texte. En effet les textes
exploités par un logiciel de reconnaissance de caractére sont rarement de
mauvaise qualité.

Nous pouvons ici observé une image filtré par ce procédé

![Image non filtré](images/bruit.jpg)
![Image filtré](images/filtre.jpg)

### Binarisation de l'image

#### Première méthode de binarisation

La qualité de cette étape est essentielle pour la suite des opérations que va
subir l'image car tout les algorithmes appliqués par la suite sur celle-ci
seront faits sur sa représentation binaire.

La grande difficulté de cette réalisation est le choix du seuil de
binarisation, c'est à dire que si un pixel est au dessus d'une valeur alors il
est fixé à blanc. Dans le cas contraire le pixel est considéré comme noir. Nous
avons essayé plusieurs méthodes de calcul du seuil de binarisation mais aucune
n'a été concluante et la plupart du temps étaient moins efficaces qu'un seuil
fixé. Nous avons donc choisi de fixer le seuil de binarisation.

La fonction nous permettant de binariser l'image n'utilise pas de SDL Surface
mais rend plutôt une matrice de booléens ("vrai" quand le pixel est blanc et
"faux" quand il est noir).

voici des exemples d'images binarisé par le biais de cette méthode

![Image en niveau de gris](images/prebin.jpg)!

![image binaire](images/postbin.jpg)

#### Méthode actuelle de Binarisation

La méthode que nous utilisions pour la binarisation lors de la première
soutenance ne nous satisfaisait pas dans la mesure où elle n'était pas auto
adaptative. En effet pour chaque image, peut importe le niveau de gris de
celle-ci, le seuil restait toujours le meme. Nous avons donc du explorer de
nouvelles methodes afin d'effectuer la binarisation de l'image. Nos recherches
nous ont orienté sur deux méthode differente, la binarisation par seuil locale
et enfin la binarisation par le biais de l'algorithme de Sauvola.

##### Binarisation par seuil locale

Le principe du seuillage local est d'utiliser un voisinage centré sur le pixel
considéré pour déterminer quel seuil utiliser. Cette fenêtre peut avoir
différentes tailles, souvent en fonction de la taille moyenne du texte dans le
document. Le premier à proposer une technique donnant de bons résultats fut
Bernsen en 1986. Plus formellement la formule peut s'écrire de cette manière :

- Soit P la largeur de la fenetre étudiée.
- Soit Q la hauteur de la fenetre étudié.
- Soit S(i,j) le seuil appliqué au pixel de coordonnées I,J.
- Soit Max(i,j) la valeur du niveau de gris maximal centré dans une fenetre centré en i,j de Taille P * Q.
- Soit Min(i,j) la valeur du niveau de gris minimal centré dans une fenetre centré en i,j de taille P * Q.

S(i,j) = (Max(i,j)+Min(i,j))/2

Nous avons fait le choix d'implémenter ce filtre sur des fenetres carrées de 9
pixels.  Pour réaliser cela il nous faut tout d'abord récuperer les pixels
voisin du pixel étudié a savoir les pixels suivants :

- $(x, y)$
- $(x-1, y-1)$
- $(x, y-1)$
- $(x+1, y-1)$
- $(x-1, y)$
- $(x+1, y)$
- $(x-1, y+1)$
- $(x, y+1)$
- $(x+1, y+1)$

Parmis ces pixels, pour réussir à determiner le seuil, il nous faut en extraire
celui ayant la plus petite valeur de niveau de gris et celui ayant la plus
grande. Pour effectuer cela nous avons choisi de stocker les valeurs de niveaux
de gris de ces pixels dans un vecteur de taille adapté et de trié ce dernier en
ordre croissant. Ainsi, pour obtenir la valeur maximale et la valeur minimale
nous n'avions plus qu 'a récuperer la valeur contenue dans la dernière et la
première case de ce vecteur (respectivement). La moyenne de ces deux valeurs
nous donnait alors le seuil à appliquer au point de coordonées (i,j). Ce procédé
est appliqué à toute la matrice afin de fournir une matrice de booléen
permettant de savoir si le pixel de coordonée (i,j) est noir ou blanc.
Cependant pour les bords de la matrice nous avons été dans l'obligation
d'utiliser la bianrisation par seuillage local.

Exemple de binarisation par seuillage globale :

![Image en niveau de gris](images/preloc.jpg)

![image binarisé par seuillage local](images/postloc.jpg)

L'implémentation de cette méthode nous montre que les résultats obtenues sont
loin d'etre ceux désiré. Cela peut s'expliquer par le fait que les images aux
nombreux niveau de gris supportent mal ce type de filtre. Sur certains textes
obtenus par des scanners de mauvaise qualité nous obtenions des résultats
identiques. Nous avons donc abandonné cette méthode mais jugions nécessaire de
la présent car elle a été une étape de notre cheminement vers une binarisation
de qualité

##### Binarisation par la méthode de Sauvola

En 1986 Niblack proposa une méthode de binarisation. Cette méthode calcule un
seuil local d'une manière beaucoup plus complique que celle présenté
précédemment. Seul le calcul du seuil change a travers toutes ces méthodes. Une
fois le seuil local calculé, on l'applique au pixel étudié pour determiner sa
couleur dans l'image binaire.

Formule de la méthode de Niblack:

- Soit P la largeur de la fenetre étudiée.
- Soit Q la hauteur de la fenetre étudié.
- Soit S(i, j) le seuil appliqué au pixel de coordonnées I, J.
- Soit d(i, j) la valeur de l'écart type dans une fenetre centré en i, j de taille N*M.
- Soit u(i, j) la valeur des niveux de gris dans une fenetre centré en i, j de taille N*M.
- Soit k une constant fixé à 0.2 $

S(i, j) = u(i, j)+ k * d(i, j)

En 2000 Sauvola apporte une amélioration à cette méthode permettant de la rendre
plus précise. Grace à cette évolution, la méthode devient aussi plus adapté à la
binarisation de texte

Formule de la méthode de Sauvola:

- Soit P la largeur de la fenetre étudiée.
- Soit Q la hauteur de la fenetre étudié.
- Soit S(i, j) le seuil appliqué au pixel de coordonnées I, J.
- Soit d(i, j) la valeur de l'écart type dans une fenetre centré en i, j de taille N*M.
- Soit u(i, j) la valeur des niveux de gris dans une fenetre centré en i, j de taille N*M.
- Soit k une constante fixé à 0,2.
- Soit une constante R permettant d'ajuster la dynamique de l'écart type (fixé en général à 128).

S(i, j) = u(i, j)* (1+k * ((d(i, j)/R) - 1))

Cette méthode plus complexe que celle utilisée lors de la première soutenance
est aussi plus efficace malgré le fait qu'elle soit plus longue à appliquer.
Ici nous utlisons la méthode de Sauvola dans des matrice de 5 * 5 pixels. On
peut ici observer le résultat de cette méthode:

![Texte avant la binarisation](images/presauvo.jpg)

![Texte après la binarisation](images/postsauvo.png)

### Filtre supplémentaire

#### Filtre de lissage post rotation

Lorsque la rotation est effectué il arrive parfois que des pixels se retrouvent
à des places qu'ils ne devraient pas occuper "naturellement" (si l'image était
droite). Pour remédier à ce soucis nous avons créé un filtre de lissage
permettant d'avoir un meilleur rendu. Ce filtre prend une fenetre de 9 pixels
dans l'image, si les pixels voisins au pixel etudié sont au moins quatres à
etre noirs alors ce pixel devient noir dans une nouvelle matrice (pour ne pas
affecter le résultat sur les pixels voisins) ce principe s'applique ainsi a tous
les pixels de l'image.

![Ici le pixel centrale restera blanc](images/3.jpg)

![Ici le pixel centrale deviendra noire](images/8.jpg)

![Texte avant lissage](images/prelis.jpg)

![Texte après lissage](images/postlis.png)

#### Filtre de détection des contours de caractères
Lors de nos travaux de traitement d'image nous avons eu l'idée de créer un
filtre. Ce filtre ne porte pas de nom car il est de notre propre création. Cet
algorithme permet de faire ressortir le contour des caractères en noir à la
manière d'un laplacien. Cela donne de très bons résultats.

![CavatOCR, le compagnon idéal, en toutes circonstances.](images/biatch4.jpg)
