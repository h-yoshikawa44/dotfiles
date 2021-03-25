# React × Laravel CI/CD

## CI 環境でのテスト環境
GitHub Actions 上では DB_HOST を 127.0.0.1 としないといけないが、phpcs.xml で設定を強制上書きしている関係で、その設定が優先して使われてしまう。
そのため DB_HOST だけを変更した GitHub Actions 用の PHPUnit 設定ファイルを別で作成しておく。
```xml
<env name="DB_HOST" value="127.0.0.1" force="true"/>
```
GitHub Actions 上でテスト実行する時は、このファイルを指定して実行するようにすること。
```bash
$ ./vendor/bin/phpunit --configuration=phpunit-ci.xml
```
※[phpunit-ci.xml](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/React-Laravel/phpunit-ci.xml)

## デプロイ時の準備
Laravel UI で導入した React では、デフォルトで全てのライブラリが devDependencies にあり、  
ローカルであらかじめビルドしたものを Git 管理して、それをデプロイするような構成になっている。

これだと毎回ローカルで本番ビルドをかけるのが手間なのと、ビルド成果物を Git 管理するのが違和感があるので、  
本番ビルドはデプロイ先で行うようにする。

1. package.json の devDependencies にあるライブラリのうち、本番環境でも使用するライブラリを dependencies に移す。
2. ビルド成果物（`src/public/css*`、`src/public/js*`）を Git 管理している場合は、Git 管理から外す
3. デプロイ時に本番環境で本番ビルドをかけるようにする

3に関して Heroku の場合は以下を package.json の scripts に追記
```json
"scripts": {
  .
  .
  .
  "heroku-postbuild": "yarn prod"
}
```

## GitHub Actions ワークフローの補足説明
### 環境変数、各種バージョン
環境変数はあらかじめ GitHub Secrets で設定。  
各種バージョンは使用しているものに合わせる。

### 各種 Lint、テスト実行コマンド
あらかじめ scripts に定義したものを使用しているので、その定義をやっておくこと。

```
$ yarn lint
$ composer lint
$ composer test-ci
```

package.json
```json
"scripts": {
  "lint": "yarn lint:eslint && yarn lint:prettier",
  "lint:eslint": "yarn run -s eslint './resources/ts/**/*.{js,jsx,ts,tsx}'",
  "lint:prettier": "yarn run -s prettier --check .",
  "fix": "yarn fix:eslint && yarn fix:prettier",
  "fix:eslint": "yarn lint:eslint -- --fix",
  "fix:prettier": "yarn lint:prettier -- --write",
}
```
composer.json
```json
"scripts": {
 "lint:fix": [
      "./vendor/bin/phpcbf --standard=phpcs.xml ."
  ],
  "test": [
      "./vendor/bin/phpunit"
  ],
  "test-ci": [
      "./vendor/bin/phpunit --configuration=phpunit-ci.xml"
  ]
```
