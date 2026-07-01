const jwt = require('jsonwebtoken');

const protegerRuta = (req, res, next) => {
    // 1. Obtener el encabezado 'Authorization' enviado por Flutter
    const authHeader = req.headers['authorization'];
    
    // 2. Separar el texto para obtener solo el token (quitando la palabra 'Bearer')
    const token = authHeader && authHeader.split(' ')[1];

    // Si Flutter no envió ningún token, bloqueamos el paso de inmediato
    if (!token) {
        return res.status(401).json({ 
            error: 'Acceso denegado. Token no proporcionado o sesión expirada.' 
        });
    }

    try {
        // 3. Validar matemáticamente el token usando la clave secreta corta de tu .env
        const verificado = jwt.verify(token, process.env.JWT_ACCESS_SECRET);
         
        // Guardamos los datos descifrados del JWT (que incluyen el id_usuario) dentro del objeto 'req.usuario'.
        // Esto es exactamente lo que tu partidosController lee después como: req.usuario.id_usuario
        req.usuario = verificado;
        
        // 5. Todo está perfecto, damos luz verde para continuar hacia el controlador de tu API
        next(); 
    } catch (error) {
    
        // Capturamos el fallo y devolvemos un HTTP 401.
        // Esto activará automáticamente el interceptor que configuramos en tu app de Flutter.
        return res.status(401).json({ 
            error: 'Token inválido o expirado. Requiere renovación en segundo plano.' 
        });
    }
};

module.exports = { protegerRuta };