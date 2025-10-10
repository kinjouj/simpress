import { resolve } from 'node:path'
import { defineConfig } from 'vite'
import { viteStaticCopy } from 'vite-plugin-static-copy';

export default defineConfig({
  plugins: [
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
    minify: 'esbuild',
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
        app: resolve(__dirname, 'src/app.tsx'),
      },
      output: {
        entryFileNames: 'app.js',
      },
    },
  },
});
