# Astro
## 環境構築
ひな型作成
```bash
npm create astro@latest

npm create astro@latest --template テンプレート名
```

サーバ立ち上げ
```
npm run dev
```

ブラウザからアクセス
```
localhost:3000
```

## UnoCSS の導入
```bash
npm install -D unocss @unocss/astro @unocss/autocomplete
```

astro.config.ts で使用設定を追記
```ts
import UnoCSS from 'unocss/astro'

export default {
  integrations: [
    UnoCSS(),
  ],
}
```

UnoCSS の設定ファイル作成
```ts
import { defineConfig } from 'unocss'

export default defineConfig({
  // ...UnoCSS options
})
```

[VSCode](https://marketplace.visualstudio.com/items?itemName=antfu.unocss) 拡張も入れておく。

## ESLint・Prettier
```bash
npm install -D @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint eslint-plugin-astro  eslint-plugin-jsx-a11y prettier prettier-plugin-astro
```

設定ファイルは .eslintrc.json を参照。
