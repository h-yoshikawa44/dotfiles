#! /bin/bash
set -eux
EXEPATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
DOTFILESRAW = "https://raw.githubusercontent.com/h-yoshikawa44/dotfiles/main"

## ========== brew ==========
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

brew upgrade
brew bundle --file "${EXEPATH}"/Brewfile

### zsh-completions に必要
chmod -R go-w /opt/homebrew/share

## ========== cli ==========

## ========== settings ==========
curl "${$DOTFILESRAW}/Mac/.zshrc" -o "${HOME}/.zshrc"
curl "${$DOTFILESRAW}/Mac/.gitconfig" -o "${HOME}/.gitconfig"
