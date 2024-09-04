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

        run ${pkgs.firefox}/bin/firefox
        run ${pkgs.picom}/bin/picom -b
        run ${pkgs.blueman}/bin/blueman-applet
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
