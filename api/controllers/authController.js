const jwt = require('jsonwebtoken');
const pool = require('../config/database');

const accessSecret = process.env.JWT_ACCESS_SECRET || 'dev_access_secret';
const refreshSecret = process.env.JWT_REFRESH_SECRET || 'dev_refresh_secret';

const login = async (req, res) => {
    const { usuario, email, password } = req.body;
    const loginValue = usuario || email;

    try {
        const userQuery = 'SELECT id_usuario, password, nombre FROM usuarios WHERE email = $1 OR nombre = $2';
        const userResult = await pool.query(userQuery, [loginValue, loginValue]);

        if (userResult.rows.length === 0) {
            return res.status(401).json({ error: 'Credenciales incorrectas' });
        }

        const usuario = userResult.rows[0];

        if (usuario.password !== password) {
            return res.status(401).json({ error: 'Credenciales incorrectas' });
        }

        const pendingToken = jwt.sign(
            {
                id_usuario: usuario.id_usuario,
                nombre: usuario.nombre,
                confirmado: false,
                tipo: 'confirmacion'
            },
            accessSecret,
            { expiresIn: '10m' }
        );

        return res.status(200).json({
            requires_confirmation: true,
            pending_access_token: pendingToken,
            message: 'Confirma tu acceso para entrar a la app.'
        });
    } catch (error) {
        console.error('Error en Login:', error);
        return res.status(500).json({ error: 'Error en el servidor' });
    }
};

const confirm = async (req, res) => {
    const { pending_access_token } = req.body;

    if (!pending_access_token) {
        return res.status(400).json({ error: 'Token de confirmación requerido.' });
    }

    try {
        const verificado = jwt.verify(pending_access_token, accessSecret);

        if (!verificado || verificado.tipo !== 'confirmacion' || verificado.confirmado) {
            return res.status(403).json({ error: 'Token de confirmación inválido.' });
        }

        const refreshToken = jwt.sign(
            { id_usuario: verificado.id_usuario },
            refreshSecret,
            { expiresIn: '7d' }
        );

        const accessToken = jwt.sign(
            {
                id_usuario: verificado.id_usuario,
                nombre: verificado.nombre,
                confirmado: true,
                tipo: 'acceso'
            },
            accessSecret,
            { expiresIn: '15m' }
        );

        const updateTokenQuery = 'UPDATE usuarios SET refresh_token = $1 WHERE id_usuario = $2';
        await pool.query(updateTokenQuery, [refreshToken, verificado.id_usuario]);

        return res.status(200).json({
            access_token: accessToken,
            refresh_token: refreshToken,
            message: 'Confirmación completada. Ya puedes entrar a la app.'
        });
    } catch (error) {
        return res.status(403).json({ error: 'La confirmación ha expirado o es inválida.' });
    }
};

const refresh = async (req, res) => {
    const { refresh_token } = req.body;

    if (!refresh_token) return res.status(400).json({ error: 'Token requerido' });

    try {
        const verificado = jwt.verify(refresh_token, refreshSecret);

        const query = 'SELECT id_usuario FROM usuarios WHERE id_usuario = $1 AND refresh_token = $2';
        const result = await pool.query(query, [verificado.id_usuario, refresh_token]);

        if (result.rows.length === 0) {
            return res.status(403).json({ error: 'Sesión inválida o expirada.' });
        }

        const nuevoAccessToken = jwt.sign(
            { id_usuario: verificado.id_usuario, confirmado: true, tipo: 'acceso' },
            accessSecret,
            { expiresIn: '15m' }
        );

        return res.status(200).json({ access_token: nuevoAccessToken });
    } catch (error) {
        return res.status(403).json({ error: 'Token de refresco caducado.' });
    }
};

module.exports = { login, confirm, refresh };