import 'dart:io';

import 'package:flutter/foundation.dart';

class AppConfig {
  static String get apiBaseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    if (kIsWeb) {
      return 'http://178.16.142.158:5342';
    }

    if (Platform.isAndroid) {
      return 'http://178.16.142.158:5342';
    }

    if (Platform.isIOS) {
      return 'http://178.16.142.158:5342';
    }

    return 'http://178.16.142.158:5342';
  }

  static const String rankingEndpoint = '/api/ranking';
  static const String partidosEndpoint = '/api/partidos';
}
