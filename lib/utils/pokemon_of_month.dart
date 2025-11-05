
String pickPokemonOfMonth(List<String> names) {
  final now = DateTime.now();
  final key = now.year * 100 + now.month;
  final index = key % names.length;
  return names[index];
}
