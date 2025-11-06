import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../service/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonSearch extends SearchDelegate {
  final ApiService api;

  PokemonSearch({required this.api});

  @override
  String get searchFieldLabel => 'Pesquisar Pokémon...';

  @override
  TextStyle get searchFieldStyle => const TextStyle(color: Colors.white);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.redAccent),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white54),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );
  }

  Icon get searchFieldIcon => const Icon(Icons.search, color: Colors.white);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.redAccent),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.redAccent),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Digite o nome de um Pokémon!',
            style: TextStyle(color: Colors.white70)),
      );
    }

    return FutureBuilder<List<Pokemon>>(
      future: api.fetchAllPokemon(limit: 200),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent));
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(
            child: Text('Pokémon não encontrado!',
                style: TextStyle(color: Colors.white70)),
          );
        }

        final filtered = snapshot.data!
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

        if (filtered.isEmpty) {
          return const Center(
            child: Text('Nenhum Pokémon encontrado!',
                style: TextStyle(color: Colors.white70)),
          );
        }

        return _PokemonGrid(pokemons: filtered);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text(
          'Pesquise por nome ou parte do nome!',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return FutureBuilder<List<Pokemon>>(
      future: api.fetchAllPokemon(limit: 200),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent));
        }

        final filtered = snapshot.data!
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

        if (filtered.isEmpty) {
          return const Center(
            child: Text('Nenhum Pokémon encontrado!',
                style: TextStyle(color: Colors.white70)),
          );
        }

        return _PokemonGrid(pokemons: filtered);
      },
    );
  }
}

class _PokemonGrid extends StatelessWidget {
  final List<Pokemon> pokemons;
  const _PokemonGrid({required this.pokemons});

  void _showPopup(BuildContext context, Pokemon p) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(color: Colors.redAccent),
      ),
    );

    try {
      final detailedPokemon = await ApiService().fetchPokemonDetail(p.name);
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.grey[900],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            detailedPokemon.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                imageUrl: detailedPokemon.imageUrl ?? '',
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Text(
                detailedPokemon.description ?? 'Descrição não disponível.',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Tipos: ${detailedPokemon.types.join(', ')}',
                style:
                    const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Fechar',
                  style: TextStyle(color: Colors.redAccent)),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar detalhes de ${p.name}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: GridView.builder(
        itemCount: pokemons.length,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.1,
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
                      child: CachedNetworkImage(
                        imageUrl: p.imageUrl ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (_, __, ___) => const Icon(
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
      ),
    );
  }
}
