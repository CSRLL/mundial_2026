import 'dart:io';

import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _localApiUrl = 'http://192.168.1.109:5342';
  static const String _androidEmulatorApiUrl = 'http://10.0.2.2:5342';
  static const bool _useAndroidEmulator = bool.fromEnvironment('API_USE_ANDROID_EMULATOR', defaultValue: false);

  static String get apiBaseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    if (kIsWeb) {
      return _localApiUrl;
    }

    if (Platform.isAndroid && _useAndroidEmulator) {
      return _androidEmulatorApiUrl;
    }

    return _localApiUrl;
  }

  static const String rankingEndpoint = '/api/ranking';
  static const String partidosEndpoint = '/api/partidos';
}
