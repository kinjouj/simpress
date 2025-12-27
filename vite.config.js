import { defineConfig } from 'vite'
import { viteStaticCopy } from 'vite-plugin-static-copy';
import react from '@vitejs/plugin-react-swc';

export default defineConfig({
  root: 'frontend',
  plugins: [
    react(),
    viteStaticCopy({
      targets: [
        {
          src: './public/*',
          dest: '../'
        }
      ]
    })
  ],
  build: {
    //minify: 'esbuild',
    minify: false,
    outDir: '../public/js',
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
        app: 'frontend/src/index.tsx',
      },
      output: {
        entryFileNames: 'app.js',
      },
    },
  },
});
