# YouTube Downloader for Navidrome

This project is a small utility written in **Pascal**, created both as a
learning exercise and as an automated workflow to download music from
YouTube, clean metadata, and organize files in a structure compatible
with **Navidrome**.

The script downloads videos or playlists, applies proper ID3 metadata,
and arranges audio files in a clean `Artist/Album` folder hierarchy.

------------------------------------------------------------------------

## Language

-   **[Pascal (Free Pascal)](https://www.freepascal.org/)**

This script is intended to be compiled with the Free Pascal Compiler
(FPC).

------------------------------------------------------------------------

## Requirements

Your system must include the following tools:

### yt-dlp

Used to download and extract audio from YouTube.

Download: https://github.com/yt-dlp/yt-dlp/releases/

Example installation (Linux):

``` bash
sudo install -m 755 yt-dlp /usr/local/bin/yt-dlp
```

### id3v2

Used to apply ID3 metadata to MP3 files.

Debian/Ubuntu:

``` bash
sudo apt install id3v2
```

### beet

Used to apply metadata to mp3 files.

Download: https://github.com/beetbox/beets/releases/

```bash
sudo beet import <MUSIC_FOLDER>
```

------------------------------------------------------------------------

## Compilation

Compile the script using **fpc**:

``` bash
fpc ./main.pas
```

This generates an executable named `main`.

### Execution

``` bash
./main
```

------------------------------------------------------------------------

## Script Logic

### 1. Input Collection

The script asks the user for: - The **YouTube URL** (video or
playlist) - The **Artist Name** - The **Album Name**

These inputs are used to name folders and apply metadata.

------------------------------------------------------------------------

### 2. Temporary Directory Creation

A working directory is created in `/tmp`, for example:

    /tmp/navidrome-downloader-XXXX

If the directory already exists, it is reused.

------------------------------------------------------------------------

### 3. Download Audio with yt-dlp

The script uses `yt-dlp` to download audio and convert it to MP3:

``` bash
yt-dlp -x --audio-format mp3 -o "/tmp/.../%(title)s.%(ext)s" "<URL>"
```

All downloaded files are stored in the temporary folder.

------------------------------------------------------------------------

### 4. Apply Metadata with id3v2

Each MP3 file in the temporary directory receives proper metadata:

``` bash
id3v2 --artist "ARTIST" --album "ALBUM" file.mp3
```

This prevents Navidrome from creating duplicate artists/albums due to
inconsistent tags.

------------------------------------------------------------------------

### 5. Build the Final Folder Structure

The output path follows:

    BASE_DIRECTORY / ARTIST / ALBUM /

Example:

    /mnt/navidrome/music/WeRenoi/Diamand\ Noir/

Folders are created automatically if missing.

------------------------------------------------------------------------

### 6. Move Processed Files to Final Directory

All MP3 files are moved from `/tmp/...` to the final album directory.\
The temporary directory can then be removed or left for debugging.

------------------------------------------------------------------------

## Example Folder Layout

    /mnt/navidrome/music/
    └── WeRenoi/
        └── Diamand Noir/
            ├── Poney.mp3
            ├── First.mp3
            ├── ...

Metadata ensures correct sorting and display in Navidrome.

------------------------------------------------------------------------

## Notes and Future Improvements

-   Use [`beet`](https://github.com/beetbox/beets/releases/)

------------------------------------------------------------------------
