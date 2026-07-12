import 'dart:convert'; // Permite convertir respuestas JSON a datos que Dart pueda manejar.
import 'package:http/http.dart' as http; // Librería para hacer peticiones HTTP a la API.

import '../config/app_config.dart';
import '../models/partido.dart'; // Modelo para convertir los partidos recibidos desde la API.
import '../models/pronostico.dart'; // Modelo para convertir los pronósticos recibidos desde la API.

class PartidosService {
  // URL base de la API.
  final String baseUrl = AppConfig.apiBaseUrl;

  // Método para obtener todos los partidos desde la API.
  Future<List<Partido>> obtenerPartidos() async {
    final response = await http.get(Uri.parse('$baseUrl${AppConfig.partidosEndpoint}'));

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

  // Método para obtener los pronósticos de un partido específico.
  Future<List<Pronostico>> obtenerPronosticosPorPartido(int idPartido) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/partidos/$idPartido/pronosticos'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List pronosticosJson = data['pronosticos'] ?? [];

      return pronosticosJson
          .map((json) => Pronostico.fromJson(json))
          .toList();
    } else {
      throw Exception('Error al cargar los pronósticos');
    }
  }
}