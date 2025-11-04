import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Primeiro App Flutter',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Olá, Flutter!'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: Text(
            'Bem-vinda ao seu primeiro app 🎉',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

