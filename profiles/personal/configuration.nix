{ pkgs, inputs, settings, helpers, ... }:
{
  imports = [
    ../../system/networking/zerotier # Vpn tunnel
    ../../system/networking/openvpn # Protonvpn configurations
    ../../system/lang/rust.nix # Rust toolchain
    ../../system/lang/sql.nix # Rust toolchain
    ../../system/lang/go.nix # Rust toolchain
    ../../system/io/bluetooth.nix # Bluetooth setup
    ../../system/io/pipewire.nix # Audio server
    ../../system/io/keyd.nix # Key remapping daemon
    ../../system/containers/sponsorblock-atv.nix
    # ../../system/apps/jellyfin.nix
    ../../system/containers/jellyfin.nix
    ../../system/apps/virtmanager.nix # Virtual machines
    ../../system/sops.nix # Secrets management
    ../../system/themes/rose-pine
    ../../system/wm/awesome
    ../../system/wm/hyprland
    ../gaming/configuration.nix # Games & related apps
    ../../system/display-manager/sddm.nix
    ../../system/scripts/home-assistant.nix
    ../../system/scripts/remote.nix
    ../../system/scripts/deref.nix
    ../../system/apps/git.nix
    ../../system/apps/media/spotify
    ../../system/apps/lazygit.nix
    ../../system/apps/terminal/kitty.nix
    ../../system/apps/terminal/wezterm.nix
    ../../system/apps/terminal/tmux.nix
    ../../system/apps/shell/fish.nix
    ../../system/apps/shell/zsh.nix
    ../../system/apps/neovim.nix
    ../../system/apps/qbittorrent.nix
    inputs.stylix.nixosModules.stylix
    inputs.affinity.nixosModules.affinity
  ];

  config = {
    affinity = let path = "${settings.user.home}/affinity"; in {
      prefix ="${path}/prefix"; 
      licenseViolations ="${path}/license_violations"; 
      user = settings.user.username;

      photo.enable = true;
      designer.enable = true;
    };

    jellyfin = {
      configDir = "${settings.user.home}/jellyfin";
      volumes = [
        "${settings.user.home}/media/series:/shows"
        "${settings.user.home}/media/movies:/movies"
      ];
    };

    # programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    secrets.profile = "personal";

    openvpn.proton = {
      enable = true;
      profile = "nl-protonvpn";
    };

    programs.zsh.enable = true;

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    environment.systemPackages = with pkgs; [
      qdirstat
      blender
      activate-linux
      veracrypt
      handbrake
      dolphin
      nautilus
      mpv
      scrot
      sxiv
      cudatoolkit
      zip
      unzip
      xorg.xhost
      networkmanagerapplet
      brave
      usbutils 
      killall
      firefox
      ethtool
      (helpers.wrapPackage {
        name = "ffmpeg";
        package = pkgs.ffmpeg-full;
        extraFlags = "-hwaccel cuda -hwaccel_output_format cuda"; # (https://docs.nvidia.com/video-technologies/video-codec-sdk/12.0/ffmpeg-with-nvidia-gpu/index.html#hwaccel-transcode-without-scaling)
      })
    ];

    programs.thunar.enable = true;
    nixpkgs.config.allowUnfree = true;
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
}
