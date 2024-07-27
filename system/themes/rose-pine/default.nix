{ pkgs, lib, config, settings, ... }:
let
  cfg = config.rose-pine;
  colors = pkgs.callPackage ./colors.nix {};
  gtkSettings = ''
    gtk-theme-name = ${name}
    gtk-icon-theme-name = oomox-${name}
  '';
  name = 
    if cfg.variant == "main" then "rose-pine" 
    else ("rose-pine-" + cfg.variant);
in {
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
    ];

    home.config.stylix.targets.gtk.enable = false;
    home.file.".config/gtk-2.0/gtkrc".text = gtkSettings;
    home.file.".config/gtk-3.0/settings.ini".text = ''
      [Settings]
      ${gtkSettings}
    '';

    qt = {
      enable = true;
      platformTheme = "gtk2";
      style = "adwaita";
    };
  };
}
