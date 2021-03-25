# PHP

## PHP Intelephense
コード補完 + 静的解析を行うもの。

### VSCode 拡張
[PHP Intelephense](https://marketplace.visualstudio.com/items?itemName=bmewburn.vscode-intelephense-client)

PHP がある環境であれば、この拡張を入れるだけ動作する。

#### Laravel の場合の対応
Laravel の場合、この拡張をいれるだけではファザードやモデルのコード補完が動作しないので、ide-helper で生成するヘルパーファイルと組み合わせて使う。
```bash
$ composer require --dev barryvdh/laravel-ide-helper
```

ヘルパーファイル生成時は、必ず`$ php artisan clear-compiled`を先に行うこと。
```bash
$ php artisan clear-compiled

$ php artisan ide-helper:generate
$ php artisan ide-helper:models --nowrite
```

それぞれ以下のファイルが自動生成される（このファイルは`.gitignore`に追加する）  
`$ php artisan ide-helper:generate` → _ide_helper.php
`$ php artisan ide-helper:models --nowrite` → _ide_helper_models.php

## phpcs と phpcbf
それぞれ
- phpcs：コーディング規約チェック
- phpcbfコードフォーマッタ

```bash
$ composer require --dev squizlabs/php_codesniffer
```
このライブラリにどちらも含まれている。

### CLI
チェックのみ
```bash
$ ./vendor/bin/phpcs --standard=phpcs.xml .
```

チェック + 自動整形
```
./vendor/bin/phpcbf --standard=phpcs.xml .
```

composer.json の scripts に登録しておくとよい
```json
"scripts": {
  .
  .
  .
  "lint": [
      "./vendor/bin/phpcs --standard=phpcs.xml ."
  ],
  "lint:fix": [
      "./vendor/bin/phpcbf --standard=phpcs.xml ."
  ],
}
```

### VSCode 拡張
[PHP Sniffer & Beautifier](https://marketplace.visualstudio.com/items?itemName=ValeryanM.vscode-phpsab)

この拡張1つで phpcs と phpcbf を動作させられる。

VSCode のエディタ設定に追記（パスは適宜合わせる）
```json
{
  "phpsab.standard": "src/phpcs.xml",
  "phpsab.composerJsonPath": "src/composer.json",
  "phpsab.snifferMode": "onType"
}
```
`phpsab.composerJsonPath`はルート階層にソースがない時のみ設定。

なお、全体の editor.defaultFormatter に Prettier 拡張を適用している場合は、バッティングするのか phpcbf が動作しなくなるため、PHP だけこの拡張を使うように設定する。
```json
{
  "[php]": {
    "editor.defaultFormatter": "valeryanm.vscode-phpsab",
    "editor.formatOnSave": true
  },
}
```

### 設定ファイルのカスタマイズ
`phpcs.xml`に定義。

チェックから除外したいファイルがある場合は、`exclude-pattern`で定義しておく。
