import 'package:flutter/material.dart';

import '../screens/ranking_screen.dart';

class AppRoutes {
  static const String home = '/';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const RankingScreen(),
      };
}
