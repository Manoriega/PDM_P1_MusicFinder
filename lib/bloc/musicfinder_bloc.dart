import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:music_finder/classes/song.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

part 'musicfinder_event.dart';
part 'musicfinder_state.dart';

class MusicfinderBloc extends Bloc<MusicfinderEvent, MusicfinderState> {
  MusicfinderBloc() : super(MusicfinderInitial()) {
    on<RecordEvent>(_onRecordEvent);
  }

  FutureOr<void> _onRecordEvent(RecordEvent event, Emitter emit) async {
    try {
      emit(RecordingState());
      String audio = await record();
      Map<String, dynamic> res = await search(audio);
      if (res['error'] != null && res['error']['error_code'] == 902) {
        emit(SearchFailedState(
            errorMsg:
                "Has alcanzado el límite de búsquedas. Solicita un nuevo token"));
      } else if (res['result'] == null) {
        emit(SearchFailedState(errorMsg: "No se encontró ninguna canción"));
      } else {
        Song song = Song(res['result']);
        var songDoc = await FirebaseFirestore.instance
            .collection("music_finder_songs")
            .doc(song.title)
            .get();
        if (!songDoc.exists) {
          await FirebaseFirestore.instance
              .collection("music_finder_songs")
              .doc(song.title)
              .set(
            {
              "artist": song.artist,
              "title": song.title,
              "album": song.album,
              "releaseDate": song.releaseDate,
              "songLink": song.songLink,
              "spotifyLink": song.spotifyLink,
              "appleLink": song.appleLink,
              "image": song.image
            },
          );
        }
        emit(SearchSucceedState(song: song));
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> search(String audio) async {
    try {
      final uri = Uri.parse("https://api.audd.io/");
      var request = http.MultipartRequest("POST", uri);

      // Parametros
      request.fields['api_token'] =
          "f5af113ab36b7c5ec93874be8cb2e7d7"; // Ingresar token de audD.io
      request.fields['return'] = "apple_music,spotify";
      request.fields['audio'] = audio;

      var response = await request.send(),
          responseString = await response.stream.bytesToString();
      print(responseString);
      Map<String, dynamic> res = jsonDecode(responseString);
      return res;
    } on Exception catch (e) {
      print(e);
    }
    return {};
  }

  FutureOr<String> record() async {
    String recordString = "";
    final record = Record();
    if (await record.hasPermission() && await _requestStoragePermission()) {
      await record.start();
      await Future.delayed(const Duration(seconds: 4), () async {
        var path = await record.stop();
        final File file = File(path!);
        List<int> bytes = await file.readAsBytes();
        recordString = base64Encode(bytes);
      });
    } else {
      emit(const RecordFailedState(
          errorMsg: "No se obtuvieron los permisos necesarios"));
    }
    return recordString;
  }

  FutureOr<bool> _requestStoragePermission() async {
    // TODO: permission handler
    var status = await Permission.storage.status;
    if (status == PermissionStatus.denied) {
      try {
        await Permission.storage.request();
      } catch (e) {
        return false;
      }
    }
    return status == PermissionStatus.granted;
  }
}
