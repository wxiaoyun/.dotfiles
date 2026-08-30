export PATH="$HOME/.local/bin:$PATH"

eval "$(mise activate zsh)"

eval "$(zoxide init zsh)"

eval "$(herdr completions zsh)"

. "$HOME/.cargo/env"
eval "$(rustup completions zsh)"

source <(usage g completion-init zsh)
