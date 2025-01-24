{
  pkgs,
  settings,
  helpers,
  inputs,
  dotfiles,
  ...
}:
{
  config = {
    secrets.profile = "personal";
    users.defaultUserShell = pkgs.zsh;

    # AdGuard DNS without filters
    networking.nameservers = [
      "94.140.14.140"
      "94.140.14.141"
    ];

    environment.systemPackages =
      with pkgs;
      [
        btop
        fastfetch
        diskonaut
        busybox
      ]
      ++ (with dotfiles.pkgs; [
        scripts
        tmux
        neovim
        lazygit
      ]);

    nix.settings = {
      trusted-users = [ settings.user.username ];
      trusted-public-keys = [ "cache.juliamertz.dev-1:Jy4H1rmdG1b9lqEl5Ldy0i8+6Gqr/5DLG90r4keBq+E=" ];
    };
  };

  imports = [
    ./traefik.nix
    ./adguard.nix
    ./forgejo.nix
    ./samba.nix
    # ./qbittorrent.nix
    ./wireguard.nix
    ./multimedia.nix

    ../../modules/containers/home-assistant.nix
    ../../modules/containers/sponsorblock-atv.nix
    ../../modules/networking/zerotier
    ../../modules/sops.nix
    ../../modules/apps/git.nix
    ../../modules/apps/shell/zsh.nix

    # inputs.protonvpn-rs.nixosModules.protonvpn
  ];
}
