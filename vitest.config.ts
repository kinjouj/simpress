import path from 'node:path';
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  cacheDir: '../node_modules/.vite',
  test: {
    root: './frontend',
    include: ['tests/**/*.test.{ts,tsx}'],
    globals: true,
    environment: 'happy-dom',
    css: false,
    setupFiles: ['tests/setupTests.ts'],
    mockReset: true,
    restoreMocks: true,
    unstubGlobals: true,
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'lcov'],
      reportsDirectory: path.resolve(__dirname, 'frontend/coverage'),
    },
  },
});
