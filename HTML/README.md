# HTML・CSS 開発補助環境

## Prettier
```
$ yarn add -D prettier
```

### CLI
```
$ yarn run -s prettier --check './**/*.{html,js,ts,json}',
```

package.json
```json
"scripts": {
  .
  .
  .
  "check:prettier": "yarn run -s prettier --check './**/*.{html,js,ts,json}'",
  "fix:prettier": "yarn check:prettier --write"
}
```

### VSCode 拡張
- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

```json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
}
```

## StyleLint
```
$ yarn add -D stylelint stylelint-config-prettier stylelint-config-recess-order stylelint-config-standard stylelint-order
```

### CLI
```
$ yarn run -s stylelint './css/**/*.css'
```

package.json
```json
"scripts": {
  .
  .
  .
  "lint-check": "yarn lint:stylelint && yarn check:prettier",
  "lint:stylelint": "yarn run -s stylelint './css/**/*.css'",
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
    "source.fixAll.stylelint": true
  },
}
```
