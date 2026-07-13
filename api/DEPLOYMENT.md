# Guía de Deployment - API Ranking Mundial 2026

## Configuración por Ambiente

### 🔧 DESARROLLO (Pruebas locales)

**Archivo `.env` para desarrollo:**
```env
DATABASE_HOST=178.16.142.158
DATABASE_PORT=5432
DATABASE_USER=administrador
DATABASE_PASSWORD=tu_contraseña
DATABASE_NAME=mundial_2026
SERVER_PORT=5342
NODE_ENV=development
```

**En `lib/config/app_config.dart` (Flutter):**
```dart
static const bool _isProduction = false;  // ← Cambiar a FALSE
```

**Ejecutar localmente:**
```bash
cd api
npm install
npm start
```

La app se conectará a: `http://192.168.1.109:5342`

---

### 🚀 PRODUCCIÓN (Servidor remoto)

**Archivo `.env` en servidor remoto:**
```env
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=administrador
DATABASE_PASSWORD=tu_contraseña
DATABASE_NAME=mundial_2026
SERVER_PORT=5342
NODE_ENV=production
```

**En `lib/config/app_config.dart` (Flutter):**
```dart
static const bool _isProduction = true;  // ← Cambiar a TRUE
```

**Desplegar en servidor remoto:**
```bash
ssh lermario@178.16.142.158

# En el servidor:
cd ~/mundial_2026/api
nano .env  # Pega la configuración de PRODUCCIÓN
npm install
npm start

# O con PM2 (para que corra siempre):
pm2 start server.js --name mundial-api
pm2 save
```

La app se conectará a: `http://178.16.142.158:5342`

---

## ⚠️ Importante

1. **NUNCA subas el `.env` real a GitHub** (está en `.gitignore` por seguridad)
2. **El `.env.example` SÍ va en GitHub** (como referencia)
3. Crea el `.env` manualmente en cada ambiente
4. Cambia `_isProduction` en `app_config.dart` según dónde corras la app

---

## Variables de Configuración Rápida

| Variable | Desarrollo | Producción |
|----------|-----------|-----------|
| DATABASE_HOST | 178.16.142.158 | localhost |
| NODE_ENV | development | production |
| _isProduction | false | true |
| API URL | 192.168.1.109:5342 | 178.16.142.158:5342 |

---

## Para agregar Login y JWT (futuro)

Cuando añadas autenticación:

1. Crea un endpoint `/api/auth/login` en Node.js
2. Retorna un JWT token
3. Guarda el token en SharedPreferences (Flutter)
4. Añade el token en los headers de todas las peticiones:
   ```dart
   final headers = {
     'Authorization': 'Bearer $token',
     'Content-Type': 'application/json',
   };
   ```

---
