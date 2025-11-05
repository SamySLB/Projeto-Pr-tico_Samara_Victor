
import 'package:flutter/material.dart';

class PokemonTile extends StatelessWidget {
  final String name;
  const PokemonTile({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name.toUpperCase()),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => Navigator.pushNamed(
        context,
        '/detail',
        arguments: name,
      ),
    );
  }
}
