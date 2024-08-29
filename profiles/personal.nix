{ pkgs, inputs, settings, helpers, config, ... }:
let user = settings.user.username;
in {
  config = {
    secrets.profile = "personal";

    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
    programs.appimage.binfmt = true;
    programs.zsh.enable = true;
    programs.thunar.enable = true;

    users.defaultUserShell = pkgs.zsh;

    sops.secrets = helpers.ownedSecrets user [ "openvpn_auth" ];

    services.protonvpn = {
      enable = true;
      requireSops = true;

      settings = {
        credentials_path = "/run/secrets/openvpn_auth";
        autostart_default = true;

        default_select = "Fastest";
        default_protocol = "Udp";
        default_criteria = {
          country = "NL";
          features = [ "Streaming" ];
        };
        killswitch = {
          enable = false;
          custom_rules = [
            # "-A INPUT -s 192.168.0.0/16 -j ACCEPT"
            # "-A OUTPUT -d 192.168.0.0/16 -j ACCEPT"
            "-A INPUT -s 192.168.0.100 -j ACCEPT"
            "-A OUTPUT -d 192.168.0.100 -j ACCEPT"
            "-A INPUT -s 192.168.0.101 -j ACCEPT"
            "-A OUTPUT -d 192.168.0.101 -j ACCEPT"
            "-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT"
          ];
        };
      };
    };

    nix.settings = {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys =
        [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      inputs.zen-browser.packages."${settings.system.platform}".generic
      qdirstat
      btop
      fastfetch
      mpv
      scrot
      sxiv
      xorg.xhost
      networkmanagerapplet
      usbutils
      firefox
      ethtool
      (pkgs.callPackage ../modules/bluegone.nix { })
    ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  imports = [
    ./gaming.nix
    ../modules/networking/zerotier
    ../modules/lang/rust.nix
    ../modules/lang/sql.nix
    ../modules/lang/go.nix
    ../modules/io/bluetooth.nix
    ../modules/io/pipewire.nix
    ../modules/io/keyd.nix
    ../modules/apps/virtmanager.nix
    ../modules/sops.nix
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
    ../modules/nerdfonts.nix
    ../modules/de/cosmic
    inputs.protonvpn-rs.nixosModules.protonvpn
    inputs.stylix.nixosModules.stylix
  ];

}
