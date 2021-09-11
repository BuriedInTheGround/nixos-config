bindkey -M viins '^n' history-substring-search-down
bindkey -M viins '^p' history-substring-search-up

# Bind UP and DOWN arrow keys.
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down
bindkey -M viins '^[OA' history-substring-search-up
bindkey -M viins '^[OB' history-substring-search-down

# Fix vim-ish ESC.
bindkey -sM vicmd '^[' '^G'
bindkey -rM viins '^X'
bindkey -M viins '^X,' _history-complete-newer \
  '^X/' _history-complete-older \
  '^X`' _bash_complete-word
