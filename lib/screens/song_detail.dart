// ignore_for_file: unrelated_type_equality_checks

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_finder/classes/song.dart';
import 'package:music_finder/provider/favorites.dart';
import 'package:url_launcher/url_launcher.dart';

class SongDetail extends StatefulWidget {
  final Song song;
  const SongDetail({super.key, required this.song});

  @override
  State<SongDetail> createState() => _SongDetailState();
}

class _SongDetailState extends State<SongDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Here you go"),
          actions: [
            IconButton(
                onPressed: () {
                  if (context.read<Favorites>().isSongInList(widget.song)) {
                    showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              title: const Text("Eliminar de favoritos"),
                              content: const Text(
                                  "El elemento será eliminado de sus favoritos ¿Quieres continuar?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                    child: const Text("Cancelar")),
                                TextButton(
                                    onPressed: () {
                                      context
                                          .read<Favorites>()
                                          .removeFavorite(widget.song);
                                      setState(() {});
                                      Navigator.pop(context, 'Cancel');
                                    },
                                    child: const Text("Aceptar")),
                              ],
                            )));
                  } else {
                    context.read<Favorites>().addFavorite(widget.song);
                    setState(() {});
                  }
                },
                icon: Icon(context.read<Favorites>().isSongInList(widget.song)
                    ? Icons.favorite
                    : Icons.favorite_border))
          ],
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              albumImage(widget.song.image != "" ? true : false),
              separator(35),
              Text(
                widget.song.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Text(
                widget.song.album,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(widget.song.artist, style: TextStyle(fontSize: 15)),
              Text(widget.song.releaseDate, style: TextStyle(fontSize: 13.5)),
              separator(20),
              const Divider(),
              Text("Abrir con:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  linkButton(
                      widget.song.spotifyLink != "" ? true : false,
                      "Ver en spotify",
                      FontAwesomeIcons.spotify,
                      widget.song.spotifyLink,
                      context),
                  linkButton(
                      true,
                      "Todos los links",
                      FontAwesomeIcons.recordVinyl,
                      widget.song.songLink,
                      context),
                  linkButton(
                      widget.song.appleLink != "" ? true : false,
                      "Ver en apple music",
                      FontAwesomeIcons.apple,
                      widget.song.appleLink,
                      context),
                ],
              )
            ],
          ),
        ));
  }

  Widget albumImage(bool b) {
    return b == true
        ? Image.network(widget.song.image)
        : Placeholder(
            child: const Text("Image not founded"),
          );
  }

  IconButton linkButton(bool b, String tooltip, IconData icon, String link,
      BuildContext context) {
    return IconButton(
        iconSize: 60,
        tooltip: tooltip,
        onPressed: b == true
            ? () => launchUrl(Uri.parse(link))
            : () => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("No existe link"))),
        icon: Icon(icon));
  }

  SizedBox separator(double height) {
    return SizedBox(
      height: height,
    );
  }
}
