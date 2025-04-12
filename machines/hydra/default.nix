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
        tmux
        neovim
        lazygit
      ]);
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
    ../../modules/apps/shell/zsh.nix
  ];
}
