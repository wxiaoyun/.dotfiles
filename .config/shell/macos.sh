#!/bin/sh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
source $(brew --prefix nvm)/nvm.sh

# Databases
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun" # bun completions
