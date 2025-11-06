import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../service/api_service.dart';
import '../screens/screen_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonSearch extends SearchDelegate {
  final ApiService api;

  PokemonSearch({required this.api});

  @override
  String get searchFieldLabel => 'Pesquisar Pokémon...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white54),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.white),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Quem é esse pokemon?!'));
    }

    return FutureBuilder<Pokemon>(
      future: api.fetchPokemonDetail(query.toLowerCase()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent));
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Pokémon não capturado'),
          );
        }

        final p = snapshot.data!;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(name: p.name),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  CachedNetworkImage(
                    imageUrl: p.imageUrl ?? '',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    p.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tipos: ${p.types.join(', ')}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text(
          'Quem é esse pokemon?!',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }
    return Container();
  }
}
