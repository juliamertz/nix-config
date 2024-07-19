{ settings, pkgs, config, ... }:
{
  imports = [
    ../widgets/rofi/rofi.nix
    ../picom
  ];

  home.packages = with pkgs; [ pamixer playerctl ];
    
  xsession.windowManager.awesome.enable = true;

  home.file.".config/awesome" = {
    source = "${config.dotfiles.path}/awesome";
    recursive = true;
  };

  home.file.".config/awesome/autorun.sh".executable = true;
  home.file.".config/awesome/autorun.sh".text = /* bash */ ''
    #!/usr/bin/env sh

    run() {
        if ! pgrep -f "$1"; then
            "$@" &
        fi
    }

    ${pkgs.spotify-player}/bin/spotify_player --daemon
    run "${settings.user.browser}"
    run "${pkgs.wezterm}/bin/wezterm start -- ${pkgs.tmux}/bin/tmux a || ${pkgs.tmux}/bin/tmux new"
  '';
}
