# React × Laravel
ここでは TypeScript + React（Laravel Mix）× Laravel による、SPA × API 構成を指す。

## 環境構築
[GitHub - ucan-lab/docker-laravel](https://github.com/ucan-lab/docker-laravel) を使わせてもらうと早いので、こちらをベースに作る。

なお、紹介記事において作者本人も触れられている通り、コンテナ内の Node.js は動作が遅いため、ローカルや WSL の Node.js を使用するとよい。

### 各種バージョン指定
各種 Dockerfile で PHP や MySQL のバージョンを、自分が使用するバージョンにしておく。
（デフォルトでは最新バージョンベースのため）

また、インストールする Laravel のバージョンを指定しておく。  
（デフォルトでは最新バージョンが入るため）

Makefile
```
laravel-install:
	docker-compose exec app composer create-project --prefer-dist laravel/laravel=6.* .
```

### コンテナ作成 & Laravel プロジェクト作成
```bash
$ make create-project
```

### 開発補助ライブラリの導入
こちらもデフォルトでは最新ベースで入る。  
Laravel のバージョンを下げている場合は、あわせてバージョンを下げておかないとバージョンの依存関係でエラーになる。

Makefile（Laravel 6系を使用した場合の例）
```
install-recommend-packages:
	docker-compose exec app composer require doctrine/dbal "^2"
	docker-compose exec app composer require --dev barryvdh/laravel-ide-helper=2.8.*
	docker-compose exec app composer require --dev beyondcode/laravel-dump-server=1.3.*
	docker-compose exec app composer require --dev barryvdh/laravel-debugbar
	docker-compose exec app composer require --dev roave/security-advisories:dev-master
	docker-compose exec app php artisan vendor:publish --provider="BeyondCode\DumpServer\DumpServerServiceProvider"
	docker-compose exec app php artisan vendor:publish --provider="Barryvdh\Debugbar\ServiceProvider"
```

ライブラリインストール
```bash
$ make install-recommend-packages
```

### Laravel initial settings の適用
[GitHub - ucan-lab/docker-laravel - wiki - Laravel initial settings](https://github.com/ucan-lab/docker-laravel/wiki/Laravel-initial-settings)

書いてある通りに設定を修正していく。

### React 環境セットアップ
Laravel UI を使って導入する。  
Laravel UI のインストール時は Laravel のバージョンに合わせたバージョンを指定すること。

Laravel 6系の場合は1系になる
```bash
$ docker-compose exec app composer require laravel/ui=1.*
```

スキャフォールディング
```bash
$ docker-compose exec app php artisan ui react
```
resources/js 配下に React のひな型が作成される

ライブラリインストール
```bash
$ yarn install
```

Laravel 側では全てのリクエストを受けるようにする  
src/routes/web.php
```php
Route::get('/{any?}', fn() => view('index'))->where('any', '.+');
```

最初からある welcome.blade.php をベースとして、起点となるビューを作成  
src/resources/index.blade.php
```php
<!doctype html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ config('app.name', 'Laravel') }}</title>

    <!-- Scripts -->
    <script src="{{ asset('js/app.js') }}" defer></script>

    <!-- Fonts -->
    <link rel="dns-prefetch" href="//fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css?family=Nunito" rel="stylesheet">

    <!-- Styles -->
    <link href="{{ asset('css/app.css') }}" rel="stylesheet">
</head>
<body>
    <div id="app"></div>
</body>
```

React 側の起点となる app.jsx で、id が app 要素に描画するよう記述
```jsx
if (document.getElementById('app')) {
  ReactDOM.render(
    <App />
    document.getElementById('app')
  );
}
```

#### アセットのバージョニング有効化
バージョニングを有効化することで、ビルドするたびコンパイルしたファイルの URL にランダム文字列を付けてブラウザがキャッシュを読まないようできる。
（キャッシュのせいで変更が反映されない現象を避けられる）

webpack.mix.js
```js
mix
  .react('resources/js/app.js', 'public/js')
  .sass('resources/sass/app.scss', 'public/css')
  .version();
```

アセット読み込みの部分を mix() を使うように修正  
src/resources/index.blade.php
```html
<!-- Scripts -->
    <script src="{{ mix('js/app.js') }}" defer></script>

<!-- Styles -->
    <link href="{{ mix('css/app.css') }}" rel="stylesheet">
```

### TypeScript セットアップ
ライブラリインストール
```
$ yarn add -D typescript ts-loader @types/node @types/react @types/react-dom
```

tsconfig.json 作成
```bash
$ ./node_modules/.bin/tsc --init
```
※tsconfig.json はこのディレクトリ階層においてあるファイル参照

resources/js を resources/ts にリネーム
```bash
$ mv src/resources/js src/resources/ts
```
あわせて bootstrap.js を除く js、jsx ファイルを ts、tsx ファイルにリネームする。

Laravel Mix の設定修正（webpack.mix.js）
```js
const mix = require('laravel-mix');

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel application. By default, we are compiling the Sass
 | file for the application as well as bundling up all the JS files.
 |
 */

mix.ts('resources/ts/app.tsx', 'public/js')
   .sass('resources/sass/app.scss', 'public/css');
   .version();
```

typesync 導入
```
$ yarn add -D typesync
```
package.json の scripts に追加して、ライブラリインストール時に型定義ライブラリがないかチェックするようにする。
```json
"scripts": {
  .
  .
  .
  "postinstall": "typesync"
}
```

## ESLint + Prettier 導入
ライブラリインストール
```
$ yarn add -D eslint eslint-plugin-react eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-react-hooks  @typescript-eslint/eslint-plugin @typescript-eslint/parser prettier eslint-config-prettier
```

airbnb の共有設定をインストール
```
$ yarn add -D eslint-config-airbnb
```

各種設定ファイルは、このディレクトリ階層においているファイル参照。  
VSCode 拡張を入れる。

### 設定の補足
#### import/extensions と import/resolver
前者は、インポート文にはファイル拡張子をつけることを強制するルール。  
後者は、標準のノード require.resolve 動作で定義されているように、インポートされたモジュールをローカルファイルシステム上のモジュールに解決できるようルール。

rules
```js
'import/extensions': [
  'error',
  'ignorePackages',
  {
    js: 'never',
    jsx: 'never',
    ts: 'never',
    tsx: 'never',
  },
],
```
settings
```js
'import/resolver': {
  node: {
    extensions: ['.js', '.jsx', '.tsx', '.ts'],
  },
},
```
React のコードの import 文で出た以下のエラー対応設定
```
Missing file extension for "./components/templates/Login"eslint(import/extensions)
Unable to resolve path to module './components/templates/Login'.eslint(import/no-unresolved)
```

## PHP Intelephense + phpcs + phpcbf 導入
上の階層の README 参照。

## テスト環境構築
docker-compose.yml にテスト用のコンテナ追記
```yml
db-testing:
  build:
    context: .
    dockerfile: ./infra/docker/mysql/Dockerfile
  environment:
    - MYSQL_DATABASE=${DB_NAME:-laravel_test}
    - MYSQL_USER=${DB_USER:-phper}
    - MYSQL_PASSWORD=${DB_PASS:-secret}
    - MYSQL_ROOT_PASSWORD=${DB_PASS:-secret}
```

DB 接続情報を app コンテナの環境変数に設定しているので、この設定が優先的に使われる。  
そのため、PHPUnit の設定ファイルで強制上書きすることで、PHPUnit 実行時はこの強制上書き設定で実行するようにする（env タグで設定すること）  
このディレクトリ階層においてある phpunit.xml 参照。

### CI 環境でのテスト環境
GitHub Actions 上では DB_HOST を 127.0.0.1 としないといけないが、上記設定が優先されるようになるので、DB_HOST だけを変更した GitHub Actions 用の PHPUnit 設定ファイルを別で作成しておく。
```xml
<env name="DB_HOST" value="127.0.0.1" force="true"/>
```
GitHub Actions 上でテスト実行する時は、このファイルを指定して実行するようにすること。
```bash
$ ./vendor/bin/phpunit --configuration=phpunit-ci.xml
```

## GitHub Actions ワークフローの補足説明
各種 Lint、テスト実行コマンドについては、あらかじめ scripts に定義したものを使用しているので、その定義をやっておくこと。

```
$ yarn lint
$ composer lint
$ composer test-ci
```
