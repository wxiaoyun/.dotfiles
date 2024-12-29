export OS=$(uname)
export MACOS="Darwin"
export LINUX="Linux"
export CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

[ -s "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
