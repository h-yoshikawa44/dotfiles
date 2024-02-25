# TypeScript 開発補助環境

## 絶対パス指定
インポート文で絶対パスを使えるようにする。  

### React
Vite で baseUrl を使えるようにする
```bash
npm i -D vite-tsconfig-paths
```

tsconfig.json
```json
"compilerOptions": {
  "baseUrl": "src",
  .
  .
  .
}
```

### Next.js
エイリアスパターン。  
これで`@/`で`src`配下を参照できるようになる。

tsconfig.json
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
```bash
npm i -D typesync
```
package.json の scripts に追加して、ライブラリインストール時に型定義ライブラリがないかチェックするようにする。
```json
"scripts": {
  .
  .
  .
  "preinstall": "typesync || echo 'skip typesync'"
}
```
`|| echo 'skip typesync'`がついているのは、初回インストール時に typesync がないことによるエラー回避のため。  

## ESLint・Prettier
静的解析 + フォーマッタ

### インストール
ESLint に関して、Vite で作成した React プロジェクトでは、すでに最低限のセットアップ済み。

create-next-app で作成した Next.js プロジェクトでも、（v11.0.0）からはセットアップ済み。
- [`eslint-config-next`の設定内容](https://github.com/vercel/next.js/blob/canary/packages/eslint-config-next/index.js)

Prettier はセットアップされていないのでいれる。
```bash
npm i -D prettier eslint-config-prettier
```

<details>
<summary>Next.js v10系における ESLint 設定</summary>
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
```bash
touch .eslintrc.js
```

ビルドを実行（現状の機能では、サーバ起動では動作しない）
```bash
npm run build
```
```
It looks like you're trying to use ESLint but do not have the required package(s) installed.

Please install eslint and eslint-config-next by running:

        mpm i --dev eslint eslint-config-next

If you are not trying to use ESLint, please remove the .eslintrc.js file from your application.
```
案内されたライブラリをインストールする
```bash
npm i -D eslint eslint-config-next
```

再度、ビルド実行
```bash
npm run build
```
これで ビルド時にまず ESLint が動作しチェックを行うようになる。
あわせて ESLint 設定ファイルに設定が追記される。
```js
{
  "extends": "next"
}
```
</details>

### CLI
※直接 ESLint を実行する場合  
（create-next-app v11.0.0 からはすでに`"lint": "next lint"`コマンドまで設定済み）

チェックコマンド例
```bash
npx eslint './src/**/*.{js,jsx,ts,tsx}'
# Next.js v11 より
npm run lint

npx prettier --check './**/*.{html,js,ts,json}'
```

ルール競合チェックコマンド例
```bash
npx eslint-config-prettier './src/**/*.{js,jsx,ts,tsx}'
```
問題なければ以下の表示になる
```
No rules that are unnecessary or conflict with Prettier were found.
```

package.json（React）
```json
{
  "scripts": {
   "lint-check": "npm run lint:eslint && npm run check:prettier",
    "lint:eslint": "eslint \"./src/**/*.{js,jsx,ts,tsx}\"",
    "check:prettier": "prettier --check \"./{public,src}/**/*.{js,jsx,ts,tsx,html,gql,graphql,json}\"",
    "fix": "npm run fix:eslint && npm run fix:prettier",
    "fix:eslint": "npm run lint:eslint -- --fix",
    "fix:prettier": "npm run check:prettier -- --write",
  }
}
```

package.json（Next.js v11以降）
```json
{
  "scripts": {
    "lint-check": "npm run lint:eslint && npm run check:prettier",
    "lint:eslint": "next lint",
    "check:prettier": "prettier --check \"./{public,src}/**/*.{js,jsx,ts,tsx,html,gql,graphql,json}\"",
    "fix": "npm run fix:eslint && npm run fix:prettier",
    "fix:eslint": "npm run lint:eslint -- --fix",
    "fix:prettier": "npm run check:prettier -- --write",
  }
}
```

### VSCode 拡張
- [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

settings.json
```json
{
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true, // ファイル保存時に ESLint 実行
  },
  "editor.formatOnSave": false, // デフォルトのフォーマットを無効化
  "editor.defaultFormatter": "esbenp.prettier-vscode", // デフォルトフォーマッターに Pretter を設定
  "[graphql]": {
    "editor.formatOnSave": true // graphql ファイル保存時に Prettier 実行
  },
  "[javascript]": {
    "editor.formatOnSave": true // js ファイル保存時に Prettier 実行
  },
  "[javascriptreact]": {
    "editor.formatOnSave": true // jsx ファイル保存時に Prettier 実行
  },
  "[json]": {
    "editor.formatOnSave": true // json ファイル保存時に Prettier 実行
  },
  "[typescript]": {
    "editor.formatOnSave": true // ts ファイル保存時に Prettier 実行
  },
  "[typescriptreact]": {
    "editor.formatOnSave": true // tsx ファイル保存時に Prettier 実行
  }
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
設定ファイルの形式は複数パターンのうち、いずれかを使う。
なので、`package.json`側に定義されている設定がある場合は削除しておく。

ESLint に関しては、create-next-app v12系からは`.eslintrc.json`、v11系からは`.eslintrc`がデフォルト。

ESLint 設定に Prettier を追加する。
```js
extends: [
  'plugin:react/recommended',
  'prettier', // 追記
],
```
ESLint と Prettier はルールが競合することがあるので、eslint-config-prettier を適用することで競合するルールを無効化して調整する。  
その性質上、追加するのは extends の最後にすること。

公開されている共有設定を使いたい場合は、インストールして適宜カスタマイズして使う。
```bash
npm i -D eslint-config-airbnb
```

チェックから除外したいファイルは`.eslintignore`、`prettierignore`に書いておく。

## StyleLint
スタイル定義の静的解析。  
CSS in JS タイプのスタイル定義にも対応させられる。
（最近のメジャーアップデート破壊的変更が入ることが多いので注意）


### インストール
```bash
npm i -D stylelint stylelint-config-standard stylelint-order stylelint-config-recess-order
```

v15系以降で、CSS in JS に対応させる場合は以下も追加
```bash
npm i -D postcss-styled-syntax
```

<details>
<summary>v14系以降で、CSS in JS に対応させる場合は以下も追加</summary>

```bash
npm i -D postcss-syntax @stylelint/postcss-css-in-js
```

</details>

### CLI
チェックコマンド例
```bash
# CSS in JS 形式
npx stylelint './src/**/*.{js,jsx,ts,tsx}'

# チェック構文として、CSS in JS 構文を強制（v13系まで）
npx stylelint --syntax 'css-in-js' './src/**/*.{js,jsx,ts,tsx}'
```

package.json
```json
"scripts": {
  "lint-check": "npm run lint:eslint && npm run lint:stylelint && npm run check:prettier",
  "lint:stylelint": "stylelint \"./src/**/*.{js,jsx,ts,tsx}\"",
  "fix": "npm run fix:eslint && npm run fix:stylelint && npm run fix:prettier",
  "fix:stylelint": "npm run lint:stylelint -- --fix",
}
```

### VSCode 拡張
- [stylelint](https://marketplace.visualstudio.com/items?itemName=stylelint.vscode-stylelint)

settings.json
```json
{
  "css.validate": false,
  "less.validate": false,
  "scss.validate": false,
  "editor.codeActionsOnSave": {
    "source.fixAll.stylelint": true
  },
  "stylelint.validate": ["css", "typescript", "typescriptreact"] // v14以降 で CSS in JS 対応させる場合のみ
}
```
上部3つは、デフォルトで動作するスタイル定義の解析を無効にするもの（無効にしないと StyleLint のものと二重チェックになる）

<details>
<summary>v13まででの CSS in JS 設定の補足</summary>

通常は、スタイル定義形式を自動認識してチェックを行うが、CSS in JS 形式をうまく認識してくれないのか、エラーが出ることがある。  
その時は、CSS in JS 形式でのチェックを強制する設定を追加。
```json
{
  "stylelint.syntax": "css-in-js"
}
```
</details>

### 設定ファイルのカスタマイズ
複数パターンのうち、いずれかを使用。


```js
module.exports = {
  extends: [
    'stylelint-config-standard',
    'stylelint-config-recess-order'
  ],
  ...
  // v14以降で CSS in JS 対応する場合のみ
  overrides: [
    {
      files: ['**/*.{ts,tsx}'],
      customSyntax: 'postcss-styled-syntax',
    },
  ],
}
```

<details>
<summary>StyleLint 14系までの衝突ルール回避設定</summary>

Prettier と衝突するルールがあるので、`stylelint-config-prettier`で無効にするようにしておく。
（v15からは、そもそも Pretter と競合するようなタイプのルールが非推奨になったので、回避設定不要になった）

```js
module.exports = {
  extends: [
    'stylelint-config-standard',
    'stylelint-config-recess-order',
    'stylelint-config-prettier', // 追記
  ],
}
```

</details>

## Pre Commit 設定
```bash
npm i simple-git-hooks nano-staged
```

package.json に追記（CSS in JS の例）
```json
"scripts": {
  ...
  "prepare": "simple-git-hooks || echo 'Can not set git hooks'"
}

"simple-git-hooks": {
  "pre-commit": "npx nano-staged"
},
"nano-staged": {
  "src/**/*.{js,jsx,ts,tsx}": [
    "prettier --write --loglevel=error",
    "eslint --fix --quiet",
    "stylelint --fix --quiet"
  ],
  "./**/*.{html,gql,graphql,json}": [
    "prettier --write --loglevel=error"
  ]
}
```

---

- [スタイルに関する環境構築](https://github.com/h-yoshikawa44/dotfiles/blob/main/TypeScript/style.md)
