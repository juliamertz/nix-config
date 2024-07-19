{ pkgs, inputs, settings, pkgs-wrapped, ... }:
{
  imports = [
    ../../system/networking/zerotier # Vpn tunnel
    ../../system/networking/openvpn # Protonvpn configurations
    ../../system/lang/rust.nix # Rust toolchain
    ../../system/lang/go.nix # Rust toolchain
    ../../system/io/bluetooth.nix # Bluetooth setup
    ../../system/io/pipewire.nix # Audio server
    ../../system/io/keyd.nix # Key remapping daemon
    ../../system/containers/sponsorblock-atv.nix
    ../../system/apps/jellyfin.nix
    # ../../system/containers/jellyfin.nix
    ../../system/apps/virtmanager.nix # Virtual machines
    ../../system/sops.nix # Secrets management
    ../../system/themes/rose-pine
    ../gaming/configuration.nix # Games & related apps
    ../../system/display-manager/sddm.nix
    ../../system/scripts/home-assistant.nix
    ../../system/scripts/deref.nix
    ../../system/dotfiles.nix
    ../../system/apps/git.nix
    ../../system/apps/spotify.nix
    ../../user/wm/awesome/configuration.nix
    inputs.stylix.nixosModules.stylix
    inputs.affinity.nixosModules.affinity
  ];

  affinity = let path = "${settings.user.home}/affinity"; in {
    prefix ="${path}/prefix"; 
    licenseViolations ="${path}/license_violations"; 
    user = settings.user.username;

    photo.enable = true;
    designer.enable = true;
  };

  users.defaultUserShell = pkgs.bash;
  secrets.profile = "personal";

  # jellyfin = {
  #   volumes = [
  #    "${settings.user.home}/jellyfin/config:/config"
  #    "${settings.user.home}/jellyfin/cache:/cache"
  #    "${settings.user.home}/media:/media"
  #   ];
  # };

  dotfiles = {
    local = {
      enable = true;
      path = settings.user.dotfiles;
    };
  };
  
  openvpn.proton = {
    enable = false;
    profile = "nl-protonvpn";
  };

  programs.ssh = {
    forwardX11 = true;
  };

  environment.systemPackages = [ ]
  ++ (with pkgs-wrapped; [
      lazygit
      nvim
      kitty
      tmux
      fish
      wezterm
    ])
  ++ (with pkgs; [
      qbittorrent
      qdirstat
      nautilus
      mpv
      xorg.xhost
      networkmanagerapplet
      usbutils 
      killall
      ffmpeg
      firefox
      ethtool
    ]);

  nixpkgs.config.allowUnfree = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
}
