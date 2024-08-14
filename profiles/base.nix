{ pkgs, settings, ... }:
let user = settings.user.username;
in {
  imports = [ ../modules/io/ssh.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = settings.system.hostname;
  networking.firewall.enable = true;
  networking.networkmanager.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    description = settings.user.fullName;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
  };

  time.timeZone = settings.system.timeZone;
  i18n.defaultLocale = settings.system.defaultLocale;
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/${user}/nix";
  };

  environment.systemPackages = with pkgs; [ openssl curl tldr xclip ];

  system.stateVersion = "24.05";
}
