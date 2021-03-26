# docker-laravel をベースとした環境構築
[GitHub - ucan-lab/docker-laravel](https://github.com/ucan-lab/docker-laravel)  
をベースとした Docker 環境。

なお、紹介記事において作者本人も触れられている通り、コンテナ内の Node.js は動作が遅いため、ローカルや WSL の Node.js を使用するとよい。

## 各種バージョン指定
各種 Dockerfile で PHP や MySQL のバージョンを、自分が使用するバージョンにしておく。
（デフォルトでは最新バージョンベースのため）

また、インストールする Laravel のバージョンを指定しておく。  
（デフォルトでは最新バージョンが入るため）

Makefile
```
laravel-install:
	docker-compose exec app composer create-project --prefer-dist laravel/laravel=6.* .
```

## コンテナ作成 & Laravel プロジェクト作成
```bash
$ make create-project
```

## 開発補助ライブラリの導入
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

## Laravel initial settings の適用
[GitHub - ucan-lab/docker-laravel - wiki - Laravel initial settings](https://github.com/ucan-lab/docker-laravel/wiki/Laravel-initial-settings)

書いてある通りに設定を修正していく。
