#!/usr/bin/env zsh

alias git='noglob git'

# Custom script to clone repositories in bare mode in a way that is convenient
# for using worktrees.
alias git-clone-bare="$MY_NIXOS_BIN/git-clone-bare"
