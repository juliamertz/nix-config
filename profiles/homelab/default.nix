{
  pkgs,
  dotfiles,
  ...
}:
{
  config = {
    secrets.profile = "personal";
    users.defaultUserShell = pkgs.zsh;

    environment.systemPackages =
      with pkgs;
      [
        btop
        fastfetch
        busybox
      ]
      ++ (with dotfiles.pkgs; [
        scripts
        zsh
        tmux
        neovim
        lazygit
      ]);
  };

  imports = [
    ./traefik.nix
    ./adguard.nix
    ./forgejo.nix
    ./samba.nix
    ./qbittorrent.nix
    ./wireguard.nix
    ./multimedia.nix

    ../../modules/containers/sponsorblock-atv.nix
    ../../modules/networking/zerotier
    ../../modules/sops.nix
    ../../modules/apps/git.nix
    ../../modules/apps/shell/zsh.nix
  ];
}
