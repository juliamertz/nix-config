{ pkgs, ... }:
{
  services.sunshine = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    capSysAdmin = false; # enable for wayland

    package = pkgs.sunshine.override {
      cudaSupport = true;
      stdenv = pkgs.cudaPackages.backendStdenv;
    };
  };
}
