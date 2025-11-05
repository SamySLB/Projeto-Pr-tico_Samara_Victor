
class Pokemon {
  final int id;
  final String name;
  final String? imageUrl;
  final List<String> types;
  final String? description;

  Pokemon({
    required this.id,
    required this.name,
    this.imageUrl,
    this.types = const [],
    this.description,
  });
}
