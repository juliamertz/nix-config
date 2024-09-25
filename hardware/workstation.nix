{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./nvidia.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.useDHCP = lib.mkDefault true;
  networking.interfaces.enp4s0 = {
    wakeOnLan.enable = true;
  };

  boot.supportedFilesystems = [ "ntfs" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
  ];

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
