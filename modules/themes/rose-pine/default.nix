{pkgs, ...}: let
  colors = pkgs.callPackage ./colors.nix {};
in {
  stylix.image = ./bg.jpeg;
  stylix.enable = true;
  stylix.polarity = "dark";
  stylix.base16Scheme = colors.moon;

  home.config.stylix.targets.gtk.enable = false;

  environment.systemPackages = with pkgs; [
    rose-pine-gtk-theme
    rose-pine-icon-theme
  ];

  gtk.settings = {
    theme-name = "rose-pine-moon";
    icon-theme-name = "rose-pine-moon";
  };

  imports = [../gtk.nix];
}
