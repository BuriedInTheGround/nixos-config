# Easier back cd.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Less typing exit and clear. ⚡
alias q='exit'
alias Q='exit'
alias clr='clear'

# Make sudo working with aliases.
alias sudo='sudo '

alias cp='cp -i'     # Ask before overwriting files.
alias mv='mv -i'     # Ask before overwriting files.

alias t='tree'       # Fast tree. ⚡
alias ta='t --all'   # Include hidden and git-ignored files.
alias md='mkdir -pv' # Make parent directories as needed.
alias rr='rm -r'     # Remove recursively.

# For working with my NixOS configuration.
alias cdot="cd $MY_NIXOS_CONFIG"
alias edot="pushd $MY_NIXOS_CONFIG && $EDITOR . && popd"
alias nixdot="nixos-rebuild switch --flake $MY_NIXOS_CONFIG# --impure"

# Clipboard Mac-like.
if command -v xclip > /dev/null; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

# Modern `ls`.
if command -v exa > /dev/null; then
  alias exa='exa --group-directories-first --git'
  alias l='exa -1'
  alias ll='exa -lg'
  alias la='exa -la'
fi

# Modern `du`.
if command -v dust > /dev/null; then
  alias du='dust'
fi

# Modern `df`.
if command -v duf > /dev/null; then
  alias df='duf'
fi

# Modern `ps`.
if command -v procs > /dev/null; then
  alias ps='procs'
fi
