class Partido {
  final int idPartido;
  final String ronda;
  final String equipoLocal;
  final String equipoVisitante;
  final int? golesLocal;
  final int? golesVisitante;
  final String fecha;
  final String duracion;

  Partido({
    required this.idPartido,
    required this.ronda,
    required this.equipoLocal,
    required this.equipoVisitante,
    this.golesLocal,
    this.golesVisitante,
    required this.fecha,
    required this.duracion,
  });

  factory Partido.fromJson(Map<String, dynamic> json) {
    return Partido(
      idPartido: json['id_partido'] ?? 0,
      ronda: json['nombre_ronda'] ?? 'Sin ronda',
      equipoLocal: json['equipo_local'] ?? '',
      equipoVisitante: json['equipo_visitante'] ?? '',
      golesLocal: json['goles_e1'],
      golesVisitante: json['goles_e2'],
      fecha: json['fecha']?.toString() ?? '',
      duracion: json['duracion']?.toString() ?? '',
    );
  }

  String get resultado {
    if (golesLocal == null || golesVisitante == null) {
      return 'Pendiente';
    }

    return '$golesLocal - $golesVisitante';
  }
}