# Git Hooks
※Lefthook でやった方が簡単ではある（[TypeScript 環境での例](https://github.com/h-yoshikawa44/dotfiles/blob/main/TypeScript/README.md#pre-commit-%E8%A8%AD%E5%AE%9A)）

## simple-git-hooks での使い方
Mac の場合は、フックファイルの作成時に実行権限がついてないことがあるのでつける
```bash
# 例
chmod a+x .githooks/prepare-commit-msg
```

Windows 側で実行権限付与を Git に反映させたい場合はこちら
```bash
# 例
git update-index --add --chmod=+x .githooks/prepare-commit-msg
```

### prepare-commit-msg
コミットメッセージテンプレの1行目に置換用の文字を入れておく
```
(#Issue)
```

package.json など設定を定義するところで、カスタムのフックファイルを使用するようにする（引数を忘れずに渡す）
```json
"simple-git-hooks": {
  "pre-commit": "npx lint-staged",
  "prepare-commit-msg": "./.githooks/prepare-commit-msg \"$@\""
},
```
