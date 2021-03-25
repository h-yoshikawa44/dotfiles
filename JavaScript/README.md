# JavaScript
自記事：[create-react-appで作成した雛形 + VSCodeにESLintとPrettierを導入する](https://changeofpace.site/develop/2019/11/06/eslint-prettier.html)

## ESLint
静的解析。  
create-react-app で作成した React プロジェクトでは、すでに最低限のセットアップ済み。

### CLI
Lint のみ
```bash
$ yarn run -s eslint './src/**/*.{js,jsx}'
```

Lint + 自動整形まで
```bash
$ yarn run -s eslint './src/**/*.{js,jsx}' --fix
```

package.json の scripts に登録しておくとよい
```json
"scripts": {
  .
  .
  .
  "lint:eslint": "yarn run -s eslint './src/**/*.{js,jsx}'",
  "fix:eslint": "yarn run -s eslint './src/**/*.{js,jsx}' --fix"
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

個人の好みもあるが、airbnb の共有設定を追加して適宜カスタマイズする。
```
$ yarn add -D eslint-config-airbnb
```

チェックから除外したいファイルは`.eslintignore`に書いておく。

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
$ yarn run -s eslint-config-prettier './src/**/*.{js,jsx}'
```
問題なければ以下の表示になる
```
No rules that are unnecessary or conflict with Prettier were found.
```

チェックのみ
```bash
$ yarn run -s prettier --check .
```

チェック + 自動整形
```bash
$ yarn run -s prettier --check . --write
```

ESLint とともに package.json の scripts に追加しておくとよい
```js
"scripts": {
  .
  .
  .
  "lint": "yarn lint:eslint && yarn lint:prettier",
  "lint:eslint": "yarn run -s eslint './src/**/*.{js,jsx}'",
  "lint:prettier": "yarn run -s prettier --check .",
  "fix": "yarn fix:eslint && yarn fix:prettier",
  "fix:eslint": "yarn lint:eslint -- --fix",
  "fix:prettier": "yarn lint:prettier -- --write",
}
```

### VSCode 拡張
[Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)


拡張を入れて、必要に応じて再起動。

VSCode のエディタ設定に追記
```json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "[javascript]": {
    "editor.formatOnSave": true
  },
  "[javascriptreact]": {
    "editor.formatOnSave": true
  },
  "[json]": {
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
