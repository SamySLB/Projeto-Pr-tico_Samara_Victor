
import 'package:flutter/material.dart';
import '../service/api_service.dart';
import '../models/pokemon.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailScreen extends StatefulWidget {
  final String name;
  const DetailScreen({required this.name, super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final api = ApiService();
  Pokemon? p;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final detail = await api.fetchPokemonDetail(widget.name);
    setState(() {
      p = detail;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: Text(p!.name.toUpperCase())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CachedNetworkImage(imageUrl: p!.imageUrl ?? '', height: 200),
            const SizedBox(height: 12),
            Text('Tipos: ${p!.types.join(', ')}'),
            const SizedBox(height: 16),
            Text(p!.description ?? 'Sem descrição disponível'),
          ],
        ),
      ),
    );
  }
}
