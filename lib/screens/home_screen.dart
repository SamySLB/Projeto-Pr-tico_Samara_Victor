
import 'package:flutter/material.dart';
import '../service/api_service.dart';
import '../widgets/pokemon_title.dart';
import '../utils/pokemon_of_month.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final api = ApiService();
  List<String> pokemonNames = [];
  String? pokemonOfMonth;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final names = await api.fetchPokemonNames(limit: 100);
    final chosen = pickPokemonOfMonth(names);
    setState(() {
      pokemonNames = names;
      pokemonOfMonth = chosen;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex MVP')),
      body: ListView(
        children: [
          if (pokemonOfMonth != null)
            Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                title: Text('Pokémon do mês: ${pokemonOfMonth!.toUpperCase()}'),
                subtitle: const Text('Descubra o destaque do mês!'),
                onTap: () => Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: pokemonOfMonth,
                ),
              ),
            ),
          ...pokemonNames.map(
            (name) => PokemonTile(name: name),
          ),
        ],
      ),
    );
  }
}
