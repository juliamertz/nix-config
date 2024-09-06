{
  config,
  inputs,
  settings,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  pkgs = import inputs.nixpkgs-unstable {
    system = settings.system.platform;
    config.allowUnfree = true;
  };
in
{
  nixpkgs.config.packageOverrides = pkgs: { inherit (pkgs) linuxPackages_latest nvidia_x11; };
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [ cudatoolkit ];

  hardware.opengl = {
    enable = true;
  };
  boot.supportedFilesystems = [ "ntfs" ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = false;
    };
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp4s0 = {
    wakeOnLan.enable = true;
  };

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7a3e2cc9-a8cd-4c05-ba11-92fc603488e4";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/2e75cdd2-6cec-47cb-951d-f88101e80b31";
    fsType = "ext4";
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

  swapDevices = [ ];
}
