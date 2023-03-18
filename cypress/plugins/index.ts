import getUserSession from './tasks';
import dotenv from 'dotenv';

export default (on, config) => {
  const envVars = dotenv.config();
    if (envVars.error) {
    throw envVars.error;
  }
  config.env = { ...config.env, ...envVars.parsed };

  on('task', {
    getUserSession: getUserSession(config.env),
  });

  return config;
};
