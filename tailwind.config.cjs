const config = {
  content: [
    './src/**/*.{html,js,svelte,ts}',
    require('path').join(require.resolve('@skeletonlabs/skeleton'), '../**/*.{html,js,svelte,ts}')
  ],

  darkMode: 'class',

  theme: {
    extend: {}
  },

  plugins: [
    ...require('@skeletonlabs/skeleton/tailwind/skeleton.cjs')(),
    require('@tailwindcss/forms'),
  ]
};

module.exports = config;
