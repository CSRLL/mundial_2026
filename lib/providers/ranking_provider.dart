import 'package:flutter/material.dart';

import '../models/ranking_entry.dart';
import '../services/ranking_service.dart';

class RankingProvider extends ChangeNotifier {
  RankingProvider({RankingService? service}) : _service = service ?? RankingService();

  final RankingService _service;

  bool isLoading = false;
  String? errorMessage;
  List<RankingEntry> ranking = [];
  int? selectedRoundId;

  Future<void> loadRanking({int? rondaId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      selectedRoundId = rondaId;
      ranking = await _service.fetchRanking(rondaId: rondaId);
    } catch (e) {
      errorMessage = e.toString();
      ranking = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
