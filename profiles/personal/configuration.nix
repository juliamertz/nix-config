{ pkgs, inputs, ... }:
let 
  isponsorblocktv = pkgs.callPackage ../../pkgs/isponsorblocktv.nix { };

in {
  imports = [
    ../../system/apps/virtmanager.nix # Virtual machines
    ../../system/apps/protonvpn.nix # Virtual machines
    ../../system/apps/zerotier.nix # Vpn tunnel
    ../../system/io/keyd.nix # Key remapping daemon
    ../../user/wm/awesome/configuration.nix # Window manager
    ../../user/sops.nix # Secrets management
    ../../system/lang/rust.nix # Rust toolchain
    ../../system/lang/go.nix # Rust toolchain
    ../../system/io/bluetooth.nix # Bluetooth setup
    ../../system/io/pipewire.nix # Audio server
    ../gaming/configuration.nix # Games & related apps
    ../../user/themes/rose-pine/configuration.nix # Theme
    ../../system/display-manager/sddm.nix
    ../../system/apps/sponsorblock-atv.nix
    inputs.stylix.nixosModules.stylix
  ];

  rose-pine.variant = "moon";
  users.defaultUserShell = pkgs.bash;

  boot.supportedFilesystems = [ "ntfs" ];
  nixpkgs.config.allowUnfree = true;
  programs.thunar.enable = true;

  environment.systemPackages = [
    pkgs.sops
    isponsorblocktv
  ];
}
