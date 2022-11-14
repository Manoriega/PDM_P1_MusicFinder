import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_finder/bloc/musicfinder_bloc.dart';
import 'package:music_finder/classes/song.dart';
import 'package:music_finder/provider/favorites.dart';
import 'package:music_finder/screens/favorites_page.dart';
import 'package:music_finder/screens/song_detail.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocConsumer<MusicfinderBloc, MusicfinderState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is RecordingState) {
              return Text("Escuchando...");
            }
            return Text("Toca para escuchar");
          },
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocConsumer<MusicfinderBloc, MusicfinderState>(
            listener: (context, state) async {
              if (state is SearchFailedState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMsg)));
              } else if (state is SearchSucceedState) {
                bool favorite = await isSongInList(state.song);
                context.read<Favorites>().setSongInList(favorite);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SongDetail(song: state.song),
                ));
              } else if (state is RecordFailedState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMsg)));
              }
            },
            builder: (context, state) {
              if (state is RecordingState) {
                return searchingView();
              }
              return defaultView(context);
            },
          ),
          separator(),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              List<Song> favoritesSongs = await getFavoritesSongs();
              print(favoritesSongs);
              List<Widget> list = [];
              for (var i = 0; i < favoritesSongs.length; i++) {
                list.add(
                  FavoriteItem(context, favoritesSongs, i),
                );
              }
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FavoritesPage(songs: list),
              ));
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: Icon(
                Icons.favorite,
                size: 15,
              ),
              radius: 20.0,
            ),
          )
        ],
      )),
    );
  }

  GestureDetector defaultView(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (() {
        BlocProvider.of<MusicfinderBloc>(context).add(RecordEvent());
      }),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 50.0,
        child: Icon(
          Icons.music_note,
          size: 50,
        ),
      ),
    );
  }

  Widget searchingView() {
    return const AvatarGlow(
      glowColor: Colors.purple,
      shape: BoxShape.circle,
      endRadius: 90.0,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 50.0,
        child: Icon(
          Icons.music_note,
          size: 50,
          color: Colors.red,
        ),
      ),
    );
  }

  SizedBox separator() {
    return SizedBox(
      height: 24,
    );
  }

  Future<bool> isSongInList(Song song) async {
    var queryUser = await FirebaseFirestore.instance
        .collection("music_finder_users")
        .doc("QGAfJwz7PaNtIbwSB2ePIb87TBG2");
    var docsRef = await queryUser.get();
    var favoritesIds = docsRef.data()?["favorites"];
    return favoritesIds.contains(song.title);
  }

  Future<List<Song>> getFavoritesSongs() async {
    var queryUser = await FirebaseFirestore.instance
        .collection("music_finder_users")
        .doc("QGAfJwz7PaNtIbwSB2ePIb87TBG2");
    // sacar data del documento
    var docsRef = await queryUser.get();
    var listIds = docsRef.data()?["favorites"];

    // query para sacar docs de fshare
    var querySongs =
        await FirebaseFirestore.instance.collection("music_finder_songs").get();

    // filtrar con Dart la info necesaria usando con referencia la lista de isd del user actual
    var favoritesSongs = querySongs.docs
        .where((doc) => listIds.contains(doc.id))
        .map((doc) => doc.data().cast<String, dynamic>())
        .toList();
    List<Song> favorites = [];

    favoritesSongs.forEach((element) {
      favorites.add(SongFromFirebase(element));
    });

    return favorites;
  }

  GestureDetector FavoriteItem(
      BuildContext context, List<Song> favorites, int i) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.read<Favorites>().setSongInList(true);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SongDetail(song: favorites[i])));
      },
      child: Container(
        height: 340,
        margin: EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
          child: Stack(
            children: [
              favorites[i].image != ""
                  ? Positioned.fill(
                      child: Image.network(
                      favorites[i].image,
                      fit: BoxFit.fill,
                    ))
                  : Placeholder(),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.indigo[500],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${favorites[i].title}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${favorites[i].artist}",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Song SongFromFirebase(Map<String, dynamic> song) {
    String artist = song['artist'];
    String title = song['title'];
    String album = song['album'];
    String releaseDate = song['releaseDate'];
    String songLink = song['songLink'];
    String spotifyLink = song['spotifyLink'];
    String appleLink = song['appleLink'];
    String image = song['image'];
    Map<String, dynamic> newSong = {
      "artist": artist,
      "title": title,
      "album": album,
      "release_date": releaseDate,
      "song_link": songLink,
      "spotify": {
        "uri": spotifyLink,
        "album": {
          "images": [
            {"url": image}
          ]
        }
      },
      "apple_music": {"url": appleLink}
    };
    return Song(newSong);
  }
}
