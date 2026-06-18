const pool = require('../config/database');

const rankingController = {
  async getRanking(req, res) {
    try {
      const query = `
        SELECT 
          u.id_usuario as user_id,
          u.nombre as user_name,
          COALESCE(SUM(CASE WHEN p.goles_e1 = r.marcador_equipo1 AND p.goles_e2 = r.marcador_equipo2 THEN 1 ELSE 0 END), 0) as aciertos,
          COUNT(p.id_pronostico) as total_pronosticos,
          CASE 
            WHEN COUNT(p.id_pronostico) = 0 THEN 0
            ELSE ROUND((SUM(CASE WHEN p.goles_e1 = r.marcador_equipo1 AND p.goles_e2 = r.marcador_equipo2 THEN 1 ELSE 0 END)::numeric / COUNT(p.id_pronostico)) * 100, 2)
          END as porcentaje
        FROM usuarios u
        LEFT JOIN pronostico p ON u.id_usuario = p.id_usuario
        LEFT JOIN resultados r ON p.id_partido = r.partido
        GROUP BY u.id_usuario, u.nombre
        ORDER BY aciertos DESC, porcentaje DESC
      `;

      const result = await pool.query(query);

      const ranking = result.rows.map((row, index) => ({
        user_id: row.user_id,
        user_name: row.user_name,
        aciertos: parseInt(row.aciertos),
        total_pronosticos: parseInt(row.total_pronosticos),
        porcentaje: parseFloat(row.porcentaje),
        posicion: index + 1,
      }));

      res.json({ ranking });
    } catch (error) {
      console.error('Error en getRanking:', error);
      res.status(500).json({ error: 'Error al obtener ranking', details: error.message });
    }
  },
};

module.exports = rankingController;
