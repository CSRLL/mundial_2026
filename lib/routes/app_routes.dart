import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/ranking_screen.dart';
import '../screens/partidos_por_fase_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
  static const String ranking = '/ranking';
  static const String partidosPorFase = '/partidos-por-fase';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        home: (context) => const HomeScreen(),
        ranking: (context) => const RankingScreen(),
        partidosPorFase: (context) => const PartidosPorFaseScreen(),
      };
}