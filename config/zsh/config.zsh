# Disable some options for dumb terminals.
if [[ $TERM == dumb ]]; then
  unsetopt ZLE PROMPT_CR PROMPT_SUBST
fi

# A list of non-alphanumeric characters considered part of a word by the line
# editor.
WORDCHARS='~!#$%^&*()_-[]{}.<>?;'

# The maximum size of the directory stack. If it gets larger it will be
# truncated automatically.
DIRSTACKSIZE=10

# Options > Changing Directories {{{
setopt AUTO_CD           # If a command can't be executed and is a directory
                         # name, perform a `cd` to that directory.

setopt AUTO_PUSHD        # Make `cd` push the old directory onto the directory
                         # stack.

setopt PUSHD_IGNORE_DUPS # Don't push multiple copies of the same directory
                         # onto the directory stack.

setopt PUSHD_SILENT      # Do not print the directory stack after `pushd` or
                         # `popd`.

setopt PUSHD_TO_HOME     # Have `pushd` with no args act like `pushd $HOME`.
# }}}

# History {{{
HISTFILE="$XDG_CACHE_HOME/zsh_history" # Set the location of the history file.

HISTSIZE=4500 # 3x times the value of SAVEHIST to assure proper working of
              # HIST_EXPIRE_DUPS_FIRST.
SAVEHIST=1500
# }}}

# Options > History {{{
setopt APPEND_HISTORY         # Zsh sessions append their history list to the
                              # history file, rather than replace it.

setopt EXTENDED_HISTORY       # Save each command as
                              # : <beginning time>:<elapsed seconds>;<command>.

setopt HIST_EXPIRE_DUPS_FIRST # If the internal history needs to be trimmed,
			      # remove the oldest history event that has a
			      # duplicate before a unique one.

setopt HIST_FCNTL_LOCK        # Use ad-hoc file locking. Should provide better
                              # performance and avoid history corruption.

setopt HIST_FIND_NO_DUPS      # When searching for history entries don't
			      # display duplicates of a line previously found.

setopt HIST_IGNORE_DUPS       # Do not enter command lines into the history
			      # list if they are duplicates of the previous
			      # event.

setopt HIST_IGNORE_SPACE      # Remove command lines from the history list when
                              # the first character is a space.

setopt HIST_SAVE_NO_DUPS      # When writing out the history file, older
			      # commands that duplicate newer ones are omitted.

setopt HIST_VERIFY            # Don't execute immediately after history
			      # expansion.

setopt INC_APPEND_HISTORY     # Like APPEND_HISTORY but writes out the commands
			      # as soon as they are entered.

setopt SHARE_HISTORY          # Share history between sessions.
# }}}

# Options > Job Control {{{
setopt AUTO_RESUME    # Attempt to resume existing jobs for single word simple
		      # commands without redirection.

unsetopt BG_NICE      # Don't run background jobs at a lower priority.

unsetopt CHECK_JOBS   # Do not report on jobs when shell exits.

unsetopt HUP          # Do not send the HUP signal to running jobs when the
		      # shell exits.

setopt LONG_LIST_JOBS # Print job notifications in the long format by default.

setopt NOTIFY         # Report the status of background jobs immediately,
		      # rather than waiting until just before printing a
		      # prompt.
# }}}

# vim:foldmethod=marker:foldlevel=0
