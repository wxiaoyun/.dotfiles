OS_CONFIG="${CONFIG_HOME}/shell/${OS}.sh"
[ -s "${OS_CONFIG}" ] && source "${OS_CONFIG}"

source <(fzf --zsh)

eval "$(zoxide init zsh)"

eval "$(rustup completions zsh)"

# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '$HOME/.opam/opam-init/init.zsh' ]] || source '$HOME/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
eval $(opam env)
