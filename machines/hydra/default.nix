{
  pkgs,
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
  };

    k3s = {
      enable = true;
      role = "agent";
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

    ../../modules/containers/sponsorblock-atv.nix
    ../../modules/networking/zerotier
    ../../modules/sops.nix
    ../../modules/k3s.nix
    ../../modules/apps/shell/zsh.nix
  ];
}
