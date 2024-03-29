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
      --reverse --height 80% --border
      --color bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9
      --color header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1
      --color fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1
    '
    export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix --hidden --exclude .git --exclude .bare ."
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --strip-cwd-prefix --hidden --exclude .git --exclude .bare --type directory ."
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
source $ZGEN_ZSHFILE

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
    touch -c "$ZSH_CACHE/zcompdump" # Update time even with no edits.
  done
  compinit -C -d "$ZSH_CACHE/zcompdump"

  # Same for bashcompinit...
  autoload -Uz bashcompinit
  for dump in $ZSH_CACHE/zbashcompdump(N.mh+24); do
    bashcompinit -u -d "$ZSH_CACHE/zbashcompdump"
    touch -c "$ZSH_CACHE/zbashcompdump" # Update time even with no edits.
  done
  bashcompinit -C -d "$ZSH_CACHE/zbashcompdump"

  # Apply theme.
  autoload -Uz promptinit && promptinit
  prompt pure
fi
