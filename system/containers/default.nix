{ pkgs, ... }: {
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # dive # look into docker image layers
    podman-tui
    podman-compose
  ];
}
