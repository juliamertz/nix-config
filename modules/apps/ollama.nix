{ inputs, lib, settings, ... }:
let
  pkgs = import inputs.nixpkgs-unstable {
    system = settings.system.platform;
    config.allowUnfree = true;
  };
in {
  services.ollama = {
    package = pkgs.ollama;
    enable = true;
    acceleration = "cuda";
    sandbox = false;
    home = "${settings.user.home}";
    models = "${settings.user.home}/.ollama";
    # writablePaths = [ "${settings.user.home}" ];
  };
}
