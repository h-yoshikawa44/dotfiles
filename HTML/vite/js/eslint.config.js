import js from '@eslint/js';
import globals from 'globals';
import neostandard, { plugins } from 'neostandard';

/** @type { import("eslint").Linter.Config[] } */
export default [
  {
    ignores: ['node_modules/**', 'eslint.config.js'],
  },
  js.configs.recommended,
  ...neostandard(),
  plugins['@stylistic'].configs.customize({
    semi: true,
  }),
  plugins.n.configs['flat/recommended-module'],
  plugins.promise.configs['flat/recommended'],
  {
    files: ['js/**/*.js'],
    languageOptions: {
      parserOptions: {
        ecmaVersion: 12,
        sourceType: 'module',
      },
      globals: {
        ...globals.browser,
      },
    },
  },
];
