{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.services.mpd;
  mpdConfigDir = "${config.user.home}/.config/mpd";
  mpdDataDir = "${config.user.home}/.local/share/mpd";
  mpdPlaylistsDir = "${mpdDataDir}/playlists";
in {
  options.modules.services.mpd = {
    enable = mkBoolOpt false;
    port = mkOpt 6600 types.port;
    startWhenNeeded = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      mpc_cli
      mpd

      # Add MPRIS service for MPD.
      # Note: you have to start it manually.
      # TODO: fix to start automatically (?)
      unstable.mpd-mpris
    ];

    home.configFile."mpd/mpd.conf".text = ''
      music_directory       "~/Music"
      playlist_directory    "${mpdPlaylistsDir}"
      state_file            "${mpdDataDir}/state"
      sticker_file          "${mpdDataDir}/sticker.sql"

      audio_output {
        type         "pulse"
        name         "pulse audio"
      }

      audio_output {
        type         "fifo"
        name         "mpd_fifo"
        path         "/tmp/mpd.fifo"
        format       "44100:16:2"
      }

      log_level                 "verbose"
      auto_update               "yes"
      auto_update_depth         "3"
      follow_outside_symlinks   "yes"
      follow_inside_symlinks    "yes"
    '';

    systemd.user.services."mpd" = {
      enable = true;
      after = [ "network.target" "sound.target" ];
      description = "Music Player Daemon";
      serviceConfig = {
        ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon ${mpdConfigDir}/mpd.conf";
        Type = "notify";
        ExecStartPre = ''${pkgs.bash}/bin/bash -c "${pkgs.coreutils}/bin/mkdir -p '${mpdDataDir}' '${mpdPlaylistsDir}'"'';
      };
      wantedBy = mkIf (!cfg.startWhenNeeded) [ "default.target" ];
    };

    systemd.user.sockets."mpd" = mkIf cfg.startWhenNeeded {
      enable = true;
      listenStreams = [ (toString cfg.port) "%t/mpd/socket" ];
      socketConfig = {
        Backlog = 5;
        KeepAlive = true;
      };
      wantedBy = [ "sockets.target" ];
    };
  };
}
