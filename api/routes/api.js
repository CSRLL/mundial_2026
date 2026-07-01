const express = require('express');
const rankingController = require('../controllers/rankingController');
const partidosController = require('../controllers/partidosController');

const { protegerRuta } = require('../middlewares/authMiddleware');

// Se crea el router para definir las rutas principales de la API.
const router = express.Router();

// Ruta para obtener el ranking de usuarios.
router.get('/ranking', rankingController.getRanking);

// Ruta para obtener todos los partidos con su fase, equipos y resultado.
router.get('/partidos', partidosController.getPartidos);

// Ruta para obtener los pronósticos de un partido específico.
router.get(
  '/partidos/:idPartido/pronosticos',
  partidosController.getPronosticosPorPartido
);

// Nueva ruta para que los usuarios guarden sus pronósticos desde Flutter.
// Inyectamos 'protegerRuta' justo antes del controlador.
router.post(
  '/pronosticos', 
  protegerRuta, 
  partidosController.crearPronostico
);

// Se exporta el router para usarlo en el servidor principal.
module.exports = router;