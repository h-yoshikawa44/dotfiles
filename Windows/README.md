## Windows

### WSL の有効化
1. 左下の Windows ボタンを右クリックし 、「アプリと機能」を選択
2. 下部の方にある関連設定の「プログラムと機能」を選択
3. 左メニューの「Windows の機能の有効化または無効化」を選択
4. 機能一覧の中から「Linux 用 Windows サブシステム」にチェックをつけて「OK」

### セットアップ

PowerShell で実行
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/h-yoshikawa44/dotfiles/main/Windows/install.ps1'))
```

### 非自動化分
#### 基本環境
- [X-Bows Driver](https://x-bows.com/pages/software)：キーカスタム（X-Bows v2 までのドライバ ※v3から [QMK ベース](https://x-bows.com/blogs/blog/how-to-use-qmk-keyboard)）

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

