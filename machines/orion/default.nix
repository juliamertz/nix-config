{
  pkgs,
  inputs,
  dotfiles,
  settings,
  ...
}: let
  nurPackages = inputs.nur.packages.${pkgs.stdenv.hostPlatform.system};
in {
  config = {
    secrets.profile = "personal";
    users.defaultUserShell = pkgs.zsh;

    networking.firewall.trustedInterfaces = ["enp4s0" "virbr0"];

    # open ports for development
    networking.firewall.allowedTCPPorts = [
      1111
      1112
    ];

    networking.hosts = {
      "10.100.0.1" = ["gatekeeper"];
      "10.100.0.2" = ["main"];
    };

    services.rpcbind.enable = true;
    boot.supportedFilesystems = ["nfs"];

    nerdfonts = {
      enable = true;
      enableUnfree = true;
    };

    services.tailscale.enable = true;

    environment.variables = {
      BROWSER = "librewolf";
      TERMINAL = "kitty";
    };

    environment.systemPackages =
      (with dotfiles.pkgs; [
        scripts
        tmux
        neovim
        lazygit
        kitty
        wezterm
        zsh
        fish
        w3m
        weechat
        zathura
      ])
      ++ (with nurPackages; [
        nixpins
      ])
      ++ (with pkgs; [
        ripgrep # find
        repgrep # replace
        emote # gtk emote picker popup
        gpu-screen-recorder-gtk
        qdirstat # disk space explorer
        btop # resource monitor
        fastfetch
        mpv # video player
        scrot # screenshot utility
        sxiv # image viewer
        lsof

        # misc utils
        xorg.xhost
        networkmanagerapplet
        usbutils
        ethtool
      ]);

    k3s = {
      enable = true;
      openFirewall = true;
      role = "agent";
      sopsFile = ../../secrets/cluster.yaml;
    };

    home-manager.users.julia = {
      imports = [
        ../../home/julia/cosmic.nix
        ../../home/julia/browser/librewolf.nix
        ../../home/julia/git.nix
      ];
    };
  };

  imports = [
    ./hardware.nix

    ./modules/games.nix
    ./modules/cosmic.nix
    # ./modules/wireguard.nix

    # ../../modules/networking/zerotier
    ../../modules/k3s.nix
    ../../modules/io/bluetooth.nix
    ../../modules/io/pipewire.nix
    ../../modules/sops.nix
    ../../modules/networking/samba/client.nix
    ../../modules/nerdfonts.nix
    ../../modules/containers/runtime/docker.nix

    # desktop environment
    ../../modules/wm/awesome
    ../../modules/dm/sddm.nix
    ../../modules/wm/hyprland
    ../../modules/io/keyd.nix
    ../../modules/themes/rose-pine

    # apps
    ../../modules/apps/shell/zsh.nix
    ../../modules/apps/media/spotify.nix
    # ../../modules/apps/browser/librewolf
    ../../modules/virtualisation/virtmanager.nix
    ../../modules/apps/thunar.nix
    # ../../modules/apps/ollama.nix

    inputs.stylix.nixosModules.stylix
  ];
}
