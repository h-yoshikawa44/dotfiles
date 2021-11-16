# Vite での環境構築

```
$ yarn create vite
```

基本的にはこれだけで OK。

## PostCSS
Vite のビルド時に実行したいものを、必要に応じていれる。
```
$ yarn add -D postcss autoprefixer
```

Autoprefixer：自動でベンダープレフィックスを付与してくれるもの

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
