import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/ranking_entry.dart';

class RankingService {
  RankingService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl = 'http://localhost:5000';
  static const String _rankingEndpoint = '/api/ranking';

  Future<List<RankingEntry>> fetchRanking({int? rondaId}) async {
    final uri = Uri.parse(
      rondaId == null
          ? '$_baseUrl$_rankingEndpoint'
          : '$_baseUrl$_rankingEndpoint?ronda_id=$rondaId',
    );

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'No se pudo cargar el ranking. Código: ${response.statusCode}',
      );
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
  }
}
