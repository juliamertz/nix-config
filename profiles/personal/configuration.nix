{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../hardware/workstation.nix
    ../../user/app/games/sunshine.nix
    ../../user/app/games/launchers.nix
    ../../user/app/input/keyd.nix
    ../../user/app/vm.nix
    ../../user/wm/awesome/configuration.nix
    ../../user/networks.nix
    ../../user/sops.nix
    ../../user/development/rust.nix
  ];

  users.users.julia = {
    isNormalUser = true;
    description = "Julia Mertz";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [];
  };

  services.getty.autologinUser = "julia";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.bash;

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
  };

  environment.systemPackages = with pkgs; [
    bat
    wget
    fzf
    alsa-lib
    wezterm
    kitty
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

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  users.extraUsers.julia.extraGroups = [ "audio" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "workstation"; 
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  }; 

  system.stateVersion = "24.05";
}
