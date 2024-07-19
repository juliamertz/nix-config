{ pkgs, lib, config, ... }:
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
    stylix.image = "${config.xdg.configHome}/background";
    stylix.enable = true;
    stylix.polarity = "dark";
    stylix.base16Scheme = colors.${cfg.variant};

    environment.systemPackages = with pkgs; [
      rose-pine-gtk-theme
      rose-pine-icon-theme
    ];

    environment.etc."/gtk-2.0/gtkrc".text = gtkSettings;
    environment.etc."/gtk-3.0/settings.ini".text = ''
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
