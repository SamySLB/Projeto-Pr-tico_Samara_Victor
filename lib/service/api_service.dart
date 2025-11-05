
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  static const baseUrl = 'https://pokeapi.co/api/v2';

  
  Future<List<String>> fetchPokemonNames({int limit = 50}) async {
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

    
    final imageUrl = pokemonData['sprites']['other']['official-artwork']['front_default'];
    final types = (pokemonData['types'] as List)
        .map((t) => t['type']['name'].toString())
        .toList();

    final speciesResponse = await http.get(Uri.parse('$baseUrl/pokemon-species/$name'));
    String description = '';
    if (speciesResponse.statusCode == 200) {
      final speciesData = jsonDecode(speciesResponse.body);
      final entries = speciesData['flavor_text_entries'] as List;
      final englishEntry = entries.firstWhere(
        (e) => e['language']['name'] == 'en',
        orElse: () => null,
      );
      if (englishEntry != null) {
        description = englishEntry['flavor_text']
            .replaceAll('\n', ' ')
            .replaceAll('\f', ' ');
      }
    }

    return Pokemon(
      id: pokemonData['id'],
      name: pokemonData['name'],
      imageUrl: imageUrl,
      types: types,
      description: description,
    );
  }
}
