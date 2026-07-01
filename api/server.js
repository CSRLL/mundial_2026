const express = require('express');
const cors = require('cors');
require('dotenv').config();

const apiRoutes = require('./routes/api');
const authRoutes = require('./routes/authRoutes'); 

const app = express();
const PORT = process.env.SERVER_PORT || 5342;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// REGISTRO DE RUTAS
app.use('/api', apiRoutes);
app.use('/api/auth', authRoutes); 

app.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'API en funcionamiento' });
});

app.use((err, req, res, next) => {
  console.error(err);
  res.status(err.status || 500).json({
    error: err.message || 'Error interno del servidor',
  });
});

app.listen(PORT, () => {
  console.log(`Servidor iniciado en puerto ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
});

module.exports = app;