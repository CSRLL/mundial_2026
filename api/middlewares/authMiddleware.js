const jwt = require('jsonwebtoken');

const protegerRuta = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({
            error: 'Acceso denegado. Se requiere confirmación para entrar a la app.'
        });
    }

    try {
        const verificado = jwt.verify(token, process.env.JWT_ACCESS_SECRET || 'dev_access_secret');

        if (!verificado.confirmado) {
            return res.status(403).json({
                error: 'Confirmación requerida para acceder a la app.'
            });
        }

        req.usuario = verificado;
        next();
    } catch (error) {
        return res.status(401).json({
            error: 'Token inválido o expirado. Requiere confirmación o renovación.'
        });
    }
};

module.exports = { protegerRuta };