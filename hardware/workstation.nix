{ config, inputs, settings, ... }:
let
  pkgs = import inputs.nixpkgs-unstable {
    system = settings.system.platform;
    config.allowUnfree = true;
  };

in {
  # Graphics
  nixpkgs.config.packageOverrides = pkgs: {
    inherit (pkgs) linuxPackages_latest nvidia_x11;
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [ cudatoolkit ];

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

  # Networking
  networking.interfaces.enp4s0 = { wakeOnLan.enable = true; };
}
