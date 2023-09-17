# 開発環境設定

## グローバルセットアップ
### Git
グローバル設定は`.gitconfig`参照。  
メールアドレスはプライベートアドレスを使用すること。  
（GitHub ベースで設定しているので、GitLab を使う場合は、ローカル設定で GitLab のプライベートアドレスを使うようにする）

### エディタ
[VSCode](https://azure.microsoft.com/ja-jp/products/visual-studio-code/) を使用。

## プロジェクトごとのセットアップ
### エディタ共通設定
[VSCode 拡張：EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) をいれる。

`.editorconfig`を作成。

### Git コミットメッセージテンプレ
`.gitmessage`を作成。
内容はプロジェクトに応じて適宜カスタマイズする。

テンプレを適用
```bash
# ローカル
git config commit.template .gitmessage

# グローバル
git config --global commit.template .gitmessage
```

大体は`.gitmessage`で用意している印象があるので、グローバルでよさそう。

### 言語ごとの環境設定
各言語のディレクトリ配下の README 参照。

### GitHub Actions ワークフロー定義ファイル
#### 配置
プロジェクトルート直下に`.github/workflows`フォルダを作り、その配下に yml ファイルを配置する。  
ファイル名は任意の名前で OK。

#### ジョブのタイムアウト時間
実施したコマンド内部でエラーが起きた場合、出力更新をしなければ Workflow は最大6時間動いてしまい、あっという間にリソースが枯渇してしまう。
そのため、必ずタイムアウト設定を入れておくこと。

#### GitHub Secrets
公開したくない秘匿情報を登録し、環境変数のように扱える機能。  
一度登録するとその値を確認することはできないようになっている。

`secrets.〇〇`の部分は、GitHub Secrets から値を参照しているので、あらかじめリポジトリの Setting から設定しておく。
ただし、`secrets.GITHUB_TOKEN`については自動で設定される。

#### Action のバージョン
`owner/repo@version`形式で指定するが、基本的に`master`は使用しない方がいい。  
バージョンアップにより、予期せぬ動作不良を招く可能性があるため。
