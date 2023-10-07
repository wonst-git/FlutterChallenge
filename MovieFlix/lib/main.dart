import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_flix/screens/movie_detail_screen.dart';
import 'package:movie_flix/screens/movie_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MovieListScreen.screenId,
      routes: {
        MovieListScreen.screenId: (context) => const MovieListScreen(),
        MovieDetailScreen.screenId: (context) => MovieDetailScreen(
              arguments: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>,
            ),
      },
    );
  }
}
