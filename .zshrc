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
setopt interactive_comments

fpath=(~/.zsh $fpath)
autoload -Uz compinit
compinit -u

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

export LANG=en_US.UTF-8
export EDITOR=nvim
export MANPAGER='nvim +Man!'

export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN

eval "$(fnm env --use-on-cd --shell zsh)"

# znap plugin manager
source "${CONFIG_HOME}/shell/znap.sh"

# Aliases
source "${CONFIG_HOME}/shell/alias.sh"

OS_CONFIG="${CONFIG_HOME}/shell/${OS}.sh"
[ -s "${OS_CONFIG}" ] && source "${OS_CONFIG}"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(starship init zsh)" # Initialize starship prompt
eval "$(zoxide init zsh)" # Initialize zoxide

fastfetch # Display system information
