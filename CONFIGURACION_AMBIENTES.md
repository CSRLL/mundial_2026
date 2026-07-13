# Configuración de Ambientes - App Ranking

## Cómo cambiar entre DESARROLLO y PRODUCCIÓN

### 📁 Archivo principal: `lib/config/app_config.dart`

```dart
class AppConfig {
  // ==========================================
  // CONFIGURAR AQUÍ SEGÚN EL AMBIENTE
  // ==========================================
  static const String _productionUrl = 'http://178.16.142.158:5342';
  static const String _developmentUrl = 'http://192.168.1.109:5342';
  
  // Selecciona el ambiente activo:
  // true  = PRODUCCIÓN (servidor remoto)
  // false = DESARROLLO (localhost)
  static const bool _isProduction = true;  // ← CAMBIA AQUÍ
  // ==========================================
}
```

---

## Pasos para cambiar de ambiente

### Para DESARROLLO (pruebas locales):

1. Abre `lib/config/app_config.dart`
2. Cambia: `static const bool _isProduction = false;`
3. Asegúrate que tu servidor Node.js corre en tu PC con:
   ```bash
   npm start
   ```
4. El `.env` debe tener: `DATABASE_HOST=178.16.142.158`
5. Ejecuta la app en el emulador o dispositivo

### Para PRODUCCIÓN (servidor remoto):

1. Abre `lib/config/app_config.dart`
2. Cambia: `static const bool _isProduction = true;`
3. Asegúrate que el servidor Node.js corre en `178.16.142.158:5342`
4. Genera el APK:
   ```bash
   flutter build apk --release
   ```
5. Distribuye el APK vía QR

---

## URLs por ambiente

```
DESARROLLO:  http://192.168.1.109:5342
PRODUCCIÓN:  http://178.16.142.158:5342
```

---

## Endpoints disponibles

- `/api/ranking` - Obtiene el ranking de jugadores
- `/api/partidos` - Obtiene todos los partidos
- `/api/partidos/{id}/pronosticos` - Obtiene pronósticos de un partido

---

## Notas para agregar autenticación (JWT)

Cuando agregues login:

1. **Crea un servicio de autenticación en Flutter**
   ```dart
   class AuthService {
     Future<String> login(String user, String password) async {
       // Llama a /api/auth/login
       // Retorna el JWT token
     }
   }
   ```

2. **Guarda el token en SharedPreferences**
   ```dart
   final prefs = await SharedPreferences.getInstance();
   await prefs.setString('jwt_token', token);
   ```

3. **Añade el token a los headers de peticiones**
   ```dart
   final token = await _getToken();
   final headers = {
     'Authorization': 'Bearer $token',
     'Content-Type': 'application/json',
   };
   final response = await _client.get(uri, headers: headers);
   ```

---
