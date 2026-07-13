import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, dynamic>> login({
    required String usuario,
    required String password,
  }) async {
    final loginUri = Uri.parse('${AppConfig.apiBaseUrl}/api/auth/login');
    final loginResponse = await _client.post(
      loginUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usuario': usuario, 'password': password}),
    );

    final decoded = jsonDecode(loginResponse.body) as Map<String, dynamic>;

    if (loginResponse.statusCode != 200) {
      throw Exception(decoded['error'] ?? 'No se pudo iniciar sesión.');
    }

    if (decoded['requires_confirmation'] == true && decoded['pending_access_token'] != null) {
      final confirmUri = Uri.parse('${AppConfig.apiBaseUrl}/api/auth/confirm');
      final confirmResponse = await _client.post(
        confirmUri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'pending_access_token': decoded['pending_access_token']}),
      );

      final confirmDecoded = jsonDecode(confirmResponse.body) as Map<String, dynamic>;

      if (confirmResponse.statusCode != 200) {
        throw Exception(confirmDecoded['error'] ?? 'No se pudo confirmar el acceso.');
      }

      return {
        'access_token': confirmDecoded['access_token'],
        'refresh_token': confirmDecoded['refresh_token'],
        'user_name': confirmDecoded['user_name'] ?? usuario,
      };
    }

    if (decoded['access_token'] != null) {
      return {
        'access_token': decoded['access_token'],
        'refresh_token': decoded['refresh_token'],
        'user_name': decoded['user_name'] ?? usuario,
      };
    }

    throw Exception(decoded['message'] ?? 'Respuesta inesperada del servidor.');
  }
}
