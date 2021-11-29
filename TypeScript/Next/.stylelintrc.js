module.exports = {
  extends: [
    'stylelint-config-standard',
    'stylelint-config-recess-order',
    'stylelint-config-prettier',
  ],
  plugins: ['stylelint-order'],
  // v14 + CSS in JS の場合のみ
  overrides: [
    {
      files: ['**/*.{ts,tsx}'],
      customSyntax: '@stylelint/postcss-css-in-js',
    },
  ],
  ignoreFiles: ['**/node_modules/**'],
};
