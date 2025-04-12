{
  dotfiles,
  pkgs,
  lib,
  ...
}: {
  home.file = {
    ".config/awesome" = {
      source = "${dotfiles.path}/awesome";
      recursive = true;
    };

    ".config/awesome/autorun.sh" = {
      executable = true;
      text =
        # sh
        ''
          #!/usr/bin/env sh

          run() {
              if ! pgrep -f "$(basename $1)"; then
                  "$@" &
              fi
          }

          run ${lib.getExe dotfiles.pkgs.picom} -b
          run ${lib.getExe pkgs.librewolf}
          run ${pkgs.blueman}/bin/blueman-applet
        '';
    };
  };

  services.xserver = {
    enable = true;
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [luarocks];
    };
  };

  environment.systemPackages = with pkgs; [
    rofi
    pamixer
    playerctl
  ];
}
