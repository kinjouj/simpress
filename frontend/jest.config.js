const { TextEncoder } = require("util");

module.exports = {
  cacheDirectory: "./node_modules/.jest",
  clearMocks: true,
  restoreMocks: true,
  preset: "ts-jest",
  testEnvironment: "jsdom",
  setupFilesAfterEnv: [ "./tests/setupTests.js" ],
  collectCoverage: true,
  coverageReporters: [ "text", "html", "lcov" ],
  coveragePathIgnorePatterns: [ "/node_modules/", "/tests/fixtures/", "index\\.ts$" ],
  globals: {
    TextEncoder: TextEncoder
  }
};
