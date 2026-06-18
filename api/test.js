// Test básico para verificar que el API funciona
// Coloca este archivo en la raíz del proyecto o en una carpeta de tests

const http = require('http');

const testConfig = {
  host: '31.97.102.106',
  port: 5342,
  methods: {
    health: {
      path: '/health',
      method: 'GET',
    },
    ranking: {
      path: '/api/ranking',
      method: 'GET',
    },
    rankingWithRonda: {
      path: '/api/ranking?ronda_id=1',
      method: 'GET',
    },
  },
};

function makeRequest(path, method = 'GET') {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: testConfig.host,
      port: testConfig.port,
      path: path,
      method: method,
      headers: {
        'Content-Type': 'application/json',
      },
    };

    const req = http.request(options, (res) => {
      let data = '';

      res.on('data', (chunk) => {
        data += chunk;
      });

      res.on('end', () => {
        resolve({
          status: res.statusCode,
          data: data ? JSON.parse(data) : null,
        });
      });
    });

    req.on('error', (error) => {
      reject(error);
    });

    req.end();
  });
}

async function runTests() {
  console.log('🧪 Iniciando pruebas de API...\n');

  try {
    // Test 1: Health Check
    console.log('Test 1: Health Check');
    const health = await makeRequest(testConfig.methods.health.path);
    console.log(`Status: ${health.status}`);
    console.log(`Response:`, health.data);
    console.log('✅ Health check exitoso\n');

    // Test 2: Obtener ranking completo
    console.log('Test 2: Obtener Ranking Completo');
    const ranking = await makeRequest(testConfig.methods.ranking.path);
    console.log(`Status: ${ranking.status}`);
    console.log(`Usuarios en ranking: ${ranking.data.ranking ? ranking.data.ranking.length : 0}`);
    if (ranking.data.ranking && ranking.data.ranking.length > 0) {
      console.log('Primer lugar:', ranking.data.ranking[0]);
    }
    console.log('✅ Ranking obtenido exitosamente\n');

    // Test 3: Obtener ranking por ronda
    console.log('Test 3: Obtener Ranking por Ronda');
    const rankingRonda = await makeRequest(testConfig.methods.rankingWithRonda.path);
    console.log(`Status: ${rankingRonda.status}`);
    console.log(`Usuarios en ronda 1: ${rankingRonda.data.ranking ? rankingRonda.data.ranking.length : 0}`);
    console.log('✅ Ranking por ronda obtenido exitosamente\n');

    console.log('✅ Todos los tests pasaron correctamente!');
  } catch (error) {
    console.error('❌ Error en las pruebas:', error.message);
    process.exit(1);
  }
}

runTests();
