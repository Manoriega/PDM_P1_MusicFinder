import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_finder/bloc/musicfinder_bloc.dart';
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
            listener: (context, state) {
              if (state is SearchFailedState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMsg)));
              } else if (state is SearchSucceedState) {
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
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FavoritesPage(),
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
        ),
      ),
    );
  }

  SizedBox separator() {
    return SizedBox(
      height: 24,
    );
  }
}
