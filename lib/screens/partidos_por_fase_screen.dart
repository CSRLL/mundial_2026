import 'package:flutter/material.dart';

import '../models/partido.dart';
import '../services/partidos_service.dart';

class PartidosPorFaseScreen extends StatelessWidget {
  const PartidosPorFaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PartidosService partidosService = PartidosService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Partidos por fase'),
        backgroundColor: const Color(0xFF1E5628),
        foregroundColor: const Color(0xFFFFD700),
      ),
      body: FutureBuilder<List<Partido>>(
        future: partidosService.obtenerPartidos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar partidos:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final partidos = snapshot.data ?? [];

          if (partidos.isEmpty) {
            return const Center(
              child: Text('No hay partidos disponibles'),
            );
          }

          final rondas = partidos.map((partido) => partido.ronda).toSet().toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rondas.length,
            itemBuilder: (context, index) {
              final ronda = rondas[index];

              final partidosDeRonda = partidos
                  .where((partido) => partido.ronda == ronda)
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ronda,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E5628),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ...partidosDeRonda.map(
                    (partido) => Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          '${partido.equipoLocal} vs ${partido.equipoVisitante}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Fecha: ${partido.fecha}\n'
                          'Duración: ${partido.duracion}\n'
                          'Resultado: ${partido.resultado}',
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            mostrarDetalle(context, partido);
                          },
                          child: const Text('Ver'),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void mostrarDetalle(BuildContext context, Partido partido) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detalle del partido'),
        content: Text(
          '${partido.equipoLocal} vs ${partido.equipoVisitante}\n\n'
          'Ronda: ${partido.ronda}\n'
          'Fecha: ${partido.fecha}\n'
          'Duración: ${partido.duracion}\n'
          'Resultado: ${partido.resultado}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}