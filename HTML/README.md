# HTML・CSS・JavaScript 開発補助環境

## Prettier・StyleLint・ESLint
### インストール
必要に応じてインストール
```
$ yarn add -D prettier stylelint stylelint-config-prettier stylelint-config-recess-order stylelint-config-standard stylelint-order eslint eslint-config-prettier
```
### CLI
チェックコマンド例
```
$ yarn run -s prettier --check './**/*.{html,js,ts,json}'

$ yarn run -s stylelint './css/**/*.css'

$ yarn run -s eslint './js/**/*.js'
```

package.json
```json
{
  "scripts": {
    "lint-check": "yarn lint:eslint && yarn lint:stylelint && yarn check:prettier",
    "lint:eslint": "eslint \"./js/**/*.js\"",
    "lint:stylelint": "stylelint \"./css/**/*.css\"",
    "check:prettier": "prettier --check \"./**/*.{html,js,ts,json}\"",
    "fix": "yarn fix:eslint && yarn fix:stylelint && yarn fix:prettier",
    "fix:eslint": "yarn lint:eslint --fix",
    "fix:stylelint": "yarn lint:stylelint --fix",
    "fix:prettier": "yarn check:prettier --write"
  }
}
```

### VSCode 拡張
- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
- [stylelint](https://marketplace.visualstudio.com/items?itemName=stylelint.vscode-stylelint)
- [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)


settings.json
```json
{
  "css.validate": false, // StyleLint を使うので、デフォルトの構文チェックを無効化
  "less.validate": false, // // StyleLint を使うので、デフォルトの構文チェックを無効化
  "scss.validate": false, // // StyleLint を使うので、デフォルトの構文チェックを無効化
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true, // ファイル保存時に ESLint 実行
    "source.fixAll.stylelint": true // ファイル保存時に StyleLint 実行
  },
  "editor.formatOnSave": false, // デフォルトのフォーマットを無効化
  "editor.defaultFormatter": "esbenp.prettier-vscode", // デフォルトフォーマッターに Pretter を設定
  "[html]": {
    "editor.formatOnSave": true // html ファイル保存時に Prettier 実行
  },
  "[css]": {
    "editor.formatOnSave": true // css ファイル保存時に Prettier 実行
  },
  "[javascript]": {
    "editor.formatOnSave": true // js ファイル保存時に Prettier 実行
  },
  "[json]": {
    "editor.formatOnSave": true // json ファイル保存時に Prettier 実行
  },
  "html-css-class-completion.enableEmmetSupport": true, // Emmet でもクラス補完を使えるようにする
  "eslint.packageManager": "yarn" // ESLint のパッケージマネージャ
}
```

拡張の v1.1.0 以降であれば、自動で node_modules 配下の StyleLint を検出してくれるはずであるが、自動検出に失敗するなら明示的に追記。
```json
{
  "stylelint.stylelintPath": "./node_modules/stylelint"
}
```

## simple-git-hooks + lint-staged
```
$ yarn add -D simple-git-hooks lint-staged
```

```json
{
  "scripts": {
    "prepare": "simple-git-hooks || echo 'Can not set git hooks'"
  }
  .
  .
  .
  "simple-git-hooks": {
    "pre-commit": "yarn run -s lint-staged"
  },
  "lint-staged": {
    "src/**/*.{js,ts}": [
      "prettier --write --loglevel=error",
      "eslint --fix --quiet"
    ],
    "css/**/*.css": [
      "stylelint --fix --quiet"
    ],
    "./**/*.{html,json}": [
      "prettier --write --loglevel=error"
    ]
  },
}
```

設定反映
```
$ yarn run -s simple-git-hooks
```
