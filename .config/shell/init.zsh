export PATH="$HOME/.local/bin:$PATH"

eval "$(zoxide init zsh)"

eval "$(herdr completions zsh)"

. "$HOME/.cargo/env"
eval "$(rustup completions zsh)"

export SSH_AUTH_SOCK="$HOME/.ssh/proton-pass-agent.sock"
