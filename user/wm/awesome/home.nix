{ settings, ... }:
{
  imports = [
    ../widgets/rofi/rofi.nix
  ];

  xsession.windowManager.awesome.enable = true;

  home.file.".config/awesome" = {
    source = ./config;
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

    run "${settings.user.browser}"
    run "wezterm start -- tmux a || tmux new"
  '';
}
