import { defineConfig } from "cypress";
import tasks from './cypress/plugins';

export default defineConfig({
  e2e: {
    baseUrl: 'http://localhost:5173',
    setupNodeEvents(on, config) {
      // implement node event listeners here
      tasks(on, config);
    },
  },

  component: {
    devServer: {
      framework: "svelte",
      bundler: "vite",
    },
  },
});
