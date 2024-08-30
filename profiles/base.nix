{ pkgs, lib, settings, inputs, helpers, ... }:
let
  inherit (settings.user) username fullName;
  inherit (settings.system) platform hostname timeZone defaultLocale;
in {
  imports = lib.optionals helpers.isLinux [
    ../modules/io/ssh.nix
    inputs.flake-programs-sqlite.nixosModules.programs-sqlite
  ];

  config = lib.mkMerge [
    # Shared
    {
      environment.systemPackages = with pkgs; [ openssl curl tldr zip unzip ];
      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      nixpkgs.hostPlatform = platform;
      networking.hostName = hostname;

      users.users.${username} = {
        description = fullName;
        home = settings.user.home;
      };
    }
    (if helpers.isDarwin then
    # Darwin
      { }
    else {
      # Nixos
      environment.systemPackages = with pkgs; [ xclip ];

      networking.firewall.enable = true;
      networking.networkmanager.enable = true;

      users.users.${username} = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
      };

      time.timeZone = timeZone;
      i18n.defaultLocale = defaultLocale;
      i18n.extraLocaleSettings = let locale = defaultLocale;
      in {
        LC_ADDRESS = locale;
        LC_IDENTIFICATION = locale;
        LC_MEASUREMENT = locale;
        LC_MONETARY = locale;
        LC_NAME = locale;
        LC_NUMERIC = locale;
        LC_PAPER = locale;
        LC_TELEPHONE = locale;
        LC_TIME = locale;
      };

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        flake = "/home/${username}/nix";
      };

      system.stateVersion = "24.05";
    })
  ];
}
