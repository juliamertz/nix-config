{ inputs, settings, ... }:
let
  inherit (settings.system) platform;

  pkgs = import inputs.nixpkgs-23_11 {
    system = platform;
    config.allowUnfree = true;
  };
  pkg = pkgs.sunshine.override {
    cudaSupport = true;
    stdenv = pkgs.cudaPackages.backendStdenv;
  };
in
{
  environment.systemPackages = [ pkg ];
  services.udev.packages = [ pkg ];

  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${pkg}/bin/sunshine";
  };

  # services.sunshine = let
  #   pkgs = import inputs.nixpkgs-unstable {
  #     system = settings.system.platform;
  #     config.allowUnfree = true;
  #   };
  #   sunshine = pkgs.sunshine.override {
  #     cudaSupport = true;
  #     stdenv = pkgs.cudaPackages.backendStdenv;
  #   };
  # in {
  #   enable = true;
  #   package = sunshine;
  #
  #   openFirewall = true;
  #   capSysAdmin = true;
  #   autoStart = true;
  # };

  networking.firewall = {
    allowedTCPPorts = [
      47984
      47989
      47990
      48010
    ];
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
