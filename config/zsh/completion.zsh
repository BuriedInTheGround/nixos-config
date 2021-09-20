# Options > Completion {{{
unsetopt ALWAYS_TO_END  # Don't move the cursor if completion is done within a
                        # word.

setopt AUTO_LIST        # Automatically list choices on an ambiguous
                        # completion.

setopt AUTO_MENU        # Automatically use menu completion after the second
                        # consecutive request for completion (e.g. <TAB><TAB>).

setopt AUTO_PARAM_KEYS  # The automatically added charater is deleted if, after
                        # a parameter name completion, the next character typed
                        # is one of those that have to come directly after the
                        # name.

setopt AUTO_PARAM_SLASH # If a parameter is completed whose content is the name
                        # of a directory, then add a trailing slash instead of
                        # a space.

setopt COMPLETE_ALIASES # Complete the aliases (aliases are distinct commands
                        # from the completion point of view).

setopt COMPLETE_IN_WORD # The cursor doesn't move before completion.

setopt HASH_LIST_ALL    # Whenever a command completion or spelling correction
                        # is attempted, make sure the entire command path is
                        # hashed first. This makes the first completion slower
                        # but avoids false reports of spelling errors.

unsetopt MENU_COMPLETE  # Don't loop through the list of possible completions
                        # (use AUTO_MENU instead).
# }}}

# Options > Expansion and Globbing {{{
unsetopt CASE_GLOB # Make globbing (filename generation) case insensitive.

unsetopt NOMATCH   # Do not print an error if a pattern for filename generation
                   # as no matches.
# }}}

# Options > Input/Output {{{
unsetopt CORRECT_ALL        # Do not try to correct the spelling of all
                            # arguments in a line.

setopt FLOW_CONTROL         # Enable flow control via start/stop characters.

setopt IGNORE_EOF           # Do not exit on EOF, require the use of `exit` or
                            # `logout`. Ten consecutive EOFs will cause to exit
                            # anyway.

setopt INTERACTIVE_COMMENTS # Allow comments even in interactive shells.

setopt PATH_DIRS            # Perform path search even on commands with
                            # slashes.

setopt RC_QUOTES            # Allow the character sequence `''` to signify a
                            # single quote within singly quotes strings.
# }}}

# Completion Settings {{{
# Use caching to make completion of very slow commands usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$ZSH_CACHE/zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list '' \
       'm:{a-z\-}={A-Z\_}' \
       'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
       'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _list _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories.
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true

# History.
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environmental Variables.
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion.
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Don't complete uninteresting users...
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill.
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man.
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Media Players.
zstyle ':completion:*:*:mpg123:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:mpg321:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:ogg123:*' file-patterns '*.(ogg|OGG|flac):ogg\ files *(-/):directories'
zstyle ':completion:*:*:mocp:*' file-patterns '*.(wav|WAV|mp3|MP3|ogg|OGG|flac):ogg\ files *(-/):directories'

# SSH/SCP/RSYNC.
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Set FZF completion.
if command -v fzf > /dev/null; then
  __git_log () {
    # The format string implies the following flags.
    #  --abbrev-commit
    #  --decorate
    git log \
      --color=always \
      --graph \
      --all \
      --date=short \
      --format="%C(bold blue)%h%C(reset) %C(green)%ad%C(reset) | %C(white)%s %C(red)[%an] %C(bold yellow)%d"
  }

  _fzf_complete_git() {
    ARGS="$@"

    # Commands commonly called on commit hashes.
    if [[ $ARGS == 'git cherry-pick'* || \
          $ARGS == 'git checkout'* || \
          $ARGS == 'git reset'* || \
          $ARGS == 'git show'* || \
          $ARGS == 'git log'* ]]; then
      _fzf_complete "--reverse --multi" "$@" < <(__git_log)
    else
      eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
  }

  _fzf_complete_git_post() {
    sed -e 's/^[^a-z0-9]*//' | awk '{print $1}'
  }
fi
# }}}

# vim:foldmethod=marker:foldlevel=0
