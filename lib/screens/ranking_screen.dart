import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ranking_provider.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RankingProvider>().loadRanking();
    });
  }

  Future<void> _refreshRanking() async {
    await context.read<RankingProvider>().loadRanking();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RankingProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Ranking Mundial 2026',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          if (!provider.isLoading)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshRanking,
              tooltip: 'Actualizar ranking',
            ),
        ],
      ),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              provider.errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _refreshRanking,
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (provider.ranking.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  _buildTopThreeCards(provider.ranking),
                                  const SizedBox(height: 24),
                                  _buildRankingTable(provider.ranking),
                                ] else
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(32),
                                      child: Column(
                                        children: [
                                          const Icon(Icons.info_outline, size: 64, color: Colors.grey),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'No hay datos de ranking disponibles',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildTopThreeCards(List ranking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text(
            'Top Pronosticadores',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E5628),
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (ranking.length >= 2)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildMedalCard(
                            ranking[1],
                            position: 2,
                            medalColor: const Color(0xFFC0C0C0),
                            height: 140,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '2do',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (ranking.isNotEmpty)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildMedalCard(
                            ranking[0],
                            position: 1,
                            medalColor: const Color(0xFFFFD700),
                            height: 180,
                            isFirstPlace: true,
                          ),
                          Container(
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFB8860B),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '1ro',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (ranking.length >= 3)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                           _buildMedalCard(
                             ranking[2],
                             position: 3,
                             medalColor: const Color(0xFFCD7F32),
                             height: 140,
                           ),
                           Container(
                             height: 40,
                             decoration: BoxDecoration(
                               color: Colors.orange.shade700,
                               borderRadius: const BorderRadius.only(
                                 bottomLeft: Radius.circular(8),
                                 bottomRight: Radius.circular(8),
                               ),
                             ),
                             child: const Center(
                               child: Text(
                                 '3ro',
                                 style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                   color: Colors.white,
                                   fontSize: 12,
                                 ),
                               ),
                             ),
                           ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedalCard(dynamic user, {
    required int position,
    required Color medalColor,
    required double height,
    bool isFirstPlace = false,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: medalColor,
              child: Text(
                '🏆',
                style: TextStyle(
                  fontSize: isFirstPlace ? 28 : 24,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              user.userName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 3),
            Flexible(
              child: Text(
                '${user.aciertos}/${user.totalPronosticos} aciertos',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF1E5628).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${user.porcentaje.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E5628),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingTable(List ranking) {
    final startIndex = ranking.length > 3 ? 3 : ranking.length;
    final remainingUsers = ranking.sublist(startIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Text(
            'Ranking Completo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E5628),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E5628),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: const [
                    SizedBox(
                      width: 40,
                      child: Text(
                        '#',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD700),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Usuario',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD700),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Aciertos/Total',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD700),
                          fontSize: 12,
                        ),
                      ),
                     ),
                     SizedBox(
                       width: 60,
                       child: Text(
                         '%',
                         textAlign: TextAlign.center,
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           color: Color(0xFFFFD700),
                           fontSize: 12,
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
              if (remainingUsers.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: remainingUsers.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) {
                    final user = remainingUsers[index];
                    final actualPosition = index + 4;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: Text(
                              '$actualPosition',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF1E5628),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              user.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                           SizedBox(
                             width: 80,
                             child: Text(
                               '${user.aciertos}/${user.totalPronosticos}',
                               textAlign: TextAlign.center,
                               style: const TextStyle(
                                 fontWeight: FontWeight.w500,
                                 fontSize: 14,
                               ),
                             ),
                           ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              '${user.porcentaje.toStringAsFixed(1)}%',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Color(0xFF1E5628),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Solo ${ranking.length} usuario(s) en el ranking',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
