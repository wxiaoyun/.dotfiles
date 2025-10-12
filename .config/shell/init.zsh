export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN

export ZVM_INSTALL=$HOME/.zvm/bin
export PATH=$PATH:$ZVM_INSTALL

source <(fzf --zsh)

eval "$(zoxide init zsh)"

eval "$(fnm env --use-on-cd --shell zsh)"

eval "$(rustup completions zsh)"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '$HOME/.opam/opam-init/init.zsh' ]] || source '$HOME/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
eval $(opam env)