Le membre en charge de cette partie du projet était Antoine Pietri

> *A good rotation. A rotation I define as the experiencing of the new beyond
> the expectation of the experiencing of the new.*

> -- Walker Percy

\vspace{0.5cm}

Le but du projet est de récupérer le texte d'images scannées. Il est donc très
probable que les images passées en entrée ne soient pas complètement droites.

La détection des blocs et la reconnaissance de caractères se base sur le
principe que l'image en entrée est parfaitement droite, ce qui est peu
probable.

Pour pallier ce problème, nous avons décidé de mettre en place un algorithme de
détection d'angle et de rotation.

### Détection d'angle d'inclinaison

Il y a plusieurs méthode de détection d'angle d'inclinaison dans un texte. Nous
avons réfléchi longuement pour déterminer laquelle était la plus efficace, et
nous en avons tiré un algorithme extrèmement efficace.

Le principe repose sur un tracé d'histogramme selon un certain angle. Pour
chaque angle, nous traçons des lignes séparées par un certain nombre de pixels
(10 est un nombre qui donne des résultats plutôt satisfaisants) selon un
certain angle, et nous comptons le nombre de pixels sur chaque ligne.

Si l'angle est bon, les lignes traverseront un nombre élevé de pixels (lignes
pleines de caractères) ou un nombre très faible (lignes vides).

Pour savoir à quel point l'angle est bien choisi, on calcule la variance du
nombre de pixels noirs pour chaque ligne. On prend ensuite l'angle dont la
variance est la plus élevée :

$$max({\sum_{n=0}^{N} (n_{\alpha} - \text{average}_{\alpha}) ~~ 
\forall \alpha \in [\text{range}]})$$

Pour gagner en performances, nous faisons tout d'abord une première passe pour
tous les angles entre -30\degres et 30\degres.

![Exemple d'histogramme tracé selon un angle bien
choisi](images/threelines2.png)

![Histogramme correspondant avec une variance très
élevée](images/threeproj.png)

![Exemple d'histogramme tracé selon un mauvais angle](images/zerolines2.png)

![Variance beaucoup plus faible du mauvais histogramme](images/zeroproj.png)


\newpage

### Rotation

Une fois que l'on a trouvé l'angle de rotation, il reste bien sûr à faire
tourner l'image selon cet angle.

La première chose à faire est de calculer les dimensions de l'image une fois
tournée. Ces dimensions sont données par la formule suivante, que l'on peut
retrouver très simplement avec quelques notions de trigonométrie basique :

$$
\left\{\begin{matrix}w = (w_o cos(\alpha) + h_o sin(\alpha))
\\h = (h_o cos(\alpha) + w_o sin(\alpha))
\end{matrix}\right.
$$

Ensuite, pour chaque pixel dans l'image de sortie, nous calculons la position
du pixel correspondant sur l'image d'entrée. Ce calcul se fait encore une fois
avec un peu de trigonométrie. Nous faisons tourner l'image selon son centre.

$$
\left\{\begin{matrix}
x_o =
(cos(\alpha) \times (x - x_{center}) +
sin(\alpha) \times (y - y_{center}))
+ x_{center} \\
y_o =
(- sin(\alpha) \times (x - x_{center}) +
cos(\alpha) \times (y - y_{center}))
+ y_{center}\end{matrix}\right.
$$

Si les coordonées obtenues ne dépassent pas les limites de l'image d'origine,
alors on copie le pixel d'origine dans le pixel correspondant sur l'image de
sortie.

