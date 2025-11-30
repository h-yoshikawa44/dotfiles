# mise
# 本来は mise activate を実行すれば、直接 node や npm コマンドが実行できるようになるが
# Windows + Git Bash で mise activate すると git や vi などの PATH が通らなくなってしまう。
# 環境変数の PATH に <homedir>\AppData\Local\mise\shims 通すことでも直接 node, npm コマンドが使えるようになるが、
# Safe Chain がうまく動作してくれないため、エイリアスで対応する。
if command -v mise >/dev/null 2>&1; then
  alias node='mise exec node -- node'
  alias npm='mise exec node -- aikido-npm'
fi
