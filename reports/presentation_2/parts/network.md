### Principe de base

Une des principales composantes de notre OCR est le réseau de neurones, qui
sert à reconnaître les caractères.

Un réseau de neurones artificiels est un modèle de calcul dont la conception
est très schématiquement inspirée du fonctionnement des neurones biologiques.

Les réseaux de neurones sont généralement optimisés par des méthodes
d’apprentissage de type probabiliste, en particulier bayésien. Ils sont placés
d’une part dans la famille des applications statistiques, qu’ils enrichissent
avec un ensemble de paradigmes 1 permettant de créer des classifications
rapides (réseaux de Kohonen en particulier), et d’autre part dans la famille
des méthodes de l’intelligence artificielle auxquelles ils fournissent un
mécanisme perceptif indépendant des idées propres de l'implémenteur, et
fournissant des informations d'entrée au raisonnement logique formel.

Notre réseau de neurones est composé d'une succession de couches dont chacune
prend ses entrées sur les sorties de la précédente. Chaque couche (i) est
composée de Ni neurones, prenant leurs entrées sur les Ni-1 neurones de la
couche précédente. À chaque synapse est associée un poids synaptique, de sorte
que les Ni-1 sont multipliés par ce poids, puis additionnés par les neurones de
niveau i, ce qui est équivalent à multiplier le vecteur d'entrée par une
matrice de transformation. Mettre l'une derrière l'autre les différentes
couches d'un réseau de neurones reviendrait à mettre en cascade plusieurs
matrices de transformation et pourrait se ramener à une seule matrice, produit
des autres, s'il n'y avait à chaque couche, la fonction de sortie qui introduit
une non linéarité à chaque étape. Ceci montre l'importance du choix judicieux
d'une bonne fonction de sortie : un réseau de neurones dont les sorties
seraient linéaires n'aurait aucun intérêt.

Notre réseau est un réseau de type MLP (Multi-Layer Perceptron) qui calcule une
combinaison linéaire des entrées, c’est-à-dire que la fonction de combinaison
renvoie le produit scalaire entre le vecteur des entrées et le vecteur des
poids synaptiques.

Notre fonction d'activation est une fonction sigmoïde, qui introduit une
non-linéarité dans le fonctionnement du neurone.

### Rétropropagation

Pour l'apprentissage des neurones, nous utilisons la méthode de
rétropropagation du gradient.

C'est une méthode qui permet de calculer le gradient de l'erreur pour chaque
neurone d'un réseau de neurones, de la dernière couche vers la première.

Ce principe fonde les méthodes de type algorithme du gradient, qui sont
efficacement utilisées dans des réseaux de neurones multicouches comme les
perceptrons multicouches (MLP pour « multi-layers perceptrons »). L'algorithme
du gradient a pour but de converger de manière itérative vers une configuration
optimisée des poids synaptiques. Cet état peut être un minimum local de la
fonction à optimiser et idéalement, un minimum global de cette fonction (dite
fonction de coût).

#### Algorithme

Les poids dans le réseau de neurones sont au préalable initialisés avec des
valeurs aléatoires(val a). On considère ensuite un ensemble de données qui vont
servir à l'apprentissage. Chaque échantillon possède ses valeurs cibles qui
sont celles que le réseau de neurones doit à terme prédire lorsqu'on lui
présente le même échantillon. L'algorithme se présente comme ceci : 

* Soit un échantillon $\vec{x}$ que l'on met à l'entrée du réseau de
* neurones et la sortie recherchée pour cet échantillon $\vec{t}$
* On propage le signal en avant dans les couches du réseau de neurones :
* $x_k^{(n-1)}\mapsto x_j^{(n)}$
* La propagation vers l'avant se calcule à l'aide de la fonction d'activation
* $g$, de la fonction d'agrégation $h$ (souvent un
* produit scalaire entre les poids et les entrées du neurone) et des poids
* synaptiques $\vec{w}_{jk}$ entre le neurone
* $x_k^{(n-1)}$ et le neurone $x_j^{(n)}$. Attention au
* passage à cette notation qui est inversée, $\vec{w}_{jk}$ indique
* bien un poids de $k$ vers $j$.

$$x_j^{(n)} = g^{(n)}(h_j^{(n)}) = g^{(n)}(\sum_k
w_{jk}^{(n)}x_k^{(n-1)})$$

* Lorsque la propagation vers l'avant est terminée, on obtient à la sortie le
* résultat $\vec{y}$
* On calcule alors l'erreur entre la sortie donnée par le réseau
* $\vec{y}$ et le vecteur $\vec{t}$ désiré à la sortie
* pour cet échantillon. Pour chaque neurone $i$ dans la couche de
* sortie, on calcule :

$$e_i^{sortie} = g'(h_i^{sortie})[t_i - y_i]$$

(g' est la dérivée de g)

* On propage l'erreur vers l'arrière $e_i^{(n)} \mapsto e_j^{(n-1)}$
* grâce à la formule suivante :

$$e_j^{(n-1)} = g'^{(n-1)}(h_j^{(n-1)})\sum_i w_{ij}e_i^{(n)}$$

* On met à jour les poids dans toutes les couches :

$$\Delta w_{ij}^{(n)} = \lambda e_i^{(n)}x_j^{(n-1)}$$ où
$\lambda$ représente le taux d'apprentissage (de faible magnitude et
inférieur à 1.0)

Pour éviter les problèmes liés à une stabilisation dans un minimum local, on
ajoute un terme d'inertie (momentum). Celui-ci permet de sortir des minimums
locaux dans la mesure du possible et de poursuivre la descente de la fonction
d'erreur. À chaque itération, le changement de poids conserve les informations
des changements précédents. Cet effet de mémoire permet d'éviter les
oscillations et accélère l'optimisation du réseau. Par rapport à la formule de
modification des poids présentée auparavant, le changement des poids avec
inertie au temps $t$ se traduit par : 

$$\Delta w_{ij}^{(n)}(t) = \lambda e_i^{(n)}x_j^{(n-1)} + \alpha \Delta
w_{ij}^{(n)}(t-1)$$

avec $\alpha$ un paramètre compris entre 0 et 1.0.

