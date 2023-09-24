module.exports = {
  plugins: [
    require('postcss-preset-env')({
      features: {
        'focus-visible-pseudo-class': { enableClientSidePolyfills: true },
      },
    }),
  ],
};
