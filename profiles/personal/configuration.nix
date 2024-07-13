{ config, pkgs, inputs, settings, ... }:
let 
  user = settings.user.username;
in {
  imports = [
    ../../system/apps/sunshine.nix
    ../../system/apps/games.nix
    ../../system/apps/virtmanager.nix
    ../../system/apps/zerotier.nix
    ../../system/io/keyd.nix
    ../../user/wm/awesome/configuration.nix
    ../../user/sops.nix
    ../../user/development/rust.nix
    ../../user/app/shell/bash.nix
    ../../system/io/bluetooth.nix
    ../../system/io/pipewire.nix
  ];

  users.defaultUserShell = pkgs.bash;

  networking.hostName = "workstation"; 
  users.users.${user} = {
    isNormalUser = true;
    description = "Julia Mertz";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [];
  };



  environment.systemPackages = with pkgs; [
    wget
    wezterm
    tmux
    neofetch
    discord
    pavucontrol
    sops
    # inputs.suyu.packages.x86_64-linux.suyu
  ];

  system.stateVersion = "24.05";
}
