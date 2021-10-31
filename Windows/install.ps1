$dotfilesRaw = "https://raw.githubusercontent.com/h-yoshikawa44/dotfiles/main"

## ========== winget ==========
winget source update

curl "$($dotfilesRaw)/Windows/bundle/winget.json" -UseBasicParsing -o ./winget.json
winget import -i .\winget.json
rm .\winget.json

