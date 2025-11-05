import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFED213A), Color(0xFF93291E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SingleChildScrollView( //Retira linha de emergência evita overflow
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height, //ocupa toda tela 
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : size.width * 0.2,
                vertical: isMobile ? 40 : 80,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
                    height: isMobile ? 200 : 300,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Bem-vindo ao PokeApp!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 26 : 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Descubra os Pokémons, suas descrições e o Pokémon do mês!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 50 : 80,
                        vertical: isMobile ? 16 : 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Começar",
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
