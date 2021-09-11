export KEYTIMEOUT=12

# Set Vi-mode.
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins ' ' magic-space
bindkey -M viins '^I' expand-or-complete-prefix

# Add and set surround.
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround

# Add vim-ish text-object support to Zsh.
autoload -U select-quoted; zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done
autoload -U select-bracketed; zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

# Open current prompt in external editor.
autoload -Uz edit-command-line; zle -N edit-command-line
bindkey '^ ' edit-command-line

# [EXTRA] bindkey -M viins '^n' history-substring-search-down
# [EXTRA] bindkey -M viins '^p' history-substring-search-up
bindkey -M viins '^s' history-incremental-pattern-search-backward
bindkey -M viins '^u' backward-kill-line
bindkey -M viins '^w' backward-kill-word
bindkey -M viins '^b' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M viins '^f' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M viins '^g' push-line-or-edit
bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line
bindkey -M viins '^d' push-line-or-edit

bindkey -M vicmd '^k' kill-line
bindkey -M vicmd 'H'  run-help

# Shift + Tab.
bindkey -M viins '^[[Z' reverse-menu-complete

# Bind UP and DOWN arrow keys.
# [EXTRA] bindkey '^[OA' history-substring-search-up
# [EXTRA] bindkey '^[OB' history-substring-search-down
# [EXTRA] bindkey -M viins '^[OA' history-substring-search-up
# [EXTRA] bindkey -M viins '^[OB' history-substring-search-down

# Bind Home and End keys.
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey -M viins '^[OH' beginning-of-line
bindkey -M viins '^[OF' end-of-line
bindkey -M vicmd '^[OH' beginning-of-line
bindkey -M vicmd '^[OF' end-of-line

# C-z to toggle current process (background/foreground).
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# Vim's C-x C-l in Zsh.
history-beginning-search-backward-then-append() {
  zle history-beginning-search-backward
  zle vi-add-eol
}
zle -N history-beginning-search-backward-then-append
bindkey -M viins '^x^l' history-beginning-search-backward-then-append

# Fix the DEL key.
bindkey -M vicmd "^[[3~" delete-char
bindkey "^[[3~" delete-char

# Fix vim-ish ESC.
# [EXTRA] bindkey -sM vicmd '^[' '^G'
# [EXTRA] bindkey -rM viins '^X'
# [EXTRA] bindkey -M viins '^X,' _history-complete-newer \
# [EXTRA]   '^X/' _history-complete-older \
# [EXTRA]   '^X`' _bash_complete-word
