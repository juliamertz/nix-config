{ config, ... }:

{
  networking.interfaces.enp4s0 = {
    wakeOnLan.enable = true;
  };

  hardware.opengl = {
    enable = true;
  };

  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
  ];

  services.xserver.videoDrivers = [ "nvidia" ]; 
  hardware.nvidia = {
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
    open = false; # Use the NVidia open source kernel module
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
