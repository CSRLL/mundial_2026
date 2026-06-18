-- Tabla de aciertos para guardar el ranking de usuarios por ronda
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

-- Índices para optimizar búsquedas
CREATE INDEX IF NOT EXISTS idx_aciertos_usuario ON aciertos(id_usuario);
CREATE INDEX IF NOT EXISTS idx_aciertos_ronda ON aciertos(id_ronda);
CREATE INDEX IF NOT EXISTS idx_aciertos_ranking ON aciertos(numero_aciertos DESC, porcentaje DESC);
