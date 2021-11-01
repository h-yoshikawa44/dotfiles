$dotfilesRaw = "https://raw.githubusercontent.com/h-yoshikawa44/dotfiles/main"

## ========== winget ==========
winget source update

curl "$($dotfilesRaw)/Windows/bundle/winget.json" -UseBasicParsing -o ./winget.json
winget import -i .\winget.json
rm .\winget.json

# インポートファイルではロケールサポートがないようなので別でインストール
winget install --id  Adobe.AdobeAcrobatReaderDC --locale ja-JP

## ========== settings ==========
curl "$($dotfilesRaw)/Windows/.bash_profile" -o $env:USERPROFILE\.bash_profile -UseBasicParsing
curl "$($dotfilesRaw)/Windows/WindowsTerminal/settings.json"  -o $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -UseBasicParsing

# VSCode設定はGitHubアカウントで同期する
