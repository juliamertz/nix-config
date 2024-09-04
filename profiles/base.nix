{ pkgs, lib, settings, inputs, helpers, ... }:
let
  inherit (settings.user) username fullName;
  inherit (settings.system) platform hostname timeZone defaultLocale;
  inherit (helpers) isDarwin isLinux;

in {
  imports = [
    ../modules/lang/rust.nix
    ../modules/lang/sql.nix
    ../modules/lang/go.nix
    ../modules/lang/nix.nix
    ../modules/lang/lua.nix
  ] ++ lib.optionals isLinux [ ../modules/io/ssh.nix ]
    ++ lib.optionals isDarwin [ ../modules/homebrew.nix ];

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
    {
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "dr" ''
          #!${pkgs.bash}
          darwin-rebuild ''${1:-"switch"} --flake ''${2:-"."}
        '')
      ];
    } else {
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
        flake = "/home/${username}/nix";
      };

      system.stateVersion = "24.05";
    })
  ];
}
