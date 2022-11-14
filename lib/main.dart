import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_finder/auth/bloc/auth_bloc.dart';
import 'package:music_finder/bloc/musicfinder_bloc.dart';
import 'package:music_finder/provider/favorites.dart';
import 'package:music_finder/screens/home_page.dart';
import 'package:music_finder/screens/login.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthBloc()..add(VerifyAuthEvent()),
      ),
      BlocProvider(
        create: (context) => MusicfinderBloc(),
      ),
    ],
    child: ChangeNotifierProvider(
      create: (context) => Favorites(),
      child: MyApp(),
    ),
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
        home: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Favor de autenticarse"),
              ),
            );
          }
        }, builder: (context, state) {
          return HomePage();
        }));
  }
}
