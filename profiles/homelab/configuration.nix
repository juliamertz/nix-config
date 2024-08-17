{ pkgs, settings, config, ... }: {
  imports = [
    ../../modules/containers/home-assistant.nix
    ../../modules/containers/jellyfin.nix
    ../../modules/containers/sponsorblock-atv.nix
    ../../modules/networking/zerotier # Vpn tunnel
    ../../modules/sops.nix # Secrets management
    ../../modules/apps/git.nix
    ../../modules/apps/terminal/tmux.nix
    ../../modules/apps/shell/zsh.nix
    ../../modules/apps/neovim.nix
    ../../modules/apps/lazygit.nix
    ../../modules/lang/lua.nix
    ../../modules/networking/openvpn # Protonvpn configurations
    ../../modules/apps/qbittorrent
    ../../modules/networking/samba/server.nix
  ];

  jellyfin = let user = settings.user.home;
  in {
    configDir = "${user}/jellyfin";
    volumes = [
      "/home/media/shows:/shows"
      "/home/media/movies:/movies"
      "/home/media/music:/music"
    ];
  };

  openvpn.proton = {
    enable = true;
    profile = "nl-393";
  };

  services.qbittorrent = {
    enable = true;
    port = 8280;
    user = settings.user.username;
    group = "users";
    settings = {
      Meta = { MigrationVersion = 6; };

      BitTorrent = {
        Session-Port = 54406;
        Session-QueueingSystemEnabled = false;
        Session-Interface = "tun0";
        Session-InterfaceName = "tun0";
      };

      Preferences = {
        General-Locale = "en";
        MailNotification-req_auth = true;
        WebUI-AuthSubnetWhitelist = "@Invalid()";
        WebUI-LocalHostAuth = false;
        WebUI-AlternativeUIEnabled = true;
        Session-DefaultSavePath = "${settings.user.home}/downloads";
        WebUI-Password_PBKDF2 =
          "@ByteArray(V5kcWZHn4FTxBM8IxsnsCA==:HPbgopaa1ZO199s4zmJAZfJ+gmGKUyAQMX1MjbphhHTtup80tt/FOFshUMRQnvCqAxAu31F6ziiUqpuUQCytPg==)";
        WebUI-RootFolder = config.services.qbittorrent.userInterfaces.iQbit;
      };
    };
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  nixpkgs.config.allowUnfree = true;
  secrets.profile = "personal";

  environment.systemPackages = with pkgs; [ btop fastfetch ];
}
