import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/ranking_entry.dart';

class RankingService {
  RankingService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  // Lista de candidatos de base URL a intentar si falla la conexión.
  List<String> _candidates() {
    final base = AppConfig.apiBaseUrl;
    return [base];
  }

  Future<List<RankingEntry>> fetchRanking({int? rondaId}) async {
    final candidates = _candidates();
    Exception? lastError;

    for (final base in candidates) {
      try {
        final uri = Uri.parse(
          rondaId == null
              ? '$base${AppConfig.rankingEndpoint}'
              : '$base${AppConfig.rankingEndpoint}?ronda_id=$rondaId',
        );

        final response = await _client.get(uri).timeout(const Duration(seconds: 6));

        if (response.statusCode != 200) {
          throw Exception('Código HTTP ${response.statusCode} desde $uri');
        }

        final dynamic decoded = jsonDecode(response.body);
        final data = decoded is Map<String, dynamic> ? decoded : {'ranking': []};
        final rawList = data['ranking'] is List ? data['ranking'] as List : const [];

        final ranking = rawList
            .map((item) => RankingEntry.fromJson(item as Map<String, dynamic>))
            .toList();

        ranking.sort((a, b) {
          if (b.aciertos != a.aciertos) {
            return b.aciertos.compareTo(a.aciertos);
          }
          return b.porcentaje.compareTo(a.porcentaje);
        });

        for (var i = 0; i < ranking.length; i++) {
          ranking[i] = RankingEntry(
            userId: ranking[i].userId,
            userName: ranking[i].userName,
            aciertos: ranking[i].aciertos,
            totalPronosticos: ranking[i].totalPronosticos,
            porcentaje: ranking[i].porcentaje,
            posicion: i + 1,
          );
        }

        return ranking;
      } catch (e) {
        lastError = Exception('Error conectando a $base: $e');
        continue;
      }
    }

    throw Exception('No se pudo conectar a la API. Intentados: ${candidates.join(', ')}. Último error: ${lastError ?? 'desconocido'}');
  }
}
