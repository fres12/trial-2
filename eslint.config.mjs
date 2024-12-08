import globals from "globals";
import pluginJs from "@eslint/js";
import pluginReact from "eslint-plugin-react";
import pluginVitest from "eslint-plugin-vitest";

/** @type {import('eslint').FlatConfig[]} */
export default [
  { files: ["**/*.{js,mjs,cjs,jsx}"] },
  { languageOptions: { globals: globals.browser } },
  pluginJs.configs.recommended,
  {
    ...pluginReact.configs.flat.recommended,
    settings: {
      react: {
        version: "detect", // Secara otomatis mendeteksi versi React
      },
    },
    rules: {
      ...pluginReact.configs.flat.recommended.rules,
      "react/react-in-jsx-scope": "off", // Tambahkan aturan ini
    },
  },
  {
    files: ["**/*.test.{js,jsx}"],
    plugins: { vitest: pluginVitest },
    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node,
        ...pluginVitest.environments.env.globals,
      },
    },
    rules: {
      "vitest/no-disabled-tests": "warn",
      "vitest/no-focused-tests": "error",
      "vitest/no-identical-title": "error",
      "vitest/valid-expect": "error",
    },
  },
];
