{
  config,
  ...
}:
{
  networking.firewall = {
    allowedTCPPorts = [
      3000
      222
    ];
    allowedUDPPorts = [
      3000
      222
    ];
  };

  # TODO: optional custom theme name instead of inferred from service name
  reverse-proxy.services.gitea = {
    subdomain = "git";
    port = config.services.gitea.settings.server.HTTP_PORT;
    theme = true;
  };

  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      server = {
        HTTP_PORT = 3000;
        SSH_PORT = 222;
        SSH_DOMAIN = "git.homelab.lan";
        DOMAIN = "git.homelab.lan";
        ROOT_URL = "https://git.homelab.lan/";
      };
      service.DISABLE_REGISTRATION = true;
      # actions = {
      #   ENABLED = true;
      #   DEFAULT_ACTIONS_URL = "github";
      # };
    };
  };
}
