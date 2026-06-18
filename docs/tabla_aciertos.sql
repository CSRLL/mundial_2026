-- SQL para PostgreSQL
-- Tabla resumen de aciertos por usuario por ronda.

CREATE TABLE IF NOT EXISTS aciertos (
    usuario_id INTEGER NOT NULL,
    ronda_id INTEGER NOT NULL,
    partidos_acertados INTEGER NOT NULL DEFAULT 0,
    total_partidos INTEGER NOT NULL DEFAULT 0,
    porcentaje NUMERIC(5,2) NOT NULL DEFAULT 0,
    actualizado_en TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (usuario_id, ronda_id),
    CONSTRAINT fk_aciertos_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    CONSTRAINT fk_aciertos_ronda
        FOREIGN KEY (ronda_id) REFERENCES rondas(id)
);

CREATE INDEX IF NOT EXISTS idx_aciertos_ronda_id
    ON aciertos (ronda_id);

CREATE INDEX IF NOT EXISTS idx_aciertos_partidos_acertados
    ON aciertos (partidos_acertados DESC);

-- Ejemplo de inserción (si quieres poblarla manualmente):
-- INSERT INTO aciertos (usuario_id, ronda_id, partidos_acertados, total_partidos, porcentaje)
-- VALUES (1, 1, 5, 8, 62.50);

-- Consulta para el ranking final de una ronda:
-- SELECT
--   u.nombre,
--   a.partidos_acertados,
--   a.total_partidos,
--   a.porcentaje
-- FROM aciertos a
-- JOIN usuarios u ON u.id = a.usuario_id
-- WHERE a.ronda_id = :ronda_id
-- ORDER BY a.partidos_acertados DESC, a.porcentaje DESC;
