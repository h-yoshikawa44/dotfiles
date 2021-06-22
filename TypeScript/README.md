# TypeScript 開発補助環境

## 絶対パス指定
インポート文で絶対パスを使えるようにする。  
これで`@/`で`src`配下を参照できるようになる。

```json
"compilerOptions": {
  "baseUrl": ".",
  "paths": {
    "@/*": ["src/*"]
  },
  .
  .
  .
}
```

## typesync
```
$ yarn add -D typesync
```
package.json の scripts に追加して、ライブラリインストール時に型定義ライブラリがないかチェックするようにする。
```json
"scripts": {
  .
  .
  .
  "preinstall": "typesync || :"
}
```
`|| :`がついているのは、初回インストール時に typesync がないことによるエラー回避のため。  

## ESLint
静的解析。

### インストール
#### React
create-react-app で作成した React プロジェクトでは、すでに最低限のセットアップ済み。

#### Next.js
create-next-app で作成した Next.js プロジェクトでは、v11.0.0 からはセットアップ済み。
`$ yarn lint`コマンドですぐに実行できる。

[`eslint-config-next`の設定内容](https://github.com/vercel/next.js/blob/canary/packages/eslint-config-next/index.js)

---
v10.2.4 の段階では、実験的に ESLint 設定を行う機能が追加されている状態。
- [Next.js - ESLint in Next.js and Create Next App](https://github.com/vercel/next.js/discussions/24900)

next.config.js ファイル作成
```js
module.exports = {
  experimental: {
    eslint: true
  }
}
```

空の ESLint 設定ファイル作成
```
$ touch .eslintrc.js
```

ビルドを実行（現状の機能では、サーバ起動では動作しない）
```
$ yarn build
```
```
It looks like you're trying to use ESLint but do not have the required package(s) installed.

Please install eslint and eslint-config-next by running:

        yarn add --dev eslint eslint-config-next

If you are not trying to use ESLint, please remove the .eslintrc.js file from your application.
```
案内されたライブラリをインストールする
```
$ yarn add -D eslint eslint-config-next
```

再度、ビルド実行
```
$ yarn build
```
これで ビルド時にまず ESLint が動作しチェックを行うようになる。
あわせて ESLint 設定ファイルに設定が追記される。
```js
{
  "extends": "next"
}
```
※この手順の前に追加したライブラリや、npm scripts が消えてないか確認しておくこと

### CLI
※直接 ESLint を実行する場合  
（create-next-app v11.0.0 からはすでに`"lint": "next lint"`コマンドまで設定済み）

例：Lint のみ
```bash
$ yarn run -s eslint './src/**/*.{js,jsx,ts,tsx}'
```

例：Lint + 自動整形まで
```bash
$ yarn run -s eslint './src/**/*.{js,jsx,ts,tsx}' --fix
```

package.json の scripts に登録しておくとよい
```json
"scripts": {
  .
  .
  .
  "lint:eslint": "yarn run -s eslint './src/**/*.{js,jsx,ts,tsx}'",
  "fix:eslint": "yarn lint:eslint --fix"
}
```

### VSCode 拡張
[ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)

拡張を入れて、必要に応じて再起動。  
基本的にはこれで Lint が動作する。

自動整形を動作させるため、VSCode のエディタ設定に追記  
（`eslint.packageManager`は自動整形には関係ない部分）
```json
{
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "editor.formatOnSave": false,
  "eslint.packageManager": "yarn",
}
```

サブディレクトリに ESLint の設定ファイルがある場合は、`eslint.workingDirectories`で指定する。
```json
{
  "eslint.workingDirectories": [
    "./app"
  ]
}
```

### 設定ファイルのカスタマイズ
設定ファイルの形式は4パターンがあるが、`.eslintrc.js`を使用。  
（create-next-app v11.0.0 からは`.eslintrc`がデフォルト）  
なので、`package.json`側に定義されている設定がある場合は削除しておく。

公開されている共有設定を使いたい場合は、インストールして適宜カスタマイズして使う。
```
$ yarn add -D eslint-config-airbnb
```

チェックから除外したいファイルは`.eslintignore`に書いておく。

### 細かなエラー対応など（React の場合）
#### typescript-estree のサポートバーション
サポート外のバージョンの TypeScript を使用していると、ESLint 実行時に警告が出るので、サポートバージョン内に合わせた方が無難かも。

```
=============

WARNING: You are currently running a version of TypeScript which is not officially supported by @typescript-eslint/typescript-estree.

You may find that it works just fine, or you may not.

SUPPORTED TYPESCRIPT VERSIONS: >=3.3.1 <4.2.0

YOUR TYPESCRIPT VERSION: 4.3.2

Please only submit bug reports when using the officially supported version.

=============
```

#### React 本体のインポート文を削除
```tsx
import React form 'react';
```
本体部分のみのインポートの場合は、React 17で改良された JSX Transform　によりインポート不要となった。

#### App コンポーネントに VFC なり型定義を設定する
explicit-module-boundary-types で関数の返り値の型定義をつけるよう言われるので、その対応。
```
Missing return type on function.eslint@typescript-eslint/explicit-module-boundary-types
```

reportWebVitals.ts でも同様のことを言われるので、void なりつける。

## Prettier
コードフォーマッタ。

create-react-app で作成した React プロジェクトには含まれていないため、自分でインストールする。
```
$ yarn add -D prettier eslint-config-prettier
```

ESLint 設定
```js
extends: [
  'plugin:react/recommended',
  'airbnb',
  'prettier', // 追記
],
```
ESLint と Prettier はルールが競合することがあるので、eslint-config-prettier を適用することで競合するルールを無効化して調整する。  
その性質上、追加するのは extends の最後にすること。

### CLI
例：競合ルールチェック
```bash
$ yarn run -s eslint-config-prettier './src/**/*.{js,jsx,ts,tsx}'
```
問題なければ以下の表示になる
```
No rules that are unnecessary or conflict with Prettier were found.
```

例：チェックのみ
```bash
$ yarn run -s prettier --check './{public,src}/**/*.{js,jsx,ts,tsx,html,gql,graphql,json}'
```

例：チェック + 自動整形
```bash
$ yarn run -s prettier --check './{public,src}/**/*.{js,jsx,ts,tsx,html,gql,graphql,json}' --write
```

ESLint とともに package.json の scripts に追加しておくとよい

例：React
```json
"scripts": {
  .
  .
  .
  "lint-check": "yarn lint:eslint && yarn check:prettier",
  "lint:eslint": "yarn run -s eslint './src/**/*.{js,jsx,ts,tsx}'",
  "check:prettier": "yarn run -s prettier --check './{public,src}/**/*.{js,jsx,ts,tsx,html,gql,graphql,json}'",
  "fix": "yarn fix:eslint && yarn fix:prettier",
  "fix:eslint": "yarn lint:eslint --fix",
  "fix:prettier": "yarn check:prettier --write"
}
```

例：Next.js（src 配下に各種ソースがある場合）
```json
"scripts": {
  .
  .
  .
  "lint-check": "yarn lint:eslint && yarn check:prettier",
  "lint:eslint": "next lint",
  "check:prettier": "yarn run -s prettier --check './src/**/*.{js,jsx,ts,tsx,html,gql,graphql,json}'",
  "fix": "yarn fix:eslint && yarn fix:prettier",
  "fix:eslint": "yarn lint:eslint --fix",
  "fix:prettier": "yarn check:prettier --write"
}
```

### VSCode 拡張
[Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

拡張を入れて、必要に応じて再起動。

VSCode のエディタ設定に追記
```json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "[graphql]": {
      "editor.formatOnSave": true
  },
  "[javascript]": {
    "editor.formatOnSave": true
  },
  "[javascriptreact]": {
    "editor.formatOnSave": true
  },
  "[json]": {
    "editor.formatOnSave": true
  },
  "[typescript]": {
      "editor.formatOnSave": true
  },
  "[typescriptreact]": {
    "editor.formatOnSave": true
  },
}
```
VSCode のデフォルトのフォーマッタに Prettier を設定。  
加えて、上記3つのファイル形式において、保存時に自動整形が動作するようにする。

### 設定ファイルのカスタマイズ
設定ファイルの形式は6パターンがあるが、`.prettierrc`を使用。

適宜カスタマイズして使用する。

チェックから除外したいファイルは`.prettierignore`に書いておく。

## StyleLint（フロントのみ）
スタイル定義の静的解析。
CSS in JS タイプのスタイル定義にも対応している。

```
$ yarn add -D stylelint stylelint-config-prettier stylelint-config-standard stylelint-order stylelint-config-recess-order
```

### CLI
例：チェックのみ（CSS in JS 形式）
```bash
$ yarn run -s stylelint './src/**/*.{js,jsx,ts,tsx}'

# チェック構文として、CSS in JS 構文を強制
$ yarn run -s stylelint --syntax 'css-in-js' './src/**/*.{js,jsx,ts,tsx}'
```

例：チェック + 自動整形（CSS in JS 形式）
```
$ yarn run -s stylelint './src/**/*.{js,jsx,ts,tsx}' --fix
```

package.json にコマンド追加（CSS in JS 形式）
```json
"scripts": {
  .
  .
  .
  "lint-check": "yarn lint:eslint && yarn lint:stylelint && yarn check:prettier",
  "lint:stylelint": "yarn run -s stylelint --syntax 'css-in-js' './src/**/*.{js,jsx,ts,tsx}'",
  "fix": "yarn fix:eslint && yarn fix:stylelint && yarn fix:prettier",
  "fix:stylelint": "yarn lint:stylelint --fix",
}
```

### VSCode 拡張
- [stylelint](https://marketplace.visualstudio.com/items?itemName=stylelint.vscode-stylelint)

VSCode のエディタ設定に追記
```json
{
  "css.validate": false,
  "less.validate": false,
  "scss.validate": false,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.fixAll.stylelint": true
  },
}
```
上部3つは、デフォルトで動作するスタイル定義の解析を無効にするもの（無効にしないと StyleLint のものと二重チェックになる）

通常は、スタイル定義形式を自動認識してチェックを行うが、CSS in JS 形式をうまく認識してくれないのか、エラーが出ることがある。  
その時は、CSS in JS 形式でのチェックを強制する設定を追加。
```json
{
  "stylelint.syntax": "css-in-js"
}
```

### 設定ファイルのカスタマイズ
`.stylelintrc.js`を使用。

Prettier と衝突するルールがあるので、`stylelint-config-prettier`で無効にするようにしておく。

```js
extends: [
  'stylelint-config-standard',
  'stylelint-config-recess-order',
  'stylelint-config-prettier', // 追記
],
```

## スタイル定義（フロントのみ）
### リセット CSS
ブラウザごとのデフォルト CSS による差異をなるべく減らすために、リセット CSS をグローバルで適用。  
種類は色々あるのでお好みで。

```bash
$ yarn add modern-css-reset
```

### emotion
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

