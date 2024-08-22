{ inputs, settings, ... }:
let
  platform = settings.system.platform;

  pkgs = import inputs.nixpkgs-unstable {
    system = platform;
    config.allowUnfree = true;
  };
  pkg = pkgs.sunshine.override {
    cudaSupport = true;
    stdenv = pkgs.cudaPackages.backendStdenv;
  };
in {
  environment.systemPackages = [ pkg ];
  services.udev.packages = [ pkg ];

  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${pkg}/bin/sunshine";
  };

  networking.firewall = {
    allowedTCPPorts = [ 47984 47989 47990 48010 ];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48000;
      }
      {
        from = 8000;
        to = 8010;
      }
    ];
  };

  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;
}
