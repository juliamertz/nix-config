{ dotfiles, settings, pkgs, ... }: {
  imports = [ ../picom ];

  config = {
    home.file.".config/awesome" = {
      source = "${dotfiles.path}/awesome";
      recursive = true;
    };

    home.file.".config/awesome/autorun.sh".executable = true;
    home.file.".config/awesome/autorun.sh".text = # bash
      ''
        #!/usr/bin/env sh

        run() {
            if ! pgrep -f "$(basename $1)"; then
                "$@" &
            fi
        }

        run ${pkgs.spotify-player}/bin/spotify_player --daemon
        run ${pkgs.firefox}/bin/firefox
        run ${pkgs.picom}/bin/picom -b
        
        # run "${pkgs.wezterm}/bin/wezterm start -- ${pkgs.tmux}/bin/tmux a || ${pkgs.tmux}/bin/tmux new"
      '';

    environment.systemPackages = with pkgs; [ rofi pamixer playerctl ];

    services.xserver = {
      enable = true;
      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [ luarocks ];
      };
    };
  };
}
