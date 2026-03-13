import { TextEncoder } from 'node:util';

export default {
  roots: ['<rootDir>/frontend'],
  cacheDirectory: './node_modules/.jest',
  clearMocks: true,
  restoreMocks: true,
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/frontend/tests/setupTests.ts'],
  collectCoverage: true,
  coverageDirectory: '<rootDir>/frontend/coverage',
  coverageReporters: ['text', 'html', 'lcov'],
  coveragePathIgnorePatterns: ['/node_modules/', '<rootDir>/frontend/tests/fixtures/', 'index\\.ts$'],
  globals: {
    TextEncoder: TextEncoder,
  },
  watchman: false,
};
