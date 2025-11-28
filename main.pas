{
    Ce programme, je l'ecris à but éducatif pour apprendre le Pascal.
    Je vais essayer de beaucoup commenter ce code pour plus tard.
}
// Il faut que je donne un nom à ce programme
program navidrome_musics_downloader;

// Ici j'importe des sortes de librairie pour utiliser certaines fonctions du systeme 
Uses
    sysutils, Process;

// En Pascal je dois definir touuuutes mes variables avant le debut du code, donc je defini pour plus tard
var
    // C'est cette fonction pour executer des programmes
    P: TProcess;
    // Ca c'est pour manipuler des fichiers
    SR: TSearchRec;
    
    // Ici j'vais stocker l'URL de la playlist/video youtube
    VIDEO_URL: string;
    // Ici j'vais mettre le nom de l'artiste à appliquer sur tout les fichiers
    ARTIST_NAME: string;
    // Ici je met le nom de l'album à appliquer à tout les fichiers
    ALBUM_TITLE: string;

    // Ca c'est le dossier temporaire où je vais stocker les fichiers recuperes temporairement pour appliquer les metadonnés
    TMP_DIR: string;
    // Ca c'est le user agent, que je vais donner à yt-dlp pour se faire passer par navigateur.
    USER_AGENT: string = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

    // L'emplacement de base des musiques navidrome
    MUSIC_DIR: string = '/mnt/navidrome/music/';
    // Ici je mettrai le chemin complet de l'album, donc le MUSIC_DIR + ARTIST + ALBUM
    ALBUM_DIR: string ;

// procedure Execute(params);
// begin
    
// end;

{
    En Pascal, le code principal se fait dans ces balises begin/end. C'est une sorte de bloc.
    Le end du code principal doit finit par "." mais les autres blocs dedans c'est ";".
}
begin
    {
        - Ici je vais ecrire un texte dans le terminal, sans retour à la ligne, en disant "Video URL: ".
        - Juste en dessous je peux dire "readln", ca va demander à l'utilisateur d'ecrire du texte.
            - Dans les parametres de read(), faut mettre la variable que ca va completer, où ca va stocker cette entrée.
    }
    // Recuperer URL de la video/playlist
    write('Video URL: ');
    readln(VIDEO_URL);

    // Recuperer le nom de l'artiste
    write('Artist name: ');
    readln(ARTIST_NAME);
    
    // Recuperer le titre de l'album
    write('Album title: ');
    readln(ALBUM_TITLE);


    {
        Je créer d'abord un repertoire temporaire pour stocker les fichiers de youtube avant de les replacer.
    }
    // Creer le directory temporaire
    // Definir son nom :
    TMP_DIR := '/tmp/navidrome_tmp_dl/';

    // S'il n'existe pas, on le creer
    // Ca utilise les fonction sysutils je crois
    if not DirectoryExists(TMP_DIR) then
        if not ForceDirectories(TMP_DIR) then
            writeln('Failed to create directory ! ',TMP_DIR)
        else
            writeln('Created "',TMP_DIR,'" directory');

    // Executer la commande systeme 'yt-dlp'
    begin
        // Je creer un process, avec process
        P := TProcess.Create(nil);
        // ca jsp
        P.Options := P.Options + [poWaitOnExit];

        // ici je dis l'executable, c'est le debut de ma commande
        P.Executable := '/usr/local/bin/yt-dlp';

        // Et la j'ajoute les parametres betement comme si je fesais ma commande.
        P.Parameters.Add('-x');
        P.Parameters.Add('--audio-format'); 
        P.Parameters.Add('mp3');

        P.Parameters.Add('--embed-metadata');
        P.Parameters.Add('--add-metadata');
        P.Parameters.Add('--embed-thumbnail');
        P.Parameters.Add('--write-subs');
        P.Parameters.Add('--write-thumbnail');

        P.Parameters.Add('--user-agent');
        // BAM, t'a vu c'est la que je fou la variable useragent
        P.Parameters.Add(USER_AGENT);

        P.Parameters.Add('-o');
        // la j'lui dis le chemin de output c'est le TMP_DIR avec le blaze du son
        P.Parameters.Add(TMP_DIR + '%(playlist_index)02d - %(artist)s - %(title)s.%(ext)s');

        P.Parameters.Add(VIDEO_URL);

        // Quand c'est pret, j'execute
        P.Execute;

        // J'me libere t'a vu...
        P.Free;
    end;

    // Executer la commande systeme 'id3v2'
    {
        `id3v2`, c'est un outil pour changer les metadonnées d'un fichier. Pour nous :
            - Album
            - Artist
    }
    begin
        // Je creer un process, avec process
        P := TProcess.Create(nil);
        P.Options := P.Options + [poWaitOnExit];

        // Pareil, je dis le nom du programme
        P.Executable := '/usr/bin/id3v2';

        // Mes arguments
        P.Parameters.Add('--album');
        P.Parameters.Add(ALBUM_TITLE); 
        P.Parameters.Add('--artist');
        P.Parameters.Add(ARTIST_NAME);
        P.Parameters.Add(TMP_DIR+'*');

        // J'execute
        P.Execute;

        // Et j'me libere
        P.Free;
    end;

    // Creer le directory de l'album
    {
        Ok, ici je vais mettre le contenu de la variable ALBUM_DIR.
        C'est MUSIC_DIR + le nom de l'artiste + Le nom de l'album

        Avec ce chemin la, je vais pouvoir ranger proprement mes musiques sur navidrome.
    }
    // Definir son nom :
    // J'crois que DirectorySeparator c'est une fonction pascal directe pour foutre un "/"
    ALBUM_DIR := MUSIC_DIR+ARTIST_NAME+DirectorySeparator+ALBUM_TITLE;

    // S'il n'existe pas, on le creer
    if not DirectoryExists(ALBUM_DIR) then
        if not ForceDirectories(ALBUM_DIR) then
            writeln('Failed to create directory ! ',ALBUM_DIR)
        else
            writeln('Created "',ALBUM_DIR,'" directory');


    {
        La, je vais déplacer tout les fichier.mp3 qui sont dans le repertoire temporaire,
        dans le dossier de l'album que j'ai créé.

        Visiblement en Pascal ya pas de fonction directe pour ca, faut les sorte de renommer.
    }
    begin
        // Je prend "*" dans le repertoire temporaire
        if FindFirst(TMP_DIR + '*.mp3', faAnyFile, SR) = 0 then
            // Et pour tous... :
            repeat
                if (SR.Name <> '.') and (SR.Name <> '..') then
                    // Je recomme ce fichier, en changeant le chemin vers le chemin de l'album
                    RenameFile(
                        TMP_DIR + SR.Name,
                        ALBUM_DIR + DirectorySeparator + SR.Name
                    );
            until FindNext(SR) <> 0;

        FindClose(SR);
    end;

    {
        La, je vais utiliser la commande "beet" pour ranger proprement les metadonnées des musiques avec MusicBrainz etc etc
    }
    begin
        // Je creer un process, avec process
        P := TProcess.Create(nil);
        P.Options := P.Options + [poWaitOnExit];

        // Pareil, je dis le nom du programme
        P.Executable := '/usr/local/bin/beet';

        // Mes arguments
        P.Parameters.Add('import');
        P.Parameters.Add(MUSIC_DIR); 

        // J'execute
        P.Execute;

        // Et j'me libere
        P.Free;
    end;
end.