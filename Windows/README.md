## Windows

### 各種インストール
※この dotfiles リポジトリをローカルに落としてきた上で実行すること

PowerShell で実行例（リポジトリトップからの例）
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; .\Windows\bundle\install.ps1
```

### 非自動化分
#### 基本環境
- Linux カーネル更新プログラム：[ここ](https://docs.microsoft.com/ja-jp/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)からインストール（Docker に必要）
- [HackGen](https://github.com/yuru7/HackGen/releases)：フォント（GitHub から通常版・Nerd 版ともに直接ダウンロードして、コントロールパネルのフォントに配置）
- [X-Bows Driver](https://x-bows.com/pages/software)：キーカスタム（X-Bows v2 までのドライバ ※v3から [QMK ベース](https://x-bows.com/blogs/blog/how-to-use-qmk-keyboard)）
  - v2 マクロは app_config 配下の .cms ファイル（US 配列用）
  - Windows 本体の言語設定から日本語キーボードレイアウトを US 配列にする
  - Windows 本体設定の Microsoft IME → キーとタッチのカスタマイズ → 各キーに好み機能を割り当てるを ON → Ctrl + Space を IME-オン/オフ にしておく
- [Ueli](https://ueli.app/#/)：ランチャー（設定反映のみ非自動・タスクバーインジケーターから設定を開いて app_config/ueli.config.json をインポート）

#### ストレージ
- [BUFFALO スマートツインズ](https://www.buffalo.jp/support/download/detail/?dl_contents_id=5130)：バックアップ
- [BUFFALO おでかけロック設定](https://www.buffalo.jp/support/download/detail/?dl_contents_id=2795)：ストレージロック
- [BUFFALO みまもり合図](https://www.buffalo.jp/support/download/detail/?dl_contents_id=62005)：ストレージ劣化確認

#### メディア
※古いバージョンなので、そのうち動かなくなるかも
- [CyberLink PowerDVD 10](https://jp.cyberlink.com/products/powerdvd-ultra/features_ja_JP.html)：DVD・Blu-ray 再生（Blu-ray 端末付属 CD より）
- [CyberLink Media Suite 10](https://dl.logitec.co.jp/software.php?pn=LST-D-497)：書き込みソフト（Blu-ray 端末付属 CD より）

#### 開発
- [Stoplight Studio](https://stoplight.io/studio/)：Open API エディタ
- make：
  - winget でインストールできるが、パスが通ってない場合があるので通す（例：`C:\Program Files (x86)\GnuWin32\bin`）
- [ngrok](https://ngrok.com/)：ローカルサーバを公開

#### シェル
- Git
  - SSH 鍵：新しく作り直すでよさそう
  - GPG 鍵：できれば前の端末から移行してきた方がよい
- [Starship](https://starship.rs/)：プロンプト
  - winget でインストール後、~/.config を作り、その下に starship.toml ファイルを配置
- mise
  - winget でインストール + PATH を通すまでやってくれるが、GitHook 環境で任意の npm パッケージを動かすために追加で PATH 設定が必要
  - `{HOME}\AppData\Local\mise\shims`
