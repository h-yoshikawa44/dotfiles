# HTML・CSS・JavaScript 開発補助環境

## Markuplint
### インストール
```bash
npm i -D markuplint
```

### CLI
```bash
npx markuplint './**/*.html'

npx markuplint './**/*.html' --fix
```

## StyleLint
### インストール
```bash
npm i -D stylelint stylelint-config-recess-order stylelint-config-standard stylelint-order
```

### CLI
```bash
npx stylelint './css/**/*.css'

npx stylelint './css/**/*.css' --fix
```

## ESLint
### インストール
```bash
npm i -D eslint eslint-config-prettier
```

### CLI
```bash
npx eslint './js/**/*.js'

npx eslint './js/**/*.js' --fix
```

## Prettier
### インストール
```bash
npm i -D prettier 
```

### CLI
```bash
npx prettier --check './**/*.{html,js,ts,json}'

npx prettier --check './**/*.{html,js,ts,json}' --write
```

package.json
```json
{
  "scripts": {
    "lint-check": "npm run lint:markuplint && npm run lint:stylelint && npm run lint:eslint && npm run check:prettier",
    "lint:markuplint": "markuplint \"./**/*.html\"",
    "lint:stylelint": "stylelint \"./css/**/*.css\"",
    "lint:eslint": "eslint \"./js/**/*.js\"",
    "check:prettier": "prettier --check \"./**/*.{html,css,json}\"",
    "fix": "npm run fix:markuplint && npm run fix:stylelint && npm run fix:eslint && npm run fix:prettier",
    "fix:markuplint": "npm run lint:markuplint -- --fix",
    "fix:stylelint": "npm run lint:stylelint -- --fix",
    "fix:eslint": "yarn lint:eslint --fix",
    "fix:prettier": "npm run check:prettier -- --write",
  }
}
```

### VSCode 拡張
- [Markuplint](https://marketplace.visualstudio.com/items?itemName=yusukehirao.vscode-markuplint)
- [StyleLint](https://marketplace.visualstudio.com/items?itemName=stylelint.vscode-stylelint)
- [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)
- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)


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
}
```

拡張の v1.1.0 以降であれば、自動で node_modules 配下の StyleLint を検出してくれるはずであるが、自動検出に失敗するなら明示的に追記。
```json
{
  "stylelint.stylelintPath": "./node_modules/stylelint"
}
```

## simple-git-hooks + nano-staged
```bash
npm i -D simple-git-hooks nano-staged
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
    "pre-commit": "./node_modules/.bin/nano-staged",
  },
  "lint-staged": {
    "./**/*.html": [
      "markuplint --fix --problem-only",
      "prettier --write --loglevel=error"
    ],
    "css/**/*.css": [
      "stylelint --fix --quiet",
      "prettier --write --loglevel=error"
    ],
    "src/**/*.{js,ts}": [
      "eslint --fix --quiet"
      "prettier --write --loglevel=error",
    ],
    "./**/*.json": [
      "prettier --write --loglevel=error"
    ]
  },
}
```

設定反映
```bash
npx simple-git-hooks
```
