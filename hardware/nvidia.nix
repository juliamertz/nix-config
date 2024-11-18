{
  config,
  inputs,
  settings,
  ...
}:
let
  pkgs = import inputs.nixpkgs-unstable {
    system = settings.system.platform;
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = with pkgs; [ cudatoolkit ];

  hardware.opengl.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.xserver.videoDrivers = [ "nvidia" ];

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  nixpkgs.config = {
    packageOverrides = _: { inherit (pkgs) linuxPackages_latest nvidia_x11; };
  };

  hardware.nvidia = {
    powerManagement = {
      enable = true;
      finegrained = false;
    };
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
