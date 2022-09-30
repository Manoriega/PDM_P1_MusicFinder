import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_finder/provider/favorites.dart';
import 'package:music_finder/screens/song_detail.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favoritos"),
        ),
        body: Center(child: Consumer<Favorites>(
          builder: (context, favorites, child) {
            List<Widget> list = [];
            for (var i = 0; i < favorites.songs.length; i++) {
              list.add(
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            SongDetail(song: favorites.songs[i])));
                  },
                  child: Container(
                    height: 340,
                    margin: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      child: Stack(
                        children: [
                          favorites.songs[i].image != ""
                              ? Positioned.fill(
                                  child: Image.network(
                                  favorites.songs[i].image,
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
                                    "${favorites.songs[i].title}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "${favorites.songs[i].artist}",
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
                ),
              );
            }
            return ListView(
              padding: EdgeInsets.all(10.0),
              children: list,
            );
          },
        )));
  }
}
