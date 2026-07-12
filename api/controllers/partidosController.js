const pool = require('../config/database');


// Función para obtener todos los partidos con su ronda y equipos.
const getPartidos = async (req, res) => {
  try {
    const query = `
      SELECT 
        p.id_partido,
        r.nombre_ronda,
        e1.nombre_equipo AS equipo_local,
        e2.nombre_equipo AS equipo_visitante,
        p.goles_e1,
        p.goles_e2,
        p.fecha,
        p.duracion
      FROM partidos p
      INNER JOIN equipos e1 ON p.id_equipo1 = e1.id_equipo
      INNER JOIN equipos e2 ON p.id_equipo2 = e2.id_equipo
      INNER JOIN rondas r ON p.id_ronda = r.id_ronda
      ORDER BY p.id_ronda, p.fecha;
    `;

        // Ejecuta la consulta en la base de datos.
    const result = await pool.query(query);
    res.json({ partidos: result.rows });
  } catch (error) {
    console.error('Error al obtener partidos:', error);
    res.status(500).json({ message: 'Error al obtener partidos', error: error.message });
  }
};


// Función para obtener los pronósticos de un partido específico.
const getPronosticosPorPartido = async (req, res) => {
  try {
    const { idPartido } = req.params;
    const query = `
      SELECT 
        pr.id_pronostico,
        pr.id_partido,
        pr.id_usuario,
        u.nombre AS nombre_usuario,
        pr.goles_e1,
        pr.goles_e2
      FROM pronostico pr
      INNER JOIN usuarios u ON pr.id_usuario = u.id_usuario
      WHERE pr.id_partido = $1
      ORDER BY pr.id_pronostico ASC;
    `;

     // Se consulta la tabla pronostico y se une con usuarios para obtener el nombre.
    const result = await pool.query(query, [idPartido]);

    // Regresa los pronósticos encontrados para ese partido.
    res.json({ pronosticos: result.rows });
  } catch (error) {

     // Si ocurre un error, se manda una respuesta para avisar al frontend.
    console.error('Error al obtener pronósticos:', error);
    res.status(500).json({ message: 'Error al obtener los pronósticos del partido', error: error.message });
  }
};

// 3. NUEVA FUNCIÓN (PROTEGIDA CON JWT): Para que los usuarios guarden sus apuestas/predicciones
const crearPronostico = async (req, res) => {
  try {
    const { id_partido, goles_e1, goles_e2 } = req.body;
    
  

    const idUsuarioSeguro = req.usuario.id_usuario; 

    const query = `
      INSERT INTO pronostico (id_partido, id_usuario, goles_e1, goles_e2)
      VALUES ($1, $2, $3, $4)
      RETURNING *;
    `;

    const result = await pool.query(query, [id_partido, idUsuarioSeguro, goles_e1, goles_e2]);

    res.status(201).json({
      message: 'Pronóstico registrado con éxito de forma segura',
      pronostico: result.rows[0]
    });
  } catch (error) {
    console.error('Error al crear pronóstico:', error);
    res.status(500).json({ message: 'No se pudo guardar el pronóstico', error: error.message });
  }
};

// Exportamos las tres funciones
module.exports = {
  getPartidos,
  getPronosticosPorPartido,
  crearPronostico, 
};