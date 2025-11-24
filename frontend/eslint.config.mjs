import { defineConfig } from "eslint/config";
import eslint from "@eslint/js";
import tseslint from "typescript-eslint";
import stylistic from "@stylistic/eslint-plugin";
import react from "eslint-plugin-react";
import reactHooks from "eslint-plugin-react-hooks";
import inlinePropsPlugin from "eslint-plugin-no-inline-props";
import globals from "globals";
import checkFile from "eslint-plugin-check-file";
import jest from "eslint-plugin-jest";
import importPlugin from "eslint-plugin-import";

export default defineConfig(
  { ignores: ["**/*.js", "**/*.mjs"] },
  eslint.configs.recommended,
  tseslint.configs.recommendedTypeChecked,
  tseslint.configs.stylisticTypeChecked,
  stylistic.configs.recommended,
  react.configs.flat.recommended,
  react.configs.flat["jsx-runtime"],
  reactHooks.configs.flat.recommended,
  inlinePropsPlugin.configs.recommended,
  {
    files: ["**/*.{ts,tsx}"],
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
        ecmaFeatures: {
          jsx: true,
        },
      },
      globals: {
        ...globals.browser,
      },
    },
    plugins: {
      "react": react,
      "react-hooks": reactHooks,
      "@stylistic": stylistic,
      "check-file": checkFile,
      "jest": jest,
      "import": importPlugin,
    },
    rules: {
      ...jest.configs["recommended"].rules,
      ...jest.configs["style"].rules,
      "curly": ["error", "all"],
      "no-empty": ["error", { allowEmptyCatch: false }],
      "no-constant-condition": "error",
      "@stylistic/arrow-parens": ["error", "always"],
      "@stylistic/array-bracket-spacing": ["error", "always", { singleValue: false }],
      "@stylistic/brace-style": ["error", "1tbs", { allowSingleLine: true }],
      "@stylistic/comma-dangle": [
        "error",
        {
          "arrays": "always-multiline",
          "objects": "always-multiline",
          "functions": "ignore",
        },
      ],
      "@stylistic/jsx-closing-bracket-location": "off",
      "@stylistic/jsx-quotes": ["error", "prefer-double"],
      "@stylistic/jsx-sort-props": [
        "error",
        {
          "callbacksLast": true,
          "reservedFirst": ["key", "ref", "id", "type", "name", "className"],
          "shorthandLast": true,
          "noSortAlphabetically": true,
        },
      ],
      "@stylistic/max-statements-per-line": ["error", { max: 2 }],
      "@stylistic/semi": ["error", "always"],
      "@stylistic/spaced-comment": "off",
      "@typescript-eslint/array-type": "error",
      "@typescript-eslint/consistent-type-definitions": "off",
      "@typescript-eslint/consistent-type-imports": "error",
      "@typescript-eslint/explicit-function-return-type": "error",
      "@typescript-eslint/naming-convention": [
        "error",
        {
          selector: ["variable", "function"],
          format: ["camelCase", "PascalCase", "UPPER_CASE"],
          leadingUnderscore: "allow",
        },
        {
          selector: ["typeAlias", "interface", "class", "enum"],
          format: ["PascalCase"],
        },
        {
          selector: ["variable", "function"],
          format: ["PascalCase"],
          custom: {
            regex: "^[A-Z]",
            match: true,
          },
        },
      ],
      "@typescript-eslint/no-floating-promises": "error",
      "@typescript-eslint/no-non-null-assertion": "error",
      "@typescript-eslint/no-unused-vars": [
        "warn",
        {
          argsIgnorePattern: "^_",
          varsIgnorePattern: "^_",
          destructuredArrayIgnorePattern: "^_",
        },
      ],
      "react/button-has-type": "error",
      "react/function-component-definition": ["error", {
        namedComponents: "arrow-function",
        unnamedComponents: [],
      }],
      "react/jsx-handler-names": "error",
      "react/jsx-no-bind": "error",
      "react/jsx-no-leaked-render": "error",
      "react/jsx-no-useless-fragment": "error",
      "react/no-array-index-key": "error",
      "check-file/filename-naming-convention": [
        "error",
        {
          "**/api/*": "CAMEL_CASE",
          "**/components/!(index).{jsx,tsx}": "PASCAL_CASE",
          "**/hooks/!(index).ts": "use[A-Z][a-zA-Z0-9]*",
          "**/pages/!(index).tsx": "PASCAL_CASE",
          "**/reducers/*.ts": "CAMEL_CASE",
          "**/types/!(index).ts": "PASCAL_CASE",
        },
        {
          ignoreMiddleExtensions: true,
        },
      ],
      "import/order": [
        "error",
        {
          "groups": [
            "builtin",
            "external",
            [ "internal", "parent", "sibling" ],
            "index",
            "type",
          ],
          "newlines-between": "never",
        },
      ],
    },
    settings: {
      react: {
        version: "detect",
      },
    },
  },
);
