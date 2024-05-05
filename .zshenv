#!/bin/sh

export OS=$(uname)
export MACOS="Darwin"
export LINUX="Linux"
export CONFIG_HOME=""

case $OS in
    $MACOS)
        CONFIG_HOME="$HOME/.config"
        ;;
    $LINUX)
        CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
        ;;
esac

. "$HOME/.cargo/env"
