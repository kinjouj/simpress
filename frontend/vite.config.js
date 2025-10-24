import { resolve } from 'node:path'
import { defineConfig } from 'vite'
import { viteStaticCopy } from 'vite-plugin-static-copy';
import react from '@vitejs/plugin-react-swc';

export default defineConfig({
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
        app: resolve(__dirname, 'src/index.tsx'),
      },
      output: {
        entryFileNames: 'app.js',
      },
    },
  },
});
