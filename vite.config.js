import { resolve } from 'node:path'
import { defineConfig } from 'vite'

export default defineConfig((opt) => {
  return {
    root: 'frontend',
    build: {
      outDir: '../public/js',
      emptyOutDir: false,
      rollupOptions: {
        input: {
          app: resolve(__dirname, 'frontend/src/app.tsx'),
        },
        output: {
          entryFileNames: 'app.js',
        },
      },
    },
  }
});
