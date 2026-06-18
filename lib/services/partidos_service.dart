import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/partido.dart';

class PartidosService {
  static const String baseUrl = 'http://localhost:5000';

  Future<List<Partido>> obtenerPartidos() async {
    final response = await http.get(Uri.parse('$baseUrl/api/partidos'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List partidosJson = data['partidos'] ?? [];

      return partidosJson
          .map((json) => Partido.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al cargar los partidos');
    }
  }
}