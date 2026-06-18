import 'package:flutter/material.dart';

import '../models/partido.dart';
import '../services/partidos_service.dart';

class PartidosPorFaseScreen extends StatelessWidget {
  const PartidosPorFaseScreen({super.key});

  // Colores principales que se usan en la pantalla.
  static const Color verdeMundial = Color(0xFF1E5628);
  static const Color doradoMundial = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    // Servicio que consulta los partidos desde la API.
    final PartidosService partidosService = PartidosService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Partidos por fase',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: verdeMundial,
        foregroundColor: doradoMundial,
        elevation: 0,
      ),

      // Uso Stack para poner primero la imagen de fondo
      // y después encima el contenido de los partidos.
      body: Stack(
        children: [
          // Fondo de la pantalla de partidos.
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo_partidos_2026.png',
              fit: BoxFit.cover,
            ),
          ),

          // Capa oscura para que las tarjetas y textos se lean mejor.
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.20),
                    Colors.black.withOpacity(0.32),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Aquí se cargan los datos reales de los partidos.
          FutureBuilder<List<Partido>>(
            future: partidosService.obtenerPartidos(),
            builder: (context, snapshot) {
              // Mientras carga la información, se muestra un indicador.
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: doradoMundial,
                  ),
                );
              }

              // Si ocurre un error al consultar la API, se muestra un mensaje.
              if (snapshot.hasError) {
                return _EstadoError(
                  mensaje:
                      'No se pudieron cargar los partidos.\n${snapshot.error}',
                  onRetry: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PartidosPorFaseScreen(),
                      ),
                    );
                  },
                );
              }

              final partidos = snapshot.data ?? [];

              // Si la API no devuelve partidos, se avisa al usuario.
              if (partidos.isEmpty) {
                return const Center(
                  child: Text(
                    'No hay partidos disponibles',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              // Se obtienen las rondas para agrupar los partidos por fase.
              final rondas = partidos.map((p) => p.ronda).toSet().toList();

              // LayoutBuilder ayuda a acomodar el contenido según el tamaño.
              return LayoutBuilder(
                builder: (context, constraints) {
                  final bool esPantallaAmplia = constraints.maxWidth >= 900;

                  // En pantallas grandes se deja el balón libre del lado izquierdo.
                  final double anchoContenido = esPantallaAmplia
                      ? constraints.maxWidth * 0.52
                      : constraints.maxWidth * 0.94;

                  return Align(
                    alignment: esPantallaAmplia
                        ? Alignment.topRight
                        : Alignment.topCenter,
                    child: Container(
                      width: anchoContenido,
                      margin: EdgeInsets.only(
                        top: 18,
                        right: esPantallaAmplia ? 28 : 0,
                        bottom: 18,
                      ),

                      // Lista de rondas y partidos.
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: rondas.length,
                        itemBuilder: (context, index) {
                          final ronda = rondas[index];

                          final partidosDeRonda = partidos
                              .where((partido) => partido.ronda == ronda)
                              .toList();

                          return _SeccionRonda(
                            ronda: ronda,
                            partidos: partidosDeRonda,
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SeccionRonda extends StatelessWidget {
  final String ronda;
  final List<Partido> partidos;

  const _SeccionRonda({
    required this.ronda,
    required this.partidos,
  });

  static const Color verdeMundial = Color(0xFF1E5628);
  static const Color doradoMundial = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de cada fase o ronda.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: verdeMundial.withOpacity(0.92),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: doradoMundial.withOpacity(0.45),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.22),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.flag,
                  color: doradoMundial,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  ronda.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: doradoMundial,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Se muestran las tarjetas de los partidos de esa ronda.
          ...partidos.map((partido) => _PartidoCard(partido: partido)),
        ],
      ),
    );
  }
}

class _PartidoCard extends StatelessWidget {
  final Partido partido;

  const _PartidoCard({
    required this.partido,
  });

  // Colores de las tarjetas para que combinen con el Home.
  static const Color colorTarjeta = Color(0xFF071A3D);
  static const Color bordeClaro = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    final bool tieneResultado =
        partido.golesLocal != null && partido.golesVisitante != null;

    final String marcador = tieneResultado ? partido.resultado : 'vs';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: colorTarjeta.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: bordeClaro.withOpacity(0.28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.30),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      // Contenido principal de la tarjeta.
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          children: [
            // Línea superior decorativa.
            Container(
              height: 2,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: bordeClaro,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            // Marcador principal con equipos, banderas y resultado.
            _MarcadorPartido(
              equipoLocal: partido.equipoLocal,
              equipoVisitante: partido.equipoVisitante,
              marcador: marcador,
            ),

            const SizedBox(height: 12),

            // Botón para abrir el detalle del partido.
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: bordeClaro,
                side: const BorderSide(color: bordeClaro),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              onPressed: () => _mostrarDetalle(context, partido),
              child: const Text(
                'Ver todo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ventana emergente que muestra más información del partido.
  void _mostrarDetalle(BuildContext context, Partido partido) {
    final bool tieneResultado =
        partido.golesLocal != null && partido.golesVisitante != null;

    final String marcador = tieneResultado ? partido.resultado : 'vs';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF071A3D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          'Detalle del partido',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),

        // Dentro del detalle se repite el marcador y se agregan fecha y hora.
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MarcadorPartido(
              equipoLocal: partido.equipoLocal,
              equipoVisitante: partido.equipoVisitante,
              marcador: marcador,
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
              child: Column(
                children: [
                  _DetalleDato(
                    titulo: 'Fecha',
                    valor: _formatearFecha(partido.fecha),
                  ),
                  const SizedBox(height: 8),
                  _DetalleDato(
                    titulo: 'Finalizó',
                    valor: _formatearHora(partido.duracion),
                  ),
                ],
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cerrar',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarcadorPartido extends StatelessWidget {
  final String equipoLocal;
  final String equipoVisitante;
  final String marcador;

  const _MarcadorPartido({
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.marcador,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Equipo local.
        Expanded(
          child: _EquipoConBandera(
            nombre: equipoLocal,
            bandera: _obtenerBandera(equipoLocal),
            alineacionDerecha: false,
          ),
        ),

        // Marcador al centro.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            marcador,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Equipo visitante.
        Expanded(
          child: _EquipoConBandera(
            nombre: equipoVisitante,
            bandera: _obtenerBandera(equipoVisitante),
            alineacionDerecha: true,
          ),
        ),
      ],
    );
  }
}

class _EquipoConBandera extends StatelessWidget {
  final String nombre;
  final String bandera;
  final bool alineacionDerecha;

  const _EquipoConBandera({
    required this.nombre,
    required this.bandera,
    required this.alineacionDerecha,
  });

  @override
  Widget build(BuildContext context) {
    // Se arma el equipo con su bandera y nombre.
    final children = [
      Text(
        bandera,
        style: const TextStyle(fontSize: 30),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          nombre,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alineacionDerecha ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ];

    // Si es visitante, se invierte el orden para que quede hacia la derecha.
    return Row(
      mainAxisAlignment:
          alineacionDerecha ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: alineacionDerecha ? children.reversed.toList() : children,
    );
  }
}

class _DetalleDato extends StatelessWidget {
  final String titulo;
  final String valor;

  const _DetalleDato({
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    // Fila para mostrar datos como Fecha y Finalizó.
    return Row(
      children: [
        Text(
          '$titulo: ',
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            valor,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

// Convierte la fecha que viene de la base de datos a formato día/mes/año.
String _formatearFecha(String fecha) {
  if (fecha.isEmpty) return 'Sin fecha';

  try {
    final date = DateTime.parse(fecha);
    final dia = date.day.toString().padLeft(2, '0');
    final mes = date.month.toString().padLeft(2, '0');
    final anio = date.year.toString();

    return '$dia/$mes/$anio';
  } catch (_) {
    return fecha;
  }
}

// Toma la hora y la muestra de forma más clara.
String _formatearHora(String duracion) {
  if (duracion.isEmpty) return 'Sin hora';

  if (duracion.length >= 5) {
    return '${duracion.substring(0, 5)} hrs';
  }

  return duracion;
}

// Función para mostrar una bandera dependiendo del nombre del equipo.
String _obtenerBandera(String equipo) {
  final nombre = equipo.toLowerCase();

  if (nombre.contains('ee. uu') ||
      nombre.contains('estados unidos') ||
      nombre.contains('usa')) {
    return '🇺🇸';
  }

  if (nombre.contains('brasil')) return '🇧🇷';
  if (nombre.contains('ghana')) return '🇬🇭';

  if (nombre.contains('república de corea') || nombre.contains('corea')) {
    return '🇰🇷';
  }

  if (nombre.contains('chequia')) return '🇨🇿';
  if (nombre.contains('méxico') || nombre.contains('mexico')) return '🇲🇽';
  if (nombre.contains('canadá') || nombre.contains('canada')) return '🇨🇦';
  if (nombre.contains('qatar')) return '🇶🇦';
  if (nombre.contains('francia')) return '🇫🇷';
  if (nombre.contains('inglaterra')) return '🏴';
  if (nombre.contains('argentina')) return '🇦🇷';
  if (nombre.contains('portugal')) return '🇵🇹';
  if (nombre.contains('colombia')) return '🇨🇴';
  if (nombre.contains('alemania')) return '🇩🇪';
  if (nombre.contains('españa') || nombre.contains('espana')) return '🇪🇸';
  if (nombre.contains('japón') || nombre.contains('japon')) return '🇯🇵';
  if (nombre.contains('marruecos')) return '🇲🇦';
  if (nombre.contains('haití') || nombre.contains('haiti')) return '🇭🇹';
  if (nombre.contains('escocia')) return '🏴';
  if (nombre.contains('australia')) return '🇦🇺';
  if (nombre.contains('turquía') || nombre.contains('turquia')) return '🇹🇷';
  if (nombre.contains('paraguay')) return '🇵🇾';
  if (nombre.contains('uruguay')) return '🇺🇾';
  if (nombre.contains('bélgica') || nombre.contains('belgica')) return '🇧🇪';
  if (nombre.contains('egipto')) return '🇪🇬';
  if (nombre.contains('iran') || nombre.contains('irán')) return '🇮🇷';
  if (nombre.contains('nueva zelanda')) return '🇳🇿';
  if (nombre.contains('noruega')) return '🇳🇴';
  if (nombre.contains('senegal')) return '🇸🇳';
  if (nombre.contains('iraq')) return '🇮🇶';
  if (nombre.contains('austria')) return '🇦🇹';
  if (nombre.contains('croacia')) return '🇭🇷';
  if (nombre.contains('panamá') || nombre.contains('panama')) return '🇵🇦';

  if (nombre.contains('uzbekistan') || nombre.contains('uzbekistán')) {
    return '🇺🇿';
  }

  if (nombre.contains('sudáfrica') ||
      nombre.contains('sudafrica') ||
      nombre.contains('south africa')) {
    return '🇿🇦';
  }

  // Si no encuentra el equipo, se muestra una bandera genérica.
  return '🏳️';
}

class _EstadoError extends StatelessWidget {
  final String mensaje;
  final VoidCallback onRetry;

  const _EstadoError({
    required this.mensaje,
    required this.onRetry,
  });

  static const Color verdeMundial = Color(0xFF1E5628);

  @override
  Widget build(BuildContext context) {
    // Vista para mostrar errores de conexión o consulta.
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.90),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 58,
              ),
              const SizedBox(height: 16),
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: verdeMundial,
                  foregroundColor: Colors.white,
                ),
                onPressed: onRetry,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}