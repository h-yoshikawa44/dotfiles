## ----------------------------------------
##  Command
## ----------------------------------------

# ghq + peco
function peco-ghq () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    if [ -t 1 ]; then
      cd ${selected_dir}
    fi
  fi
}
bind '"\C-]": "peco-ghq\C-m\C-l"'

# history + peco
function peco-history-selection() {
  local selected_command=$(HISTTIMEFORMAT= history | awk '{$1="";print}' | peco)
  READLINE_LINE="$selected_command"
  READLINE_POINT=${#selected_command}
}
bind -x '"\C-h": peco-history-selection'

## ----------------------------------------
##  Prompt
## ----------------------------------------

# Starship
eval "$(starship init bash)"

## ----------------------------------------
##  Git Editor
## ----------------------------------------

# Cursor 上のターミナル操作では Cursor でコミットメッセージが書けるようにする
case "$VSCODE_GIT_ASKPASS_MAIN" in
        *cursor*)
                git config --local core.editor "cursor --wait"
                ;;
        *)
                git config --local core.editor "code --wait"
esac
