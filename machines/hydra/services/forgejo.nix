{config, ...}: {
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

  reverse-proxy.services.forgejo = {
    subdomain = "git";
    port = config.services.forgejo.settings.server.HTTP_PORT;
    theme = "gitea";
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
