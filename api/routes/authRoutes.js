const express = require('express');
const router = express.Router();
// Importamos el controlador de autenticación que creamos con las consultas a Postgres
const authController = require('../controllers/authController');

// Rutas para tu app de Flutter
router.post('/login', authController.login);
router.post('/confirm', authController.confirm);
router.post('/refresh', authController.refresh);

module.exports = router;