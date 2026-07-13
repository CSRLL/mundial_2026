const getConfiguredCredentials = () => {
  const email = process.env.APP_LOGIN_EMAIL || 'admin@mundial2026.local';
  const password = process.env.APP_LOGIN_PASSWORD || 'Mundial2026!';

  return { email, password };
};

module.exports = { getConfiguredCredentials };
