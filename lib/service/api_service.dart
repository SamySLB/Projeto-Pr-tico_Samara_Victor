import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  static const baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<String>> fetchPokemonNames({int limit = 200}) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=$limit'));
    if (response.statusCode != 200) throw Exception('Erro ao carregar Pokémons');
    final data = jsonDecode(response.body);
    final results = data['results'] as List;
    return results.map((e) => e['name'].toString()).toList();
  }

  Future<Pokemon> fetchPokemonDetail(String name) async {
    final pokemonResponse = await http.get(Uri.parse('$baseUrl/pokemon/$name'));
    if (pokemonResponse.statusCode != 200) throw Exception('Erro ao carregar detalhes');
    final pokemonData = jsonDecode(pokemonResponse.body);
    final id = pokemonData['id'];
    final imageUrl = pokemonData['sprites']['other']['official-artwork']['front_default'];
    final types = (pokemonData['types'] as List)
        .map((t) => t['type']['name'].toString())
        .toList();

    final speciesResponse = await http.get(Uri.parse('$baseUrl/pokemon-species/$id'));
    String? description;

    if (speciesResponse.statusCode == 200) {
      final speciesData = jsonDecode(speciesResponse.body);
      final entries = speciesData['flavor_text_entries'] as List;

      final entry = entries.firstWhere(
        (e) => e['language']['name'] == 'pt' || e['language']['name'] == 'pt-BR',
        orElse: () => entries.firstWhere(
          (e) => e['language']['name'] == 'en',
          orElse: () => null,
        ),
      );

      if (entry != null) {
        description = entry['flavor_text']
            .toString()
            .replaceAll('\n', ' ')
            .replaceAll('\f', ' ');
      }
    }

    return Pokemon(
      id: id,
      name: pokemonData['name'],
      imageUrl: imageUrl,
      types: types,
      description: description,
    );
  }

  Future<List<Pokemon>> fetchAllPokemon({int limit = 200}) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=$limit'));
    if (response.statusCode != 200) throw Exception('Erro ao carregar Pokémons');
    final data = jsonDecode(response.body);
    final results = data['results'] as List;

    List<Pokemon> pokemons = [];

    for (var e in results) {
      final name = e['name'];
      final detailResponse = await http.get(Uri.parse('$baseUrl/pokemon/$name'));
      if (detailResponse.statusCode == 200) {
        final detailData = jsonDecode(detailResponse.body);
        final imageUrl = detailData['sprites']['other']['official-artwork']['front_default'];
        final types = (detailData['types'] as List)
            .map((t) => t['type']['name'].toString())
            .toList();
        pokemons.add(Pokemon(
          id: detailData['id'],
          name: name,
          imageUrl: imageUrl,
          types: types,
        ));
      }
    }

    return pokemons;
  }

  Future<List<Pokemon>> searchPokemon(String query) async {
    final allPokemons = await fetchAllPokemon(limit: 200);
    final normalizedQuery = query.toLowerCase().trim();
    return allPokemons.where((pokemon) {
      final name = pokemon.name.toLowerCase();
      return name.contains(normalizedQuery) ||
          name.startsWith(normalizedQuery) ||
          _levenshtein(name, normalizedQuery) <= 2;
    }).toList();
  }

  int _levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    List<List<int>> dp = List.generate(
      a.length + 1,
      (_) => List.filled(b.length + 1, 0),
    );
    for (int i = 0; i <= a.length; i++) dp[i][0] = i;
    for (int j = 0; j <= b.length; j++) dp[0][j] = j;
    for (int i = 1; i <= a.length; i++) {
      for (int j = 1; j <= b.length; j++) {
        int cost = a[i - 1] == b[j - 1] ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1,
          dp[i][j - 1] + 1,
          dp[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return dp[a.length][b.length];
  }
}
