const pool = require('../config/database');

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

    const result = await pool.query(query);

    res.json({
      partidos: result.rows,
    });
  } catch (error) {
    console.error('Error al obtener partidos:', error);
    res.status(500).json({
      message: 'Error al obtener partidos',
      error: error.message,
    });
  }
};

module.exports = {
  getPartidos,
};