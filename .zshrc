export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export EDITOR=nvim

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

case $OS in
    $MACOS)
        [ -f "${CONFIG_HOME}/shell/macos.sh" ] && source "${CONFIG_HOME}/shell/macos.sh"
        ;;
    $LINUX)
        [ -f "${CONFIG_HOME}/shell/linux.sh" ] && source "${CONFIG_HOME}/shell/linux.sh"
        ;;
esac

[ -f "${CONFIG_HOME}/shell/znap.sh" ] && source "${CONFIG_HOME}/shell/znap.sh"

export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Aliases
[ -f "${CONFIG_HOME}/shell/alias.sh" ] && source "${CONFIG_HOME}/shell/alias.sh"

eval "$(starship init zsh)" # Initialize starship prompt
eval "$(zoxide init zsh)" # Initialize zoxide
fastfetch # Display system information
