class Song {
  late String artist,
      title,
      album,
      releaseDate,
      songLink,
      spotifyLink,
      appleLink,
      image;

  Song(Map<String, dynamic> song) {
    artist = song['artist'];
    title = song['title'];
    album = song['album'];
    releaseDate = song['release_date'];
    songLink = song['song_link'];
    spotifyLink = song['spotify'] != null ? song['spotify']['uri'] : "";
    appleLink = song['apple_music'] != null ? song['apple_music']['url'] : "";
    image = song['spotify'] != null
        ? song['spotify']['album']['images'][0]['url']
        : "";
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Artist: $artist\nTitle: $title\nAlbum: $album\nRelease date: $releaseDate\nSong Link: $songLink\nSpotify Link: $spotifyLink\nApple Music Link: $appleLink\nImage Link: $image\n";
  }
}
