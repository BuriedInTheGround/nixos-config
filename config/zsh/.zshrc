# Create the $ZSH_CACHE folder if it doesn't exists, otherwise compinit isn't
# able to save the zcompdump file.
[ -d "$ZSH_CACHE" ] || mkdir -pv "$ZSH_CACHE"

# Download zgen if missing.
[ -d "$ZGEN_DIR" ] || git clone https://github.com/tarjoilija/zgen "$ZGEN_DIR"

# Source basic configuration.
source $ZDOTDIR/config.zsh

# Continue only if the terminal has capabilities.
if [[ $TERM != dumb ]]; then
  source $ZDOTDIR/keybindings.zsh
  source $ZDOTDIR/completion.zsh
  source $ZDOTDIR/aliases.zsh

  # If `fd` is present use it.
  if command -v fd > /dev/null; then
    export FZF_DEFAULT_OPTS='
      --reverse --ansi
      --color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C
      --color pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B
    '
    export FZF_DEFAULT_COMMAND="fd ."
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd -t d . $HOME" # Look for directories only.
  fi

  if command -v keychain > /dev/null; then
      eval $(keychain --eval --quiet --nogui)
  fi

  # File `extra.zshrc` is autogenerated via the NixOS system configuration.
  source $ZDOTDIR/extra.zshrc

  # Load a local .zshrc file if exists.
  [ -f ~/.zshrc ] && source ~/.zshrc
fi

# Source zgen.
export ZGEN_AUTOLOAD_COMPINIT=0
source $ZGEN_SOURCE

# Initialize zgen and create a save if needed.
if ! zgen saved; then
  echo "Initializing zgen..."

  zgen load mafredri/zsh-async
  zgen load sindresorhus/pure . main

  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search
  zgen load zsh-users/zsh-completions src
  zgen load MichaelAquilina/zsh-you-should-use
  zgen load tarruda/zsh-autosuggestions

  zgen load junegunn/fzf shell

  zgen save
fi

if [[ $TERM != dumb ]]; then
  # Load extra keybindings after sourcing zsh-history-substring-search.
  source $ZDOTDIR/extra-keybindings.zsh

  # Load colors aliases.
  autoload -U colors && colors

  # Load and run compinit.
  #   `-U` marks compinit for autoloading.
  #   `-z` loads compinit using zsh-style autoloading.
  #   `-u` avoid compinit tests for insecure files and directories.
  #   `-C` avoid regeneration of zcompdump cache (implies `-u`).
  #   `-d` set the compinit dumpfile location.
  autoload -Uz compinit
  for dump in $ZSH_CACHE/zcompdump(N.mh+24); do
    compinit -u -d "$ZSH_CACHE/zcompdump"
  done
  compinit -C -d "$ZSH_CACHE/zcompdump"

  # Same for bashcompinit...
  autoload -Uz bashcompinit
  for dump in $ZSH_CACHE/zbashcompdump(N.mh+24); do
    compinit -u -d "$ZSH_CACHE/zbashcompdump"
  done
  compinit -C -d "$ZSH_CACHE/zbashcompdump"

  # Apply theme.
  autoload -Uz promptinit && promptinit
  prompt pure
fi
