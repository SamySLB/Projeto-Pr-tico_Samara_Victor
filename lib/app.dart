import 'package:flutter_aplicattion_sv/service/api_service.dart';

void main() async {
  final api = ApiService();
  final p = await api.fetchPokemonDetail('pikachu');
  print('${p.name}: ${p.description}');
}
