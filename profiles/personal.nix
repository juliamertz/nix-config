{ pkgs, inputs, settings, helpers, config, ... }: {
  imports = [
    ./gaming.nix # Games & related apps

    ../modules/networking/zerotier # Vpn tunnel
    # ../modules/networking/openvpn # Protonvpn configurations
    ../modules/lang/rust.nix
    ../modules/lang/sql.nix
    ../modules/lang/go.nix
    ../modules/io/bluetooth.nix # Bluetooth setup
    ../modules/io/pipewire.nix # Audio server
    ../modules/io/keyd.nix # Key remapping daemon
    ../modules/apps/virtmanager.nix # Virtual machines
    ../modules/sops.nix # Secrets management
    ../modules/themes/rose-pine
    ../modules/wm/awesome
    ../modules/wm/hyprland
    ../modules/display-manager/sddm
    ../modules/scripts/home-assistant.nix
    ../modules/scripts/remote.nix
    ../modules/scripts/deref.nix
    ../modules/apps/git.nix
    ../modules/apps/media/spotify
    ../modules/apps/ollama.nix
    ../modules/apps/lazygit.nix
    ../modules/apps/terminal/kitty.nix
    ../modules/apps/terminal/wezterm.nix
    ../modules/apps/terminal/tmux.nix
    ../modules/apps/shell/fish.nix
    ../modules/apps/shell/zsh.nix
    ../modules/apps/neovim.nix
    ../modules/networking/samba/client.nix
    ../modules/apps/browser/librewolf.nix
    # ../modules/wm/cosmic
    inputs.protonvpn-rs.nixosModules.protonvpn
    inputs.stylix.nixosModules.stylix
  ];

  config = {
    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };

    programs.appimage.binfmt = true;
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    secrets.profile = "personal";

    # openvpn.proton = {
    #   enable = true;
    #   profile = "nl-367";
    # };
    sops.secrets =
      helpers.ownedSecrets settings.user.username [ "openvpn_auth" ];

    fonts.packages = with pkgs;
      [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

    # nixpkgs.config.packageOverrides = self: rec {
    #   blender = self.blender.override { cudaSupport = true; };
    # };

    environment.systemPackages = with pkgs; [
      inputs.zen-browser.packages."${settings.system.platform}".generic
      qdirstat
      # blender
      activate-linux
      btop
      fastfetch
      veracrypt
      handbrake
      dolphin
      mpv
      scrot
      sxiv
      cudatoolkit
      zip
      unzip
      xorg.xhost
      networkmanagerapplet
      usbutils
      firefox
      ethtool
      (pkgs.callPackage ../modules/bluegone.nix { })
      (helpers.wrapPackage {
        name = "ffmpeg";
        package = pkgs.ffmpeg-full;
        extraFlags =
          "-hwaccel cuda -hwaccel_output_format cuda"; # (https://docs.nvidia.com/video-technologies/video-codec-sdk/12.0/ffmpeg-with-nvidia-gpu/index.html#hwaccel-transcode-without-scaling)
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
