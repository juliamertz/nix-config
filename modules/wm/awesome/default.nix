{ dotfiles, pkgs, ... }:
{
  imports = [ ../picom ];

  config = {
    home.file.".config/awesome" = {
      source = "${dotfiles.path}/awesome";
      recursive = true;
    };

    home.file.".config/awesome/autorun.sh" = {
      executable = true;
      text = # bash
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

          xinput set-prop 'Logitech USB Receiver Mouse' 'libinput Accel Speed' -1
        '';
    };

    environment.systemPackages = with pkgs; [
      rofi
      pamixer
      playerctl
    ];

    services.xserver = {
      enable = true;
      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [ luarocks ];
      };
    };
  };
}
