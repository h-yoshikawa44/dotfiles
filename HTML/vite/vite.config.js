import { defineConfig } from 'vite';
import { browserslistToTargets } from 'lightningcss';
import browserslist from 'browserslist';

export default defineConfig({
    // GitHub Pages にデプロイする時に使用
  // base: process.env.NODE_ENV === 'production' ? '/ch-minimal-blog-card/' : './',
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
    cssMinify: 'lightningcss',
  },
});
