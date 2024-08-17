{ pkgs, inputs, settings, helpers, config, ... }: {
  imports = [
    ../../modules/networking/zerotier # Vpn tunnel
    ../../modules/networking/openvpn # Protonvpn configurations
    ../../modules/lang/rust.nix
    ../../modules/lang/sql.nix
    ../../modules/lang/go.nix
    ../../modules/io/bluetooth.nix # Bluetooth setup
    ../../modules/io/pipewire.nix # Audio server
    ../../modules/io/keyd.nix # Key remapping daemon
    ../../modules/apps/virtmanager.nix # Virtual machines
    ../../modules/sops.nix # Secrets management
    ../../modules/themes/rose-pine
    ../../modules/wm/awesome
    ../../modules/wm/hyprland
    ../gaming/configuration.nix # Games & related apps
    ../../modules/display-manager/sddm
    ../../modules/scripts/home-assistant.nix
    ../../modules/scripts/remote.nix
    ../../modules/scripts/deref.nix
    ../../modules/apps/git.nix
    ../../modules/apps/media/spotify
    ../../modules/apps/ollama.nix
    ../../modules/apps/lazygit.nix
    ../../modules/apps/terminal/kitty.nix
    ../../modules/apps/terminal/wezterm.nix
    ../../modules/apps/terminal/tmux.nix
    ../../modules/apps/shell/fish.nix
    ../../modules/apps/shell/zsh.nix
    ../../modules/apps/neovim.nix
    ../../modules/networking/samba/client.nix
    ../../modules/apps/browser/librewolf.nix
    inputs.stylix.nixosModules.stylix
    inputs.affinity.nixosModules.affinity
  ];

  config = {
    affinity = let path = "${settings.user.home}/affinity";
    in {
      prefix = "${path}/prefix";
      licenseViolations = "${path}/license_violations";
      user = settings.user.username;

      photo.enable = true;
      designer.enable = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
    secrets.profile = "personal";

    openvpn.proton = {
      enable = true;
      profile = "nl-393";
    };

    fonts.packages = with pkgs;
      [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

    nixpkgs.config.packageOverrides = self: rec {
      blender = self.blender.override { cudaSupport = true; };
    };

    environment.systemPackages =
      let json_repair = pkgs.callPackage ../../pkgs/json_repair.nix { };
      in with pkgs; [
        # json_repair
        qdirstat
        blender
        activate-linux
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
        (pkgs.callPackage ../../modules/bluegone.nix { })
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

# sudo etherwake -i enp0s10 04:7C:16:EB:DF:9B
