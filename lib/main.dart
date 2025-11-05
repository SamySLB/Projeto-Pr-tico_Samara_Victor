import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';

void main() {
  runApp(const PokeApp());
}

class PokeApp extends StatelessWidget {
  const PokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const IntroScreen(),
      routes: {
        '/home': (context) => const Placeholder(), //aqui é a rota esperando proxima tela
      },
    );
  }
}
