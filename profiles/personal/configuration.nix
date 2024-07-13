{ config, pkgs, inputs, settings, ... }:
let 
  user = settings.user.username;
in {
  imports = [
    # ../../user/themes/rose-pine/moon.nix
    ../../system/apps/sunshine.nix
    ../../system/apps/games.nix
    ../../system/apps/virtmanager.nix
    ../../system/apps/zerotier.nix
    ../../system/io/keyd.nix
    ../../user/wm/awesome/configuration.nix
    ../../user/sops.nix
    ../../user/development/rust.nix
    ../../system/io/bluetooth.nix
    ../../system/io/pipewire.nix
  ];

  users.defaultUserShell = pkgs.bash;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  stylix.image = "${config.xdg.configHome}/background";
  stylix.enable = true;

  programs.thunar.enable = true;

  networking.hostName = "workstation"; 
  users.users.${user} = {
    isNormalUser = true;
    description = "Julia Mertz";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [];
  };


  environment.systemPackages = with pkgs; [
    neofetch
    discord
    pavucontrol
    sops
    # inputs.suyu.packages.x86_64-linux.suyu
  ];

  system.stateVersion = "24.05";
}
