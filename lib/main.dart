import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/start_screen.dart';
import 'screens/loading_screen.dart';

void main() {
  runApp(const ColorLabyrinthApp());
}

class ColorLabyrinthApp extends StatelessWidget {
  const ColorLabyrinthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Labyrinth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => const LoadingScreen(),
        '/start': (context) => const StartScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}