# dotfiles

## 基本環境周り
### エディタ共通設定
[VSCode 拡張：EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) をいれる。

`.editorconfig`を作成。

### Git コミットメッセージテンプレ
`.gitmessage`を作成。

テンプレを適用
```bash
$ git config commit.template .gitmessage
```

## 言語ごとの環境設定
各言語のディレクトリ配下の README 参照。

## GitHub Actions ワークフロー定義ファイル
### 配置
プロジェクトルート直下に`.github/workflows`フォルダを作り、その配下に yml ファイルを配置する。  
ファイル名は任意の名前で OK。

### GitHub Secrets
公開したくない秘匿情報を登録し、環境変数のように扱える機能。  
一度登録するとその値を確認することはできないようになっている。

`secrets.〇〇`の部分は、GitHub Secrets から値を参照しているので、あらかじめリポジトリの Setting から設定しておく。
ただし、`secrets.GITHUB_TOKEN`については自動で設定される。

### Action のバージョン
`owner/repo@version`形式で指定するが、基本的に`master`は使用しない方がいい。  
バージョンアップにより、予期せぬ動作不良を招く可能性があるため。
