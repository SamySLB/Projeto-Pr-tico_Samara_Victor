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

    final id = pokemonData['id'];
    final imageUrl = pokemonData['sprites']['other']['official-artwork']['front_default'];
    final types = (pokemonData['types'] as List)
        .map((t) => t['type']['name'].toString())
        .toList();
//procura a descrição em pt se não tiver em inglês
    final speciesResponse = await http.get(Uri.parse('$baseUrl/pokemon-species/$id'));
    String? description;

    if (speciesResponse.statusCode == 200) {
      final speciesData = jsonDecode(speciesResponse.body);
      final entries = speciesData['flavor_text_entries'] as List;

      final ptEntry = entries.firstWhere(
        (e) => e['language']['name'] == 'pt' || e['language']['name'] == 'pt-BR',
        orElse: () => null,
      );

      if (ptEntry != null) {
        description = ptEntry['flavor_text']
            .toString()
            .replaceAll('\n', ' ')
            .replaceAll('\f', ' ');
      } else {
        final enEntry = entries.firstWhere(
          (e) => e['language']['name'] == 'en',
          orElse: () => null,
        );
        description = enEntry?['flavor_text']
            ?.toString()
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
//procura os pokemons para pesquisa
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

        final imageUrl =
            detailData['sprites']['other']['official-artwork']['front_default'];
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
}
