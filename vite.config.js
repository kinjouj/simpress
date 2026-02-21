import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc';

export default defineConfig({
  root: 'frontend',
  plugins: [
    react(),
  ],
  build: {
    minify: 'esbuild',
    outDir: '../public',
    assetsDir: 'assets',
    emptyOutDir: false,
    copyPublicDir: false,
    rollupOptions: {
      onwarn(warning, warn) {
        if (warning.code === 'MODULE_LEVEL_DIRECTIVE') {
          return;
        }

        warn(warning);
      },
      input: {
        app: 'frontend/index.html',
      },
      output: {
        entryFileNames: 'js/app.js',
        chunkFileNames: 'js/[name]-[hash].js'
      },
    },
  },
});
