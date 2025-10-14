import eslint from '@eslint/js';
import globals from 'globals';
import react from 'eslint-plugin-react';
import reactHooks from 'eslint-plugin-react-hooks';
import stylistic from '@stylistic/eslint-plugin';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  {
    files: ['**/*.{ts,tsx}'],
    plugins: { 'react': react, 'react-hooks': reactHooks, '@stylistic': stylistic },
    extends: [
      tseslint.configs.recommendedTypeChecked,
      stylistic.configs.recommended,
      tseslint.configs.stylisticTypeChecked,
      react.configs.flat.recommended,
      react.configs.flat['jsx-runtime'],
      reactHooks.configs.flat.recommended
    ],
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
        ecmaFeatures: {
          jsx: true
        }
      },
      globals: {
        ...globals.browser,
      }
    },
    rules: {
      'no-empty': ['error', { allowEmptyCatch: true }],
      'no-constant-condition': 'error',
      "@stylistic/comma-dangle": [
        "error",
        {
          'arrays': 'always-multiline',
          'objects': 'always-multiline',
          'functions': 'ignore'
        }
      ],
      '@stylistic/semi': ['error', 'always'],
      '@stylistic/brace-style': ['error', '1tbs', { allowSingleLine: true }],
      '@stylistic/max-statements-per-line': ['error', { max: 2 }],
      '@typescript-eslint/array-type': 'error',
      "@typescript-eslint/consistent-type-definitions": ['error', 'type'],
      '@typescript-eslint/consistent-type-imports': 'error',
      '@typescript-eslint/explicit-function-return-type': 'error',
      '@typescript-eslint/no-non-null-assertion': 'error',
      '@typescript-eslint/no-unused-vars': [
        'warn',
        {
          'argsIgnorePattern': '^_',
          'varsIgnorePattern': '^_',
          'caughtErrorsIgnorePattern': '^_',
          'destructuredArrayIgnorePattern': '^_'
        }
      ]
    },
    settings: {
      react: {
        version: 'detect'
      }
    }
  },
  {
    ignores: ['**/*.js', '**/*.mjs']
  }
);
