source <(fzf --zsh)

eval "$(zoxide init zsh)"

eval "$(fnm env --use-on-cd --shell zsh)"

eval "$(rustup completions zsh)"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi
