// Vite で MPA + ルートディレクトリを変更する例

import { resolve } from 'path';
import { defineConfig } from 'vite';
import { browserslistToTargets } from 'lightningcss';
import browserslist from 'browserslist';

const root = './src';

export default defineConfig({
  root,
  base: process.env.NODE_ENV === 'production' ? '/ch-qr-code-generator/' : './',
  publicDir: '../public',
  server: {
    open: true,
  },
  css: {
    transformer: 'lightningcss',
    lightningcss: {
      targets: browserslistToTargets(browserslist('>= 0.25%')),
    },
  },
  build: {
    base: './',
    outDir: '../dist',
    cssMinify: 'lightningcss',
    rollupOptions: {
      input: {
        index: resolve(root, 'index.html'),
        qr: resolve(root, 'qr.html'),
      },
    },
  },
});
