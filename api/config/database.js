const { Pool } = require('pg');
require('dotenv').config();

console.log('Intentando conectar a PostgreSQL con:');
console.log('  HOST:', process.env.DATABASE_HOST);
console.log('  PORT:', process.env.DATABASE_PORT);
console.log('  USER:', process.env.DATABASE_USER);
console.log('  DATABASE:', process.env.DATABASE_NAME);

const pool = new Pool({
  host: process.env.DATABASE_HOST,
  port: parseInt(process.env.DATABASE_PORT),
  user: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
});

pool.on('error', (err) => {
  console.error('❌ Error en cliente idle:', err.message);
});

pool.on('connect', () => {
  console.log('✅ Conectado a PostgreSQL correctamente');
});

module.exports = pool;
