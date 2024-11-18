{
  inputs,
  helpers,
  settings,
  ...
}:
let
  inherit (settings.user) username;
  pkgs = helpers.getPkgs inputs.nixpkgs-unstable;
in
{
  virtualisation.libvirtd = {
    enable = true;
    package = pkgs.libvirt;
  };
  programs.virt-manager = {
    enable = true;
    package = pkgs.virt-manager;
  };

  users.users.${username} = {
    extraGroups = [ "libvirtd" ];
  };

  # dconf.settings = {
  #   "org/virt-manager/virt-manager/connections" = {
  #     autoconnect = ["qemu:///system"];
  #     uris = ["qemu:///system"];
  #   };
  # };
}
