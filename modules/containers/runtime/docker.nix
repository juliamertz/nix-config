{ lib, settings, ... }:
{
  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
      extraOptions =
        [
          # allow insecure access for local image registry
          "--insecure-registry=localhost:5000"
        ]
        |> lib.concatStringsSep " ";
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/298165
  networking.firewall.checkReversePath = false;

  users.users.${settings.user.username}.extraGroups = [ "docker" ];
}
