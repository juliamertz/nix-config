{ config, ... }: {
  networking.interfaces.enp4s0 = { wakeOnLan.enable = true; };

  hardware.opengl = { enable = true; };

  boot.supportedFilesystems = [ "ntfs" ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Set nvidia-drm.modeset=1 kernel parameter
    modesetting.enable = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement = {
      enable = true;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      finegrained = false;
    };
    open = false; # Use the NVidia open source kernel module
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
