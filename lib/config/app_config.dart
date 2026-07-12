import 'dart:io';

import 'package:flutter/foundation.dart';

class AppConfig {
  // ==========================================
  // CONFIGURAR AQUÍ SEGÚN EL AMBIENTE
  // ==========================================
  // PRODUCCIÓN: IP del servidor remoto
  static const String _productionUrl = 'http://178.16.142.158:5342';
  
  // DESARROLLO: IP local de tu PC (cambia según tu red)
  static const String _developmentUrl = 'http://192.168.1.109:5342';
  
  // Selecciona el ambiente activo:
  // true = PRODUCCIÓN (servidor remoto)
  // false = DESARROLLO (localhost)
  static const bool _isProduction = true;
  // ==========================================

  static String get apiBaseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    // Usa la configuración según el ambiente seleccionado
    final baseUrl = _isProduction ? _productionUrl : _developmentUrl;

    if (kIsWeb) {
      return baseUrl;
    }

    if (Platform.isAndroid) {
      return baseUrl;
    }

    if (Platform.isIOS) {
      return baseUrl;
    }

    return baseUrl;
  }

  static const String rankingEndpoint = '/api/ranking';
  static const String partidosEndpoint = '/api/partidos';
}
