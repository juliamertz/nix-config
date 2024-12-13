{
  dotfiles,
  pkgs,
  ...
}:
{
  imports = [ ../picom ];

  config =
    let
      autorun = pkgs.writeText "autorun.sh" # sh
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
    in
    {
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
        (pkgs.runCommandNoCC "awesome-config" { } ''
          mkdir -p $out/etc/xdg/awesome
          cp -r ${dotfiles.path}/awesome/*  $out/etc/xdg/awesome
          cp ${autorun} $out/etc/xdg/awesome/autorun.sh
        '')
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
