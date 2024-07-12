{ config, pkgs, inputs, settings, ... }:
let 
  user = settings.user.username;
in {
  imports = [
    # ../../user/app/games/sunshine.nix
    ../../user/app/games/launchers.nix
    ../../user/app/io/keyd.nix
    ../../user/app/vm.nix
    ../../user/wm/awesome/configuration.nix
    ../../user/networks.nix
    ../../user/sops.nix
    ../../user/development/rust.nix
    ../../user/app/shell/bash.nix
    ../../user/app/io/bluetooth.nix
    ../../user/app/io/audio/pipewire.nix
  ];

  networking.hostName = "workstation"; 
  users.users.${user} = {
    isNormalUser = true;
    description = "Julia Mertz";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [];
  };

  services.getty.autologinUser = user;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  users.defaultUserShell = pkgs.bash;

  environment.systemPackages = with pkgs; [
    bat
    wget
    fzf
    wezterm
    tmux
    ripgrep
    jq
    neofetch
    discord
    delta
    pavucontrol
    sops
    # inputs.suyu.packages.x86_64-linux.suyu
  ];

  system.stateVersion = "24.05";
}
