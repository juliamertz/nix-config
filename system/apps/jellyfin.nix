{ pkgs, settings, ... }: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = settings.user.username;
  };

  environment.systemPackages =
    [ pkgs.jellyfin pkgs.jellyfin-web pkgs.jellyfin-ffmpeg ];
}
