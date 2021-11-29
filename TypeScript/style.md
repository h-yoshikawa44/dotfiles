# スタイルに関する環境構築

## リセット CSS
ブラウザごとのデフォルト CSS による差異をなるべく減らすために、リセット CSS をグローバルで適用。  
種類は色々あるのでお好みで。

```bash
$ yarn add modern-css-reset
```

## emotion
CSS in JS の一種。

### Next.js における導入手順
本体のインストール
```bash
$ yarn add @emotion/react
```
基本的にはこれだけで使用できる。
ただ、使用ファイルそれぞれに`/** @jsxImportSource @emotion/react */`というプラグマを書く必要がある。

これを都度書かなくていいようにするには、以下の手順を行う。

Babel 用の preset をインストール（core も必要になるので入れる）
```bash
$ yarn add -D @emotion/babel-preset-css-prop @babel/core
```

.babelrc を作成し、この preset を使うようにする
```
{
  "presets": ["next/babel", "@emotion/babel-preset-css-prop"]
}
```

tsconfig.json にもその旨追記
```json
{
  "compilerOptions": {
    // ...
    "jsxImportSource": "@emotion/react"
  }
}
```

### VSCode 拡張
- [vscode-styled-components](https://marketplace.visualstudio.com/items?itemName=jpoissonnier.vscode-styled-components)

styled-components 形式コードの、シンタックスハイライトや入力補完を追加。

入れるだけで OK。  
styled-components 用であるが、emotion でも問題なく動作する。

