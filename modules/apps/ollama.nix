{ inputs, settings, ... }:
let
  pkgs = import inputs.nixpkgs-unstable {
    system = settings.system.platform;
    config.allowUnfree = true;
  };
in
{
  # systemd.tmpfiles.rules = [
  #   "d /home/${user} 0775 ${user} ${group}"
  # ];

  services.ollama = {
    enable = true;
    # inherit user group;
    user = "ollama";
    group = "ollama";

    package = pkgs.ollama;
    acceleration = "cuda";

    home = "/games/ollama";
    models = "/games/ollama/models";
  };
}
