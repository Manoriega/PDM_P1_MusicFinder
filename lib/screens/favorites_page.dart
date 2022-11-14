import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_finder/classes/song.dart';
import 'package:music_finder/provider/favorites.dart';
import 'package:music_finder/screens/song_detail.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  final List<Widget> songs;
  const FavoritesPage({Key? key, required this.songs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favoritos"),
        ),
        body: Center(
            child: ListView(
          padding: EdgeInsets.all(10.0),
          children: songs,
        )));
  }
}
