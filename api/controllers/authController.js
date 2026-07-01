const jwt = require('jsonwebtoken');
const pool = require('../config/database'); // Tu conexión a Postgres

const login = async (req, res) => {
    const { email, password } = req.body;

    try {
        // 1. Buscar el usuario en Postgres
        const userQuery = 'SELECT id_usuario, password, nombre FROM usuarios WHERE email = $1';
        const userResult = await pool.query(userQuery, [email]);

        if (userResult.rows.length === 0) {
            return res.status(401).json({ error: 'Credenciales incorrectas' });
        }

        const usuario = userResult.rows[0];

        // 2. VERIFICACIÓN DE CONTRASEÑA 
        if (usuario.password !== password) { 
            return res.status(401).json({ error: 'Credenciales incorrectas' });
        }

        // 3. Generar Access Token metiendo el "id_usuario" que pide tu base de datos
        const accessToken = jwt.sign(
            { id_usuario: usuario.id_usuario, nombre: usuario.nombre }, 
            process.env.JWT_ACCESS_SECRET, 
            { expiresIn: '15m' }
        );

        // 4. Generar Refresh Token
        const refreshToken = jwt.sign(
            { id_usuario: usuario.id_usuario }, 
            process.env.JWT_REFRESH_SECRET, 
            { expiresIn: '7d' }
        );

        // 5. RESPALDO EN POSTGRES: Guardamos el refresh token en la base de datos
        const updateTokenQuery = 'UPDATE usuarios SET refresh_token = $1 WHERE id_usuario = $2';
        await pool.query(updateTokenQuery, [refreshToken, usuario.id_usuario]);

        // Responder a Flutter
        return res.status(200).json({
            access_token: accessToken,
            refresh_token: refreshToken
        });

    } catch (error) {
        console.error('Error en Login:', error);
        return res.status(500).json({ error: 'Error en el servidor' });
    }
};

const refresh = async (req, res) => {
    const { refresh_token } = req.body;

    if (!refresh_token) return res.status(400).json({ error: 'Token requerido' });

    try {
        // Verificar firma del refresh token
        const verificado = jwt.verify(refresh_token, process.env.JWT_REFRESH_SECRET);

        // Validar en Postgres si ese token sigue registrado y activo para ese usuario
        const query = 'SELECT id_usuario FROM usuarios WHERE id_usuario = $1 AND refresh_token = $2';
        const result = await pool.query(query, [verificado.id_usuario, refresh_token]);

        if (result.rows.length === 0) {
            return res.status(403).json({ error: 'Sesión inválida o expirada.' });
        }

        // Si existe en la BD, generamos un Access Token nuevo por 15 minutos más
        const nuevoAccessToken = jwt.sign(
            { id_usuario: verificado.id_usuario }, 
            process.env.JWT_ACCESS_SECRET, 
            { expiresIn: '15m' }
        );

        return res.status(200).json({ access_token: nuevoAccessToken });

    } catch (error) {
        return res.status(403).json({ error: 'Token de refresco caducado.' });
    }
};

module.exports = { login, refresh };