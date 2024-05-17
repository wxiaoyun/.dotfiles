# zsh configs
HISTSIZE=5000
HISTFILE=~/.cache/zsh/history
SAVEHIST=$HISTSIZE
HISTUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

export LANG=en_US.UTF-8
export EDITOR=nvim

export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# znap plugin manager
[ -f "${CONFIG_HOME}/shell/znap.sh" ] && source "${CONFIG_HOME}/shell/znap.sh"

# Aliases
[ -f "${CONFIG_HOME}/shell/alias.sh" ] && source "${CONFIG_HOME}/shell/alias.sh"

case $OS in
    $MACOS)
        [ -f "${CONFIG_HOME}/shell/macos.sh" ] && source "${CONFIG_HOME}/shell/macos.sh"
        ;;
    $LINUX)
        [ -f "${CONFIG_HOME}/shell/linux.sh" ] && source "${CONFIG_HOME}/shell/linux.sh"
        ;;
esac

eval "$(starship init zsh)" # Initialize starship prompt
eval "$(zoxide init zsh)" # Initialize zoxide
fastfetch # Display system information
