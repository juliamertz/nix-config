{
  pkgs,
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.supportedFilesystems = ["ntfs"];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
  ];

  # Cpu
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Networking
  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp4s0 = {
    wakeOnLan.enable = true;
  };

  # Filesystems
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7a3e2cc9-a8cd-4c05-ba11-92fc603488e4";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2e75cdd2-6cec-47cb-951d-f88101e80b31";
    fsType = "ext4";
    neededForBoot = true;
  };

  fileSystems."/games" = {
    device = "/dev/disk/by-uuid/f32a0b81-efbf-4696-b421-50331ec2b2b4";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2D88-45C8";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [];

  # Nvidia GPU
  environment.systemPackages = with pkgs; [
    cudatoolkit
    # nvidia-container-toolkit
  ];

  hardware.nvidia-container-toolkit.enable = true;

  hardware.graphics.enable = true;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  services.xserver.videoDrivers = ["nvidia"];

  # Common kernel params required for many programs on linux to work
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    powerManagement = {
      enable = true;
      finegrained = false;
    };
  };
}
