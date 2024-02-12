
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
source ~/Repos/znap/znap.zsh  # Start Znap

znap source marlonrichert/zsh-autocomplete
# `znap install` adds new commands and completions.
znap install aureliojargas/clitest zsh-users/zsh-completions

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/tokyonight_storm.omp.json)"
  # eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/jblab_2021.omp.json)"
fi

# System Paths
export PATH="$PATH:/Users/wuxiaoyun/.nvm/versions/node/v20.1.0/lib/node_modules/yarn/bin"
export RUBY_CONFIGURE_OPTS="--with-zlib-dir=$(brew --prefix zlib) --with-openssl-dir=$(brew --prefix openssl@1.1) --with-readline-dir=$(brew --prefix readline) --with-libyaml-dir=$(brew --prefix libyaml) --with-gdbm-dir=$(brew --prefix gdbm)"
export CFLAGS="-Wno-error=implicit-function-declaration"
export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"
export RBENV_ROOT=/opt/homebrew/opt/rbenv
export PATH=$RBENV_ROOT/bin:$PATH
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/opt/homebrew/opt/openssl@1.1"
eval "$(rbenv init - zsh)"
export PATH=${PATH}:/usr/local/mysql-8.0.33-macos13-arm64/bin/
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
export NVM_DIR="$HOME/.nvm"
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
# export PATH="/usr/local/go/bin:$PATH:$HOME/go/bin"
# export GOBIN=$GOPATH/bin
export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# bun completions
[ -s "/Users/wuxiaoyun/.bun/_bun" ] && source "/Users/wuxiaoyun/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/wuxiaoyun/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
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


# Aliases for nvim
alias vim="nvim"
alias vide="neovide"
