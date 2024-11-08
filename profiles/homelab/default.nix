{
  pkgs,
  settings,
  helpers,
  inputs,
  ...
}:
{
  config = {
    secrets.profile = "personal";
    users.defaultUserShell = pkgs.zsh;

    environment.systemPackages = with pkgs; [
      btop
      fastfetch
      diskonaut
      busybox
    ];

    jellyfin =
      let
        user = settings.user.home;
      in
      {
        configDir = "${user}/jellyfin";
        volumes = [
          "/home/media/shows:/shows"
          "/home/media/movies:/movies"
          "/home/media/music:/music"
        ];
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
    ./theme-park.nix
    ./qbittorrent.nix
    ./wireguard.nix

    ../../modules/containers/home-assistant.nix
    ../../modules/containers/jellyfin.nix
    ../../modules/containers/sponsorblock-atv.nix
    ../../modules/networking/zerotier
    ../../modules/sops.nix
    ../../modules/apps/git.nix
    ../../modules/apps/terminal/tmux.nix
    ../../modules/apps/shell/zsh.nix
    ../../modules/apps/neovim.nix
    ../../modules/apps/lazygit.nix
    ../../modules/networking/samba/server.nix

    inputs.protonvpn-rs.nixosModules.protonvpn
  ];
}
