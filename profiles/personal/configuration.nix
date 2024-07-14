{ pkgs, inputs, ... }:
{
  imports = [
    ../../system/apps/virtmanager.nix # Virtual machines
    ../../system/apps/zerotier.nix # Vpn tunnel
    ../../system/io/keyd.nix # Key remapping daemon
    ../../user/wm/awesome/configuration.nix # Window manager
    ../../user/sops.nix # Secrets management
    ../../system/lang/rust.nix # Rust toolchain
    ../../system/lang/go.nix # Rust toolchain
    ../../system/io/bluetooth.nix # Bluetooth setup
    ../../system/io/pipewire.nix # Audio server
    ../gaming/configuration.nix # Games & related apps
    # inputs.stylix.nixosModules.stylix
  ];

  users.defaultUserShell = pkgs.bash;

  # stylix.image = "${config.xdg.configHome}/background";
  # stylix.enable = true;
  # stylix.polarity = "dark";
  # environment.sessionVariables = {
  #   QT_QPA_PLATFORMTHEME="qt6ct";
  # };

  boot.supportedFilesystems = [ "ntfs" ];
  programs.thunar.enable = true;

  environment.systemPackages = with pkgs; [
    sops
  ];
}
