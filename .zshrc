# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# ZNAP
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# Download Znap, if it's not there yet.
[[ -r ~/Repos/znap/znap.zsh ]] ||
  git clone --depth 1 -- \
    https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh # Start Znap

znap source marlonrichert/zsh-autocomplete
# `znap install` adds new commands and completions.
znap install aureliojargas/clitest zsh-users/zsh-completions

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/tokyonight_storm.omp.json)"
  # eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/jblab_2021.omp.json)"
fi

# Ruby
export RBENV_ROOT=/opt/homebrew/opt/rbenv
export PATH=$RBENV_ROOT/bin:$PATH
eval "$(rbenv init - zsh)"

# Databases
export PATH=${PATH}:/usr/local/mysql-8.0.33-macos13-arm64/bin/
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# Golang
export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
source $(brew --prefix nvm)/nvm.sh
export NVM_DIR="$HOME/.nvm"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/Users/wuxiaoyun/.bun/_bun" ] && source "/Users/wuxiaoyun/.bun/_bun" # bun completions

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/wuxiaoyun/anaconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
else
  if [ -f "/Users/wuxiaoyun/anaconda3/etc/profile.d/conda.sh" ]; then
    . "/Users/wuxiaoyun/anaconda3/etc/profile.d/conda.sh"
  else
    export PATH="/Users/wuxiaoyun/anaconda3/bin:$PATH"
  fi
fi
unset __conda_setup
# <<< conda initialize <<<

export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH
 
# Aliases 
alias vim="nvim"
alias cdc="cd ~/code"
alias sshsoc="ssh wxiaoyun@pe113.comp.nus.edu.sg"

# Print neofetch
neofetch
