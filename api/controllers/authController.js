const jwt = require('jsonwebtoken');
const pool = require('../config/database');
const { getConfiguredCredentials } = require('../utils/authConfig');

const accessSecret = process.env.JWT_ACCESS_SECRET || 'dev_access_secret';
const refreshSecret = process.env.JWT_REFRESH_SECRET || 'dev_refresh_secret';

const login = async (req, res) => {
    const { email, password } = req.body;
    const configuredCredentials = getConfiguredCredentials();

    if (email !== configuredCredentials.email || password !== configuredCredentials.password) {
        return res.status(401).json({ error: 'Credenciales incorrectas' });
    }

    try {
        const pendingToken = jwt.sign(
            {
                sub: 'app-user',
                nombre: 'Administrador',
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
            { sub: verificado.sub, tipo: 'refresh' },
            refreshSecret,
            { expiresIn: '7d' }
        );

        const accessToken = jwt.sign(
            {
                sub: verificado.sub,
                nombre: verificado.nombre,
                confirmado: true,
                tipo: 'acceso'
            },
            accessSecret,
            { expiresIn: '15m' }
        );

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