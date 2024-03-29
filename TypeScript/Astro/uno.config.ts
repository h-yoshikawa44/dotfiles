import {
  defineConfig,
  presetUno,
  presetWebFonts,
  presetIcons,
  transformerDirectives,
} from 'unocss';

export default defineConfig({
  presets: [
    presetUno(),
    presetWebFonts({
      fonts: {
        sawarabi: [
          'Sawarabi Mincho',
          'Verdana',
          { name: 'sans-serif', provider: 'none' },
        ],
        fatface: ['Abril Fatface', { name: 'sans-serif', provider: 'none' }],
      },
    }),
    presetIcons(),
  ],
  transformers: [transformerDirectives()],
  theme: {
    fontFamily: {
      hackGen: [
        'HackGen',
        'ui-monospace',
        'SFMono-Regular',
        'Menlo',
        'Monaco',
        'Consolas',
        'Liberation Mono',
        'Courier New',
        'monospace',
      ],
    },
    colors: {
      brand: {
        primary: '#202020',
        start: '#323232',
        end: '#0e0e0e',
      },
    },
  },
  // スタイル生成を強制したいクラスがあれば定義
  safelist: '',
  shortcuts: {
    // 複雑なスタイルの組み合わせ定義を使いまわすとき
  },
});
