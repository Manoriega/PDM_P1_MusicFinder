import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_finder/bloc/musicfinder_bloc.dart';
import 'package:music_finder/provider/favorites.dart';
import 'package:music_finder/screens/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Favorites(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MusicFindApp',
        darkTheme: ThemeData(brightness: Brightness.dark),
        theme: ThemeData(brightness: Brightness.light),
        themeMode: ThemeMode.dark,
        home: BlocProvider(
          create: (context) => MusicfinderBloc(),
          child: const HomePage(),
        ));
  }
}
