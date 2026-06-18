# Implementación - Pantalla de Ranking Mundial 2026

Este documento contiene los pasos para implementar la solución completa de la pantalla de ranking con acceso a la base de datos PostgreSQL.

## 📁 Estructura de Archivos Creados

```
mundial_2026/
├── api/
│   ├── package.json                    (Dependencias Node.js)
│   ├── .env                           (Configuración BD)
│   ├── server.js                      (Servidor principal)
│   ├── test.js                        (Tests de API)
│   ├── config/
│   │   └── database.js                (Conexión a PostgreSQL)
│   ├── controllers/
│   │   └── rankingController.js       (Lógica del ranking)
│   └── routes/
│       └── api.js                     (Rutas de la API)
├── database/
│   ├── schema.sql                     (Definición de tabla aciertos)
│   └── create_aciertos_table.sql      (Script para crear tabla)
├── lib/
│   ├── main.dart                      (App principal con colores mundial)
│   ├── config/
│   │   └── app_config.dart            (Configuración)
│   ├── models/
│   │   └── ranking_entry.dart         (Modelo de datos)
│   ├── providers/
│   │   └── ranking_provider.dart      (Gestión de estado)
│   ├── services/
│   │   └── ranking_service.dart       (Conexión a API)
│   ├── screens/
│   │   └── ranking_screen.dart        (Pantalla principal - MEJORADA)
│   └── routes/
│       └── app_routes.dart            (Rutas de navegación)
└── API_README.md                      (Documentación API)
```

## 🔧 Paso 1: Crear Tabla de Aciertos en PostgreSQL

### Opción A: Con pgAdmin
1. Abre pgAdmin
2. Conéctate a tu servidor en `31.97.102.106:5342`
3. Selecciona la BD `Mundial_2026`
4. Abre Query Tool
5. Copia y ejecuta el contenido de `database/create_aciertos_table.sql`

### Opción B: Con CLI de PostgreSQL
```bash
psql -h 31.97.102.106 -p 5342 -U administrador -d Mundial_2026 -f database/create_aciertos_table.sql
```

**Contraseña:** `Penjamo-123`

Verifica que la tabla se creó:
```sql
SELECT table_name FROM information_schema.tables WHERE table_name = 'aciertos';
```

## 🚀 Paso 2: Configurar e Iniciar la API Node.js

### 2.1 Instalar Node.js (si no lo tienes)
Descarga desde: https://nodejs.org/

### 2.2 Instalar dependencias de la API
```bash
cd api
npm install
```

Esto instalará:
- express: Framework web
- pg: Driver PostgreSQL
- cors: Control de origen cruzado
- dotenv: Variables de entorno

### 2.3 Verificar la configuración en `.env`
El archivo `.env` debe contener:
```
DATABASE_HOST=31.97.102.106
DATABASE_PORT=5342
DATABASE_USER=administrador
DATABASE_PASSWORD=Penjamo-123
DATABASE_NAME=Mundial_2026
SERVER_PORT=5342
```

### 2.4 Iniciar el servidor
**Modo desarrollo (con reinicio automático):**
```bash
npm run dev
```

**Modo producción:**
```bash
npm start
```

Deberías ver:
```
Servidor iniciado en puerto 5342
Health check: http://localhost:5342/health
```

## 🧪 Paso 3: Probar la API

### Opción A: Con Node.js
```bash
node api/test.js
```

### Opción B: Con curl
```bash
# Health check
curl http://31.97.102.106:5342/health

# Obtener ranking
curl http://31.97.102.106:5342/api/ranking

# Obtener ranking de una ronda específica
curl "http://31.97.102.106:5342/api/ranking?ronda_id=1"
```

### Opción C: En el navegador
Navega a: `http://31.97.102.106:5342/health`

Deberías ver: `{"status":"OK","message":"API en funcionamiento"}`

## 📱 Paso 4: Ejecutar la Aplicación Flutter

### 4.1 Instalar dependencias Flutter
```bash
flutter pub get
```

### 4.2 Ejecutar la aplicación
```bash
flutter run
```

### 4.3 Pruebas en la APP
- La pantalla debe cargar el ranking automáticamente
- Presiona el icono de refresh para actualizar
- Verifica los colores del mundial (verde y dorado)
- Los usuarios deben estar ordenados por aciertos (descendente)
- Cada usuario muestra "X/Y aciertos" (ej: 45/64 aciertos)

## 🎨 Mejoras Realizadas en la Pantalla de Ranking

### Colores del Mundial
- **Color Principal:** Verde oscuro (`#1E5628`)
- **Color Secundario:** Dorado (`#FFD700`)
- **Medallas:** Oro (1er), Plata (2do), Bronce (3er)

### Nuevas Características
✅ Botón de refresh en AppBar
✅ Colores dinámicos para medallas
✅ Mejor visual con Card elevadas
✅ Muestra "X/Y aciertos" en lugar de solo aciertos
✅ Porcentaje de aciertos mejorado
✅ Responsive design

### Estructura de Datos Retornada

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

## 📊 Tabla de Aciertos - Estructura

```
Columna              | Tipo          | Descripción
---------------------|---------------|---------------------------
id_acierto          | SERIAL        | ID único (PK)
id_usuario          | INTEGER       | Usuario (FK)
id_ronda            | INTEGER       | Ronda (FK, nullable)
numero_aciertos     | INTEGER       | Pronósticos correctos
total_pronosticos   | INTEGER       | Total de pronósticos
porcentaje          | DECIMAL(5,2)  | % de aciertos
fecha_calculo       | TIMESTAMP     | Última actualización
```

## ⚠️ Solución de Problemas

### Error: "No se pudo cargar el ranking"
**Solución:** Verifica que:
- El API está corriendo (`npm start`)
- PostgreSQL está accesible
- La tabla `aciertos` existe
- La configuración en `.env` es correcta

### API no responde
**Solución:**
1. Verifica puerto: `netstat -ano | findstr :5342` (Windows)
2. Mata proceso: `taskkill /PID {id} /F`
3. Reinicia: `npm start`

### Usuarios sin ranking
**Solución:**
- Verifica que haya registros en `usuarios`, `pronosticos` y `resultados`
- Los IDs de partidos deben coincidir entre `pronosticos` y `resultados`

### Flutter no se conecta
**Solución:**
- Asegúrate que la IP `31.97.102.106` sea accesible desde tu máquina
- Prueba: `ping 31.97.102.106`
- Verifica el puerto: `telnet 31.97.102.106 5342`

## 📝 Notas Importantes

1. **API y Flutter deben correr simultáneamente** para que funcione la aplicación
2. **La tabla `aciertos` se llena calculando en tiempo real** desde `pronosticos` y `resultados`
3. **El cálculo de aciertos es exacto:** ambos goles deben coincidir
4. **El ranking se ordena por:** aciertos (descendente) → porcentaje (descendente)

## 🔄 Flujo de Datos

```
PostgreSQL (BD)
    ↓
    ├── usuarios
    ├── pronosticos
    ├── resultados
    └── aciertos (nueva tabla)
    ↓
API Node.js (Endpoint /api/ranking)
    ↓
Flutter App (RankingService)
    ↓
RankingProvider (State Management)
    ↓
RankingScreen (UI)
```

## 📚 Documentación Adicional

- `API_README.md` - Documentación completa de la API
- `database/schema.sql` - Definición de tabla
- `api/controllers/rankingController.js` - Lógica de cálculo
- `lib/screens/ranking_screen.dart` - UI mejorada

¡La implementación está lista! Sigue los pasos en orden y tendrás tu pantalla de ranking funcionando. 🎉
