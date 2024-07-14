{ pkgs, ... }:
{
  imports = [
    ../../system/apps/zerotier.nix # Vpn tunnel
    ../../user/sops.nix # Secrets management
  ];

  rose-pine.variant = "moon";
  users.defaultUserShell = pkgs.bash;

  boot.supportedFilesystems = [ "ntfs" ];
  nixpkgs.config.allowUnfree = true;
  programs.thunar.enable = true;

  environment.systemPackages = with pkgs; [
    sops
  ];
}
