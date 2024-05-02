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

# ---------- OS specific settings --------- #
OS=$(uname)
MACOS="Darwin"
LINUX="Linux"

if [[ $OS == $MACOS ]]; then

    # Ruby
    export RBENV_ROOT=/opt/homebrew/opt/rbenv
    export PATH=$RBENV_ROOT/bin:$PATH
    eval "$(rbenv init - zsh)"

    # nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    source $(brew --prefix nvm)/nvm.sh
    export NVM_DIR="$HOME/.nvm"

    # Databases
    export PATH=${PATH}:/usr/local/mysql-8.0.33-macos13-arm64/bin/
    export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

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

elif [[ $OS == $LINUX ]]; then
    export ARCHFLAGS="-arch x86_64"

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/home/wuxiaoyun/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/wuxiaoyun/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/home/wuxiaoyun/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/home/wuxiaoyun/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

    export JAVA_HOME="/home/wuxiaoyun/.jdks/azul-11.0.22"
    export PATH=$JAVA_HOME/bin:$PATH

    export GRAPHVIZ_DOT="/usr/bin/dot"

fi

# ---------- Common --------- #

# ZNAP
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# Download Znap, if it's not there yet.
[[ -r ~/Repos/znap/znap.zsh ]] ||
git clone --depth 1 -- \
    https://github.com/marlonrichert/zsh-snap.git ~/Repos/znap
source ~/Repos/znap/znap.zsh # Start Znap

znap source marlonrichert/zsh-autocomplete
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
znap source zsh-users/zsh-syntax-highlighting
ZSH_AUTOSUGGEST_STRATEGY=(history)
znap source zsh-users/zsh-autosuggestions

# Golang
export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Aliases
alias vim="nvim"
alias cdd="cd ~/dev"
alias sshsoc="ssh wxiaoyun@pe113.comp.nus.edu.sg"

eval "$(starship init zsh)"
fastfetch
