-- Crear tabla de aciertos en PostgreSQL
-- Ejecutar esta consulta en pgAdmin o desde la CLI de PostgreSQL

CREATE TABLE IF NOT EXISTS aciertos (
    id_acierto SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    id_ronda INTEGER REFERENCES rondas(id_ronda) ON DELETE CASCADE,
    numero_aciertos INTEGER NOT NULL DEFAULT 0,
    total_pronosticos INTEGER NOT NULL DEFAULT 0,
    porcentaje DECIMAL(5, 2) NOT NULL DEFAULT 0.00,
    fecha_calculo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id_usuario, id_ronda)
);

-- Crear índices para optimizar búsquedas
CREATE INDEX IF NOT EXISTS idx_aciertos_usuario ON aciertos(id_usuario);
CREATE INDEX IF NOT EXISTS idx_aciertos_ronda ON aciertos(id_ronda);
CREATE INDEX IF NOT EXISTS idx_aciertos_ranking ON aciertos(numero_aciertos DESC, porcentaje DESC);

-- Verificar que la tabla se creó correctamente
SELECT table_name FROM information_schema.tables WHERE table_name = 'aciertos';

-- Ver estructura de la tabla
\d aciertos;
