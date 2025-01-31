{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.rose-pine;
  colors = pkgs.callPackage ./colors.nix { };
in
{
  options = {
    rose-pine.variant = lib.mkOption {
      type = lib.types.str;
      default = "moon";
    };
  };

  config = {
    stylix.image = ./bg.jpeg;
    stylix.enable = true;
    stylix.polarity = "dark";
    stylix.base16Scheme = colors.${cfg.variant};

    environment.systemPackages = with pkgs; [
      rose-pine-gtk-theme
      rose-pine-icon-theme
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
    ];

    home.config.stylix.targets.gtk.enable = false;
    home.file.".config/gtk-2.0/gtkrc".text = ''
      gtk-theme-name = rose-pine-moon
      gtk-icon-theme-name = oomox-rose-pine-moon
    '';
    home.file.".config/gtk-3.0/settings.ini".text = 
    # ini
    ''
      [Settings]
      gtk-theme-name=rose-pine-moon 
      gtk-icon-theme-name=rose-pine-moon                                                                                      
      gtk-font-name=Sans 10
    '';

    qt = {
      enable = true;
      platformTheme = "gtk2";
      style = "adwaita";
    };

    nixpkgs.config.qt5 = {
      enable = true;
      platformTheme = "qt5ct";
      style = {
        package = pkgs.utterly-nord-plasma;
        name = "Utterly Nord Plasma";
      };
    };

  };
}
