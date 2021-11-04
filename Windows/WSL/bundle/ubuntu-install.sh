#! /bin/bash
set -eux
EXEPATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)
DOTFILESRAW = "https://raw.githubusercontent.com/h-yoshikawa44/dotfiles/main"

sudo apt update
sudo apt upgrade

## ========== brew ==========
sudo apt install build-essential procps curl file git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

brew upgrade
brew bundle --file "${EXEPATH}"/Brewfile

## ========== starship ==========
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

## ========== settings ==========
curl "${$DOTFILESRAW}/Windows/WSL/.bashrc" -o "${HOME}/.bashrc"
curl "${$DOTFILESRAW}/Windows/WSL/.profile" -o "${HOME}/.profile"
curl "${$DOTFILESRAW}/Windows/WSL/config/starship.toml" -o "${HOME}/.config/starship.toml"
