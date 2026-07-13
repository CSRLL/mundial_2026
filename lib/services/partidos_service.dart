import 'dart:convert'; // Permite convertir respuestas JSON a datos que Dart pueda manejar.
import 'package:http/http.dart' as http; // Librería para hacer peticiones HTTP a la API.

import '../config/app_config.dart';
import '../models/partido.dart'; // Modelo para convertir los partidos recibidos desde la API.
import '../models/pronostico.dart'; // Modelo para convertir los pronósticos recibidos desde la API.
import 'auth_storage.dart';

class PartidosService {
  // URL base de la API.
  final String baseUrl = AppConfig.apiBaseUrl;

  List<String> _candidates() {
    return [baseUrl];
  }

  Future<Map<String, String>> _headers() async {
    final authStorage = AuthStorage();
    final token = await authStorage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // Método para obtener todos los partidos desde la API.
  Future<List<Partido>> obtenerPartidos() async {
    final candidates = _candidates();
    Exception? lastError;

    for (final base in candidates) {
      try {
        final uri = Uri.parse('$base${AppConfig.partidosEndpoint}');
        final headers = await _headers();
        final response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List partidosJson = data['partidos'] ?? [];

          return partidosJson.map((json) => Partido.fromJson(json)).toList();
        }

        lastError = Exception('Código ${response.statusCode} desde $uri');
      } catch (e) {
        lastError = Exception('Error conectando a $base: $e');
      }
    }

    throw Exception('No se pudo cargar los partidos. Intentados: ${candidates.join(', ')}. Último error: $lastError');
  }

  // Método para obtener los pronósticos de un partido específico.
  Future<List<Pronostico>> obtenerPronosticosPorPartido(int idPartido) async {
    final candidates = _candidates();
    Exception? lastError;

    for (final base in candidates) {
      try {
        final uri = Uri.parse('$base${AppConfig.partidosEndpoint}/$idPartido/pronosticos');
        final headers = await _headers();
        final response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 6));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List pronosticosJson = data['pronosticos'] ?? [];

          return pronosticosJson.map((json) => Pronostico.fromJson(json)).toList();
        }

        lastError = Exception('Código ${response.statusCode} desde $uri');
      } catch (e) {
        lastError = Exception('Error conectando a $base: $e');
      }
    }

    throw Exception('No se pudo cargar los pronósticos. Intentados: ${candidates.join(', ')}. Último error: $lastError');
  }
}