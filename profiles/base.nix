{ pkgs, lib, settings, inputs, helpers, ... }:
let
  inherit (settings.user) username fullName;
  inherit (settings.system) platform hostname timeZone defaultLocale;
  inherit (helpers) isDarwin isLinux;

  inherit (inputs.flake-programs-sqlite.nixosModules) programs-sqlite;
in {
  imports = [
    ../modules/lang/rust.nix
    ../modules/lang/sql.nix
    ../modules/lang/go.nix
    ../modules/lang/nix.nix
    ../modules/lang/lua.nix
  ] ++ lib.optionals isLinux [ ../modules/io/ssh.nix programs-sqlite ]
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
