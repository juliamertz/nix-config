{ pkgs, settings, ... }:
{
  imports = [ ./shared.nix ];

  users.users.${settings.user.username} = {
    description = settings.user.fullName;
    inherit (settings.user) home;
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "dr" ''
      #!${pkgs.bash}
      darwin-rebuild ''${1:-"switch"} --flake ''${2:-"."}
    '')
  ];
}
