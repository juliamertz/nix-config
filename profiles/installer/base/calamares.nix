{ pkgs, modulesPath, ... }:
{
  imports = [
    ./graphical.nix
  ];

  environment.systemPackages = with pkgs; [
    # Calamares for graphical installation
    libsForQt5.kpmcore
    calamares-nixos
    calamares-nixos-extensions
    # Get list of locales
    glibcLocales
  ];

  installer-desktop.paths = with pkgs; [ calamares-nixos ];

  # Support choosing from any locale
  i18n.supportedLocales = [ "all" ];
}
