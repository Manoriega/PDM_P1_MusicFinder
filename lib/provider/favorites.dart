import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_finder/classes/song.dart';

class Favorites with ChangeNotifier {
  List<Song> _songs = [];

  List<Song> get songs => _songs;
  bool _songInList = false;
  bool get isSongInList => _songInList;

  void setSongInList(bool val) {
    _songInList = val;
  }

  void addFavorite(Song s) {
    _songs.add(s);
    notifyListeners();
  }

  void removeFavorite(Song s) {
    _songs.remove(s);
    notifyListeners();
  }
}
