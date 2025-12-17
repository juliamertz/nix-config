{pkgs, ...}: {
  imports = [
    ./graphical.nix
  ];

  environment.systemPackages = with pkgs; [
    calamares-nixos
    calamares-nixos-extensions
    glibcLocales
  ];

  installer-desktop.paths = with pkgs; [calamares-nixos];

  # Support choosing from any locale
  i18n.supportedLocales = ["all"];
}
