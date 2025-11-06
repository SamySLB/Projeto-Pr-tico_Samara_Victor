import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../service/api_service.dart';
import '../utils/pokemon_of_month.dart';

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
          'PokeApp',
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              //configurações
            },
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
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  _PokemonGrid(pokemons: pokemons),
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
        Image.network(
          pokemon.imageUrl ?? '',
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
        ),
        Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Pokémon do mês: ${pokemon.name.toUpperCase()}",
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
}

class _PokemonGrid extends StatelessWidget {
  final List<Pokemon> pokemons;
  const _PokemonGrid({required this.pokemons});

  void _showPopup(BuildContext context, Pokemon p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          p.name.toUpperCase(),
          style: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(p.imageUrl ?? '', height: 120),
            const SizedBox(height: 10),
            Text(
              p.description ?? 'Sem descrição disponível 😅',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Tipos: ${p.types.join(', ')}',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Fechar', style: TextStyle(color: Colors.redAccent)),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: pokemons.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // duas colunas estilo Pinterest
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final p = pokemons[index];
        return GestureDetector(
          onTap: () => _showPopup(context, p),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      p.imageUrl ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.help_outline,
                        color: Colors.white54,
                        size: 48,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    p.name.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
