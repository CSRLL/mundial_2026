# Mundial 2026 - Ranking de Aciertos

Aplicación Flutter que muestra el ranking mundial de pronósticos con conexión a una base de datos PostgreSQL y API REST en Node.js.

## Características

- 🏆 **Pantalla de Ranking** - Visualizar usuarios ordenados por aciertos
- 📊 **Estadísticas** - Muestra X/Y aciertos (aciertos de total de predicciones)
- 🎨 **Colores del Mundial** - Tema verde oscuro (#1E5628) y dorado (#FFD700)
- 🥇 **Medallas Dinámicas** - Oro, plata y bronce para los top 3
- 🔄 **Actualización en Tiempo Real** - Botón refresh para actualizar datos
- 📱 **Responsive Design** - Funciona en móviles, tablets y web

## Tecnología

- **Frontend:** Flutter
- **Backend:** Node.js + Express
- **Base de Datos:** PostgreSQL
- **State Management:** Provider

## Estructura del Proyecto

```
mundial_2026/
├── api/                          (API Node.js)
│   ├── config/database.js        (Conexión PostgreSQL)
│   ├── controllers/rankingController.js
│   ├── routes/api.js
│   └── server.js
├── database/                     (Scripts SQL)
│   └── create_aciertos_table.sql
├── lib/                          (Aplicación Flutter)
│   ├── screens/ranking_screen.dart
│   ├── models/ranking_entry.dart
│   ├── providers/ranking_provider.dart
│   ├── services/ranking_service.dart
│   └── main.dart
└── Documentación/
    ├── IMPLEMENTACIÓN.md
    ├── API_README.md
    └── GUÍA_RÁPIDA.txt
```

## Instalación Rápida

### 1. Base de Datos
```bash
psql -h 31.97.102.106 -p 5342 -U administrador -d Mundial_2026 -f database/create_aciertos_table.sql
```

### 2. API
```bash
cd api
npm install
npm start
```

### 3. Flutter
```bash
flutter pub get
flutter run
```

## Uso

1. Asegúrate de que el API esté corriendo
2. Abre la aplicación Flutter
3. Presiona el botón de refresh para cargar el ranking
4. Visualiza los usuarios ordenados por aciertos

## Cálculo de Aciertos

Un pronóstico es correcto cuando ambos goles coinciden exactamente con el resultado real:

- **Ejemplo correcto:** Pronóstico (2-1) = Resultado (2-1) ✓
- **Ejemplo incorrecto:** Pronóstico (2-0) ≠ Resultado (2-1) ✗

El ranking se ordena por: aciertos (descendente) → porcentaje (descendente)

## Documentación

- **[IMPLEMENTACIÓN.md](IMPLEMENTACIÓN.md)** - Guía paso a paso completa
- **[API_README.md](API_README.md)** - Documentación técnica del API
- **[GUÍA_RÁPIDA.txt](GUÍA_RÁPIDA.txt)** - Checklist de implementación
- **[RESUMEN_IMPLEMENTACIÓN.md](RESUMEN_IMPLEMENTACIÓN.md)** - Resumen visual

## Credenciales de Acceso

**PostgreSQL:**
- Host: 31.97.102.106
- Puerto: 5342
- Usuario: administrador
- Contraseña: Penjamo-123
- BD: Mundial_2026

**API:**
- URL: http://31.97.102.106:5342
- Endpoint: /api/ranking

## Solución de Problemas

Consulta la sección **"Solución de Problemas"** en [IMPLEMENTACIÓN.md](IMPLEMENTACIÓN.md) para más detalles.

## Estado del Proyecto

✅ Implementación completa y lista para usar
