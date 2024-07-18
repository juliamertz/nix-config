{ pkgs, inputs, settings, config, ... }:
{
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
    ../../user/scripts/home-assistant.nix
    ../../user/scripts/deref.nix
    ../../system/networking/openvpn
    inputs.stylix.nixosModules.stylix
  ];

  users.defaultUserShell = pkgs.bash;

  # services.flatpak.enable = true;
  programs.thunar.enable = true;

  openvpn.proton = {
    enable = true;
    profile = "de-protonvpn";
  };

  secrets.profile = "personal";
  sops.secrets = {
    zerotier_network_id = { owner = settings.user.username; };
    home_assistant_ip = { owner = settings.user.username; };
    home_assistant_token = { owner = settings.user.username; };
  };

  environment.systemPackages = [ 
    pkgs.qbittorrent
    pkgs.networkmanagerapplet
    pkgs.usbutils 
  ];

  boot.supportedFilesystems = [ "ntfs" ];
  nixpkgs.config.allowUnfree = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
}
