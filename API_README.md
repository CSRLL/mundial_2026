# API Rest - Mundial 2026

API REST para calcular y obtener el ranking de aciertos del Mundial 2026.

## Requisitos Previos

- Node.js (v14 o superior)
- PostgreSQL (con la BD Mundial_2026 configurada)
- npm

## Instalación

1. Navega a la carpeta de la API:
```bash
cd api
```

2. Instala las dependencias:
```bash
npm install
```

## Configuración

El archivo `.env` ya contiene la configuración de conexión a la BD:
```
DATABASE_HOST=31.97.102.106
DATABASE_PORT=5342
DATABASE_USER=administrador
DATABASE_PASSWORD=Penjamo-123
DATABASE_NAME=Mundial_2026
SERVER_PORT=5342
```

## Ejecución

### Modo desarrollo (con reinicio automático):
```bash
npm run dev
```

### Modo producción:
```bash
npm start
```

El servidor estará disponible en: `http://31.97.102.106:5342`

## Endpoints

### GET /api/ranking
Obtiene el ranking completo de usuarios ordenado por aciertos.

**Parámetros opcionales:**
- `ronda_id` (query): Filtra por ID de ronda

**Respuesta:**
```json
{
  "ranking": [
    {
      "user_id": 1,
      "user_name": "Juan Pérez",
      "aciertos": 45,
      "total_pronosticos": 64,
      "porcentaje": 70.31,
      "posicion": 1
    },
    {
      "user_id": 2,
      "user_name": "María López",
      "aciertos": 42,
      "total_pronosticos": 64,
      "porcentaje": 65.63,
      "posicion": 2
    }
  ]
}
```

**Notas:**
- `aciertos`: Número de predicciones correctas
- `total_pronosticos`: Total de predicciones realizadas
- El formato en UI será: "45/64 aciertos" (aciertos/total)

### POST /api/ranking/update
Actualiza los aciertos de un usuario en la tabla `aciertos`.

**Body:**
```json
{
  "id_usuario": 1,
  "id_ronda": 1
}
```

## Estructura de la Base de Datos

### Tabla `aciertos`
La tabla de aciertos guarda el ranking calculado:

```sql
CREATE TABLE IF NOT EXISTS aciertos (
    id_acierto SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL REFERENCES usuarios(id_usuario),
    id_ronda INTEGER REFERENCES rondas(id_ronda),
    numero_aciertos INTEGER NOT NULL DEFAULT 0,
    total_pronosticos INTEGER NOT NULL DEFAULT 0,
    porcentaje DECIMAL(5, 2) NOT NULL DEFAULT 0.00,
    fecha_calculo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id_usuario, id_ronda)
);
```

**Campos:**
- `id_acierto`: ID único de la entrada
- `id_usuario`: Usuario al que pertenecen los aciertos
- `id_ronda`: Ronda del mundial (NULL = todas las rondas)
- `numero_aciertos`: Cantidad de pronósticos correctos
- `total_pronosticos`: Total de pronósticos realizados
- `porcentaje`: Porcentaje de aciertos
- `fecha_calculo`: Última vez que se calculó

## Lógica de Cálculo

El cálculo de aciertos se realiza comparando los pronósticos de cada usuario con los resultados reales:

- Un pronóstico es correcto si: `goles_e1 == marcador_equipo1 AND goles_e2 == marcador_equipo2`
- El porcentaje se calcula como: `(aciertos / total_pronosticos) * 100`
- El ranking se ordena por: aciertos (descendente) y porcentaje (descendente)

## Integración con Flutter

La aplicación Flutter consume los datos de esta API a través de:

**Base URL:** `http://31.97.102.106:5342`
**Endpoint:** `/api/ranking`

El RankingService en Flutter realiza una petición GET y procesa la respuesta.

## Solución de Problemas

### Error de conexión a BD
- Verifica que PostgreSQL esté corriendo en `31.97.102.106:5342`
- Confirma que el usuario y contraseña sean correctos
- Asegúrate de que la BD `Mundial_2026` existe

### El API no responde
- Verifica que Node.js esté instalado
- Confirma que las dependencias están instaladas: `npm install`
- Intenta acceder a `/health` para verificar el estado: `http://localhost:5342/health`

### Ranking vacío o incorrecto
- Verifica que existan registros en las tablas: `usuarios`, `pronosticos`, `resultados`
- Asegúrate de que los IDs de partidos en pronósticos coincidan con los de resultados
