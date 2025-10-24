const { TextEncoder } = require('util');

module.exports = {
  clearMocks: true,
  restoreMocks: true,
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  collectCoverage: true,
  coverageReporters: [ 'text', 'html', 'lcov' ],
    globals: {
    TextEncoder: TextEncoder
  },
};
