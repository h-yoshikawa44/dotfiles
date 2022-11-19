# Git Hooks
## simple-git-hooks での使い方
### prepare-commit-msg
コミットメッセージテンプレの1行目に置換用の文字を入れておく
```
(#Issue)
```

package.json など設定を定義するところで、カスタムのフックファイルを使用するようにする
```json
"simple-git-hooks": {
  "pre-commit": "yarn run -s lint-staged",
  "prepare-commit-msg": "./git-hook/commit-msg \"$@\""
},
```
