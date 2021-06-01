# TypeScript 開発補助環境

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
create-react-app で作成した React プロジェクトでは、すでに最低限のセットアップ済み。

### CLI
Lint のみ
```bash
$ yarn run -s eslint './src/**/*.{js,jsx,ts,tsx}'
```

Lint + 自動整形まで
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
なので、`package.json`側に定義されている設定は削除しておく。

個人の好みもあるが、airbnb の共有設定を追加して適宜カスタマイズする。
```
$ yarn add -D eslint-config-airbnb
```

チェックから除外したいファイルは`.eslintignore`に書いておく。

ファイル例
- [.eslintrc.js](https://github.com/h-yoshikawa44/dotfiles/blob/main/TypeScript/React/.eslintrc.js)
- [.eslintignore](https://github.com/h-yoshikawa44/dotfiles/blob/main/TypeScript/React/.eslintignore)

### 細かなエラー対応など
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
競合ルールチェック
```bash
$ yarn run -s eslint-config-prettier './src/**/*.{js,jsx,ts,tsx}'
```
問題なければ以下の表示になる
```
No rules that are unnecessary or conflict with Prettier were found.
```

チェックのみ
```bash
$ yarn run -s prettier --check '{public,src}/**/*.{js,jsx,ts,tsx,html,gql,graphql,json}'
```

チェック + 自動整形
```bash
$ yarn run -s prettier --check '{public,src}/**/*.{js,jsx,ts,tsx,html,gql,graphql,json}' --write
```

ESLint とともに package.json の scripts に追加しておくとよい
```json
"scripts": {
  .
  .
  .
  "lint-check": "yarn lint:eslint && yarn check:prettier",
  "lint:eslint": "yarn run -s eslint './src/**/*.{js,jsx,ts,tsx}'",
  "check:prettier": "yarn run -s prettier --check '{public,src}/**/*.{js,jsx,ts,tsx,html,gql,graphql,json}'",
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

ファイル例
- [.prettierrc](https://github.com/h-yoshikawa44/dotfiles/blob/main/TypeScript/React/.prettierrc)
