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

    environment.systemPackages =
      let
        scripts = import ../../modules/scripts { inherit pkgs; };
      in
      with pkgs;
      [
        btop
        fastfetch
        diskonaut
        busybox
      ]
      ++ (with dotfiles.pkgs; [
        tmux
        neovim
        lazygit
      ])
      ++ (with scripts; [ wake ]);

    # enable dynamically linked binaries for mason in neovim
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [ stdenv.cc.cc ];
    };

    sops.secrets = helpers.ownedSecrets settings.user.username [ "openvpn_auth" ];

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
          features = [ "P2P" ];
        };
        killswitch = {
          enable = false;
          custom_rules = [ ];
        };
      };
    };
  };

  imports = [
    ./traefik.nix
    ./adguard.nix
    ./forgejo.nix
    # ./theme-park.nix
    ./qbittorrent.nix
    ./wireguard.nix
    ./multimedia.nix

    ../../modules/containers/home-assistant.nix
    ../../modules/containers/sponsorblock-atv.nix
    ../../modules/networking/zerotier
    ../../modules/sops.nix
    ../../modules/apps/git.nix
    ../../modules/apps/shell/zsh.nix
    ../../modules/networking/samba/server.nix

    inputs.protonvpn-rs.nixosModules.protonvpn
  ];
}
