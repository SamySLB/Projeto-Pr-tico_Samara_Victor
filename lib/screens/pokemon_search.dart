import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../service/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/pokemon_card.dart'; 

class PokemonSearch extends SearchDelegate {
  final ApiService api;

  PokemonSearch({required this.api});

  @override
  String get searchFieldLabel => 'Pesquisar Pokémon...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
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

  // Resultado quando o usuário confirma a pesquisa
  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Digite o nome de um Pokémon!', style: TextStyle(color: Colors.white70)));
    }

    return FutureBuilder<Pokemon>(
      future: api.fetchPokemonDetail(query.toLowerCase()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Pokémon não encontrado!', style: TextStyle(color: Colors.white70)));
        }

        final pokemon = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: PokemonCard(pokemon: pokemon), 
        );
      },
    );
  }

  
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text(
          'Quem é esse Pokémon?',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return FutureBuilder<List<Pokemon>>(
      future: api.fetchAllPokemon(), 
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
        }

        final filtered = snapshot.data!
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

        if (filtered.isEmpty) {
          return const Center(
            child: Text('Nenhum Pokémon encontrado!', style: TextStyle(color: Colors.white70)),
          );
        }

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final pokemon = filtered[index];
            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: pokemon.imageUrl ?? '',
                height: 50,
                width: 50,
              ),
              title: Text(
                pokemon.name.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                query = pokemon.name;
                showResults(context); 
              },
            );
          },
        );
      },
    );
  }
}
