{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../base/installer-desktop.nix
  ];

  isoImage.edition = lib.mkDefault "plasma5";

  services.xserver.desktopManager.plasma5 = {
    enable = true;
  };

  installer-desktop.enable = true;

  # Automatically login as nixos.
  services.displayManager = {
    sddm.enable = true;
    autoLogin = {
      enable = true;
      user = "nixos";
    };
  };

  environment.systemPackages = with pkgs; [
    # Graphical text editor
    plasma5Packages.kate
  ];
}
