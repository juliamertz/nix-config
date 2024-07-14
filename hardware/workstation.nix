{ config, ... }:

{
  networking.interfaces.enp4s0 = {
    wakeOnLan.enable = true;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  services.xserver.videoDrivers = [ "nvidia" ]; 
}
