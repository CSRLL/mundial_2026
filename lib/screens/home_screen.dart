import 'package:flutter/material.dart';

import 'ranking_screen.dart';
import 'partidos_por_fase_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color verdeMundial = Color(0xFF1E5628);
  static const Color doradoMundial = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool esCelular = size.width < 700;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo_home_2026.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Container(
          color: Colors.black.withValues(alpha: esCelular ? 0.38 : 0.28),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: esCelular ? 22 : 32,
                vertical: esCelular ? 28 : 38,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: esCelular ? double.infinity : 520,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mundial 2026',
                        style: TextStyle(
                          fontSize: esCelular ? 40 : 54,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                          height: 1.05,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Consulta el ranking de pronósticos y los partidos organizados por fase.',
                        style: TextStyle(
                          fontSize: esCelular ? 16 : 19,
                          color: Colors.white,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: esCelular ? 34 : 46),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _HomeButton(
                                title: 'Ranking Mundial 2026',
                                subtitle: 'Ver tabla de aciertos de usuarios',
                                icon: Icons.emoji_events,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RankingScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 18),
                              _HomeButton(
                                title: 'Partidos por fase',
                                subtitle: 'Ver rondas, marcadores y detalles',
                                icon: Icons.sports_soccer,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const PartidosPorFaseScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  static const Color verdeMundial = Color(0xFF1E5628);
  static const Color doradoMundial = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    final bool esCelular = MediaQuery.of(context).size.width < 700;

    return Card(
      color: Colors.white.withValues(alpha: 0.88),
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: esCelular ? 14 : 18,
            vertical: esCelular ? 15 : 17,
          ),
          child: Row(
            children: [
              Container(
                width: esCelular ? 48 : 54,
                height: esCelular ? 48 : 54,
                decoration: BoxDecoration(
                  color: verdeMundial,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: doradoMundial,
                  size: esCelular ? 26 : 30,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: esCelular ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: verdeMundial,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: esCelular ? 13 : 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: verdeMundial,
              ),
            ],
          ),
        ),
      ),
    );
  }
}