{
  pkgs,
  lib,
  dotfiles,
  ...
}: {
  config = {
    secrets.profile = "personal";
    users.defaultUserShell = pkgs.zsh;

    environment.systemPackages = with pkgs;
      [
        btop
        fastfetch
        busybox
      ]
      ++ (with dotfiles.pkgs; [
        scripts
        git
        zsh
        fish
        tmux
        neovim
        lazygit
      ]);

    k3s = {
      enable = true;
      openFirewall = true;
      role = "server";
      sopsFile = ../../secrets/cluster.yaml;
    };

    systemd.tmpfiles.rules = [
      "d /exports          0755 nobody nogroup"
      "d /exports/jellyfin 0755 nobody nogroup"
    ];

    services.nfs.server = {
      enable = true;
      exports = ''
        /exports/jellyfin 192.168.0.0/24(rw,sync,no_subtree_check)

        /home/media           192.168.0.0/24(rw,sync,no_subtree_check)
        /home/media/downloads 192.168.0.0/24(rw,sync,no_subtree_check)
      '';
    };

    networking.firewall = let
      nfsPorts = [
        2049 # NFS
        111 # portmap/rpcbind
        20048
      ];
    in {
      allowedTCPPorts = nfsPorts ++ [6443];
      allowedUDPPorts = nfsPorts;
    };
  };

  imports = [
    ./hardware.nix

    ./services/traefik.nix
    ./services/adguard.nix
    ./services/forgejo.nix
    ./services/samba.nix
    ./services/qbittorrent.nix
    ./services/wireguard.nix
    ./services/multimedia.nix
    ./services/home-assistant

    ../../modules/networking/zerotier
    ../../modules/sops.nix
    ../../modules/k3s.nix
    ../../modules/apps/shell/zsh.nix
  ];
}
