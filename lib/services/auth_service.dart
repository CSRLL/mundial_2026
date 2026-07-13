import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class AuthService {
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/api/auth/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(data['error'] ?? 'No se pudo iniciar sesión');
    }

    return data;
  }

  Future<Map<String, dynamic>> confirm({required String pendingAccessToken}) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/api/auth/confirm');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pending_access_token': pendingAccessToken}),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      throw Exception(data['error'] ?? 'No se pudo confirmar la sesión');
    }

    return data;
  }
}
