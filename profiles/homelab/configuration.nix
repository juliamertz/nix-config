{ pkgs, ... }:
{
  imports = [
    ../../system/apps/home-assistant.nix
    ../../system/apps/sponsorblock-atv.nix
    ../../system/apps/zerotier.nix # Vpn tunnel
    ../../user/sops.nix # Secrets management
  ];

  users.defaultUserShell = pkgs.bash;

  nixpkgs.config.allowUnfree = true;
  programs.thunar.enable = true;

  environment.systemPackages = with pkgs; [
    sops
  ];
}
