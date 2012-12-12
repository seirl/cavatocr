### Bot irc

Pour nous assister tout au long de cette aventure, nous avons mis en place un
bot irc, véritable mascotte du groupe. Ce bot est capable de plusieurs
fonctionnalités :

#### Raccourcisseur d'URL

La plupart des membres du groupe utilisent massivement IRC, et ce dans un
terminal qui détecte tout seul les liens. Le problème est quand le lien est trop
grand et s'affiche sur deux lignes, le client irc perturbe la ligne et le
terminal ne peut plus détecter correctement le lien.

Nous avons donc implémenté le raccourcissement d'URL dans notre bot, celui-ci
créé automatiquement une redirection à base d'un hash de l'URL d'origine via un
serveur auquel nous avons accès, afin de fournir une URL équivalente nettement
plus courte.

#### Message d'arrivée

Quand notre bot se connecte sur notre canal de discussion, celui-ci relance la
motivation de chacun grace à une phrase aléatoire tirée d'une référence commune
: Kaeloo (qui est d'ailleurs le nom du bot).

#### Annonce des commits

La fonctionalité la plus intéressante que nous ayons ajouté à ce bot l'annonce
des commit. Celui-ci vérifie régulièrement sur notre dépot les derniers commits
et, s'il en repère un nouveau, l'annonce sur le canal en donnant le nom de
l'auteur, le hash de la version et le début du message de commit. Ceci nous
permet de nous synchroniser efficacement.
