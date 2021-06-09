module.exports = {
  extends: ['next', 'prettier'],
  overrides: [
    {
      files: ['*.tsx'],
      rules: {
        'react/prop-types': 'off',
      },
    },
  ],
}
