# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

# ghq + peco
function peco-ghq () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ghq
bindkey '^]' peco-ghq

# history + peco
function peco-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^h' peco-history-selection

# Homebrew
## Command Completions
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# anyenv
# eval "$(anyenv init -)"

# asdf
. $(brew --prefix asdf)/asdf.sh
. ~/.asdf/plugins/java/set-java-home.zsh

# fnm（パス系は引き継がない方がいいかも）
export PATH="/Users/h_yoshikawa/Library/Caches/fnm_multishells/97719_1645753298280/bin":$PATH
export FNM_MULTISHELL_PATH="/Users/h_yoshikawa/Library/Caches/fnm_multishells/97719_1645753298280"
export FNM_VERSION_FILE_STRATEGY="local"
export FNM_DIR="/Users/h_yoshikawa/Library/Application Support/fnm"
export FNM_LOGLEVEL="info"
export FNM_NODE_DIST_MIRROR="https://nodejs.org/dist"
export FNM_ARCH="arm64"
rehash

eval "$(fnm env --use-on-cd)"

# Starship
eval "$(starship init zsh)"

# curl
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"

# unzip
export PATH="/opt/homebrew/opt/unzip/bin:$PATH"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
