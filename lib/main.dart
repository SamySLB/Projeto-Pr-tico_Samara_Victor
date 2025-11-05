import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';
//colocar import do cadastro e login
import 'screens/home_screen.dart'; 

void main() {
  runApp(const PokeApp());
}

class PokeApp extends StatelessWidget {
  const PokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokéApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const IntroScreen(),
      routes: {
        '/home': (context) => const HomeScreen(), // rota para a Home(não é a final rota)
      },
    );
  }
}
