fastfetch # Display system information

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

export LANG=en_US.UTF-8
export EDITOR=nvim
export MANPAGER='nvim +Man!'

export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN

source <(fzf --zsh)       # Initialize fzf
eval "$(zoxide init zsh)" # Initialize zoxide
eval "$(fnm env --use-on-cd --shell zsh)"

# zim config manager
source "${CONFIG_HOME}/shell/zim.sh"

OS_CONFIG="${CONFIG_HOME}/shell/${OS}.sh"
[ -s "${OS_CONFIG}" ] && source "${OS_CONFIG}"

# Aliases
source "${CONFIG_HOME}/shell/alias.sh"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
