# React × Laravel
ここでは TypeScript + React（Laravel Mix）× Laravel による、SPA × API 構成を指す。

## 環境構築
Docker 環境構築部分は下記参照
- [docker-laravel をベースとした環境構築](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/Laravel/docker/docker-laravel/README.md)

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
※[tsconfig.json](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/React-Laravel/tsconfig.json)

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

## Remote Container 環境
VSCode 拡張：[Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

以下をプロジェクトルートに配置
- [.devcontainer/devcontainer.json](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/React-Laravel/.devcontainer/devcontainer.json)
- [.devcontainer/docker-compose.yml](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/React-Laravel/.devcontainer/docker-compose.yml)
- [example.code-workspace.json](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/React-Laravel/example.code-workspace.json) ※名称は先頭部分はプロジェクト名に合わせてリネーム

コンテナ内で使用する VSCode 拡張は devcontainer.json に記述してあるので、適宜使用する拡張に変える。

## ESLint + Prettier 導入
ライブラリインストール
```
$ yarn add -D eslint eslint-plugin-react eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-react-hooks  @typescript-eslint/eslint-plugin @typescript-eslint/parser prettier eslint-config-prettier
```

airbnb の共有設定をインストール
```
$ yarn add -D eslint-config-airbnb
```

※各種設定ファイル
- [.eslintrc.js](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/React-Laravel/.eslintrc.js)
- [.eslintignore](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/React-Laravel/.eslintignore)
- [.prettierrc](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/React-Laravel/.prettierrc)
- [.prettierignore](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/React-Laravel/.prettierignore)

それぞれ VSCode 拡張を入れる。
（devcontainer.json に記述済み）
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
[PHP 開発補助環境](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/README.md) を参照。

※[phpcs.xml](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/React-Laravel/phpcs.xml)

## テスト DB 環境構築
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
※[phpunit.xml](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/React-Laravel/phpunit.xml)

CI 環境におけるテスト DB の注意点は [React × Laravel CI/CD](https://github.com/h-yoshikawa44/dotfiles/blob/main/PHP/React-Laravel/README-ci-cd.md) を参照。

