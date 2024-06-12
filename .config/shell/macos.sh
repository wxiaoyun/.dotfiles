#!/bin/sh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
source $(brew --prefix nvm)/nvm.sh

# Databases
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

[ -s "/Users/wuxiaoyun/.bun/_bun" ] && source "/Users/wuxiaoyun/.bun/_bun" # bun completions
