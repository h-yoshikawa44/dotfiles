# Vite での環境構築

```bash
npm create vite
```

基本的にはこれだけで OK。

## CSS 加工
### Lightning CSS
```bash
npm i -D lightningcss browserslist
```

vite.config.js で Lightning CSS を使うよう設定。

### PostCSS
Vite のビルド時に実行したいものを、必要に応じていれる。
```bash
npm i -D postcss postcss-preset-env
```

postcss-preset-env：ほとんどの PostCSS をまとめて導入できるやつ

例
- Autoprefixer：自動でベンダープレフィックスを付与してくれるもの
- postcss-media-minmax：メディアクエリの`<``>`記法を処理してくれる

一部は別途ポリフィルも併せて導入する必要があることに注意
```bash
npm i -D focus-visible
```
enableClientSidePolyfills を有効化
```js
module.exports = {
  plugins: [
    require('postcss-preset-env')({
      features: {
        'focus-visible-pseudo-class': { enableClientSidePolyfills: true },
      },
    }),
  ],
};
````

## link タグでの CSS 読み込み
CSS の読み込みは、どちらでもできる
- 起点 JS からインポート
- link タグから読み込む

link タグで読み込む形式の場合は、パスを`/`からはじめること。
（`/`なしで書くと、開発時はいいが、本番ビルドにエラーになる）
```html
<link rel="stylesheet" href="/css/style.css" />
```

## package.json
npm パッケージとして公開するつもりがなければ、private をつけておく。
```json
{
  "private": true,
}
```

公開するつもりであれば、代わりに license を適宜設定。
