const express = require('express');
const rankingController = require('../controllers/rankingController');
const partidosController = require('../controllers/partidosController');

const router = express.Router();

router.get('/ranking', rankingController.getRanking);
router.get('/partidos', partidosController.getPartidos);

module.exports = router;
