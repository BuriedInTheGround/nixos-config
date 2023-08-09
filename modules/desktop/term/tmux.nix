{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.term.tmux;
  configDir = config.my.configDir;

  tmuxConf = ''
    # Enable 24-bit TrueColor, italics, undercurl, and underline colors.
    set-option -g  default-terminal   "tmux-256color"
    set-option -ag terminal-overrides ",xterm-256color:RGB"
    set-option -ag terminal-overrides ',*:Smulx=\E[4::%p1%dm'
    set-option -ag terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'

    # Style the status bar.
    #set-option -g status-style 'bg=#2e3440 fg=#81a1c1'

    # Start counting from 1 for windows and panes.
    set-option -g base-index      1
    set-option -g pane-base-index 1

    # Set prefix to CTRL-a.
    unbind-key C-b
    set-option -g prefix C-a
    bind-key C-a send-prefix

    # Set Vi mode.
    set-option -wg mode-keys vi

    # Yank to clipboard.
    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

    # Vim-like window/pane switching.
    bind-key -r C-6 last-window
    bind-key -r h   select-pane -L
    bind-key -r j   select-pane -D
    bind-key -r k   select-pane -U
    bind-key -r l   select-pane -R

    # Enable mouse scrolling.
    set-option -g mouse on

    # Use 24-hours clock.
    set-option -wg clock-mode-style 24

    # Instant normal mode in Vim.
    set-option -sg escape-time 0

    # As suggested by Neovim checkhealth...
    set-option -g focus-events on

    # Big scrollback buffer size.
    set-option -g history-limit 50000

    # Let me see those messages longer.
    set-option -g display-time 4000

    # Refresh the status faster.
    set-option -g status-interval 5

    # Source local tmux.conf.
    bind-key R source-file \
      ''$XDG_CONFIG_HOME/tmux/tmux.conf \; \
      display-message "Sourced ''$XDG_CONFIG_HOME/tmux/tmux.conf!"

    # Load plugins.
    ${optionalString (cfg.plugins != []) ''
    ${concatMapStringsSep "\n" (x: "run-shell ${x.rtp}") cfg.plugins}
    ''}
  '';
in {
  options.modules.desktop.term.tmux = with types; {
    enable = mkBoolOpt false;
    plugins = mkOpt' [] "List of plugins to install." (listOf package);
  };

  config = mkIf cfg.enable {
    environment = {
      etc."tmux.conf".text = tmuxConf;

      systemPackages = [ pkgs.tmux ] ++ cfg.plugins;

      variables = {
        TMUX_TMPDIR = ''''${XDG_RUNTIME_DIR:-"/run/user/$(id -u)"}'';
      };
    };

    home.configFile."tmux".source = "${configDir}/tmux";
  };
}
