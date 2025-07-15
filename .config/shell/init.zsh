source <(fzf --zsh)

eval "$(zoxide init zsh)"

eval "$(fnm env --use-on-cd --shell zsh)"

eval "$(rustup completions zsh)"