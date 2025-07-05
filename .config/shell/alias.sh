#!/bin/sh

alias v="nvim"
alias vim="nvim"
alias ivim="nvim \$(fzf -m --preview='bat --color=always {}')"

alias ls="eza --color --icons --group-directories-first"
alias cd="z"
alias mv="mv -iv"
alias rm="rm -I"
alias grep="grep --color=always"
alias lg="lazygit"

alias pn="pnpm"
alias srcpy="source .venv/bin/activate"

# Composite shortcuts
alias lla="ls -la"
alias lc="code $HOME/code/leetcode"
alias vpnsoc="sudo openfortivpn webvpn.comp.nus.edu.sg --username=e0702008"

cdc() {
  cd "$HOME/code/$1"
}
