/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './src/**/*.{html,js,svelte,ts}',
    './node_modules/layerchart/**/*.{svelte,js}'
  ],

  theme: {
    colors: {
      'book-spine': '#e95a85',
      'roasted': '#654d4b',  /* 4c5256 */
      'meaty': '#a16f89',
      'cheesy': '#f0eb54',
      'earthy': '#7b6c66',
      'mustardy': '#dac900',
      'sulphurous': '#fade00',
      'marine': '#03bab1',
      'brine-salt': '#7de1c6',
      'green-grassy': '#61cd3b',
      'spicy': '#d0845e',
      'woodland': '#62a14e',
      'fresh-fruity': '#ed89b1',
      'creamy-fruity': '#efcce1',
      'citrussy': '#eceb01',
      'bramble-hedge': '#765970',
      'floral-fruity': '#b15582',
    }
  },

  plugins: []
};
