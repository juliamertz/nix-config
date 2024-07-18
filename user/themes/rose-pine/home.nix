{ pkgs, lib, config, ... }:
let
  cfg = config.rose-pine;
  themeName = 
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
    home.packages = with pkgs; [
      rose-pine-gtk-theme
      rose-pine-icon-theme
    ];

    home.file.".config/gtk-2.0/gtkrc".text = ''
      gtk-theme-name = "${themeName}"
    '';

    home.file.".config/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name = ${themeName}
      gtk-icon-theme-name = ${themeName}
    '';

    qt = {
      enable = true;
      platformTheme = "gtk";
      style.name = "gtk2";
    };
  };
}
