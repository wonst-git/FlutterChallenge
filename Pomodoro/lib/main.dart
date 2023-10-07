import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomodoro/screens/HomeScreen.dart';

void main() {
  runApp(const Pomodoro());
}

class Pomodoro extends StatelessWidget {
  const Pomodoro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData(context),
      home: const HomeScreen(),
    );
  }
}

ThemeData themeData(BuildContext context) => ThemeData(
      colorScheme: ColorScheme(
          brightness: Theme.of(context).colorScheme.brightness,
          primary: Theme.of(context).colorScheme.primary,
          onPrimary: Theme.of(context).colorScheme.onPrimary,
          secondary: Theme.of(context).colorScheme.secondary,
          onSecondary: Theme.of(context).colorScheme.onSecondary,
          error: Theme.of(context).colorScheme.error,
          onError: Theme.of(context).colorScheme.onError,
          background: const Color.fromRGBO(213, 88, 70, 1),
          onBackground: Theme.of(context).colorScheme.onBackground,
          surface: Theme.of(context).colorScheme.surface,
          onSurface: Theme.of(context).colorScheme.onSurface),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFF101010)),
      ),
      cardColor: const Color(0xFFF4EDDB),
    );
