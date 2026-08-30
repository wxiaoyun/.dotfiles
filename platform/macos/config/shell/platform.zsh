if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

export SSH_AUTH_SOCK="$HOME/.ssh/proton-pass-agent.sock"