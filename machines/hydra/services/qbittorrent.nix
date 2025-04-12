{
  settings,
  config,
  ...
}: {
  imports = [../../../modules/apps/qbittorrent];

  reverse-proxy.services.qbittorrent = {
    subdomain = "qbittorrent";
    port = config.services.qbittorrent.port;
    theme = true;
  };

  services.qbittorrent = {
    enable = true;
    port = 8280;
    openFirewall = true;
    flood.enable = false;

    user = settings.user.username;
    group = "users";

    settings = {
      Core = {
        AutoDeleteAddedTorrentFile = "Never";
      };

      BitTorrent = {
        Session-Interface = "tun0";
        Session-InterfaceName = "tun0";
        Session-DefaultSavePath = /home/media/downloads;
        Session-DisableAutoTMMByDefault = false;
        Session-DisableAutoTMMTriggers-CategorySavePathChanged = false;
      };

      Preferences = {
        General-Locale = "en";
        WebUI-LocalHostAuth = false;
        WebUI-Password_PBKDF2 = "@ByteArray(V5kcWZHn4FTxBM8IxsnsCA==:HPbgopaa1ZO199s4zmJAZfJ+gmGKUyAQMX1MjbphhHTtup80tt/FOFshUMRQnvCqAxAu31F6ziiUqpuUQCytPg==)";
        WebUI-CustomHTTPHeaders = ''"content-security-policy: default-src 'self'; style-src 'self' 'unsafe-inline' develop.theme-park.dev raw.githubusercontent.com use.fontawesome.com; img-src 'self' themepark.homelab.lan raw.githubusercontent.com data:; script-src 'self' 'unsafe-inline'; object-src 'none'; form-action 'self'; frame-ancestors 'self'; font-src use.fontawesome.com;"'';
        WebUI-CustomHTTPHeadersEnabled = true;
        # WebUI-AlternativeUIEnabled = true;
        # WebUI-RootFolder = config.services.qbittorrent.userInterfaces.darklight;
      };
    };
  };
}
