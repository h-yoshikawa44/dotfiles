## Windows

### WSL の有効化
1. 左下の Windows ボタンを右クリックし 、「アプリと機能」を選択
2. 下部の方にある関連設定の「プログラムと機能」を選択
3. 左メニューの「Windows の機能の有効化または無効化」を選択
4. 機能一覧の中から「Linux 用 Windows サブシステム」にチェックをつけて「OK」

### 各種インストール
※この dotfiles リポジトリをローカルに落としてきた上で実行すること

PowerShell で実行例（リポジトリトップからの例）
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; .\Windows\bundle\install.ps1
```

### 非自動化分
#### 基本環境
- [HackGen](https://github.com/yuru7/HackGen/releases)：フォント（GitHub から通常版・Nerd 版ともに直接ダウンロードして、コントロールパネルのフォントに配置）
- [X-Bows Driver](https://x-bows.com/pages/software)：キーカスタム（X-Bows v2 までのドライバ ※v3から [QMK ベース](https://x-bows.com/blogs/blog/how-to-use-qmk-keyboard)）
- [Ueli](https://ueli.app/#/)：ランチャー（設定反映のみ非自動・タスクバーインジケーターから設定を開いて app_config/ueli.config.json をインポート）

#### セキュリティ
- [カスペルスキー インターネット セキュリティ](https://www.kaspersky.co.jp/downloads/thank-you/internet-security)：ウイルス対策

#### ストレージ
- [BUFFALO スマートツインズ](https://www.buffalo.jp/support/download/detail/?dl_contents_id=5130)：バックアップ
- [BUFFALO おでかけロック設定](https://www.buffalo.jp/support/download/detail/?dl_contents_id=2795)：ストレージロック
- [BUFFALO みまもり合図](https://www.buffalo.jp/support/download/detail/?dl_contents_id=62005)：ストレージ劣化確認

#### メディア
※古いバージョンなので、そのうち動かなくなるかも
- [CyberLink PowerDVD 10](https://jp.cyberlink.com/products/powerdvd-ultra/features_ja_JP.html)：DVD・Blu-ray 再生（Blu-ray 端末付属 CD より）
- [CyberLink Media Suite 10](https://dl.logitec.co.jp/software.php?pn=LST-D-497)：書き込みソフト（Blu-ray 端末付属 CD より）

#### エディタ
- [Stoplight Studio](https://stoplight.io/studio/)：Open API エディタ

#### シェル
- [Starship](https://starship.rs/)：プロンプト
  - GitHub から直接 ~~x86_64-pc-windows-msvc.zip ファイルを取得
  - C:\Program Files\Starship 配下に展開
  - システム環境変数の PATH に C:\Program Files\Starship を追加
  - Windows Terminal 自体を再起動

