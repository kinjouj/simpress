const { TextEncoder } = require("util");

module.exports = {
  roots: ['<rootDir>/frontend'],
  cacheDirectory: "./node_modules/.jest",
  clearMocks: true,
  restoreMocks: true,
  preset: "ts-jest",
  testEnvironment: "jsdom",
  setupFilesAfterEnv: [ "<rootDir>/frontend/tests/setupTests.js" ],
  collectCoverage: true,
  coverageDirectory: "<rootDir>/frontend/coverage",
  coverageReporters: [ "text", "html", "lcov" ],
  coveragePathIgnorePatterns: [ "/node_modules/", "<rootDir>/frontend/tests/fixtures/", "index\\.ts$" ],
  globals: {
    TextEncoder: TextEncoder
  },
  watchman: false
};
