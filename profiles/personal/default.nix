{
  pkgs,
  inputs,
  settings,
  helpers,
  dotfiles,
  ...
}:
let
  user = settings.user.username;
in
{
  config = {
    secrets.profile = "personal";

    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
    programs.appimage.binfmt = true;
    users.defaultUserShell = pkgs.zsh;
    programs.thunar.enable = true;

    sops.secrets = helpers.ownedSecrets user [ "openvpn_auth" ];

    # open port for development
    networking.firewall.allowedTCPPorts = [ 1111 1112 ];

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
          applyFirewallRules = true;
          custom_rules = [
            "-A INPUT -s 192.168.0.0/24 -j ACCEPT"
            "-A OUTPUT -d 192.168.0.0/24 -j ACCEPT"
          ];
        };
      };
    };

    nix.settings = {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };

    environment.systemPackages =
      let
        scripts = import ../../modules/scripts { inherit pkgs; };
      in
      (with scripts; [
        dev
        wake
        comma
        fishies
      ])
      ++ (with dotfiles.pkgs; [
        neovim
        kitty
        lazygit
        tmux
      ])
      ++ (with pkgs; [
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
        gh
        ethtool
        (pkgs.callPackage ../../modules/bluegone.nix { })
      ]);

    # enable dynamically linked binaries for mason in neovim
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [ stdenv.cc.cc ];
    };

    # Conflicts with cosmic flake
    # xdg.portal.config = {
    #   enable = true;
    #   extraPortals = with pkgs; [
    #     xdg-desktop-portal-wlr
    #     xdg-desktop-portal-gtk
    #   ];
    # };
  };

  imports = [
    ../gaming

    ../../modules/networking/zerotier
    ../../modules/io/bluetooth.nix
    ../../modules/io/pipewire.nix
    ../../modules/io/keyd.nix
    ../../modules/apps/virtmanager.nix
    ../../modules/sops.nix
    ../../modules/themes/rose-pine
    ../../modules/wm/awesome
    ../../modules/dm/sddm
    ../../modules/scripts/home-assistant.nix
    ../../modules/apps/git.nix
    ../../modules/apps/media/spotify
    # ../../modules/apps/terminal/kitty.nix
    ../../modules/apps/terminal/wezterm.nix
    ../../modules/apps/shell/fish.nix
    ../../modules/apps/shell/zsh.nix
    ../../modules/networking/samba/client.nix
    ../../modules/nerdfonts.nix
    ../../modules/lang/lua.nix
    ../../modules/lang/nix.nix
    # ../modules/wm/hyprland
    # ../modules/apps/browser/librewolf.nix
    # ../modules/apps/ollama.nix
    # ../modules/apps/affinity.nix
    # ../../modules/de/cosmic
    # ../modules/de/plasma
    inputs.protonvpn-rs.nixosModules.protonvpn
    inputs.stylix.nixosModules.stylix
    inputs.flake-programs-sqlite.nixosModules.programs-sqlite
  ];

}
