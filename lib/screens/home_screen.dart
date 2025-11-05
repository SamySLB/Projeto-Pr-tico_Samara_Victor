import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../service/api_service.dart';
import '../utils/pokemon_of_month.dart';
import '../widgets/pokemon_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  final int _batchSize = 12;
  int _currentLimit = 12;

  Future<Map<String, dynamic>> _fetchPokemons() async {
    final names = await api.fetchPokemonNames(limit: _currentLimit);
    final details = await Future.wait(names.map(api.fetchPokemonDetail));
    final highlightName = pickPokemonOfMonth(names);
    final highlight = details.firstWhere((p) => p.name == highlightName);
    return {'pokemons': details, 'highlight': highlight};
  }

  void _loadMore() {
    if (_currentLimit < 100) {
      setState(() => _currentLimit += _batchSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'PokéFlix',
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {}, // Tela de busca futura
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {}, // Tela de configurações futura
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchPokemons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar Pokémons 😕',
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          final data = snapshot.data!;
          final List<Pokemon> pokemons = data['pokemons'];
          final Pokemon destaque = data['highlight'];

          return RefreshIndicator(
            color: Colors.redAccent,
            onRefresh: () async => setState(() {}),
            child: ListView(
              children: [
                _HighlightSection(pokemon: destaque),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    "Pokémons",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _PokemonCarousel(pokemons: pokemons),
                if (_currentLimit < 100)
                  Center(
                    child: ElevatedButton(
                      onPressed: _loadMore,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        "Carregar mais",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HighlightSection extends StatelessWidget {
  final Pokemon pokemon;
  const _HighlightSection({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        _buildImage(pokemon.imageUrl ?? ''),
        _buildGradient(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "⭐ Pokémon do mês: ${pokemon.name.toUpperCase()}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String imageUrl) {
    return Image.network(
      imageUrl,
      height: 250,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: 250,
        color: Colors.grey[900],
        child: const Center(
          child: Icon(Icons.help_outline, color: Colors.white54, size: 64),
        ),
      ),
    );
  }

  Widget _buildGradient() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }
}

class _PokemonCarousel extends StatelessWidget {
  final List<Pokemon> pokemons;
  const _PokemonCarousel({required this.pokemons});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pokemons.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final p = pokemons[index];
          return PokemonTile(
            name: p.name,
            imageUrl: p.imageUrl,
            onTap: () =>
                Navigator.pushNamed(context, '/detail', arguments: p.name),
          );
        },
      ),
    );
  }
}
