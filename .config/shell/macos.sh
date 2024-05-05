#!/bin/sh

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
