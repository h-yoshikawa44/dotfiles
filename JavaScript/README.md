# JavaScript
## .eslintrc.js
ESLint の設定ファイル。

ファイルは基本的にはプロジェクトルートに配置。  
それ以外の場合は VSCode 設定の eslint.workingDirectories に記述すること。

ライブラリ（ESLint + Prettier） + [VSCode 拡張](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint)で、エディタ上で動かすようにする。

なお、create-react-app を使用した場合は、react-script の中で ESLint の基本ライブラリは導入されている。

ライブラリインストール例
```
$ yarn add -D eslint-config-airbnb prettier prettier-eslint prettier-eslint-cli eslint-config-prettier eslint-plugin-prettier
```

VSCode 設定例
```json
{
  "eslint.workingDirectories": [
    "./JavaScript/React/tutorial1",
    "./JavaScript/ReactNative/app"
  ],
  "editor.formatOnSave": false,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "eslint.packageManager": "yarn",
}
```
