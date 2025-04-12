{
  lib,
  config,
  ...
}: let
  cfg = config.gtk;
in {
  options.gtk = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
    };

    settings = {
      theme-name = mkOption {
        type = types.str;
        default = "Adwaita";
      };
      icon-theme-name = mkOption {
        type = types.str;
        default = "Adwaita";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."xdg/gtk-2.0/gtkrc".text = ''
      gtk-theme-name=${cfg.settings.theme-name}
      gtk-icon-theme-name=${cfg.settings.icon-theme-name}
    '';

    environment.etc."xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${cfg.settings.theme-name}
      gtk-icon-theme-name=${cfg.settings.icon-theme-name}
    '';
  };
}
