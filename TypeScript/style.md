# スタイルに関する環境構築

## リセット CSS
ブラウザごとのデフォルト CSS による差異をなるべく減らすために、リセット CSS をグローバルで適用。  
種類は色々あるのでお好みで。

```bash
npm i modern-css-reset
```

## emotion
CSS in JS の一種。

### Next.js における導入手順
本体のインストール
```bash
npm i @emotion/react
```
基本的にはこれだけで使用できる。

ただ、CSS Prop の機能を使うには、使用ファイルそれぞれに`/** @jsxImportSource @emotion/react */`というプラグマを書く必要がある。
Next v12.1.1 からは emotion の SWC サポートが入ったので、その機能を有効化するだけで OK っぽい。  
（機能を有効化しなくても普通に CSS Prop 使えてる感じではあったけど）

tsconfig.json に追記は必要  
（これがないと CSS Prop を書こうとしても、そんなプロパティはないとエラーになる）
```json
{
  "compilerOptions": {
    // ...
    "jsxImportSource": "@emotion/react"
  }
}
```

<details>
<summary>v12.1.0までで CSS Prop を使うために必要な Babel プラグイン設定</summary>
これを都度書かなくていいようにするには、以下の手順を行う。

Babel 用の preset をインストール（core も必要になるので入れる）
```bash
npm i -D @emotion/babel-preset-css-prop @babel/core
```

.babelrc を作成し、この preset を使うようにする
```
{
  "presets": ["next/babel", "@emotion/babel-preset-css-prop"]
}
```

</details>

### VSCode 拡張
- [vscode-styled-components](https://marketplace.visualstudio.com/items?itemName=styled-components.vscode-styled-components)

styled-components 形式コードの、シンタックスハイライトや入力補完を追加。

入れるだけで OK。  
styled-components 用であるが、emotion でも問題なく動作する。

