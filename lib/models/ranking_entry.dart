class RankingEntry {
  final int userId;
  final String userName;
  final int aciertos;
  final int totalPronosticos;
  final double porcentaje;
  final int? posicion;

  RankingEntry({
    required this.userId,
    required this.userName,
    required this.aciertos,
    required this.totalPronosticos,
    required this.porcentaje,
    this.posicion,
  });

  factory RankingEntry.fromJson(Map<String, dynamic> json) {
    return RankingEntry(
      userId: json['user_id'] ?? json['userId'] ?? 0,
      userName: json['user_name'] ?? json['userName'] ?? 'Usuario',
      aciertos: json['aciertos'] ?? 0,
      totalPronosticos: json['total_pronosticos'] ?? json['totalPronosticos'] ?? 0,
      porcentaje: (json['porcentaje'] ?? 0).toDouble(),
      posicion: json['posicion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'aciertos': aciertos,
      'total_pronosticos': totalPronosticos,
      'porcentaje': porcentaje,
      'posicion': posicion,
    };
  }
}
