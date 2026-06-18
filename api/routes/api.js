const express = require('express');
const rankingController = require('../controllers/rankingController');

const router = express.Router();

router.get('/ranking', rankingController.getRanking);

module.exports = router;
