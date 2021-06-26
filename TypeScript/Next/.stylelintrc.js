module.exports = {
  extends: [
    'stylelint-config-standard',
    'stylelint-config-recess-order',
    'stylelint-config-prettier',
  ],
  plugins: ['stylelint-order'],
  ignoreFiles: ['**/node_modules/**'],
  // CSS in JS の時はPrettier側で設定があるので不要
  rules: {
    'string-quotes': 'single',
  },
};
