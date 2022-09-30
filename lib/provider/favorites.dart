import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_finder/classes/song.dart';

class Favorites with ChangeNotifier {
  List<Song> _songs = [];

  List<Song> get songs => _songs;

  bool isSongInList(Song s) {
    var state = false;
    if (songs.contains(s)) {
      state = true;
    }
    return state;
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
