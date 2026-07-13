const test = require('node:test');
const assert = require('node:assert/strict');

const { getConfiguredCredentials } = require('../utils/authConfig');

test('usa credenciales desde variables de entorno cuando existen', () => {
  process.env.APP_LOGIN_EMAIL = 'demo@local.test';
  process.env.APP_LOGIN_PASSWORD = 'supersecret';

  const credentials = getConfiguredCredentials();

  assert.equal(credentials.email, 'demo@local.test');
  assert.equal(credentials.password, 'supersecret');
});

test('usa valores por defecto cuando no hay variables de entorno', () => {
  delete process.env.APP_LOGIN_EMAIL;
  delete process.env.APP_LOGIN_PASSWORD;

  const credentials = getConfiguredCredentials();

  assert.equal(credentials.email, 'admin@mundial2026.local');
  assert.equal(credentials.password, 'Mundial2026!');
});
