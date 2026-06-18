class Pronostico {
  final int idPronostico;
  final int idPartido;
  final int idUsuario;
  final String nombreUsuario;
  final int golesEquipo1;
  final int golesEquipo2;

  Pronostico({
    required this.idPronostico,
    required this.idPartido,
    required this.idUsuario,
    required this.nombreUsuario,
    required this.golesEquipo1,
    required this.golesEquipo2,
  });

  // Convierte los datos JSON de la API en un objeto Pronostico.
  factory Pronostico.fromJson(Map<String, dynamic> json) {
    return Pronostico(
      idPronostico: json['id_pronostico'] ?? 0,
      idPartido: json['id_partido'] ?? 0,
      idUsuario: json['id_usuario'] ?? 0,
      nombreUsuario: json['nombre_usuario'] ?? 'Usuario sin nombre',
      golesEquipo1: json['goles_e1'] ?? 0,
      golesEquipo2: json['goles_e2'] ?? 0,
    );
  }

  // Devuelve el marcador pronosticado en formato más claro.
  String get marcadorPronosticado {
    return '$golesEquipo1 - $golesEquipo2';
  }
}