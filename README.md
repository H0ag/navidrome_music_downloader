# YouTube downloader for Navidrome
J'ai fais ce script en Pascal à la fois pour m'entrainer à l'apprentissage de ce language + automatiser le telechargement et le rangement des musiques YouTube pour navidrome, proprement.

## Language :
- [Pascal](https://www.freepascal.org/)

## Compilation
Pour compiler le script, j'utilise `fpc` (Free Pascal Compiler).

```bash
fpc ./main.pas
```
**Execution:**
```bash
./main
```

## Logique
- Recuperer les infos : 
    - L'URL de la video/playliste YouTube.
    - Le nom de l'artiste.
    - Le nom de l'album.

- Creer un repertoire temporaire dans le `/tmp` pour stocker temporairement les musiques
    - S'il existe pas, il le créer

- Ensuite, j'utilise la commande [`yt-dlp`](https://github.com/yt-dlp/yt-dlp/releases/) pour telecharger les videos depuis YouTube.

- Sur toutes ces musiques dans le dossier temporaire, j'applique la commande `id3v2` pour changer les metadonnées. J'ajoute :
    - Nom de l'album
    - Nom de l'artiste

- Quand c'est fait, je créer le dossier de l'album. Qui est BASE/ARTISTE/ALBUM
- Et je deplace toutes ces musiques du dossier temporaire vers ce dossier.