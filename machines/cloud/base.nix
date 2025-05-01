{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
    # ./hardware.nix
  ];
}
