# Git Hooks
## simple-git-hooks での使い方
Mac の場合は、フックファイルの作成時に実行権限がついてないことがあるのでつける
```bash
# 例
chmod a+x git-hooks/prepare-commit-msg
```

### prepare-commit-msg
コミットメッセージテンプレの1行目に置換用の文字を入れておく
```
(#Issue)
```

package.json など設定を定義するところで、カスタムのフックファイルを使用するようにする（引数を忘れずに渡す）
```json
"simple-git-hooks": {
  "pre-commit": "yarn run -s lint-staged",
  "prepare-commit-msg": "./git-hook/prepare-commit-msg \"$@\""
},
```
