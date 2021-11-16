module.exports = {
  extends: [
    'stylelint-config-standard',
    'stylelint-config-recess-order',
    'stylelint-config-prettier',
  ],
  plugins: ['stylelint-order'],
  ignoreFiles: ['**/node_modules/**'],
  rules: {
    'selector-class-pattern': [
      '^([a-z][a-z0-9]*)(-[a-z0-9]+)*(__)*([a-z][a-z0-9]*)(-[a-z0-9]+)*(--)*([a-z][a-z0-9]*)(-[a-z0-9]+)*$',
      {
        message: 'Expected class selector to be BEM',
      },
    ],
  },
};
