const { TextEncoder } = require('util');

module.exports = {
  clearMocks: true,
  restoreMocks: true,
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  globals: {
    TextEncoder: TextEncoder
  },
  collectCoverage: true,
  coverageReporters: [ 'text', 'html', 'lcov' ]
};
